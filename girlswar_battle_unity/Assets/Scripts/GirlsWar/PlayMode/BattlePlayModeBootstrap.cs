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

        public static bool Completed { get; private set; }
        public static int LastExitCode { get; private set; } = 1;
        public static string LastStatus { get; private set; } = "";
        public static string ResultPath { get; private set; }

        private static int configuredFrameBudget = 240;

        [SerializeField] private int frameBudget = 240;

        private string firstLogException = "";
        private int errorLogCount;

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
            rawset(_G, 'IsNil', function(v) return v == nil or v == NOOP end)
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
            ResultPath = resultPath;
            configuredFrameBudget = frames;
            Completed = false;
            LastExitCode = 1;
            LastStatus = "";
        }

        private void Awake()
        {
            frameBudget = configuredFrameBudget > 0 ? configuredFrameBudget : frameBudget;
            YouYou.GameEntry.Instance.CoroutineHost = this;
            YouYou.GameEntry.Procedure.ResetRuntimeState();
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
                        if GameInit then rawset(GameInit,'IsClient',true); rawset(GameInit,'IsBattlePlayVerify',false) end
                        if PlayerMgr and type(rawget(PlayerMgr,'PlayerInfo'))~='table' then
                          rawset(PlayerMgr, 'PlayerInfo', { uid = info.ourPlayerId or 0, head = 0, name = 'offline', level = 1 })
                        elseif PlayerMgr and PlayerMgr.PlayerInfo then
                          PlayerMgr.PlayerInfo.uid = PlayerMgr.PlayerInfo.uid or info.ourPlayerId or 0
                        end
                        if ModulesInit and PNB then rawset(ModulesInit, 'ProcedureNormalBattle', PNB) end
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
                        for _, mod in pairs(package.loaded) do
                          if type(mod)=='table' and rawget(mod,'isLoadIO')==true then rawset(mod,'isLoadIO', false) end
                        end
                        if PNB then
                          PNB.IsOpenPlayMusic = false
                          PNB.FightPlayData = info
                          PNB.IsFightPlay = true
                          local function make_station_setting(prefix)
                            local rootGo = CS.UnityEngine.GameObject(prefix .. '_Root')
                            local root = rootGo.transform
                            local stations = {}
                            for idx=0,5 do
                              local go = CS.UnityEngine.GameObject(prefix .. '_Station_' .. tostring(idx))
                              go.transform:SetParent(root, false)
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
                          'CheckBattleBegin','BattleBegin','BattleAllBigRoundBegin','BattleBigRoundBegin',
                          'BattleSmallRoundBegin','FinalBattleEnd'}) do wrap(n) end",
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
                    DIAG_SUMMARY =
                      'loadPlayerHero='..tostring(CNT and CNT['LoadPlayerHero'] or 0)..
                      ' loadEnemy='..tostring(CNT and CNT['LoadEnemyPlayerHeros'] or 0)..
                      ' teamReady='..tostring(CNT and CNT['OnBattleTeamReady'] or 0)..
                      ' battleBegin='..tostring(CNT and CNT['BattleBegin'] or 0)..
                      ' bigRound='..tostring(CNT and CNT['BattleBigRoundBegin'] or 0)..
                      ' currBigRound='..tostring(PNB and rawget(PNB,'CurrBattleBigRound'))");
                result.diagSummary = env.Global.Get<string>("DIAG_SUMMARY") ?? "";
            }
            catch { }
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
            try { env.DoString("if PNB and PNB.OnUpdate then PNB.OnUpdate(CS.UnityEngine.Time.deltaTime) end"); }
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
            public List<string> stagesCompleted;
        }
    }
}
