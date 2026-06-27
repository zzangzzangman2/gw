// GirlsWar offline-battle Milestone 2: run the battle headless.
// Staged + defensive: each stage is pcall-guarded so one run pinpoints the first real
// blocker. Writes reports/battle/BATTLE_88_M2_HEADLESS_BATTLE_RESULT.json.
//
// Run:
//   Unity.exe -quit -batchmode -nographics -projectPath girlswar_battle_unity \
//     -executeMethod GirlsWar.GirlsWarLuaBootstrapMilestone2.Run \
//     -logFile reports/battle/BATTLE_88_M2_HEADLESS_BATTLE.log
using System;
using System.IO;
using System.Text;
using UnityEditor;
using UnityEngine;
using XLua;

namespace GirlsWar
{
    public static class GirlsWarLuaBootstrapMilestone2
    {
        // Headless global environment. Instead of the game's strict-global guard
        // (Common/Global.lua, which infinite-recurses without the full init that declares
        // every global), install a PERMISSIVE _G: any undefined global resolves to a
        // chainable no-op (field -> itself, callable -> nil). This neutralizes the entire
        // view/UI/audio/missing-global surface so the battle LOGIC can run; real modules
        // (required) and explicitly-set globals (JsonUtil, ...) take precedence via rawset.
        private const string SetupEnv = @"
            -- NOOP is an 'absorbing' value: it survives indexing, calling, comparison,
            -- arithmetic and concat so missing framework surface can't crash the battle
            -- LOGIC. (Branches it controls collapse to false/0 — fine for a headless run.)
            local NOOP = {}
            setmetatable(NOOP, {
              -- numeric keys -> nil so `ipairs(NOOP)` terminates at index 1 (Lua 5.3 ipairs
              -- reads t[i] through __index; returning NOOP forever = infinite loop, e.g.
              -- HeroBattleInfo.SetHeroSkill's `for _ in ipairs(e.underwearSuits)`). Non-numeric
              -- keys still chain to NOOP so field/method access stays absorbing.
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
            local function logf() end
            for _,n in ipairs({'log','logerror','logwarn','logblue','loggreen','logyellow','logtable','logProto','logBattle'}) do
              rawset(_G, n, logf)
            end
            -- logic stubs: globals whose RETURN VALUE steers a branch need real returns
            -- (the absorbing NOOP would pick the wrong branch). Grow this as M2 reveals more.
            rawset(_G, 'BuildPatchMgr', {
              CheckCanUseRapidjson = function() return false end,  -- use pure-lua Common/json
              CompareVersion = function() return 0 end,
            })
            -- SaveMgr: persisted UI prefs (auto-battle/game-speed/fast-skill keys). A fresh
            -- offline run has NO saved prefs, so Has=false and getters return the caller's
            -- default (legitimate, not fabricated). Calls are dot-style: GetXForKey(key, default).
            -- Without this the absorbing NOOP returns truthy for Has* and a table for getters,
            -- breaking guards and string.format (e.g. LoadAutoMode/LoadGameSpeed).
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
            -- permissive fallback: any undeclared global read -> the absorbing NOOP
            setmetatable(_G, { __index = function(_, k) return NOOP end })
        ";

        public static void Run()
        {
            var stages = new System.Collections.Generic.List<string>();
            string failStage = "", err = "";
            bool battleEntered = false;

            LuaEnv env = null;
            try
            {
                env = new LuaEnv();
                env.AddLoader((ref string p) => GirlsWarLuaLoader.Load(ref p));
                stages.Add("luaenv+loader");

                // permissive _G + logging globals (replaces the strict Common/Global guard)
                env.DoString(SetupEnv);
                // hand the Lua NOOP table to the C# GameEntry stub (object-returning members
                // hand it back so form:GetXxx() chains stay no-crash headless)
                LuaNoopHolder.Noop = env.Global.Get<LuaTable>("NOOP_STUB");
                stages.Add("permissive-_G");

                // stdlib extensions: the game installs pure-Lua helpers onto the standard
                // `string`/`table` libraries (e.g. `table.deepCopy=...`, `string.split=...`) via
                // these Common modules. The full game requires them during init; our minimal
                // harness must too, or real battle code hits nil (e.g. InitDataWithFightPlayData
                // calls table.deepCopy). StringUtil first: TableUtil captures string.split at load.
                Safe(env, @"
                    pcall(require, 'Common/StringUtil')
                    pcall(require, 'Common/TableUtil')", stages, ref failStage, ref err, optional: true);

                // Real Lua-defined framework globals (resolved by leaf via custom loader).
                // rawset so they take precedence over the permissive __index fallback.
                string[] globals = {
                    "JsonUtil", "GameTools", "GameInit", "CommonEventId",
                    "EventSystem", "ModulesInit", "PlayerMgr",
                };
                foreach (var g in globals)
                {
                    if (!string.IsNullOrEmpty(failStage)) break;
                    // Many of these modules self-assign their global (e.g. JsonUtil={...}) and
                    // `return` nothing, so require() yields `true`. Only adopt the return when
                    // it's a table AND the module didn't already set the global itself.
                    Safe(env,
                        $"local ok,m = pcall(require, '{g}'); " +
                        $"if ok and type(m)=='table' and type(rawget(_G,'{g}'))~='table' then rawset(_G,'{g}',m) end",
                        stages, ref failStage, ref err, optional: true);
                }

                // Give the real framework modules a permissive __index fallback: their own
                // methods stay (rawget), but methods that are actually native/defined-elsewhere
                // resolve to NOOP instead of crashing (e.g. GameInit.CheckOpenCurBattleLog...).
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
                    end", stages, ref failStage, ref err, optional: true);

                // load the battle procedure
                if (string.IsNullOrEmpty(failStage))
                    Safe(env, "PNB = require('ProcedureNormalBattle')", stages, ref failStage, ref err);

                // headless: skip the audio/BGM path (irrelevant to battle logic, pulls in
                // native audio internals). Disable music + give GameTools a no-op for the
                // BGM helper so OnEnter's music block is inert.
                Safe(env, @"
                    if PNB then pcall(function() PNB.IsOpenPlayMusic = false end) end
                    if GameTools then
                      GameTools.SwitchBGMFadeOutLua = function() end
                      GameTools.SwitchBGMFadeOut = function() end
                    end", stages, ref failStage, ref err, optional: true);

                // feed battleInfo and enter
                if (string.IsNullOrEmpty(failStage))
                {
                    var payloadPath = Path.GetFullPath(Path.Combine(
                        Application.dataPath, "RestoreData", "battle", "BATTLE_TEST_PAYLOAD.json"));
                    var json = File.Exists(payloadPath) ? File.ReadAllText(payloadPath) : "";
                    env.Global.Set("BATTLE_TEST_JSON", json);
                    Safe(env,
                        @"local data = JsonUtil and JsonUtil.decode and JsonUtil.decode(BATTLE_TEST_JSON) or nil
                          local info = data and data.battleInfo or data
                          assert(info, 'no battleInfo in payload')
                          -- DATA WIRING (the real fix): OnEnter(a) NEVER stores its arg, so
                          -- feeding battleInfo to OnEnter alone leaves e.FightPlayData=nil and
                          -- InitBattleInfo falls to InitDataWithEmptyData -> e.BattleType=nil ->
                          -- crash at PNB:740. The game's replay entry (PlayFightClientReplay)
                          -- sets these on the procedure table BEFORE the state change. PNB is
                          -- that table (file: 'local t={} local e=t ... return t'), so setting
                          -- PNB.FightPlayData IS e.FightPlayData. Then InitBattleInfo takes the
                          -- InitDataWithFightPlayData branch -> e.BattleType=info.battleType (=1)
                          -- -> DTBattleDBModel.GetEntity(1) self-populates offline (isLoadIO
                          -- false -> InitRequire -> DTBattleEntityTableData row id=1 'campaign').
                          PNB.FightPlayData = info
                          PNB.IsFightPlay = true
                          -- Minimal real player identity: battle prefs/report code builds keys
                          -- from PlayerMgr.PlayerInfo.uid (e.g. LoadAutoMode/LoadGameSpeed do
                          -- string.format('%d_...', uid, ...)). Without a numeric uid the
                          -- permissive NOOP yields a table and string.format throws. This battle
                          -- belongs to ourPlayerId, so use it (not fabricated).
                          if PlayerMgr and type(rawget(PlayerMgr,'PlayerInfo'))~='table' then
                            rawset(PlayerMgr, 'PlayerInfo', { uid = info.ourPlayerId or 0 })
                          end
                          local fn = PNB and (PNB.ProcedureNormalBattle_OnEnter or PNB.OnEnter)
                          assert(fn, 'no OnEnter on ProcedureNormalBattle')
                          fn(info)",
                        stages, ref failStage, ref err);
                    if (string.IsNullOrEmpty(failStage)) battleEntered = true;
                }

                // pump a few ticks (battle replay advances on update/coroutine)
                if (battleEntered)
                {
                    for (int i = 0; i < 120 && string.IsNullOrEmpty(failStage); i++)
                        Safe(env, "if PNB and PNB.OnUpdate then PNB.OnUpdate(0.033) end",
                             stages, ref failStage, ref err, optional: true);
                    env.Tick();
                    stages.Add("pumped");
                }
            }
            catch (Exception e)
            {
                if (string.IsNullOrEmpty(failStage)) { failStage = "init"; err = e.Message; }
            }
            finally { try { env?.Dispose(); } catch { } }

            err = (err ?? "").Replace("\\", "/").Replace("\"", "'").Replace("\n", " | ");
            var sb = new StringBuilder();
            sb.Append("{\n");
            sb.Append("  \"milestone\": \"BATTLE_88_m2_headless_battle\",\n");
            sb.Append($"  \"stagesCompleted\": \"{string.Join(" > ", stages)}\",\n");
            sb.Append($"  \"battleEntered\": {battleEntered.ToString().ToLower()},\n");
            sb.Append($"  \"failedStage\": \"{failStage}\",\n");
            sb.Append($"  \"error\": \"{err}\"\n");
            sb.Append("}\n");
            var outDir = Path.GetFullPath(Path.Combine(Application.dataPath, "..", "..", "reports", "battle"));
            Directory.CreateDirectory(outDir);
            File.WriteAllText(Path.Combine(outDir, "BATTLE_88_M2_HEADLESS_BATTLE_RESULT.json"),
                              sb.ToString(), new UTF8Encoding(false));
            Debug.Log($"[GirlsWarLua] M2 entered={battleEntered} failStage={failStage} err={err}");
        }

        // M2 finish line: run the battle as the SERVER does (verify mode). With GameInit.IsClient
        // =false the battle modules bind the SYNCHRONOUS coroutine driver (cs_coroutine_server.start
        // = fn -> fn()) and skip the entire view/animation surface, so the wave/round replay runs
        // start-to-finish headless and FightDataReportMgr validates it. No Play Mode needed.
        // (Client mode's replay is Unity-coroutine/time-driven -> that's the watchable M3 path.)
        public static void RunServerReplay()
        {
            var stages = new System.Collections.Generic.List<string>();
            string failStage = "", err = "";
            bool replayRan = false;
            string isValid = "unknown", bigRound = "unknown";

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
                    pcall(require, 'Common/Class')      -- global Class(): battle modules do HeroCtrl=Class(...)
                    pcall(require, 'Common/StringUtil')
                    pcall(require, 'Common/TableUtil')", stages, ref failStage, ref err, optional: true);

                // SERVER MODE FIRST: load GameInit, then force IsClient=false BEFORE any battle
                // module is required, so each binds cs_coroutine_server (sync) at load time.
                Safe(env, @"local ok,m = pcall(require, 'GameInit')
                            if ok and type(m)=='table' and type(rawget(_G,'GameInit'))~='table' then rawset(_G,'GameInit',m) end",
                     stages, ref failStage, ref err, optional: true);
                Safe(env, @"if GameInit then rawset(GameInit,'IsClient',false); rawset(GameInit,'IsBattlePlayVerify',false) end",
                     stages, ref failStage, ref err, optional: true);

                string[] globals = {
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
                    end", stages, ref failStage, ref err, optional: true);

                if (string.IsNullOrEmpty(failStage))
                    Safe(env, "PNB = require('ProcedureNormalBattle')", stages, ref failStage, ref err);

                if (string.IsNullOrEmpty(failStage))
                {
                    var payloadPath = Path.GetFullPath(Path.Combine(
                        Application.dataPath, "RestoreData", "battle", "BATTLE_TEST_PAYLOAD.json"));
                    var json = File.Exists(payloadPath) ? File.ReadAllText(payloadPath) : "";
                    env.Global.Set("BATTLE_TEST_JSON", json);
                    Safe(env,
                        @"local data = JsonUtil and JsonUtil.decode and JsonUtil.decode(BATTLE_TEST_JSON) or nil
                          local info = data and data.battleInfo or data
                          assert(info, 'no battleInfo in payload')
                          if PlayerMgr and type(rawget(PlayerMgr,'PlayerInfo'))~='table' then
                            rawset(PlayerMgr, 'PlayerInfo', { uid = info.ourPlayerId or 0 })
                          end
                          -- CRITICAL: PlayFightServerCheck dispatches via
                          -- ModulesInit.ProcedureNormalBattle.BeginFightPlayWithServer(...), and the
                          -- battle reads ModulesInit.ProcedureNormalBattle.<state> throughout. Our
                          -- permissive __index leaves that = NOOP (so the whole entry no-ops:
                          -- chainTrace was NOCHAIN). Bind it to the real required PNB table.
                          if ModulesInit and PNB then rawset(ModulesInit, 'ProcedureNormalBattle', PNB) end
                          -- HeroMgr: player's hero inventory keyed by heroId. ourTeamFormation
                          -- entries carry only heroId; LoadPlayerHeros fills heroDid via
                          -- HeroMgr:GetHeroDataByHeroId(heroId), and HeroCtrl:OnOpen needs a valid
                          -- heroDid to load DTHeroRow (config). The payload's ourHeros pairs
                          -- heroId<->heroDid, so build the lookup from it (source-backed).
                          do
                            local byId = {}
                            local function idx(list) if type(list)=='table' then for k=1,#list do local hh=list[k]; if hh and hh.heroId then byId[hh.heroId]=hh end end end end
                            idx(info.ourHeros); idx(info.enemyHeros)
                            if type(info.waveData)=='table' then for _,wv in ipairs(info.waveData) do idx(wv.enemyHeros) end end
                            rawset(_G,'HeroMgr', setmetatable({
                              GetHeroDataByHeroId = function(_, id) return byId[id] end,
                              GetHeroData         = function(_, id) return byId[id] end,
                            }, { __index = function() return NOOP_STUB end }))
                          end
                          -- Localization is display-only; the real GetLocalize gsubs a NOOP
                          -- language template headless. Return the key as a string so name/text
                          -- reads (e.g. HeroCtrl NickName) never crash the battle logic.
                          if GameTools then
                            GameTools.GetLocalize = function(a) return type(a)=='string' and a or tostring(a) end
                          end
                          -- Data tables: large tables (monster/soul/buff/...) default to isLoadIO=true
                          -- (read .bigd binary IO at a runtime path we don't provision -> GetEntity
                          -- crashes on a nil DataTableHeader). The game flips them to inline-Lua mode
                          -- when GameTools.ClientIsSupportIOLoad()==false (LoadList sets isLoadIO=false
                          -- -> GetEntity uses InitRequire over the decoded *EntityTableData Lua).
                          -- Force offline Lua-load: flag false + flip every loaded DB model's field.
                          if GameTools then GameTools.ClientIsSupportIOLoad = function() return false end end
                          for _, mod in pairs(package.loaded) do
                            if type(mod)=='table' and rawget(mod,'isLoadIO')==true then rawset(mod,'isLoadIO', false) end
                          end
                          -- TRACE the begin chain: wrap PNB functions (PNB is the procedure table,
                          -- called as e.X()) to record call order. Tells us exactly where the
                          -- teams-load -> ready -> BattleBegin -> round-loop chain stops. (Wrapping
                          -- before fn() works for OnBattleTeamReady too: InitBattleTeam re-captures
                          -- e.OnBattleTeamReady into the teams during fn, picking up the wrapper.)
                          TRACE = ''
                          local CNT = {}
                          local function wrap(name)
                            local orig = rawget(PNB, name)
                            PNB[name] = function(...)
                              CNT[name] = (CNT[name] or 0) + 1
                              if CNT[name] <= 3 then TRACE = TRACE .. name .. ';' end
                              if type(orig)=='function' then return orig(...) end
                            end
                          end
                          for _,n in ipairs({'OnBattleTeamReady','FirstBattleTeamReady',
                            'AfterBattleTeamReady','CheckBattleBegin','BattleBegin',
                            'BattleAllBigRoundBegin','BattleBigRoundBegin','BattleSmallRoundBegin',
                            'LoadPlayerHero','FinalBattleEnd'}) do wrap(n) end
                          -- Call BeginFightPlayWithServer DIRECTLY (the real replay entry) instead
                          -- of PlayFightServerCheck, whose Exit() wipes team/round state before we
                          -- can inspect it. Same synchronous path: InitBattleInfo -> teams load
                          -- (IsSkipBattle) -> OnBattleTeamReady -> BattleBegin -> round loop.
                          pcall(function() PNB.IsOpenCurBattleCheck = true end)
                          -- DIAGNOSTIC: count which hero-load branch runs. sync branch (IsSkipBattle
                          -- true) -> BattleTeam:AddHeroCtrl; async branch -> GameTools:PoolGameObjectSpawn.
                          DIAG = { pool=0, addHero=0, addPet=0 }
                          if GameTools then
                            local o = rawget(GameTools,'PoolGameObjectSpawn')
                            GameTools.PoolGameObjectSpawn = function(...) DIAG.pool=DIAG.pool+1; if type(o)=='function' then return o(...) end end
                          end
                          local BT = rawget(_G,'BattleTeam')
                          if type(BT)=='table' then
                            local oh = rawget(BT,'AddHeroCtrl'); BT.AddHeroCtrl = function(...) DIAG.addHero=DIAG.addHero+1; if type(oh)=='function' then return oh(...) end end
                            local op = rawget(BT,'AddPetCtrl'); BT.AddPetCtrl = function(...) DIAG.addPet=DIAG.addPet+1; if type(op)=='function' then return op(...) end end
                          end
                          -- Re-assert server mode right before entry: GameInit defaults IsClient=true
                          -- (init/GameInit.lua) and helpers re-set it; for a headless SYNC replay it
                          -- MUST stay false so client view/animation code (which waits on frames we
                          -- never tick) is bypassed instead of spinning forever.
                          if GameInit then rawset(GameInit,'IsClient',false) end
                          PROBE = 'Class='..type(rawget(_G,'Class'))
                            ..' HeroCtrlIsClass='..tostring(type(IsLuaClass)=='function' and IsLuaClass(rawget(_G,'HeroCtrl')))
                            ..' IsClient='..tostring(GameInit and GameInit.IsClient)
                          pcall(function() CS.UnityEngine.Debug.Log('[GirlsWarLua] PRE-BEGIN '..PROBE) end)
                          -- safety: the replay engine expects frames/time; if a loop runs away
                          -- headless, abort with a traceback instead of hanging forever.
                          pcall(function()
                            local _n = 0
                            debug.sethook(function() _n = _n + 1; if _n > 300 then error('INSTR_LIMIT runaway loop (headless replay)') end end, '', 10000000)
                          end)
                          local begin = PNB.BeginFightPlayWithServer
                          assert(begin, 'no BeginFightPlayWithServer')
                          begin(info)
                          pcall(function() debug.sethook() end)
                          local ot, et = rawget(PNB,'OurTeam'), rawget(PNB,'EnemyTeam')
                          REPLAY_ISVALID =
                            'skip='..tostring(rawget(PNB,'IsSkipBattle'))..
                            ' pool='..tostring(DIAG.pool)..' addHero='..tostring(DIAG.addHero)..' addPet='..tostring(DIAG.addPet)..
                            ' ourMax='..tostring(ot and rawget(ot,'MaxHeroCount'))..
                            ' ourCur='..tostring(ot and rawget(ot,'CurrHeroCount'))..
                            ' readyCount='..tostring(rawget(PNB,'ReadyTeamCount'))..
                            ' isFirstReady='..tostring(rawget(PNB,'IsFirstBattleTeamReady'))
                          REPLAY_BIGROUND = (TRACE=='' and 'NOCHAIN' or TRACE)
                                            .. ' | loadHero=' .. tostring(CNT['LoadPlayerHero'] or 0)
                                            .. ' bigRound=' .. tostring(CNT['BattleBigRoundBegin'] or 0)
                                            .. ' currBigRound=' .. tostring(rawget(PNB,'CurrBattleBigRound'))",
                        stages, ref failStage, ref err);
                    if (string.IsNullOrEmpty(failStage))
                    {
                        replayRan = true;
                        try { isValid = env.Global.Get<string>("REPLAY_ISVALID"); } catch { }
                        try { bigRound = env.Global.Get<string>("REPLAY_BIGROUND"); } catch { }
                        try { isValid = (env.Global.Get<string>("PROBE") ?? "") + " || " + isValid; } catch { }
                    }
                }
            }
            catch (Exception e)
            {
                if (string.IsNullOrEmpty(failStage)) { failStage = "init"; err = e.Message; }
            }
            finally { try { env?.Dispose(); } catch { } }

            err = (err ?? "").Replace("\\", "/").Replace("\"", "'").Replace("\n", " | ");
            var sb = new StringBuilder();
            sb.Append("{\n");
            sb.Append("  \"milestone\": \"BATTLE_89_m2_server_replay\",\n");
            sb.Append($"  \"stagesCompleted\": \"{string.Join(" > ", stages)}\",\n");
            sb.Append($"  \"replayRan\": {replayRan.ToString().ToLower()},\n");
            sb.Append($"  \"playFightServerCheckReturn_isValid\": \"{isValid}\",\n");
            sb.Append($"  \"chainTrace\": \"{bigRound}\",\n");
            sb.Append($"  \"failedStage\": \"{failStage}\",\n");
            sb.Append($"  \"error\": \"{err}\"\n");
            sb.Append("}\n");
            var outDir = Path.GetFullPath(Path.Combine(Application.dataPath, "..", "..", "reports", "battle"));
            Directory.CreateDirectory(outDir);
            File.WriteAllText(Path.Combine(outDir, "BATTLE_89_M2_SERVER_REPLAY_RESULT.json"),
                              sb.ToString(), new UTF8Encoding(false));
            Debug.Log($"[GirlsWarLua] M2 serverReplay ran={replayRan} isValid={isValid} bigRound={bigRound} failStage={failStage} err={err}");
        }

        private static void Safe(LuaEnv env, string lua, System.Collections.Generic.List<string> stages,
                                 ref string failStage, ref string err, bool optional = false)
        {
            try { env.DoString(lua); stages.Add(lua.Length > 32 ? lua.Substring(0, 32) + "..." : lua); }
            catch (Exception e)
            {
                if (optional) { stages.Add("(opt-fail)" + (lua.Length > 24 ? lua.Substring(0, 24) : lua)); return; }
                failStage = lua.Length > 48 ? lua.Substring(0, 48) + "..." : lua;
                err = e.Message;
            }
        }
    }
}
