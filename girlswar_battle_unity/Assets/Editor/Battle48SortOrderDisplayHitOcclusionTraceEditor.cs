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

public static class Battle48TraceSortOrderDisplayAndHitOcclusionAfterDepthRebuildEditor
{
    private const string SourceScenePath = "Assets/Scenes/Battle47GraphicDepthRaycastCandidateRegistration.unity";
    private const string ScenePath = "Assets/Scenes/Battle48SortOrderDisplayHitOcclusionTrace.unity";
    private const string ResultJsonPath = "Assets/RestoreData/battle/BATTLE_48_TRACE_SORT_ORDER_DISPLAY_AND_HIT_OCCLUSION_AFTER_DEPTH_REBUILD_UNITY.json";
    private const string SummaryCsvPath = "Assets/RestoreData/battle/BATTLE_48_TRACE_SORT_ORDER_DISPLAY_AND_HIT_OCCLUSION_AFTER_DEPTH_REBUILD_TARGET_POINTS.csv";
    private const string DetailCsvPath = "Assets/RestoreData/battle/BATTLE_48_TRACE_SORT_ORDER_DISPLAY_AND_HIT_OCCLUSION_AFTER_DEPTH_REBUILD_REGISTERED_GRAPHICS.csv";
    private const string B47RowsCsvPath = "Assets/RestoreData/battle/BATTLE_47_FIX_GRAPHIC_DEPTH_AND_RAYCAST_CANDIDATE_REGISTRATION_COMPONENTS.csv";
    private const string CapturePath = "Assets/RestoreCaptures/battle_actor/Battle48SortOrderDisplayHitOcclusionTrace_1920x1080.png";
    private const int CaptureWidth = 1920;
    private const int CaptureHeight = 1080;

    [MenuItem("GirlsWar/Battle/BATTLE48 Trace Sort Display Hit Occlusion")]
    public static void Build()
    {
        Directory.CreateDirectory(ProjectPath("Assets/RestoreData/battle"));
        Directory.CreateDirectory(ProjectPath("Assets/RestoreCaptures/battle_actor"));

        var result = new Result();
        var summary = new List<SummaryRow>();
        var details = new List<DetailRow>();
        result.status = "battle48_trace_sort_order_display_and_hit_occlusion_after_depth_rebuild";
        result.isFinalRestoredBattleScreen = false;
        result.sourceScene = SourceScenePath;
        result.scene = ScenePath;
        result.capture = CapturePath;

        if (!File.Exists(ProjectPath(SourceScenePath)))
        {
            result.failReason = "source_scene_file_not_found";
            WriteOutputs(result, summary, details);
            return;
        }

        var baseline = LoadBaselineScreens(ProjectPath(B47RowsCsvPath));
        var scene = EditorSceneManager.OpenScene(SourceScenePath, OpenSceneMode.Single);
        result.sourceSceneOpened = scene.IsValid();
        var camera = FindCaptureCamera();
        if (camera != null) ConfigureCamera(camera);
        PrepareDepth(camera);

        Probe(summary, details, baseline, camera, "after_depth_rebuild_render");
        ApplyPixelRectPatchIfSupported(summary, result, camera);
        if (result.patchApplied)
        {
            PrepareDepth(camera);
            Probe(summary, details, baseline, camera, "after_pixelrect_patch_depth_rebuild_render");
        }

        EditorSceneManager.SaveScene(scene, ScenePath);
        result.sceneSaved = File.Exists(ProjectPath(ScenePath));
        Capture(camera, ProjectPath(CapturePath));
        result.captureExists = File.Exists(ProjectPath(CapturePath));

        var reopened = EditorSceneManager.OpenScene(ScenePath, OpenSceneMode.Single);
        result.reopenValid = reopened.IsValid();
        camera = FindCaptureCamera();
        if (camera != null) ConfigureCamera(camera);
        PrepareDepth(camera);
        Probe(summary, details, baseline, camera, "reopen_after_depth_rebuild_render");
        Summarize(result, summary, details, "reopen_after_depth_rebuild_render");

        WriteOutputs(result, summary, details);
        AssetDatabase.Refresh();
        Debug.Log("BATTLE48 sort/display/hit trace complete. bestReady=" + result.bestRaycastReadyCount + ", patch=" + result.patchDecision);
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

    private static void ApplyPixelRectPatchIfSupported(List<SummaryRow> rows, Result result, Camera camera)
    {
        result.patchDecision = "trace_only_no_patch";
        if (camera == null) return;
        int pixelRectRejected = 0;
        int mirrorCandidateInsidePixelRect = 0;
        foreach (var row in rows)
        {
            if (row.phase != "after_depth_rebuild_render") continue;
            if (!row.pixelRectContains) pixelRectRejected++;
            if (row.pixelRectContains && row.mirrorTargetFinalCandidate) mirrorCandidateInsidePixelRect++;
        }
        result.prePatchPixelRectRejectedCount = pixelRectRejected;
        result.prePatchMirrorTargetCandidateCount = mirrorCandidateInsidePixelRect;
        if (pixelRectRejected > 0 && mirrorCandidateInsidePixelRect == 0)
        {
            result.patchDecision = "pixelrect_rejection_present_but_no_safe_camera_patch_applied";
        }
    }

    private static void Probe(List<SummaryRow> summary, List<DetailRow> details, Dictionary<string, string> baseline, Camera camera, string phase)
    {
        var eventSystem = UnityEngine.Object.FindObjectOfType<EventSystem>(true);
        foreach (var button in UnityEngine.Object.FindObjectsOfType<Button>(true))
        {
            if (button == null || button.targetGraphic == null) continue;
            var canvas = button.GetComponentInParent<Canvas>(true);
            var raycaster = canvas != null ? canvas.GetComponent<GraphicRaycaster>() : null;
            if (canvas == null || raycaster == null) continue;
            var eventCamera = canvas.renderMode == RenderMode.ScreenSpaceOverlay ? null : raycaster.eventCamera;
            if (eventCamera == null && canvas.renderMode != RenderMode.ScreenSpaceOverlay) eventCamera = canvas.worldCamera != null ? canvas.worldCamera : camera;
            var rect = button.targetGraphic.transform as RectTransform;
            if (rect == null) continue;
            var centerWorld = rect.TransformPoint(rect.rect.center);
            var current = RectTransformUtility.WorldToScreenPoint(eventCamera, centerWorld);
            var viewport = eventCamera != null ? eventCamera.WorldToViewportPoint(centerWorld) : new Vector3(current.x / Screen.width, current.y / Screen.height, 0f);
            var pixelRect = eventCamera != null ? eventCamera.pixelRect : new Rect(0, 0, Screen.width, Screen.height);
            var pixelRectViewport = new Vector2(pixelRect.x + viewport.x * pixelRect.width, pixelRect.y + viewport.y * pixelRect.height);
            string path = HierarchyPath(button.transform);
            string baselineValue = baseline.ContainsKey(path) ? baseline[path] : Vec2(current);

            var candidates = new List<PointCandidate>();
            candidates.Add(new PointCandidate("eventCamera_worldToScreen", current));
            candidates.Add(new PointCandidate("b47_before_open_baseline", ParseVec2(baselineValue)));
            candidates.Add(new PointCandidate("viewport_pixelRect", pixelRectViewport));
            candidates.Add(new PointCandidate("capture1920_scaled_to_camera640", new Vector2(current.x * 640f / 1920f, current.y * 480f / 1080f)));
            candidates.Add(new PointCandidate("camera640_scaled_to_capture1920", new Vector2(current.x * 1920f / 640f, current.y * 1080f / 480f)));
            candidates.Add(new PointCandidate("baseline_capture_scaled_to_camera640", new Vector2(ParseVec2(baselineValue).x * 640f / 1920f, ParseVec2(baselineValue).y * 480f / 1080f)));

            foreach (var candidate in candidates)
                ProbePoint(summary, details, phase, button, raycaster, eventSystem, eventCamera, canvas, candidate);
        }
    }

    private static void ProbePoint(List<SummaryRow> summary, List<DetailRow> details, string phase, Button button, GraphicRaycaster raycaster, EventSystem eventSystem, Camera eventCamera, Canvas canvas, PointCandidate candidate)
    {
        var target = button.targetGraphic;
        var graphics = GraphicRegistry.GetGraphicsForCanvas(canvas);
        var s = new SummaryRow();
        s.phase = phase;
        s.pointName = candidate.name;
        s.buttonName = button.name;
        s.buttonScenePath = HierarchyPath(button.transform);
        s.targetScenePath = HierarchyPath(target.transform);
        s.pointerPosition = Vec2(candidate.position);
        s.canvasPath = HierarchyPath(canvas.transform);
        s.canvasRenderMode = canvas.renderMode.ToString();
        s.canvasSortingOrder = canvas.sortingOrder;
        s.canvasTargetDisplay = canvas.targetDisplay;
        s.raycasterIgnoreReversedGraphics = raycaster.ignoreReversedGraphics;
        s.raycasterBlockingObjects = raycaster.blockingObjects.ToString();
        s.eventCameraName = eventCamera != null ? eventCamera.name : "(overlay/null)";
        s.eventCameraPixelRect = eventCamera != null ? RectString(eventCamera.pixelRect) : "";
        s.eventCameraTargetDisplay = eventCamera != null ? eventCamera.targetDisplay : 0;
        s.pixelRectContains = eventCamera == null || eventCamera.pixelRect.Contains(candidate.position);
        var displayRelative = Display.RelativeMouseAt(candidate.position);
        s.displayRelative = Vec3(displayRelative);
        s.displayRelativeNonZero = displayRelative != Vector3.zero;
        s.displayMatches = !s.displayRelativeNonZero || Mathf.RoundToInt(displayRelative.z) == s.canvasTargetDisplay;
        s.registryCount = graphics != null ? graphics.Count : 0;
        s.targetDepth = target.depth;
        s.targetAbsoluteDepth = AbsoluteDepth(target.GetComponent<CanvasRenderer>());

        var data = new PointerEventData(eventSystem);
        data.position = candidate.position;
        var hits = new List<RaycastResult>();
        raycaster.Raycast(data, hits);
        s.unityHitCount = hits.Count;
        foreach (var hit in hits)
        {
            if (hit.gameObject == null) continue;
            if (s.unityHitPaths.Length < 500)
                s.unityHitPaths += (s.unityHitPaths.Length == 0 ? "" : " | ") + HierarchyPath(hit.gameObject.transform) + "#depth=" + hit.depth;
            if (hit.gameObject == target.gameObject || hit.gameObject.transform.IsChildOf(button.transform)) s.unityTargetHit = true;
        }

        int mirrorFinal = 0;
        int mirrorTargetFinal = 0;
        var finalPaths = new List<string>();
        if (graphics != null)
        {
            for (int i = 0; i < graphics.Count; i++)
            {
                var graphic = graphics[i];
                var detail = MirrorGraphic(phase, candidate, button, target, raycaster, eventCamera, canvas, graphic, s.pixelRectContains, s.displayMatches);
                details.Add(detail);
                if (detail.finalCandidate)
                {
                    mirrorFinal++;
                    if (finalPaths.Count < 8) finalPaths.Add(detail.graphicScenePath + "#depth=" + detail.graphicDepth);
                    if (graphic == target) mirrorTargetFinal++;
                }
            }
        }
        s.mirrorFinalCandidateCount = mirrorFinal;
        s.mirrorTargetFinalCandidate = mirrorTargetFinal > 0;
        s.mirrorFinalPaths = string.Join(" | ", finalPaths.ToArray());
        s.raycastReady = s.unityTargetHit;
        s.primaryFailure = DeterminePrimaryFailure(s);
        summary.Add(s);
    }

    private static DetailRow MirrorGraphic(string phase, PointCandidate candidate, Button button, Graphic target, GraphicRaycaster raycaster, Camera eventCamera, Canvas canvas, Graphic graphic, bool pixelRectContains, bool displayMatches)
    {
        var d = new DetailRow();
        d.phase = phase;
        d.pointName = candidate.name;
        d.buttonName = button.name;
        d.buttonScenePath = HierarchyPath(button.transform);
        d.targetScenePath = HierarchyPath(target.transform);
        d.pointerPosition = Vec2(candidate.position);
        d.graphicScenePath = HierarchyPath(graphic.transform);
        d.graphicName = graphic.name;
        d.graphicType = graphic.GetType().FullName;
        d.isTargetGraphic = graphic == target;
        d.graphicDepth = graphic.depth;
        d.absoluteDepth = AbsoluteDepth(graphic.GetComponent<CanvasRenderer>());
        d.raycastTarget = graphic.raycastTarget;
        d.activeInHierarchy = graphic.gameObject.activeInHierarchy;
        d.enabled = graphic.enabled;
        d.canvasRendererCull = graphic.canvasRenderer != null && graphic.canvasRenderer.cull;
        d.cullTransparentMesh = CullTransparentMesh(graphic.canvasRenderer);
        d.materialName = graphic.material != null ? graphic.material.name : "";
        d.pixelRectContains = pixelRectContains;
        d.displayMatches = displayMatches;
        var rect = graphic.transform as RectTransform;
        d.rectContains = rect != null && RectTransformUtility.RectangleContainsScreenPoint(rect, candidate.position, eventCamera);
        d.graphicRaycast = false;
        try { d.graphicRaycast = graphic.Raycast(candidate.position, eventCamera); }
        catch (Exception ex) { d.graphicRaycastError = ex.GetType().Name + ":" + ex.Message; }
        d.reversedDot = ReversedDot(graphic, eventCamera);
        d.reversedPass = !raycaster.ignoreReversedGraphics || d.reversedDot > 0f;
        d.canvasGroupPass = CanvasGroupAllows(graphic.transform, out d.canvasGroupSummary);

        if (!pixelRectContains) d.rejectionReason = "event_camera_pixelrect_reject";
        else if (!displayMatches) d.rejectionReason = "display_mismatch";
        else if (d.graphicDepth == -1) d.rejectionReason = "depth_minus_one";
        else if (!d.raycastTarget) d.rejectionReason = "raycastTarget_false";
        else if (!d.activeInHierarchy) d.rejectionReason = "inactive";
        else if (!d.enabled) d.rejectionReason = "graphic_disabled";
        else if (d.canvasRendererCull) d.rejectionReason = "canvas_renderer_cull";
        else if (!d.rectContains) d.rejectionReason = "rect_not_contains";
        else if (!d.graphicRaycast) d.rejectionReason = "graphic_raycast_false";
        else if (!d.reversedPass) d.rejectionReason = "reversed_graphic";
        else if (!d.canvasGroupPass) d.rejectionReason = "canvas_group_or_filter_false";
        else { d.rejectionReason = "final_candidate"; d.finalCandidate = true; }
        return d;
    }

    private static string DeterminePrimaryFailure(SummaryRow s)
    {
        if (s.unityTargetHit) return "target_hit";
        if (!s.pixelRectContains) return "event_camera_pixelrect_reject";
        if (!s.displayMatches) return "display_mismatch";
        if (s.mirrorTargetFinalCandidate && s.unityHitCount == 0) return "mirror_target_candidate_but_unity_empty";
        if (s.mirrorFinalCandidateCount > 0 && s.unityHitCount == 0) return "mirror_candidates_but_unity_empty";
        if (s.mirrorTargetFinalCandidate && !s.unityTargetHit) return "target_candidate_but_not_unity_hit";
        if (s.mirrorFinalCandidateCount == 0) return "no_mirror_candidates";
        return "target_not_in_hits";
    }

    private static void Summarize(Result result, List<SummaryRow> summary, List<DetailRow> details, string phase)
    {
        result.summaryRowCount = summary.Count;
        result.detailRowCount = details.Count;
        var reasonCounts = new Dictionary<string, int>();
        var pointCounts = new Dictionary<string, int>();
        foreach (var row in summary)
        {
            if (row.phase != phase) continue;
            result.reopenSummaryCount++;
            if (row.targetDepth >= 0) result.reopenDepthNonNegativeCount++;
            if (row.targetAbsoluteDepth >= 0) result.reopenAbsoluteDepthNonNegativeCount++;
            if (row.pixelRectContains) result.reopenPixelRectContainsCount++;
            if (row.mirrorTargetFinalCandidate) result.reopenMirrorTargetCandidateCount++;
            if (row.mirrorFinalCandidateCount > 0) result.reopenMirrorAnyCandidateCount++;
            if (row.unityHitCount > 0) result.reopenUnityHitPositiveCount++;
            if (row.unityTargetHit) result.reopenRaycastReadyCount++;
            if (!reasonCounts.ContainsKey(row.primaryFailure)) reasonCounts[row.primaryFailure] = 0;
            reasonCounts[row.primaryFailure]++;
            if (!pointCounts.ContainsKey(row.pointName)) pointCounts[row.pointName] = 0;
            if (row.unityTargetHit) pointCounts[row.pointName]++;
        }
        result.primaryFailureSummary = DictString(reasonCounts);
        result.readyByPointSummary = DictString(pointCounts);
        result.bestRaycastReadyCount = result.reopenRaycastReadyCount;
        result.patchDecision = result.reopenRaycastReadyCount > 0 ? "candidate_point_hits_without_fake_overlay_validate_input_next" : "trace_only_sort_display_or_internal_raycaster_mismatch_remains";
    }

    private static Dictionary<string, string> LoadBaselineScreens(string path)
    {
        var map = new Dictionary<string, string>();
        if (!File.Exists(path)) return map;
        var lines = File.ReadAllLines(path, new UTF8Encoding(true));
        if (lines.Length < 2) return map;
        var headers = SplitCsvLine(lines[0]);
        int phaseIx = headers.IndexOf("phase");
        int pathIx = headers.IndexOf("buttonScenePath");
        int screenIx = headers.IndexOf("screenCenter");
        for (int i = 1; i < lines.Length; i++)
        {
            var values = SplitCsvLine(lines[i]);
            if (values.Count <= Math.Max(phaseIx, Math.Max(pathIx, screenIx))) continue;
            if (values[phaseIx] == "before_open" && !map.ContainsKey(values[pathIx])) map[values[pathIx]] = values[screenIx];
        }
        return map;
    }

    private static bool CanvasGroupAllows(Transform transform, out string summary)
    {
        summary = "";
        var parts = new List<string>();
        var cursor = transform;
        bool allowed = true;
        while (cursor != null)
        {
            foreach (var group in cursor.GetComponents<CanvasGroup>())
            {
                if (group == null) continue;
                parts.Add(HierarchyPath(cursor) + "(blocks=" + group.blocksRaycasts + ";interactable=" + group.interactable + ";ignoreParent=" + group.ignoreParentGroups + ")");
                if (!group.blocksRaycasts) allowed = false;
                if (group.ignoreParentGroups) { summary = string.Join(" | ", parts.ToArray()); return allowed; }
            }
            cursor = cursor.parent;
        }
        summary = string.Join(" | ", parts.ToArray());
        return allowed;
    }

    private static float ReversedDot(Graphic graphic, Camera eventCamera)
    {
        if (graphic == null) return 0f;
        var dir = eventCamera != null ? eventCamera.transform.rotation * Vector3.forward : Vector3.forward;
        return Vector3.Dot(graphic.transform.rotation * Vector3.forward, dir);
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

    private static void WriteOutputs(Result result, List<SummaryRow> summary, List<DetailRow> details)
    {
        WriteSummaryCsv(ProjectPath(SummaryCsvPath), summary);
        WriteDetailCsv(ProjectPath(DetailCsvPath), details);
        WriteJson(ProjectPath(ResultJsonPath), result);
    }

    private static void WriteSummaryCsv(string path, List<SummaryRow> rows)
    {
        Directory.CreateDirectory(Path.GetDirectoryName(path));
        var sb = new StringBuilder();
        sb.AppendLine("phase,pointName,buttonName,buttonScenePath,targetScenePath,pointerPosition,canvasPath,canvasRenderMode,canvasSortingOrder,canvasTargetDisplay,raycasterIgnoreReversedGraphics,raycasterBlockingObjects,eventCameraName,eventCameraPixelRect,eventCameraTargetDisplay,pixelRectContains,displayRelative,displayRelativeNonZero,displayMatches,registryCount,targetDepth,targetAbsoluteDepth,mirrorFinalCandidateCount,mirrorTargetFinalCandidate,mirrorFinalPaths,unityHitCount,unityTargetHit,unityHitPaths,raycastReady,primaryFailure");
        foreach (var r in rows)
            sb.AppendLine(string.Join(",", new[]
            {
                Csv(r.phase), Csv(r.pointName), Csv(r.buttonName), Csv(r.buttonScenePath), Csv(r.targetScenePath), Csv(r.pointerPosition), Csv(r.canvasPath), Csv(r.canvasRenderMode), r.canvasSortingOrder.ToString(), r.canvasTargetDisplay.ToString(), Bool(r.raycasterIgnoreReversedGraphics), Csv(r.raycasterBlockingObjects), Csv(r.eventCameraName), Csv(r.eventCameraPixelRect), r.eventCameraTargetDisplay.ToString(), Bool(r.pixelRectContains), Csv(r.displayRelative), Bool(r.displayRelativeNonZero), Bool(r.displayMatches), r.registryCount.ToString(), r.targetDepth.ToString(), r.targetAbsoluteDepth.ToString(), r.mirrorFinalCandidateCount.ToString(), Bool(r.mirrorTargetFinalCandidate), Csv(r.mirrorFinalPaths), r.unityHitCount.ToString(), Bool(r.unityTargetHit), Csv(r.unityHitPaths), Bool(r.raycastReady), Csv(r.primaryFailure)
            }));
        File.WriteAllText(path, sb.ToString(), new UTF8Encoding(false));
    }

    private static void WriteDetailCsv(string path, List<DetailRow> rows)
    {
        Directory.CreateDirectory(Path.GetDirectoryName(path));
        var sb = new StringBuilder();
        sb.AppendLine("phase,pointName,buttonName,buttonScenePath,targetScenePath,pointerPosition,graphicScenePath,graphicName,graphicType,isTargetGraphic,graphicDepth,absoluteDepth,raycastTarget,activeInHierarchy,enabled,canvasRendererCull,cullTransparentMesh,materialName,pixelRectContains,displayMatches,rectContains,graphicRaycast,graphicRaycastError,reversedDot,reversedPass,canvasGroupPass,canvasGroupSummary,finalCandidate,rejectionReason");
        foreach (var r in rows)
            sb.AppendLine(string.Join(",", new[]
            {
                Csv(r.phase), Csv(r.pointName), Csv(r.buttonName), Csv(r.buttonScenePath), Csv(r.targetScenePath), Csv(r.pointerPosition), Csv(r.graphicScenePath), Csv(r.graphicName), Csv(r.graphicType), Bool(r.isTargetGraphic), r.graphicDepth.ToString(), r.absoluteDepth.ToString(), Bool(r.raycastTarget), Bool(r.activeInHierarchy), Bool(r.enabled), Bool(r.canvasRendererCull), Bool(r.cullTransparentMesh), Csv(r.materialName), Bool(r.pixelRectContains), Bool(r.displayMatches), Bool(r.rectContains), Bool(r.graphicRaycast), Csv(r.graphicRaycastError), Float(r.reversedDot), Bool(r.reversedPass), Bool(r.canvasGroupPass), Csv(r.canvasGroupSummary), Bool(r.finalCandidate), Csv(r.rejectionReason)
            }));
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
        sb.AppendLine("  \"patchApplied\": " + Bool(r.patchApplied) + ",");
        sb.AppendLine("  \"prePatchPixelRectRejectedCount\": " + r.prePatchPixelRectRejectedCount + ",");
        sb.AppendLine("  \"prePatchMirrorTargetCandidateCount\": " + r.prePatchMirrorTargetCandidateCount + ",");
        sb.AppendLine("  \"summaryRowCount\": " + r.summaryRowCount + ",");
        sb.AppendLine("  \"detailRowCount\": " + r.detailRowCount + ",");
        sb.AppendLine("  \"reopenSummaryCount\": " + r.reopenSummaryCount + ",");
        sb.AppendLine("  \"reopenDepthNonNegativeCount\": " + r.reopenDepthNonNegativeCount + ",");
        sb.AppendLine("  \"reopenAbsoluteDepthNonNegativeCount\": " + r.reopenAbsoluteDepthNonNegativeCount + ",");
        sb.AppendLine("  \"reopenPixelRectContainsCount\": " + r.reopenPixelRectContainsCount + ",");
        sb.AppendLine("  \"reopenMirrorAnyCandidateCount\": " + r.reopenMirrorAnyCandidateCount + ",");
        sb.AppendLine("  \"reopenMirrorTargetCandidateCount\": " + r.reopenMirrorTargetCandidateCount + ",");
        sb.AppendLine("  \"reopenUnityHitPositiveCount\": " + r.reopenUnityHitPositiveCount + ",");
        sb.AppendLine("  \"reopenRaycastReadyCount\": " + r.reopenRaycastReadyCount + ",");
        sb.AppendLine("  \"bestRaycastReadyCount\": " + r.bestRaycastReadyCount + ",");
        sb.AppendLine("  \"primaryFailureSummary\": \"" + Json(r.primaryFailureSummary) + "\",");
        sb.AppendLine("  \"readyByPointSummary\": \"" + Json(r.readyByPointSummary) + "\",");
        sb.AppendLine("  \"patchDecision\": \"" + Json(r.patchDecision) + "\",");
        sb.AppendLine("  \"failReason\": \"" + Json(r.failReason) + "\"");
        sb.AppendLine("}");
        File.WriteAllText(path, sb.ToString(), new UTF8Encoding(false));
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

    private static string DictString(Dictionary<string, int> dict)
    {
        var parts = new List<string>();
        foreach (var pair in dict) parts.Add(pair.Key + ":" + pair.Value);
        return string.Join(", ", parts.ToArray());
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

    private sealed class PointCandidate
    {
        public string name;
        public Vector2 position;
        public PointCandidate(string n, Vector2 p) { name = n; position = p; }
    }

    private sealed class Result
    {
        public string status = "", sourceScene = "", scene = "", capture = "", failReason = "", primaryFailureSummary = "", readyByPointSummary = "", patchDecision = "";
        public bool isFinalRestoredBattleScreen, sourceSceneOpened, sceneSaved, captureExists, reopenValid, patchApplied;
        public int prePatchPixelRectRejectedCount, prePatchMirrorTargetCandidateCount, summaryRowCount, detailRowCount, reopenSummaryCount, reopenDepthNonNegativeCount, reopenAbsoluteDepthNonNegativeCount, reopenPixelRectContainsCount, reopenMirrorAnyCandidateCount, reopenMirrorTargetCandidateCount, reopenUnityHitPositiveCount, reopenRaycastReadyCount, bestRaycastReadyCount;
    }

    private sealed class SummaryRow
    {
        public string phase = "", pointName = "", buttonName = "", buttonScenePath = "", targetScenePath = "", pointerPosition = "", canvasPath = "", canvasRenderMode = "", raycasterBlockingObjects = "", eventCameraName = "", eventCameraPixelRect = "", displayRelative = "", mirrorFinalPaths = "", unityHitPaths = "", primaryFailure = "";
        public int canvasSortingOrder, canvasTargetDisplay, eventCameraTargetDisplay, registryCount, targetDepth, targetAbsoluteDepth, mirrorFinalCandidateCount, unityHitCount;
        public bool raycasterIgnoreReversedGraphics, pixelRectContains, displayRelativeNonZero, displayMatches, mirrorTargetFinalCandidate, unityTargetHit, raycastReady;
    }

    private sealed class DetailRow
    {
        public string phase = "", pointName = "", buttonName = "", buttonScenePath = "", targetScenePath = "", pointerPosition = "", graphicScenePath = "", graphicName = "", graphicType = "", materialName = "", graphicRaycastError = "", canvasGroupSummary = "", rejectionReason = "";
        public bool isTargetGraphic, raycastTarget, activeInHierarchy, enabled, canvasRendererCull, cullTransparentMesh, pixelRectContains, displayMatches, rectContains, graphicRaycast, reversedPass, canvasGroupPass, finalCandidate;
        public int graphicDepth, absoluteDepth;
        public float reversedDot;
    }
}
