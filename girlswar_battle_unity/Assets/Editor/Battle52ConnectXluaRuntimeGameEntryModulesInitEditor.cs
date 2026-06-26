using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;
using System;
using System.Collections.Generic;
using System.IO;
using System.Reflection;
using System.Text;

public static class Battle52ConnectXluaRuntimeGameEntryModulesInitEditor
{
    private const string ScenePath = "Assets/Scenes/Battle51LuaBridgeRaycasterRegistrationCandidate.unity";
    private const string InputCsvPath = "Assets/RestoreData/battle/BATTLE_51_RESTORE_SOURCE_BACKED_LUAUNIT_UIEVENTLISTENER_AND_EVENTSYSTEM_RAYCASTER_REGISTRATION_COMPONENTS.csv";
    private const string EditJsonPath = "Assets/RestoreData/battle/BATTLE_52_CONNECT_XLUA_RUNTIME_GAMEENTRY_MODULESINIT_PROCEDURE_NORMAL_BATTLE_OR_BLOCK_EDITMODE.json";
    private const string EditRowsCsvPath = "Assets/RestoreData/battle/BATTLE_52_CONNECT_XLUA_RUNTIME_GAMEENTRY_MODULESINIT_PROCEDURE_NORMAL_BATTLE_OR_BLOCK_EDITMODE.csv";
    private const string TypeCsvPath = "Assets/RestoreData/battle/BATTLE_52_CONNECT_XLUA_RUNTIME_GAMEENTRY_MODULESINIT_PROCEDURE_NORMAL_BATTLE_OR_BLOCK_TYPES.csv";
    private const string PlayJsonPath = "Assets/RestoreData/battle/BATTLE_52_CONNECT_XLUA_RUNTIME_GAMEENTRY_MODULESINIT_PROCEDURE_NORMAL_BATTLE_OR_BLOCK_PLAYMODE.json";
    private const string PlayRowsCsvPath = "Assets/RestoreData/battle/BATTLE_52_CONNECT_XLUA_RUNTIME_GAMEENTRY_MODULESINIT_PROCEDURE_NORMAL_BATTLE_OR_BLOCK_PLAYMODE.csv";
    private const string SessionStateKey = "BATTLE52_PLAYMODE_STATE";
    private const string SessionFrameKey = "BATTLE52_PLAYMODE_FRAME";

    private static readonly string[] ButtonOrder = { "btnAuto", "btnBuff", "btnTwoSpeed", "btnFastSkill", "btn_box" };

    static Battle52ConnectXluaRuntimeGameEntryModulesInitEditor()
    {
        if (SessionState.GetString(SessionStateKey, "") == "waiting")
            EditorApplication.update += PlayModeUpdate;
    }

    [MenuItem("GirlsWar/Battle/BATTLE52 EditMode Probe")]
    public static void Build()
    {
        Directory.CreateDirectory(ProjectPath("Assets/RestoreData/battle"));
        var summary = new Summary();
        var rows = new List<Row>();
        summary.phase = "editmode";
        summary.scene = ScenePath;
        summary.isFinalRestoredBattleScreen = false;
        summary.xluaRuntimeAvailable = Type.GetType("XLua.LuaEnv, Assembly-CSharp") != null || FindType("XLua.LuaEnv") != null;
        summary.xluaLuaTableAvailable = FindType("XLua.LuaTable") != null;
        summary.xluaLuaFunctionAvailable = FindType("XLua.LuaFunction") != null;
        summary.youyouGameEntryAvailable = FindType("YouYou.GameEntry") != null || FindType("GameEntry") != null;
        summary.youyouLuaManagerAvailable = FindType("YouYou.LuaManager") != null || FindType("LuaManager") != null;
        summary.youyouLuaFormAvailable = FindType("YouYou.LuaForm") != null;
        summary.youyouLuaUnitAvailable = FindType("YouYou.LuaUnit") != null;
        summary.luaComBinderAvailable = FindType("LuaComponentBinder.LuaComBinder") != null;
        summary.uiEventListenerAvailable = FindType("YouYou.UIEventListener") != null;
        summary.projectXluaAssetCount = FindProjectXluaAssets().Count;
        summary.projectXluaAssets = string.Join(" | ", FindProjectXluaAssets().ToArray());

        if (!File.Exists(ProjectPath(ScenePath)))
        {
            summary.failReason = "scene_file_not_found";
            WriteSummary(ProjectPath(EditJsonPath), summary);
            WriteRows(ProjectPath(EditRowsCsvPath), rows);
            WriteTypes(ProjectPath(TypeCsvPath), summary);
            return;
        }

        var scene = EditorSceneManager.OpenScene(ScenePath, OpenSceneMode.Single);
        summary.sceneOpened = scene.IsValid();
        PrepareDepth();
        FillSceneCounts(summary, "before");
        summary.raycasterManagerBefore = RaycasterManagerSummary();
        rows = ProbeRows("edit_before_forced");
        SummarizeRows(summary, rows, "before");

        ToggleRaycasters();
        PrepareDepth();
        summary.raycasterManagerAfterToggle = RaycasterManagerSummary();
        var toggleRows = ProbeRows("edit_after_toggle");
        SummarizeRows(summary, toggleRows, "toggle");

        ForceRegisterRaycasters();
        summary.raycasterManagerAfterForced = RaycasterManagerSummary();
        var forcedRows = ProbeRows("edit_after_forced");
        SummarizeRows(summary, forcedRows, "forced");

        rows.AddRange(toggleRows);
        rows.AddRange(forcedRows);
        summary.patchDecision = "blocked_missing_xlua_runtime_no_scene_patch";
        summary.nextBlocker = "BATTLE_53_RESTORE_OR_IMPORT_SOURCE_BACKED_XLUA_RUNTIME_AND_MODULESINIT_BOOTSTRAP_OR_ACCEPT_BLOCK";
        WriteSummary(ProjectPath(EditJsonPath), summary);
        WriteRows(ProjectPath(EditRowsCsvPath), rows);
        WriteTypes(ProjectPath(TypeCsvPath), summary);
        AssetDatabase.Refresh();
        Debug.Log("BATTLE52 editmode probe complete. xLua=" + summary.xluaRuntimeAvailable + " eventBefore=" + summary.eventSystemTargetIncludedBefore + " forced=" + summary.eventSystemTargetIncludedForced);
    }

    [MenuItem("GirlsWar/Battle/BATTLE52 PlayMode Probe")]
    public static void RunPlayModeProbe()
    {
        Directory.CreateDirectory(ProjectPath("Assets/RestoreData/battle"));
        SessionState.SetString(SessionStateKey, "waiting");
        SessionState.SetInt(SessionFrameKey, 0);
        if (File.Exists(ProjectPath(ScenePath)))
            EditorSceneManager.OpenScene(ScenePath, OpenSceneMode.Single);
        EditorApplication.update -= PlayModeUpdate;
        EditorApplication.update += PlayModeUpdate;
        EditorApplication.isPlaying = true;
    }

    private static void PlayModeUpdate()
    {
        if (SessionState.GetString(SessionStateKey, "") != "waiting")
        {
            EditorApplication.update -= PlayModeUpdate;
            return;
        }
        int frame = SessionState.GetInt(SessionFrameKey, 0) + 1;
        SessionState.SetInt(SessionFrameKey, frame);
        if (!EditorApplication.isPlaying)
        {
            if (frame > 600)
            {
                WritePlayModeFailure("playmode_not_entered_within_update_budget");
                SessionState.SetString(SessionStateKey, "done");
                EditorApplication.update -= PlayModeUpdate;
                EditorApplication.Exit(2);
            }
            return;
        }
        if (frame < 20) return;

        var summary = new Summary();
        summary.phase = "playmode";
        summary.scene = ScenePath;
        summary.isFinalRestoredBattleScreen = false;
        summary.sceneOpened = true;
        summary.xluaRuntimeAvailable = FindType("XLua.LuaEnv") != null;
        summary.xluaLuaTableAvailable = FindType("XLua.LuaTable") != null;
        summary.xluaLuaFunctionAvailable = FindType("XLua.LuaFunction") != null;
        summary.youyouGameEntryAvailable = FindType("YouYou.GameEntry") != null || FindType("GameEntry") != null;
        summary.youyouLuaManagerAvailable = FindType("YouYou.LuaManager") != null || FindType("LuaManager") != null;
        summary.youyouLuaFormAvailable = FindType("YouYou.LuaForm") != null;
        summary.youyouLuaUnitAvailable = FindType("YouYou.LuaUnit") != null;
        summary.luaComBinderAvailable = FindType("LuaComponentBinder.LuaComBinder") != null;
        summary.uiEventListenerAvailable = FindType("YouYou.UIEventListener") != null;
        FillSceneCounts(summary, "before");
        PrepareDepth();
        summary.raycasterManagerBefore = RaycasterManagerSummary();
        var rows = ProbeRows("playmode_one_frame");
        SummarizeRows(summary, rows, "before");
        summary.patchDecision = "blocked_missing_xlua_runtime_no_scene_patch";
        summary.nextBlocker = "BATTLE_53_RESTORE_OR_IMPORT_SOURCE_BACKED_XLUA_RUNTIME_AND_MODULESINIT_BOOTSTRAP_OR_ACCEPT_BLOCK";
        WriteSummary(ProjectPath(PlayJsonPath), summary);
        WriteRows(ProjectPath(PlayRowsCsvPath), rows);
        SessionState.SetString(SessionStateKey, "done");
        EditorApplication.update -= PlayModeUpdate;
        EditorApplication.isPlaying = false;
        EditorApplication.Exit(0);
    }

    private static void WritePlayModeFailure(string reason)
    {
        var summary = new Summary();
        summary.phase = "playmode";
        summary.scene = ScenePath;
        summary.isFinalRestoredBattleScreen = false;
        summary.failReason = reason;
        summary.patchDecision = "blocked_missing_xlua_runtime_no_scene_patch";
        WriteSummary(ProjectPath(PlayJsonPath), summary);
        WriteRows(ProjectPath(PlayRowsCsvPath), new List<Row>());
    }

    private static List<Row> ProbeRows(string phase)
    {
        var inputs = LoadInputRows(ProjectPath(InputCsvPath));
        var rows = new List<Row>();
        foreach (var input in inputs)
        {
            if (Array.IndexOf(ButtonOrder, input.buttonName) < 0) continue;
            var transform = FindTransform(input.buttonScenePath);
            var button = transform != null ? transform.GetComponent<Button>() : null;
            if (button == null) continue;
            var row = new Row();
            row.phase = phase;
            row.buttonName = input.buttonName;
            row.pointerPosition = input.pointerPosition;
            row.buttonScenePath = input.buttonScenePath;
            row.handlerPath = HandlerFor(input.buttonName);
            row.buttonInteractable = button.interactable;
            row.buttonOnClickPersistentCount = button.onClick.GetPersistentEventCount();
            row.buttonOnClickRuntimeCount = RuntimeListenerCount(button.onClick);
            var listener = button.GetComponent<YouYou.UIEventListener>();
            row.uiEventListenerPresent = listener != null;
            row.uiEventListenerHasDelegate = listener != null && listener.onClick != null;
            row.luaLifecycleExecuted = LuaLifecycleExecuted(input.buttonName);
            ProbeRaycasts(row, button);
            rows.Add(row);
        }
        return rows;
    }

    private static bool LuaLifecycleExecuted(string buttonName)
    {
        if (buttonName == "btn_box")
        {
            var unit = GetAt<YouYou.LuaUnit>("BattleHudSpriteAtlasTextureRuntimeBindingClip05Root/CanvasLuaStateHUD_02_ui_battle3dui/root_battle/UI_BattleBoxPage");
            return unit != null && (unit.InitCalled || unit.OpenCalled);
        }
        var normal = GetAt<YouYou.LuaForm>("BattleHudSpriteAtlasTextureRuntimeBindingClip05Root/CanvasLuaStateHUD_01_ui_normalbattle");
        return false && normal != null;
    }

    private static void ProbeRaycasts(Row row, Button button)
    {
        var eventSystem = UnityEngine.Object.FindObjectOfType<EventSystem>(true);
        if (eventSystem != null)
        {
            EventSystem.current = eventSystem;
            try { eventSystem.UpdateModules(); } catch { }
        }
        var pointer = new PointerEventData(eventSystem);
        pointer.position = ParseVec2(row.pointerPosition);
        pointer.button = PointerEventData.InputButton.Left;
        pointer.pointerId = -1;
        pointer.clickCount = 1;
        pointer.clickTime = Time.unscaledTime;
        if (eventSystem != null)
        {
            var eventHits = new List<RaycastResult>();
            eventSystem.RaycastAll(pointer, eventHits);
            row.eventSystemRaycastAllCount = eventHits.Count;
            row.eventTargetIncluded = TargetIncluded(row.buttonScenePath, eventHits);
            row.eventHitPaths = HitPaths(eventHits);
        }
        var canvas = button.GetComponentInParent<Canvas>(true);
        var raycaster = canvas != null ? canvas.GetComponent<GraphicRaycaster>() : null;
        if (raycaster != null)
        {
            var directHits = new List<RaycastResult>();
            raycaster.Raycast(pointer, directHits);
            row.directGraphicRaycasterHitCount = directHits.Count;
            row.directTargetIncluded = TargetIncluded(row.buttonScenePath, directHits);
            row.directHitPaths = HitPaths(directHits);
        }
        row.raycasterManagerCount = GetRaycasterManagerList().Count;
        row.raycasterManagerSummary = RaycasterManagerSummary();
    }

    private static bool TargetIncluded(string targetPath, List<RaycastResult> hits)
    {
        foreach (var hit in hits)
        {
            if (hit.gameObject == null) continue;
            string path = HierarchyPath(hit.gameObject.transform);
            if (path == targetPath || path.StartsWith(targetPath + "/")) return true;
        }
        return false;
    }

    private static string HitPaths(List<RaycastResult> hits)
    {
        var paths = new List<string>();
        for (int i = 0; i < hits.Count && paths.Count < 8; i++)
        {
            if (hits[i].gameObject == null) continue;
            paths.Add(HierarchyPath(hits[i].gameObject.transform) + "#depth=" + hits[i].depth + "#module=" + (hits[i].module != null ? hits[i].module.GetType().Name : ""));
        }
        return string.Join(" | ", paths.ToArray());
    }

    private static void ToggleRaycasters()
    {
        foreach (var raycaster in UnityEngine.Object.FindObjectsOfType<GraphicRaycaster>(true))
        {
            if (raycaster == null) continue;
            bool enabled = raycaster.enabled;
            raycaster.enabled = false;
            raycaster.enabled = enabled;
        }
    }

    private static void ForceRegisterRaycasters()
    {
        var add = FindRaycasterManagerMethod("AddRaycaster");
        if (add == null) return;
        foreach (var raycaster in UnityEngine.Object.FindObjectsOfType<BaseRaycaster>(true))
        {
            if (raycaster == null || !raycaster.isActiveAndEnabled) continue;
            try { add.Invoke(null, new object[] { raycaster }); } catch { }
        }
    }

    private static List<BaseRaycaster> GetRaycasterManagerList()
    {
        var list = new List<BaseRaycaster>();
        try
        {
            var m = FindRaycasterManagerMethod("GetRaycasters");
            var value = m != null ? m.Invoke(null, null) as System.Collections.IEnumerable : null;
            if (value != null)
                foreach (var item in value)
                    if (item is BaseRaycaster br && br != null) list.Add(br);
        }
        catch { }
        return list;
    }

    private static MethodInfo FindRaycasterManagerMethod(string method)
    {
        var assemblies = new[] { typeof(EventSystem).Assembly, typeof(BaseRaycaster).Assembly, typeof(GraphicRaycaster).Assembly };
        foreach (var assembly in assemblies)
        {
            var t = assembly.GetType("UnityEngine.EventSystems.RaycasterManager");
            var m = t != null ? t.GetMethod(method, BindingFlags.Static | BindingFlags.Public | BindingFlags.NonPublic) : null;
            if (m != null) return m;
        }
        return null;
    }

    private static string RaycasterManagerSummary()
    {
        bool typeFound = FindRaycasterManagerMethod("GetRaycasters") != null;
        var parts = new List<string>();
        foreach (var r in GetRaycasterManagerList())
            if (r != null) parts.Add(HierarchyPath(r.transform) + ":" + r.GetType().FullName + ":enabled=" + r.enabled + ":active=" + r.IsActive());
        return "typeFound=" + Bool(typeFound) + " | count=" + parts.Count + " | " + string.Join(" ; ", parts.ToArray());
    }

    private static void PrepareDepth()
    {
        Canvas.ForceUpdateCanvases();
        foreach (var graphic in UnityEngine.Object.FindObjectsOfType<Graphic>(true))
        {
            if (graphic == null) continue;
            graphic.SetLayoutDirty();
            graphic.SetVerticesDirty();
            graphic.SetMaterialDirty();
            try { CanvasUpdateRegistry.RegisterCanvasElementForGraphicRebuild(graphic); } catch { }
            try { graphic.Rebuild(CanvasUpdate.PreRender); } catch { }
        }
        Canvas.ForceUpdateCanvases();
    }

    private static void FillSceneCounts(Summary summary, string phase)
    {
        summary.canvasCount = UnityEngine.Object.FindObjectsOfType<Canvas>(true).Length;
        summary.graphicRaycasterCount = UnityEngine.Object.FindObjectsOfType<GraphicRaycaster>(true).Length;
        summary.buttonCount = UnityEngine.Object.FindObjectsOfType<Button>(true).Length;
        summary.eventSystemCount = UnityEngine.Object.FindObjectsOfType<EventSystem>(true).Length;
        summary.inputModuleCount = UnityEngine.Object.FindObjectsOfType<BaseInputModule>(true).Length;
        summary.luaFormCount = UnityEngine.Object.FindObjectsOfType<YouYou.LuaForm>(true).Length;
        summary.luaUnitCount = UnityEngine.Object.FindObjectsOfType<YouYou.LuaUnit>(true).Length;
        summary.luaComBinderCount = UnityEngine.Object.FindObjectsOfType<LuaComponentBinder.LuaComBinder>(true).Length;
        summary.uiEventListenerCount = UnityEngine.Object.FindObjectsOfType<YouYou.UIEventListener>(true).Length;
    }

    private static void SummarizeRows(Summary summary, List<Row> rows, string slot)
    {
        int eventIncluded = 0;
        int directIncluded = 0;
        int listeners = 0;
        int luaLifecycle = 0;
        foreach (var row in rows)
        {
            if (row.eventTargetIncluded) eventIncluded++;
            if (row.directTargetIncluded) directIncluded++;
            if (row.buttonOnClickPersistentCount + row.buttonOnClickRuntimeCount > 0 || row.uiEventListenerHasDelegate) listeners++;
            if (row.luaLifecycleExecuted) luaLifecycle++;
        }
        if (slot == "before")
        {
            summary.eventSystemTargetIncludedBefore = eventIncluded;
            summary.directGraphicTargetIncludedBefore = directIncluded;
            summary.listenerBoundBefore = listeners;
            summary.luaLifecycleExecutedBefore = luaLifecycle;
        }
        else if (slot == "toggle")
        {
            summary.eventSystemTargetIncludedAfterToggle = eventIncluded;
        }
        else if (slot == "forced")
        {
            summary.eventSystemTargetIncludedForced = eventIncluded;
        }
    }

    private static List<string> FindProjectXluaAssets()
    {
        var assets = new List<string>();
        string assetsRoot = Application.dataPath;
        if (!Directory.Exists(assetsRoot)) return assets;
        foreach (var path in Directory.GetFiles(assetsRoot, "*", SearchOption.AllDirectories))
        {
            string p = path.Replace("\\", "/");
            string name = Path.GetFileName(path);
            if (p.IndexOf("/Library/", StringComparison.OrdinalIgnoreCase) >= 0) continue;
            if (p.IndexOf("xlua", StringComparison.OrdinalIgnoreCase) >= 0 || name.IndexOf("xlua", StringComparison.OrdinalIgnoreCase) >= 0)
                assets.Add("Assets" + p.Substring(assetsRoot.Replace("\\", "/").Length));
        }
        return assets;
    }

    private static Type FindType(string fullName)
    {
        foreach (var assembly in AppDomain.CurrentDomain.GetAssemblies())
        {
            Type t = null;
            try { t = assembly.GetType(fullName, false); } catch { }
            if (t != null) return t;
        }
        return null;
    }

    private static int RuntimeListenerCount(UnityEngine.Events.UnityEvent evt)
    {
        try
        {
            var baseType = typeof(UnityEngine.Events.UnityEventBase);
            var callsField = baseType.GetField("m_Calls", BindingFlags.Instance | BindingFlags.NonPublic);
            var calls = callsField != null ? callsField.GetValue(evt) : null;
            if (calls == null) return 0;
            var runtimeField = calls.GetType().GetField("m_RuntimeCalls", BindingFlags.Instance | BindingFlags.NonPublic);
            var runtime = runtimeField != null ? runtimeField.GetValue(calls) as System.Collections.ICollection : null;
            return runtime != null ? runtime.Count : 0;
        }
        catch { return 0; }
    }

    private static T GetAt<T>(string path) where T : Component
    {
        var transform = FindTransform(path);
        return transform != null ? transform.GetComponent<T>() : null;
    }

    private static Transform FindTransform(string path)
    {
        foreach (var transform in UnityEngine.Object.FindObjectsOfType<Transform>(true))
            if (HierarchyPath(transform) == path) return transform;
        return null;
    }

    private static List<InputRow> LoadInputRows(string path)
    {
        var rows = new List<InputRow>();
        if (!File.Exists(path)) return rows;
        var lines = File.ReadAllLines(path, new UTF8Encoding(true));
        if (lines.Length < 2) return rows;
        var headers = SplitCsvLine(lines[0]);
        for (int i = 1; i < lines.Length; i++)
        {
            var map = RowMap(headers, SplitCsvLine(lines[i]));
            string button = Get(map, "buttonName");
            if (Array.IndexOf(ButtonOrder, button) < 0) continue;
            rows.Add(new InputRow
            {
                buttonName = button,
                pointerPosition = Get(map, "pointerPosition"),
                buttonScenePath = Get(map, "buttonScenePath")
            });
        }
        return rows;
    }

    private static string HandlerFor(string button)
    {
        if (button == "btnAuto") return "UI_NormalBattle:86-110 ChangeToAuto(true)/ChangeToManual";
        if (button == "btnBuff") return "UI_NormalBattle:180-184 ShowBuffView(f==false)";
        if (button == "btnTwoSpeed") return "UI_NormalBattle:111-131 SetGameSpeed";
        if (button == "btnFastSkill") return "UI_NormalBattle:132-146 ChangeGameFastSkill/CheckFastSkill";
        if (button == "btn_box") return "UI_BattleBoxPage:162-178 UIEventListener.onClick showFlyAction/RecycleBoxInstance";
        return "";
    }

    private static Dictionary<string, string> RowMap(List<string> headers, List<string> values)
    {
        var map = new Dictionary<string, string>();
        for (int i = 0; i < headers.Count && i < values.Count; i++) map[headers[i]] = values[i];
        return map;
    }

    private static List<string> SplitCsvLine(string line)
    {
        var values = new List<string>();
        var sb = new StringBuilder();
        bool quote = false;
        for (int i = 0; i < line.Length; i++)
        {
            char c = line[i];
            if (quote && c == '"' && i + 1 < line.Length && line[i + 1] == '"') { sb.Append('"'); i++; }
            else if (c == '"') quote = !quote;
            else if (c == ',' && !quote) { values.Add(sb.ToString()); sb.Length = 0; }
            else sb.Append(c);
        }
        values.Add(sb.ToString());
        return values;
    }

    private static Vector2 ParseVec2(string value)
    {
        var parts = (value ?? "0/0").Split('/');
        float x = 0, y = 0;
        if (parts.Length > 0) float.TryParse(parts[0], System.Globalization.NumberStyles.Float, System.Globalization.CultureInfo.InvariantCulture, out x);
        if (parts.Length > 1) float.TryParse(parts[1], System.Globalization.NumberStyles.Float, System.Globalization.CultureInfo.InvariantCulture, out y);
        return new Vector2(x, y);
    }

    private static string Get(Dictionary<string, string> map, string key) { return map.ContainsKey(key) ? map[key] : ""; }
    private static string HierarchyPath(Transform transform) { var names = new List<string>(); var cursor = transform; while (cursor != null) { names.Add(cursor.name); cursor = cursor.parent; } names.Reverse(); return string.Join("/", names.ToArray()); }
    private static string ProjectPath(string assetPath) { return Path.Combine(Application.dataPath, "..", assetPath.Replace("/", "\\")); }
    private static string Bool(bool value) { return value ? "true" : "false"; }
    private static string Csv(string value) { return "\"" + (value ?? "").Replace("\"", "\"\"") + "\""; }
    private static string Json(string value) { return (value ?? "").Replace("\\", "\\\\").Replace("\"", "\\\"").Replace("\r", " ").Replace("\n", " "); }

    private static void WriteRows(string path, List<Row> rows)
    {
        Directory.CreateDirectory(Path.GetDirectoryName(path));
        var sb = new StringBuilder();
        sb.AppendLine("phase,buttonName,pointerPosition,buttonScenePath,handlerPath,luaLifecycleExecuted,buttonInteractable,buttonOnClickPersistentCount,buttonOnClickRuntimeCount,uiEventListenerPresent,uiEventListenerHasDelegate,eventSystemRaycastAllCount,eventTargetIncluded,eventHitPaths,directGraphicRaycasterHitCount,directTargetIncluded,directHitPaths,raycasterManagerCount,raycasterManagerSummary");
        foreach (var r in rows)
            sb.AppendLine(string.Join(",", new[]
            {
                Csv(r.phase), Csv(r.buttonName), Csv(r.pointerPosition), Csv(r.buttonScenePath), Csv(r.handlerPath), Bool(r.luaLifecycleExecuted),
                Bool(r.buttonInteractable), r.buttonOnClickPersistentCount.ToString(), r.buttonOnClickRuntimeCount.ToString(), Bool(r.uiEventListenerPresent), Bool(r.uiEventListenerHasDelegate),
                r.eventSystemRaycastAllCount.ToString(), Bool(r.eventTargetIncluded), Csv(r.eventHitPaths), r.directGraphicRaycasterHitCount.ToString(), Bool(r.directTargetIncluded), Csv(r.directHitPaths),
                r.raycasterManagerCount.ToString(), Csv(r.raycasterManagerSummary)
            }));
        File.WriteAllText(path, sb.ToString(), new UTF8Encoding(false));
    }

    private static void WriteTypes(string path, Summary s)
    {
        Directory.CreateDirectory(Path.GetDirectoryName(path));
        var sb = new StringBuilder();
        sb.AppendLine("typeName,available,evidence");
        sb.AppendLine("XLua.LuaEnv," + Bool(s.xluaRuntimeAvailable) + ",current Unity project AppDomain/assets");
        sb.AppendLine("XLua.LuaTable," + Bool(s.xluaLuaTableAvailable) + ",required by original LuaForm/LuaUnit/LuaManager dump");
        sb.AppendLine("XLua.LuaFunction," + Bool(s.xluaLuaFunctionAvailable) + ",required by original LuaManager delegates");
        sb.AppendLine("YouYou.GameEntry," + Bool(s.youyouGameEntryAvailable) + ",original dump exposes static GameEntry.Lua/UI/Procedure");
        sb.AppendLine("YouYou.LuaManager," + Bool(s.youyouLuaManagerAvailable) + ",original dump exposes LuaManager.LoadUIScript/MyLoader/GetLuaBuff");
        sb.AppendLine("YouYou.LuaForm," + Bool(s.youyouLuaFormAvailable) + ",BATTLE51 source-backed bridge stub persists");
        sb.AppendLine("YouYou.LuaUnit," + Bool(s.youyouLuaUnitAvailable) + ",BATTLE51 source-backed bridge stub persists");
        sb.AppendLine("LuaComponentBinder.LuaComBinder," + Bool(s.luaComBinderAvailable) + ",BATTLE51 source-backed bridge stub persists");
        sb.AppendLine("YouYou.UIEventListener," + Bool(s.uiEventListenerAvailable) + ",BATTLE51 source-backed bridge stub persists");
        File.WriteAllText(path, sb.ToString(), new UTF8Encoding(false));
    }

    private static void WriteSummary(string path, Summary s)
    {
        Directory.CreateDirectory(Path.GetDirectoryName(path));
        var sb = new StringBuilder();
        sb.Append("{\n");
        sb.Append("  \"phase\":\"" + Json(s.phase) + "\",\n");
        sb.Append("  \"scene\":\"" + Json(s.scene) + "\",\n");
        sb.Append("  \"sceneOpened\":" + Bool(s.sceneOpened) + ",\n");
        sb.Append("  \"isFinalRestoredBattleScreen\":false,\n");
        sb.Append("  \"xluaRuntimeAvailable\":" + Bool(s.xluaRuntimeAvailable) + ",\n");
        sb.Append("  \"xluaLuaTableAvailable\":" + Bool(s.xluaLuaTableAvailable) + ",\n");
        sb.Append("  \"xluaLuaFunctionAvailable\":" + Bool(s.xluaLuaFunctionAvailable) + ",\n");
        sb.Append("  \"youyouGameEntryAvailable\":" + Bool(s.youyouGameEntryAvailable) + ",\n");
        sb.Append("  \"youyouLuaManagerAvailable\":" + Bool(s.youyouLuaManagerAvailable) + ",\n");
        sb.Append("  \"youyouLuaFormAvailable\":" + Bool(s.youyouLuaFormAvailable) + ",\n");
        sb.Append("  \"youyouLuaUnitAvailable\":" + Bool(s.youyouLuaUnitAvailable) + ",\n");
        sb.Append("  \"luaComBinderAvailable\":" + Bool(s.luaComBinderAvailable) + ",\n");
        sb.Append("  \"uiEventListenerAvailable\":" + Bool(s.uiEventListenerAvailable) + ",\n");
        sb.Append("  \"projectXluaAssetCount\":" + s.projectXluaAssetCount + ",\n");
        sb.Append("  \"projectXluaAssets\":\"" + Json(s.projectXluaAssets) + "\",\n");
        sb.Append("  \"canvasCount\":" + s.canvasCount + ",\n");
        sb.Append("  \"graphicRaycasterCount\":" + s.graphicRaycasterCount + ",\n");
        sb.Append("  \"buttonCount\":" + s.buttonCount + ",\n");
        sb.Append("  \"eventSystemCount\":" + s.eventSystemCount + ",\n");
        sb.Append("  \"inputModuleCount\":" + s.inputModuleCount + ",\n");
        sb.Append("  \"luaFormCount\":" + s.luaFormCount + ",\n");
        sb.Append("  \"luaUnitCount\":" + s.luaUnitCount + ",\n");
        sb.Append("  \"luaComBinderCount\":" + s.luaComBinderCount + ",\n");
        sb.Append("  \"uiEventListenerCount\":" + s.uiEventListenerCount + ",\n");
        sb.Append("  \"directGraphicTargetIncludedBefore\":" + s.directGraphicTargetIncludedBefore + ",\n");
        sb.Append("  \"eventSystemTargetIncludedBefore\":" + s.eventSystemTargetIncludedBefore + ",\n");
        sb.Append("  \"eventSystemTargetIncludedAfterToggle\":" + s.eventSystemTargetIncludedAfterToggle + ",\n");
        sb.Append("  \"eventSystemTargetIncludedForced\":" + s.eventSystemTargetIncludedForced + ",\n");
        sb.Append("  \"listenerBoundBefore\":" + s.listenerBoundBefore + ",\n");
        sb.Append("  \"luaLifecycleExecutedBefore\":" + s.luaLifecycleExecutedBefore + ",\n");
        sb.Append("  \"raycasterManagerBefore\":\"" + Json(s.raycasterManagerBefore) + "\",\n");
        sb.Append("  \"raycasterManagerAfterToggle\":\"" + Json(s.raycasterManagerAfterToggle) + "\",\n");
        sb.Append("  \"raycasterManagerAfterForced\":\"" + Json(s.raycasterManagerAfterForced) + "\",\n");
        sb.Append("  \"failReason\":\"" + Json(s.failReason) + "\",\n");
        sb.Append("  \"patchDecision\":\"" + Json(s.patchDecision) + "\",\n");
        sb.Append("  \"nextBlocker\":\"" + Json(s.nextBlocker) + "\"\n");
        sb.Append("}\n");
        File.WriteAllText(path, sb.ToString(), new UTF8Encoding(false));
    }

    private class InputRow
    {
        public string buttonName;
        public string pointerPosition;
        public string buttonScenePath;
    }

    private class Row
    {
        public string phase;
        public string buttonName;
        public string pointerPosition;
        public string buttonScenePath;
        public string handlerPath;
        public bool luaLifecycleExecuted;
        public bool buttonInteractable;
        public int buttonOnClickPersistentCount;
        public int buttonOnClickRuntimeCount;
        public bool uiEventListenerPresent;
        public bool uiEventListenerHasDelegate;
        public int eventSystemRaycastAllCount;
        public bool eventTargetIncluded;
        public string eventHitPaths;
        public int directGraphicRaycasterHitCount;
        public bool directTargetIncluded;
        public string directHitPaths;
        public int raycasterManagerCount;
        public string raycasterManagerSummary;
    }

    private class Summary
    {
        public string phase;
        public string scene;
        public bool sceneOpened;
        public bool isFinalRestoredBattleScreen;
        public bool xluaRuntimeAvailable;
        public bool xluaLuaTableAvailable;
        public bool xluaLuaFunctionAvailable;
        public bool youyouGameEntryAvailable;
        public bool youyouLuaManagerAvailable;
        public bool youyouLuaFormAvailable;
        public bool youyouLuaUnitAvailable;
        public bool luaComBinderAvailable;
        public bool uiEventListenerAvailable;
        public int projectXluaAssetCount;
        public string projectXluaAssets;
        public int canvasCount;
        public int graphicRaycasterCount;
        public int buttonCount;
        public int eventSystemCount;
        public int inputModuleCount;
        public int luaFormCount;
        public int luaUnitCount;
        public int luaComBinderCount;
        public int uiEventListenerCount;
        public int directGraphicTargetIncludedBefore;
        public int eventSystemTargetIncludedBefore;
        public int eventSystemTargetIncludedAfterToggle;
        public int eventSystemTargetIncludedForced;
        public int listenerBoundBefore;
        public int luaLifecycleExecutedBefore;
        public string raycasterManagerBefore;
        public string raycasterManagerAfterToggle;
        public string raycasterManagerAfterForced;
        public string failReason;
        public string patchDecision;
        public string nextBlocker;
    }
}
