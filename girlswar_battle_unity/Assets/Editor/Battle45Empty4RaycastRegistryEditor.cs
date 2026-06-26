using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using TMPro;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Text;

public static class Battle45TraceCanvasGraphicRegistryCameraAndEmpty4RaycastRuntimeEnableEditor
{
    private const string SourceScenePath = "Assets/Scenes/Battle43PlayableContextValidationCandidate.unity";
    private const string ScenePath = "Assets/Scenes/Battle45Empty4RaycastRegistryCandidate.unity";
    private const string PatchManifestPath = "Assets/RestoreData/battle/BATTLE_44_ORIGINAL_BUTTON_TARGET_GRAPHIC_PATCH_MANIFEST.csv";
    private const string ResultJsonPath = "Assets/RestoreData/battle/BATTLE_45_TRACE_CANVAS_GRAPHIC_REGISTRY_CAMERA_AND_EMPTY4RAYCAST_RUNTIME_ENABLE_UNITY.json";
    private const string RowsCsvPath = "Assets/RestoreData/battle/BATTLE_45_TRACE_CANVAS_GRAPHIC_REGISTRY_CAMERA_AND_EMPTY4RAYCAST_RUNTIME_ENABLE_COMPONENTS.csv";
    private const string CapturePath = "Assets/RestoreCaptures/battle_actor/Battle45Empty4RaycastRegistryCandidate_1920x1080.png";
    private const int CaptureWidth = 1920;
    private const int CaptureHeight = 1080;

    [MenuItem("GirlsWar/Battle/BATTLE45 Trace Empty4Raycast Registry")]
    public static void Build()
    {
        Directory.CreateDirectory(ProjectPath("Assets/RestoreData/battle"));
        Directory.CreateDirectory(ProjectPath("Assets/RestoreCaptures/battle_actor"));
        var rows = new List<Row>();
        var result = new Result();
        result.sourceScene = SourceScenePath;
        result.scene = ScenePath;
        result.capture = CapturePath;
        result.isFinalRestoredBattleScreen = false;

        TraceEmpty4RaycastScript(result);
        var manifest = LoadManifest(ProjectPath(PatchManifestPath));
        result.patchManifestCount = manifest.Count;

        if (!File.Exists(ProjectPath(SourceScenePath)))
        {
            result.failReason = "source_scene_file_not_found";
            WriteOutputs(result, rows);
            return;
        }

        var scene = EditorSceneManager.OpenScene(SourceScenePath, OpenSceneMode.Single);
        result.sourceSceneOpened = scene.IsValid();
        var camera = FindCaptureCamera();
        if (camera == null) camera = CreateFallbackCamera();
        ConfigureCamera(camera);
        result.eventSystemAdded = EnsureEventSystem();
        result.graphicRaycasterAddedCount = AddGraphicRaycasters();
        Snapshot(result, "before");

        var originalButtonPaths = new HashSet<string>();
        foreach (var item in manifest)
        {
            var buttonTransform = FindTransformBySuffix(item.buttonSuffix);
            if (buttonTransform == null)
            {
                rows.Add(MakeRow("button_root_missing", null, null, item, "button suffix not found"));
                continue;
            }
            originalButtonPaths.Add(HierarchyPath(buttonTransform));
            var targetTransform = !string.IsNullOrEmpty(item.targetSuffix) ? FindTransformBySuffix(item.targetSuffix) : null;
            if (targetTransform == null) targetTransform = buttonTransform;

            Graphic targetGraphic = null;
            if (item.targetFullName == "UnityEngine.UI.Empty4Raycast")
            {
                var empty = targetTransform.GetComponent<Empty4Raycast>();
                if (empty == null)
                {
                    empty = targetTransform.gameObject.AddComponent<Empty4Raycast>();
                    result.empty4RaycastAddedCount++;
                }
                empty.enabled = true;
                empty.raycastTarget = item.targetRaycastTarget != "0";
                empty.color = ParseColor(item.targetColor, Color.white);
                empty.SetAllDirty();
                targetGraphic = empty;
            }
            else
            {
                targetGraphic = targetTransform.GetComponent<Graphic>();
                if (targetGraphic != null)
                {
                    targetGraphic.enabled = true;
                    targetGraphic.raycastTarget = item.targetRaycastTarget != "0";
                    targetGraphic.SetAllDirty();
                }
            }

            if (targetGraphic == null)
            {
                rows.Add(MakeRow("target_graphic_missing", buttonTransform, targetTransform, item, "target transform matched but no Graphic component exists"));
                continue;
            }

            var button = buttonTransform.GetComponent<Button>();
            if (button == null)
            {
                button = buttonTransform.gameObject.AddComponent<Button>();
                result.buttonAddedCount++;
            }
            button.targetGraphic = targetGraphic;
            button.interactable = true;
            button.transition = Selectable.Transition.None;
            result.patchedButtonCount++;
            rows.Add(MakeRow("patched_original_target_graphic", buttonTransform, targetTransform, item, "targetGraphic mapped from original m_TargetGraphic PPtr; no fake onClick"));
        }

        result.removedHeuristicButtonCount = RemoveHeuristicButtons(originalButtonPaths);
        Canvas.ForceUpdateCanvases();
        foreach (var graphic in UnityEngine.Object.FindObjectsOfType<Graphic>(true))
        {
            if (graphic != null) graphic.SetAllDirty();
        }
        Canvas.ForceUpdateCanvases();
        Snapshot(result, "after");
        result.registryTargetIncludedCount = ProbeRegistryAndRaycasts(rows, camera);
        result.raycastReadyButtonCount = CountRaycastReady(rows);

        EditorSceneManager.SaveScene(scene, ScenePath);
        result.sceneSaved = File.Exists(ProjectPath(ScenePath));
        Capture(camera, ProjectPath(CapturePath));
        result.captureExists = File.Exists(ProjectPath(CapturePath));

        var reopened = EditorSceneManager.OpenScene(ScenePath, OpenSceneMode.Single);
        result.reopenValid = reopened.IsValid();
        Canvas.ForceUpdateCanvases();
        Snapshot(result, "reopen");
        result.reopenRegistryTargetIncludedCount = ProbeRegistryAndRaycasts(rows, FindCaptureCamera());
        result.reopenRaycastReadyButtonCount = CountRaycastReady(rows);
        result.reopenEventSystemCount = UnityEngine.Object.FindObjectsOfType<EventSystem>(true).Length;

        WriteOutputs(result, rows);
        AssetDatabase.Refresh();
        Debug.Log("BATTLE45 Empty4Raycast registry trace complete. reopenEmpty=" + result.reopenEmpty4RaycastCount + ", reopenReady=" + result.reopenRaycastReadyButtonCount);
    }

    private static void TraceEmpty4RaycastScript(Result result)
    {
        var go = new GameObject("BATTLE45_TempEmpty4RaycastScriptProbe");
        var empty = go.AddComponent<Empty4Raycast>();
        var mono = MonoScript.FromMonoBehaviour(empty);
        result.empty4RaycastTypeFullName = typeof(Empty4Raycast).FullName;
        result.empty4RaycastAssemblyName = typeof(Empty4Raycast).Assembly.GetName().Name;
        if (mono != null)
        {
            result.empty4RaycastMonoScriptPath = AssetDatabase.GetAssetPath(mono);
            result.empty4RaycastMonoScriptGuid = AssetDatabase.AssetPathToGUID(result.empty4RaycastMonoScriptPath);
            result.empty4RaycastMonoScriptClass = mono.GetClass() != null ? mono.GetClass().FullName : "";
        }
        UnityEngine.Object.DestroyImmediate(go);
    }

    private static int ProbeRegistryAndRaycasts(List<Row> rows, Camera camera)
    {
        int included = 0;
        var eventSystem = UnityEngine.Object.FindObjectOfType<EventSystem>(true);
        foreach (var button in UnityEngine.Object.FindObjectsOfType<Button>(true))
        {
            if (button == null || !button.gameObject.activeInHierarchy || button.targetGraphic == null) continue;
            var row = MakeRow("registry_and_raycast_probe", button.transform, button.targetGraphic.transform, null, "registry/raycast probe");
            var canvas = button.GetComponentInParent<Canvas>(true);
            row.hasParentCanvas = canvas != null;
            if (canvas != null)
            {
                row.canvasPath = HierarchyPath(canvas.transform);
                row.canvasRenderMode = canvas.renderMode.ToString();
                row.canvasWorldCameraName = canvas.worldCamera != null ? canvas.worldCamera.name : "";
                var raycaster = canvas.GetComponent<GraphicRaycaster>();
                row.hasGraphicRaycaster = raycaster != null;
                row.raycasterEnabled = raycaster != null && raycaster.enabled;
                try
                {
                    var graphics = GraphicRegistry.GetGraphicsForCanvas(canvas);
                    row.registryCount = graphics != null ? graphics.Count : 0;
                    row.targetInRegistry = graphics != null && graphics.Contains(button.targetGraphic);
                    if (row.targetInRegistry) included++;
                }
                catch (Exception ex)
                {
                    row.registryError = ex.GetType().Name + ":" + ex.Message;
                }
            }
            row.targetEnabled = button.targetGraphic.enabled;
            row.targetRaycastTarget = button.targetGraphic.raycastTarget;
            row.targetMaterialName = button.targetGraphic.material != null ? button.targetGraphic.material.name : "";
            row.targetHasCanvasRenderer = button.targetGraphic.GetComponent<CanvasRenderer>() != null;
            row.targetLayer = button.targetGraphic.gameObject.layer;
            row.targetActiveInHierarchy = button.targetGraphic.gameObject.activeInHierarchy;
            row.canvasGroupBlocksRaycasts = ParentCanvasGroupsAllowRaycasts(button.targetGraphic.transform);
            ProbeRaycast(button, camera, eventSystem, row);
            rows.Add(row);
        }
        return included;
    }

    private static void ProbeRaycast(Button button, Camera camera, EventSystem eventSystem, Row row)
    {
        if (eventSystem == null)
        {
            row.raycastReason = "missing_event_system";
            return;
        }
        var rect = button.targetGraphic.transform as RectTransform;
        if (rect == null)
        {
            row.raycastReason = "missing_target_rect";
            return;
        }
        var canvas = button.GetComponentInParent<Canvas>(true);
        var raycaster = canvas != null ? canvas.GetComponent<GraphicRaycaster>() : null;
        if (canvas == null || raycaster == null)
        {
            row.raycastReason = canvas == null ? "missing_canvas" : "missing_graphic_raycaster";
            return;
        }
        Camera eventCamera = canvas.renderMode == RenderMode.ScreenSpaceOverlay ? null : raycaster.eventCamera;
        if (eventCamera == null && canvas.renderMode != RenderMode.ScreenSpaceOverlay) eventCamera = canvas.worldCamera != null ? canvas.worldCamera : camera;
        row.eventCameraName = eventCamera != null ? eventCamera.name : "(overlay/null)";
        Vector2 screen = RectTransformUtility.WorldToScreenPoint(eventCamera, rect.TransformPoint(rect.rect.center));
        row.screen = Vec2(screen);
        var data = new PointerEventData(eventSystem);
        data.position = screen;
        var hits = new List<RaycastResult>();
        raycaster.Raycast(data, hits);
        row.hitCount = hits.Count;
        var hitPaths = new List<string>();
        foreach (var hit in hits)
        {
            if (hit.gameObject == null) continue;
            if (hitPaths.Count < 5) hitPaths.Add(HierarchyPath(hit.gameObject.transform));
            if (hit.gameObject == button.targetGraphic.gameObject || hit.gameObject.transform.IsChildOf(button.transform)) row.raycastReady = true;
        }
        row.hitPaths = string.Join(" | ", hitPaths.ToArray());
        row.raycastReason = row.raycastReady ? "target_hit" : (hits.Count == 0 ? "no_graphic_hits_at_target_center" : "target_not_in_hits");
    }

    private static bool ParentCanvasGroupsAllowRaycasts(Transform transform)
    {
        var cursor = transform;
        while (cursor != null)
        {
            foreach (var group in cursor.GetComponents<CanvasGroup>())
                if (group != null && !group.blocksRaycasts) return false;
            cursor = cursor.parent;
        }
        return true;
    }

    private static int CountRaycastReady(List<Row> rows)
    {
        int count = 0;
        foreach (var row in rows)
            if (row.status == "registry_and_raycast_probe" && row.raycastReady) count++;
        return count;
    }

    private static void Snapshot(Result result, string phase)
    {
        int canvas = UnityEngine.Object.FindObjectsOfType<Canvas>(true).Length;
        int raycaster = UnityEngine.Object.FindObjectsOfType<GraphicRaycaster>(true).Length;
        int image = UnityEngine.Object.FindObjectsOfType<Image>(true).Length;
        int graphic = UnityEngine.Object.FindObjectsOfType<Graphic>(true).Length;
        int button = UnityEngine.Object.FindObjectsOfType<Button>(true).Length;
        int empty = UnityEngine.Object.FindObjectsOfType<Empty4Raycast>(true).Length;
        int activeGraphic = CountActiveGraphics();
        int mask = UnityEngine.Object.FindObjectsOfType<Mask>(true).Length;
        int rectMask = UnityEngine.Object.FindObjectsOfType<RectMask2D>(true).Length;
        int text = UnityEngine.Object.FindObjectsOfType<Text>(true).Length;
        int tmp = UnityEngine.Object.FindObjectsOfType<TMP_Text>(true).Length;
        int missing = CountMissingScripts();
        if (phase == "before") { result.beforeCanvasCount = canvas; result.beforeGraphicRaycasterCount = raycaster; result.beforeImageCount = image; result.beforeGraphicCount = graphic; result.beforeButtonCount = button; result.beforeEmpty4RaycastCount = empty; result.beforeActiveGraphicCount = activeGraphic; result.beforeMaskCount = mask; result.beforeRectMask2DCount = rectMask; result.beforeTextCount = text; result.beforeTmpCount = tmp; result.beforeMissingScriptCount = missing; return; }
        if (phase == "after") { result.afterCanvasCount = canvas; result.afterGraphicRaycasterCount = raycaster; result.afterImageCount = image; result.afterGraphicCount = graphic; result.afterButtonCount = button; result.afterEmpty4RaycastCount = empty; result.afterActiveGraphicCount = activeGraphic; result.afterMaskCount = mask; result.afterRectMask2DCount = rectMask; result.afterTextCount = text; result.afterTmpCount = tmp; result.afterMissingScriptCount = missing; return; }
        result.reopenCanvasCount = canvas; result.reopenGraphicRaycasterCount = raycaster; result.reopenImageCount = image; result.reopenGraphicCount = graphic; result.reopenButtonCount = button; result.reopenEmpty4RaycastCount = empty; result.reopenActiveGraphicCount = activeGraphic; result.reopenMaskCount = mask; result.reopenRectMask2DCount = rectMask; result.reopenTextCount = text; result.reopenTmpCount = tmp; result.reopenMissingScriptCount = missing;
    }

    private static int RemoveHeuristicButtons(HashSet<string> originalButtonPaths)
    {
        int removed = 0;
        foreach (var button in UnityEngine.Object.FindObjectsOfType<Button>(true))
        {
            string path = HierarchyPath(button.transform);
            if (originalButtonPaths.Contains(path)) continue;
            if (path.IndexOf("/btn", StringComparison.OrdinalIgnoreCase) < 0 && path.IndexOf("/BT_", StringComparison.OrdinalIgnoreCase) < 0) continue;
            UnityEngine.Object.DestroyImmediate(button);
            removed++;
        }
        return removed;
    }

    private static int AddGraphicRaycasters()
    {
        int count = 0;
        foreach (var canvas in UnityEngine.Object.FindObjectsOfType<Canvas>(true))
        {
            if (!canvas.gameObject.activeInHierarchy || canvas.GetComponent<GraphicRaycaster>() != null) continue;
            canvas.gameObject.AddComponent<GraphicRaycaster>();
            count++;
        }
        return count;
    }

    private static bool EnsureEventSystem()
    {
        if (UnityEngine.Object.FindObjectOfType<EventSystem>(true) != null) return false;
        var go = new GameObject("BATTLE45_EvidenceBackedEventSystem");
        go.AddComponent<EventSystem>();
        go.AddComponent<StandaloneInputModule>();
        return true;
    }

    private static Transform FindTransformBySuffix(string suffix)
    {
        if (string.IsNullOrEmpty(suffix)) return null;
        string normalized = suffix.Replace("\\", "/").Trim('/');
        Transform fallback = null;
        foreach (var transform in UnityEngine.Object.FindObjectsOfType<Transform>(true))
        {
            string path = HierarchyPath(transform).Replace("\\", "/");
            if (path.EndsWith("/" + normalized, StringComparison.OrdinalIgnoreCase) || path.Equals(normalized, StringComparison.OrdinalIgnoreCase))
            {
                if (transform.gameObject.activeInHierarchy) return transform;
                if (fallback == null) fallback = transform;
            }
        }
        return fallback;
    }

    private static List<ManifestRow> LoadManifest(string path)
    {
        var rows = new List<ManifestRow>();
        if (!File.Exists(path)) return rows;
        var lines = File.ReadAllLines(path, new UTF8Encoding(true));
        if (lines.Length < 2) return rows;
        var headers = SplitCsvLine(lines[0]);
        for (int i = 1; i < lines.Length; i++)
        {
            if (string.IsNullOrWhiteSpace(lines[i])) continue;
            var values = SplitCsvLine(lines[i]);
            var map = new Dictionary<string, string>();
            for (int j = 0; j < headers.Count && j < values.Count; j++) map[headers[j]] = values[j];
            rows.Add(new ManifestRow
            {
                originalButtonPath = Get(map, "originalButtonPath"),
                buttonSuffix = Get(map, "buttonSuffix"),
                targetFullName = Get(map, "targetFullName"),
                targetSuffix = Get(map, "targetSuffix"),
                targetRaycastTarget = Get(map, "targetRaycastTarget"),
                targetColor = Get(map, "targetColor"),
                targetGraphicRef = Get(map, "targetGraphicRef")
            });
        }
        return rows;
    }

    private static Row MakeRow(string status, Transform button, Transform target, ManifestRow item, string evidence)
    {
        var row = new Row();
        row.status = status;
        row.evidence = evidence;
        if (item != null)
        {
            row.originalButtonPath = item.originalButtonPath;
            row.buttonSuffix = item.buttonSuffix;
            row.targetFullName = item.targetFullName;
            row.targetSuffix = item.targetSuffix;
            row.targetGraphicRef = item.targetGraphicRef;
        }
        if (button != null)
        {
            row.buttonScenePath = HierarchyPath(button);
            row.buttonActiveInHierarchy = button.gameObject.activeInHierarchy;
            var rect = button as RectTransform;
            if (rect != null) { row.buttonRectSize = Vec2(rect.rect.size); row.buttonAnchoredPosition = Vec2(rect.anchoredPosition); }
            var b = button.GetComponent<Button>();
            row.hasButton = b != null;
            row.buttonInteractable = b != null && b.interactable;
        }
        if (target != null)
        {
            row.targetScenePath = HierarchyPath(target);
            row.targetActiveInHierarchy = target.gameObject.activeInHierarchy;
            var graphic = target.GetComponent<Graphic>();
            if (graphic != null)
            {
                row.boundTargetGraphicType = graphic.GetType().FullName;
                row.targetEnabled = graphic.enabled;
                row.targetRaycastTarget = graphic.raycastTarget;
            }
            var rect = target as RectTransform;
            if (rect != null) { row.targetRectSize = Vec2(rect.rect.size); row.targetAnchoredPosition = Vec2(rect.anchoredPosition); }
        }
        return row;
    }

    private static int CountActiveGraphics()
    {
        int count = 0;
        foreach (var graphic in UnityEngine.Object.FindObjectsOfType<Graphic>(true))
            if (graphic != null && graphic.enabled && graphic.gameObject.activeInHierarchy) count++;
        return count;
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

    private static Camera CreateFallbackCamera()
    {
        var go = new GameObject("BATTLE45_FallbackCaptureCamera");
        return go.AddComponent<Camera>();
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
    }

    private static void Capture(Camera camera, string path)
    {
        Directory.CreateDirectory(Path.GetDirectoryName(path));
        var rt = new RenderTexture(CaptureWidth, CaptureHeight, 24, RenderTextureFormat.ARGB32);
        var previousTarget = camera.targetTexture;
        var previousActive = RenderTexture.active;
        camera.targetTexture = rt;
        RenderTexture.active = rt;
        camera.Render();
        var texture = new Texture2D(CaptureWidth, CaptureHeight, TextureFormat.RGB24, false);
        texture.ReadPixels(new Rect(0, 0, CaptureWidth, CaptureHeight), 0, 0);
        texture.Apply();
        File.WriteAllBytes(path, texture.EncodeToPNG());
        camera.targetTexture = previousTarget;
        RenderTexture.active = previousActive;
        UnityEngine.Object.DestroyImmediate(texture);
        UnityEngine.Object.DestroyImmediate(rt);
    }

    private static void WriteOutputs(Result result, List<Row> rows)
    {
        WriteRowsCsv(ProjectPath(RowsCsvPath), rows);
        WriteJson(ProjectPath(ResultJsonPath), result);
    }

    private static void WriteRowsCsv(string path, List<Row> rows)
    {
        Directory.CreateDirectory(Path.GetDirectoryName(path));
        var sb = new StringBuilder();
        sb.AppendLine("status,originalButtonPath,buttonSuffix,buttonScenePath,targetFullName,targetSuffix,targetGraphicRef,targetScenePath,boundTargetGraphicType,hasButton,buttonInteractable,buttonActiveInHierarchy,targetActiveInHierarchy,targetEnabled,targetRaycastTarget,buttonRectSize,targetRectSize,canvasPath,canvasRenderMode,canvasWorldCameraName,hasParentCanvas,hasGraphicRaycaster,raycasterEnabled,eventCameraName,screen,targetLayer,targetHasCanvasRenderer,targetMaterialName,canvasGroupBlocksRaycasts,registryCount,targetInRegistry,registryError,hitCount,hitPaths,raycastReady,raycastReason,evidence");
        foreach (var r in rows)
        {
            sb.AppendLine(string.Join(",", new[]
            {
                Csv(r.status), Csv(r.originalButtonPath), Csv(r.buttonSuffix), Csv(r.buttonScenePath), Csv(r.targetFullName), Csv(r.targetSuffix), Csv(r.targetGraphicRef), Csv(r.targetScenePath), Csv(r.boundTargetGraphicType),
                Bool(r.hasButton), Bool(r.buttonInteractable), Bool(r.buttonActiveInHierarchy), Bool(r.targetActiveInHierarchy), Bool(r.targetEnabled), Bool(r.targetRaycastTarget),
                Csv(r.buttonRectSize), Csv(r.targetRectSize), Csv(r.canvasPath), Csv(r.canvasRenderMode), Csv(r.canvasWorldCameraName), Bool(r.hasParentCanvas), Bool(r.hasGraphicRaycaster), Bool(r.raycasterEnabled),
                Csv(r.eventCameraName), Csv(r.screen), r.targetLayer.ToString(), Bool(r.targetHasCanvasRenderer), Csv(r.targetMaterialName), Bool(r.canvasGroupBlocksRaycasts),
                r.registryCount.ToString(), Bool(r.targetInRegistry), Csv(r.registryError), r.hitCount.ToString(), Csv(r.hitPaths), Bool(r.raycastReady), Csv(r.raycastReason), Csv(r.evidence)
            }));
        }
        File.WriteAllText(path, sb.ToString(), new UTF8Encoding(false));
    }

    private static void WriteJson(string path, Result r)
    {
        Directory.CreateDirectory(Path.GetDirectoryName(path));
        var sb = new StringBuilder();
        sb.AppendLine("{");
        sb.AppendLine("  \"status\": \"battle45_trace_canvas_graphic_registry_camera_and_empty4raycast_runtime_enable\",");
        sb.AppendLine("  \"isFinalRestoredBattleScreen\": false,");
        sb.AppendLine("  \"sourceScene\": \"" + Json(r.sourceScene) + "\",");
        sb.AppendLine("  \"scene\": \"" + Json(r.scene) + "\",");
        sb.AppendLine("  \"capture\": \"" + Json(r.capture) + "\",");
        sb.AppendLine("  \"sourceSceneOpened\": " + Bool(r.sourceSceneOpened) + ",");
        sb.AppendLine("  \"sceneSaved\": " + Bool(r.sceneSaved) + ",");
        sb.AppendLine("  \"captureExists\": " + Bool(r.captureExists) + ",");
        sb.AppendLine("  \"reopenValid\": " + Bool(r.reopenValid) + ",");
        sb.AppendLine("  \"empty4RaycastTypeFullName\": \"" + Json(r.empty4RaycastTypeFullName) + "\",");
        sb.AppendLine("  \"empty4RaycastAssemblyName\": \"" + Json(r.empty4RaycastAssemblyName) + "\",");
        sb.AppendLine("  \"empty4RaycastMonoScriptPath\": \"" + Json(r.empty4RaycastMonoScriptPath) + "\",");
        sb.AppendLine("  \"empty4RaycastMonoScriptGuid\": \"" + Json(r.empty4RaycastMonoScriptGuid) + "\",");
        sb.AppendLine("  \"empty4RaycastMonoScriptClass\": \"" + Json(r.empty4RaycastMonoScriptClass) + "\",");
        sb.AppendLine("  \"patchManifestCount\": " + r.patchManifestCount + ",");
        sb.AppendLine("  \"patchedButtonCount\": " + r.patchedButtonCount + ",");
        sb.AppendLine("  \"buttonAddedCount\": " + r.buttonAddedCount + ",");
        sb.AppendLine("  \"empty4RaycastAddedCount\": " + r.empty4RaycastAddedCount + ",");
        sb.AppendLine("  \"removedHeuristicButtonCount\": " + r.removedHeuristicButtonCount + ",");
        sb.AppendLine("  \"eventSystemAdded\": " + Bool(r.eventSystemAdded) + ",");
        sb.AppendLine("  \"graphicRaycasterAddedCount\": " + r.graphicRaycasterAddedCount + ",");
        sb.AppendLine("  \"registryTargetIncludedCount\": " + r.registryTargetIncludedCount + ",");
        sb.AppendLine("  \"reopenRegistryTargetIncludedCount\": " + r.reopenRegistryTargetIncludedCount + ",");
        sb.AppendLine("  \"raycastReadyButtonCount\": " + r.raycastReadyButtonCount + ",");
        sb.AppendLine("  \"reopenRaycastReadyButtonCount\": " + r.reopenRaycastReadyButtonCount + ",");
        sb.AppendLine("  \"reopenEventSystemCount\": " + r.reopenEventSystemCount + ",");
        sb.AppendLine("  \"before\": " + CountsJson(r, "before") + ",");
        sb.AppendLine("  \"after\": " + CountsJson(r, "after") + ",");
        sb.AppendLine("  \"reopen\": " + CountsJson(r, "reopen") + ",");
        sb.AppendLine("  \"reopenButtonCount\": " + r.reopenButtonCount + ",");
        sb.AppendLine("  \"reopenEmpty4RaycastCount\": " + r.reopenEmpty4RaycastCount + ",");
        sb.AppendLine("  \"reopenMissingScriptCount\": " + r.reopenMissingScriptCount + ",");
        sb.AppendLine("  \"reopenMaskCount\": " + r.reopenMaskCount + ",");
        sb.AppendLine("  \"reopenRectMask2DCount\": " + r.reopenRectMask2DCount + ",");
        sb.AppendLine("  \"reopenTmpCount\": " + r.reopenTmpCount + ",");
        sb.AppendLine("  \"reopenTextCount\": " + r.reopenTextCount + ",");
        sb.AppendLine("  \"failReason\": \"" + Json(r.failReason) + "\"");
        sb.AppendLine("}");
        File.WriteAllText(path, sb.ToString(), new UTF8Encoding(false));
    }

    private static string CountsJson(Result r, string phase)
    {
        if (phase == "before") return "{\"canvas\":" + r.beforeCanvasCount + ",\"graphicRaycaster\":" + r.beforeGraphicRaycasterCount + ",\"image\":" + r.beforeImageCount + ",\"graphic\":" + r.beforeGraphicCount + ",\"activeGraphic\":" + r.beforeActiveGraphicCount + ",\"button\":" + r.beforeButtonCount + ",\"empty4Raycast\":" + r.beforeEmpty4RaycastCount + ",\"mask\":" + r.beforeMaskCount + ",\"rectMask2D\":" + r.beforeRectMask2DCount + ",\"text\":" + r.beforeTextCount + ",\"tmp\":" + r.beforeTmpCount + ",\"missingScript\":" + r.beforeMissingScriptCount + "}";
        if (phase == "after") return "{\"canvas\":" + r.afterCanvasCount + ",\"graphicRaycaster\":" + r.afterGraphicRaycasterCount + ",\"image\":" + r.afterImageCount + ",\"graphic\":" + r.afterGraphicCount + ",\"activeGraphic\":" + r.afterActiveGraphicCount + ",\"button\":" + r.afterButtonCount + ",\"empty4Raycast\":" + r.afterEmpty4RaycastCount + ",\"mask\":" + r.afterMaskCount + ",\"rectMask2D\":" + r.afterRectMask2DCount + ",\"text\":" + r.afterTextCount + ",\"tmp\":" + r.afterTmpCount + ",\"missingScript\":" + r.afterMissingScriptCount + "}";
        return "{\"canvas\":" + r.reopenCanvasCount + ",\"graphicRaycaster\":" + r.reopenGraphicRaycasterCount + ",\"image\":" + r.reopenImageCount + ",\"graphic\":" + r.reopenGraphicCount + ",\"activeGraphic\":" + r.reopenActiveGraphicCount + ",\"button\":" + r.reopenButtonCount + ",\"empty4Raycast\":" + r.reopenEmpty4RaycastCount + ",\"mask\":" + r.reopenMaskCount + ",\"rectMask2D\":" + r.reopenRectMask2DCount + ",\"text\":" + r.reopenTextCount + ",\"tmp\":" + r.reopenTmpCount + ",\"missingScript\":" + r.reopenMissingScriptCount + "}";
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
    private static Color ParseColor(string value, Color fallback)
    {
        var parts = (value ?? "").Split('/');
        if (parts.Length != 4) return fallback;
        float r, g, b, a;
        if (!float.TryParse(parts[0], NumberStyles.Float, CultureInfo.InvariantCulture, out r)) return fallback;
        if (!float.TryParse(parts[1], NumberStyles.Float, CultureInfo.InvariantCulture, out g)) return fallback;
        if (!float.TryParse(parts[2], NumberStyles.Float, CultureInfo.InvariantCulture, out b)) return fallback;
        if (!float.TryParse(parts[3], NumberStyles.Float, CultureInfo.InvariantCulture, out a)) return fallback;
        return new Color(r, g, b, a);
    }
    private static string HierarchyPath(Transform transform) { var names = new List<string>(); var cursor = transform; while (cursor != null) { names.Add(cursor.name); cursor = cursor.parent; } names.Reverse(); return string.Join("/", names.ToArray()); }
    private static string ProjectPath(string assetPath) { return Path.Combine(Application.dataPath, "..", assetPath.Replace("/", "\\")); }
    private static string Vec2(Vector2 v) { return v.x.ToString("0.###") + "/" + v.y.ToString("0.###"); }
    private static string Bool(bool value) { return value ? "true" : "false"; }
    private static string Json(string value) { return (value ?? "").Replace("\\", "\\\\").Replace("\"", "\\\"").Replace("\r", " ").Replace("\n", " "); }
    private static string Csv(string value) { return "\"" + (value ?? "").Replace("\"", "\"\"") + "\""; }

    private sealed class ManifestRow { public string originalButtonPath = ""; public string buttonSuffix = ""; public string targetFullName = ""; public string targetSuffix = ""; public string targetRaycastTarget = ""; public string targetColor = ""; public string targetGraphicRef = ""; }
    private sealed class Result
    {
        public bool isFinalRestoredBattleScreen;
        public string sourceScene = "", scene = "", capture = "", failReason = "";
        public bool sourceSceneOpened, sceneSaved, captureExists, reopenValid, eventSystemAdded;
        public string empty4RaycastTypeFullName = "", empty4RaycastAssemblyName = "", empty4RaycastMonoScriptPath = "", empty4RaycastMonoScriptGuid = "", empty4RaycastMonoScriptClass = "";
        public int patchManifestCount, patchedButtonCount, buttonAddedCount, empty4RaycastAddedCount, removedHeuristicButtonCount, graphicRaycasterAddedCount, registryTargetIncludedCount, reopenRegistryTargetIncludedCount, raycastReadyButtonCount, reopenRaycastReadyButtonCount, reopenEventSystemCount;
        public int beforeCanvasCount, beforeGraphicRaycasterCount, beforeImageCount, beforeGraphicCount, beforeActiveGraphicCount, beforeButtonCount, beforeEmpty4RaycastCount, beforeMaskCount, beforeRectMask2DCount, beforeTextCount, beforeTmpCount, beforeMissingScriptCount;
        public int afterCanvasCount, afterGraphicRaycasterCount, afterImageCount, afterGraphicCount, afterActiveGraphicCount, afterButtonCount, afterEmpty4RaycastCount, afterMaskCount, afterRectMask2DCount, afterTextCount, afterTmpCount, afterMissingScriptCount;
        public int reopenCanvasCount, reopenGraphicRaycasterCount, reopenImageCount, reopenGraphicCount, reopenActiveGraphicCount, reopenButtonCount, reopenEmpty4RaycastCount, reopenMaskCount, reopenRectMask2DCount, reopenTextCount, reopenTmpCount, reopenMissingScriptCount;
    }
    private sealed class Row
    {
        public string status = "", originalButtonPath = "", buttonSuffix = "", buttonScenePath = "", targetFullName = "", targetSuffix = "", targetGraphicRef = "", targetScenePath = "", boundTargetGraphicType = "", evidence = "";
        public bool hasButton, buttonInteractable, buttonActiveInHierarchy, targetActiveInHierarchy, targetEnabled, targetRaycastTarget, hasParentCanvas, hasGraphicRaycaster, raycasterEnabled, targetHasCanvasRenderer, canvasGroupBlocksRaycasts = true, targetInRegistry, raycastReady;
        public string buttonRectSize = "", buttonAnchoredPosition = "", targetRectSize = "", targetAnchoredPosition = "", canvasPath = "", canvasRenderMode = "", canvasWorldCameraName = "", eventCameraName = "", screen = "", targetMaterialName = "", registryError = "", hitPaths = "", raycastReason = "";
        public int targetLayer, registryCount, hitCount;
    }
}
