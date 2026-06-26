// GirlsWar offline-battle — C# YouYou.GameEntry stub (Claude / core lane).
// The GLOBAL `GameEntry` is shadowed by the harness's permissive Lua NOOP (handles the
// huge GameEntry.X:Y() surface for free). This C# type exists for the few DIRECT
// `CS.YouYou.GameEntry.X` accesses inside real framework modules (GameTools, etc.).
// Object-returning members hand back the harness's Lua NOOP so `form:GetXxx()` chains
// stay no-crash headless. Covers the observed subsystem surface; extend on new blockers.
using System;
using XLua;

namespace GirlsWar
{
    // Set by the harness to the Lua permissive NOOP table; returned for object-valued members.
    public static class LuaNoopHolder
    {
        public static LuaTable Noop;
        public static object N => Noop;
    }
}

namespace YouYou
{
    using GirlsWar;

    public static class GameEntry
    {
        public static readonly GE_UI UI = new GE_UI();
        public static readonly GE_Time Time = new GE_Time();
        public static readonly GE_Instance Instance = new GE_Instance();
        public static readonly GE_Video Video = new GE_Video();
        public static readonly GE_Pool Pool = new GE_Pool();
        public static readonly GE_Audio Audio = new GE_Audio();
        public static readonly GE_Procedure Procedure = new GE_Procedure();
        public static readonly GE_Effect Effect = new GE_Effect();
        public static readonly GE_CameraCtrl CameraCtrl = new GE_CameraCtrl();
        public static readonly GE_Resource Resource = new GE_Resource();

        public static string AppVer = "1.0.0";
        public static bool IsReview() { return false; }
        public static bool IsCommittee() { return false; }
        public static void LogError(object o) { }
    }

    public class GE_UI
    {
        public object OpenUIForm(object a, object b = null, object c = null) { return LuaNoopHolder.N; }
        public bool IsExists(object a) { return false; }
        public void CloseUIForm(object a) { }
        public void ShowUIForm(object a) { }
        public void HideUIForm(object a) { }
        public void SetSortingOrder(object a, object b = null) { }
        public object GetLastEnableUILayer() { return LuaNoopHolder.N; }
        public object GetBgMusic(object a = null) { return null; }
        public bool IsDisableUILayer(object a) { return false; }
        public float GetUIScale() { return 1f; }
        public float GetAdjustOGSizeRate() { return 1f; }
        public float CurrScreenWidthRatio = 1f;
        public float CurrScreenHeightRatio = 1f;
    }

    public class GE_Time
    {
        public void RemoveTimeActionByName(object name) { }
        public object AddTimeAction(object a = null, object b = null, object c = null, object d = null) { return null; }
        public void RemoveTimeAction(object a) { }
    }

    public class GE_Instance
    {
        public object UIRoot => LuaNoopHolder.N;
        public object UI3DRoot => LuaNoopHolder.N;
        public object UIRootCanvas => LuaNoopHolder.N;
        public object UIRootCanvasScaler => LuaNoopHolder.N;
        public object VideoPlayerImage => LuaNoopHolder.N;
        public float StandardHeight = 1280f;
        public float MinWidth = 720f;
        public float MaxWidth = 1280f;
        public object OGDesignSize => LuaNoopHolder.N;
        public object StartCoroutine(object a) { return null; }
        public void StopCoroutine(object a) { }
        public void StopAllCoroutines() { }
    }

    public class GE_Video
    {
        public void PrepareVideo(object a = null, object b = null, object c = null) { }
        public void Stop() { }
    }

    public class GE_Pool
    {
        public object GameObjectSpawn(object a = null, object b = null) { return LuaNoopHolder.N; }
        public object GameObjectSpawnWithPath(object a = null, object b = null) { return LuaNoopHolder.N; }
        public void GameObjectDespawn(object a = null) { }
        public void ReleaseAndDestroyUnused() { }
    }

    public class GE_Audio
    {
        public object PlayAudio(object a = null, object b = null, object c = null) { return 0; }
        public void StopAudio(object a = null) { }
        public void StopAllAudio() { }
        public void StopBGM() { }
        public void PauseBGM() { }
        public void PausedAllAudio() { }
        public void SetBGMVolumeSlow(object a = null) { }
        public int GetBGMCurrAudioEventId() { return 0; }
    }

    public class GE_Procedure
    {
        public object CurrProcedureState => ProcedureState.NormalBattle;
        public void ChangeState(object a = null, object b = null) { }
    }

    public class GE_Effect
    {
        public object ShowUIEffect(object a = null, object b = null, object c = null) { return LuaNoopHolder.N; }
        public object ShowBuffEffect(object a = null, object b = null, object c = null) { return LuaNoopHolder.N; }
        public object ShowEffect(object a = null, object b = null, object c = null) { return LuaNoopHolder.N; }
        public object ShowEffectPro(object a = null, object b = null, object c = null) { return LuaNoopHolder.N; }
        public void RemoveEffect(object a = null) { }
    }

    public class GE_CameraCtrl
    {
        public object MainCamera => LuaNoopHolder.N;
        public object UICamera => LuaNoopHolder.N;
        public object transform => LuaNoopHolder.N;
        public object SpeedLineContainer => LuaNoopHolder.N;
        public void CameraMaskChangeColor(object a = null, object b = null) { }
        public void ResetMainCameraPos() { }
        public void RadialBlurSetActive(object a = null) { }
        public void OpenOrCloseMainCamera(object a = null) { }
    }

    public class GE_Resource
    {
        public object ResourceManager => LuaNoopHolder.N;
        public object ResourceLoaderManager => LuaNoopHolder.N;
    }
}
