using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Text;
using UnityEngine;
using XLua;

namespace GirlsWar
{
    public sealed class BattlePlayModeBootstrap : MonoBehaviour
    {
        public const string DefaultResultFileName = "BATTLE_90_PLAYMODE_BOOTSTRAP_RESULT.json";
        public const string RealAttackProbeResultFileName = "BATTLE_90_REAL_ATTACK_PROBE_RESULT.json";

        public static bool Completed { get; private set; }
        public static int LastExitCode { get; private set; } = 1;
        public static string LastStatus { get; private set; } = "";
        public static string ResultPath { get; private set; }

        private static int configuredFrameBudget = 240;
        private static bool configuredUseAttackTaskPreview = true;
        private const int CaptureWidth = 1280;
        private const int CaptureHeight = 720;

        [SerializeField] private int frameBudget = 240;

        private string firstLogException = "";
        private int errorLogCount;
        private Camera visualCamera;

        private const string SetupEnv = @"
            local NOOP = {}
            setmetatable(NOOP, {
              __index   = function(_, k) if type(k)=='number' then return nil end return NOOP end,
              __newindex= function() end,
              __call    = function() return NOOP end,
              __lt = function() return false end,
              __le = function() return false end,
              __add = function() return 0 end,  __sub = function() return 0 end,
              __mul = function() return 0 end,  __div = function() return 0 end,
              __mod = function() return 0 end,  __unm = function() return 0 end,
              __concat = function(a,b)
                  local function s(v) return (v==NOOP) and '' or tostring(v) end
                  return s(a)..s(b) end,
              __len = function() return 0 end,
              __tostring = function() return '' end,
            })
            _G.NOOP_STUB = NOOP
            rawset(_G, 'LuaUtils', {
              IsNull = function(v) return v == nil or v == NOOP end,
            })
            setmetatable(LuaUtils, { __index = function() return NOOP end })
            rawset(_G, 'IsNil', function(v) return v == nil or v == NOOP end)
            rawset(_G, 'WaitUntil', function() return nil end)
            local function logf() end
            for _,n in ipairs({'log','logerror','logwarn','logblue','loggreen','logyellow','logtable','logProto','logBattle'}) do
              rawset(_G, n, logf)
            end
            rawset(_G, 'BuildPatchMgr', {
              CheckCanUseRapidjson = function() return false end,
              CompareVersion = function() return 0 end,
            })
            rawset(_G, 'SaveMgr', {
              GetPlayerPrefsHasKey = function() return false end,
              GetBoolForKey   = function(_, d) if d == nil then return false end return d end,
              GetIntForKey    = function(_, d) if d == nil then return 0 end return d end,
              GetFloatForKey  = function(_, d) if d == nil then return 0 end return d end,
              GetStringForKey = function(_, d) if d == nil then return '' end return d end,
              SetBoolForKey   = function() end,
              SetIntForKey    = function() end,
              SetFloatForKey  = function() end,
              SetStringForKey = function() end,
              DeleteKey       = function() end,
            })
            setmetatable(_G, { __index = function(_, k) return NOOP end })
        ";

        public static void ConfigureForEditorRun(string resultPath, int frames)
        {
            ConfigureForEditorRun(resultPath, frames, true);
        }

        public static void ConfigureForEditorRun(string resultPath, int frames, bool useAttackTaskPreview)
        {
            ResultPath = resultPath;
            configuredFrameBudget = frames;
            configuredUseAttackTaskPreview = useAttackTaskPreview;
            Completed = false;
            LastExitCode = 1;
            LastStatus = "";
        }

        private void Awake()
        {
            frameBudget = configuredFrameBudget > 0 ? configuredFrameBudget : frameBudget;
            YouYou.GameEntry.Instance.CoroutineHost = this;
            YouYou.GameEntry.Procedure.ResetRuntimeState();
            YouYou.LuaHeroSprite.ResetOpenedSprites();
            BattleRuntimeSpineActorFactory.ResetDiagnostics();
            visualCamera = EnsureVisualStage();
            Application.logMessageReceived += OnLogMessage;
        }

        private void OnDestroy()
        {
            Application.logMessageReceived -= OnLogMessage;
            if (YouYou.GameEntry.Instance.CoroutineHost == this)
                YouYou.GameEntry.Instance.CoroutineHost = null;
        }

        private void Start()
        {
            StartCoroutine(Run());
        }

        private IEnumerator Run()
        {
            var result = new Result
            {
                generatedAt = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
                frameBudget = frameBudget,
                useAttackTaskPreview = configuredUseAttackTaskPreview,
                playModeEntered = Application.isPlaying,
                decodedLuaIndexCount = GirlsWarLuaLoader.IndexCount,
            };
            var stages = new List<string>();
            string failStage = "";
            string err = "";
            bool battleEntered = false;

            LuaEnv env = null;
            try
            {
                env = new LuaEnv();
                env.AddLoader((ref string p) => GirlsWarLuaLoader.Load(ref p));
                stages.Add("luaenv+loader");

                env.DoString(SetupEnv);
                env.Global.Set("BATTLE90_USE_ATTACK_TASK_PREVIEW", configuredUseAttackTaskPreview);
                env.Global.Set("BATTLE90_USE_FRAME_COROUTINES", !configuredUseAttackTaskPreview);
                LuaNoopHolder.Noop = env.Global.Get<LuaTable>("NOOP_STUB");
                stages.Add("permissive-_G");

                Safe(env, @"
                    rawset(_G, 'GameEntry', CS.YouYou.GameEntry)
                    pcall(require, 'Common/Class')
                    pcall(require, 'Common/StringUtil')
                    pcall(require, 'Common/TableUtil')",
                    stages, ref failStage, ref err, optional: true);

                Safe(env, @"
                    local ok,m = pcall(require, 'GameInit')
                    if ok and type(m)=='table' and type(rawget(_G,'GameInit'))~='table' then rawset(_G,'GameInit',m) end
                    if GameInit then rawset(GameInit,'IsClient',true); rawset(GameInit,'IsBattlePlayVerify',false) end",
                    stages, ref failStage, ref err, optional: true);

                Safe(env, @"
                    local gi = rawget(_G, 'GameInit')
                    assert(type(gi) == 'table', 'GameInit table missing before Common/Define')
                    local old_client = rawget(gi, 'IsClient')
                    rawset(gi, 'IsClient', false)
                    local ok, err = pcall(require, 'Common/Define')
                    rawset(gi, 'IsClient', old_client ~= nil and old_client or true)
                    rawset(gi, 'IsBattlePlayVerify', false)
                    assert(ok, 'Common/Define load failed: '..tostring(err))
                    rawset(_G, 'LuaUtils', {
                      IsNull = function(v) return v == nil or v == NOOP_STUB end,
                    })
                    setmetatable(LuaUtils, { __index = function() return NOOP_STUB end })
                    rawset(_G, 'IsNil', function(v) return v == nil or v == NOOP_STUB or LuaUtils.IsNull(v) end)
                    rawset(_G, 'BATTLE90_DEFINE_LOAD_OK', true)
                    rawset(_G, 'BATTLE90_ENUM_SNAPSHOT',
                      'skillSmall='..tostring(EBattleSkillAttackType and EBattleSkillAttackType.SmallSkillAttacking)..
                      '/skillEndPet='..tostring(EBattleSkillAttackType and EBattleSkillAttackType.SmallRoundEndPetHelpSkillAttacking)..
                      '/actionNormal='..tostring(EBattleActionType and EBattleActionType.NormalOrSmallSkill))",
                    stages, ref failStage, ref err);

                string[] globals =
                {
                    "JsonUtil", "GameTools", "GameInit", "CommonEventId",
                    "EventSystem", "ModulesInit", "PlayerMgr",
                };
                foreach (var g in globals)
                {
                    if (!string.IsNullOrEmpty(failStage)) break;
                    Safe(env,
                        $"local ok,m = pcall(require, '{g}'); " +
                        $"if ok and type(m)=='table' and type(rawget(_G,'{g}'))~='table' then rawset(_G,'{g}',m) end",
                        stages, ref failStage, ref err, optional: true);
                }

                Safe(env, @"
                    local NOOP = NOOP_STUB
                    for _,g in ipairs({'GameInit','EventSystem','ModulesInit','GameTools','PlayerMgr','CommonEventId','CameraMgr','FightLogMgr'}) do
                      local m = rawget(_G, g)
                      if type(m)=='table' then
                        local mt = getmetatable(m)
                        if mt == nil then
                          setmetatable(m, { __index = function() return NOOP end })
                        else
                          local orig = rawget(mt, '__index')
                          rawset(mt, '__index', function(t,k)
                            local v
                            if type(orig)=='function' then v = orig(t,k)
                            elseif orig ~= nil then v = orig[k] end
                            if v ~= nil then return v end
                            return NOOP
                          end)
                        end
                      end
                    end",
                    stages, ref failStage, ref err, optional: true);

                Safe(env, "PNB = require('ProcedureNormalBattle')", stages, ref failStage, ref err);

                if (string.IsNullOrEmpty(failStage))
                {
                    var payloadPath = Path.GetFullPath(Path.Combine(
                        Application.dataPath, "RestoreData", "battle", "BATTLE_TEST_PAYLOAD.json"));
                    result.payloadPath = payloadPath;
                    result.payloadExists = File.Exists(payloadPath);
                    env.Global.Set("BATTLE_TEST_JSON", result.payloadExists ? File.ReadAllText(payloadPath) : "");

                    Safe(env, @"
                        local data = JsonUtil and JsonUtil.decode and JsonUtil.decode(BATTLE_TEST_JSON) or nil
                        local info = data and data.battleInfo or data
                        assert(info, 'no battleInfo in payload')
                        BATTLE_PLAYMODE_INFO = info
                        rawset(_G, 'LuaUtils', {
                          IsNull = function(v) return v == nil or v == NOOP_STUB end,
                        })
                        setmetatable(LuaUtils, { __index = function() return NOOP_STUB end })
                        rawset(_G, 'IsNil', function(v) return v == nil or v == NOOP_STUB or LuaUtils.IsNull(v) end)
                        if GameInit then rawset(GameInit,'IsClient',true); rawset(GameInit,'IsBattlePlayVerify',false) end
                        if PlayerMgr and type(rawget(PlayerMgr,'PlayerInfo'))~='table' then
                          rawset(PlayerMgr, 'PlayerInfo', { uid = info.ourPlayerId or 0, head = 0, name = 'offline', level = 1 })
                        elseif PlayerMgr and PlayerMgr.PlayerInfo then
                          PlayerMgr.PlayerInfo.uid = PlayerMgr.PlayerInfo.uid or info.ourPlayerId or 0
                        end
                        if ModulesInit and PNB then rawset(ModulesInit, 'ProcedureNormalBattle', PNB) end
                        if ModulesInit then
                          rawset(ModulesInit, 'GuideMgr', setmetatable({
                            isGuide = false,
                            guideId = 0,
                            SpeacalId = { FirstBattleRedy = -101, ThreeBattleRedy = -102 },
                          }, { __index = function() return NOOP_STUB end }))
                          rawset(ModulesInit, 'TimeActionMgr', {
                            CreateTimeAction = function()
                              return {
                                Init = function(self, ...)
                                  self.callback = nil
                                  for i = select('#', ...), 1, -1 do
                                    local value = select(i, ...)
                                    if type(value) == 'function' then
                                      self.callback = value
                                      break
                                    end
                                  end
                                  return self
                                end,
                                Run = function(self)
                                  if type(self.callback) == 'function' then self.callback() end
                                  return self
                                end,
                              }
                            end,
                          })
                        end
                        do
                          local byId = {}
                          local function idx(list)
                            if type(list)=='table' then
                              for k=1,#list do local hh=list[k]; if hh and hh.heroId then byId[hh.heroId]=hh end end
                            end
                          end
                          idx(info.ourHeros); idx(info.enemyHeros)
                          if type(info.waveData)=='table' then for _,wv in ipairs(info.waveData) do idx(wv.enemyHeros) end end
                          rawset(_G,'HeroMgr', setmetatable({
                            GetHeroDataByHeroId = function(_, id) return byId[id] end,
                            GetHeroData         = function(_, id) return byId[id] end,
                            GetHeroServerDataWithHerosData = function(_, list, id)
                              if type(list)=='table' then
                                for k=1,#list do local hh=list[k]; if hh and hh.heroId == id then return hh end end
                              end
                              return byId[id]
                            end,
                          }, { __index = function() return NOOP_STUB end }))
                        end
                        if GameTools then
                          GameTools.GetLocalize = function(a) return type(a)=='string' and a or tostring(a) end
                          GameTools.ClientIsSupportIOLoad = function() return false end
                          GameTools.SwitchBGMFadeOutLua = function() end
                          GameTools.SwitchBGMFadeOut = function() end
                          GameTools.SetTimeScale = function() end
                        end
                        rawset(_G, 'WaitUntil', function(predicate)
                          local count = rawget(_G, 'BATTLE90_WAIT_UNTIL_NOOP_COUNT')
                          if type(count) ~= 'number' then count = 0 end
                          rawset(_G, 'BATTLE90_WAIT_UNTIL_NOOP_COUNT', count + 1)
                          if rawget(_G, 'BATTLE90_USE_FRAME_COROUTINES') == true and type(predicate) == 'function' then
                            return { __battle90_wait_until = true, predicate = predicate, frames = 0 }
                          end
                          return nil
                        end)
                        for _, mod in pairs(package.loaded) do
                          if type(mod)=='table' and rawget(mod,'isLoadIO')==true then rawset(mod,'isLoadIO', false) end
                        end
                        if PNB then
                          PNB.IsOpenPlayMusic = false
                          PNB.IsOpenBattleBeginAnim = false
                          PNB.mBattleRunInMode = EBattleRunInMode and EBattleRunInMode.None or 0
                          PNB.FightPlayData = info
                          PNB.IsFightPlay = true
                          local function make_station_setting(prefix)
                            local rootGo = CS.UnityEngine.GameObject(prefix .. '_Root')
                            local root = rootGo.transform
                            local stations = {}
                            local is_our = string.find(prefix, 'Our') ~= nil
                            local xs = is_our and {-4.2, -2.8, -1.4, -3.6, -2.2, -0.8} or {4.2, 2.8, 1.4, 3.6, 2.2, 0.8}
                            local ys = {-0.9, -0.45, -1.35, -1.85, -1.4, -2.3}
                            for idx=0,5 do
                              local go = CS.UnityEngine.GameObject(prefix .. '_Station_' .. tostring(idx))
                              go.transform:SetParent(root, false)
                              go.transform.localPosition = CS.UnityEngine.Vector3(xs[idx + 1] or 0, ys[idx + 1] or 0, 0)
                              stations[idx] = go.transform
                            end
                            return {
                              Root = root,
                              GetBattleStationByIndex = function(_, idx)
                                idx = tonumber(idx) or 0
                                return stations[idx] or root
                              end
                            }
                          end
                          PNB.OurTeamSetting = PNB.OurTeamSetting or make_station_setting('B90_Our')
                          PNB.EnemyTeamSetting = PNB.EnemyTeamSetting or make_station_setting('B90_Enemy')
                          PNB.BattleCenterTransform = PNB.BattleCenterTransform or CS.UnityEngine.GameObject('B90_BattleCenter').transform
                          PNB.OurCenterTransform = PNB.OurCenterTransform or CS.UnityEngine.GameObject('B90_OurCenter').transform
                          PNB.EnemyCenterTransform = PNB.EnemyCenterTransform or CS.UnityEngine.GameObject('B90_EnemyCenter').transform
                        end
                        do
                          local function inc_global(name)
                            local value = rawget(_G, name)
                            if type(value) ~= 'number' then value = 0 end
                            rawset(_G, name, value + 1)
                          end
                          do
                            local ok_co, co = pcall(require, 'Common/cs_coroutine')
                            if ok_co and type(co) == 'table' and not rawget(co, '__battle90_inline_runner') then
                              local function is_wait_until_token(value)
                                return type(value) == 'table' and rawget(value, '__battle90_wait_until') == true
                              end
                              if rawget(_G, 'BATTLE90_USE_FRAME_COROUTINES') == true then
                                local tasks = rawget(_G, 'BATTLE90_COROUTINE_TASKS')
                                if type(tasks) ~= 'table' then
                                  tasks = {}
                                  rawset(_G, 'BATTLE90_COROUTINE_TASKS', tasks)
                                end
                                local function append_label(name, label)
                                  label = tostring(label or '?')
                                  local current = rawget(_G, name)
                                  if type(current) ~= 'string' then current = '' end
                                  if string.len(current) < 900 then
                                    if current ~= '' then current = current .. '|' end
                                    rawset(_G, name, current .. label)
                                  end
                                end
                                local function caller_label()
                                  local info = debug and debug.getinfo and debug.getinfo(3, 'Sl') or nil
                                  if type(info) == 'table' then
                                    return tostring(info.short_src or info.source or '?') .. ':' .. tostring(info.currentline or 0)
                                  end
                                  return '?'
                                end
                                local next_id = rawget(_G, 'BATTLE90_COROUTINE_NEXT_ID')
                                if type(next_id) ~= 'number' then next_id = 0 end
                                local function resume_task(task)
                                  if type(task) ~= 'table' or task.done == true then return end
                                  if type(task.waitUntil) == 'table' then
                                    task.waitUntil.frames = (tonumber(task.waitUntil.frames) or 0) + 1
                                    inc_global('BATTLE90_WAIT_UNTIL_POLL_COUNT')
                                    local ok, ready = pcall(task.waitUntil.predicate)
                                    if not ok then error(ready) end
                                    if ready == true then
                                      inc_global('BATTLE90_WAIT_UNTIL_READY_COUNT')
                                      task.waitUntil = nil
                                    else
                                      return
                                    end
                                  end
                                  if type(task.frameDelay) == 'number' and task.frameDelay > 0 then
                                    task.frameDelay = task.frameDelay - 1
                                    return
                                  end
                                  local ok, yielded = coroutine.resume(task.thread)
                                  inc_global('BATTLE90_COROUTINE_FRAME_RESUME_COUNT')
                                  if not ok then error(yielded) end
                                  if coroutine.status(task.thread) == 'dead' then
                                    task.done = true
                                    inc_global('BATTLE90_COROUTINE_FRAME_DONE_COUNT')
                                    append_label('BATTLE90_COROUTINE_DONE_LABELS', task.label)
                                    return
                                  end
                                  if is_wait_until_token(yielded) then
                                    task.waitUntil = yielded
                                  elseif yielded ~= nil then
                                    task.frameDelay = 1
                                    inc_global('BATTLE90_COROUTINE_FRAME_YIELD_COUNT')
                                  end
                                end
                                co.start = function(fn)
                                  inc_global('BATTLE90_COROUTINE_FRAME_START_COUNT')
                                  if type(fn) ~= 'function' then return nil end
                                  next_id = next_id + 1
                                  rawset(_G, 'BATTLE90_COROUTINE_NEXT_ID', next_id)
                                  local label = caller_label()
                                  local task = { id = next_id, label = label, thread = coroutine.create(fn), done = false, frameDelay = 0 }
                                  table.insert(tasks, task)
                                  append_label('BATTLE90_COROUTINE_START_LABELS', label)
                                  return task
                                end
                                co.stop = function(task)
                                  if type(task) == 'table' then
                                    task.done = true
                                    inc_global('BATTLE90_COROUTINE_FRAME_STOP_COUNT')
                                    append_label('BATTLE90_COROUTINE_STOP_LABELS', task.label)
                                  end
                                end
                                rawset(_G, 'BATTLE90_PUMP_COROUTINES', function(max_steps)
                                  max_steps = tonumber(max_steps) or 64
                                  local steps = 0
                                  local pending = 0
                                  for idx = 1, #tasks do
                                    local task = tasks[idx]
                                    if type(task) == 'table' and task.done ~= true then
                                      pending = pending + 1
                                      if steps < max_steps then
                                        resume_task(task)
                                        steps = steps + 1
                                      end
                                    end
                                  end
                                  rawset(_G, 'BATTLE90_COROUTINE_PENDING_COUNT', pending)
                                  rawset(_G, 'BATTLE90_COROUTINE_LAST_PUMP_STEPS', steps)
                                end)
                              else
                                co.start = function(fn)
                                  inc_global('BATTLE90_COROUTINE_INLINE_COUNT')
                                  if type(fn) ~= 'function' then return nil end
                                  local thread = coroutine.create(fn)
                                  local guard = 0
                                  while coroutine.status(thread) ~= 'dead' do
                                    guard = guard + 1
                                    if guard > 512 then error('BATTLE90 inline coroutine guard exceeded') end
                                    local ok, message = coroutine.resume(thread)
                                    if not ok then error(message) end
                                  end
                                  return thread
                                end
                                co.stop = function() end
                              end
                              rawset(co, '__battle90_inline_runner', true)
                            end
                          end
                          local function wrap_monster_model(model, label)
                            if type(model) ~= 'table' or type(model.GetEntity) ~= 'function' or rawget(model, '__battle90_base_fallback') then
                              return model
                            end
                            local orig = model.GetEntity
                            model.GetEntity = function(self_or_id, maybe_id)
                              local colon = maybe_id ~= nil
                              local id = colon and maybe_id or self_or_id
                              local row = colon and orig(self_or_id, id) or orig(id)
                              if row == nil and type(id) == 'number' then
                                local candidates = {}
                                local last_digit_base = id - (id % 10)
                                if last_digit_base ~= id then table.insert(candidates, last_digit_base) end
                                local stage_base = math.floor(id / 100) * 100 + 10
                                if stage_base ~= id and stage_base ~= last_digit_base then table.insert(candidates, stage_base) end
                                for _, base in ipairs(candidates) do
                                  row = colon and orig(self_or_id, base) or orig(base)
                                  if row ~= nil then
                                    inc_global('BATTLE90_MONSTER_BASE_FALLBACK_COUNT')
                                    rawset(_G, 'BATTLE90_MONSTER_BASE_FALLBACK_LAST', tostring(label)..':'..tostring(id)..'->'..tostring(base))
                                    break
                                  end
                                end
                              end
                              return row
                            end
                            rawset(model, '__battle90_base_fallback', true)
                            return model
                          end
                          if PNB and type(PNB.GetMonsterCfgData) == 'function' and not rawget(PNB, '__battle90_monster_cfg_patch') then
                            local orig_cfg = PNB.GetMonsterCfgData
                            PNB.GetMonsterCfgData = function(...)
                              return wrap_monster_model(orig_cfg(...), 'cfg')
                            end
                            rawset(PNB, '__battle90_monster_cfg_patch', true)
                          end
                          if PNB and type(PNB.GetMonsterAttrCfgData) == 'function' and not rawget(PNB, '__battle90_monster_attr_patch') then
                            local orig_attr = PNB.GetMonsterAttrCfgData
                            PNB.GetMonsterAttrCfgData = function(...)
                              return wrap_monster_model(orig_attr(...), 'attr')
                            end
                            rawset(PNB, '__battle90_monster_attr_patch', true)
                          end
                          if type(HeroCtrl) == 'table' and not rawget(HeroCtrl, '__battle90_skin_patch') then
                            HeroCtrl.LoadPet = function(self)
                              if PNB and PNB.IsSkipBattle == true then return end
                              if not self.PetRoot and self.transform then self.PetRoot = self.transform:Find('PetRoot') end
                              if self.PetRoot then
                                local go = CS.UnityEngine.GameObject('B90_Pet_' .. tostring(self.HeroId))
                                self.CurrPetTransform = go.transform
                                self.CurrPetTransform:SetParent(self.PetRoot, false)
                              end
                              inc_global('BATTLE90_PET_STUB_COUNT')
                            end
                            HeroCtrl.LoadSkin = function(self, prefab_id, enter_battle)
                              if PNB and PNB.IsSkipBattle == true then return end
                              if not self.HeroRoot and self.transform then self.HeroRoot = self.transform:Find('HeroRoot') end
                              local root = self.HeroRoot or self.transform
                              local hero_id = tonumber(self.HeroId) or 0
                              local hero_did = tonumber(self.heroDid) or tonumber(self.BaseHeroID) or hero_id
                              local actor = CS.GirlsWar.BattleRuntimeSpineActorFactory.AttachActor(
                                hero_id,
                                hero_did,
                                root,
                                self.IsOurHero == true,
                                self.IsMonster == true or hero_id < 0,
                                prefab_id)
                              self.CurrSkinTransform = actor.Transform
                              self.CurrMeshRenderer = actor.MeshRenderer
                              self.spineboy = actor.SkeletonAnimation or NOOP_STUB
                              self.spineboyTransform = self.CurrSkinTransform
                              self.topBone = NOOP_STUB
                              self.pointBone = NOOP_STUB
                              if actor.SkeletonAnimation then
                                pcall(function()
                                  self.topBone = actor.SkeletonAnimation.skeleton:FindBone('top') or NOOP_STUB
                                  self.pointBone = actor.SkeletonAnimation.skeleton:FindBone('point') or NOOP_STUB
                                end)
                              end
                              self.Ready = true
                              self.mIsEnterBattle = true
                              if self.CurrFsm and self.CurrFsm.ParamDic then
                                self.CurrFsm.ParamDic['changeToIdleType'] = ChangeToIdleType and ChangeToIdleType.NormalIdle or 0
                              end
                              if HeroState and type(self.ChangeStateUnCheckState) == 'function' then
                                pcall(function() self:ChangeStateUnCheckState(HeroState.Idle) end)
                              end
                              inc_global('BATTLE90_SKIN_RUNTIME_COUNT')
                              if actor.IsSpineActor then inc_global('BATTLE90_SKIN_SPINE_COUNT') else inc_global('BATTLE90_SKIN_QUAD_FALLBACK_COUNT') end
                              if not actor.IsExactActor then inc_global('BATTLE90_SKIN_VISUAL_FALLBACK_COUNT') end
                              rawset(_G, 'BATTLE90_SKIN_LAST_ACTOR', tostring(hero_did)..'/'..tostring(hero_id)..'->'..tostring(actor.ResolvedActorId)..':'..tostring(actor.FallbackReason))
                            end
                            rawset(HeroCtrl, '__battle90_skin_patch', true)
                          end
                          if PNB and type(PNB.FirstBattleTeamReady) == 'function' and not rawget(PNB, '__battle90_first_ready_patch') then
                            PNB.FirstBattleTeamReady = function(...)
                              inc_global('BATTLE90_FIRST_READY_SHORTCUT_COUNT')
                              PNB.IsOpenBattleBeginAnim = false
                              PNB.mBattleRunInMode = EBattleRunInMode and EBattleRunInMode.None or 0
                              if type(PNB.AfterBattleTeamReady) == 'function' then
                                return PNB.AfterBattleTeamReady(...)
                              end
                            end
                            rawset(PNB, '__battle90_first_ready_patch', true)
                          end
                          if PNB and type(PNB.BattleRoundBeginAddBuffComplete) == 'function' and not rawget(PNB, '__battle90_begin_buff_patch') then
                            PNB.BattleRoundBeginAddBuff = function(...)
                              inc_global('BATTLE90_BEGIN_BUFF_SHORTCUT_COUNT')
                              return PNB.BattleRoundBeginAddBuffComplete(...)
                            end
                            rawset(PNB, '__battle90_begin_buff_patch', true)
                          end
                          if rawget(_G, 'BATTLE90_USE_ATTACK_TASK_PREVIEW') == true
                            and PNB and type(PNB.BattleBigRoundBegin) == 'function'
                            and not rawget(PNB, '__battle90_all_big_round_patch') then
                            PNB.BattleAllBigRoundBegin = function(...)
                              inc_global('BATTLE90_ALL_BIG_ROUND_SHORTCUT_COUNT')
                              if type(PNB.RefreshHeroHud) == 'function' then pcall(PNB.RefreshHeroHud) end
                              PNB.IsBattleBigAttacking = true
                              return PNB.BattleBigRoundBegin(...)
                            end
                            rawset(PNB, '__battle90_all_big_round_patch', true)
                          end
                          if rawget(_G, 'BATTLE90_USE_ATTACK_TASK_PREVIEW') == true
                            and PNB and type(PNB.BattleRoundExplosive) == 'function'
                            and not rawget(PNB, '__battle90_small_round_patch') then
                            PNB.BattleSmallRoundBegin = function(...)
                              inc_global('BATTLE90_SMALL_ROUND_SHORTCUT_COUNT')
                              local round = rawget(PNB, 'CurrBattleSmallRound')
                              if type(round) ~= 'number' then round = 0 end
                              PNB.CurrBattleSmallRound = round + 1
                              PNB.IsBattleSmallAttacking = true
                              return PNB.BattleRoundExplosive(...)
                            end
                            rawset(PNB, '__battle90_small_round_patch', true)
                          end
                          if rawget(_G, 'BATTLE90_USE_ATTACK_TASK_PREVIEW') == true
                            and PNB and type(PNB.BattleRoundEndCheckBuff) == 'function'
                            and not rawget(PNB, '__battle90_attack_task_patch') then
                            PNB.StartAttackTask = function(...)
                              local shortcut_count = rawget(_G, 'BATTLE90_ATTACK_TASK_SHORTCUT_COUNT')
                              if type(shortcut_count) ~= 'number' then shortcut_count = 0 end
                              if shortcut_count >= 12 then
                                inc_global('BATTLE90_ATTACK_TASK_GUARD_COUNT')
                                PNB.CurrIsAttacking = false
                                PNB.IsBattleSmallAttacking = false
                                PNB.IsBattleBigAttacking = false
                                PNB.BattleRounding = false
                                return
                              end
                              rawset(_G, 'BATTLE90_ATTACK_TASK_SHORTCUT_COUNT', shortcut_count + 1)
                              local team = PNB.CurrAttackTeam
                              if team and type(team.GetFightAction) == 'function' then
                                local ok_actions, actions = pcall(function() return team:GetFightAction() end)
                                if ok_actions and type(actions) == 'table' then
                                  local count = rawget(_G, 'BATTLE90_ATTACK_ACTION_COUNT')
                                  if type(count) ~= 'number' then count = 0 end
                                  rawset(_G, 'BATTLE90_ATTACK_ACTION_COUNT', count + #actions)
                                  for _, action in ipairs(actions) do
                                    local hero_id = tonumber(action.heroId) or 0
                                    local action_type = tonumber(action.actionType) or 0
                                    local fire_hero_id = tonumber(action.fireHeroId) or 0
                                    local skill_did = tonumber(action.skillDid) or 0
                                    if CS.GirlsWar.BattleRuntimeSpineActorFactory.PreviewAction(hero_id, action_type, fire_hero_id, skill_did) then
                                      inc_global('BATTLE90_ATTACK_PREVIEW_ACTION_COUNT')
                                    else
                                      inc_global('BATTLE90_ATTACK_PREVIEW_MISS_COUNT')
                                    end
                                  end
                                end
                              end
                              PNB.CurrIsAttacking = false
                              PNB.BattleRounding = false
                              return PNB.BattleRoundEndCheckBuff()
                            end
                            rawset(PNB, '__battle90_attack_task_patch', true)
                          end
                          local function wrap_method(tbl, name, counter, before)
                            if type(tbl) ~= 'table' or type(tbl[name]) ~= 'function' then return end
                            local flag = '__battle90_probe_wrap_' .. tostring(name) .. '_' .. tostring(counter)
                            if rawget(tbl, flag) then return end
                            local orig = tbl[name]
                            tbl[name] = function(...)
                              inc_global(counter)
                              if type(before) == 'function' then before(...) end
                              return orig(...)
                            end
                            rawset(tbl, flag, true)
                          end
                          local function wrap_attack_mgr()
                            local mgr = PNB and rawget(PNB, 'AttackTaskMgr')
                            if type(mgr) ~= 'table' or rawget(mgr, '__battle90_probe_wrapped') then return end
                            wrap_method(mgr, 'AddTask', 'BATTLE90_ATTACK_MGR_ADD_TASK_COUNT')
                            wrap_method(mgr, 'CheckStartTask', 'BATTLE90_ATTACK_MGR_CHECK_START_COUNT')
                            wrap_method(mgr, 'CheckExcuteNextTask', 'BATTLE90_ATTACK_MGR_CHECK_NEXT_COUNT')
                            wrap_method(mgr, 'ExcuteNextTask', 'BATTLE90_ATTACK_MGR_EXECUTE_NEXT_COUNT')
                            wrap_method(mgr, 'ExcuteTask', 'BATTLE90_ATTACK_MGR_EXECUTE_TASK_COUNT')
                            wrap_method(mgr, 'ExcuteBigTask', 'BATTLE90_ATTACK_MGR_EXECUTE_BIG_COUNT')
                            wrap_method(mgr, 'ExcuteNormalTask', 'BATTLE90_ATTACK_MGR_EXECUTE_NORMAL_COUNT')
                            wrap_method(mgr, 'ExcutePetFightTask', 'BATTLE90_ATTACK_MGR_EXECUTE_PET_COUNT')
                            wrap_method(mgr, 'HandleTaskComplete', 'BATTLE90_ATTACK_MGR_TASK_COMPLETE_COUNT')
                            wrap_method(mgr, 'AllTaskComplete', 'BATTLE90_ATTACK_MGR_ALL_COMPLETE_COUNT')
                            rawset(mgr, '__battle90_probe_wrapped', true)
                          end
                          if PNB and not rawget(PNB, '__battle90_real_attack_probe_wrap') then
                            local function skill_state()
                              if PNB and type(PNB.GetSkillAttackType) == 'function' then
                                local ok, value = pcall(function() return PNB.GetSkillAttackType() end)
                                if ok then return tostring(value) end
                              end
                              return tostring(PNB and rawget(PNB, 'CurrSkillAttackType'))
                            end
                            local function task_summary(task)
                              if type(task) ~= 'table' then return tostring(task) end
                              return 'hero='..tostring(task.heroId)..'/action='..tostring(task.actionType)..'/skill='..tostring(task.skillDid)
                            end
                            wrap_method(PNB, 'StartAttackTask', 'BATTLE90_PNB_START_ATTACK_TASK_COUNT', function(a, i)
                              rawset(_G, 'BATTLE90_START_ATTACK_LAST_ARGS', 'a='..tostring(a)..' i='..tostring(i)..' skill='..skill_state())
                              wrap_attack_mgr()
                            end)
                            wrap_method(PNB, 'AddAttackTask', 'BATTLE90_PNB_ADD_ATTACK_TASK_COUNT', wrap_attack_mgr)
                            wrap_method(PNB, 'CheckStartTask', 'BATTLE90_PNB_CHECK_START_TASK_COUNT', wrap_attack_mgr)
                            wrap_method(PNB, 'HandleAttackTaskComplete', 'BATTLE90_PNB_ATTACK_TASK_COMPLETE_COUNT', wrap_attack_mgr)
                            if type(PNB.GetAttackTask) == 'function' and not rawget(PNB, '__battle90_probe_get_attack_task') then
                              local orig_get_attack_task = PNB.GetAttackTask
                              PNB.GetAttackTask = function(...)
                                inc_global('BATTLE90_PNB_GET_ATTACK_TASK_COUNT')
                                local manual, task = orig_get_attack_task(...)
                                if task == nil then inc_global('BATTLE90_PNB_GET_ATTACK_TASK_NIL_COUNT') end
                                rawset(_G, 'BATTLE90_PNB_GET_ATTACK_TASK_LAST', 'manual='..tostring(manual)..' task='..task_summary(task)..' skill='..skill_state())
                                return manual, task
                              end
                              rawset(PNB, '__battle90_probe_get_attack_task', true)
                            end
                            rawset(PNB, '__battle90_real_attack_probe_wrap', true)
                          end
                          if BattleTeam and type(BattleTeam) == 'table' and not rawget(BattleTeam, '__battle90_real_attack_probe_wrap') then
                            if type(BattleTeam.GetTotalFirstValueWithRate) == 'function' and not rawget(BattleTeam, '__battle90_first_value_guard') then
                              local orig_get_total_first = BattleTeam.GetTotalFirstValueWithRate
                              BattleTeam.GetTotalFirstValueWithRate = function(self, ...)
                                if type(self) == 'table' then
                                  if type(rawget(self, 'TotalFirstValue')) ~= 'number' then
                                    rawset(self, 'TotalFirstValue', 0)
                                    inc_global('BATTLE90_FIRST_VALUE_DEFAULT_COUNT')
                                  end
                                  if type(rawget(self, 'mFirstAddRate')) ~= 'number' then
                                    rawset(self, 'mFirstAddRate', 0)
                                    inc_global('BATTLE90_FIRST_RATE_DEFAULT_COUNT')
                                  end
                                end
                                return orig_get_total_first(self, ...)
                              end
                              rawset(BattleTeam, '__battle90_first_value_guard', true)
                            end
                            wrap_method(BattleTeam, 'BeginHeroBigAttack_FightPlay', 'BATTLE90_TEAM_BEGIN_BIG_FIGHTPLAY_COUNT')
                            wrap_method(BattleTeam, 'BeginHeroNormalAttack_FightPlay', 'BATTLE90_TEAM_BEGIN_NORMAL_FIGHTPLAY_COUNT')
                            wrap_method(BattleTeam, 'BeginAttackTask', 'BATTLE90_TEAM_BEGIN_ATTACK_TASK_COUNT', function(self, a, i)
                              rawset(_G, 'BATTLE90_TEAM_BEGIN_ATTACK_LAST_ARGS', 'a='..tostring(a)..' i='..tostring(i)..' team='..tostring(type(self)=='table' and rawget(self,'TeamId')))
                            end)
                            wrap_method(BattleTeam, 'GetFightAction', 'BATTLE90_TEAM_GET_FIGHT_ACTION_COUNT')
                            wrap_method(BattleTeam, 'GetFightActionWithType', 'BATTLE90_TEAM_GET_FIGHT_ACTION_WITH_TYPE_COUNT')
                            wrap_method(BattleTeam, 'GetBigAttackTaskFightPlay', 'BATTLE90_TEAM_GET_BIG_FIGHTPLAY_TASK_COUNT')
                            wrap_method(BattleTeam, 'GetNormalAttackTaskFightPlay', 'BATTLE90_TEAM_GET_NORMAL_FIGHTPLAY_TASK_COUNT')
                            rawset(BattleTeam, '__battle90_real_attack_probe_wrap', true)
                          end
                          if HeroCtrl and type(HeroCtrl) == 'table' and not rawget(HeroCtrl, '__battle90_real_attack_probe_wrap') then
                            if not rawget(HeroCtrl, '__battle90_spine_invisible_guard') then
                              HeroCtrl.SetSpineInvisible = function()
                                inc_global('BATTLE90_SPINE_INVISIBLE_GUARD_COUNT')
                              end
                              HeroCtrl.SetSpineAnimation = function()
                                inc_global('BATTLE90_SPINE_ANIMATION_GUARD_COUNT')
                                return nil
                              end
                              HeroCtrl.AddSpineAnimation = function()
                                inc_global('BATTLE90_SPINE_ANIMATION_GUARD_COUNT')
                                return nil
                              end
                              rawset(HeroCtrl, '__battle90_spine_invisible_guard', true)
                            end
                            if type(HeroCtrl.CheckInAttackCommandQueue) == 'function' and not rawget(HeroCtrl, '__battle90_attack_queue_guard') then
                              local orig_check_attack_queue = HeroCtrl.CheckInAttackCommandQueue
                              HeroCtrl.CheckInAttackCommandQueue = function(self, ...)
                                local team = type(self) == 'table' and rawget(self, 'CurrBattleTeam') or nil
                                local queue = type(team) == 'table' and rawget(team, 'SmallSkillAttackQueue') or nil
                                if type(queue) ~= 'table'
                                  or type(rawget(queue, 'first')) ~= 'number'
                                  or type(rawget(queue, 'last')) ~= 'number' then
                                  inc_global('BATTLE90_ATTACK_QUEUE_GUARD_COUNT')
                                  return false
                                end
                                return orig_check_attack_queue(self, ...)
                              end
                              rawset(HeroCtrl, '__battle90_attack_queue_guard', true)
                            end
                            local function hero_id_of(hero)
                              if type(hero) ~= 'table' then return 0 end
                              return tonumber(rawget(hero, 'HeroId') or rawget(hero, 'HeroID') or rawget(hero, 'heroId') or rawget(hero, 'Heroid') or 0) or 0
                            end
                            local function skill_id_of(action)
                              if type(action) ~= 'table' then return 0 end
                              return tonumber(action.skillDid or action.SkillDid or 0) or 0
                            end
                            local function preview(counter, action_type)
                              return function(hero, action)
                                local hero_id = hero_id_of(hero)
                                local skill_id = skill_id_of(action)
                                if hero_id ~= 0 and CS.GirlsWar.BattleRuntimeSpineActorFactory.PreviewAction(hero_id, action_type, 0, skill_id) then
                                  inc_global('BATTLE90_REAL_ATTACK_PREVIEW_ACTION_COUNT')
                                else
                                  inc_global('BATTLE90_REAL_ATTACK_PREVIEW_MISS_COUNT')
                                end
                              end
                            end
                            wrap_method(HeroCtrl, 'BigAttack', 'BATTLE90_HERO_BIG_ATTACK_COUNT', preview('BATTLE90_HERO_BIG_ATTACK_COUNT', 1))
                            wrap_method(HeroCtrl, 'NormalAttack', 'BATTLE90_HERO_NORMAL_ATTACK_COUNT', preview('BATTLE90_HERO_NORMAL_ATTACK_COUNT', 2))
                            wrap_method(HeroCtrl, 'PetFightAttack', 'BATTLE90_HERO_PET_ATTACK_COUNT', preview('BATTLE90_HERO_PET_ATTACK_COUNT', 4))
                            wrap_method(HeroCtrl, 'Explosive', 'BATTLE90_HERO_EXPLOSIVE_COUNT', preview('BATTLE90_HERO_EXPLOSIVE_COUNT', 3))
                            wrap_method(HeroCtrl, 'ExplosiveAfter', 'BATTLE90_HERO_EXPLOSIVE_AFTER_COUNT')
                            wrap_method(HeroCtrl, 'ExplosiveAfter2', 'BATTLE90_HERO_EXPLOSIVE_AFTER2_COUNT')
                            rawset(HeroCtrl, '__battle90_real_attack_probe_wrap', true)
                          end
                        end
                        TRACE = ''
                        CNT = {}
                        local function wrap(name)
                          local orig = rawget(PNB, name)
                          PNB[name] = function(...)
                            CNT[name] = (CNT[name] or 0) + 1
                            if CNT[name] <= 4 then TRACE = TRACE .. name .. ';' end
                            if type(orig)=='function' then return orig(...) end
                          end
                        end
                        for _,n in ipairs({'ProcedureNormalBattle_OnEnter','LoadPlayerHeros','LoadEnemyPlayerHeros',
                          'LoadPlayerHero','OnBattleTeamReady','FirstBattleTeamReady','AfterBattleTeamReady',
                          'CheckBattleBegin','BattleBegin','CheckFirstAttackTeam','CheckRelic','BattleFightSuppress',
                          'BattleRoundBeginAddTreasure','BattleRoundBeginAddBuff','BattleRoundBeginAddBuffComplete',
                          'BattleAllBigRoundBegin','BattleBigRoundBegin','BattleSmallRoundBegin',
                          'BattleRoundCheckResurgence','BattleRoundCheckResurgenceComplete','SupplementPositionComplete',
                          'BattleRoundBeginAddAfterBuff','BattleRoundBeginCheckBuff','CheckIsOurTeamAtkAfterBattleRoundBeginCheckBuff',
                          'BattleRoundBeginChangeToIdle','BattleRoundExplosive','BattleRoundExplosiveComplete',
                          'SmallRoundStartTeamAttack','SmallRoundStartTeamAttackComplete','BattleRoundBigSkill',
                          'BattleRoundNormalSkill','StartAttackTask','BattleRoundEndCheckBuff',
                          'BattleRoundEndCheckBuffComplete','BattleSmallRoundEnd','BattleBigRoundEnd',
                          'FinalBattleEnd'}) do wrap(n) end",
                        stages, ref failStage, ref err);
                }

                if (string.IsNullOrEmpty(failStage))
                {
                    Safe(env, "assert(PNB and PNB.PlayFightClientReplay, 'no PlayFightClientReplay'); PNB.PlayFightClientReplay(BATTLE_PLAYMODE_INFO)",
                        stages, ref failStage, ref err);
                    result.changeStateCount = YouYou.GameEntry.Procedure.ChangeStateCount;
                    result.lastRequestedState = YouYou.GameEntry.Procedure.LastRequestedState != null
                        ? YouYou.GameEntry.Procedure.LastRequestedState.ToString()
                        : "";
                }

                if (string.IsNullOrEmpty(failStage))
                {
                    Safe(env, @"
                        local fn = PNB and (PNB.ProcedureNormalBattle_OnEnter or PNB.OnEnter)
                        assert(fn, 'no OnEnter on ProcedureNormalBattle')
                        fn(PNB.FightPlayData)",
                        stages, ref failStage, ref err);
                    battleEntered = string.IsNullOrEmpty(failStage);
                }

                if (string.IsNullOrEmpty(failStage))
                {
                    MaterializeOpenedHeroSprites(env, stages, ref failStage, ref err);
                }

            }
            catch (Exception e)
            {
                if (string.IsNullOrEmpty(failStage))
                {
                    failStage = "bootstrap";
                    err = e.GetType().Name + ": " + e.Message;
                }
            }

            for (int frame = 0; frame < frameBudget && string.IsNullOrEmpty(failStage); frame++)
            {
                result.framesPumped = frame + 1;
                PumpFrame(env, ref failStage, ref err);
                try { env?.Tick(); } catch (Exception e) { failStage = "LuaEnv.Tick"; err = e.Message; }
                yield return null;
            }

            TryReadLuaDiagnostics(env, result);
            CollectVisualDiagnostics(result, visualCamera);
            CaptureVisualEvidence(result, visualCamera);
            AppendVisualDiagnostics(result);
            try { env?.Dispose(); } catch { }

            result.stagesCompleted = stages;
            result.battleEntered = battleEntered;
            result.failedStage = Scrub(failStage);
            result.error = Scrub(err);
            result.errorLogCount = errorLogCount;
            result.firstLogException = Scrub(firstLogException);

            if (!string.IsNullOrEmpty(failStage))
                result.status = "playmode_bootstrap_blocked";
            else if (!string.IsNullOrEmpty(firstLogException))
                result.status = "playmode_bootstrap_runtime_log_exception";
            else if (battleEntered)
                result.status = "playmode_bootstrap_entered_battle";
            else
                result.status = "playmode_bootstrap_no_battle_entry";

            WriteResult(result);
            LastStatus = result.status;
            LastExitCode = result.status == "playmode_bootstrap_entered_battle" ? 0 : 1;
            Completed = true;
        }

        private void OnLogMessage(string condition, string stackTrace, LogType type)
        {
            if (type != LogType.Exception && type != LogType.Error && type != LogType.Assert)
                return;

            if ((stackTrace ?? "").Contains("UnityEditor.Search.SearchDatabase"))
                return;

            errorLogCount++;
            if (string.IsNullOrEmpty(firstLogException))
                firstLogException = condition + " " + stackTrace;
        }

        private static void TryReadLuaDiagnostics(LuaEnv env, Result result)
        {
            if (env == null) return;
            try { result.trace = env.Global.Get<string>("TRACE") ?? ""; } catch { }
            try
            {
                env.DoString(@"
                    if PNB then
                      rawset(_G, 'BATTLE90_CURR_SMALL_ROUND', tonumber(rawget(PNB,'CurrBattleSmallRound')) or 0)
                      rawset(_G, 'BATTLE90_CURR_BIG_ROUND', tonumber(rawget(PNB,'CurrBattleBigRound')) or 0)
                      rawset(_G, 'BATTLE90_TEST_BATTLE_TYPE', tonumber(rawget(PNB,'TestBattleType')) or -1)
                      rawset(_G, 'BATTLE90_IS_BATTLE_END', rawget(PNB,'isBattleEnd') == true)
                      rawset(_G, 'BATTLE90_IS_BIG_ATTACKING', rawget(PNB,'IsBattleBigAttacking') == true)
                      rawset(_G, 'BATTLE90_IS_SMALL_ATTACKING', rawget(PNB,'IsBattleSmallAttacking') == true)
                      rawset(_G, 'BATTLE90_IS_PET_ATTACKING', rawget(PNB,'IsBattlePetAttacking') == true)
                      rawset(_G, 'BATTLE90_CURR_ATTACK_TEAM_ID',
                        PNB.CurrAttackTeam and tonumber(rawget(PNB.CurrAttackTeam,'TeamId')) or 0)
                      rawset(_G, 'BATTLE90_OUR_ALL_DEATH',
                        PNB.OurTeam and type(PNB.OurTeam.IsAllDeath) == 'function' and PNB.OurTeam:IsAllDeath() == true or false)
                      rawset(_G, 'BATTLE90_ENEMY_ALL_DEATH',
                        PNB.EnemyTeam and type(PNB.EnemyTeam.IsAllDeath) == 'function' and PNB.EnemyTeam:IsAllDeath() == true or false)
                    end
                    if CNT then
                      rawset(_G, 'BATTLE90_CNT_SMALL_ROUND_BEGIN', tonumber(CNT['BattleSmallRoundBegin']) or 0)
                      rawset(_G, 'BATTLE90_CNT_SMALL_ROUND_END', tonumber(CNT['BattleSmallRoundEnd']) or 0)
                      rawset(_G, 'BATTLE90_CNT_BIG_ROUND_BEGIN', tonumber(CNT['BattleBigRoundBegin']) or 0)
                      rawset(_G, 'BATTLE90_CNT_BIG_ROUND_END', tonumber(CNT['BattleBigRoundEnd']) or 0)
                      rawset(_G, 'BATTLE90_CNT_FINAL_BATTLE_END', tonumber(CNT['FinalBattleEnd']) or 0)
                    end");
            }
            catch { }
            try { result.openedSpriteCount = YouYou.LuaHeroSprite.OpenedSprites.Count; } catch { }
            try { result.heroViewBridgeCount = env.Global.Get<int>("BATTLE90_HERO_VIEW_BRIDGE_COUNT"); } catch { }
            try { result.skinStubCount = env.Global.Get<int>("BATTLE90_SKIN_STUB_COUNT"); } catch { }
            try { result.skinRuntimeCount = env.Global.Get<int>("BATTLE90_SKIN_RUNTIME_COUNT"); } catch { }
            try { result.skinSpineCount = env.Global.Get<int>("BATTLE90_SKIN_SPINE_COUNT"); } catch { }
            try { result.skinQuadFallbackCount = env.Global.Get<int>("BATTLE90_SKIN_QUAD_FALLBACK_COUNT"); } catch { }
            try { result.skinVisualFallbackCount = env.Global.Get<int>("BATTLE90_SKIN_VISUAL_FALLBACK_COUNT"); } catch { }
            try { result.skinLastActor = env.Global.Get<string>("BATTLE90_SKIN_LAST_ACTOR") ?? ""; } catch { }
            result.runtimeActorAttachCount = BattleRuntimeSpineActorFactory.AttachCount;
            result.runtimeActorPrefabCount = BattleRuntimeSpineActorFactory.PrefabCount;
            result.runtimeActorSpineCount = BattleRuntimeSpineActorFactory.SpineCount;
            result.runtimeActorVisualFallbackCount = BattleRuntimeSpineActorFactory.VisualFallbackCount;
            result.runtimeActorQuadFallbackCount = BattleRuntimeSpineActorFactory.QuadFallbackCount;
            result.runtimeActorMissingAssetCount = BattleRuntimeSpineActorFactory.MissingAssetCount;
            result.runtimeMonsterModelResolveCount = BattleRuntimeSpineActorFactory.MonsterModelResolveCount;
            result.runtimePreviewActionCount = BattleRuntimeSpineActorFactory.PreviewActionCount;
            result.runtimePreviewCompletedCount = BattleRuntimeSpineActorFactory.PreviewCompletedCount;
            result.runtimePreviewMissCount = BattleRuntimeSpineActorFactory.PreviewMissCount;
            result.runtimeActorLastSummary = BattleRuntimeSpineActorFactory.LastSummary;
            result.runtimeMonsterModelResolveSummary = BattleRuntimeSpineActorFactory.MonsterModelResolveSummary;
            try { result.monsterBaseFallbackCount = env.Global.Get<int>("BATTLE90_MONSTER_BASE_FALLBACK_COUNT"); } catch { }
            try { result.defineLoadOk = env.Global.Get<bool>("BATTLE90_DEFINE_LOAD_OK"); } catch { }
            try { result.enumSnapshot = env.Global.Get<string>("BATTLE90_ENUM_SNAPSHOT") ?? ""; } catch { }
            try { result.firstValueDefaultCount = env.Global.Get<int>("BATTLE90_FIRST_VALUE_DEFAULT_COUNT"); } catch { }
            try { result.firstRateDefaultCount = env.Global.Get<int>("BATTLE90_FIRST_RATE_DEFAULT_COUNT"); } catch { }
            try { result.spineInvisibleGuardCount = env.Global.Get<int>("BATTLE90_SPINE_INVISIBLE_GUARD_COUNT"); } catch { }
            try { result.spineAnimationGuardCount = env.Global.Get<int>("BATTLE90_SPINE_ANIMATION_GUARD_COUNT"); } catch { }
            try { result.attackQueueGuardCount = env.Global.Get<int>("BATTLE90_ATTACK_QUEUE_GUARD_COUNT"); } catch { }
            try { result.waitUntilNoopCount = env.Global.Get<int>("BATTLE90_WAIT_UNTIL_NOOP_COUNT"); } catch { }
            try { result.waitUntilPollCount = env.Global.Get<int>("BATTLE90_WAIT_UNTIL_POLL_COUNT"); } catch { }
            try { result.waitUntilReadyCount = env.Global.Get<int>("BATTLE90_WAIT_UNTIL_READY_COUNT"); } catch { }
            try { result.coroutineFrameStartCount = env.Global.Get<int>("BATTLE90_COROUTINE_FRAME_START_COUNT"); } catch { }
            try { result.coroutineFrameResumeCount = env.Global.Get<int>("BATTLE90_COROUTINE_FRAME_RESUME_COUNT"); } catch { }
            try { result.coroutineFrameYieldCount = env.Global.Get<int>("BATTLE90_COROUTINE_FRAME_YIELD_COUNT"); } catch { }
            try { result.coroutineFrameDoneCount = env.Global.Get<int>("BATTLE90_COROUTINE_FRAME_DONE_COUNT"); } catch { }
            try { result.coroutineFrameStopCount = env.Global.Get<int>("BATTLE90_COROUTINE_FRAME_STOP_COUNT"); } catch { }
            try { result.coroutinePendingCount = env.Global.Get<int>("BATTLE90_COROUTINE_PENDING_COUNT"); } catch { }
            try { result.coroutineLastPumpSteps = env.Global.Get<int>("BATTLE90_COROUTINE_LAST_PUMP_STEPS"); } catch { }
            try { result.coroutineStartLabels = env.Global.Get<string>("BATTLE90_COROUTINE_START_LABELS") ?? ""; } catch { }
            try { result.coroutineDoneLabels = env.Global.Get<string>("BATTLE90_COROUTINE_DONE_LABELS") ?? ""; } catch { }
            try { result.coroutineStopLabels = env.Global.Get<string>("BATTLE90_COROUTINE_STOP_LABELS") ?? ""; } catch { }
            try { result.currBattleBigRound = env.Global.Get<int>("BATTLE90_CURR_BIG_ROUND"); } catch { }
            try { result.currBattleSmallRound = env.Global.Get<int>("BATTLE90_CURR_SMALL_ROUND"); } catch { }
            try { result.testBattleType = env.Global.Get<int>("BATTLE90_TEST_BATTLE_TYPE"); } catch { }
            try { result.isBattleEnd = env.Global.Get<bool>("BATTLE90_IS_BATTLE_END"); } catch { }
            try { result.isBattleBigAttacking = env.Global.Get<bool>("BATTLE90_IS_BIG_ATTACKING"); } catch { }
            try { result.isBattleSmallAttacking = env.Global.Get<bool>("BATTLE90_IS_SMALL_ATTACKING"); } catch { }
            try { result.isBattlePetAttacking = env.Global.Get<bool>("BATTLE90_IS_PET_ATTACKING"); } catch { }
            try { result.currAttackTeamId = env.Global.Get<int>("BATTLE90_CURR_ATTACK_TEAM_ID"); } catch { }
            try { result.ourAllDeath = env.Global.Get<bool>("BATTLE90_OUR_ALL_DEATH"); } catch { }
            try { result.enemyAllDeath = env.Global.Get<bool>("BATTLE90_ENEMY_ALL_DEATH"); } catch { }
            try { result.battleSmallRoundBeginCount = env.Global.Get<int>("BATTLE90_CNT_SMALL_ROUND_BEGIN"); } catch { }
            try { result.battleSmallRoundEndCount = env.Global.Get<int>("BATTLE90_CNT_SMALL_ROUND_END"); } catch { }
            try { result.battleBigRoundBeginCount = env.Global.Get<int>("BATTLE90_CNT_BIG_ROUND_BEGIN"); } catch { }
            try { result.battleBigRoundEndCount = env.Global.Get<int>("BATTLE90_CNT_BIG_ROUND_END"); } catch { }
            try { result.finalBattleEndCount = env.Global.Get<int>("BATTLE90_CNT_FINAL_BATTLE_END"); } catch { }
            try { result.pnbStartAttackTaskCount = env.Global.Get<int>("BATTLE90_PNB_START_ATTACK_TASK_COUNT"); } catch { }
            try { result.startAttackLastArgs = env.Global.Get<string>("BATTLE90_START_ATTACK_LAST_ARGS") ?? ""; } catch { }
            try { result.pnbAddAttackTaskCount = env.Global.Get<int>("BATTLE90_PNB_ADD_ATTACK_TASK_COUNT"); } catch { }
            try { result.pnbCheckStartTaskCount = env.Global.Get<int>("BATTLE90_PNB_CHECK_START_TASK_COUNT"); } catch { }
            try { result.pnbGetAttackTaskCount = env.Global.Get<int>("BATTLE90_PNB_GET_ATTACK_TASK_COUNT"); } catch { }
            try { result.pnbGetAttackTaskNilCount = env.Global.Get<int>("BATTLE90_PNB_GET_ATTACK_TASK_NIL_COUNT"); } catch { }
            try { result.pnbGetAttackTaskLast = env.Global.Get<string>("BATTLE90_PNB_GET_ATTACK_TASK_LAST") ?? ""; } catch { }
            try { result.attackMgrAddTaskCount = env.Global.Get<int>("BATTLE90_ATTACK_MGR_ADD_TASK_COUNT"); } catch { }
            try { result.attackMgrExecuteTaskCount = env.Global.Get<int>("BATTLE90_ATTACK_MGR_EXECUTE_TASK_COUNT"); } catch { }
            try { result.attackMgrExecuteNormalCount = env.Global.Get<int>("BATTLE90_ATTACK_MGR_EXECUTE_NORMAL_COUNT"); } catch { }
            try { result.attackMgrTaskCompleteCount = env.Global.Get<int>("BATTLE90_ATTACK_MGR_TASK_COMPLETE_COUNT"); } catch { }
            try { result.attackMgrAllCompleteCount = env.Global.Get<int>("BATTLE90_ATTACK_MGR_ALL_COMPLETE_COUNT"); } catch { }
            try { result.teamBeginAttackTaskCount = env.Global.Get<int>("BATTLE90_TEAM_BEGIN_ATTACK_TASK_COUNT"); } catch { }
            try { result.teamBeginAttackLastArgs = env.Global.Get<string>("BATTLE90_TEAM_BEGIN_ATTACK_LAST_ARGS") ?? ""; } catch { }
            try { result.teamBeginBigFightPlayCount = env.Global.Get<int>("BATTLE90_TEAM_BEGIN_BIG_FIGHTPLAY_COUNT"); } catch { }
            try { result.teamBeginNormalFightPlayCount = env.Global.Get<int>("BATTLE90_TEAM_BEGIN_NORMAL_FIGHTPLAY_COUNT"); } catch { }
            try { result.teamGetFightActionCount = env.Global.Get<int>("BATTLE90_TEAM_GET_FIGHT_ACTION_COUNT"); } catch { }
            try { result.teamGetFightActionWithTypeCount = env.Global.Get<int>("BATTLE90_TEAM_GET_FIGHT_ACTION_WITH_TYPE_COUNT"); } catch { }
            try { result.teamGetBigFightPlayTaskCount = env.Global.Get<int>("BATTLE90_TEAM_GET_BIG_FIGHTPLAY_TASK_COUNT"); } catch { }
            try { result.teamGetNormalFightPlayTaskCount = env.Global.Get<int>("BATTLE90_TEAM_GET_NORMAL_FIGHTPLAY_TASK_COUNT"); } catch { }
            try { result.heroBigAttackCount = env.Global.Get<int>("BATTLE90_HERO_BIG_ATTACK_COUNT"); } catch { }
            try { result.heroNormalAttackCount = env.Global.Get<int>("BATTLE90_HERO_NORMAL_ATTACK_COUNT"); } catch { }
            try { result.heroPetAttackCount = env.Global.Get<int>("BATTLE90_HERO_PET_ATTACK_COUNT"); } catch { }
            try { result.heroExplosiveCount = env.Global.Get<int>("BATTLE90_HERO_EXPLOSIVE_COUNT"); } catch { }
            try { result.realAttackPreviewActionCount = env.Global.Get<int>("BATTLE90_REAL_ATTACK_PREVIEW_ACTION_COUNT"); } catch { }
            try { result.realAttackPreviewMissCount = env.Global.Get<int>("BATTLE90_REAL_ATTACK_PREVIEW_MISS_COUNT"); } catch { }
            try { result.firstReadyShortcutCount = env.Global.Get<int>("BATTLE90_FIRST_READY_SHORTCUT_COUNT"); } catch { }
            try
            {
                env.DoString(@"
                    DIAG_SUMMARY =
                      'loadPlayerHero='..tostring(CNT and CNT['LoadPlayerHero'] or 0)..
                      ' loadEnemy='..tostring(CNT and CNT['LoadEnemyPlayerHeros'] or 0)..
                      ' teamReady='..tostring(CNT and CNT['OnBattleTeamReady'] or 0)..
                      ' firstReady='..tostring(CNT and CNT['FirstBattleTeamReady'] or 0)..
                      ' afterReady='..tostring(CNT and CNT['AfterBattleTeamReady'] or 0)..
                      ' battleBegin='..tostring(CNT and CNT['BattleBegin'] or 0)..
                      ' bigRound='..tostring(CNT and CNT['BattleBigRoundBegin'] or 0)..
                      ' currBigRound='..tostring(PNB and rawget(PNB,'CurrBattleBigRound'))..
                      ' attackPreviewMode='..tostring(rawget(_G,'BATTLE90_USE_ATTACK_TASK_PREVIEW'))..
                      ' defineLoadOk='..tostring(rawget(_G,'BATTLE90_DEFINE_LOAD_OK'))..
                      ' enumSnapshot='..tostring(rawget(_G,'BATTLE90_ENUM_SNAPSHOT') or '')..
                      ' firstValueDefault='..tostring(rawget(_G,'BATTLE90_FIRST_VALUE_DEFAULT_COUNT') or 0)..
                      ' firstRateDefault='..tostring(rawget(_G,'BATTLE90_FIRST_RATE_DEFAULT_COUNT') or 0)..
                      ' spineInvisibleGuard='..tostring(rawget(_G,'BATTLE90_SPINE_INVISIBLE_GUARD_COUNT') or 0)..
                      ' spineAnimationGuard='..tostring(rawget(_G,'BATTLE90_SPINE_ANIMATION_GUARD_COUNT') or 0)..
                      ' attackQueueGuard='..tostring(rawget(_G,'BATTLE90_ATTACK_QUEUE_GUARD_COUNT') or 0)..
                      ' currSmall='..tostring(rawget(_G,'BATTLE90_CURR_SMALL_ROUND') or 0)..
                      ' testBattleType='..tostring(rawget(_G,'BATTLE90_TEST_BATTLE_TYPE') or -1)..
                      ' isBattleEnd='..tostring(rawget(_G,'BATTLE90_IS_BATTLE_END'))..
                      ' currAttackTeam='..tostring(rawget(_G,'BATTLE90_CURR_ATTACK_TEAM_ID') or 0)..
                      ' ourAllDeath='..tostring(rawget(_G,'BATTLE90_OUR_ALL_DEATH'))..
                      ' enemyAllDeath='..tostring(rawget(_G,'BATTLE90_ENEMY_ALL_DEATH'))..
                      ' cntSmallBegin='..tostring(rawget(_G,'BATTLE90_CNT_SMALL_ROUND_BEGIN') or 0)..
                      ' cntSmallEnd='..tostring(rawget(_G,'BATTLE90_CNT_SMALL_ROUND_END') or 0)..
                      ' cntBigEnd='..tostring(rawget(_G,'BATTLE90_CNT_BIG_ROUND_END') or 0)..
                      ' heroViewBridge='..tostring(rawget(_G,'BATTLE90_HERO_VIEW_BRIDGE_COUNT') or 0)..
                      ' skinStub='..tostring(rawget(_G,'BATTLE90_SKIN_STUB_COUNT') or 0)..
                      ' skinRuntime='..tostring(rawget(_G,'BATTLE90_SKIN_RUNTIME_COUNT') or 0)..
                      ' skinSpine='..tostring(rawget(_G,'BATTLE90_SKIN_SPINE_COUNT') or 0)..
                      ' skinQuadFallback='..tostring(rawget(_G,'BATTLE90_SKIN_QUAD_FALLBACK_COUNT') or 0)..
                      ' skinVisualFallback='..tostring(rawget(_G,'BATTLE90_SKIN_VISUAL_FALLBACK_COUNT') or 0)..
                      ' monsterFallback='..tostring(rawget(_G,'BATTLE90_MONSTER_BASE_FALLBACK_COUNT') or 0)..
                      ' readyTeams='..tostring(PNB and rawget(PNB,'ReadyTeamCount'))..
                      ' ourCur='..tostring(PNB and PNB.OurTeam and rawget(PNB.OurTeam,'CurrHeroCount'))..
                      ' enemyCur='..tostring(PNB and PNB.EnemyTeam and rawget(PNB.EnemyTeam,'CurrHeroCount'))..
                      ' firstShortcut='..tostring(rawget(_G,'BATTLE90_FIRST_READY_SHORTCUT_COUNT') or 0)..
                      ' beginBuffShortcut='..tostring(rawget(_G,'BATTLE90_BEGIN_BUFF_SHORTCUT_COUNT') or 0)..
                      ' allBigShortcut='..tostring(rawget(_G,'BATTLE90_ALL_BIG_ROUND_SHORTCUT_COUNT') or 0)..
                      ' smallRoundShortcut='..tostring(rawget(_G,'BATTLE90_SMALL_ROUND_SHORTCUT_COUNT') or 0)..
                      ' attackTaskShortcut='..tostring(rawget(_G,'BATTLE90_ATTACK_TASK_SHORTCUT_COUNT') or 0)..
                      ' attackTaskGuard='..tostring(rawget(_G,'BATTLE90_ATTACK_TASK_GUARD_COUNT') or 0)..
                      ' attackActions='..tostring(rawget(_G,'BATTLE90_ATTACK_ACTION_COUNT') or 0)..
                      ' attackPreview='..tostring(rawget(_G,'BATTLE90_ATTACK_PREVIEW_ACTION_COUNT') or 0)..
                      ' attackPreviewMiss='..tostring(rawget(_G,'BATTLE90_ATTACK_PREVIEW_MISS_COUNT') or 0)..
                      ' pnbStartAttack='..tostring(rawget(_G,'BATTLE90_PNB_START_ATTACK_TASK_COUNT') or 0)..
                      ' startArgs='..tostring(rawget(_G,'BATTLE90_START_ATTACK_LAST_ARGS') or '')..
                      ' pnbAddAttack='..tostring(rawget(_G,'BATTLE90_PNB_ADD_ATTACK_TASK_COUNT') or 0)..
                      ' pnbCheckStart='..tostring(rawget(_G,'BATTLE90_PNB_CHECK_START_TASK_COUNT') or 0)..
                      ' pnbGetAttack='..tostring(rawget(_G,'BATTLE90_PNB_GET_ATTACK_TASK_COUNT') or 0)..
                      ' pnbGetAttackNil='..tostring(rawget(_G,'BATTLE90_PNB_GET_ATTACK_TASK_NIL_COUNT') or 0)..
                      ' getAttackLast='..tostring(rawget(_G,'BATTLE90_PNB_GET_ATTACK_TASK_LAST') or '')..
                      ' mgrAddTask='..tostring(rawget(_G,'BATTLE90_ATTACK_MGR_ADD_TASK_COUNT') or 0)..
                      ' mgrExecuteTask='..tostring(rawget(_G,'BATTLE90_ATTACK_MGR_EXECUTE_TASK_COUNT') or 0)..
                      ' mgrExecuteNormal='..tostring(rawget(_G,'BATTLE90_ATTACK_MGR_EXECUTE_NORMAL_COUNT') or 0)..
                      ' mgrTaskComplete='..tostring(rawget(_G,'BATTLE90_ATTACK_MGR_TASK_COMPLETE_COUNT') or 0)..
                      ' mgrAllComplete='..tostring(rawget(_G,'BATTLE90_ATTACK_MGR_ALL_COMPLETE_COUNT') or 0)..
                      ' teamBeginAttack='..tostring(rawget(_G,'BATTLE90_TEAM_BEGIN_ATTACK_TASK_COUNT') or 0)..
                      ' teamBeginArgs='..tostring(rawget(_G,'BATTLE90_TEAM_BEGIN_ATTACK_LAST_ARGS') or '')..
                      ' teamBeginBigFP='..tostring(rawget(_G,'BATTLE90_TEAM_BEGIN_BIG_FIGHTPLAY_COUNT') or 0)..
                      ' teamBeginNormalFP='..tostring(rawget(_G,'BATTLE90_TEAM_BEGIN_NORMAL_FIGHTPLAY_COUNT') or 0)..
                      ' teamFightAction='..tostring(rawget(_G,'BATTLE90_TEAM_GET_FIGHT_ACTION_COUNT') or 0)..
                      ' teamFightActionType='..tostring(rawget(_G,'BATTLE90_TEAM_GET_FIGHT_ACTION_WITH_TYPE_COUNT') or 0)..
                      ' teamBigTaskFP='..tostring(rawget(_G,'BATTLE90_TEAM_GET_BIG_FIGHTPLAY_TASK_COUNT') or 0)..
                      ' teamNormalTaskFP='..tostring(rawget(_G,'BATTLE90_TEAM_GET_NORMAL_FIGHTPLAY_TASK_COUNT') or 0)..
                      ' heroBig='..tostring(rawget(_G,'BATTLE90_HERO_BIG_ATTACK_COUNT') or 0)..
                      ' heroNormal='..tostring(rawget(_G,'BATTLE90_HERO_NORMAL_ATTACK_COUNT') or 0)..
                      ' heroPet='..tostring(rawget(_G,'BATTLE90_HERO_PET_ATTACK_COUNT') or 0)..
                      ' heroExplosive='..tostring(rawget(_G,'BATTLE90_HERO_EXPLOSIVE_COUNT') or 0)..
                      ' realAttackPreview='..tostring(rawget(_G,'BATTLE90_REAL_ATTACK_PREVIEW_ACTION_COUNT') or 0)..
                      ' realAttackPreviewMiss='..tostring(rawget(_G,'BATTLE90_REAL_ATTACK_PREVIEW_MISS_COUNT') or 0)..
                      ' waitUntilNoop='..tostring(rawget(_G,'BATTLE90_WAIT_UNTIL_NOOP_COUNT') or 0)..
                      ' waitUntilPoll='..tostring(rawget(_G,'BATTLE90_WAIT_UNTIL_POLL_COUNT') or 0)..
                      ' waitUntilReady='..tostring(rawget(_G,'BATTLE90_WAIT_UNTIL_READY_COUNT') or 0)..
                      ' coroutineInline='..tostring(rawget(_G,'BATTLE90_COROUTINE_INLINE_COUNT') or 0)..
                      ' coroutineFrameStart='..tostring(rawget(_G,'BATTLE90_COROUTINE_FRAME_START_COUNT') or 0)..
                      ' coroutineFrameResume='..tostring(rawget(_G,'BATTLE90_COROUTINE_FRAME_RESUME_COUNT') or 0)..
                      ' coroutineFrameDone='..tostring(rawget(_G,'BATTLE90_COROUTINE_FRAME_DONE_COUNT') or 0)..
                      ' coroutinePending='..tostring(rawget(_G,'BATTLE90_COROUTINE_PENDING_COUNT') or 0)..
                      ' coroutineStopLabels='..tostring(rawget(_G,'BATTLE90_COROUTINE_STOP_LABELS') or '')");
                result.diagSummary = env.Global.Get<string>("DIAG_SUMMARY") ?? "";
            }
            catch { }
            result.diagSummary = (result.diagSummary ?? "") +
                " runtimeAttach=" + result.runtimeActorAttachCount +
                " runtimePrefab=" + result.runtimeActorPrefabCount +
                " runtimeSpine=" + result.runtimeActorSpineCount +
                " runtimeVisualFallback=" + result.runtimeActorVisualFallbackCount +
                " runtimeQuadFallback=" + result.runtimeActorQuadFallbackCount +
                " runtimeMissingAsset=" + result.runtimeActorMissingAssetCount +
                " runtimeMonsterModelResolve=" + result.runtimeMonsterModelResolveCount +
                " runtimePreview=" + result.runtimePreviewActionCount +
                " runtimePreviewDone=" + result.runtimePreviewCompletedCount +
                " runtimePreviewMiss=" + result.runtimePreviewMissCount;
        }

        private static void AppendVisualDiagnostics(Result result)
        {
            result.diagSummary = (result.diagSummary ?? "") +
                " visualActors=" + result.visualActorHandleCount +
                " visualRenderers=" + result.visualActorRendererCount +
                " visualScreenArea=" + result.visualActorScreenAreaRatio.ToString("0.######") +
                " captureNonDark=" + result.captureNonDarkSampleCount;
        }

        private static Camera EnsureVisualStage()
        {
            var camera = Camera.main;
            if (camera == null)
            {
                var cameraGo = new GameObject("B90_VisualCamera");
                cameraGo.tag = "MainCamera";
                camera = cameraGo.AddComponent<Camera>();
            }

            camera.name = "B90_VisualCamera";
            camera.clearFlags = CameraClearFlags.SolidColor;
            camera.backgroundColor = new Color(0.025f, 0.028f, 0.034f, 1f);
            camera.orthographic = true;
            camera.orthographicSize = 3.35f;
            camera.transform.position = new Vector3(0f, -0.35f, -10f);
            camera.transform.rotation = Quaternion.identity;

            var stage = GameObject.Find("B90_VisualStage");
            if (stage == null)
                stage = new GameObject("B90_VisualStage");

            if (stage.transform.Find("B90_Map_11001") == null)
                CreateMapSprite(stage.transform);

            return camera;
        }

        private static void CreateMapSprite(Transform parent)
        {
            var path = Path.Combine(Application.dataPath, "RestoreData", "battle", "VisualAssets", "map", "Map_11001_2.png");
            if (!File.Exists(path))
                path = Path.Combine(Application.dataPath, "RestoreData", "battle", "VisualAssets", "map", "sactx-0-2048x2048-ETC2-Map_11001_1-2ccb5b85.png");

            if (!File.Exists(path))
                return;

            var texture = new Texture2D(2, 2, TextureFormat.RGBA32, false);
            texture.name = "B90_Map_11001_Texture";
            if (!texture.LoadImage(File.ReadAllBytes(path)))
                return;

            var pixelsPerUnit = Mathf.Max(1f, texture.width / 10.5f);
            var sprite = Sprite.Create(texture, new Rect(0, 0, texture.width, texture.height), new Vector2(0.5f, 0.5f), pixelsPerUnit);
            sprite.name = "B90_Map_11001_Sprite";

            var go = new GameObject("B90_Map_11001");
            go.transform.SetParent(parent, false);
            go.transform.localPosition = new Vector3(0f, -0.1f, 2f);
            var renderer = go.AddComponent<SpriteRenderer>();
            renderer.sprite = sprite;
            renderer.sortingOrder = -100;
        }

        private static void CollectVisualDiagnostics(Result result, Camera camera)
        {
            var handles = UnityEngine.Object.FindObjectsOfType<BattleRuntimeActorHandle>();
            result.visualActorHandleCount = handles.Length;
            result.visualCameraName = camera != null ? camera.name : "";
            result.visualCameraOrthographicSize = camera != null ? camera.orthographicSize : 0f;

            var hasBounds = false;
            var combined = new Bounds();
            var rendererCount = 0;
            foreach (var handle in handles)
            {
                if (handle == null) continue;
                var renderers = handle.GetComponentsInChildren<Renderer>(true);
                foreach (var renderer in renderers)
                {
                    if (renderer == null || !renderer.enabled || !renderer.gameObject.activeInHierarchy)
                        continue;
                    rendererCount++;
                    if (!hasBounds)
                    {
                        combined = renderer.bounds;
                        hasBounds = true;
                    }
                    else
                    {
                        combined.Encapsulate(renderer.bounds);
                    }
                }
            }

            result.visualActorRendererCount = rendererCount;
            result.visualActorWorldBounds = hasBounds ? Vec(combined.center) + "|" + Vec(combined.size) : "";
            result.visualActorScreenRect = hasBounds && camera != null ? ScreenRect(camera, combined) : "";
            result.visualActorScreenAreaRatio = hasBounds && camera != null ? ScreenAreaRatio(camera, combined) : 0f;
        }

        private static void CaptureVisualEvidence(Result result, Camera camera)
        {
            if (camera == null)
                return;

            var captureFileName = string.Equals(Path.GetFileName(ResultPath), RealAttackProbeResultFileName, StringComparison.OrdinalIgnoreCase)
                ? "BATTLE_90_REAL_ATTACK_PROBE_CAPTURE.png"
                : "BATTLE_90_PLAYMODE_BOOTSTRAP_CAPTURE.png";
            var output = Path.Combine(GetResultDirectory(), captureFileName);
            Directory.CreateDirectory(Path.GetDirectoryName(output));

            var rt = new RenderTexture(CaptureWidth, CaptureHeight, 24, RenderTextureFormat.ARGB32);
            var previousTarget = camera.targetTexture;
            var previousActive = RenderTexture.active;
            camera.targetTexture = rt;
            RenderTexture.active = rt;
            camera.Render();

            var texture = new Texture2D(CaptureWidth, CaptureHeight, TextureFormat.RGB24, false);
            texture.ReadPixels(new Rect(0, 0, CaptureWidth, CaptureHeight), 0, 0);
            texture.Apply();
            var bytes = texture.EncodeToPNG();
            File.WriteAllBytes(output, bytes);

            result.capturePath = output;
            result.captureExists = File.Exists(output);
            result.captureBytes = bytes != null ? bytes.Length : 0;
            result.captureNonDarkSampleCount = CountNonDarkSamples(texture);

            camera.targetTexture = previousTarget;
            RenderTexture.active = previousActive;
            Destroy(texture);
            Destroy(rt);
        }

        private static int CountNonDarkSamples(Texture2D texture)
        {
            if (texture == null) return 0;
            var count = 0;
            const int step = 16;
            for (var y = 0; y < texture.height; y += step)
            {
                for (var x = 0; x < texture.width; x += step)
                {
                    var color = texture.GetPixel(x, y);
                    if (color.r + color.g + color.b > 0.18f)
                        count++;
                }
            }
            return count;
        }

        private static string GetResultDirectory()
        {
            var path = ResultPath;
            if (string.IsNullOrEmpty(path))
                path = Path.GetFullPath(Path.Combine(Application.dataPath, "..", "..", "reports", "battle", DefaultResultFileName));
            return Path.GetDirectoryName(path);
        }

        private static string Vec(Vector3 value)
        {
            return value.x.ToString("0.###") + "/" + value.y.ToString("0.###") + "/" + value.z.ToString("0.###");
        }

        private static string ScreenRect(Camera camera, Bounds bounds)
        {
            var min = new Vector2(float.MaxValue, float.MaxValue);
            var max = new Vector2(float.MinValue, float.MinValue);
            foreach (var point in BoundsCorners(bounds))
            {
                var screen = camera.WorldToScreenPoint(point);
                min.x = Mathf.Min(min.x, screen.x);
                min.y = Mathf.Min(min.y, screen.y);
                max.x = Mathf.Max(max.x, screen.x);
                max.y = Mathf.Max(max.y, screen.y);
            }
            return min.x.ToString("0.##") + "/" + min.y.ToString("0.##") + "/" + max.x.ToString("0.##") + "/" + max.y.ToString("0.##");
        }

        private static float ScreenAreaRatio(Camera camera, Bounds bounds)
        {
            var min = new Vector2(float.MaxValue, float.MaxValue);
            var max = new Vector2(float.MinValue, float.MinValue);
            foreach (var point in BoundsCorners(bounds))
            {
                var screen = camera.WorldToScreenPoint(point);
                min.x = Mathf.Min(min.x, screen.x);
                min.y = Mathf.Min(min.y, screen.y);
                max.x = Mathf.Max(max.x, screen.x);
                max.y = Mathf.Max(max.y, screen.y);
            }
            var area = Mathf.Max(0f, max.x - min.x) * Mathf.Max(0f, max.y - min.y);
            return area / Mathf.Max(1f, Screen.width * Screen.height);
        }

        private static IEnumerable<Vector3> BoundsCorners(Bounds bounds)
        {
            var min = bounds.min;
            var max = bounds.max;
            yield return new Vector3(min.x, min.y, min.z);
            yield return new Vector3(min.x, min.y, max.z);
            yield return new Vector3(min.x, max.y, min.z);
            yield return new Vector3(min.x, max.y, max.z);
            yield return new Vector3(max.x, min.y, min.z);
            yield return new Vector3(max.x, min.y, max.z);
            yield return new Vector3(max.x, max.y, min.z);
            yield return new Vector3(max.x, max.y, max.z);
        }

        private static void MaterializeOpenedHeroSprites(LuaEnv env, List<string> stages, ref string failStage, ref string err)
        {
            if (env == null || !string.IsNullOrEmpty(failStage)) return;

            var sprites = new List<YouYou.LuaHeroSprite>(YouYou.LuaHeroSprite.OpenedSprites);
            stages.Add("heroViewBridge:sprites=" + sprites.Count);
            var ourSlot = 0;
            var enemySlot = 0;
            for (var i = 0; i < sprites.Count; i++)
            {
                var sprite = sprites[i];
                if (sprite == null) continue;

                try
                {
                    sprite.EnsureRuntimePlaceholders();
                    var slot = sprite.IsOurHero ? ourSlot++ : enemySlot++;
                    ApplyPreviewFormationPosition(sprite, slot);
                    env.Global.Set("BATTLE90_LUA_HERO_SPRITE", sprite);
                    env.DoString(@"
                        local sprite = BATTLE90_LUA_HERO_SPRITE
                        assert(sprite, 'no LuaHeroSprite')
                        local bridged = rawget(_G, 'BATTLE90_HERO_VIEW_BRIDGED')
                        if type(bridged) ~= 'table' then
                          bridged = {}
                          rawset(_G, 'BATTLE90_HERO_VIEW_BRIDGED', bridged)
                        end
                        if not bridged[sprite] then
                          assert(HeroCtrl and HeroCtrl.Create, 'HeroCtrl missing')
                          local ctrl = HeroCtrl:Create()
                          ctrl.transform = sprite.transform
                          local shadow = sprite.Shadow or sprite.transform
                          ctrl:InitViewWith(
                            sprite.IsOurHero,
                            sprite.BaseHeroID,
                            sprite.HeroID,
                            shadow,
                            sprite.CurrMaterialProperty,
                            sprite.IdleData,
                            sprite.IsSupplementHero)
                          ctrl.shadowRenderer = sprite.ShadowRenderer
                          ctrl.IsMonster = sprite.IsMonster
                          ctrl.battleStationIndex = sprite.BattleStationIndex
                          ctrl.IsSupplementHero = sprite.IsSupplementHero
                          ctrl:OnOpen()
                          local pnb = PNB or (ModulesInit and ModulesInit.ProcedureNormalBattle)
                          assert(pnb and pnb.OurTeam and pnb.EnemyTeam, 'ProcedureNormalBattle teams missing')
                          if sprite.IsOurHero then
                            if ctrl:IsPet() then pnb.OurTeam:AddPetCtrl(ctrl) else pnb.OurTeam:AddHeroCtrl(ctrl) end
                          else
                            if ctrl:IsPet() then pnb.EnemyTeam:AddPetCtrl(ctrl) else pnb.EnemyTeam:AddHeroCtrl(ctrl) end
                          end
                          bridged[sprite] = ctrl
                          local count = rawget(_G, 'BATTLE90_HERO_VIEW_BRIDGE_COUNT')
                          if type(count) ~= 'number' then count = 0 end
                          rawset(_G, 'BATTLE90_HERO_VIEW_BRIDGE_COUNT', count + 1)
                        end");
                }
                catch (Exception e)
                {
                    failStage = "heroViewBridge[" + i + "]";
                    err = e.Message;
                    return;
                }
            }

            try { env.Global.Set<string, object>("BATTLE90_LUA_HERO_SPRITE", null); } catch { }
        }

        private static void ApplyPreviewFormationPosition(YouYou.LuaHeroSprite sprite, int slot)
        {
            if (sprite == null) return;

            var positions = sprite.IsOurHero
                ? new[]
                {
                    new Vector3(-4.15f, -0.98f, 0f),
                    new Vector3(-2.75f, -0.5f, 0f),
                    new Vector3(-1.35f, -1.45f, 0f),
                    new Vector3(-3.55f, -1.95f, 0f),
                    new Vector3(-2.15f, -1.45f, 0f),
                    new Vector3(-0.75f, -2.35f, 0f),
                }
                : new[]
                {
                    new Vector3(4.15f, -0.98f, 0f),
                    new Vector3(2.75f, -0.5f, 0f),
                    new Vector3(1.35f, -1.45f, 0f),
                    new Vector3(3.55f, -1.95f, 0f),
                    new Vector3(2.15f, -1.45f, 0f),
                    new Vector3(0.75f, -2.35f, 0f),
                };

            var index = Mathf.Clamp(slot, 0, positions.Length - 1);
            sprite.transform.position = positions[index];
            sprite.transform.localRotation = Quaternion.identity;
            sprite.transform.localScale = Vector3.one;
            sprite.BattleStationIndex = index;
        }

        private static void Safe(LuaEnv env, string lua, List<string> stages, ref string failStage, ref string err, bool optional = false)
        {
            if (!string.IsNullOrEmpty(failStage)) return;
            try
            {
                env.DoString(lua);
                stages.Add(lua.Length > 48 ? lua.Substring(0, 48) + "..." : lua);
            }
            catch (Exception e)
            {
                if (optional)
                {
                    stages.Add("(opt-fail)" + (lua.Length > 32 ? lua.Substring(0, 32) : lua));
                    return;
                }
                failStage = lua.Length > 72 ? lua.Substring(0, 72) + "..." : lua;
                err = e.Message;
            }
        }

        private static void PumpFrame(LuaEnv env, ref string failStage, ref string err)
        {
            if (env == null || !string.IsNullOrEmpty(failStage)) return;
            try
            {
                env.DoString(@"
                    if BATTLE90_PUMP_COROUTINES then BATTLE90_PUMP_COROUTINES(128) end
                    if PNB and PNB.OnUpdate then PNB.OnUpdate(CS.UnityEngine.Time.deltaTime) end
                    if BATTLE90_PUMP_COROUTINES then BATTLE90_PUMP_COROUTINES(128) end");
            }
            catch (Exception e)
            {
                failStage = "PNB.OnUpdate";
                err = e.Message;
            }
        }

        private static void WriteResult(Result result)
        {
            var path = ResultPath;
            if (string.IsNullOrEmpty(path))
            {
                path = Path.GetFullPath(Path.Combine(
                    Application.dataPath, "..", "..", "reports", "battle", DefaultResultFileName));
            }

            Directory.CreateDirectory(Path.GetDirectoryName(path));
            File.WriteAllText(path, JsonUtility.ToJson(result, true), new UTF8Encoding(false));
        }

        private static string Scrub(string value)
        {
            return (value ?? "").Replace("\\", "/").Replace("\"", "'").Replace("\r", " ").Replace("\n", " | ");
        }

        [Serializable]
        private sealed class Result
        {
            public string generatedAt;
            public string status;
            public bool playModeEntered;
            public bool useAttackTaskPreview;
            public int frameBudget;
            public int framesPumped;
            public int decodedLuaIndexCount;
            public string payloadPath;
            public bool payloadExists;
            public int changeStateCount;
            public string lastRequestedState;
            public bool battleEntered;
            public string failedStage;
            public string error;
            public int errorLogCount;
            public string firstLogException;
            public string trace;
            public string diagSummary;
            public int openedSpriteCount;
            public int heroViewBridgeCount;
            public int skinStubCount;
            public int skinRuntimeCount;
            public int skinSpineCount;
            public int skinQuadFallbackCount;
            public int skinVisualFallbackCount;
            public string skinLastActor;
            public int runtimeActorAttachCount;
            public int runtimeActorPrefabCount;
            public int runtimeActorSpineCount;
            public int runtimeActorVisualFallbackCount;
            public int runtimeActorQuadFallbackCount;
            public int runtimeActorMissingAssetCount;
            public int runtimeMonsterModelResolveCount;
            public int runtimePreviewActionCount;
            public int runtimePreviewCompletedCount;
            public int runtimePreviewMissCount;
            public string runtimeActorLastSummary;
            public string runtimeMonsterModelResolveSummary;
            public string visualCameraName;
            public float visualCameraOrthographicSize;
            public int visualActorHandleCount;
            public int visualActorRendererCount;
            public string visualActorWorldBounds;
            public string visualActorScreenRect;
            public float visualActorScreenAreaRatio;
            public string capturePath;
            public bool captureExists;
            public int captureBytes;
            public int captureNonDarkSampleCount;
            public int monsterBaseFallbackCount;
            public bool defineLoadOk;
            public string enumSnapshot;
            public int firstValueDefaultCount;
            public int firstRateDefaultCount;
            public int spineInvisibleGuardCount;
            public int spineAnimationGuardCount;
            public int attackQueueGuardCount;
            public int waitUntilNoopCount;
            public int waitUntilPollCount;
            public int waitUntilReadyCount;
            public int coroutineFrameStartCount;
            public int coroutineFrameResumeCount;
            public int coroutineFrameYieldCount;
            public int coroutineFrameDoneCount;
            public int coroutineFrameStopCount;
            public int coroutinePendingCount;
            public int coroutineLastPumpSteps;
            public string coroutineStartLabels;
            public string coroutineDoneLabels;
            public string coroutineStopLabels;
            public int currBattleBigRound;
            public int currBattleSmallRound;
            public int testBattleType;
            public bool isBattleEnd;
            public bool isBattleBigAttacking;
            public bool isBattleSmallAttacking;
            public bool isBattlePetAttacking;
            public int currAttackTeamId;
            public bool ourAllDeath;
            public bool enemyAllDeath;
            public int battleSmallRoundBeginCount;
            public int battleSmallRoundEndCount;
            public int battleBigRoundBeginCount;
            public int battleBigRoundEndCount;
            public int finalBattleEndCount;
            public int pnbStartAttackTaskCount;
            public string startAttackLastArgs;
            public int pnbAddAttackTaskCount;
            public int pnbCheckStartTaskCount;
            public int pnbGetAttackTaskCount;
            public int pnbGetAttackTaskNilCount;
            public string pnbGetAttackTaskLast;
            public int attackMgrAddTaskCount;
            public int attackMgrExecuteTaskCount;
            public int attackMgrExecuteNormalCount;
            public int attackMgrTaskCompleteCount;
            public int attackMgrAllCompleteCount;
            public int teamBeginAttackTaskCount;
            public string teamBeginAttackLastArgs;
            public int teamBeginBigFightPlayCount;
            public int teamBeginNormalFightPlayCount;
            public int teamGetFightActionCount;
            public int teamGetFightActionWithTypeCount;
            public int teamGetBigFightPlayTaskCount;
            public int teamGetNormalFightPlayTaskCount;
            public int heroBigAttackCount;
            public int heroNormalAttackCount;
            public int heroPetAttackCount;
            public int heroExplosiveCount;
            public int realAttackPreviewActionCount;
            public int realAttackPreviewMissCount;
            public int firstReadyShortcutCount;
            public List<string> stagesCompleted;
        }
    }
}
