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

public static class Battle50OriginalLuaIl2cppButtonHandlerTraceEditor
{
    private const string SourceScenePath = "Assets/Scenes/Battle49RealClickInputHandlerValidation.unity";
    private const string ScenePath = "Assets/Scenes/Battle50OriginalLuaIl2cppButtonHandlerTrace.unity";
    private const string B49RowsCsvPath = "Assets/RestoreData/battle/BATTLE_49_VALIDATE_REAL_CLICK_INPUT_AND_HANDLER_BINDING_COMPONENTS.csv";
    private const string ResultJsonPath = "Assets/RestoreData/battle/BATTLE_50_TRACE_ORIGINAL_LUA_IL2CPP_BUTTON_HANDLER_BINDING_AND_MISSING_SCRIPTS_UNITY.json";
    private const string RowsCsvPath = "Assets/RestoreData/battle/BATTLE_50_TRACE_ORIGINAL_LUA_IL2CPP_BUTTON_HANDLER_BINDING_AND_MISSING_SCRIPTS_EVENTSYSTEM.csv";
    private const string CapturePath = "Assets/RestoreCaptures/battle_actor/Battle50OriginalLuaIl2cppButtonHandlerTrace_1920x1080.png";

    [MenuItem("GirlsWar/Battle/BATTLE50 Trace Original Lua IL2CPP Button Handler Binding")]
    public static void Build()
    {
        Directory.CreateDirectory(ProjectPath("Assets/RestoreData/battle"));
        Directory.CreateDirectory(ProjectPath("Assets/RestoreCaptures/battle_actor"));
        var result = new Result();
        var rows = new List<Row>();
        result.status = "battle50_trace_original_lua_il2cpp_button_handler_binding_and_missing_scripts";
        result.isFinalRestoredBattleScreen = false;
        result.sourceScene = SourceScenePath;
        result.scene = ScenePath;
        result.capture = CapturePath;

        if (!File.Exists(ProjectPath(SourceScenePath)))
        {
            result.failReason = "source_scene_file_not_found";
            WriteOutputs(result, rows);
            return;
        }

        var inputRows = LoadB49Rows(ProjectPath(B49RowsCsvPath));
        result.b49InputRows = inputRows.Count;
        var scene = EditorSceneManager.OpenScene(SourceScenePath, OpenSceneMode.Single);
        result.sourceSceneOpened = scene.IsValid();
        var camera = FindCaptureCamera();
        if (camera != null) ConfigureCamera(camera);
        PrepareDepth(camera);
        Snapshot(result, "before");
        FillEventSystemSummary(result);
        result.raycasterManagerBefore = RaycasterManagerSummary();

        foreach (var input in inputRows)
        {
            var buttonTransform = FindTransform(input.buttonScenePath);
            if (buttonTransform == null) continue;
            var button = buttonTransform.GetComponent<Button>();
            if (button == null) continue;
            rows.Add(ProbeRow(input, button));
        }

        result.raycasterManagerAfterProbe = RaycasterManagerSummary();
        Summarize(result, rows);
        EditorSceneManager.SaveScene(scene, ScenePath);
        result.sceneSaved = File.Exists(ProjectPath(ScenePath));
        Capture(camera, ProjectPath(CapturePath));
        result.captureExists = File.Exists(ProjectPath(CapturePath));

        var reopened = EditorSceneManager.OpenScene(ScenePath, OpenSceneMode.Single);
        result.reopenValid = reopened.IsValid();
        camera = FindCaptureCamera();
        if (camera != null) ConfigureCamera(camera);
        PrepareDepth(camera);
        Snapshot(result, "reopen");
        result.raycasterManagerReopen = RaycasterManagerSummary();
        WriteOutputs(result, rows);
        AssetDatabase.Refresh();
        Debug.Log("BATTLE50 handler trace complete. eventSystemTargets=" + result.eventSystemTargetIncludedCount + ", blockedNoPatch=" + result.blockedNoPatchCount);
    }

    private static Row ProbeRow(InputRow input, Button button)
    {
        var row = new Row();
        row.buttonName = button.name;
        row.pointerPosition = input.pointerPosition;
        row.buttonScenePath = HierarchyPath(button.transform);
        row.originalButtonPath = input.originalButtonPath;
        row.originalTargetPath = input.originalTargetPath;
        row.originalTargetFullName = input.originalTargetFullName;
        row.originalButtonScriptPathId = input.originalButtonScriptPathId;
        row.originalTargetGraphicRef = input.originalTargetGraphicRef;
        row.b49GraphicRaycasterHitCount = ParseInt(input.graphicRaycasterHitCount);
        row.b49EventSystemRaycastAllCount = ParseInt(input.eventSystemRaycastAllCount);
        row.b49ExecutePointerClick = input.executePointerClick == "true";
        row.b49OnClickTotalKnownCount = ParseInt(input.onClickTotalKnownCount);

        var eventSystem = UnityEngine.Object.FindObjectOfType<EventSystem>(true);
        var canvas = button.GetComponentInParent<Canvas>(true);
        var raycaster = canvas != null ? canvas.GetComponent<GraphicRaycaster>() : null;
        var eventCamera = raycaster != null ? raycaster.eventCamera : (canvas != null ? canvas.worldCamera : null);
        row.eventSystemPresent = eventSystem != null;
        row.eventSystemPath = eventSystem != null ? HierarchyPath(eventSystem.transform) : "";
        row.eventSystemCurrentMatches = eventSystem != null && EventSystem.current == eventSystem;
        row.inputModuleSummary = eventSystem != null ? InputModuleSummary(eventSystem) : "";
        row.canvasPath = canvas != null ? HierarchyPath(canvas.transform) : "";
        row.canvasRenderMode = canvas != null ? canvas.renderMode.ToString() : "";
        row.canvasEnabled = canvas != null && canvas.enabled;
        row.canvasSortingOrder = canvas != null ? canvas.sortingOrder : 0;
        row.raycasterPath = raycaster != null ? HierarchyPath(raycaster.transform) : "";
        row.raycasterEnabled = raycaster != null && raycaster.enabled;
        row.raycasterIsActive = raycaster != null && raycaster.IsActive();
        row.raycasterBlockingObjects = raycaster != null ? raycaster.blockingObjects.ToString() : "";
        row.eventCameraName = eventCamera != null ? eventCamera.name : "(overlay/null)";
        row.eventCameraPixelRect = eventCamera != null ? RectString(eventCamera.pixelRect) : "";
        row.targetGraphicPath = button.targetGraphic != null ? HierarchyPath(button.targetGraphic.transform) : "";
        row.targetGraphicType = button.targetGraphic != null ? button.targetGraphic.GetType().FullName : "";
        row.buttonInteractable = button.interactable;
        row.buttonActiveInHierarchy = button.gameObject.activeInHierarchy;
        row.buttonOnClickPersistentCount = button.onClick.GetPersistentEventCount();
        row.buttonOnClickRuntimeCount = RuntimeListenerCount(button.onClick);
        row.eventTriggerCount = button.GetComponents<EventTrigger>().Length;
        row.buttonComponentTypes = ComponentTypes(button.transform);
        row.missingComponentChain = MissingChain(button.transform);
        row.missingOnButton = CountMissingOnTransform(button.transform);
        row.missingOnParents = CountMissingOnParents(button.transform);
        row.sceneRaycasterCount = UnityEngine.Object.FindObjectsOfType<BaseRaycaster>(true).Length;
        row.sceneActiveRaycasterCount = CountActiveSceneRaycasters();
        row.raycasterManagerCount = GetRaycasterManagerList().Count;
        row.currentRaycasterRegistered = raycaster != null && GetRaycasterManagerList().Contains(raycaster);
        row.raycasterManagerSummary = RaycasterManagerSummary();

        var pointer = new PointerEventData(eventSystem);
        pointer.position = ParseVec2(input.pointerPosition);
        pointer.button = PointerEventData.InputButton.Left;
        pointer.pointerId = -1;
        pointer.clickCount = 1;
        pointer.clickTime = Time.unscaledTime;

        if (eventSystem != null)
        {
            try { eventSystem.UpdateModules(); } catch { }
            var eventHits = new List<RaycastResult>();
            eventSystem.RaycastAll(pointer, eventHits);
            row.eventSystemRaycastAllCount = eventHits.Count;
            FillHits(row, eventHits, "event");
        }
        if (raycaster != null)
        {
            var directHits = new List<RaycastResult>();
            raycaster.Raycast(pointer, directHits);
            row.directGraphicRaycasterHitCount = directHits.Count;
            FillHits(row, directHits, "direct");
        }
        row.allSceneRaycastersManualHitSummary = ManualRaycasterHits(pointer);

        if (raycaster != null && !row.currentRaycasterRegistered)
        {
            bool oldEnabled = raycaster.enabled;
            raycaster.enabled = false;
            raycaster.enabled = oldEnabled;
            row.raycasterManagerAfterToggle = RaycasterManagerSummary();
            row.currentRaycasterRegisteredAfterToggle = GetRaycasterManagerList().Contains(raycaster);
            if (eventSystem != null)
            {
                var afterHits = new List<RaycastResult>();
                eventSystem.RaycastAll(pointer, afterHits);
                row.eventSystemRaycastAllAfterToggleCount = afterHits.Count;
                row.eventTargetIncludedAfterToggle = TargetIncluded(row, afterHits);
            }
        }

        row.eventSystemRootCause = DetermineEventCause(row);
        row.patchDecision = "blocked_no_patch_original_handler_binding_requires_missing_lua_unit_ui_event_listener_bridge";
        return row;
    }

    private static string DetermineEventCause(Row row)
    {
        if (row.eventSystemRaycastAllCount > 0 && row.eventTargetIncluded) return "eventsystem_hits_target";
        if (!row.raycasterManagerSummary.Contains("typeFound=true")) return "eventsystem_zero_direct_hit_but_raycaster_manager_reflection_unavailable";
        if (row.directGraphicRaycasterHitCount > 0 && !row.currentRaycasterRegistered) return "raycaster_manager_registration_missing_while_direct_graphicraycaster_hits";
        if (row.directGraphicRaycasterHitCount > 0 && row.currentRaycasterRegistered && row.eventSystemRaycastAllCount == 0) return "registered_raycaster_not_used_or_filtered_by_eventsystem";
        if (row.directGraphicRaycasterHitCount == 0) return "direct_graphicraycaster_no_hit";
        return "eventsystem_target_not_included_unknown";
    }

    private static void FillHits(Row row, List<RaycastResult> hits, string prefix)
    {
        var paths = new List<string>();
        bool targetIncluded = TargetIncluded(row, hits);
        for (int i = 0; i < hits.Count; i++)
        {
            if (hits[i].gameObject == null) continue;
            if (paths.Count < 8) paths.Add(HierarchyPath(hits[i].gameObject.transform) + "#depth=" + hits[i].depth + "#module=" + (hits[i].module != null ? hits[i].module.GetType().Name : ""));
        }
        if (prefix == "event")
        {
            row.eventTargetIncluded = targetIncluded;
            row.eventHitPaths = string.Join(" | ", paths.ToArray());
        }
        else
        {
            row.directTargetIncluded = targetIncluded;
            row.directHitPaths = string.Join(" | ", paths.ToArray());
        }
    }

    private static bool TargetIncluded(Row row, List<RaycastResult> hits)
    {
        foreach (var hit in hits)
        {
            if (hit.gameObject == null) continue;
            string path = HierarchyPath(hit.gameObject.transform);
            if (path == row.targetGraphicPath || path == row.buttonScenePath || path.StartsWith(row.buttonScenePath + "/")) return true;
        }
        return false;
    }

    private static List<BaseRaycaster> GetRaycasterManagerList()
    {
        var list = new List<BaseRaycaster>();
        try
        {
            var m = FindRaycasterManagerMethod();
            var value = m != null ? m.Invoke(null, null) as System.Collections.IEnumerable : null;
            if (value != null)
                foreach (var item in value)
                    if (item is BaseRaycaster br) list.Add(br);
        }
        catch { }
        return list;
    }

    private static MethodInfo FindRaycasterManagerMethod()
    {
        var assemblies = new[] { typeof(EventSystem).Assembly, typeof(BaseRaycaster).Assembly, typeof(GraphicRaycaster).Assembly };
        foreach (var assembly in assemblies)
        {
            var t = assembly.GetType("UnityEngine.EventSystems.RaycasterManager");
            var m = t != null ? t.GetMethod("GetRaycasters", BindingFlags.Static | BindingFlags.Public | BindingFlags.NonPublic) : null;
            if (m != null) return m;
        }
        return null;
    }

    private static string RaycasterManagerSummary()
    {
        bool typeFound = FindRaycasterManagerMethod() != null;
        var parts = new List<string>();
        foreach (var r in GetRaycasterManagerList())
            if (r != null) parts.Add(HierarchyPath(r.transform) + ":" + r.GetType().FullName + ":enabled=" + r.enabled + ":active=" + r.IsActive());
        return "typeFound=" + Bool(typeFound) + " | count=" + parts.Count + " | " + string.Join(" ; ", parts.ToArray());
    }

    private static string ManualRaycasterHits(PointerEventData pointer)
    {
        var parts = new List<string>();
        foreach (var r in UnityEngine.Object.FindObjectsOfType<BaseRaycaster>(true))
        {
            if (r == null || !r.IsActive()) continue;
            var hits = new List<RaycastResult>();
            try { r.Raycast(pointer, hits); } catch (Exception ex) { parts.Add(HierarchyPath(r.transform) + ":EX=" + ex.GetType().Name); continue; }
            if (hits.Count > 0)
            {
                string top = hits[0].gameObject != null ? HierarchyPath(hits[0].gameObject.transform) : "";
                parts.Add(HierarchyPath(r.transform) + ":hits=" + hits.Count + ":top=" + top);
            }
        }
        return string.Join(" | ", parts.ToArray());
    }

    private static int CountActiveSceneRaycasters()
    {
        int count = 0;
        foreach (var r in UnityEngine.Object.FindObjectsOfType<BaseRaycaster>(true))
            if (r != null && r.IsActive()) count++;
        return count;
    }

    private static List<InputRow> LoadB49Rows(string path)
    {
        var rows = new List<InputRow>();
        if (!File.Exists(path)) return rows;
        var lines = File.ReadAllLines(path, new UTF8Encoding(true));
        if (lines.Length < 2) return rows;
        var headers = SplitCsvLine(lines[0]);
        for (int i = 1; i < lines.Length; i++)
        {
            var map = RowMap(headers, SplitCsvLine(lines[i]));
            rows.Add(new InputRow
            {
                buttonName = Get(map, "buttonName"),
                pointerPosition = Get(map, "pointerPosition"),
                buttonScenePath = Get(map, "buttonScenePath"),
                originalButtonPath = Get(map, "originalButtonPath"),
                originalTargetPath = Get(map, "originalTargetPath"),
                originalTargetFullName = Get(map, "originalTargetFullName"),
                originalTargetGraphicRef = Get(map, "originalTargetGraphicRef"),
                originalButtonScriptPathId = Get(map, "originalButtonScriptPathId"),
                eventSystemRaycastAllCount = Get(map, "eventSystemRaycastAllCount"),
                graphicRaycasterHitCount = Get(map, "graphicRaycasterHitCount"),
                executePointerClick = Get(map, "executePointerClick"),
                onClickTotalKnownCount = Get(map, "onClickTotalKnownCount")
            });
        }
        return rows;
    }

    private static void Summarize(Result result, List<Row> rows)
    {
        result.rowCount = rows.Count;
        foreach (var row in rows)
        {
            if (row.directTargetIncluded) result.directGraphicTargetIncludedCount++;
            if (row.eventTargetIncluded) result.eventSystemTargetIncludedCount++;
            if (row.currentRaycasterRegistered) result.currentRaycasterRegisteredCount++;
            if (row.currentRaycasterRegisteredAfterToggle) result.currentRaycasterRegisteredAfterToggleCount++;
            if (row.eventTargetIncludedAfterToggle) result.eventTargetIncludedAfterToggleCount++;
            if (row.patchDecision.StartsWith("blocked_no_patch")) result.blockedNoPatchCount++;
        }
        result.patchDecision = "blocked_no_patch";
        result.nextBlocker = "BATTLE_51_RESTORE_SOURCE_BACKED_LUAUNIT_UIEVENTLISTENER_AND_EVENTSYSTEM_RAYCASTER_REGISTRATION";
    }

    private static void FillEventSystemSummary(Result result)
    {
        var systems = UnityEngine.Object.FindObjectsOfType<EventSystem>(true);
        result.eventSystemCount = systems.Length;
        var modules = UnityEngine.Object.FindObjectsOfType<BaseInputModule>(true);
        result.inputModuleCount = modules.Length;
        var parts = new List<string>();
        foreach (var module in modules)
            if (module != null) parts.Add(HierarchyPath(module.transform) + ":" + module.GetType().FullName + ":enabled=" + module.enabled + ":active=" + module.isActiveAndEnabled);
        result.inputModuleSummary = string.Join(" | ", parts.ToArray());
    }

    private static string InputModuleSummary(EventSystem eventSystem)
    {
        var parts = new List<string>();
        foreach (var module in eventSystem.GetComponents<BaseInputModule>())
            if (module != null) parts.Add(module.GetType().FullName + ":enabled=" + module.enabled + ":active=" + module.isActiveAndEnabled);
        return string.Join(" | ", parts.ToArray());
    }

    private static string MissingChain(Transform start)
    {
        var parts = new List<string>();
        var cursor = start;
        while (cursor != null)
        {
            int missing = CountMissingOnTransform(cursor);
            if (missing > 0) parts.Add(HierarchyPath(cursor) + ":missing=" + missing + ":components=" + ComponentTypes(cursor));
            cursor = cursor.parent;
        }
        return string.Join(" | ", parts.ToArray());
    }

    private static int CountMissingOnTransform(Transform transform)
    {
        int count = 0;
        foreach (var c in transform.GetComponents<Component>()) if (c == null) count++;
        return count;
    }

    private static int CountMissingOnParents(Transform transform)
    {
        int count = 0;
        var cursor = transform;
        while (cursor != null)
        {
            count += CountMissingOnTransform(cursor);
            cursor = cursor.parent;
        }
        return count;
    }

    private static string ComponentTypes(Transform transform)
    {
        var parts = new List<string>();
        foreach (var c in transform.GetComponents<Component>()) parts.Add(c == null ? "<missing>" : c.GetType().FullName);
        return string.Join(";", parts.ToArray());
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

    private static void PrepareDepth(Camera camera)
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
        DestroyTexture(RenderCamera(camera, 640, 480, null));
        Canvas.ForceUpdateCanvases();
    }

    private static void Snapshot(Result result, string phase)
    {
        int canvas = UnityEngine.Object.FindObjectsOfType<Canvas>(true).Length;
        int raycaster = UnityEngine.Object.FindObjectsOfType<GraphicRaycaster>(true).Length;
        int baseRaycaster = UnityEngine.Object.FindObjectsOfType<BaseRaycaster>(true).Length;
        int button = UnityEngine.Object.FindObjectsOfType<Button>(true).Length;
        int missing = CountMissingScripts();
        if (phase == "before")
        {
            result.beforeCanvasCount = canvas; result.beforeGraphicRaycasterCount = raycaster; result.beforeBaseRaycasterCount = baseRaycaster; result.beforeButtonCount = button; result.beforeMissingScriptCount = missing;
        }
        else
        {
            result.reopenCanvasCount = canvas; result.reopenGraphicRaycasterCount = raycaster; result.reopenBaseRaycasterCount = baseRaycaster; result.reopenButtonCount = button; result.reopenMissingScriptCount = missing;
        }
    }

    private static int CountMissingScripts()
    {
        int count = 0;
        foreach (var transform in UnityEngine.Object.FindObjectsOfType<Transform>(true))
            foreach (var component in transform.GetComponents<Component>())
                if (component == null) count++;
        return count;
    }

    private static Camera FindCaptureCamera()
    {
        foreach (var cam in UnityEngine.Object.FindObjectsOfType<Camera>(true))
            if (cam != null && cam.name.IndexOf("BattleHudSpriteAtlasTextureRuntimeBindingClip05Camera", StringComparison.OrdinalIgnoreCase) >= 0) return cam;
        foreach (var cam in UnityEngine.Object.FindObjectsOfType<Camera>(true))
            if (cam != null && cam.gameObject.activeInHierarchy) return cam;
        return null;
    }

    private static void ConfigureCamera(Camera camera)
    {
        camera.gameObject.SetActive(true);
        camera.enabled = true;
        camera.clearFlags = CameraClearFlags.SolidColor;
        camera.backgroundColor = Color.black;
        camera.orthographic = true;
        if (camera.orthographicSize < 1f) camera.orthographicSize = 540f;
        camera.targetTexture = null;
        camera.ResetAspect();
        camera.ResetProjectionMatrix();
        camera.ResetWorldToCameraMatrix();
    }

    private static void Capture(Camera camera, string path)
    {
        if (camera == null) return;
        Directory.CreateDirectory(Path.GetDirectoryName(path));
        DestroyTexture(RenderCamera(camera, 1920, 1080, path));
    }

    private static Texture2D RenderCamera(Camera camera, int width, int height, string optionalPath)
    {
        if (camera == null) return null;
        var rt = new RenderTexture(width, height, 24, RenderTextureFormat.ARGB32);
        var previousTarget = camera.targetTexture;
        var previousActive = RenderTexture.active;
        camera.targetTexture = rt;
        RenderTexture.active = rt;
        camera.Render();
        var texture = new Texture2D(width, height, TextureFormat.RGB24, false);
        texture.ReadPixels(new Rect(0, 0, width, height), 0, 0);
        texture.Apply();
        if (!string.IsNullOrEmpty(optionalPath)) File.WriteAllBytes(optionalPath, texture.EncodeToPNG());
        camera.targetTexture = previousTarget;
        RenderTexture.active = previousActive;
        UnityEngine.Object.DestroyImmediate(rt);
        return texture;
    }

    private static void DestroyTexture(Texture2D texture)
    {
        if (texture != null) UnityEngine.Object.DestroyImmediate(texture);
    }

    private static Transform FindTransform(string path)
    {
        foreach (var transform in UnityEngine.Object.FindObjectsOfType<Transform>(true))
            if (HierarchyPath(transform) == path) return transform;
        return null;
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

    private static int ParseInt(string value) { int v; return int.TryParse(value, out v) ? v : 0; }
    private static string Get(Dictionary<string, string> map, string key) { return map.ContainsKey(key) ? map[key] : ""; }
    private static string HierarchyPath(Transform transform) { var names = new List<string>(); var cursor = transform; while (cursor != null) { names.Add(cursor.name); cursor = cursor.parent; } names.Reverse(); return string.Join("/", names.ToArray()); }
    private static string ProjectPath(string assetPath) { return Path.Combine(Application.dataPath, "..", assetPath.Replace("/", "\\")); }
    private static string RectString(Rect r) { return r.x.ToString("0.###") + "/" + r.y.ToString("0.###") + "/" + r.width.ToString("0.###") + "/" + r.height.ToString("0.###"); }
    private static string Bool(bool value) { return value ? "true" : "false"; }
    private static string Json(string value) { return (value ?? "").Replace("\\", "\\\\").Replace("\"", "\\\"").Replace("\r", " ").Replace("\n", " "); }
    private static string Csv(string value) { return "\"" + (value ?? "").Replace("\"", "\"\"") + "\""; }

    private static void WriteOutputs(Result result, List<Row> rows)
    {
        WriteRowsCsv(ProjectPath(RowsCsvPath), rows);
        WriteJson(ProjectPath(ResultJsonPath), result);
    }

    private static void WriteRowsCsv(string path, List<Row> rows)
    {
        Directory.CreateDirectory(Path.GetDirectoryName(path));
        var sb = new StringBuilder();
        sb.AppendLine("buttonName,pointerPosition,buttonScenePath,originalButtonPath,originalTargetPath,originalTargetFullName,originalButtonScriptPathId,originalTargetGraphicRef,b49GraphicRaycasterHitCount,b49EventSystemRaycastAllCount,b49ExecutePointerClick,b49OnClickTotalKnownCount,eventSystemPresent,eventSystemPath,eventSystemCurrentMatches,inputModuleSummary,canvasPath,canvasRenderMode,canvasEnabled,canvasSortingOrder,raycasterPath,raycasterEnabled,raycasterIsActive,raycasterBlockingObjects,eventCameraName,eventCameraPixelRect,targetGraphicPath,targetGraphicType,buttonActiveInHierarchy,buttonInteractable,buttonOnClickPersistentCount,buttonOnClickRuntimeCount,eventTriggerCount,buttonComponentTypes,missingComponentChain,missingOnButton,missingOnParents,sceneRaycasterCount,sceneActiveRaycasterCount,raycasterManagerCount,currentRaycasterRegistered,raycasterManagerSummary,eventSystemRaycastAllCount,eventTargetIncluded,eventHitPaths,directGraphicRaycasterHitCount,directTargetIncluded,directHitPaths,allSceneRaycastersManualHitSummary,raycasterManagerAfterToggle,currentRaycasterRegisteredAfterToggle,eventSystemRaycastAllAfterToggleCount,eventTargetIncludedAfterToggle,eventSystemRootCause,patchDecision");
        foreach (var r in rows)
        {
            sb.AppendLine(string.Join(",", new[]
            {
                Csv(r.buttonName), Csv(r.pointerPosition), Csv(r.buttonScenePath), Csv(r.originalButtonPath), Csv(r.originalTargetPath), Csv(r.originalTargetFullName), Csv(r.originalButtonScriptPathId), Csv(r.originalTargetGraphicRef),
                r.b49GraphicRaycasterHitCount.ToString(), r.b49EventSystemRaycastAllCount.ToString(), Bool(r.b49ExecutePointerClick), r.b49OnClickTotalKnownCount.ToString(),
                Bool(r.eventSystemPresent), Csv(r.eventSystemPath), Bool(r.eventSystemCurrentMatches), Csv(r.inputModuleSummary), Csv(r.canvasPath), Csv(r.canvasRenderMode), Bool(r.canvasEnabled), r.canvasSortingOrder.ToString(),
                Csv(r.raycasterPath), Bool(r.raycasterEnabled), Bool(r.raycasterIsActive), Csv(r.raycasterBlockingObjects), Csv(r.eventCameraName), Csv(r.eventCameraPixelRect), Csv(r.targetGraphicPath), Csv(r.targetGraphicType),
                Bool(r.buttonActiveInHierarchy), Bool(r.buttonInteractable), r.buttonOnClickPersistentCount.ToString(), r.buttonOnClickRuntimeCount.ToString(), r.eventTriggerCount.ToString(), Csv(r.buttonComponentTypes), Csv(r.missingComponentChain), r.missingOnButton.ToString(), r.missingOnParents.ToString(),
                r.sceneRaycasterCount.ToString(), r.sceneActiveRaycasterCount.ToString(), r.raycasterManagerCount.ToString(), Bool(r.currentRaycasterRegistered), Csv(r.raycasterManagerSummary),
                r.eventSystemRaycastAllCount.ToString(), Bool(r.eventTargetIncluded), Csv(r.eventHitPaths), r.directGraphicRaycasterHitCount.ToString(), Bool(r.directTargetIncluded), Csv(r.directHitPaths), Csv(r.allSceneRaycastersManualHitSummary),
                Csv(r.raycasterManagerAfterToggle), Bool(r.currentRaycasterRegisteredAfterToggle), r.eventSystemRaycastAllAfterToggleCount.ToString(), Bool(r.eventTargetIncludedAfterToggle), Csv(r.eventSystemRootCause), Csv(r.patchDecision)
            }));
        }
        File.WriteAllText(path, sb.ToString(), new UTF8Encoding(false));
    }

    private static void WriteJson(string path, Result r)
    {
        Directory.CreateDirectory(Path.GetDirectoryName(path));
        var sb = new StringBuilder();
        sb.AppendLine("{");
        sb.AppendLine("  \"status\": \"" + Json(r.status) + "\",");
        sb.AppendLine("  \"isFinalRestoredBattleScreen\": false,");
        sb.AppendLine("  \"sourceScene\": \"" + Json(r.sourceScene) + "\",");
        sb.AppendLine("  \"scene\": \"" + Json(r.scene) + "\",");
        sb.AppendLine("  \"capture\": \"" + Json(r.capture) + "\",");
        sb.AppendLine("  \"sourceSceneOpened\": " + Bool(r.sourceSceneOpened) + ",");
        sb.AppendLine("  \"sceneSaved\": " + Bool(r.sceneSaved) + ",");
        sb.AppendLine("  \"captureExists\": " + Bool(r.captureExists) + ",");
        sb.AppendLine("  \"reopenValid\": " + Bool(r.reopenValid) + ",");
        sb.AppendLine("  \"b49InputRows\": " + r.b49InputRows + ",");
        sb.AppendLine("  \"rowCount\": " + r.rowCount + ",");
        sb.AppendLine("  \"eventSystemCount\": " + r.eventSystemCount + ",");
        sb.AppendLine("  \"inputModuleCount\": " + r.inputModuleCount + ",");
        sb.AppendLine("  \"inputModuleSummary\": \"" + Json(r.inputModuleSummary) + "\",");
        sb.AppendLine("  \"directGraphicTargetIncludedCount\": " + r.directGraphicTargetIncludedCount + ",");
        sb.AppendLine("  \"eventSystemTargetIncludedCount\": " + r.eventSystemTargetIncludedCount + ",");
        sb.AppendLine("  \"currentRaycasterRegisteredCount\": " + r.currentRaycasterRegisteredCount + ",");
        sb.AppendLine("  \"currentRaycasterRegisteredAfterToggleCount\": " + r.currentRaycasterRegisteredAfterToggleCount + ",");
        sb.AppendLine("  \"eventTargetIncludedAfterToggleCount\": " + r.eventTargetIncludedAfterToggleCount + ",");
        sb.AppendLine("  \"blockedNoPatchCount\": " + r.blockedNoPatchCount + ",");
        sb.AppendLine("  \"raycasterManagerBefore\": \"" + Json(r.raycasterManagerBefore) + "\",");
        sb.AppendLine("  \"raycasterManagerAfterProbe\": \"" + Json(r.raycasterManagerAfterProbe) + "\",");
        sb.AppendLine("  \"raycasterManagerReopen\": \"" + Json(r.raycasterManagerReopen) + "\",");
        sb.AppendLine("  \"before\": {\"canvas\":" + r.beforeCanvasCount + ",\"graphicRaycaster\":" + r.beforeGraphicRaycasterCount + ",\"baseRaycaster\":" + r.beforeBaseRaycasterCount + ",\"button\":" + r.beforeButtonCount + ",\"missingScript\":" + r.beforeMissingScriptCount + "},");
        sb.AppendLine("  \"reopen\": {\"canvas\":" + r.reopenCanvasCount + ",\"graphicRaycaster\":" + r.reopenGraphicRaycasterCount + ",\"baseRaycaster\":" + r.reopenBaseRaycasterCount + ",\"button\":" + r.reopenButtonCount + ",\"missingScript\":" + r.reopenMissingScriptCount + "},");
        sb.AppendLine("  \"patchDecision\": \"" + Json(r.patchDecision) + "\",");
        sb.AppendLine("  \"nextBlocker\": \"" + Json(r.nextBlocker) + "\",");
        sb.AppendLine("  \"failReason\": \"" + Json(r.failReason) + "\"");
        sb.AppendLine("}");
        File.WriteAllText(path, sb.ToString(), new UTF8Encoding(false));
    }

    private sealed class InputRow
    {
        public string buttonName = "", pointerPosition = "", buttonScenePath = "", originalButtonPath = "", originalTargetPath = "", originalTargetFullName = "", originalTargetGraphicRef = "", originalButtonScriptPathId = "", eventSystemRaycastAllCount = "", graphicRaycasterHitCount = "", executePointerClick = "", onClickTotalKnownCount = "";
    }

    private sealed class Result
    {
        public string status = "", sourceScene = "", scene = "", capture = "", failReason = "", inputModuleSummary = "", raycasterManagerBefore = "", raycasterManagerAfterProbe = "", raycasterManagerReopen = "", patchDecision = "", nextBlocker = "";
        public bool isFinalRestoredBattleScreen, sourceSceneOpened, sceneSaved, captureExists, reopenValid;
        public int b49InputRows, rowCount, eventSystemCount, inputModuleCount, directGraphicTargetIncludedCount, eventSystemTargetIncludedCount, currentRaycasterRegisteredCount, currentRaycasterRegisteredAfterToggleCount, eventTargetIncludedAfterToggleCount, blockedNoPatchCount;
        public int beforeCanvasCount, beforeGraphicRaycasterCount, beforeBaseRaycasterCount, beforeButtonCount, beforeMissingScriptCount, reopenCanvasCount, reopenGraphicRaycasterCount, reopenBaseRaycasterCount, reopenButtonCount, reopenMissingScriptCount;
    }

    private sealed class Row
    {
        public string buttonName = "", pointerPosition = "", buttonScenePath = "", originalButtonPath = "", originalTargetPath = "", originalTargetFullName = "", originalButtonScriptPathId = "", originalTargetGraphicRef = "";
        public int b49GraphicRaycasterHitCount, b49EventSystemRaycastAllCount, b49OnClickTotalKnownCount;
        public bool b49ExecutePointerClick, eventSystemPresent, eventSystemCurrentMatches, canvasEnabled, raycasterEnabled, raycasterIsActive, buttonActiveInHierarchy, buttonInteractable, currentRaycasterRegistered, eventTargetIncluded, directTargetIncluded, currentRaycasterRegisteredAfterToggle, eventTargetIncludedAfterToggle;
        public string eventSystemPath = "", inputModuleSummary = "", canvasPath = "", canvasRenderMode = "", raycasterPath = "", raycasterBlockingObjects = "", eventCameraName = "", eventCameraPixelRect = "", targetGraphicPath = "", targetGraphicType = "", buttonComponentTypes = "", missingComponentChain = "", raycasterManagerSummary = "", eventHitPaths = "", directHitPaths = "", allSceneRaycastersManualHitSummary = "", raycasterManagerAfterToggle = "", eventSystemRootCause = "", patchDecision = "";
        public int canvasSortingOrder, buttonOnClickPersistentCount, buttonOnClickRuntimeCount, eventTriggerCount, missingOnButton, missingOnParents, sceneRaycasterCount, sceneActiveRaycasterCount, raycasterManagerCount, eventSystemRaycastAllCount, directGraphicRaycasterHitCount, eventSystemRaycastAllAfterToggleCount;
    }
}
