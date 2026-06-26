// GirlsWar offline-battle — core CS.YouYou.* stubs (Claude / logic lane).
// Minimal, headless-first. Enough surface for the battle Lua to load and run its logic;
// view/audio/UI subsystems are no-ops. Codex enriches the view classes for M3.
//
// These are reflection-bound by xLua (CS.YouYou.X). Expand members as the M2 run reveals.
using System;
using System.Collections.Generic;

namespace YouYou
{
    // Build/config flags. DISABLE_ASSETBUNDLE gates thousands of load branches; offline we
    // run from local decoded Lua + local assets, i.e. the non-bundle/dev path.
    public static class MacroDefine
    {
        public const bool DISABLE_ASSETBUNDLE = true;
        public const bool DEBUG_MODEL = false;
        public const bool DEBUG_LOG_RESOURCE = false;
        public const bool DEBUG_LOG_PROTO = false;
        public const bool DEBUG_LOG_PROCEDURE = false;
        public const bool DEBUG_LOG_NORMAL = false;
        public const bool DEBUG_LOG_ERROR = true;
        public const bool DEBUG_LOG_BATTLE = false;
    }

    public enum ProcedureState
    {
        None = 0,
        LogOn,
        MainCity,
        NormalBattle,
        TestBattle,
        Tower,
        Puzzling,
        War,
        TryEnterMainCity,
    }

    // Async asset loader — headless: run callbacks synchronously / no-op.
    public static class AsyncLoadManager
    {
        public static void AddAsyncLoadTasks(object task) { }
        public static void RemoveAsyncLoadTasks(object task) { }
        public static void ClearAll() { }
    }
}
