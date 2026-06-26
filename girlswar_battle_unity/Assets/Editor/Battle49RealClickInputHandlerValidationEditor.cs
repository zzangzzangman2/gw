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

public static class Battle49ValidateRealClickInputAndHandlerBindingEditor
{
    private const string SourceScenePath = "Assets/Scenes/Battle48SortOrderDisplayHitOcclusionTrace.unity";
    private const string ScenePath = "Assets/Scenes/Battle49RealClickInputHandlerValidation.unity";
    private const string B48ReadyCsvPath = "Assets/RestoreData/battle/BATTLE_48_TRACE_SORT_ORDER_DISPLAY_AND_HIT_OCCLUSION_AFTER_DEPTH_REBUILD_TARGET_POINTS.csv";
    private const string B44ManifestCsvPath = "Assets/RestoreData/battle/BATTLE_44_ORIGINAL_BUTTON_TARGET_GRAPHIC_PATCH_MANIFEST.csv";
    private const string ResultJsonPath = "Assets/RestoreData/battle/BATTLE_49_VALIDATE_REAL_CLICK_INPUT_AND_HANDLER_BINDING_UNITY.json";
    private const string RowsCsvPath = "Assets/RestoreData/battle/BATTLE_49_VALIDATE_REAL_CLICK_INPUT_AND_HANDLER_BINDING_COMPONENTS.csv";
    private const string CapturePath = "Assets/RestoreCaptures/battle_actor/Battle49RealClickInputHandlerValidation_1920x1080.png";
    private const int CaptureWidth = 1920;
    private const int CaptureHeight = 1080;

    private static readonly List<string> CapturedLogs = new List<string>();

    [MenuItem("GirlsWar/Battle/BATTLE49 Validate Real Click Input Handler Binding")]
    public static void Build()
    {
        Directory.CreateDirectory(ProjectPath("Assets/RestoreData/battle"));
        Directory.CreateDirectory(ProjectPath("Assets/RestoreCaptures/battle_actor"));
        var result = new Result();
        var rows = new List<Row>();
        result.status = "battle49_validate_real_click_input_and_handler_binding";
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

        var ready = LoadReadyRows(ProjectPath(B48ReadyCsvPath));
        var original = LoadOriginalManifest(ProjectPath(B44ManifestCsvPath));
        result.readyInputRowCount = ready.Count;
        var scene = EditorSceneManager.OpenScene(SourceScenePath, OpenSceneMode.Single);
        result.sourceSceneOpened = scene.IsValid();
        var camera = FindCaptureCamera();
        if (camera != null) ConfigureCamera(camera);
        PrepareDepth(camera);
        Snapshot(result, "before");
        FillEventSystemSummary(result);

        Application.logMessageReceived += CaptureLog;
        foreach (var item in ready)
        {
            var buttonTransform = FindTransform(item.buttonScenePath);
            if (buttonTransform == null) continue;
            var button = buttonTransform.GetComponent<Button>();
            if (button == null) continue;
            ManifestRow manifest = FindManifest(original, item.buttonScenePath, button.name);
            rows.Add(ProbeClickPath(item, manifest, button));
        }
        Application.logMessageReceived -= CaptureLog;

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
        WriteOutputs(result, rows);
        AssetDatabase.Refresh();
        Debug.Log("BATTLE49 real click validation complete. executeClick=" + result.executeClickReceiverCount + ", gameplayHandlers=" + result.boundGameplayHandlerCount);
    }

    private static Row ProbeClickPath(ReadyRow item, ManifestRow manifest, Button button)
    {
        CapturedLogs.Clear();
        var row = new Row();
        row.pointName = item.pointName;
        row.buttonName = button.name;
        row.pointerPosition = item.pointerPosition;
        row.buttonScenePath = HierarchyPath(button.transform);
        row.originalButtonPath = manifest.originalButtonPath;
        row.buttonSuffix = manifest.buttonSuffix;
        row.originalTargetPath = manifest.originalTargetPath;
        row.targetSuffix = manifest.targetSuffix;
        row.originalTargetFullName = manifest.targetFullName;
        row.originalTargetGraphicRef = manifest.targetGraphicRef;
        row.originalButtonScriptPathId = manifest.buttonScriptPathId;
        row.originalEvidence = string.IsNullOrEmpty(manifest.evidence) ? "BATTLE44 manifest row not matched" : manifest.evidence;

        var eventSystem = UnityEngine.Object.FindObjectOfType<EventSystem>(true);
        row.eventSystemPresent = eventSystem != null;
        row.eventSystemName = eventSystem != null ? eventSystem.name : "";
        row.inputModuleSummary = InputModuleSummary(eventSystem);
        var canvas = button.GetComponentInParent<Canvas>(true);
        var raycaster = canvas != null ? canvas.GetComponent<GraphicRaycaster>() : null;
        var eventCamera = raycaster != null ? raycaster.eventCamera : (canvas != null ? canvas.worldCamera : null);
        row.eventCameraName = eventCamera != null ? eventCamera.name : "(overlay/null)";
        row.canvasPath = canvas != null ? HierarchyPath(canvas.transform) : "";
        row.canvasRenderMode = canvas != null ? canvas.renderMode.ToString() : "";
        row.targetGraphicPath = button.targetGraphic != null ? HierarchyPath(button.targetGraphic.transform) : "";
        row.targetGraphicType = button.targetGraphic != null ? button.targetGraphic.GetType().FullName : "";
        row.buttonActiveInHierarchy = button.gameObject.activeInHierarchy;
        row.buttonInteractable = button.interactable;
        row.selectableState = SelectableState(button);
        row.onClickPersistentCount = button.onClick.GetPersistentEventCount();
        row.onClickRuntimeCount = RuntimeListenerCount(button.onClick);
        row.onClickTotalKnownCount = row.onClickPersistentCount + row.onClickRuntimeCount;
        row.eventTriggerCountOnButton = button.GetComponents<EventTrigger>().Length;
        row.buttonMissingMonoBehaviourCount = CountMissingOnTransform(button.transform);
        row.parentMissingMonoBehaviourCount = CountMissingOnParents(button.transform);
        row.buttonComponentTypes = ComponentTypes(button.transform);
        row.parentHandlerSummary = HandlerChain(button.transform);
        row.eventTriggerSummary = EventTriggerSummary(button.transform);

        var pointer = new PointerEventData(eventSystem);
        pointer.position = ParseVec2(item.pointerPosition);
        pointer.button = PointerEventData.InputButton.Left;
        pointer.pointerId = -1;
        pointer.clickCount = 1;
        pointer.clickTime = Time.unscaledTime;

        if (eventSystem != null)
        {
            var allHits = new List<RaycastResult>();
            eventSystem.RaycastAll(pointer, allHits);
            row.eventSystemRaycastAllCount = allHits.Count;
            FillHits(row, allHits, "event");
        }
        if (raycaster != null)
        {
            var graphicHits = new List<RaycastResult>();
            raycaster.Raycast(pointer, graphicHits);
            row.graphicRaycasterHitCount = graphicHits.Count;
            FillHits(row, graphicHits, "graphic");
        }
        var top = row.graphicTopObjectPath.Length > 0 ? FindTransform(row.graphicTopObjectPath) : button.transform;
        if (top == null) top = button.transform;
        row.pointerDownReceiver = EventHandlerPath<IPointerDownHandler>(top.gameObject);
        row.pointerUpReceiver = EventHandlerPath<IPointerUpHandler>(top.gameObject);
        row.pointerClickReceiver = EventHandlerPath<IPointerClickHandler>(top.gameObject);
        row.submitReceiver = EventHandlerPath<ISubmitHandler>(button.gameObject);
        row.executeReceiverChain = ExecuteReceiverChain(top);

        var beforeSelected = eventSystem != null && eventSystem.currentSelectedGameObject != null ? HierarchyPath(eventSystem.currentSelectedGameObject.transform) : "";
        row.selectedBefore = beforeSelected;
        try
        {
            row.executePointerDown = ExecuteEvents.ExecuteHierarchy<IPointerDownHandler>(top.gameObject, pointer, ExecuteEvents.pointerDownHandler);
            pointer.pointerPress = ExecuteEvents.GetEventHandler<IPointerClickHandler>(top.gameObject);
            pointer.rawPointerPress = top.gameObject;
            row.executePointerUp = ExecuteEvents.ExecuteHierarchy<IPointerUpHandler>(top.gameObject, pointer, ExecuteEvents.pointerUpHandler);
            row.executePointerClick = ExecuteEvents.ExecuteHierarchy<IPointerClickHandler>(top.gameObject, pointer, ExecuteEvents.pointerClickHandler);
            row.executeSubmit = ExecuteEvents.Execute<ISubmitHandler>(button.gameObject, new BaseEventData(eventSystem), ExecuteEvents.submitHandler);
        }
        catch (Exception ex)
        {
            row.executeException = ex.GetType().Name + ":" + ex.Message;
        }
        row.selectedAfter = eventSystem != null && eventSystem.currentSelectedGameObject != null ? HierarchyPath(eventSystem.currentSelectedGameObject.transform) : "";
        row.stateChanged = row.selectedBefore != row.selectedAfter;
        row.capturedLogCount = CapturedLogs.Count;
        row.capturedLogs = string.Join(" | ", CapturedLogs.ToArray());
        row.clickPathValidated = row.executePointerClick && row.graphicTargetIncluded;
        row.gameplayHandlerBound = row.onClickTotalKnownCount > 0 || row.eventTriggerCountOnButton > 0 || HasNonUnityHandler(button.transform);
        row.blocker = row.clickPathValidated ? (row.gameplayHandlerBound ? "click_path_and_handler_present_needs_runtime_payload_validation" : "click_path_reaches_button_but_no_bound_gameplay_handler") : "click_path_not_validated";
        return row;
    }

    private static void FillHits(Row row, List<RaycastResult> hits, string prefix)
    {
        var paths = new List<string>();
        bool targetIncluded = false;
        string targetPath = row.targetGraphicPath;
        for (int i = 0; i < hits.Count; i++)
        {
            if (hits[i].gameObject == null) continue;
            string path = HierarchyPath(hits[i].gameObject.transform);
            if (i == 0)
            {
                if (prefix == "event") row.eventTopObjectPath = path;
                else row.graphicTopObjectPath = path;
            }
            if (path == targetPath || targetPath.StartsWith(path + "/") || path.StartsWith(row.buttonScenePath + "/") || path == row.buttonScenePath) targetIncluded = true;
            if (paths.Count < 8) paths.Add(path + "#depth=" + hits[i].depth);
        }
        if (prefix == "event")
        {
            row.eventTargetIncluded = targetIncluded;
            row.eventHitPaths = string.Join(" | ", paths.ToArray());
        }
        else
        {
            row.graphicTargetIncluded = targetIncluded;
            row.graphicHitPaths = string.Join(" | ", paths.ToArray());
        }
    }

    private static void Summarize(Result result, List<Row> rows)
    {
        result.rowCount = rows.Count;
        var blockers = new Dictionary<string, int>();
        var readyButtons = new HashSet<string>();
        foreach (var row in rows)
        {
            if (row.graphicTargetIncluded) result.graphicRaycastTargetIncludedCount++;
            if (row.eventTargetIncluded) result.eventSystemTargetIncludedCount++;
            if (row.executePointerClick) result.executeClickReceiverCount++;
            if (row.clickPathValidated) { result.clickPathValidatedCount++; readyButtons.Add(row.buttonName); }
            if (row.gameplayHandlerBound) result.boundGameplayHandlerCount++;
            if (row.onClickTotalKnownCount > 0) result.onClickListenerBoundCount++;
            if (row.executeException.Length > 0) result.executeExceptionCount++;
            if (!blockers.ContainsKey(row.blocker)) blockers[row.blocker] = 0;
            blockers[row.blocker]++;
        }
        result.uniqueClickPathButtonCount = readyButtons.Count;
        result.blockerSummary = DictString(blockers);
        result.patchDecision = result.clickPathValidatedCount > 0 && result.boundGameplayHandlerCount == 0 ? "real_click_path_reaches_original_buttons_but_gameplay_handler_binding_missing" : (result.boundGameplayHandlerCount > 0 ? "click_path_and_some_handlers_present_validate_payload_runtime_next" : "click_path_not_validated");
    }

    private static List<ReadyRow> LoadReadyRows(string path)
    {
        var rows = new List<ReadyRow>();
        if (!File.Exists(path)) return rows;
        var lines = File.ReadAllLines(path, new UTF8Encoding(true));
        if (lines.Length < 2) return rows;
        var headers = SplitCsvLine(lines[0]);
        var seen = new HashSet<string>();
        for (int i = 1; i < lines.Length; i++)
        {
            var values = SplitCsvLine(lines[i]);
            var map = RowMap(headers, values);
            if (Get(map, "phase") != "reopen_after_depth_rebuild_render") continue;
            if (Get(map, "raycastReady") != "true") continue;
            if (Get(map, "pointName") != "eventCamera_worldToScreen") continue;
            string buttonPath = Get(map, "buttonScenePath");
            if (seen.Contains(buttonPath)) continue;
            seen.Add(buttonPath);
            rows.Add(new ReadyRow { pointName = Get(map, "pointName"), buttonName = Get(map, "buttonName"), buttonScenePath = buttonPath, pointerPosition = Get(map, "pointerPosition") });
        }
        return rows;
    }

    private static List<ManifestRow> LoadOriginalManifest(string path)
    {
        var rows = new List<ManifestRow>();
        if (!File.Exists(path)) return rows;
        var lines = File.ReadAllLines(path, new UTF8Encoding(true));
        if (lines.Length < 2) return rows;
        var headers = SplitCsvLine(lines[0]);
        for (int i = 1; i < lines.Length; i++)
        {
            var map = RowMap(headers, SplitCsvLine(lines[i]));
            rows.Add(new ManifestRow
            {
                originalButtonPath = Get(map, "originalButtonPath"),
                buttonSuffix = Get(map, "buttonSuffix"),
                targetGraphicRef = Get(map, "targetGraphicRef"),
                originalTargetPath = Get(map, "originalTargetPath"),
                targetSuffix = Get(map, "targetSuffix"),
                targetFullName = Get(map, "targetFullName"),
                buttonScriptPathId = Get(map, "buttonScriptPathId"),
                evidence = Get(map, "evidence")
            });
        }
        return rows;
    }

    private static ManifestRow FindManifest(List<ManifestRow> rows, string scenePath, string buttonName)
    {
        foreach (var row in rows)
            if (!string.IsNullOrEmpty(row.buttonSuffix) && scenePath.EndsWith("/" + row.buttonSuffix, StringComparison.OrdinalIgnoreCase)) return row;
        foreach (var row in rows)
            if (!string.IsNullOrEmpty(row.buttonSuffix) && row.buttonSuffix.EndsWith("/" + buttonName, StringComparison.OrdinalIgnoreCase)) return row;
        return new ManifestRow();
    }

    private static void FillEventSystemSummary(Result result)
    {
        var systems = UnityEngine.Object.FindObjectsOfType<EventSystem>(true);
        result.eventSystemCount = systems.Length;
        var modules = UnityEngine.Object.FindObjectsOfType<BaseInputModule>(true);
        result.inputModuleCount = modules.Length;
        var parts = new List<string>();
        foreach (var module in modules)
            if (module != null) parts.Add(HierarchyPath(module.transform) + ":" + module.GetType().FullName + ":enabled=" + module.enabled);
        result.inputModuleSummary = string.Join(" | ", parts.ToArray());
    }

    private static string InputModuleSummary(EventSystem eventSystem)
    {
        if (eventSystem == null) return "";
        var parts = new List<string>();
        foreach (var module in eventSystem.GetComponents<BaseInputModule>())
            if (module != null) parts.Add(module.GetType().FullName + ":enabled=" + module.enabled);
        return string.Join(" | ", parts.ToArray());
    }

    private static string EventHandlerPath<T>(GameObject go) where T : IEventSystemHandler
    {
        var receiver = ExecuteEvents.GetEventHandler<T>(go);
        return receiver != null ? HierarchyPath(receiver.transform) : "";
    }

    private static string ExecuteReceiverChain(Transform start)
    {
        var parts = new List<string>();
        var cursor = start;
        while (cursor != null)
        {
            var names = new List<string>();
            foreach (var c in cursor.GetComponents<Component>())
            {
                if (c == null) { names.Add("<missing>"); continue; }
                var t = c.GetType();
                if (typeof(IPointerDownHandler).IsAssignableFrom(t) || typeof(IPointerUpHandler).IsAssignableFrom(t) || typeof(IPointerClickHandler).IsAssignableFrom(t) || typeof(ISubmitHandler).IsAssignableFrom(t))
                    names.Add(t.FullName);
            }
            if (names.Count > 0) parts.Add(HierarchyPath(cursor) + "[" + string.Join(";", names.ToArray()) + "]");
            cursor = cursor.parent;
        }
        return string.Join(" | ", parts.ToArray());
    }

    private static string HandlerChain(Transform start)
    {
        var parts = new List<string>();
        var cursor = start;
        while (cursor != null)
        {
            foreach (var c in cursor.GetComponents<Component>())
            {
                if (c == null) continue;
                var t = c.GetType();
                if (typeof(IEventSystemHandler).IsAssignableFrom(t) || t == typeof(Button) || t == typeof(EventTrigger))
                    parts.Add(HierarchyPath(cursor) + ":" + t.FullName);
            }
            cursor = cursor.parent;
        }
        return string.Join(" | ", parts.ToArray());
    }

    private static string EventTriggerSummary(Transform start)
    {
        var parts = new List<string>();
        foreach (var trigger in start.GetComponents<EventTrigger>())
        {
            if (trigger == null || trigger.triggers == null) continue;
            foreach (var entry in trigger.triggers)
                parts.Add(entry.eventID + ":persistent=" + (entry.callback != null ? entry.callback.GetPersistentEventCount() : 0));
        }
        return string.Join(" | ", parts.ToArray());
    }

    private static bool HasNonUnityHandler(Transform transform)
    {
        foreach (var c in transform.GetComponents<Component>())
        {
            if (c == null) continue;
            var name = c.GetType().FullName;
            if (name.StartsWith("UnityEngine.")) continue;
            if (typeof(IEventSystemHandler).IsAssignableFrom(c.GetType())) return true;
        }
        return false;
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
        foreach (var c in transform.GetComponents<Component>())
            parts.Add(c == null ? "<missing>" : c.GetType().FullName);
        return string.Join(" | ", parts.ToArray());
    }

    private static string SelectableState(Selectable selectable)
    {
        try
        {
            var prop = typeof(Selectable).GetProperty("currentSelectionState", BindingFlags.Instance | BindingFlags.NonPublic);
            return prop != null ? Convert.ToString(prop.GetValue(selectable, null)) : "";
        }
        catch { return ""; }
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

    private static void CaptureLog(string condition, string stackTrace, LogType type)
    {
        if (CapturedLogs.Count >= 20) return;
        CapturedLogs.Add(type + ":" + condition.Replace("\r", " ").Replace("\n", " "));
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
        int button = UnityEngine.Object.FindObjectsOfType<Button>(true).Length;
        int missing = CountMissingScripts();
        if (phase == "before") { result.beforeCanvasCount = canvas; result.beforeRaycasterCount = raycaster; result.beforeButtonCount = button; result.beforeMissingScriptCount = missing; }
        else { result.reopenCanvasCount = canvas; result.reopenRaycasterCount = raycaster; result.reopenButtonCount = button; result.reopenMissingScriptCount = missing; }
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
        DestroyTexture(RenderCamera(camera, CaptureWidth, CaptureHeight, path));
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

    private static string Get(Dictionary<string, string> map, string key) { return map.ContainsKey(key) ? map[key] : ""; }
    private static string DictString(Dictionary<string, int> dict) { var parts = new List<string>(); foreach (var pair in dict) parts.Add(pair.Key + ":" + pair.Value); return string.Join(", ", parts.ToArray()); }
    private static string HierarchyPath(Transform transform) { var names = new List<string>(); var cursor = transform; while (cursor != null) { names.Add(cursor.name); cursor = cursor.parent; } names.Reverse(); return string.Join("/", names.ToArray()); }
    private static string ProjectPath(string assetPath) { return Path.Combine(Application.dataPath, "..", assetPath.Replace("/", "\\")); }
    private static string Vec2(Vector2 v) { return v.x.ToString("0.###", System.Globalization.CultureInfo.InvariantCulture) + "/" + v.y.ToString("0.###", System.Globalization.CultureInfo.InvariantCulture); }
    private static Vector2 ParseVec2(string value) { var parts = (value ?? "0/0").Split('/'); float x = 0, y = 0; if (parts.Length > 0) float.TryParse(parts[0], System.Globalization.NumberStyles.Float, System.Globalization.CultureInfo.InvariantCulture, out x); if (parts.Length > 1) float.TryParse(parts[1], System.Globalization.NumberStyles.Float, System.Globalization.CultureInfo.InvariantCulture, out y); return new Vector2(x, y); }
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
        sb.AppendLine("pointName,buttonName,pointerPosition,buttonScenePath,originalButtonPath,buttonSuffix,originalTargetPath,targetSuffix,originalTargetFullName,originalTargetGraphicRef,originalButtonScriptPathId,originalEvidence,eventSystemPresent,eventSystemName,inputModuleSummary,canvasPath,canvasRenderMode,eventCameraName,eventSystemRaycastAllCount,eventTopObjectPath,eventTargetIncluded,eventHitPaths,graphicRaycasterHitCount,graphicTopObjectPath,graphicTargetIncluded,graphicHitPaths,buttonActiveInHierarchy,buttonInteractable,selectableState,targetGraphicPath,targetGraphicType,onClickPersistentCount,onClickRuntimeCount,onClickTotalKnownCount,eventTriggerCountOnButton,buttonMissingMonoBehaviourCount,parentMissingMonoBehaviourCount,buttonComponentTypes,parentHandlerSummary,eventTriggerSummary,pointerDownReceiver,pointerUpReceiver,pointerClickReceiver,submitReceiver,executeReceiverChain,executePointerDown,executePointerUp,executePointerClick,executeSubmit,selectedBefore,selectedAfter,stateChanged,capturedLogCount,capturedLogs,executeException,clickPathValidated,gameplayHandlerBound,blocker");
        foreach (var r in rows)
        {
            sb.AppendLine(string.Join(",", new[]
            {
                Csv(r.pointName), Csv(r.buttonName), Csv(r.pointerPosition), Csv(r.buttonScenePath), Csv(r.originalButtonPath), Csv(r.buttonSuffix), Csv(r.originalTargetPath), Csv(r.targetSuffix), Csv(r.originalTargetFullName), Csv(r.originalTargetGraphicRef), Csv(r.originalButtonScriptPathId), Csv(r.originalEvidence),
                Bool(r.eventSystemPresent), Csv(r.eventSystemName), Csv(r.inputModuleSummary), Csv(r.canvasPath), Csv(r.canvasRenderMode), Csv(r.eventCameraName), r.eventSystemRaycastAllCount.ToString(), Csv(r.eventTopObjectPath), Bool(r.eventTargetIncluded), Csv(r.eventHitPaths), r.graphicRaycasterHitCount.ToString(), Csv(r.graphicTopObjectPath), Bool(r.graphicTargetIncluded), Csv(r.graphicHitPaths),
                Bool(r.buttonActiveInHierarchy), Bool(r.buttonInteractable), Csv(r.selectableState), Csv(r.targetGraphicPath), Csv(r.targetGraphicType), r.onClickPersistentCount.ToString(), r.onClickRuntimeCount.ToString(), r.onClickTotalKnownCount.ToString(), r.eventTriggerCountOnButton.ToString(), r.buttonMissingMonoBehaviourCount.ToString(), r.parentMissingMonoBehaviourCount.ToString(), Csv(r.buttonComponentTypes), Csv(r.parentHandlerSummary), Csv(r.eventTriggerSummary),
                Csv(r.pointerDownReceiver), Csv(r.pointerUpReceiver), Csv(r.pointerClickReceiver), Csv(r.submitReceiver), Csv(r.executeReceiverChain), Bool(r.executePointerDown), Bool(r.executePointerUp), Bool(r.executePointerClick), Bool(r.executeSubmit), Csv(r.selectedBefore), Csv(r.selectedAfter), Bool(r.stateChanged), r.capturedLogCount.ToString(), Csv(r.capturedLogs), Csv(r.executeException), Bool(r.clickPathValidated), Bool(r.gameplayHandlerBound), Csv(r.blocker)
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
        sb.AppendLine("  \"readyInputRowCount\": " + r.readyInputRowCount + ",");
        sb.AppendLine("  \"rowCount\": " + r.rowCount + ",");
        sb.AppendLine("  \"eventSystemCount\": " + r.eventSystemCount + ",");
        sb.AppendLine("  \"inputModuleCount\": " + r.inputModuleCount + ",");
        sb.AppendLine("  \"inputModuleSummary\": \"" + Json(r.inputModuleSummary) + "\",");
        sb.AppendLine("  \"graphicRaycastTargetIncludedCount\": " + r.graphicRaycastTargetIncludedCount + ",");
        sb.AppendLine("  \"eventSystemTargetIncludedCount\": " + r.eventSystemTargetIncludedCount + ",");
        sb.AppendLine("  \"executeClickReceiverCount\": " + r.executeClickReceiverCount + ",");
        sb.AppendLine("  \"clickPathValidatedCount\": " + r.clickPathValidatedCount + ",");
        sb.AppendLine("  \"uniqueClickPathButtonCount\": " + r.uniqueClickPathButtonCount + ",");
        sb.AppendLine("  \"onClickListenerBoundCount\": " + r.onClickListenerBoundCount + ",");
        sb.AppendLine("  \"boundGameplayHandlerCount\": " + r.boundGameplayHandlerCount + ",");
        sb.AppendLine("  \"executeExceptionCount\": " + r.executeExceptionCount + ",");
        sb.AppendLine("  \"before\": {\"canvas\":" + r.beforeCanvasCount + ",\"raycaster\":" + r.beforeRaycasterCount + ",\"button\":" + r.beforeButtonCount + ",\"missingScript\":" + r.beforeMissingScriptCount + "},");
        sb.AppendLine("  \"reopen\": {\"canvas\":" + r.reopenCanvasCount + ",\"raycaster\":" + r.reopenRaycasterCount + ",\"button\":" + r.reopenButtonCount + ",\"missingScript\":" + r.reopenMissingScriptCount + "},");
        sb.AppendLine("  \"blockerSummary\": \"" + Json(r.blockerSummary) + "\",");
        sb.AppendLine("  \"patchDecision\": \"" + Json(r.patchDecision) + "\",");
        sb.AppendLine("  \"failReason\": \"" + Json(r.failReason) + "\"");
        sb.AppendLine("}");
        File.WriteAllText(path, sb.ToString(), new UTF8Encoding(false));
    }

    private sealed class ReadyRow { public string pointName = "", buttonName = "", buttonScenePath = "", pointerPosition = ""; }
    private sealed class ManifestRow { public string originalButtonPath = "", buttonSuffix = "", targetGraphicRef = "", originalTargetPath = "", targetSuffix = "", targetFullName = "", buttonScriptPathId = "", evidence = ""; }

    private sealed class Result
    {
        public string status = "", sourceScene = "", scene = "", capture = "", failReason = "", inputModuleSummary = "", blockerSummary = "", patchDecision = "";
        public bool isFinalRestoredBattleScreen, sourceSceneOpened, sceneSaved, captureExists, reopenValid;
        public int readyInputRowCount, rowCount, eventSystemCount, inputModuleCount, graphicRaycastTargetIncludedCount, eventSystemTargetIncludedCount, executeClickReceiverCount, clickPathValidatedCount, uniqueClickPathButtonCount, onClickListenerBoundCount, boundGameplayHandlerCount, executeExceptionCount;
        public int beforeCanvasCount, beforeRaycasterCount, beforeButtonCount, beforeMissingScriptCount, reopenCanvasCount, reopenRaycasterCount, reopenButtonCount, reopenMissingScriptCount;
    }

    private sealed class Row
    {
        public string pointName = "", buttonName = "", pointerPosition = "", buttonScenePath = "", originalButtonPath = "", buttonSuffix = "", originalTargetPath = "", targetSuffix = "", originalTargetFullName = "", originalTargetGraphicRef = "", originalButtonScriptPathId = "", originalEvidence = "";
        public bool eventSystemPresent, eventTargetIncluded, graphicTargetIncluded, buttonActiveInHierarchy, buttonInteractable, executePointerDown, executePointerUp, executePointerClick, executeSubmit, stateChanged, clickPathValidated, gameplayHandlerBound;
        public string eventSystemName = "", inputModuleSummary = "", canvasPath = "", canvasRenderMode = "", eventCameraName = "", eventTopObjectPath = "", eventHitPaths = "", graphicTopObjectPath = "", graphicHitPaths = "", selectableState = "", targetGraphicPath = "", targetGraphicType = "";
        public int eventSystemRaycastAllCount, graphicRaycasterHitCount, onClickPersistentCount, onClickRuntimeCount, onClickTotalKnownCount, eventTriggerCountOnButton, buttonMissingMonoBehaviourCount, parentMissingMonoBehaviourCount, capturedLogCount;
        public string buttonComponentTypes = "", parentHandlerSummary = "", eventTriggerSummary = "", pointerDownReceiver = "", pointerUpReceiver = "", pointerClickReceiver = "", submitReceiver = "", executeReceiverChain = "", selectedBefore = "", selectedAfter = "", capturedLogs = "", executeException = "", blocker = "";
    }
}
