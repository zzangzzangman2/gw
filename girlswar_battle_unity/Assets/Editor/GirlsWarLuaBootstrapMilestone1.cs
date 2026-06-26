// GirlsWar offline-battle Milestone 1: prove the xLua VM boots and the custom loader
// resolves decoded battle Lua. Headless, batchmode-friendly (no GUI, matches workflow).
//
// Run:
//   Unity.exe -quit -batchmode -nographics -projectPath girlswar_battle_unity \
//     -executeMethod GirlsWar.GirlsWarLuaBootstrapMilestone1.Run \
//     -logFile reports/battle/BATTLE_86_XLUA_BOOTSTRAP_M1.log
//
// Writes reports/battle/BATTLE_86_XLUA_BOOTSTRAP_M1_RESULT.json with a real pass/fail.
// This does NOT yet run a battle — it verifies the runtime foundation only.
using System;
using System.IO;
using System.Text;
using UnityEditor;
using UnityEngine;
using XLua;

namespace GirlsWar
{
    public static class GirlsWarLuaBootstrapMilestone1
    {
        public static void Run()
        {
            var sb = new StringBuilder();
            sb.Append("{\n");
            bool envOk = false, loaderOk = false, requireOk = false;
            int indexCount = 0;
            string err = "";
            string probeModule = "DataNode/DataTable/Create/constant/DTBattleDBModel";

            LuaEnv env = null;
            try
            {
                env = new LuaEnv();
                envOk = true;

                env.AddLoader((ref string p) => GirlsWarLuaLoader.Load(ref p));
                indexCount = GirlsWarLuaLoader.IndexCount;
                loaderOk = indexCount > 0;

                // A data-table module is the cleanest probe: pure Lua, fewest CS.* deps.
                // require() success proves: VM up + custom loader resolves decoded files.
                env.DoString($"local m = require('{probeModule}'); assert(m ~= nil)");
                requireOk = true;
            }
            catch (Exception e)
            {
                err = e.Message.Replace("\\", "/").Replace("\"", "'");
            }
            finally
            {
                try { env?.Dispose(); } catch { }
            }

            sb.Append($"  \"milestone\": \"BATTLE_86_xlua_bootstrap_m1\",\n");
            sb.Append($"  \"decodedRoot\": \"{GirlsWarLuaLoader.DecodedRoot.Replace("\\", "/")}\",\n");
            sb.Append($"  \"luaEnvCreated\": {envOk.ToString().ToLower()},\n");
            sb.Append($"  \"loaderIndexed\": {loaderOk.ToString().ToLower()},\n");
            sb.Append($"  \"loaderIndexCount\": {indexCount},\n");
            sb.Append($"  \"probeModule\": \"{probeModule}\",\n");
            sb.Append($"  \"probeRequireOk\": {requireOk.ToString().ToLower()},\n");
            sb.Append($"  \"error\": \"{err}\"\n");
            sb.Append("}\n");

            var outDir = Path.GetFullPath(Path.Combine(Application.dataPath, "..", "..", "reports", "battle"));
            Directory.CreateDirectory(outDir);
            var outPath = Path.Combine(outDir, "BATTLE_86_XLUA_BOOTSTRAP_M1_RESULT.json");
            File.WriteAllText(outPath, sb.ToString(), new UTF8Encoding(false));

            Debug.Log($"[GirlsWarLua] M1 envOk={envOk} loaderIndex={indexCount} requireOk={requireOk} err={err}");
            Debug.Log($"[GirlsWarLua] result -> {outPath}");
        }
    }
}
