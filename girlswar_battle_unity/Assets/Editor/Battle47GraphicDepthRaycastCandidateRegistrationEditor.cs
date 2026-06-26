using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using TMPro;
using System;
using System.Collections.Generic;
using System.IO;
using System.Reflection;
using System.Text;

public static class Battle47FixGraphicDepthAndRaycastCandidateRegistrationEditor
{
    private const string SourceScenePath = "Assets/Scenes/Battle46GraphicRaycasterEventCameraScreenSpaceCandidate.unity";
    private const string ScenePath = "Assets/Scenes/Battle47GraphicDepthRaycastCandidateRegistration.unity";
    private const string ResultJsonPath = "Assets/RestoreData/battle/BATTLE_47_FIX_GRAPHIC_DEPTH_AND_RAYCAST_CANDIDATE_REGISTRATION_UNITY.json";
    private const string RowsCsvPath = "Assets/RestoreData/battle/BATTLE_47_FIX_GRAPHIC_DEPTH_AND_RAYCAST_CANDIDATE_REGISTRATION_COMPONENTS.csv";
    private const string CapturePath = "Assets/RestoreCaptures/battle_actor/Battle47GraphicDepthRaycastCandidateRegistration_1920x1080.png";
    private const int CaptureWidth = 1920;
    private const int CaptureHeight = 1080;
    private static readonly Dictionary<string, string> BaselineScreenByButtonPath = new Dictionary<string, string>();

    [MenuItem("GirlsWar/Battle/BATTLE47 Fix Graphic Depth And Raycast Candidate Registration")]
    public static void Build()
    {
        Directory.CreateDirectory(ProjectPath("Assets/RestoreData/battle"));
        Directory.CreateDirectory(ProjectPath("Assets/RestoreCaptures/battle_actor"));
        var result = new Result();
        var rows = new List<Row>();
        result.status = "battle47_fix_graphic_depth_and_raycast_candidate_registration";
        result.isFinalRestoredBattleScreen = false;
        result.sourceScene = SourceScenePath;
        result.scene = ScenePath;
        result.capture = CapturePath;
        BaselineScreenByButtonPath.Clear();

        if (!File.Exists(ProjectPath(SourceScenePath)))
        {
            result.failReason = "source_scene_file_not_found";
            WriteOutputs(result, rows);
            return;
        }

        var scene = EditorSceneManager.OpenScene(SourceScenePath, OpenSceneMode.Single);
        result.sourceSceneOpened = scene.IsValid();
        var camera = FindCaptureCamera();
        if (camera != null) ConfigureCamera(camera);
        Snapshot(result, "before");

        ProbePhase(rows, "before_open", camera);
        ForceOnly();
        ProbePhase(rows, "after_force_update", camera);
        DirtyAndRegisterGraphics();
        ProbePhase(rows, "after_set_dirty_register_force_update", camera);
        ExplicitGraphicRebuild();
        ProbePhase(rows, "after_explicit_graphic_rebuild_prerender", camera);
        DestroyTexture(RenderCamera(camera, null));
        ProbePhase(rows, "after_camera_render", camera);
        ResetCameraProjection(camera);
        ForceOnly();
        ProbePhase(rows, "after_camera_render_reset_aspect", camera);

        result.bestAfterPhase = BestPhase(rows);
        FillPhaseSummary(result, rows, "after_camera_render_reset_aspect", true);

        EditorSceneManager.SaveScene(scene, ScenePath);
        result.sceneSaved = File.Exists(ProjectPath(ScenePath));
        Capture(camera, ProjectPath(CapturePath));
        result.captureExists = File.Exists(ProjectPath(CapturePath));

        var reopened = EditorSceneManager.OpenScene(ScenePath, OpenSceneMode.Single);
        result.reopenValid = reopened.IsValid();
        camera = FindCaptureCamera();
        if (camera != null) ConfigureCamera(camera);
        Snapshot(result, "reopenBefore");
        ProbePhase(rows, "reopen_before_update", camera);
        ForceOnly();
        ProbePhase(rows, "reopen_after_force_update", camera);
        DirtyAndRegisterGraphics();
        ExplicitGraphicRebuild();
        DestroyTexture(RenderCamera(camera, null));
        ProbePhase(rows, "reopen_after_dirty_rebuild_render", camera);
        ResetCameraProjection(camera);
        ForceOnly();
        ProbePhase(rows, "reopen_after_render_reset_aspect", camera);
        FillPhaseSummary(result, rows, "reopen_after_render_reset_aspect", false);
        Snapshot(result, "reopenAfter");

        result.patchDecision = DecidePatch(result, rows);
        WriteOutputs(result, rows);
        AssetDatabase.Refresh();
        Debug.Log("BATTLE47 graphic depth/raycast trace complete. reopenReady=" + result.reopenRaycastReadyCount + ", decision=" + result.patchDecision);
    }

    private static void ForceOnly()
    {
        Canvas.ForceUpdateCanvases();
    }

    private static void DirtyAndRegisterGraphics()
    {
        foreach (var graphic in UnityEngine.Object.FindObjectsOfType<Graphic>(true))
        {
            if (graphic == null) continue;
            graphic.SetLayoutDirty();
            graphic.SetVerticesDirty();
            graphic.SetMaterialDirty();
            try { CanvasUpdateRegistry.RegisterCanvasElementForGraphicRebuild(graphic); } catch { }
        }
        foreach (var rect in UnityEngine.Object.FindObjectsOfType<RectTransform>(true))
            if (rect != null) LayoutRebuilder.MarkLayoutForRebuild(rect);
        Canvas.ForceUpdateCanvases();
    }

    private static void ExplicitGraphicRebuild()
    {
        foreach (var graphic in UnityEngine.Object.FindObjectsOfType<Graphic>(true))
        {
            if (graphic == null) continue;
            try { graphic.Rebuild(CanvasUpdate.PreRender); } catch { }
        }
        Canvas.ForceUpdateCanvases();
    }

    private static void ProbePhase(List<Row> rows, string phase, Camera fallbackCamera)
    {
        var eventSystem = UnityEngine.Object.FindObjectOfType<EventSystem>(true);
        foreach (var button in UnityEngine.Object.FindObjectsOfType<Button>(true))
        {
            if (button == null || button.targetGraphic == null) continue;
            var row = MakeRow(phase, button, eventSystem, fallbackCamera);
            rows.Add(row);
        }
    }

    private static Row MakeRow(string phase, Button button, EventSystem eventSystem, Camera fallbackCamera)
    {
        var row = new Row();
        row.phase = phase;
        row.buttonScenePath = HierarchyPath(button.transform);
        row.buttonName = button.name;
        row.hasButton = true;
        row.buttonInteractable = button.interactable;
        row.buttonActiveSelf = button.gameObject.activeSelf;
        row.buttonActiveInHierarchy = button.gameObject.activeInHierarchy;

        var graphic = button.targetGraphic;
        var rect = graphic.transform as RectTransform;
        var renderer = graphic.GetComponent<CanvasRenderer>();
        var parentCanvas = button.GetComponentInParent<Canvas>(true);
        var graphicCanvas = graphic.canvas;
        var raycaster = parentCanvas != null ? parentCanvas.GetComponent<GraphicRaycaster>() : null;
        var eventCamera = raycaster != null ? raycaster.eventCamera : (parentCanvas != null ? parentCanvas.worldCamera : fallbackCamera);
        if (parentCanvas != null && parentCanvas.renderMode == RenderMode.ScreenSpaceOverlay) eventCamera = null;

        row.targetScenePath = HierarchyPath(graphic.transform);
        row.targetName = graphic.name;
        row.targetType = graphic.GetType().FullName;
        row.targetActiveSelf = graphic.gameObject.activeSelf;
        row.targetActiveInHierarchy = graphic.gameObject.activeInHierarchy;
        row.targetEnabled = graphic.enabled;
        row.targetRaycastTarget = graphic.raycastTarget;
        row.targetLayer = graphic.gameObject.layer;
        row.targetDepth = graphic.depth;
        row.graphicCanvasPath = graphicCanvas != null ? HierarchyPath(graphicCanvas.transform) : "";
        row.targetGraphicRaycast = SafeGraphicRaycast(graphic, eventCamera, out row.graphicRaycastError);
        row.targetMaterialName = graphic.material != null ? graphic.material.name : "";
        row.targetMaterialForRenderingName = graphic.materialForRendering != null ? graphic.materialForRendering.name : "";
        row.canvasRendererExists = renderer != null;
        row.canvasRendererAbsoluteDepth = AbsoluteDepth(renderer);
        row.canvasRendererCull = renderer != null && renderer.cull;
        row.canvasRendererCullTransparentMesh = CullTransparentMesh(renderer);
        row.canvasRendererAlpha = renderer != null ? Float(renderer.GetAlpha()) : "";

        if (rect != null)
        {
            row.targetRectSize = Vec2(rect.rect.size);
            row.targetAnchoredPosition = Vec2(rect.anchoredPosition);
            var centerWorld = rect.TransformPoint(rect.rect.center);
            row.worldCenter = Vec3(centerWorld);
            row.screenCenter = Vec2(RectTransformUtility.WorldToScreenPoint(eventCamera, centerWorld));
            row.rectContains = RectTransformUtility.RectangleContainsScreenPoint(rect, ParseVec2(row.screenCenter), eventCamera);
        }

        if (parentCanvas != null)
        {
            row.parentCanvasPath = HierarchyPath(parentCanvas.transform);
            row.parentCanvasEnabled = parentCanvas.enabled;
            row.parentCanvasActiveInHierarchy = parentCanvas.gameObject.activeInHierarchy;
            row.parentCanvasRenderMode = parentCanvas.renderMode.ToString();
            row.parentCanvasScaleFactor = Float(parentCanvas.scaleFactor);
            row.parentCanvasReferencePixelsPerUnit = Float(parentCanvas.referencePixelsPerUnit);
            row.parentCanvasPlaneDistance = Float(parentCanvas.planeDistance);
            row.parentCanvasSortingLayerId = parentCanvas.sortingLayerID;
            row.parentCanvasSortingOrder = parentCanvas.sortingOrder;
            row.parentCanvasOverrideSorting = parentCanvas.overrideSorting;
            row.parentCanvasTargetDisplay = parentCanvas.targetDisplay;
            row.parentCanvasWorldCamera = parentCanvas.worldCamera != null ? parentCanvas.worldCamera.name : "";
            row.registryParentCount = RegistryCount(parentCanvas, graphic, out row.targetInParentRegistry);
        }
        if (graphicCanvas != null)
            row.registryGraphicCanvasCount = RegistryCount(graphicCanvas, graphic, out row.targetInGraphicCanvasRegistry);

        if (raycaster != null)
        {
            row.hasGraphicRaycaster = true;
            row.raycasterEnabled = raycaster.enabled;
            row.raycasterIgnoreReversedGraphics = raycaster.ignoreReversedGraphics;
            row.raycasterBlockingObjects = raycaster.blockingObjects.ToString();
            row.raycasterBlockingMask = raycaster.blockingMask.value;
            row.eventCameraName = eventCamera != null ? eventCamera.name : "(overlay/null)";
            row.eventCameraPixelRect = eventCamera != null ? RectString(eventCamera.pixelRect) : "";
            row.eventCameraTargetDisplay = eventCamera != null ? eventCamera.targetDisplay : 0;
            ProbeRaycaster(row, raycaster, eventSystem, button, eventCamera);
            if (phase == "before_open" && !BaselineScreenByButtonPath.ContainsKey(row.buttonScenePath))
                BaselineScreenByButtonPath[row.buttonScenePath] = row.screenCenter;
            if (BaselineScreenByButtonPath.ContainsKey(row.buttonScenePath))
            {
                row.baselineScreenCenter = BaselineScreenByButtonPath[row.buttonScenePath];
                ProbeRaycasterAt(row, raycaster, eventSystem, button, row.baselineScreenCenter, true);
            }
        }
        else
        {
            row.raycastReason = parentCanvas == null ? "missing_parent_canvas" : "missing_graphic_raycaster";
        }
        row.evidence = "BATTLE47 depth/raycast candidate registration probe; no fake onClick or fake overlay";
        return row;
    }

    private static int RegistryCount(Canvas canvas, Graphic graphic, out bool contains)
    {
        contains = false;
        if (canvas == null) return 0;
        try
        {
            var graphics = GraphicRegistry.GetGraphicsForCanvas(canvas);
            contains = graphics != null && graphics.Contains(graphic);
            return graphics != null ? graphics.Count : 0;
        }
        catch { return 0; }
    }

    private static void ProbeRaycaster(Row row, GraphicRaycaster raycaster, EventSystem eventSystem, Button button, Camera eventCamera)
    {
        ProbeRaycasterAt(row, raycaster, eventSystem, button, row.screenCenter, false);
    }

    private static void ProbeRaycasterAt(Row row, GraphicRaycaster raycaster, EventSystem eventSystem, Button button, string screenCenter, bool baseline)
    {
        if (eventSystem == null)
        {
            if (baseline) row.baselineRaycastReason = "missing_event_system";
            else row.raycastReason = "missing_event_system";
            return;
        }
        var data = new PointerEventData(eventSystem);
        data.position = ParseVec2(screenCenter);
        var hits = new List<RaycastResult>();
        raycaster.Raycast(data, hits);
        if (baseline) row.baselineHitCount = hits.Count;
        else row.hitCount = hits.Count;
        var hitPaths = new List<string>();
        bool ready = false;
        foreach (var hit in hits)
        {
            if (hit.gameObject == null) continue;
            if (hitPaths.Count < 8) hitPaths.Add(HierarchyPath(hit.gameObject.transform) + "#depth=" + hit.depth + "#dist=" + Float(hit.distance));
            if (hit.gameObject == button.targetGraphic.gameObject || hit.gameObject.transform.IsChildOf(button.transform)) ready = true;
        }
        string paths = string.Join(" | ", hitPaths.ToArray());
        string reason = ready ? "target_hit" : (hits.Count == 0 && row.targetDepth == -1 ? "no_hits_depth_minus_one" : (hits.Count == 0 ? "no_hits" : "target_not_in_hits"));
        if (baseline)
        {
            row.baselineHitPaths = paths;
            row.baselineRaycastReady = ready;
            row.baselineRaycastReason = reason;
        }
        else
        {
            row.hitPaths = paths;
            row.raycastReady = ready;
            row.raycastReason = reason;
        }
    }

    private static string BestPhase(List<Row> rows)
    {
        var counts = new Dictionary<string, int>();
        foreach (var row in rows)
        {
            if (!counts.ContainsKey(row.phase)) counts[row.phase] = 0;
            if (row.raycastReady) counts[row.phase]++;
        }
        string best = "";
        int bestCount = -1;
        foreach (var pair in counts)
        {
            if (pair.Value > bestCount) { best = pair.Key; bestCount = pair.Value; }
        }
        return best + ":" + bestCount;
    }

    private static void FillPhaseSummary(Result result, List<Row> rows, string phase, bool after)
    {
        int probe = 0, depthOk = 0, absOk = 0, registry = 0, ready = 0, baselineReady = 0, graphicRaycast = 0, rect = 0, hits = 0, baselineHits = 0;
        foreach (var row in rows)
        {
            if (row.phase != phase) continue;
            probe++;
            if (row.targetDepth >= 0) depthOk++;
            if (row.canvasRendererAbsoluteDepth >= 0) absOk++;
            if (row.targetInParentRegistry || row.targetInGraphicCanvasRegistry) registry++;
            if (row.raycastReady) ready++;
            if (row.baselineRaycastReady) baselineReady++;
            if (row.targetGraphicRaycast) graphicRaycast++;
            if (row.rectContains) rect++;
            if (row.hitCount > 0) hits++;
            if (row.baselineHitCount > 0) baselineHits++;
        }
        if (after)
        {
            result.afterProbeCount = probe; result.afterDepthNonNegativeCount = depthOk; result.afterAbsoluteDepthNonNegativeCount = absOk; result.afterRegistryIncludedCount = registry; result.afterRaycastReadyCount = ready; result.afterBaselineRaycastReadyCount = baselineReady; result.afterGraphicRaycastCount = graphicRaycast; result.afterRectContainsCount = rect; result.afterHitPositiveCount = hits; result.afterBaselineHitPositiveCount = baselineHits;
        }
        else
        {
            result.reopenProbeCount = probe; result.reopenDepthNonNegativeCount = depthOk; result.reopenAbsoluteDepthNonNegativeCount = absOk; result.reopenRegistryIncludedCount = registry; result.reopenRaycastReadyCount = ready; result.reopenBaselineRaycastReadyCount = baselineReady; result.reopenGraphicRaycastCount = graphicRaycast; result.reopenRectContainsCount = rect; result.reopenHitPositiveCount = hits; result.reopenBaselineHitPositiveCount = baselineHits;
        }
    }

    private static string DecidePatch(Result result, List<Row> rows)
    {
        if (result.reopenRaycastReadyCount > 0) return "force_dirty_rebuild_render_makes_original_targets_raycast_ready_after_reopen";
        if (result.reopenBaselineRaycastReadyCount > 0) return "depth_restored_and_baseline_screen_coordinates_hit_original_targets_after_reopen";
        if (result.afterRaycastReadyCount > 0) return "force_dirty_rebuild_render_improves_before_save_but_not_reopen";
        if (result.afterBaselineRaycastReadyCount > 0) return "depth_restored_and_baseline_screen_coordinates_hit_before_save_only";
        if (result.reopenDepthNonNegativeCount == 0 && result.reopenProbeCount > 0) return "force_update_rebuild_render_does_not_restore_graphic_depth_in_batchmode";
        if (result.reopenDepthNonNegativeCount > 0 && result.reopenRaycastReadyCount == 0) return "depth_restored_but_raycast_still_blocked_by_sort_display_or_hit_order";
        return "trace_only_no_safe_patch";
    }

    private static bool SafeGraphicRaycast(Graphic graphic, Camera camera, out string error)
    {
        error = "";
        if (graphic == null) return false;
        try
        {
            var rect = graphic.transform as RectTransform;
            if (rect == null) return false;
            var center = RectTransformUtility.WorldToScreenPoint(camera, rect.TransformPoint(rect.rect.center));
            return graphic.Raycast(center, camera);
        }
        catch (Exception ex)
        {
            error = ex.GetType().Name + ":" + ex.Message;
            return false;
        }
    }

    private static void Snapshot(Result result, string phase)
    {
        var counts = new Counts();
        counts.canvas = UnityEngine.Object.FindObjectsOfType<Canvas>(true).Length;
        counts.graphicRaycaster = UnityEngine.Object.FindObjectsOfType<GraphicRaycaster>(true).Length;
        counts.image = UnityEngine.Object.FindObjectsOfType<Image>(true).Length;
        counts.graphic = UnityEngine.Object.FindObjectsOfType<Graphic>(true).Length;
        counts.activeGraphic = CountActiveGraphics();
        counts.button = UnityEngine.Object.FindObjectsOfType<Button>(true).Length;
        counts.empty4Raycast = UnityEngine.Object.FindObjectsOfType<Empty4Raycast>(true).Length;
        counts.mask = UnityEngine.Object.FindObjectsOfType<Mask>(true).Length;
        counts.rectMask2D = UnityEngine.Object.FindObjectsOfType<RectMask2D>(true).Length;
        counts.text = UnityEngine.Object.FindObjectsOfType<Text>(true).Length;
        counts.tmp = UnityEngine.Object.FindObjectsOfType<TMP_Text>(true).Length;
        counts.missingScript = CountMissingScripts();
        if (phase == "before") result.before = counts;
        else if (phase == "reopenBefore") result.reopenBefore = counts;
        else result.reopenAfter = counts;
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

    private static void ConfigureCamera(Camera camera)
    {
        camera.gameObject.SetActive(true);
        camera.enabled = true;
        camera.clearFlags = CameraClearFlags.SolidColor;
        camera.backgroundColor = Color.black;
        camera.orthographic = true;
        if (camera.orthographicSize < 1f) camera.orthographicSize = 540f;
        camera.targetTexture = null;
        ResetCameraProjection(camera);
    }

    private static void ResetCameraProjection(Camera camera)
    {
        if (camera == null) return;
        camera.targetTexture = null;
        camera.ResetAspect();
        camera.ResetProjectionMatrix();
        camera.ResetWorldToCameraMatrix();
    }

    private static void Capture(Camera camera, string path)
    {
        if (camera == null) return;
        Directory.CreateDirectory(Path.GetDirectoryName(path));
        var texture = RenderCamera(camera, path);
        if (texture != null) UnityEngine.Object.DestroyImmediate(texture);
    }

    private static Texture2D RenderCamera(Camera camera, string optionalPath)
    {
        if (camera == null) return null;
        var rt = new RenderTexture(CaptureWidth, CaptureHeight, 24, RenderTextureFormat.ARGB32);
        var previousTarget = camera.targetTexture;
        var previousActive = RenderTexture.active;
        camera.targetTexture = rt;
        RenderTexture.active = rt;
        camera.Render();
        var texture = new Texture2D(CaptureWidth, CaptureHeight, TextureFormat.RGB24, false);
        texture.ReadPixels(new Rect(0, 0, CaptureWidth, CaptureHeight), 0, 0);
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

    private static int AbsoluteDepth(CanvasRenderer renderer)
    {
        if (renderer == null) return -999999;
        var prop = typeof(CanvasRenderer).GetProperty("absoluteDepth", BindingFlags.Instance | BindingFlags.Public);
        if (prop == null) return -999998;
        try { return Convert.ToInt32(prop.GetValue(renderer, null)); } catch { return -999997; }
    }

    private static bool CullTransparentMesh(CanvasRenderer renderer)
    {
        if (renderer == null) return false;
        var prop = typeof(CanvasRenderer).GetProperty("cullTransparentMesh", BindingFlags.Instance | BindingFlags.Public);
        if (prop == null) return false;
        try { return Convert.ToBoolean(prop.GetValue(renderer, null)); } catch { return false; }
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
        sb.AppendLine("phase,buttonScenePath,buttonName,targetScenePath,targetName,targetType,hasButton,buttonInteractable,buttonActiveSelf,buttonActiveInHierarchy,targetActiveSelf,targetActiveInHierarchy,targetEnabled,targetRaycastTarget,targetLayer,targetDepth,canvasRendererExists,canvasRendererAbsoluteDepth,canvasRendererCull,canvasRendererCullTransparentMesh,canvasRendererAlpha,targetGraphicRaycast,graphicRaycastError,targetMaterialName,targetMaterialForRenderingName,targetRectSize,targetAnchoredPosition,worldCenter,screenCenter,baselineScreenCenter,rectContains,graphicCanvasPath,parentCanvasPath,parentCanvasEnabled,parentCanvasActiveInHierarchy,parentCanvasRenderMode,parentCanvasScaleFactor,parentCanvasReferencePixelsPerUnit,parentCanvasPlaneDistance,parentCanvasSortingLayerId,parentCanvasSortingOrder,parentCanvasOverrideSorting,parentCanvasTargetDisplay,parentCanvasWorldCamera,registryParentCount,targetInParentRegistry,registryGraphicCanvasCount,targetInGraphicCanvasRegistry,hasGraphicRaycaster,raycasterEnabled,raycasterIgnoreReversedGraphics,raycasterBlockingObjects,raycasterBlockingMask,eventCameraName,eventCameraPixelRect,eventCameraTargetDisplay,hitCount,hitPaths,raycastReady,raycastReason,baselineHitCount,baselineHitPaths,baselineRaycastReady,baselineRaycastReason,evidence");
        foreach (var r in rows)
        {
            sb.AppendLine(string.Join(",", new[]
            {
                Csv(r.phase), Csv(r.buttonScenePath), Csv(r.buttonName), Csv(r.targetScenePath), Csv(r.targetName), Csv(r.targetType), Bool(r.hasButton), Bool(r.buttonInteractable), Bool(r.buttonActiveSelf), Bool(r.buttonActiveInHierarchy), Bool(r.targetActiveSelf), Bool(r.targetActiveInHierarchy), Bool(r.targetEnabled), Bool(r.targetRaycastTarget), r.targetLayer.ToString(), r.targetDepth.ToString(),
                Bool(r.canvasRendererExists), r.canvasRendererAbsoluteDepth.ToString(), Bool(r.canvasRendererCull), Bool(r.canvasRendererCullTransparentMesh), Csv(r.canvasRendererAlpha), Bool(r.targetGraphicRaycast), Csv(r.graphicRaycastError), Csv(r.targetMaterialName), Csv(r.targetMaterialForRenderingName), Csv(r.targetRectSize), Csv(r.targetAnchoredPosition), Csv(r.worldCenter), Csv(r.screenCenter), Csv(r.baselineScreenCenter), Bool(r.rectContains),
                Csv(r.graphicCanvasPath), Csv(r.parentCanvasPath), Bool(r.parentCanvasEnabled), Bool(r.parentCanvasActiveInHierarchy), Csv(r.parentCanvasRenderMode), Csv(r.parentCanvasScaleFactor), Csv(r.parentCanvasReferencePixelsPerUnit), Csv(r.parentCanvasPlaneDistance), r.parentCanvasSortingLayerId.ToString(), r.parentCanvasSortingOrder.ToString(), Bool(r.parentCanvasOverrideSorting), r.parentCanvasTargetDisplay.ToString(), Csv(r.parentCanvasWorldCamera),
                r.registryParentCount.ToString(), Bool(r.targetInParentRegistry), r.registryGraphicCanvasCount.ToString(), Bool(r.targetInGraphicCanvasRegistry), Bool(r.hasGraphicRaycaster), Bool(r.raycasterEnabled), Bool(r.raycasterIgnoreReversedGraphics), Csv(r.raycasterBlockingObjects), r.raycasterBlockingMask.ToString(), Csv(r.eventCameraName), Csv(r.eventCameraPixelRect), r.eventCameraTargetDisplay.ToString(), r.hitCount.ToString(), Csv(r.hitPaths), Bool(r.raycastReady), Csv(r.raycastReason), r.baselineHitCount.ToString(), Csv(r.baselineHitPaths), Bool(r.baselineRaycastReady), Csv(r.baselineRaycastReason), Csv(r.evidence)
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
        sb.AppendLine("  \"before\": " + CountsJson(r.before) + ",");
        sb.AppendLine("  \"reopenBefore\": " + CountsJson(r.reopenBefore) + ",");
        sb.AppendLine("  \"reopenAfter\": " + CountsJson(r.reopenAfter) + ",");
        sb.AppendLine("  \"bestAfterPhase\": \"" + Json(r.bestAfterPhase) + "\",");
        sb.AppendLine("  \"afterProbeCount\": " + r.afterProbeCount + ",");
        sb.AppendLine("  \"afterDepthNonNegativeCount\": " + r.afterDepthNonNegativeCount + ",");
        sb.AppendLine("  \"afterAbsoluteDepthNonNegativeCount\": " + r.afterAbsoluteDepthNonNegativeCount + ",");
        sb.AppendLine("  \"afterRegistryIncludedCount\": " + r.afterRegistryIncludedCount + ",");
        sb.AppendLine("  \"afterGraphicRaycastCount\": " + r.afterGraphicRaycastCount + ",");
        sb.AppendLine("  \"afterRectContainsCount\": " + r.afterRectContainsCount + ",");
        sb.AppendLine("  \"afterHitPositiveCount\": " + r.afterHitPositiveCount + ",");
        sb.AppendLine("  \"afterBaselineHitPositiveCount\": " + r.afterBaselineHitPositiveCount + ",");
        sb.AppendLine("  \"afterRaycastReadyCount\": " + r.afterRaycastReadyCount + ",");
        sb.AppendLine("  \"afterBaselineRaycastReadyCount\": " + r.afterBaselineRaycastReadyCount + ",");
        sb.AppendLine("  \"reopenProbeCount\": " + r.reopenProbeCount + ",");
        sb.AppendLine("  \"reopenDepthNonNegativeCount\": " + r.reopenDepthNonNegativeCount + ",");
        sb.AppendLine("  \"reopenAbsoluteDepthNonNegativeCount\": " + r.reopenAbsoluteDepthNonNegativeCount + ",");
        sb.AppendLine("  \"reopenRegistryIncludedCount\": " + r.reopenRegistryIncludedCount + ",");
        sb.AppendLine("  \"reopenGraphicRaycastCount\": " + r.reopenGraphicRaycastCount + ",");
        sb.AppendLine("  \"reopenRectContainsCount\": " + r.reopenRectContainsCount + ",");
        sb.AppendLine("  \"reopenHitPositiveCount\": " + r.reopenHitPositiveCount + ",");
        sb.AppendLine("  \"reopenBaselineHitPositiveCount\": " + r.reopenBaselineHitPositiveCount + ",");
        sb.AppendLine("  \"reopenRaycastReadyCount\": " + r.reopenRaycastReadyCount + ",");
        sb.AppendLine("  \"reopenBaselineRaycastReadyCount\": " + r.reopenBaselineRaycastReadyCount + ",");
        sb.AppendLine("  \"patchDecision\": \"" + Json(r.patchDecision) + "\",");
        sb.AppendLine("  \"failReason\": \"" + Json(r.failReason) + "\"");
        sb.AppendLine("}");
        File.WriteAllText(path, sb.ToString(), new UTF8Encoding(false));
    }

    private static string CountsJson(Counts c)
    {
        if (c == null) return "{}";
        return "{\"canvas\":" + c.canvas + ",\"graphicRaycaster\":" + c.graphicRaycaster + ",\"image\":" + c.image + ",\"graphic\":" + c.graphic + ",\"activeGraphic\":" + c.activeGraphic + ",\"button\":" + c.button + ",\"empty4Raycast\":" + c.empty4Raycast + ",\"mask\":" + c.mask + ",\"rectMask2D\":" + c.rectMask2D + ",\"text\":" + c.text + ",\"tmp\":" + c.tmp + ",\"missingScript\":" + c.missingScript + "}";
    }

    private static string HierarchyPath(Transform transform) { var names = new List<string>(); var cursor = transform; while (cursor != null) { names.Add(cursor.name); cursor = cursor.parent; } names.Reverse(); return string.Join("/", names.ToArray()); }
    private static string ProjectPath(string assetPath) { return Path.Combine(Application.dataPath, "..", assetPath.Replace("/", "\\")); }
    private static string Float(float value) { return value.ToString("0.###", System.Globalization.CultureInfo.InvariantCulture); }
    private static string Vec2(Vector2 v) { return Float(v.x) + "/" + Float(v.y); }
    private static string Vec3(Vector3 v) { return Float(v.x) + "/" + Float(v.y) + "/" + Float(v.z); }
    private static string RectString(Rect r) { return Float(r.x) + "/" + Float(r.y) + "/" + Float(r.width) + "/" + Float(r.height); }
    private static Vector2 ParseVec2(string value)
    {
        var parts = (value ?? "0/0").Split('/');
        float x = 0f, y = 0f;
        if (parts.Length > 0) float.TryParse(parts[0], System.Globalization.NumberStyles.Float, System.Globalization.CultureInfo.InvariantCulture, out x);
        if (parts.Length > 1) float.TryParse(parts[1], System.Globalization.NumberStyles.Float, System.Globalization.CultureInfo.InvariantCulture, out y);
        return new Vector2(x, y);
    }
    private static string Bool(bool value) { return value ? "true" : "false"; }
    private static string Json(string value) { return (value ?? "").Replace("\\", "\\\\").Replace("\"", "\\\"").Replace("\r", " ").Replace("\n", " "); }
    private static string Csv(string value) { return "\"" + (value ?? "").Replace("\"", "\"\"") + "\""; }

    private sealed class Counts
    {
        public int canvas, graphicRaycaster, image, graphic, activeGraphic, button, empty4Raycast, mask, rectMask2D, text, tmp, missingScript;
    }

    private sealed class Result
    {
        public string status = "", sourceScene = "", scene = "", capture = "", failReason = "", bestAfterPhase = "", patchDecision = "";
        public bool isFinalRestoredBattleScreen, sourceSceneOpened, sceneSaved, captureExists, reopenValid;
        public Counts before = new Counts();
        public Counts reopenBefore = new Counts();
        public Counts reopenAfter = new Counts();
        public int afterProbeCount, afterDepthNonNegativeCount, afterAbsoluteDepthNonNegativeCount, afterRegistryIncludedCount, afterGraphicRaycastCount, afterRectContainsCount, afterHitPositiveCount, afterBaselineHitPositiveCount, afterRaycastReadyCount, afterBaselineRaycastReadyCount;
        public int reopenProbeCount, reopenDepthNonNegativeCount, reopenAbsoluteDepthNonNegativeCount, reopenRegistryIncludedCount, reopenGraphicRaycastCount, reopenRectContainsCount, reopenHitPositiveCount, reopenBaselineHitPositiveCount, reopenRaycastReadyCount, reopenBaselineRaycastReadyCount;
    }

    private sealed class Row
    {
        public string phase = "", buttonScenePath = "", buttonName = "", targetScenePath = "", targetName = "", targetType = "", graphicRaycastError = "", targetMaterialName = "", targetMaterialForRenderingName = "", targetRectSize = "", targetAnchoredPosition = "", worldCenter = "", screenCenter = "";
        public string graphicCanvasPath = "", parentCanvasPath = "", parentCanvasRenderMode = "", parentCanvasScaleFactor = "", parentCanvasReferencePixelsPerUnit = "", parentCanvasPlaneDistance = "", parentCanvasWorldCamera = "";
        public string raycasterBlockingObjects = "", eventCameraName = "", eventCameraPixelRect = "", hitPaths = "", raycastReason = "", baselineScreenCenter = "", baselineHitPaths = "", baselineRaycastReason = "", evidence = "", canvasRendererAlpha = "";
        public bool hasButton, buttonInteractable, buttonActiveSelf, buttonActiveInHierarchy, targetActiveSelf, targetActiveInHierarchy, targetEnabled, targetRaycastTarget, canvasRendererExists, canvasRendererCull, canvasRendererCullTransparentMesh, targetGraphicRaycast, rectContains;
        public bool parentCanvasEnabled, parentCanvasActiveInHierarchy, parentCanvasOverrideSorting, targetInParentRegistry, targetInGraphicCanvasRegistry, hasGraphicRaycaster, raycasterEnabled, raycasterIgnoreReversedGraphics, raycastReady, baselineRaycastReady;
        public int targetLayer, targetDepth, canvasRendererAbsoluteDepth, parentCanvasSortingLayerId, parentCanvasSortingOrder, parentCanvasTargetDisplay, registryParentCount, registryGraphicCanvasCount, raycasterBlockingMask, eventCameraTargetDisplay, hitCount, baselineHitCount;
    }
}
