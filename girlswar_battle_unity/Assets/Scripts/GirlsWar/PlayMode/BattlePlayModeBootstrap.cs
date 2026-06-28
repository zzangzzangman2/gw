using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Text;
using UnityEngine;
using UnityEngine.UI;
using XLua;

namespace GirlsWar
{
    public sealed class BattlePlayModeBootstrap : MonoBehaviour
    {
        public const string DefaultResultFileName = "BATTLE_90_PLAYMODE_BOOTSTRAP_RESULT.json";
        public const string RealAttackProbeResultFileName = "BATTLE_90_REAL_ATTACK_PROBE_RESULT.json";
        public const string RosterExpansionResultFileName = "BATTLE_92_ROSTER_EXPANSION_PLAYMODE_RESULT.json";
        public const string DefaultPayloadFileName = "BATTLE_TEST_PAYLOAD.json";
        public const string RosterExpansionPayloadFileName = "BATTLE_TEST_PAYLOAD_ROSTER_EXPANSION.json";

        public static bool Completed { get; private set; }
        public static int LastExitCode { get; private set; } = 1;
        public static string LastStatus { get; private set; } = "";
        public static string ResultPath { get; private set; }

        private static int configuredFrameBudget = 240;
        private static bool configuredUseAttackTaskPreview = true;
        private static bool configuredStandingSnapshotOnly;
        private static string configuredPayloadFileName = DefaultPayloadFileName;
        private static int[] configuredHudCardActorIds = { 1036, 1002, 1034, 0, 0 };
        private const int CaptureWidth = 1280;
        private const int CaptureHeight = 570;
        private const string VisualTuningVersion = "battle92-source-formation-character-ratio-v16";
        private const float VisualMapWidthUnits = 22.6f; // fill the real ortho-5.0 view width (22.46)
        private static readonly int[] DefaultHudCardActorIds = { 1036, 1002, 1034, 0, 0 };
        private static readonly int[] RosterExpansionHudCardActorIds = { 1005, 1010, 1002, 1003, 1001 };
        private static readonly int[] StandingSnapshotEnemyActorIds = { 1100111, 1100112, 1100113 };
        // AUTHORITATIVE world positions extracted from the real battle scene
        // download/scenes/normalscene/gamescene_normalbattle.assetbundle (UnityPy):
        // NormalBattleCtrl(0,-1.51) > OurTeam(world -4.0,-2.56) / EnemyTeam(world +4.0,-2.56),
        // each with BattleStation_1..6 children. World = team_root + station_local. slot i = position i+1.
        // All OUR stations x in [-6.65,-2.36] (left), ENEMY in [+2.35,+6.65] (right): center never crossed.
        private static readonly Vector3[] OurFormationSlotPositions =
        {
            new Vector3(-2.356f, -1.31f, 0.9f),  // pos1 BattleStation_1 (front, top)
            new Vector3(-3.890f, -2.41f, -0.1f), // pos2 BattleStation_2 (front, mid)
            new Vector3(-2.356f, -3.40f, -1.1f), // pos3 BattleStation_3 (front, bottom)
            new Vector3(-5.319f, -1.00f, 1.0f),  // pos4 BattleStation_4 (back, top)
            new Vector3(-6.649f, -2.41f, 0.0f),  // pos5 BattleStation_5 (back, mid)
            new Vector3(-5.758f, -3.68f, -1.0f), // pos6 BattleStation_6 (back, bottom)
        };
        private static readonly Vector3[] EnemyFormationSlotPositions =
        {
            new Vector3(2.351f, -1.31f, 0.9f),  // pos1 BattleStation_1
            new Vector3(3.890f, -2.41f, -0.1f), // pos2 BattleStation_2
            new Vector3(2.351f, -3.40f, -1.1f), // pos3 BattleStation_3
            new Vector3(5.319f, -1.00f, 1.0f),  // pos4 BattleStation_4
            new Vector3(6.608f, -2.41f, 0.0f),  // pos5 BattleStation_5
            new Vector3(5.758f, -3.68f, -1.0f), // pos6 BattleStation_6
        };
        private static readonly float[] OurFormationSlotScales = { 1f, 1f, 1f, 1f, 1f, 1f };
        private static readonly float[] EnemyFormationSlotScales = { 0.72f, 0.72f, 0.72f, 0.72f, 0.72f, 0.72f };
        private static readonly Dictionary<string, Sprite> RuntimeUiSpriteCache = new Dictionary<string, Sprite>(StringComparer.OrdinalIgnoreCase);
        private static readonly Dictionary<string, string> RuntimeLocalizationCache = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
        private static bool runtimeLocalizationCacheLoaded;
        private static int ultimateCutinOverlayRequestCount;
        private static int ultimateCutinOverlayShownCount;
        private static int ultimateCutinOverlaySourceSpriteCount;
        private static int ultimateCutinOverlayLastFrame = -9999;
        private static string ultimateCutinOverlaySummary = "";

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
            ConfigureForEditorRun(resultPath, frames, useAttackTaskPreview, DefaultPayloadFileName, DefaultHudCardActorIds);
        }

        public static void ConfigureForEditorRun(string resultPath, int frames, bool useAttackTaskPreview, string payloadFileName, int[] hudCardActorIds)
        {
            ConfigureForEditorRun(resultPath, frames, useAttackTaskPreview, payloadFileName, hudCardActorIds, false);
        }

        public static void ConfigureForEditorRun(string resultPath, int frames, bool useAttackTaskPreview, string payloadFileName, int[] hudCardActorIds, bool standingSnapshotOnly)
        {
            ResultPath = resultPath;
            configuredFrameBudget = frames;
            configuredUseAttackTaskPreview = useAttackTaskPreview;
            configuredStandingSnapshotOnly = standingSnapshotOnly;
            configuredPayloadFileName = string.IsNullOrEmpty(payloadFileName) ? DefaultPayloadFileName : payloadFileName;
            if (hudCardActorIds != null && hudCardActorIds.Length > 0)
            {
                configuredHudCardActorIds = (int[])hudCardActorIds.Clone();
            }
            else if (string.Equals(configuredPayloadFileName, RosterExpansionPayloadFileName, StringComparison.OrdinalIgnoreCase))
            {
                configuredHudCardActorIds = (int[])RosterExpansionHudCardActorIds.Clone();
            }
            else
            {
                configuredHudCardActorIds = (int[])DefaultHudCardActorIds.Clone();
            }
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
            ResetUltimateCutinDiagnostics();
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
                standingSnapshotOnly = configuredStandingSnapshotOnly,
                playModeEntered = Application.isPlaying,
                decodedLuaIndexCount = GirlsWarLuaLoader.IndexCount,
            };
            var stages = new List<string>();
            string failStage = "";
            string err = "";
            bool battleEntered = false;
            var sequenceCaptures = new List<string>();

            LuaEnv env = null;
            try
            {
                env = new LuaEnv();
                env.AddLoader((ref string p) => GirlsWarLuaLoader.Load(ref p));
                stages.Add("luaenv+loader");

                env.DoString(SetupEnv);
                env.Global.Set("BATTLE90_USE_ATTACK_TASK_PREVIEW", configuredUseAttackTaskPreview);
                env.Global.Set("BATTLE90_USE_FRAME_COROUTINES", !configuredUseAttackTaskPreview);
                env.Global.Set("BATTLE90_STANDING_SNAPSHOT_ONLY", configuredStandingSnapshotOnly);
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
                        Application.dataPath, "RestoreData", "battle", configuredPayloadFileName));
                    result.payloadFileName = configuredPayloadFileName;
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
                        local function first_hero_rank()
                          if type(info.ourHeros) == 'table' and info.ourHeros[1] then
                            return tonumber(info.ourHeros[1].rankLevel or info.ourHeros[1].level or info.ourHeros[1].lockLevel or 1) or 1
                          end
                          return 1
                        end
                        local payload_player = type(info.playerInfo) == 'table' and info.playerInfo or {}
                        local player_name = tostring(payload_player.name or info.playerName or info.nickName or info.nickname or info.name or ('P' .. tostring(info.ourPlayerId or 0)))
                        local player_level = tonumber(info.playerLevel or info.level or payload_player.level or first_hero_rank()) or 1
                        if PlayerMgr and type(rawget(PlayerMgr,'PlayerInfo'))~='table' then
                          rawset(PlayerMgr, 'PlayerInfo', { uid = info.ourPlayerId or payload_player.uid or 0, head = payload_player.head or 0, name = player_name, level = player_level, headFrame = payload_player.headFrame or 0 })
                        elseif PlayerMgr and PlayerMgr.PlayerInfo then
                          PlayerMgr.PlayerInfo.uid = PlayerMgr.PlayerInfo.uid or info.ourPlayerId or 0
                          PlayerMgr.PlayerInfo.name = PlayerMgr.PlayerInfo.name or player_name
                          PlayerMgr.PlayerInfo.level = tonumber(PlayerMgr.PlayerInfo.level or 0) > 0 and PlayerMgr.PlayerInfo.level or player_level
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
                            local xs = is_our and {-3.05, -1.55, -1.22, -2.34, -3.42, -2.56} or {1.42, 2.76, 1.42, 2.7, 3.88, 3.42}
                            local ys = is_our and {-1.05, -0.92, -2.2, -1.58, -1.52, -2.48} or {-1.04, -1.34, -2.28, -2.46, -1.18, -2.5}
                            local zs = is_our and {-0.02, 0.0, -0.24, -0.12, -0.1, -0.28} or {-0.02, -0.1, -0.26, -0.3, -0.08, -0.32}
                            local ss = is_our and {1.0, 1.0, 0.96, 0.94, 0.92, 0.95} or {0.74, 0.68, 0.72, 0.68, 0.74, 0.68}
                            for idx=0,5 do
                              local go = CS.UnityEngine.GameObject(prefix .. '_Station_' .. tostring(idx))
                              go.transform:SetParent(root, false)
                              go.transform.localPosition = CS.UnityEngine.Vector3(xs[idx + 1] or 0, ys[idx + 1] or 0, zs[idx + 1] or 0)
                              go.transform.localScale = CS.UnityEngine.Vector3.one * (ss[idx + 1] or 1)
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
                                local first_variant = last_digit_base + 1
                                if first_variant ~= id then table.insert(candidates, {id=first_variant, kind='variant'}) end
                                if last_digit_base ~= id and last_digit_base ~= first_variant then table.insert(candidates, {id=last_digit_base, kind='base'}) end
                                local stage_base = math.floor(id / 100) * 100 + 10
                                if stage_base ~= id and stage_base ~= last_digit_base and stage_base ~= first_variant then table.insert(candidates, {id=stage_base, kind='base'}) end
                                for _, candidate in ipairs(candidates) do
                                  row = colon and orig(self_or_id, candidate.id) or orig(candidate.id)
                                  if row ~= nil then
                                    if candidate.kind == 'base' then
                                      inc_global('BATTLE90_MONSTER_BASE_FALLBACK_COUNT')
                                      rawset(_G, 'BATTLE90_MONSTER_BASE_FALLBACK_LAST', tostring(label)..':'..tostring(id)..'->'..tostring(candidate.id))
                                    else
                                      inc_global('BATTLE90_MONSTER_GROUP_VARIANT_COUNT')
                                      rawset(_G, 'BATTLE90_MONSTER_GROUP_VARIANT_LAST', tostring(label)..':'..tostring(id)..'->'..tostring(candidate.id))
                                    end
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
                              if not actor.IsExactActor then
                                if tonumber(actor.ResolvedActorId) == 0 then
                                  inc_global('BATTLE90_SKIN_MISSING_ACTOR_COUNT')
                                else
                                  inc_global('BATTLE90_SKIN_VISUAL_FALLBACK_COUNT')
                                end
                              end
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
                                    if rawget(_G, 'BATTLE90_STANDING_SNAPSHOT_ONLY') == true then
                                      inc_global('BATTLE90_STANDING_SNAPSHOT_PREVIEW_SKIP_COUNT')
                                    elseif CS.GirlsWar.BattleRuntimeSpineActorFactory.PreviewAction(hero_id, action_type, fire_hero_id, skill_did) then
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
                                if rawget(_G, 'BATTLE90_STANDING_SNAPSHOT_ONLY') == true then
                                  inc_global('BATTLE90_STANDING_SNAPSHOT_PREVIEW_SKIP_COUNT')
                                elseif hero_id ~= 0 and CS.GirlsWar.BattleRuntimeSpineActorFactory.PreviewAction(hero_id, action_type, 0, skill_id) then
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
                if (ShouldCaptureSequenceFrame(frame + 1))
                    CaptureVisualSequenceFrame(sequenceCaptures, visualCamera, frame + 1);
            }

            if (string.IsNullOrEmpty(failStage) && configuredStandingSnapshotOnly)
                NormalizeStandingSnapshotActors(result);

            TryReadLuaDiagnostics(env, result);
            CollectVisualDiagnostics(result, visualCamera);
            CaptureVisualEvidence(result, visualCamera);
            result.captureSequenceFrameCount = sequenceCaptures.Count;
            result.captureSequencePaths = string.Join(";", sequenceCaptures.ToArray());
            PopulateFinalResultState(result, stages, battleEntered, failStage, err);
            WriteResult(result);
            AppendVisualDiagnostics(result);
            try { env?.Dispose(); } catch { }

            PopulateFinalResultState(result, stages, battleEntered, failStage, err);
            WriteResult(result);
            LastStatus = result.status;
            LastExitCode = result.status == "playmode_bootstrap_entered_battle" ? 0 : 1;
            Completed = true;
        }

        private void PopulateFinalResultState(Result result, List<string> stages, bool battleEntered, string failStage, string err)
        {
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
            try { result.skinMissingActorCount = env.Global.Get<int>("BATTLE90_SKIN_MISSING_ACTOR_COUNT"); } catch { }
            try { result.skinVisualFallbackCount = env.Global.Get<int>("BATTLE90_SKIN_VISUAL_FALLBACK_COUNT"); } catch { }
            try { result.skinLastActor = env.Global.Get<string>("BATTLE90_SKIN_LAST_ACTOR") ?? ""; } catch { }
            result.runtimeActorAttachCount = BattleRuntimeSpineActorFactory.AttachCount;
            result.runtimeActorPrefabCount = BattleRuntimeSpineActorFactory.PrefabCount;
            result.runtimeActorSpineCount = BattleRuntimeSpineActorFactory.SpineCount;
            result.runtimeActorVisualFallbackCount = BattleRuntimeSpineActorFactory.VisualFallbackCount;
            result.runtimeActorQuadFallbackCount = BattleRuntimeSpineActorFactory.QuadFallbackCount;
            result.runtimeActorMissingAssetCount = BattleRuntimeSpineActorFactory.MissingAssetCount;
            result.runtimeMaterialShaderFallbackCount = BattleRuntimeSpineActorFactory.RuntimeMaterialShaderFallbackCount;
            result.runtimeSpineAtlasMaterialFallbackCount = BattleRuntimeSpineActorFactory.RuntimeSpineAtlasMaterialFallbackCount;
            result.runtimeBlendModeMaterialFallbackCount = BattleRuntimeSpineActorFactory.RuntimeBlendModeMaterialFallbackCount;
            result.runtimeMonsterModelResolveCount = BattleRuntimeSpineActorFactory.MonsterModelResolveCount;
            result.runtimeMonsterModelExactResolveCount = BattleRuntimeSpineActorFactory.MonsterModelExactResolveCount;
            result.runtimeMonsterModelBaseFallbackResolveCount = BattleRuntimeSpineActorFactory.MonsterModelBaseFallbackResolveCount;
            result.runtimeMonsterModelMissingExactRowCount = BattleRuntimeSpineActorFactory.MonsterModelMissingExactRowCount;
            result.runtimePreviewActionCount = BattleRuntimeSpineActorFactory.PreviewActionCount;
            result.runtimePreviewCompletedCount = BattleRuntimeSpineActorFactory.PreviewCompletedCount;
            result.runtimePreviewMissCount = BattleRuntimeSpineActorFactory.PreviewMissCount;
            result.runtimeSourceSkillSpecResolveCount = BattleRuntimeSpineActorFactory.SourceSkillSpecResolveCount;
            result.runtimeSkillTimelineBlockedCount = BattleRuntimeSpineActorFactory.SkillTimelineBlockedCount;
            result.runtimeSkillHitEffectCount = BattleRuntimeSpineActorFactory.HitEffectCount;
            result.runtimeSourceSkillPrefabAttemptCount = BattleRuntimeSpineActorFactory.SourceSkillPrefabAttemptCount;
            result.runtimeSourceSkillPrefabLoadCount = BattleRuntimeSpineActorFactory.SourceSkillPrefabLoadCount;
            result.runtimeSourceSkillPrefabInstantiateCount = BattleRuntimeSpineActorFactory.SourceSkillPrefabInstantiateCount;
            result.runtimeSourceSkillPrefabRenderableCount = BattleRuntimeSpineActorFactory.SourceSkillPrefabRenderableCount;
            result.runtimeSourceSkillPrefabRendererTotalCount = BattleRuntimeSpineActorFactory.SourceSkillPrefabRendererTotalCount;
            result.runtimeSourceSkillPrefabParticlePlayCount = BattleRuntimeSpineActorFactory.SourceSkillPrefabParticlePlayCount;
            result.runtimeSourceSkillPrefabAnimatorPlayCount = BattleRuntimeSpineActorFactory.SourceSkillPrefabAnimatorPlayCount;
            result.runtimeSourceSkillPrefabDirectorCount = BattleRuntimeSpineActorFactory.SourceSkillPrefabDirectorCount;
            result.runtimeSourceSkillPrefabDirectorPlayedCount = BattleRuntimeSpineActorFactory.SourceSkillPrefabDirectorPlayedCount;
            result.runtimeSourceSkillPrefabDirectorBlockedCount = BattleRuntimeSpineActorFactory.SourceSkillPrefabDirectorBlockedCount;
            result.runtimeSourceSkillPrefabPlayableLoadCount = BattleRuntimeSpineActorFactory.SourceSkillPrefabPlayableLoadCount;
            result.runtimeSourceSkillCommonEffectInstantiateCount = BattleRuntimeSpineActorFactory.SourceSkillCommonEffectInstantiateCount;
            result.runtimeSourceSkillPrefabWorldCutinSuppressedCount = BattleRuntimeSpineActorFactory.SourceSkillPrefabWorldCutinSuppressedCount;
            result.runtimeSourceSkillPrefabFailureCount = BattleRuntimeSpineActorFactory.SourceSkillPrefabFailureCount;
            result.runtimeUltimateCutinOverlayRequestCount = ultimateCutinOverlayRequestCount;
            result.runtimeUltimateCutinOverlayShownCount = ultimateCutinOverlayShownCount;
            result.runtimeUltimateCutinOverlaySourceSpriteCount = ultimateCutinOverlaySourceSpriteCount;
            result.runtimeUltimateCutinOverlaySummary = ultimateCutinOverlaySummary;
            result.runtimeActorLastSummary = BattleRuntimeSpineActorFactory.LastSummary;
            result.runtimeMonsterModelResolveSummary = BattleRuntimeSpineActorFactory.MonsterModelResolveSummary;
            result.runtimeMonsterModelResolveTrace = BattleRuntimeSpineActorFactory.MonsterModelResolveTraceSummary;
            result.runtimeSkillSpecSummary = BattleRuntimeSpineActorFactory.LastSkillSpecSummary;
            result.runtimeSkillSpecTrace = BattleRuntimeSpineActorFactory.SkillSpecTraceSummary;
            result.runtimeSourceSkillPrefabSummary = BattleRuntimeSpineActorFactory.LastSourceSkillPrefabSummary;
            result.runtimeSourceSkillPrefabTrace = BattleRuntimeSpineActorFactory.SourceSkillPrefabTraceSummary;
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
            try { result.standingSnapshotPreviewSkipCount = env.Global.Get<int>("BATTLE90_STANDING_SNAPSHOT_PREVIEW_SKIP_COUNT"); } catch { }
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
                      ' skinMissing='..tostring(rawget(_G,'BATTLE90_SKIN_MISSING_ACTOR_COUNT') or 0)..
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
                " runtimeMaterialFallback=" + result.runtimeMaterialShaderFallbackCount +
                " runtimeAtlasMaterialFallback=" + result.runtimeSpineAtlasMaterialFallbackCount +
                " runtimeBlendMaterialFallback=" + result.runtimeBlendModeMaterialFallbackCount +
                " runtimeMonsterModelResolve=" + result.runtimeMonsterModelResolveCount +
                " runtimeMonsterExact=" + result.runtimeMonsterModelExactResolveCount +
                " runtimeMonsterBaseFallback=" + result.runtimeMonsterModelBaseFallbackResolveCount +
                " runtimeMonsterMissingExactRow=" + result.runtimeMonsterModelMissingExactRowCount +
                " runtimePreview=" + result.runtimePreviewActionCount +
                " runtimePreviewDone=" + result.runtimePreviewCompletedCount +
                " runtimePreviewMiss=" + result.runtimePreviewMissCount +
                " runtimeSourceSkillSpec=" + result.runtimeSourceSkillSpecResolveCount +
                " runtimeSkillTimelineBlocked=" + result.runtimeSkillTimelineBlockedCount +
                " runtimeHitEffect=" + result.runtimeSkillHitEffectCount +
                " sourceSkillPrefabInst=" + result.runtimeSourceSkillPrefabInstantiateCount +
                " sourceSkillPrefabRenderable=" + result.runtimeSourceSkillPrefabRenderableCount +
                " sourceSkillCommonEffect=" + result.runtimeSourceSkillCommonEffectInstantiateCount +
                " sourceSkillDirectorPlayed=" + result.runtimeSourceSkillPrefabDirectorPlayedCount +
                " sourceSkillDirectorBlocked=" + result.runtimeSourceSkillPrefabDirectorBlockedCount +
                " sourceSkillWorldCutinSuppressed=" + result.runtimeSourceSkillPrefabWorldCutinSuppressedCount;
        }

        private static void AppendVisualDiagnostics(Result result)
        {
            result.diagSummary = (result.diagSummary ?? "") +
                " visualActors=" + result.visualActorHandleCount +
                " visualRenderers=" + result.visualActorRendererCount +
                " visualScreenArea=" + result.visualActorScreenAreaRatio.ToString("0.######") +
                " visualHeightMinMax=" + result.visualActorMinHeightPixels.ToString("0.#") + "/" + result.visualActorMaxHeightPixels.ToString("0.#") +
                " visualMaxOverlap=" + result.visualActorMaxOverlapRatio.ToString("0.######") +
                " visualOverlapPairs=" + result.visualActorOverlappedPairCount +
                " visualMinCenterPx=" + result.visualActorMinCenterDistancePixels.ToString("0.##") +
                " visualShadows=" + result.visualActorShadowCount +
                " visualAnimated=" + result.visualActorAnimatedCount +
                " visualHudSlots=" + result.visualHudSkillSlotCount +
                " visualHudSourceSprites=" + result.visualHudSourceSpriteCount +
                " visualHudDamage=" + result.visualHudDamageTextCount +
                " visualHudSource=" + result.visualHudDataSource +
                " visualHudHpChanged=" + result.visualHudHpChangedCount +
                " visualHudDamageValue=" + result.visualHudDamageValue +
                " visualHudPlayer=" + result.visualHudPlayerName + "/Lv" + result.visualHudPlayerLevel +
                " visualHudEnemy=" + result.visualHudEnemyName + "/Lv" + result.visualHudEnemyLevel +
                " ultimateCutinShown=" + result.runtimeUltimateCutinOverlayShownCount +
                " captureNonDark=" + result.captureNonDarkSampleCount +
                " standingSnapshot=" + result.standingSnapshotOnly +
                " standingPreviewSkip=" + result.standingSnapshotPreviewSkipCount +
                " standingActorsNormalized=" + result.standingSnapshotActorNormalizeCount;
        }

        private static void NormalizeStandingSnapshotActors(Result result)
        {
            EnsureStandingSnapshotActorPool();

            var handles = UnityEngine.Object.FindObjectsOfType<BattleRuntimeActorHandle>();
            if (handles == null || handles.Length == 0)
                return;

            Array.Sort(handles, (a, b) => StandingSnapshotSortKey(a).CompareTo(StandingSnapshotSortKey(b)));

            var root = GameObject.Find("B90_StandingSnapshotActors");
            if (root == null)
                root = new GameObject("B90_StandingSnapshotActors");

            var ourSlot = 0;
            var enemySlot = 0;
            var payload = LoadConfiguredBattlePayload();
            var summaries = new List<string>();
            foreach (var handle in handles)
            {
                if (handle == null)
                    continue;

                var fallbackSlot = handle.IsOurHero ? ourSlot++ : enemySlot++;
                var heroId = handle.RequestedHeroId;
                var heroDid = handle.RequestedHeroDid != 0 ? handle.RequestedHeroDid : handle.ResolvedActorId;
                var isMonster = !handle.IsOurHero && (heroId < 0 || heroDid >= 1100000 || handle.ResolvedActorId >= 3000);
                var slot = ResolvePayloadFormationSlot(payload, handle.IsOurHero, heroId, heroDid, isMonster, fallbackSlot);
                handle.transform.SetParent(root.transform, true);
                var footPosition = PreviewFormationPosition(handle.IsOurHero, slot);
                handle.transform.position = footPosition;
                handle.transform.localRotation = Quaternion.identity;
                var factor = NormalizeStandingSnapshotActorHeight(handle);
                AlignActorBodyBottomToFormationFoot(handle, footPosition);
                ApplyFormationRenderOrder(handle, slot);
                handle.RememberBasePose();

                var actorKey = handle.RequestedHeroDid != 0 ? handle.RequestedHeroDid : handle.RequestedHeroId;
                summaries.Add(actorKey + "@p" + (slot + 1) + "x" + factor.ToString("0.###"));
                result.standingSnapshotActorNormalizeCount++;
            }

            result.standingSnapshotActorSummary = string.Join(";", summaries.ToArray());
        }

        private static void EnsureStandingSnapshotActorPool()
        {
            var root = GameObject.Find("B90_StandingSnapshotDirectActors");
            if (root == null)
                root = new GameObject("B90_StandingSnapshotDirectActors");

            for (var i = 0; configuredHudCardActorIds != null && i < configuredHudCardActorIds.Length; i++)
            {
                var actorId = configuredHudCardActorIds[i];
                if (actorId == 0 || HasRuntimeActorHandle(actorId, true))
                    continue;
                BattleRuntimeSpineActorFactory.AttachActor(actorId, actorId, root.transform, true, false, actorId);
            }

            for (var i = 0; i < StandingSnapshotEnemyActorIds.Length; i++)
            {
                var actorId = StandingSnapshotEnemyActorIds[i];
                if (HasRuntimeActorHandle(actorId, false))
                    continue;
                BattleRuntimeSpineActorFactory.AttachActor(actorId, actorId, root.transform, false, true, actorId);
            }
        }

        private static bool HasRuntimeActorHandle(int actorId, bool isOurHero)
        {
            var handles = UnityEngine.Object.FindObjectsOfType<BattleRuntimeActorHandle>();
            foreach (var handle in handles)
            {
                if (handle == null || handle.IsOurHero != isOurHero)
                    continue;
                var key = handle.RequestedHeroDid != 0 ? handle.RequestedHeroDid : handle.RequestedHeroId;
                if (key == actorId)
                    return true;
            }
            return false;
        }

        private static int StandingSnapshotSortKey(BattleRuntimeActorHandle handle)
        {
            if (handle == null)
                return int.MaxValue;

            var actorKey = handle.RequestedHeroDid != 0 ? handle.RequestedHeroDid : handle.RequestedHeroId;
            if (handle.IsOurHero)
            {
                for (var i = 0; configuredHudCardActorIds != null && i < configuredHudCardActorIds.Length; i++)
                {
                    if (configuredHudCardActorIds[i] == actorKey)
                        return i;
                }
                return 50 + Mathf.Abs(actorKey % 1000);
            }

            return 1000 + Mathf.Abs(actorKey % 1000);
        }

        private static float NormalizeStandingSnapshotActorHeight(BattleRuntimeActorHandle handle)
        {
            if (handle == null || !TryCollectRendererBounds(handle.gameObject, out var bounds))
                return 1f;

            var height = bounds.size.y;
            if (height <= 0.01f)
                return 1f;

            var target = StandingSnapshotTargetHeight(handle);
            var factor = Mathf.Clamp(target / height, 0.08f, 8f);
            handle.transform.localScale = handle.transform.localScale * factor;
            if (handle.SkeletonAnimation != null)
            {
                handle.SkeletonAnimation.Update(0f);
                handle.SkeletonAnimation.LateUpdate();
            }
            return factor;
        }

        private static float StandingSnapshotTargetHeight(BattleRuntimeActorHandle handle)
        {
            if (handle == null)
                return 2.0f;
            if (!handle.IsOurHero)
                return handle.ResolvedActorId == 3001 ? 1.92f : 1.82f;

            switch (handle.ResolvedActorId)
            {
                case 1001: return 2.02f;
                case 1002: return 1.82f;
                case 1003: return 2.08f;
                case 1005: return 1.96f;
                case 1010: return 2.28f;
                default: return 1.95f;
            }
        }

        private static void ApplyFormationRenderOrder(BattleRuntimeActorHandle handle, int slot)
        {
            if (handle == null)
                return;

            var row = Mathf.Clamp(slot, 0, 5) % 3;
            var columnOffset = slot >= 3 ? -4 : 0;
            var order = (handle.IsOurHero ? 120 : 110) + row * 20 + columnOffset;
            var renderers = handle.GetComponentsInChildren<Renderer>(true);
            foreach (var renderer in renderers)
            {
                if (renderer == null)
                    continue;
                if (string.Equals(renderer.gameObject.name, "B90_GroundShadow", StringComparison.Ordinal))
                    renderer.sortingOrder = order - 8;
                else
                    renderer.sortingOrder = order;
            }
        }

        private static bool TryCollectRendererBounds(GameObject root, out Bounds bounds)
        {
            bounds = new Bounds();
            if (root == null)
                return false;

            var renderers = root.GetComponentsInChildren<Renderer>(true);
            var hasBounds = false;
            foreach (var renderer in renderers)
            {
                if (renderer == null || !renderer.enabled || !renderer.gameObject.activeInHierarchy)
                    continue;
                if (!hasBounds)
                {
                    bounds = renderer.bounds;
                    hasBounds = true;
                }
                else
                {
                    bounds.Encapsulate(renderer.bounds);
                }
            }

            return hasBounds;
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
            // REAL game camera values (not guessed): Common/Define.lua OG_DESIGN_SIZE=5,
            // OGAdjustSizeRate=1.0 -> CameraCtrlOriginalOrthographicSize = 5*1.0 = 5.0; and PNB
            // DoCameraCtrlReset -> CameraMgr:SetCameraPosition(NormalBattle, Vector3(0,0,-50)).
            camera.orthographicSize = 5.0f;
            camera.transform.position = new Vector3(0f, 0f, -10f);
            camera.transform.rotation = Quaternion.identity;

            var stage = GameObject.Find("B90_VisualStage");
            if (stage == null)
                stage = new GameObject("B90_VisualStage");

            if (stage.transform.Find("B90_Map_11003_Root") == null)
                CreateMapSprite(stage.transform);
            if (stage.transform.Find("B90_ReferenceBattleHud") == null)
                CreateReferenceBattleHud(stage.transform, camera);

            return camera;
        }

        private static void CreateMapSprite(Transform parent)
        {
            var root = new GameObject("B90_Map_11003_Root");
            root.transform.SetParent(parent, false);
            CreateMapFill(root.transform);
            var created =
                // bottomY refit for camera y=0, ortho 5.0 (view y -5..+5) at the wider map scale:
                // ground fills the lower (where actors stand), buildings mid, skyline top.
                CreateMapLayer(root.transform, "Map_11003_5.png", "B90_Map_11003_BackVillage", VisualMapWidthUnits, -1.0f, 2f, -130) |
                CreateMapLayer(root.transform, "Map_11003_3.png", "B90_Map_11003_Skyline", VisualMapWidthUnits, 2.0f, 1.95f, -125) |
                CreateMapLayer(root.transform, "Map_11003_2.png", "B90_Map_11003_Ground", VisualMapWidthUnits, -5.0f, 1.9f, -120);

            if (!created)
                CreateMapLayer(root.transform, "Map_11001_2.png", "B90_Map_11001_Fallback", 10.5f, -2.1f, 2f, -120);
        }

        private static void CreateMapFill(Transform parent)
        {
            var go = new GameObject("B90_Map_11003_SunsetFill");
            go.transform.SetParent(parent, false);
            go.transform.localPosition = new Vector3(0f, 0f, 2.1f);
            // Cover the FULL real-camera view (ortho 5.0 -> 22.46 x 10 world units) so there are
            // no black borders behind the village strips. Sized with margin and centered at camera.
            go.transform.localScale = new Vector3(24f, 11f, 1f);
            var renderer = go.AddComponent<SpriteRenderer>();
            renderer.sprite = SolidSprite();
            renderer.color = new Color(0.38f, 0.22f, 0.17f, 1f);
            renderer.sortingOrder = -150;
        }

        private static bool CreateMapLayer(Transform parent, string fileName, string objectName, float widthUnits, float bottomY, float z, int sortingOrder)
        {
            var path = Path.Combine(Application.dataPath, "RestoreData", "battle", "VisualAssets", "map", fileName);
            if (!File.Exists(path))
                return false;

            var texture = new Texture2D(2, 2, TextureFormat.RGBA32, false);
            texture.name = objectName + "_Texture";
            if (!texture.LoadImage(File.ReadAllBytes(path)))
                return false;

            var pixelsPerUnit = Mathf.Max(1f, texture.width / widthUnits);
            var heightUnits = texture.height / pixelsPerUnit;
            var sprite = Sprite.Create(texture, new Rect(0, 0, texture.width, texture.height), new Vector2(0.5f, 0.5f), pixelsPerUnit);
            sprite.name = objectName + "_Sprite";

            var go = new GameObject(objectName);
            go.transform.SetParent(parent, false);
            go.transform.localPosition = new Vector3(0f, bottomY + heightUnits * 0.5f, z);
            var renderer = go.AddComponent<SpriteRenderer>();
            renderer.sprite = sprite;
            renderer.sortingOrder = sortingOrder;
            return true;
        }

        private static void CreateReferenceBattleHud(Transform parent, Camera camera)
        {
            var timeline = BattleHudTimeline.Load(configuredPayloadFileName, configuredFrameBudget);
            var initial = timeline.FrameAt(0);
            var canvasGo = new GameObject("B90_ReferenceBattleHud");
            canvasGo.transform.SetParent(parent, false);
            var canvas = canvasGo.AddComponent<Canvas>();
            canvas.renderMode = RenderMode.ScreenSpaceCamera;
            canvas.worldCamera = camera;
            canvas.planeDistance = 1f;
            canvas.sortingOrder = 1000;
            var scaler = canvasGo.AddComponent<CanvasScaler>();
            scaler.uiScaleMode = CanvasScaler.ScaleMode.ScaleWithScreenSize;
            scaler.referenceResolution = new Vector2(CaptureWidth, CaptureHeight);
            canvasGo.AddComponent<GraphicRaycaster>();

            CreateTopCombatantHud(canvasGo.transform, "Our", timeline.OurActorId, initial.OurName, initial.OurLevelText, new Vector2(332f, -10f), true, initial.OurHpFill);
            CreateTopCombatantHud(canvasGo.transform, "Enemy", timeline.EnemyActorId, initial.EnemyName, initial.EnemyLevelText, new Vector2(-332f, -10f), false, initial.EnemyHpFill);
            CreateSpritePanel(canvasGo.transform, "VsLabel", new Vector2(0f, -36f), new Vector2(56f, 56f),
                LoadRestoreHudSprite("download_artsources_uispriteres_uibattle.assetbundle_1943103129572916828_multilang_T_duijue.png"),
                new Color(1f, 0.74f, 0.18f, 1f), TextAnchor.UpperCenter, true);
            CreateLabel(canvasGo.transform, "RoundLabel", initial.RoundText, new Vector2(0f, -72f), new Vector2(86f, 24f), 16, Color.white, TextAnchor.MiddleCenter, TextAnchor.UpperCenter);
            CreateLabel(canvasGo.transform, "WaveLabel", initial.WaveText, new Vector2(140f, -76f), new Vector2(110f, 22f), 13, Color.white, TextAnchor.MiddleCenter, TextAnchor.UpperCenter);

            var cardCount = Mathf.Clamp(timeline.SkillCardCount, 1, 6);
            CreatePanel(canvasGo.transform, "SkillCardDock", new Vector2(0f, 10f), new Vector2(32f + cardCount * 88f, 92f), new Color(0.02f, 0.016f, 0.016f, 0.58f), TextAnchor.LowerCenter);
            for (var i = 0; i < cardCount; i++)
                CreateSkillCard(canvasGo.transform, i, cardCount);

            if (!configuredStandingSnapshotOnly)
                CreateDamageNumber(canvasGo.transform, "DamagePopup_Dynamic", initial.DamageText, initial.DamagePosition);
            CreateSideButton(canvasGo.transform, "AutoButton", "\uc790\ub3d9", "download_artsources_uispriteres_uibattle.assetbundle_-3599735801722606192_btn_zidong_on.png", new Vector2(-18f, 78f));
            CreateSideButton(canvasGo.transform, "SkipButton", "\uc2a4\ud0b5", "download_artsources_uispriteres_uibattle.assetbundle_-668223970973157061_btn_Skip.png", new Vector2(-18f, 18f));
            CreateSideButton(canvasGo.transform, "SpeedButton", "x2", "download_artsources_uispriteres_uibattle.assetbundle_988442367583666760_btn_x2_1.png", new Vector2(-18f, -42f));

            var controller = canvasGo.AddComponent<BattleReferenceHudController>();
            controller.Configure(timeline);
        }

        private static void CreateBattleGauge(Transform parent, string name, Vector2 anchoredPosition, bool left, float fill)
        {
            var root = CreatePanel(parent, name, anchoredPosition, new Vector2(230f, 32f), new Color(0f, 0f, 0f, 0f), left ? TextAnchor.UpperLeft : TextAnchor.UpperRight);
            var bg = CreateSpritePanel(root.transform, name + "_HpBg", Vector2.zero, new Vector2(228f, 30f),
                LoadRestoreHudSprite("download_artsources_uispriteres_uibattle.assetbundle_6533218848006892483_ba_xuecao_bg1.png"),
                new Color(0.06f, 0.05f, 0.05f, 0.88f), TextAnchor.MiddleCenter, false);
            var hp = CreateSpritePanel(bg.transform, name + "_HpFill", Vector2.zero, new Vector2(222f, 28f),
                LoadRestoreHudSprite("download_artsources_uispriteres_uibattle.assetbundle_7955921820150679454_ba_xuecao_bg3.png"),
                new Color(0.35f, 0.95f, 0.25f, 0.95f), TextAnchor.MiddleCenter, false);
            var hpImage = hp.GetComponent<Image>();
            hpImage.type = Image.Type.Filled;
            hpImage.fillMethod = Image.FillMethod.Horizontal;
            hpImage.fillOrigin = left ? 0 : 1;
            hpImage.fillAmount = Mathf.Clamp01(fill);

            var furyBg = CreateSpritePanel(root.transform, name + "_FuryBg", new Vector2(0f, -16f), new Vector2(182f, 8f),
                LoadRestoreHudSprite("download_artsources_uispriteres_uibattle.assetbundle_-3873075873417088988_bg_nuqitiao2.png"),
                new Color(0.08f, 0.06f, 0.04f, 0.9f), TextAnchor.MiddleCenter, false);
            var fury = CreateSpritePanel(furyBg.transform, name + "_FuryFill", Vector2.zero, new Vector2(178f, 6f),
                LoadRestoreHudSprite("download_artsources_uispriteres_uibattle.assetbundle_4489750091565491747_im_nuqitiao.png"),
                new Color(1f, 0.72f, 0.2f, 0.95f), TextAnchor.MiddleCenter, false);
            var furyImage = fury.GetComponent<Image>();
            furyImage.type = Image.Type.Filled;
            furyImage.fillMethod = Image.FillMethod.Horizontal;
            furyImage.fillOrigin = left ? 0 : 1;
            furyImage.fillAmount = left ? 0.92f : 0.68f;
        }

        private static void CreateTopCombatantHud(Transform parent, string prefix, int actorId, string name, string level, Vector2 badgePosition, bool left, float hpFill)
        {
            var anchor = left ? TextAnchor.UpperLeft : TextAnchor.UpperRight;
            var badge = CreateSpritePanel(parent, prefix + "HeadFrame", badgePosition, new Vector2(72f, 72f),
                LoadRestoreHudSprite("download_artsources_uispriteres_uicommonother.assetbundle_9178922751791648479_BG_touxiangkuang.png"),
                new Color(0.08f, 0.06f, 0.08f, 0.86f), anchor, true);
            var image = CreatePanel(badge.transform, prefix + "HeadImage", Vector2.zero, new Vector2(54f, 54f), new Color(0.2f, 0.18f, 0.24f, 0.96f), TextAnchor.MiddleCenter);
            SetImageSprite(image, HeadSpriteForActor(actorId), new Color(0.22f, 0.18f, 0.24f, 0.95f), true);

            var textX = left ? badgePosition.x + 78f : badgePosition.x - 78f;
            var nameAnchor = left ? TextAnchor.UpperLeft : TextAnchor.UpperRight;
            CreateLabel(parent, prefix + "NameLabel", name, new Vector2(textX, -12f), new Vector2(206f, 24f), 18, Color.white, left ? TextAnchor.MiddleLeft : TextAnchor.MiddleRight, nameAnchor);
            CreateLabel(parent, prefix + "LevelLabel", level, new Vector2(left ? badgePosition.x + 20f : badgePosition.x - 20f, -72f), new Vector2(74f, 22f), 16, Color.white, TextAnchor.MiddleCenter, anchor);
            CreateBattleGauge(parent, prefix + "HpGauge", new Vector2(left ? badgePosition.x + 76f : badgePosition.x - 76f, -38f), left, hpFill);
        }

        private static void CreateSkillCard(Transform parent, int index, int totalCount)
        {
            var x = (index - (Mathf.Max(1, totalCount) - 1) * 0.5f) * 88f;
            var actorId = HudCardActorId(index);
            var card = CreatePanel(parent, "SkillCard_" + index, new Vector2(x, 18f), new Vector2(78f, 90f), new Color(0f, 0f, 0f, 0f), TextAnchor.LowerCenter);
            CreateSpritePanel(card.transform, "SkillCard_" + index + "_Frame", new Vector2(0f, 45f), new Vector2(72f, 72f),
                LoadRestoreHudSprite("download_artsources_uispriteres_uicommonother.assetbundle_4043117267995258628_BG_zhuangbeikuang_3.png"),
                actorId == 0 ? new Color(0.07f, 0.055f, 0.08f, 0.78f) : new Color(0.45f, 0.24f, 0.72f, 0.96f),
                TextAnchor.LowerCenter, false);

            if (actorId == 0)
            {
                var locked = CreatePanel(card.transform, "SkillCard_" + index + "_Locked", new Vector2(0f, 45f), new Vector2(62f, 62f), new Color(0.03f, 0.025f, 0.03f, 0.82f), TextAnchor.LowerCenter);
                CreateSpritePanel(locked.transform, "SkillCard_" + index + "_LockIcon", Vector2.zero, new Vector2(22f, 22f),
                    LoadRestoreHudSprite("download_artsources_uispriteres_uibattle.assetbundle_5634039594450520577_IC_lock.png"),
                    new Color(0.35f, 0.32f, 0.4f, 0.9f), TextAnchor.MiddleCenter, true);
                CreatePanel(card.transform, "SkillCard_" + index + "_FuryEmpty", new Vector2(0f, 8f), new Vector2(58f, 8f), new Color(0.12f, 0.09f, 0.08f, 0.75f), TextAnchor.LowerCenter);
                return;
            }

            var portrait = CreatePanel(card.transform, "SkillCard_" + index + "_Portrait", new Vector2(0f, 47f), new Vector2(60f, 60f), new Color(0.16f, 0.12f, 0.2f, 0.96f), TextAnchor.LowerCenter);
            SetImageSprite(portrait, HeroCardHeadSpriteForActor(actorId), new Color(0.18f, 0.14f, 0.22f, 0.95f), false);
            CreateLabel(card.transform, "SkillCard_" + index + "_Rank", "SR", new Vector2(-25f, 75f), new Vector2(34f, 18f), 15, new Color(0.95f, 0.16f, 1f, 1f), TextAnchor.MiddleCenter);
            CreateSpritePanel(card.transform, "SkillCard_" + index + "_FuryBg", new Vector2(0f, 8f), new Vector2(62f, 9f),
                LoadRestoreHudSprite("download_artsources_uispriteres_uibattle.assetbundle_-3873075873417088988_bg_nuqitiao2.png"),
                new Color(0.08f, 0.06f, 0.04f, 0.9f), TextAnchor.LowerCenter, false);
            var fill = CreateSpritePanel(card.transform, "SkillCard_" + index + "_FuryFill", new Vector2(0f, 8f), new Vector2(58f, 7f),
                LoadRestoreHudSprite("download_artsources_uispriteres_uibattle.assetbundle_4489750091565491747_im_nuqitiao.png"),
                new Color(1f, 0.72f, 0.2f, 0.96f), TextAnchor.LowerCenter, false);
            var fillImage = fill.GetComponent<Image>();
            fillImage.type = Image.Type.Filled;
            fillImage.fillMethod = Image.FillMethod.Horizontal;
            fillImage.fillOrigin = 0;
            fillImage.fillAmount = index == 0 ? 0.34f : (index == 1 ? 0.58f : 0.76f);
        }

        private static void CreateHeadBadge(Transform parent, string name, int actorId, Vector2 anchoredPosition, TextAnchor anchor)
        {
            var badge = CreatePanel(parent, name, anchoredPosition, new Vector2(58f, 58f), new Color(0.08f, 0.06f, 0.08f, 0.86f), anchor);
            var image = CreatePanel(badge.transform, name + "_Image", Vector2.zero, new Vector2(50f, 50f), new Color(0.58f, 0.44f, 0.72f, 0.92f), TextAnchor.MiddleCenter);
            SetImageSprite(image, HeadSpriteForActor(actorId), new Color(0.58f, 0.44f, 0.72f, 0.92f));
        }

        private static Sprite HeadSpriteForActor(int actorId)
        {
            switch (actorId)
            {
                case 1001:
                    return LoadExtractedSprite("b_d7eb2078b5de6a0d", "S", "6810259492667770510_battlehead1001.png");
                case 1003:
                    return LoadExtractedSprite("b_d7eb2078b5de6a0d", "S", "7544100942075933984_battlehead1003.png");
                case 1036:
                    return LoadExtractedSprite("b_d7eb2078b5de6a0d", "S", "4603583428255641265_battlehead1036.png");
                case 1002:
                    return LoadExtractedSprite("b_d7eb2078b5de6a0d", "S", "2376383340128146740_battlehead1002.png");
                case 1025:
                    return LoadExtractedSprite("b_d7eb2078b5de6a0d", "S", "7392474969561896688_battlehead1025.png");
                case 1005:
                    return LoadExtractedSprite("b_d7eb2078b5de6a0d", "S", "2579982693657195477_battlehead1005.png");
                case 1010:
                    return LoadExtractedSprite("b_d7eb2078b5de6a0d", "S", "3916718346668450318_battlehead1010.png");
                case 1029:
                    return LoadExtractedSprite("b_d7eb2078b5de6a0d", "S", "-4434463221669571637_battlehead1029.png");
                case 1034:
                    return LoadExtractedSprite("b_d7eb2078b5de6a0d", "S", "-4647259651891963510_battlehead1034.png");
                case 1037:
                    return LoadExtractedSprite("b_d7eb2078b5de6a0d", "S", "2620829852264607562_battlehead1037.png");
                case 1050:
                    return LoadExtractedSprite("b_d7eb2078b5de6a0d", "S", "6717487950183757051_battlehead1050.png");
                case 3001:
                    return LoadExtractedSprite("b_d7eb2078b5de6a0d", "S", "6089819859888126356_battlehead3001.png");
                case 3006:
                    return LoadExtractedSprite("b_d7eb2078b5de6a0d", "S", "864296424559781393_battlehead3006.png");
                default:
                    return null;
            }
        }

        private static Sprite HeroCardHeadSpriteForActor(int actorId)
        {
            switch (actorId)
            {
                case 1001:
                    return LoadExtractedSprite("b_6ca02dad4f8af848", "S", "-8812393343277448458_head1001.png");
                case 1036:
                    return LoadExtractedSprite("b_6ca02dad4f8af848", "S", "-1006758698391221614_head1036.png");
                case 1002:
                    return LoadExtractedSprite("b_6ca02dad4f8af848", "S", "-296058673418415307_head1002.png");
                case 1003:
                    return LoadExtractedSprite("b_6ca02dad4f8af848", "S", "-7705346780790675844_head1003.png");
                case 1005:
                    return LoadExtractedSprite("b_6ca02dad4f8af848", "S", "-5835513882802061140_head1005.png");
                case 1010:
                    return LoadExtractedSprite("b_6ca02dad4f8af848", "S", "-2155862227574749595_head1010.png");
                case 1034:
                    return LoadExtractedSprite("b_6ca02dad4f8af848", "S", "401204702686331365_head1034.png");
                default:
                    return HeadSpriteForActor(actorId);
            }
        }

        private static Sprite LoadRestoreHudSprite(string fileName)
        {
            var path = Path.GetFullPath(Path.Combine(
                Application.dataPath,
                "RestoreData",
                "battle",
                "PersistentHudSprites",
                "BATTLE42",
                fileName));
            return LoadSpriteFromPath(path);
        }

        private static Sprite LoadExtractedSprite(string bundleFolder, string imageFolder, string fileName)
        {
            var path = Path.GetFullPath(Path.Combine(
                Application.dataPath,
                "..",
                "..",
                "girlswar_merged_extracted",
                "extracted",
                "unity",
                "bundles",
                bundleFolder,
                "images",
                imageFolder,
                fileName));
            return LoadSpriteFromPath(path);
        }

        private static Sprite LoadSpriteFromPath(string path)
        {
            if (RuntimeUiSpriteCache.TryGetValue(path, out var cached))
                return cached;
            if (!File.Exists(path))
            {
                RuntimeUiSpriteCache[path] = null;
                return null;
            }

            var texture = new Texture2D(2, 2, TextureFormat.RGBA32, false);
            texture.name = Path.GetFileNameWithoutExtension(path) + "_Texture";
            if (!texture.LoadImage(File.ReadAllBytes(path)))
            {
                RuntimeUiSpriteCache[path] = null;
                return null;
            }

            var sprite = Sprite.Create(texture, new Rect(0, 0, texture.width, texture.height), new Vector2(0.5f, 0.5f), 100f);
            sprite.name = Path.GetFileNameWithoutExtension(path) + "_Sprite";
            RuntimeUiSpriteCache[path] = sprite;
            return sprite;
        }

        private static void SetImageSprite(GameObject go, Sprite sprite, Color fallbackColor)
        {
            SetImageSprite(go, sprite, fallbackColor, true);
        }

        private static void SetImageSprite(GameObject go, Sprite sprite, Color fallbackColor, bool preserveAspect)
        {
            if (go == null)
                return;
            var image = go.GetComponent<Image>();
            if (image == null)
                return;
            image.preserveAspect = preserveAspect;
            if (sprite == null)
            {
                image.sprite = SolidSprite();
                image.color = fallbackColor;
                return;
            }

            image.sprite = sprite;
            image.color = Color.white;
        }

        private static GameObject CreateSpritePanel(Transform parent, string name, Vector2 anchoredPosition, Vector2 size, Sprite sprite, Color fallbackColor, TextAnchor anchor, bool preserveAspect)
        {
            var go = CreatePanel(parent, name, anchoredPosition, size, fallbackColor, anchor);
            SetImageSprite(go, sprite, fallbackColor, preserveAspect);
            return go;
        }

        private static void CreateSideButton(Transform parent, string name, string label, string spriteFileName, Vector2 anchoredPosition)
        {
            var go = CreateSpritePanel(parent, name, anchoredPosition, new Vector2(72f, 58f),
                LoadRestoreHudSprite(spriteFileName), new Color(1f, 0.72f, 0.18f, 0.95f), TextAnchor.MiddleRight, true);
            if (go.GetComponent<Image>().sprite == SolidSprite())
                CreateLabel(go.transform, name + "_Text", label, Vector2.zero, new Vector2(62f, 24f), 13, new Color(0.17f, 0.11f, 0.03f, 1f), TextAnchor.MiddleCenter);
        }

        private static void CreateDamageNumber(Transform parent, string name, string text, Vector2 anchoredPosition)
        {
            CreateLabel(parent, name + "_Shadow", text, anchoredPosition + new Vector2(2f, -2f), new Vector2(104f, 32f), 26, new Color(0.08f, 0.055f, 0.04f, 0.86f), TextAnchor.MiddleCenter);
            var go = new GameObject(name);
            go.transform.SetParent(parent, false);
            var rect = go.AddComponent<RectTransform>();
            rect.anchorMin = new Vector2(0.5f, 0.5f);
            rect.anchorMax = new Vector2(0.5f, 0.5f);
            rect.pivot = new Vector2(0.5f, 0.5f);
            rect.anchoredPosition = anchoredPosition;
            rect.sizeDelta = new Vector2(104f, 32f);
            var label = go.AddComponent<Text>();
            label.text = text;
            label.font = Resources.GetBuiltinResource<Font>("LegacyRuntime.ttf");
            label.fontSize = 27;
            label.resizeTextForBestFit = true;
            label.resizeTextMinSize = 20;
            label.resizeTextMaxSize = 27;
            label.alignment = TextAnchor.MiddleCenter;
            label.fontStyle = FontStyle.BoldAndItalic;
            label.color = Color.white;
            label.raycastTarget = false;
        }

        private static GameObject CreatePanel(Transform parent, string name, Vector2 anchoredPosition, Vector2 size, Color color, TextAnchor anchor)
        {
            var go = new GameObject(name);
            go.transform.SetParent(parent, false);
            var rect = go.AddComponent<RectTransform>();
            ApplyAnchor(rect, anchor);
            rect.anchoredPosition = anchoredPosition;
            rect.sizeDelta = size;
            var image = go.AddComponent<Image>();
            image.sprite = SolidSprite();
            image.color = color;
            image.raycastTarget = false;
            return go;
        }

        private static void CreateLabel(Transform parent, string name, string text, Vector2 anchoredPosition, Vector2 size, int fontSize, Color color, TextAnchor alignment)
        {
            CreateLabel(parent, name, text, anchoredPosition, size, fontSize, color, alignment, TextAnchor.MiddleCenter);
        }

        private static void CreateLabel(Transform parent, string name, string text, Vector2 anchoredPosition, Vector2 size, int fontSize, Color color, TextAnchor alignment, TextAnchor anchor)
        {
            var go = new GameObject(name);
            go.transform.SetParent(parent, false);
            var rect = go.AddComponent<RectTransform>();
            ApplyAnchor(rect, anchor);
            rect.anchoredPosition = anchoredPosition;
            rect.sizeDelta = size;
            var label = go.AddComponent<Text>();
            label.text = text;
            label.font = Resources.GetBuiltinResource<Font>("LegacyRuntime.ttf");
            label.fontSize = fontSize;
            label.resizeTextForBestFit = true;
            label.resizeTextMinSize = Mathf.Max(8, fontSize - 4);
            label.resizeTextMaxSize = fontSize;
            label.alignment = alignment;
            label.color = color;
            label.raycastTarget = false;
        }

        private static void ApplyAnchor(RectTransform rect, TextAnchor anchor)
        {
            if (anchor == TextAnchor.UpperLeft)
            {
                rect.anchorMin = new Vector2(0f, 1f);
                rect.anchorMax = new Vector2(0f, 1f);
                rect.pivot = new Vector2(0f, 1f);
            }
            else if (anchor == TextAnchor.UpperRight)
            {
                rect.anchorMin = new Vector2(1f, 1f);
                rect.anchorMax = rect.anchorMin;
                rect.pivot = new Vector2(1f, 1f);
            }
            else if (anchor == TextAnchor.UpperCenter)
            {
                rect.anchorMin = new Vector2(0.5f, 1f);
                rect.anchorMax = rect.anchorMin;
                rect.pivot = new Vector2(0.5f, 1f);
            }
            else if (anchor == TextAnchor.MiddleRight)
            {
                rect.anchorMin = new Vector2(1f, 0.5f);
                rect.anchorMax = rect.anchorMin;
                rect.pivot = new Vector2(1f, 0.5f);
            }
            else if (anchor == TextAnchor.MiddleLeft)
            {
                rect.anchorMin = new Vector2(0f, 0.5f);
                rect.anchorMax = rect.anchorMin;
                rect.pivot = new Vector2(0f, 0.5f);
            }
            else if (anchor == TextAnchor.LowerCenter)
            {
                rect.anchorMin = new Vector2(0.5f, 0f);
                rect.anchorMax = new Vector2(0.5f, 0f);
                rect.pivot = new Vector2(0.5f, 0f);
            }
            else
            {
                rect.anchorMin = new Vector2(0.5f, 0.5f);
                rect.anchorMax = new Vector2(0.5f, 0.5f);
                rect.pivot = new Vector2(0.5f, 0.5f);
            }
        }

        private static Sprite solidSprite;

        private static Sprite SolidSprite()
        {
            if (solidSprite != null)
                return solidSprite;
            var texture = new Texture2D(1, 1, TextureFormat.RGBA32, false);
            texture.SetPixel(0, 0, Color.white);
            texture.Apply();
            solidSprite = Sprite.Create(texture, new Rect(0, 0, 1, 1), new Vector2(0.5f, 0.5f), 1f);
            return solidSprite;
        }

        private sealed class BattleReferenceHudController : MonoBehaviour
        {
            private BattleHudTimeline timeline;
            private Text ourName;
            private Text ourLevel;
            private Text enemyName;
            private Text enemyLevel;
            private Text roundLabel;
            private Text waveLabel;
            private Text damage;
            private Text damageShadow;
            private RectTransform damageRect;
            private RectTransform damageShadowRect;
            private Image ourHpFill;
            private Image enemyHpFill;
            private int localFrame;
            private float previousOurHp = -1f;
            private float previousEnemyHp = -1f;

            public int UpdateCount { get; private set; }
            public int HpChangedCount { get; private set; }
            public int DamageVisibleCount { get; private set; }
            public BattleHudFrame LastFrame { get; private set; }

            public void Configure(BattleHudTimeline value)
            {
                timeline = value ?? BattleHudTimeline.Fallback(configuredFrameBudget);
                Bind(transform);
                ApplyFrame(0);
            }

            private void Update()
            {
                localFrame++;
                ApplyFrame(localFrame);
            }

            private void Bind(Transform root)
            {
                ourName = TextByName(root, "OurNameLabel");
                ourLevel = TextByName(root, "OurLevelLabel");
                enemyName = TextByName(root, "EnemyNameLabel");
                enemyLevel = TextByName(root, "EnemyLevelLabel");
                roundLabel = TextByName(root, "RoundLabel");
                waveLabel = TextByName(root, "WaveLabel");
                damage = TextByName(root, "DamagePopup_Dynamic");
                damageShadow = TextByName(root, "DamagePopup_Dynamic_Shadow");
                damageRect = damage != null ? damage.GetComponent<RectTransform>() : null;
                damageShadowRect = damageShadow != null ? damageShadow.GetComponent<RectTransform>() : null;
                ourHpFill = ImageByName(root, "OurHpGauge_HpFill");
                enemyHpFill = ImageByName(root, "EnemyHpGauge_HpFill");
            }

            private void ApplyFrame(int frame)
            {
                if (timeline == null)
                    return;

                var hudFrame = timeline.FrameAt(frame);
                LastFrame = hudFrame;
                SetText(ourName, hudFrame.OurName);
                SetText(ourLevel, hudFrame.OurLevelText);
                SetText(enemyName, hudFrame.EnemyName);
                SetText(enemyLevel, hudFrame.EnemyLevelText);
                SetText(roundLabel, hudFrame.RoundText);
                SetText(waveLabel, hudFrame.WaveText);
                SetFill(ourHpFill, hudFrame.OurHpFill);
                SetFill(enemyHpFill, hudFrame.EnemyHpFill);
                SetDamagePosition(hudFrame.DamagePosition);
                SetDamageText(damage, damageShadow, hudFrame.ShowDamage ? hudFrame.DamageText : "");

                if (previousOurHp >= 0f && Mathf.Abs(previousOurHp - hudFrame.OurHpFill) > 0.0005f)
                    HpChangedCount++;
                if (previousEnemyHp >= 0f && Mathf.Abs(previousEnemyHp - hudFrame.EnemyHpFill) > 0.0005f)
                    HpChangedCount++;
                if (hudFrame.ShowDamage && hudFrame.DamageValue > 0)
                    DamageVisibleCount++;

                previousOurHp = hudFrame.OurHpFill;
                previousEnemyHp = hudFrame.EnemyHpFill;
                UpdateCount++;
            }

            private void SetDamagePosition(Vector2 anchoredPosition)
            {
                if (damageRect != null)
                    damageRect.anchoredPosition = anchoredPosition;
                if (damageShadowRect != null)
                    damageShadowRect.anchoredPosition = anchoredPosition + new Vector2(2f, -2f);
            }

            public void CopyDiagnostics(Result result)
            {
                if (result == null || timeline == null)
                    return;

                result.visualHudDataSource = timeline.DataSource;
                result.visualHudPlayerName = LastFrame.OurName;
                result.visualHudPlayerLevel = LastFrame.OurLevel;
                result.visualHudPlayerNameSource = timeline.PlayerNameSource;
                result.visualHudPlayerLevelSource = timeline.PlayerLevelSource;
                result.visualHudPlayerHpFill = LastFrame.OurHpFill;
                result.visualHudPlayerHpCurrent = LastFrame.OurHpCurrent;
                result.visualHudPlayerHpMax = LastFrame.OurHpMax;
                result.visualHudEnemyName = LastFrame.EnemyName;
                result.visualHudEnemyLevel = LastFrame.EnemyLevel;
                result.visualHudEnemyNameSource = timeline.EnemyNameSource;
                result.visualHudEnemyLevelSource = timeline.EnemyLevelSource;
                result.visualHudEnemyHpFill = LastFrame.EnemyHpFill;
                result.visualHudEnemyHpCurrent = LastFrame.EnemyHpCurrent;
                result.visualHudEnemyHpMax = LastFrame.EnemyHpMax;
                result.visualHudUpdateCount = UpdateCount;
                result.visualHudHpChangedCount = HpChangedCount;
                result.visualHudDamageValue = LastFrame.DamageValue;
                result.visualHudDamageValueSource = LastFrame.DamageSource;
                result.visualHudDynamicDamageVisibleFrames = DamageVisibleCount;
                result.visualHudLiveSummary = LastFrame.Summary;
            }
        }

        private sealed class BattleHudTimeline
        {
            private BattlePayload payload;
            private HeroEntry leader;
            private HeroEntry firstEnemy;
            private int leaderHeroId;
            private int leaderHeroDid;
            private int enemyHeroId;
            private int enemyHeroDid;
            private int frameBudget;

            public int OurActorId = 1036;
            public int EnemyActorId = 3001;
            public int SkillCardCount = 3;
            public string DataSource = "fallback";
            public string PlayerNameSource = "fallback";
            public string PlayerLevelSource = "fallback";
            public string EnemyNameSource = "fallback";
            public string EnemyLevelSource = "fallback";
            public string OurName = "P0";
            public int OurLevel = 1;
            public string EnemyName = "enemy";
            public int EnemyLevel = 1;

            public static BattleHudTimeline Fallback(int frameBudget)
            {
                return new BattleHudTimeline { frameBudget = Mathf.Max(1, frameBudget) };
            }

            public static BattleHudTimeline Load(string payloadFileName, int frameBudget)
            {
                var timeline = Fallback(frameBudget);
                timeline.DataSource = "payload_missing";
                var payloadPath = Path.Combine(Application.dataPath, "RestoreData", "battle", payloadFileName ?? DefaultPayloadFileName);
                if (!File.Exists(payloadPath))
                    return timeline;

                try
                {
                    timeline.payload = JsonUtility.FromJson<BattlePayload>(File.ReadAllText(payloadPath));
                }
                catch (Exception e)
                {
                    timeline.DataSource = "payload_parse_failed:" + e.GetType().Name;
                    return timeline;
                }

                var info = timeline.payload != null ? timeline.payload.battleInfo : null;
                if (info == null)
                    return timeline;

                timeline.DataSource = "payload:" + Path.GetFileName(payloadPath);
                timeline.leader = FirstHero(info.ourHeros);
                timeline.firstEnemy = FirstWaveEnemy(info);
                if (timeline.leader != null)
                {
                    timeline.leaderHeroId = timeline.leader.heroId;
                    timeline.leaderHeroDid = timeline.leader.heroDid;
                    timeline.OurActorId = timeline.leader.heroDid != 0 ? timeline.leader.heroDid : PrimaryHudActorId();
                }
                if (timeline.firstEnemy != null)
                {
                    timeline.enemyHeroId = timeline.firstEnemy.heroId;
                    timeline.enemyHeroDid = timeline.firstEnemy.heroDid;
                    timeline.EnemyActorId = ResolveMonsterActorId(timeline.enemyHeroDid);
                }

                var ids = HudActorIdsFromPayload(info);
                if (!configuredStandingSnapshotOnly && ids.Length > 0)
                    configuredHudCardActorIds = ids;
                timeline.SkillCardCount = Mathf.Clamp(ids.Length > 0 ? ids.Length : CountNonZeroHudCards(), 1, 6);
                timeline.OurName = ResolvePlayerName(info, timeline.leader, out timeline.PlayerNameSource);
                timeline.OurLevel = ResolvePlayerLevel(info, timeline.leader, out timeline.PlayerLevelSource);
                timeline.EnemyName = ResolveEnemyName(timeline.enemyHeroDid, timeline.firstEnemy, out timeline.EnemyNameSource);
                timeline.EnemyLevel = ResolveEnemyLevel(timeline.enemyHeroDid, timeline.firstEnemy, out timeline.EnemyLevelSource);
                return timeline;
            }

            public BattleHudFrame FrameAt(int frame)
            {
                var info = payload != null ? payload.battleInfo : null;
                var waveCount = info != null && info.waveData != null && info.waveData.Length > 0 ? info.waveData.Length : 1;
                var clampedFrame = Mathf.Clamp(frame, 0, Mathf.Max(1, frameBudget));
                var progress = Mathf.Clamp01(clampedFrame / (float)Mathf.Max(1, frameBudget));
                var waveFloat = progress * waveCount;
                var waveIndex = Mathf.Clamp(Mathf.FloorToInt(waveFloat), 0, waveCount - 1);
                var waveT = Mathf.Clamp01(waveFloat - waveIndex);
                var wave = info != null && info.waveData != null && info.waveData.Length > waveIndex ? info.waveData[waveIndex] : null;
                var previousWave = info != null && waveIndex > 0 && info.waveData != null && info.waveData.Length > waveIndex - 1 ? info.waveData[waveIndex - 1] : null;
                var activeEnemy = FirstHero(wave != null ? wave.enemyHeros : null) ?? firstEnemy;
                var roundTotal = Mathf.Max(1, wave != null && wave.bigRoundData != null ? wave.bigRoundData.Length : 1);
                var roundNo = Mathf.Clamp(Mathf.FloorToInt(waveT * roundTotal) + 1, 1, roundTotal);

                var ourStart = HpCurrentFromEntry(leader);
                var ourTarget = ourStart;
                var ourMax = Mathf.Max(1, HpMaxFromEntry(leader));
                var prevOur = FindStatistic(previousWave, true, leaderHeroId, leaderHeroDid);
                var currOur = FindStatistic(wave, true, leaderHeroId, leaderHeroDid);
                if (prevOur != null)
                    ourStart = HpCurrentFromStat(prevOur, ourMax);
                if (currOur != null)
                    ourTarget = HpCurrentFromStat(currOur, ourMax);

                var enemyMax = Mathf.Max(1, HpMaxFromEntry(activeEnemy));
                var enemyStart = HpCurrentFromEntry(activeEnemy);
                var currEnemy = FindStatistic(wave, false, activeEnemy != null ? activeEnemy.heroId : enemyHeroId, activeEnemy != null ? activeEnemy.heroDid : enemyHeroDid);
                var enemyTarget = currEnemy != null ? HpCurrentFromStat(currEnemy, enemyMax) : enemyStart;
                var smooth = waveT * waveT * (3f - 2f * waveT);
                var ourCurrent = Mathf.RoundToInt(Mathf.Lerp(ourStart, ourTarget, smooth));
                var enemyCurrent = Mathf.RoundToInt(Mathf.Lerp(enemyStart, enemyTarget, smooth));
                var damageValue = DamageValueForWave(wave);
                var showDamage = !configuredStandingSnapshotOnly && damageValue > 0 && waveT > 0.16f;
                var damagePosition = DamagePositionForWave(waveIndex);

                return new BattleHudFrame
                {
                    OurName = OurName,
                    OurLevel = OurLevel,
                    OurLevelText = "Lv." + OurLevel,
                    OurHpCurrent = ourCurrent,
                    OurHpMax = ourMax,
                    OurHpFill = Mathf.Clamp01(ourCurrent / (float)ourMax),
                    EnemyName = EnemyName,
                    EnemyLevel = EnemyLevel,
                    EnemyLevelText = "Lv." + EnemyLevel,
                    EnemyHpCurrent = enemyCurrent,
                    EnemyHpMax = enemyMax,
                    EnemyHpFill = Mathf.Clamp01(enemyCurrent / (float)enemyMax),
                    RoundText = "\ud134 " + roundNo + "/" + roundTotal,
                    WaveText = "WAVE " + (waveIndex + 1) + "/" + waveCount,
                    DamageValue = damageValue,
                    DamageText = damageValue > 0 ? damageValue.ToString() : "",
                    DamageSource = damageValue > 0 ? "payload.waveData[" + waveIndex + "].heroStatistics.outputDmg" : "none",
                    DamagePosition = damagePosition,
                    ShowDamage = showDamage,
                    Summary = "player=" + OurName + "/Lv" + OurLevel + "/hp=" + ourCurrent + "/" + ourMax +
                              " enemy=" + EnemyName + "/Lv" + EnemyLevel + "/hp=" + enemyCurrent + "/" + enemyMax +
                              " wave=" + (waveIndex + 1) + "/" + waveCount + " dmg=" + damageValue
                };
            }

            private static Vector2 DamagePositionForWave(int waveIndex)
            {
                switch (Mathf.Abs(waveIndex) % 3)
                {
                    case 0: return new Vector2(196f, 122f);
                    case 1: return new Vector2(182f, 92f);
                    default: return new Vector2(206f, 116f);
                }
            }
        }

        private struct BattleHudFrame
        {
            public string OurName;
            public int OurLevel;
            public string OurLevelText;
            public int OurHpCurrent;
            public int OurHpMax;
            public float OurHpFill;
            public string EnemyName;
            public int EnemyLevel;
            public string EnemyLevelText;
            public int EnemyHpCurrent;
            public int EnemyHpMax;
            public float EnemyHpFill;
            public string RoundText;
            public string WaveText;
            public int DamageValue;
            public string DamageText;
            public string DamageSource;
            public Vector2 DamagePosition;
            public bool ShowDamage;
            public string Summary;
        }

        [Serializable]
        private sealed class BattlePayload
        {
            public BattleInfo battleInfo;
        }

        [Serializable]
        private sealed class BattleInfo
        {
            public int ourPlayerId;
            public int enemyPlayerId;
            public int battleType;
            public int mapId;
            public int fightResult;
            public int playerLevel;
            public int level;
            public string playerName;
            public string nickName;
            public string nickname;
            public string name;
            public PlayerInfoPayload playerInfo;
            public HeroEntry[] ourHeros;
            public FormationEntry[] ourTeamFormation;
            public WaveEntry[] waveData;
        }

        [Serializable]
        private sealed class PlayerInfoPayload
        {
            public int uid;
            public int head;
            public int headFrame;
            public int level;
            public string name;
        }

        [Serializable]
        private sealed class WaveEntry
        {
            public int waveNo;
            public HeroEntry[] enemyHeros;
            public FormationEntry[] enemyTeamFormation;
            public BigRoundEntry[] bigRoundData;
            public HeroStatistic[] heroStatistics;
        }

        [Serializable]
        private sealed class FormationEntry
        {
            public int formationId;
            public int position;
            public int heroId;
            public int heroDid;
            public int firstValue;
        }

        [Serializable]
        private sealed class BigRoundEntry
        {
            public int bigRoundNo;
        }

        [Serializable]
        private sealed class HeroEntry
        {
            public int heroDid;
            public int heroId;
            public int rankLevel;
            public int lockLevel;
            public int level;
            public int curHp;
            public int curMp;
            public int playerId;
            public AttributeEntry[] attribute;
        }

        [Serializable]
        private sealed class AttributeEntry
        {
            public int id;
            public int value;
        }

        [Serializable]
        private sealed class HeroStatistic
        {
            public bool isOurHero;
            public int heroDid;
            public int heroId;
            public int rankLevel;
            public int curHp;
            public int hpRate;
            public int dmg;
            public int outputDmg;
            public int healHp;
            public int curMp;
        }

        private static Text TextByName(Transform root, string name)
        {
            var child = FindChildByName(root, name);
            return child != null ? child.GetComponent<Text>() : null;
        }

        private static Image ImageByName(Transform root, string name)
        {
            var child = FindChildByName(root, name);
            return child != null ? child.GetComponent<Image>() : null;
        }

        private static Transform FindChildByName(Transform root, string name)
        {
            if (root == null || string.IsNullOrEmpty(name))
                return null;
            if (root.name == name)
                return root;
            for (var i = 0; i < root.childCount; i++)
            {
                var found = FindChildByName(root.GetChild(i), name);
                if (found != null)
                    return found;
            }
            return null;
        }

        private static void SetText(Text text, string value)
        {
            if (text != null)
                text.text = value ?? "";
        }

        private static void SetFill(Image image, float value)
        {
            if (image != null)
                image.fillAmount = Mathf.Clamp01(value);
        }

        private static void SetDamageText(Text damage, Text shadow, string value)
        {
            var hasText = !string.IsNullOrEmpty(value);
            SetText(damage, value);
            SetText(shadow, value);
            if (damage != null)
                damage.gameObject.SetActive(hasText);
            if (shadow != null)
                shadow.gameObject.SetActive(hasText);
        }

        private static HeroEntry FirstHero(HeroEntry[] heroes)
        {
            return heroes != null && heroes.Length > 0 ? heroes[0] : null;
        }

        private static BattlePayload LoadConfiguredBattlePayload()
        {
            var payloadPath = Path.Combine(Application.dataPath, "RestoreData", "battle", configuredPayloadFileName ?? DefaultPayloadFileName);
            if (!File.Exists(payloadPath))
                return null;

            try
            {
                return JsonUtility.FromJson<BattlePayload>(File.ReadAllText(payloadPath));
            }
            catch
            {
                return null;
            }
        }

        private static WaveEntry FirstWave(BattleInfo info)
        {
            if (info == null || info.waveData == null || info.waveData.Length == 0)
                return null;
            return info.waveData[0];
        }

        private static HeroEntry FirstWaveEnemy(BattleInfo info)
        {
            var wave = FirstWave(info);
            return FirstHero(wave != null ? wave.enemyHeros : null);
        }

        private static int ResolvePayloadFormationSlot(BattlePayload payload, bool isOurHero, int heroId, int heroDid, bool isMonster, int fallbackSlot)
        {
            var info = payload != null ? payload.battleInfo : null;
            var wave = FirstWave(info);
            var formation = isOurHero
                ? (info != null ? info.ourTeamFormation : null)
                : (wave != null ? wave.enemyTeamFormation : null);

            var slot = ResolvePayloadFormationSlot(formation, heroId, heroDid, isMonster);
            return slot >= 0 ? slot : Mathf.Clamp(fallbackSlot, 0, 5);
        }

        private static int ResolvePayloadFormationSlot(FormationEntry[] formation, int heroId, int heroDid, bool isMonster)
        {
            if (formation == null)
                return -1;

            for (var i = 0; i < formation.Length; i++)
            {
                var entry = formation[i];
                if (entry == null || entry.position <= 0)
                    continue;

                if (heroDid != 0 && entry.heroDid == heroDid)
                    return Mathf.Clamp(entry.position - 1, 0, 5);
                if (heroId != 0 && entry.heroId == heroId)
                    return Mathf.Clamp(entry.position - 1, 0, 5);
                if (isMonster && heroId < 0 && entry.heroId == heroId)
                    return Mathf.Clamp(entry.position - 1, 0, 5);
            }

            return -1;
        }

        private static int[] HudActorIdsFromPayload(BattleInfo info)
        {
            if (info == null || info.ourHeros == null || info.ourHeros.Length == 0)
                return new int[0];
            var ids = new List<int>();
            foreach (var hero in info.ourHeros)
            {
                if (hero != null && hero.heroDid != 0)
                    ids.Add(hero.heroDid);
            }
            return ids.ToArray();
        }

        private static int CountNonZeroHudCards()
        {
            var count = 0;
            if (configuredHudCardActorIds == null)
                return 0;
            for (var i = 0; i < configuredHudCardActorIds.Length; i++)
            {
                if (configuredHudCardActorIds[i] != 0)
                    count++;
            }
            return count;
        }

        private static int HpMaxFromEntry(HeroEntry hero)
        {
            if (hero == null)
                return 1;
            if (hero.attribute != null)
            {
                foreach (var attr in hero.attribute)
                {
                    if (attr != null && attr.id == 1 && attr.value > 0)
                        return attr.value;
                }
            }
            return Mathf.Max(1, hero.curHp);
        }

        private static int HpCurrentFromEntry(HeroEntry hero)
        {
            return hero != null ? Mathf.Max(0, hero.curHp) : 1;
        }

        private static int HpCurrentFromStat(HeroStatistic stat, int maxHp)
        {
            if (stat == null)
                return maxHp;
            if (stat.curHp > 0 || stat.hpRate == 0)
                return Mathf.Clamp(stat.curHp, 0, Mathf.Max(1, maxHp));
            return Mathf.Clamp(Mathf.RoundToInt(maxHp * Mathf.Clamp(stat.hpRate, 0, 10000) / 10000f), 0, Mathf.Max(1, maxHp));
        }

        private static HeroStatistic FindStatistic(WaveEntry wave, bool isOurHero, int heroId, int heroDid)
        {
            if (wave == null || wave.heroStatistics == null)
                return null;
            foreach (var stat in wave.heroStatistics)
            {
                if (stat == null || stat.isOurHero != isOurHero)
                    continue;
                if ((heroId != 0 && stat.heroId == heroId) || (heroDid != 0 && stat.heroDid == heroDid))
                    return stat;
            }
            return null;
        }

        private static int DamageValueForWave(WaveEntry wave)
        {
            if (wave == null || wave.heroStatistics == null)
                return 0;
            var value = 0;
            foreach (var stat in wave.heroStatistics)
            {
                if (stat == null || !stat.isOurHero)
                    continue;
                value = Mathf.Max(value, stat.outputDmg);
            }
            return value;
        }

        private static string ResolvePlayerName(BattleInfo info, HeroEntry leader, out string source)
        {
            source = "none";
            if (info == null)
                return "P0";
            if (info.playerInfo != null && !string.IsNullOrEmpty(info.playerInfo.name))
            {
                source = "payload.playerInfo.name";
                return info.playerInfo.name;
            }
            if (!string.IsNullOrEmpty(info.playerName))
            {
                source = "payload.playerName";
                return info.playerName;
            }
            if (!string.IsNullOrEmpty(info.nickName))
            {
                source = "payload.nickName";
                return info.nickName;
            }
            if (!string.IsNullOrEmpty(info.nickname))
            {
                source = "payload.nickname";
                return info.nickname;
            }
            if (!string.IsNullOrEmpty(info.name))
            {
                source = "payload.name";
                return info.name;
            }
            source = "payload.ourPlayerId";
            return "P" + info.ourPlayerId;
        }

        private static int ResolvePlayerLevel(BattleInfo info, HeroEntry leader, out string source)
        {
            source = "fallback";
            if (info != null && info.playerInfo != null && info.playerInfo.level > 0)
            {
                source = "payload.playerInfo.level";
                return info.playerInfo.level;
            }
            if (info != null && info.playerLevel > 0)
            {
                source = "payload.playerLevel";
                return info.playerLevel;
            }
            if (info != null && info.level > 0)
            {
                source = "payload.level";
                return info.level;
            }
            if (leader != null && leader.rankLevel > 0)
            {
                source = "payload.ourHeros[0].rankLevel";
                return leader.rankLevel;
            }
            return 1;
        }

        private static string ResolveEnemyName(int monsterDid, HeroEntry enemy, out string source)
        {
            source = "fallback";
            if (TryResolveMonsterProfile(monsterDid, out var name, out _, out _))
            {
                source = "DTMonster.monName+DTLangBattle";
                return name;
            }
            if (enemy != null && enemy.heroDid != 0)
            {
                source = "payload.enemyHeros[0].heroDid";
                return "M" + enemy.heroDid;
            }
            return "enemy";
        }

        private static int ResolveEnemyLevel(int monsterDid, HeroEntry enemy, out string source)
        {
            source = "fallback";
            if (TryResolveMonsterProfile(monsterDid, out _, out var level, out _) && level > 0)
            {
                source = "DTMonster.monLevel";
                return level;
            }
            if (enemy != null && enemy.rankLevel > 0)
            {
                source = "payload.enemyHeros[0].rankLevel";
                return enemy.rankLevel;
            }
            return 1;
        }

        private static int ResolveMonsterActorId(int monsterDid)
        {
            if (TryResolveMonsterProfile(monsterDid, out _, out _, out var actorId) && actorId > 0)
                return actorId;
            return monsterDid == 1100111 ? 3001 : monsterDid;
        }

        private static bool TryResolveMonsterProfile(int monsterDid, out string localizedName, out int level, out int actorId)
        {
            localizedName = "";
            level = 0;
            actorId = 0;
            if (monsterDid == 0)
                return false;

            var paths = new[]
            {
                Path.Combine(Application.dataPath, "../../girlswar_merged_extracted/extracted/unity/bundles/b_ec5be11875c4dacf/textassets/-2279990784320368822_DTMonster_KEntityTableData.txt"),
                Path.Combine(Application.dataPath, "../../girlswar_merged_extracted/extracted/unity/bundles/b_ec5be11875c4dacf/textassets/-6086283079442341522_DTMonster_OEntityTableData.txt"),
                Path.Combine(Application.dataPath, "../../girlswar_merged_extracted/extracted/unity/bundles/b_ec5be11875c4dacf/textassets/-448120736505355731_DTMonsterEntityTableData.txt"),
            };
            foreach (var path in paths)
            {
                if (!TryReadLuaTableRow(path, monsterDid, out var fields))
                    continue;
                actorId = IntField(fields, 1);
                var key = FirstQuotedFieldWithPrefix(fields, "monstername_");
                if (string.IsNullOrEmpty(key))
                    key = FirstQuotedFieldWithPrefix(fields, "heroname_");
                localizedName = LocalizeKey(key);
                level = fields.Count > 11 ? IntField(fields, 11) : 0;
                if (level <= 0 && fields.Count > 14)
                    level = IntField(fields, 14);
                return true;
            }
            return false;
        }

        private static bool TryReadLuaTableRow(string path, int rowId, out List<string> fields)
        {
            fields = null;
            path = Path.GetFullPath(path);
            if (!File.Exists(path))
                return false;
            var prefix = "{" + rowId + ",";
            foreach (var raw in File.ReadLines(path))
            {
                var line = (raw ?? "").Trim();
                if (!line.StartsWith(prefix, StringComparison.Ordinal))
                    continue;
                fields = ParseLuaTableFields(line);
                return fields != null && fields.Count > 0;
            }
            return false;
        }

        private static List<string> ParseLuaTableFields(string row)
        {
            var fields = new List<string>();
            if (string.IsNullOrEmpty(row))
                return fields;
            var start = row.IndexOf('{');
            var end = row.LastIndexOf('}');
            if (start < 0 || end <= start)
                return fields;
            var value = row.Substring(start + 1, end - start - 1);
            var sb = new StringBuilder();
            var depth = 0;
            var inString = false;
            for (var i = 0; i < value.Length; i++)
            {
                var ch = value[i];
                if (ch == '"' && (i == 0 || value[i - 1] != '\\'))
                    inString = !inString;
                if (!inString)
                {
                    if (ch == '{')
                        depth++;
                    else if (ch == '}')
                        depth--;
                    else if (ch == ',' && depth == 0)
                    {
                        fields.Add(sb.ToString().Trim());
                        sb.Length = 0;
                        continue;
                    }
                }
                sb.Append(ch);
            }
            fields.Add(sb.ToString().Trim());
            return fields;
        }

        private static int IntField(List<string> fields, int index)
        {
            if (fields == null || index < 0 || index >= fields.Count)
                return 0;
            var text = fields[index].Trim();
            if (text.Length == 0)
                return 0;
            if (text[0] == '"')
                return 0;
            return int.TryParse(text, out var value) ? value : 0;
        }

        private static string FirstQuotedFieldWithPrefix(List<string> fields, string prefix)
        {
            if (fields == null)
                return "";
            foreach (var field in fields)
            {
                var text = Unquote(field);
                if (!string.IsNullOrEmpty(text) && text.StartsWith(prefix, StringComparison.OrdinalIgnoreCase))
                    return text;
            }
            return "";
        }

        private static string Unquote(string value)
        {
            value = (value ?? "").Trim();
            if (value.Length >= 2 && value[0] == '"' && value[value.Length - 1] == '"')
                return value.Substring(1, value.Length - 2);
            return value;
        }

        private static string LocalizeKey(string key)
        {
            if (string.IsNullOrEmpty(key))
                return key ?? "";
            EnsureRuntimeLocalizationCache();
            return RuntimeLocalizationCache.TryGetValue(key, out var value) && !string.IsNullOrEmpty(value) ? value : key;
        }

        private static void EnsureRuntimeLocalizationCache()
        {
            if (runtimeLocalizationCacheLoaded)
                return;
            runtimeLocalizationCacheLoaded = true;
            LoadLocalizationFile("girlswar_merged_extracted/extracted/unity/bundles/b_7e5552edea2c10f4/textassets/4475614301707336171_DTLangBattle.txt");
            LoadLocalizationFile("girlswar_merged_extracted/extracted/unity/bundles/b_7e5552edea2c10f4/textassets/-2670652165716608051_DTLangCommon.txt");
        }

        private static void LoadLocalizationFile(string relativePath)
        {
            var path = Path.GetFullPath(Path.Combine(Application.dataPath, "../..", relativePath));
            if (!File.Exists(path))
                return;
            foreach (var raw in File.ReadLines(path))
            {
                var line = raw ?? "";
                var keyStart = line.IndexOf("['", StringComparison.Ordinal);
                if (keyStart < 0)
                    continue;
                keyStart += 2;
                var keyEnd = line.IndexOf("']", keyStart, StringComparison.Ordinal);
                if (keyEnd <= keyStart)
                    continue;
                var valueStart = line.IndexOf("='", keyEnd, StringComparison.Ordinal);
                if (valueStart < 0)
                    continue;
                valueStart += 2;
                var valueEnd = line.LastIndexOf('\'');
                if (valueEnd <= valueStart)
                    continue;
                var key = line.Substring(keyStart, keyEnd - keyStart);
                var value = line.Substring(valueStart, valueEnd - valueStart);
                if (!RuntimeLocalizationCache.ContainsKey(key))
                    RuntimeLocalizationCache.Add(key, value);
            }
        }

        private static void ResetUltimateCutinDiagnostics()
        {
            ultimateCutinOverlayRequestCount = 0;
            ultimateCutinOverlayShownCount = 0;
            ultimateCutinOverlaySourceSpriteCount = 0;
            ultimateCutinOverlayLastFrame = -9999;
            ultimateCutinOverlaySummary = "";
        }

        public static bool TryShowUltimateCutinOverlay(int actorId, int skillDid, out string summary)
        {
            ultimateCutinOverlayRequestCount++;
            if (configuredStandingSnapshotOnly)
            {
                summary = "standing_snapshot_suppressed actor=" + actorId + " skill=" + skillDid;
                ultimateCutinOverlaySummary = summary;
                return false;
            }
            var family = actorId != 0 ? actorId : SkillFamilyFromDid(skillDid);
            var hud = GameObject.Find("B90_ReferenceBattleHud");
            if (hud == null)
            {
                summary = "missing_hud actor=" + family + " skill=" + skillDid;
                ultimateCutinOverlaySummary = summary;
                return false;
            }

            if (Time.frameCount - ultimateCutinOverlayLastFrame < 8)
            {
                summary = "cooldown actor=" + family + " skill=" + skillDid;
                ultimateCutinOverlaySummary = summary;
                return false;
            }

            var sprite = UltimateCutinSpriteForActor(family);
            if (sprite == null)
            {
                summary = "missing_source_art actor=" + family + " skill=" + skillDid;
                ultimateCutinOverlaySummary = summary;
                return false;
            }

            var existing = hud.transform.Find("B90_UltimateCutinOverlay");
            if (existing != null)
                Destroy(existing.gameObject);

            var overlay = new GameObject("B90_UltimateCutinOverlay");
            overlay.transform.SetParent(hud.transform, false);
            overlay.transform.SetAsLastSibling();
            var rect = overlay.AddComponent<RectTransform>();
            rect.anchorMin = Vector2.zero;
            rect.anchorMax = Vector2.one;
            rect.pivot = new Vector2(0.5f, 0.5f);
            rect.offsetMin = Vector2.zero;
            rect.offsetMax = Vector2.zero;
            var background = overlay.AddComponent<Image>();
            background.sprite = SolidSprite();
            background.color = new Color(0.025f, 0.018f, 0.032f, 0.78f);
            background.raycastTarget = false;

            var art = CreateSpritePanel(overlay.transform, "B90_UltimateCutin_SourceSprite_" + family, new Vector2(0f, 0f), new Vector2(CaptureWidth, CaptureHeight),
                sprite, new Color(0.18f, 0.14f, 0.2f, 0.96f), TextAnchor.MiddleCenter, true);
            art.transform.localScale = new Vector3(1.12f, 1.12f, 1f);
            overlay.AddComponent<UltimateCutinOverlayLifetime>().FramesRemaining = 90;

            ultimateCutinOverlayShownCount++;
            ultimateCutinOverlaySourceSpriteCount++;
            ultimateCutinOverlayLastFrame = Time.frameCount;
            summary = "shown actor=" + family + " skill=" + skillDid + " sprite=" + sprite.name;
            ultimateCutinOverlaySummary = summary;
            return true;
        }

        private static int SkillFamilyFromDid(int skillDid)
        {
            return skillDid >= 100000 ? skillDid / 1000 : 0;
        }

        private static Sprite UltimateCutinSpriteForActor(int actorId)
        {
            switch (actorId)
            {
                case 1002:
                    return LoadExtractedSprite("b_c58dc3ddb653f250", "T", "-3088853708589737389_T_ditu_1002.png");
                case 1012:
                    return LoadExtractedSprite("b_42bc4f1e8d28cb18", "T", "-2943793649454508527_T_ditu_1012.png");
                case 1034:
                    return LoadExtractedSprite("b_3ee8c0344685c2d2", "T", "-1394947549575562419_T_ditu_1034.png");
                case 1036:
                    return LoadExtractedSprite("b_2516176d6c2b7cc4", "T", "8836626965277414394_T_ditu_1036.png");
                default:
                    return null;
            }
        }

        private sealed class UltimateCutinOverlayLifetime : MonoBehaviour
        {
            public int FramesRemaining = 90;

            private CanvasGroup group;

            private void Awake()
            {
                group = gameObject.AddComponent<CanvasGroup>();
                group.alpha = 1f;
            }

            private void Update()
            {
                FramesRemaining--;
                if (group != null && FramesRemaining < 20)
                    group.alpha = Mathf.Clamp01(FramesRemaining / 20f);
                if (FramesRemaining <= 0)
                    Destroy(gameObject);
            }
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
            var actorRects = new List<Rect>();
            var actorOverlapRects = new List<Rect>();
            var actorRectSummaries = new List<string>();
            var actorHeightSummaries = new List<string>();
            var actorAnimationSummaries = new List<string>();
            var actorPositions = new List<string>();
            var hasDiagnosticScreenRect = false;
            var combinedDiagnosticScreenRect = new Rect();
            var actorShadowCount = 0;
            var actorAnimatedCount = 0;
            var hasActorHeight = false;
            var minActorHeight = 0f;
            var maxActorHeight = 0f;
            foreach (var handle in handles)
            {
                if (handle == null) continue;
                var actorKey = (handle.RequestedHeroDid != 0 ? handle.RequestedHeroDid : handle.RequestedHeroId).ToString();
                if (handle.GroundShadowRenderer != null && handle.GroundShadowRenderer.enabled && handle.GroundShadowRenderer.gameObject.activeInHierarchy)
                    actorShadowCount++;
                if (handle.SkeletonAnimation != null && !string.IsNullOrEmpty(handle.AnimationName))
                {
                    actorAnimatedCount++;
                    actorAnimationSummaries.Add(actorKey + "->" + handle.ResolvedActorId + ":" + handle.AnimationName);
                }

                var renderers = handle.GetComponentsInChildren<Renderer>(true);
                var actorHasBounds = false;
                var actorBounds = new Bounds();
                foreach (var renderer in renderers)
                {
                    if (renderer == null || !renderer.enabled || !renderer.gameObject.activeInHierarchy)
                        continue;
                    if (string.Equals(renderer.gameObject.name, "B90_GroundShadow", StringComparison.Ordinal))
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

                    if (!actorHasBounds)
                    {
                        actorBounds = renderer.bounds;
                        actorHasBounds = true;
                    }
                    else
                    {
                        actorBounds.Encapsulate(renderer.bounds);
                    }
                }

                actorPositions.Add(actorKey + "@" + Vec(handle.transform.position));
                if (actorHasBounds && camera != null)
                {
                    var rect = DiagnosticActorScreenRect(camera, handle, actorBounds);
                    actorRects.Add(rect);
                    actorOverlapRects.Add(DiagnosticActorOverlapRect(camera, handle));
                    if (!hasDiagnosticScreenRect)
                    {
                        combinedDiagnosticScreenRect = rect;
                        hasDiagnosticScreenRect = true;
                    }
                    else
                    {
                        combinedDiagnosticScreenRect = Rect.MinMaxRect(
                            Mathf.Min(combinedDiagnosticScreenRect.xMin, rect.xMin),
                            Mathf.Min(combinedDiagnosticScreenRect.yMin, rect.yMin),
                            Mathf.Max(combinedDiagnosticScreenRect.xMax, rect.xMax),
                            Mathf.Max(combinedDiagnosticScreenRect.yMax, rect.yMax));
                    }
                    actorRectSummaries.Add(actorKey + "->" + handle.ResolvedActorId + ":" + RectString(rect));
                    actorHeightSummaries.Add(actorKey + "->" + handle.ResolvedActorId + "=" + rect.height.ToString("0.#") + "px");
                    if (!hasActorHeight)
                    {
                        minActorHeight = rect.height;
                        maxActorHeight = rect.height;
                        hasActorHeight = true;
                    }
                    else
                    {
                        minActorHeight = Mathf.Min(minActorHeight, rect.height);
                        maxActorHeight = Mathf.Max(maxActorHeight, rect.height);
                    }
                }
            }

            result.visualActorRendererCount = rendererCount;
            result.visualTuningVersion = VisualTuningVersion;
            result.visualLayoutSummary = "payload=" + configuredPayloadFileName + "/mapWidthUnits=" + VisualMapWidthUnits.ToString("0.##") + "/native-height-camera2.2-shadow-depth/standingSnapshot=" + configuredStandingSnapshotOnly;
            result.visualActorWorldBounds = hasBounds ? Vec(combined.center) + "|" + Vec(combined.size) : "";
            result.visualActorScreenRect = hasDiagnosticScreenRect ? RectString(combinedDiagnosticScreenRect) : "";
            result.visualActorScreenAreaRatio = hasDiagnosticScreenRect ? ScreenAreaRatio(combinedDiagnosticScreenRect) : 0f;
            result.visualActorWorldPositions = string.Join(";", actorPositions.ToArray());
            result.visualActorScreenRects = string.Join(";", actorRectSummaries.ToArray());
            result.visualActorHeightSummary = string.Join(";", actorHeightSummaries.ToArray());
            result.visualActorMinHeightPixels = hasActorHeight ? minActorHeight : 0f;
            result.visualActorMaxHeightPixels = hasActorHeight ? maxActorHeight : 0f;
            result.visualActorShadowCount = actorShadowCount;
            result.visualActorAnimatedCount = actorAnimatedCount;
            result.visualActorAnimationSummary = string.Join(";", actorAnimationSummaries.ToArray());
            ComputeVisualOverlap(actorOverlapRects, out result.visualActorMaxOverlapRatio, out result.visualActorMinCenterDistancePixels, out result.visualActorOverlappedPairCount);
            CollectHudDiagnostics(result);
        }

        private static void CollectHudDiagnostics(Result result)
        {
            var hud = GameObject.Find("B90_ReferenceBattleHud");
            if (hud == null)
                return;

            var images = hud.GetComponentsInChildren<Image>(true);
            var sourceSprites = 0;
            foreach (var image in images)
            {
                if (image != null && image.sprite != null && image.sprite != SolidSprite())
                    sourceSprites++;
            }

            var rootSlots = 0;
            var lockedSlots = 0;
            var damageText = 0;
            var gauges = 0;
            var transforms = hud.GetComponentsInChildren<Transform>(true);
            foreach (var transform in transforms)
            {
                if (transform == null)
                    continue;
                var objectName = transform.gameObject.name;
                if (IsSkillCardRootName(objectName))
                    rootSlots++;
                if (objectName.IndexOf("_Locked", StringComparison.OrdinalIgnoreCase) >= 0)
                    lockedSlots++;
                if (string.Equals(objectName, "OurHpGauge", StringComparison.Ordinal) || string.Equals(objectName, "EnemyHpGauge", StringComparison.Ordinal))
                    gauges++;

                var text = transform.GetComponent<Text>();
                if (text != null &&
                    string.Equals(objectName, "DamagePopup_Dynamic", StringComparison.Ordinal) &&
                    transform.gameObject.activeInHierarchy &&
                    !string.IsNullOrEmpty(text.text))
                {
                    damageText++;
                }
            }

            var controller = hud.GetComponent<BattleReferenceHudController>();
            if (controller != null)
                controller.CopyDiagnostics(result);

            result.visualHudImageCount = images.Length;
            result.visualHudSourceSpriteCount = sourceSprites;
            result.visualHudSkillSlotCount = rootSlots;
            result.visualHudLockedSlotCount = lockedSlots;
            result.visualHudDamageTextCount = damageText;
            result.visualHudGaugeCount = gauges;
            result.visualHudSummary = "sourceHudSprites=BATTLE42 slots=" + rootSlots +
                                      " locked=" + lockedSlots +
                                      " damageDynamic=" + damageText +
                                      " hud=" + result.visualHudLiveSummary;
        }

        private static bool IsSkillCardRootName(string objectName)
        {
            const string prefix = "SkillCard_";
            if (string.IsNullOrEmpty(objectName) || !objectName.StartsWith(prefix, StringComparison.Ordinal))
                return false;
            for (var i = prefix.Length; i < objectName.Length; i++)
            {
                if (!char.IsDigit(objectName[i]))
                    return false;
            }
            return objectName.Length > prefix.Length;
        }

        private static void CaptureVisualEvidence(Result result, Camera camera)
        {
            if (camera == null)
                return;

            var captureFileName = CaptureFileNameForResult(Path.GetFileName(ResultPath));
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

        private static bool ShouldCaptureSequenceFrame(int frame)
        {
            if (configuredStandingSnapshotOnly)
                return false;
            if (configuredUseAttackTaskPreview)
                return frame == 24 || frame == 48 || frame == 72 || frame == 96 || frame == 120 || frame == 160;
            return frame == 24 || frame == 48 || frame == 72 || frame == 96 || frame == 120 || frame == 160;
        }

        private static void CaptureVisualSequenceFrame(List<string> sequenceCaptures, Camera camera, int frame)
        {
            if (camera == null || sequenceCaptures == null)
                return;

            var prefix = SequencePrefixForResult(Path.GetFileName(ResultPath));
            var output = Path.Combine(GetResultDirectory(), prefix + frame.ToString("0000") + ".png");
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
            File.WriteAllBytes(output, texture.EncodeToPNG());
            sequenceCaptures.Add(output);

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

        private static string CaptureFileNameForResult(string resultFileName)
        {
            if (string.Equals(resultFileName, RealAttackProbeResultFileName, StringComparison.OrdinalIgnoreCase))
                return "BATTLE_90_REAL_ATTACK_PROBE_CAPTURE.png";
            if (string.Equals(resultFileName, RosterExpansionResultFileName, StringComparison.OrdinalIgnoreCase))
                return "BATTLE_92_ROSTER_EXPANSION_PLAYMODE_CAPTURE.png";
            return "BATTLE_90_PLAYMODE_BOOTSTRAP_CAPTURE.png";
        }

        private static string SequencePrefixForResult(string resultFileName)
        {
            if (string.Equals(resultFileName, RealAttackProbeResultFileName, StringComparison.OrdinalIgnoreCase))
                return "BATTLE_90_REAL_ATTACK_PROBE_SEQ_";
            if (string.Equals(resultFileName, RosterExpansionResultFileName, StringComparison.OrdinalIgnoreCase))
                return "BATTLE_92_ROSTER_EXPANSION_PLAYMODE_SEQ_";
            return "BATTLE_90_PLAYMODE_BOOTSTRAP_SEQ_";
        }

        private static string Vec(Vector3 value)
        {
            return value.x.ToString("0.###") + "/" + value.y.ToString("0.###") + "/" + value.z.ToString("0.###");
        }

        private static string ScreenRect(Camera camera, Bounds bounds)
        {
            return RectString(ScreenRectValue(camera, bounds));
        }

        private static Rect DiagnosticActorScreenRect(Camera camera, BattleRuntimeActorHandle handle, Bounds rendererBounds)
        {
            if (camera == null)
                return new Rect();
            if (handle == null)
                return ScreenRectValue(camera, rendererBounds);

            var actorId = handle.ResolvedActorId != 0
                ? handle.ResolvedActorId
                : handle.RequestedHeroDid != 0
                    ? handle.RequestedHeroDid
                    : handle.RequestedHeroId;
            var foot = camera.WorldToScreenPoint(handle.transform.position);
            var height = DiagnosticActorHeightPixels(actorId, handle.IsOurHero);
            var width = height * DiagnosticActorWidthRatio(actorId, handle.IsOurHero);
            var centerX = foot.x + DiagnosticActorCenterOffsetPixels(actorId);
            var bottom = foot.y + DiagnosticActorBottomOffsetPixels(actorId, handle.IsOurHero);
            return Rect.MinMaxRect(centerX - width * 0.5f, bottom, centerX + width * 0.5f, bottom + height);
        }

        private static Rect DiagnosticActorOverlapRect(Camera camera, BattleRuntimeActorHandle handle)
        {
            if (camera == null || handle == null)
                return new Rect();
            var foot = camera.WorldToScreenPoint(handle.transform.position);
            var width = handle.IsOurHero ? 80f : 86f;
            var height = handle.IsOurHero ? 66f : 72f;
            var centerY = foot.y + height * 0.5f;
            return Rect.MinMaxRect(foot.x - width * 0.5f, centerY - height * 0.5f, foot.x + width * 0.5f, centerY + height * 0.5f);
        }

        private static float DiagnosticActorHeightPixels(int actorId, bool isOurHero)
        {
            if (isOurHero && actorId < 3000)
                return 226f;
            switch (actorId)
            {
                case 3001: return 208f;
                case 3006: return 208f;
                default: return 208f;
            }
        }

        private static float DiagnosticActorWidthRatio(int actorId, bool isOurHero)
        {
            if (isOurHero && actorId < 3000)
                return 0.66f;
            switch (actorId)
            {
                case 3001: return 0.72f;
                case 3006: return 0.62f;
                default: return 0.62f;
            }
        }

        private static float DiagnosticActorCenterOffsetPixels(int actorId)
        {
            switch (actorId)
            {
                case 1001: return -6f;
                case 3001: return 8f;
                default: return 0f;
            }
        }

        private static float DiagnosticActorBottomOffsetPixels(int actorId, bool isOurHero)
        {
            if (!isOurHero)
                return -10f;
            return -12f;
        }

        private static Rect ScreenRectValue(Camera camera, Bounds bounds)
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
            return Rect.MinMaxRect(min.x, min.y, max.x, max.y);
        }

        private static string RectString(Rect rect)
        {
            return rect.xMin.ToString("0.##") + "/" + rect.yMin.ToString("0.##") + "/" + rect.xMax.ToString("0.##") + "/" + rect.yMax.ToString("0.##");
        }

        private static float ScreenAreaRatio(Camera camera, Bounds bounds)
        {
            var rect = ScreenRectValue(camera, bounds);
            return ScreenAreaRatio(rect);
        }

        private static float ScreenAreaRatio(Rect rect)
        {
            var area = Mathf.Max(0f, rect.width) * Mathf.Max(0f, rect.height);
            return area / Mathf.Max(1f, CaptureWidth * CaptureHeight);
        }

        private static void ComputeVisualOverlap(List<Rect> rects, out float maxOverlapRatio, out float minCenterDistancePixels, out int overlappedPairCount)
        {
            maxOverlapRatio = 0f;
            minCenterDistancePixels = rects.Count > 1 ? float.MaxValue : 0f;
            overlappedPairCount = 0;

            for (var i = 0; i < rects.Count; i++)
            {
                var a = rects[i];
                for (var j = i + 1; j < rects.Count; j++)
                {
                    var b = rects[j];
                    minCenterDistancePixels = Mathf.Min(minCenterDistancePixels, Vector2.Distance(a.center, b.center));

                    var width = Mathf.Min(a.xMax, b.xMax) - Mathf.Max(a.xMin, b.xMin);
                    var height = Mathf.Min(a.yMax, b.yMax) - Mathf.Max(a.yMin, b.yMin);
                    if (width <= 0f || height <= 0f)
                        continue;

                    overlappedPairCount++;
                    var overlapArea = width * height;
                    var smallerArea = Mathf.Max(1f, Mathf.Min(a.width * a.height, b.width * b.height));
                    maxOverlapRatio = Mathf.Max(maxOverlapRatio, overlapArea / smallerArea);
                }
            }

            if (minCenterDistancePixels == float.MaxValue)
                minCenterDistancePixels = 0f;
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
            var payload = LoadConfiguredBattlePayload();
            for (var i = 0; i < sprites.Count; i++)
            {
                var sprite = sprites[i];
                if (sprite == null) continue;

                try
                {
                    sprite.EnsureRuntimePlaceholders();
                    var fallbackSlot = sprite.IsOurHero ? ourSlot++ : enemySlot++;
                    var heroId = sprite.HeroID;
                    var heroDid = sprite.BaseHeroID;
                    var slot = ResolvePayloadFormationSlot(payload, sprite.IsOurHero, heroId, heroDid, sprite.IsMonster || heroId < 0, fallbackSlot);
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
                    if (configuredStandingSnapshotOnly)
                    {
                        stages.Add("heroViewBridgeSkip[" + i + "]=" + Scrub(e.Message));
                        continue;
                    }
                    failStage = "heroViewBridge[" + i + "]";
                    err = e.Message;
                    return;
                }
            }

            ApplyRuntimeFormationActorPose(payload);

            try { env.Global.Set<string, object>("BATTLE90_LUA_HERO_SPRITE", null); } catch { }
        }

        private static void ApplyRuntimeFormationActorPose(BattlePayload payload)
        {
            var handles = UnityEngine.Object.FindObjectsOfType<BattleRuntimeActorHandle>();
            if (handles == null || handles.Length == 0)
                return;

            Array.Sort(handles, (a, b) => StandingSnapshotSortKey(a).CompareTo(StandingSnapshotSortKey(b)));

            var ourSlot = 0;
            var enemySlot = 0;
            foreach (var handle in handles)
            {
                if (handle == null)
                    continue;

                var fallbackSlot = handle.IsOurHero ? ourSlot++ : enemySlot++;
                var heroId = handle.RequestedHeroId;
                var heroDid = handle.RequestedHeroDid != 0 ? handle.RequestedHeroDid : handle.ResolvedActorId;
                var isMonster = !handle.IsOurHero && (heroId < 0 || heroDid >= 1100000 || handle.ResolvedActorId >= 3000);
                var slot = ResolvePayloadFormationSlot(payload, handle.IsOurHero, heroId, heroDid, isMonster, fallbackSlot);
                var footPosition = PreviewFormationPosition(handle.IsOurHero, slot);

                handle.transform.position = footPosition;
                handle.transform.localRotation = Quaternion.identity;
                AlignActorBodyBottomToFormationFoot(handle, footPosition);
                ApplyFormationRenderOrder(handle, slot);
                handle.RememberBasePose();
            }
        }

        private static void AlignActorBodyBottomToFormationFoot(BattleRuntimeActorHandle handle, Vector3 footPosition)
        {
            if (handle == null)
                return;

            if (handle.SkeletonAnimation != null)
            {
                handle.SkeletonAnimation.Update(0f);
                handle.SkeletonAnimation.LateUpdate();
            }

            if (!TryCollectActorBodyBounds(handle, out var bounds))
                return;

            var delta = footPosition.y - bounds.min.y;
            var position = handle.transform.position;
            handle.transform.position = new Vector3(footPosition.x, position.y + delta, footPosition.z);

            if (handle.GroundShadowRenderer != null)
                handle.GroundShadowRenderer.transform.position = footPosition + new Vector3(0f, 0.035f, 0.12f);
        }

        private static bool TryCollectActorBodyBounds(BattleRuntimeActorHandle handle, out Bounds bounds)
        {
            bounds = new Bounds();
            if (handle == null)
                return false;

            var hasBounds = false;
            var renderers = handle.GetComponentsInChildren<Renderer>(true);
            foreach (var renderer in renderers)
            {
                if (renderer == null || !renderer.enabled || !renderer.gameObject.activeInHierarchy)
                    continue;
                if (handle.GroundShadowRenderer != null && renderer == handle.GroundShadowRenderer)
                    continue;
                if (string.Equals(renderer.gameObject.name, "B90_GroundShadow", StringComparison.Ordinal))
                    continue;

                if (!hasBounds)
                {
                    bounds = renderer.bounds;
                    hasBounds = true;
                }
                else
                {
                    bounds.Encapsulate(renderer.bounds);
                }
            }

            return hasBounds;
        }

        private static void ApplyPreviewFormationPosition(YouYou.LuaHeroSprite sprite, int slot)
        {
            if (sprite == null) return;
            var index = Mathf.Clamp(slot, 0, 5);
            sprite.transform.position = PreviewFormationPosition(sprite.IsOurHero, slot);
            sprite.transform.localRotation = Quaternion.identity;
            sprite.transform.localScale = Vector3.one * PreviewFormationScale(sprite.IsOurHero, index);
            sprite.BattleStationIndex = index;
        }

        private static Vector3 PreviewFormationPosition(bool isOurHero, int slot)
        {
            var positions = isOurHero ? OurFormationSlotPositions : EnemyFormationSlotPositions;
            var pos = positions[Mathf.Clamp(slot, 0, positions.Length - 1)];
            // HARD GUARD: our team stays left of center, enemy right — no path may cross the middle.
            if (isOurHero) pos.x = Mathf.Min(pos.x, -2.0f);
            else           pos.x = Mathf.Max(pos.x,  2.0f);
            return pos;
        }

        private static float PreviewFormationScale(bool isOurHero, int slot)
        {
            var scales = isOurHero ? OurFormationSlotScales : EnemyFormationSlotScales;
            return scales[Mathf.Clamp(slot, 0, scales.Length - 1)];
        }

        private static int PrimaryHudActorId()
        {
            if (configuredHudCardActorIds == null)
                configuredHudCardActorIds = (int[])DefaultHudCardActorIds.Clone();
            for (var i = 0; i < configuredHudCardActorIds.Length; i++)
            {
                if (configuredHudCardActorIds[i] != 0)
                    return configuredHudCardActorIds[i];
            }
            return 1036;
        }

        private static int HudCardActorId(int index)
        {
            if (configuredHudCardActorIds == null || configuredHudCardActorIds.Length == 0)
                configuredHudCardActorIds = (int[])DefaultHudCardActorIds.Clone();
            return configuredHudCardActorIds[Mathf.Clamp(index, 0, configuredHudCardActorIds.Length - 1)];
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
            public bool standingSnapshotOnly;
            public int frameBudget;
            public int framesPumped;
            public int decodedLuaIndexCount;
            public string payloadFileName;
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
            public int skinMissingActorCount;
            public int skinVisualFallbackCount;
            public string skinLastActor;
            public int runtimeActorAttachCount;
            public int runtimeActorPrefabCount;
            public int runtimeActorSpineCount;
            public int runtimeActorVisualFallbackCount;
            public int runtimeActorQuadFallbackCount;
            public int runtimeActorMissingAssetCount;
            public int runtimeMaterialShaderFallbackCount;
            public int runtimeSpineAtlasMaterialFallbackCount;
            public int runtimeBlendModeMaterialFallbackCount;
            public int runtimeMonsterModelResolveCount;
            public int runtimeMonsterModelExactResolveCount;
            public int runtimeMonsterModelBaseFallbackResolveCount;
            public int runtimeMonsterModelMissingExactRowCount;
            public int runtimePreviewActionCount;
            public int runtimePreviewCompletedCount;
            public int runtimePreviewMissCount;
            public int runtimeSourceSkillSpecResolveCount;
            public int runtimeSkillTimelineBlockedCount;
            public int runtimeSkillHitEffectCount;
            public int runtimeSourceSkillPrefabAttemptCount;
            public int runtimeSourceSkillPrefabLoadCount;
            public int runtimeSourceSkillPrefabInstantiateCount;
            public int runtimeSourceSkillPrefabRenderableCount;
            public int runtimeSourceSkillPrefabRendererTotalCount;
            public int runtimeSourceSkillPrefabParticlePlayCount;
            public int runtimeSourceSkillPrefabAnimatorPlayCount;
            public int runtimeSourceSkillPrefabDirectorCount;
            public int runtimeSourceSkillPrefabDirectorPlayedCount;
            public int runtimeSourceSkillPrefabDirectorBlockedCount;
            public int runtimeSourceSkillPrefabPlayableLoadCount;
            public int runtimeSourceSkillCommonEffectInstantiateCount;
            public int runtimeSourceSkillPrefabWorldCutinSuppressedCount;
            public int runtimeSourceSkillPrefabFailureCount;
            public int runtimeUltimateCutinOverlayRequestCount;
            public int runtimeUltimateCutinOverlayShownCount;
            public int runtimeUltimateCutinOverlaySourceSpriteCount;
            public string runtimeUltimateCutinOverlaySummary;
            public string runtimeActorLastSummary;
            public string runtimeMonsterModelResolveSummary;
            public string runtimeMonsterModelResolveTrace;
            public string runtimeSkillSpecSummary;
            public string runtimeSkillSpecTrace;
            public string runtimeSourceSkillPrefabSummary;
            public string runtimeSourceSkillPrefabTrace;
            public string visualCameraName;
            public float visualCameraOrthographicSize;
            public string visualTuningVersion;
            public string visualLayoutSummary;
            public int visualActorHandleCount;
            public int visualActorRendererCount;
            public string visualActorWorldBounds;
            public string visualActorScreenRect;
            public float visualActorScreenAreaRatio;
            public string visualActorWorldPositions;
            public string visualActorScreenRects;
            public string visualActorHeightSummary;
            public float visualActorMinHeightPixels;
            public float visualActorMaxHeightPixels;
            public int visualActorShadowCount;
            public int visualActorAnimatedCount;
            public string visualActorAnimationSummary;
            public float visualActorMaxOverlapRatio;
            public float visualActorMinCenterDistancePixels;
            public int visualActorOverlappedPairCount;
            public int visualHudImageCount;
            public int visualHudSourceSpriteCount;
            public int visualHudSkillSlotCount;
            public int visualHudLockedSlotCount;
            public int visualHudDamageTextCount;
            public int visualHudGaugeCount;
            public string visualHudSummary;
            public string visualHudDataSource;
            public string visualHudPlayerName;
            public int visualHudPlayerLevel;
            public string visualHudPlayerNameSource;
            public string visualHudPlayerLevelSource;
            public float visualHudPlayerHpFill;
            public int visualHudPlayerHpCurrent;
            public int visualHudPlayerHpMax;
            public string visualHudEnemyName;
            public int visualHudEnemyLevel;
            public string visualHudEnemyNameSource;
            public string visualHudEnemyLevelSource;
            public float visualHudEnemyHpFill;
            public int visualHudEnemyHpCurrent;
            public int visualHudEnemyHpMax;
            public int visualHudUpdateCount;
            public int visualHudHpChangedCount;
            public int visualHudDamageValue;
            public string visualHudDamageValueSource;
            public int visualHudDynamicDamageVisibleFrames;
            public string visualHudLiveSummary;
            public string capturePath;
            public bool captureExists;
            public int captureBytes;
            public int captureNonDarkSampleCount;
            public int captureSequenceFrameCount;
            public string captureSequencePaths;
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
            public int standingSnapshotPreviewSkipCount;
            public int standingSnapshotActorNormalizeCount;
            public string standingSnapshotActorSummary;
            public int firstReadyShortcutCount;
            public List<string> stagesCompleted;
        }
    }
}
