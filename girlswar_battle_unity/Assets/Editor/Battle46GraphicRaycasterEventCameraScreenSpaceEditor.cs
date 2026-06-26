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
using System.Text;

public static class Battle46TraceGraphicRaycasterEventCameraScreenSpaceAndBlockersEditor
{
    private const string SourceScenePath = "Assets/Scenes/Battle45Empty4RaycastRegistryCandidate.unity";
    private const string ScenePath = "Assets/Scenes/Battle46GraphicRaycasterEventCameraScreenSpaceCandidate.unity";
    private const string ResultJsonPath = "Assets/RestoreData/battle/BATTLE_46_TRACE_GRAPHICRAYCASTER_EVENT_CAMERA_SCREENSPACE_AND_BLOCKERS_UNITY.json";
    private const string RowsCsvPath = "Assets/RestoreData/battle/BATTLE_46_TRACE_GRAPHICRAYCASTER_EVENT_CAMERA_SCREENSPACE_AND_BLOCKERS_COMPONENTS.csv";
    private const string CapturePath = "Assets/RestoreCaptures/battle_actor/Battle46GraphicRaycasterEventCameraScreenSpaceCandidate_1920x1080.png";
    private const int CaptureWidth = 1920;
    private const int CaptureHeight = 1080;

    [MenuItem("GirlsWar/Battle/BATTLE46 Trace GraphicRaycaster EventCamera ScreenSpace")]
    public static void Build()
    {
        Directory.CreateDirectory(ProjectPath("Assets/RestoreData/battle"));
        Directory.CreateDirectory(ProjectPath("Assets/RestoreCaptures/battle_actor"));

        var result = new Result();
        result.status = "battle46_trace_graphicraycaster_event_camera_screenspace_and_blockers";
        result.isFinalRestoredBattleScreen = false;
        result.sourceScene = SourceScenePath;
        result.scene = ScenePath;
        result.capture = CapturePath;

        var rows = new List<Row>();
        if (!File.Exists(ProjectPath(SourceScenePath)))
        {
            result.failReason = "source_scene_file_not_found";
            WriteOutputs(result, rows);
            return;
        }

        var scene = EditorSceneManager.OpenScene(SourceScenePath, OpenSceneMode.Single);
        result.sourceSceneOpened = scene.IsValid();
        var captureCamera = FindCaptureCamera();
        if (captureCamera != null) ConfigureCamera(captureCamera);
        result.eventSystemCountBefore = UnityEngine.Object.FindObjectsOfType<EventSystem>(true).Length;
        Snapshot(result, "before");

        Canvas.ForceUpdateCanvases();
        foreach (var graphic in UnityEngine.Object.FindObjectsOfType<Graphic>(true))
        {
            if (graphic != null) graphic.SetAllDirty();
        }
        Canvas.ForceUpdateCanvases();

        EditorSceneManager.SaveScene(scene, ScenePath);
        result.sceneSaved = File.Exists(ProjectPath(ScenePath));
        if (captureCamera != null)
        {
            Capture(captureCamera, ProjectPath(CapturePath));
            result.captureExists = File.Exists(ProjectPath(CapturePath));
        }

        var reopened = EditorSceneManager.OpenScene(ScenePath, OpenSceneMode.Single);
        result.reopenValid = reopened.IsValid();
        Canvas.ForceUpdateCanvases();
        captureCamera = FindCaptureCamera();
        if (captureCamera != null) ConfigureCamera(captureCamera);
        Snapshot(result, "reopen");
        ProbeButtons(rows, result, captureCamera);
        SummarizeRows(rows, result);

        WriteOutputs(result, rows);
        AssetDatabase.Refresh();
        Debug.Log("BATTLE46 GraphicRaycaster screen-space trace complete. ready=" + result.reopenRaycastReadyButtonCount + ", rows=" + rows.Count);
    }

    private static void ProbeButtons(List<Row> rows, Result result, Camera captureCamera)
    {
        var eventSystem = UnityEngine.Object.FindObjectOfType<EventSystem>(true);
        foreach (var button in UnityEngine.Object.FindObjectsOfType<Button>(true))
        {
            if (button == null || button.targetGraphic == null) continue;
            var row = new Row();
            row.status = "reopen_button_target_probe";
            row.buttonScenePath = HierarchyPath(button.transform);
            row.buttonName = button.name;
            row.hasButton = true;
            row.buttonInteractable = button.interactable;
            row.buttonActiveSelf = button.gameObject.activeSelf;
            row.buttonActiveInHierarchy = button.gameObject.activeInHierarchy;
            row.targetScenePath = HierarchyPath(button.targetGraphic.transform);
            row.targetName = button.targetGraphic.name;
            row.boundTargetGraphicType = button.targetGraphic.GetType().FullName;
            row.targetActiveSelf = button.targetGraphic.gameObject.activeSelf;
            row.targetActiveInHierarchy = button.targetGraphic.gameObject.activeInHierarchy;
            row.targetEnabled = button.targetGraphic.enabled;
            row.targetRaycastTarget = button.targetGraphic.raycastTarget;
            row.targetLayer = button.targetGraphic.gameObject.layer;
            row.targetDepth = button.targetGraphic.depth;
            row.targetMaterialName = button.targetGraphic.material != null ? button.targetGraphic.material.name : "";
            row.targetCull = GetCanvasRendererCull(button.targetGraphic);
            row.targetCanvasRendererAlpha = GetCanvasRendererAlpha(button.targetGraphic);
            row.targetGraphicRaycastEventCamera = SafeGraphicRaycast(button.targetGraphic, EventCameraFor(button), row);
            row.canvasGroupBlocksRaycasts = ParentCanvasGroupsAllowRaycasts(button.targetGraphic.transform, out row.canvasGroupSummary);

            var rect = button.targetGraphic.transform as RectTransform;
            if (rect != null)
            {
                row.targetRectSize = Vec2(rect.rect.size);
                row.targetPivot = Vec2(rect.pivot);
                row.targetAnchoredPosition = Vec2(rect.anchoredPosition);
                row.targetLossyScale = Vec3(rect.lossyScale);
            }
            var buttonRect = button.transform as RectTransform;
            if (buttonRect != null)
            {
                row.buttonRectSize = Vec2(buttonRect.rect.size);
                row.buttonAnchoredPosition = Vec2(buttonRect.anchoredPosition);
            }

            var canvas = button.GetComponentInParent<Canvas>(true);
            row.hasParentCanvas = canvas != null;
            if (canvas != null)
            {
                FillCanvas(row, canvas);
                var raycaster = canvas.GetComponent<GraphicRaycaster>();
                row.hasGraphicRaycaster = raycaster != null;
                if (raycaster != null)
                {
                    FillRaycaster(row, raycaster);
                    ProbeRaycaster(row, raycaster, eventSystem, button, rect);
                }
                try
                {
                    var graphics = GraphicRegistry.GetGraphicsForCanvas(canvas);
                    row.registryCount = graphics != null ? graphics.Count : 0;
                    row.targetInRegistry = graphics != null && graphics.Contains(button.targetGraphic);
                }
                catch (Exception ex)
                {
                    row.registryError = ex.GetType().Name + ":" + ex.Message;
                }
            }
            if (rect != null) FillWorldAndScreen(row, rect, captureCamera);
            row.evidence = "BATTLE46 reopen probe; no fake onClick/art/HUD/card/icon; compares GraphicRaycaster with RectTransformUtility candidates";
            rows.Add(row);
        }
    }

    private static Camera EventCameraFor(Button button)
    {
        var canvas = button != null ? button.GetComponentInParent<Canvas>(true) : null;
        if (canvas == null || canvas.renderMode == RenderMode.ScreenSpaceOverlay) return null;
        var raycaster = canvas.GetComponent<GraphicRaycaster>();
        if (raycaster != null && raycaster.eventCamera != null) return raycaster.eventCamera;
        return canvas.worldCamera;
    }

    private static void FillCanvas(Row row, Canvas canvas)
    {
        row.canvasPath = HierarchyPath(canvas.transform);
        row.canvasRenderMode = canvas.renderMode.ToString();
        row.canvasActiveSelf = canvas.gameObject.activeSelf;
        row.canvasActiveInHierarchy = canvas.gameObject.activeInHierarchy;
        row.canvasEnabled = canvas.enabled;
        row.canvasScaleFactor = Float(canvas.scaleFactor);
        row.canvasReferencePixelsPerUnit = Float(canvas.referencePixelsPerUnit);
        row.canvasPlaneDistance = Float(canvas.planeDistance);
        row.canvasSortingLayerId = canvas.sortingLayerID;
        row.canvasSortingOrder = canvas.sortingOrder;
        row.canvasOverrideSorting = canvas.overrideSorting;
        row.canvasTargetDisplay = canvas.targetDisplay;
        row.canvasWorldCameraName = canvas.worldCamera != null ? canvas.worldCamera.name : "";
        FillCamera(row, canvas.worldCamera, "world");
    }

    private static void FillRaycaster(Row row, GraphicRaycaster raycaster)
    {
        row.raycasterEnabled = raycaster.enabled;
        row.raycasterActiveInHierarchy = raycaster.gameObject.activeInHierarchy;
        row.raycasterIgnoreReversedGraphics = raycaster.ignoreReversedGraphics;
        row.raycasterBlockingObjects = raycaster.blockingObjects.ToString();
        row.raycasterBlockingMask = raycaster.blockingMask.value;
        row.eventCameraName = raycaster.eventCamera != null ? raycaster.eventCamera.name : "(overlay/null)";
        FillCamera(row, raycaster.eventCamera, "event");
    }

    private static void FillCamera(Row row, Camera camera, string prefix)
    {
        if (camera == null)
        {
            SetCameraFields(row, prefix, "", false, 0, 0, 0, false, 0, 0, 0, 0, "", "", "", 0, 0, 0);
            return;
        }
        SetCameraFields(
            row,
            prefix,
            camera.name,
            camera.enabled,
            camera.depth,
            camera.cullingMask,
            camera.targetDisplay,
            camera.orthographic,
            camera.orthographicSize,
            camera.nearClipPlane,
            camera.farClipPlane,
            camera.aspect,
            RectString(camera.pixelRect),
            Vec2(new Vector2(camera.pixelWidth, camera.pixelHeight)),
            camera.clearFlags.ToString(),
            camera.transform.position.x,
            camera.transform.position.y,
            camera.transform.position.z);
    }

    private static void SetCameraFields(Row row, string prefix, string name, bool enabled, float depth, int cullingMask, int display, bool ortho, float orthoSize, float near, float far, float aspect, string pixelRect, string pixelSize, string clearFlags, float px, float py, float pz)
    {
        if (prefix == "world")
        {
            row.worldCameraName = name; row.worldCameraEnabled = enabled; row.worldCameraDepth = Float(depth); row.worldCameraCullingMask = cullingMask; row.worldCameraTargetDisplay = display; row.worldCameraOrthographic = ortho; row.worldCameraOrthographicSize = Float(orthoSize); row.worldCameraNear = Float(near); row.worldCameraFar = Float(far); row.worldCameraAspect = Float(aspect); row.worldCameraPixelRect = pixelRect; row.worldCameraPixelSize = pixelSize; row.worldCameraClearFlags = clearFlags; row.worldCameraPosition = Vec3(new Vector3(px, py, pz));
        }
        else
        {
            row.eventCameraName = string.IsNullOrEmpty(name) ? row.eventCameraName : name; row.eventCameraEnabled = enabled; row.eventCameraDepth = Float(depth); row.eventCameraCullingMask = cullingMask; row.eventCameraTargetDisplay = display; row.eventCameraOrthographic = ortho; row.eventCameraOrthographicSize = Float(orthoSize); row.eventCameraNear = Float(near); row.eventCameraFar = Float(far); row.eventCameraAspect = Float(aspect); row.eventCameraPixelRect = pixelRect; row.eventCameraPixelSize = pixelSize; row.eventCameraClearFlags = clearFlags; row.eventCameraPosition = Vec3(new Vector3(px, py, pz));
        }
    }

    private static void FillWorldAndScreen(Row row, RectTransform rect, Camera captureCamera)
    {
        var eventCamera = CameraByName(row.eventCameraName);
        if (row.eventCameraName == "(overlay/null)") eventCamera = null;
        var mainCamera = Camera.main;
        var centerWorld = rect.TransformPoint(rect.rect.center);
        row.worldCenter = Vec3(centerWorld);
        row.screenEventCenter = Vec2(RectTransformUtility.WorldToScreenPoint(eventCamera, centerWorld));
        row.screenNullCenter = Vec2(RectTransformUtility.WorldToScreenPoint(null, centerWorld));
        row.screenMainCenter = mainCamera != null ? Vec2(RectTransformUtility.WorldToScreenPoint(mainCamera, centerWorld)) : "";
        row.screenCaptureCenter = captureCamera != null ? Vec2(RectTransformUtility.WorldToScreenPoint(captureCamera, centerWorld)) : "";
        row.viewportEventCenter = eventCamera != null ? Vec3(eventCamera.WorldToViewportPoint(centerWorld)) : "";
        row.viewportMainCenter = mainCamera != null ? Vec3(mainCamera.WorldToViewportPoint(centerWorld)) : "";
        row.viewportCaptureCenter = captureCamera != null ? Vec3(captureCamera.WorldToViewportPoint(centerWorld)) : "";
        row.eventCameraZ = eventCamera != null ? Float(eventCamera.WorldToViewportPoint(centerWorld).z) : "";
        row.mainCameraZ = mainCamera != null ? Float(mainCamera.WorldToViewportPoint(centerWorld).z) : "";
        row.captureCameraZ = captureCamera != null ? Float(captureCamera.WorldToViewportPoint(centerWorld).z) : "";
        row.eventCameraInFront = eventCamera != null && eventCamera.WorldToViewportPoint(centerWorld).z > 0f;
        row.mainCameraInFront = mainCamera != null && mainCamera.WorldToViewportPoint(centerWorld).z > 0f;
        row.captureCameraInFront = captureCamera != null && captureCamera.WorldToViewportPoint(centerWorld).z > 0f;

        var corners = new Vector3[4];
        rect.GetWorldCorners(corners);
        row.worldCorners = JoinVec3(corners);
        row.screenCornersEvent = JoinScreen(corners, eventCamera);
        row.screenCornersNull = JoinScreen(corners, null);
        row.screenCornersMain = mainCamera != null ? JoinScreen(corners, mainCamera) : "";
        row.screenCornersCapture = captureCamera != null ? JoinScreen(corners, captureCamera) : "";

        Vector2 eventPoint = ParseVec2(row.screenEventCenter);
        Vector2 nullPoint = ParseVec2(row.screenNullCenter);
        Vector2 mainPoint = string.IsNullOrEmpty(row.screenMainCenter) ? eventPoint : ParseVec2(row.screenMainCenter);
        Vector2 capturePoint = string.IsNullOrEmpty(row.screenCaptureCenter) ? eventPoint : ParseVec2(row.screenCaptureCenter);

        ProbeRectUtility(rect, eventPoint, eventCamera, out row.rectContainsEventAtEventCenter, out row.localEventAtEventCenter, out row.localEventOkAtEventCenter);
        ProbeRectUtility(rect, eventPoint, null, out row.rectContainsNullAtEventCenter, out row.localNullAtEventCenter, out row.localNullOkAtEventCenter);
        if (mainCamera != null) ProbeRectUtility(rect, mainPoint, mainCamera, out row.rectContainsMainAtMainCenter, out row.localMainAtMainCenter, out row.localMainOkAtMainCenter);
        if (captureCamera != null) ProbeRectUtility(rect, capturePoint, captureCamera, out row.rectContainsCaptureAtCaptureCenter, out row.localCaptureAtCaptureCenter, out row.localCaptureOkAtCaptureCenter);
        ProbeRectUtility(rect, nullPoint, null, out row.rectContainsNullAtNullCenter, out row.localNullAtNullCenter, out row.localNullOkAtNullCenter);
    }

    private static void ProbeRectUtility(RectTransform rect, Vector2 screenPoint, Camera camera, out bool contains, out string local, out bool localOk)
    {
        contains = RectTransformUtility.RectangleContainsScreenPoint(rect, screenPoint, camera);
        Vector2 localPoint;
        localOk = RectTransformUtility.ScreenPointToLocalPointInRectangle(rect, screenPoint, camera, out localPoint);
        local = Vec2(localPoint);
    }

    private static void ProbeRaycaster(Row row, GraphicRaycaster raycaster, EventSystem eventSystem, Button button, RectTransform rect)
    {
        if (eventSystem == null)
        {
            row.raycastReason = "missing_event_system";
            return;
        }
        if (rect == null)
        {
            row.raycastReason = "missing_target_rect";
            return;
        }
        var screen = ParseVec2(row.screenEventCenter);
        var data = new PointerEventData(eventSystem);
        data.position = screen;
        var hits = new List<RaycastResult>();
        raycaster.Raycast(data, hits);
        row.hitCount = hits.Count;
        var hitPaths = new List<string>();
        foreach (var hit in hits)
        {
            if (hit.gameObject == null) continue;
            if (hitPaths.Count < 8) hitPaths.Add(HierarchyPath(hit.gameObject.transform) + "#" + Float(hit.distance) + "#" + hit.depth);
            if (hit.gameObject == button.targetGraphic.gameObject || hit.gameObject.transform.IsChildOf(button.transform)) row.raycastReady = true;
        }
        row.hitPaths = string.Join(" | ", hitPaths.ToArray());
        if (row.raycastReady) row.raycastReason = "target_hit";
        else if (hits.Count == 0) row.raycastReason = "no_graphic_hits_at_target_center";
        else row.raycastReason = "target_not_in_hits";
    }

    private static bool SafeGraphicRaycast(Graphic graphic, Camera camera, Row row)
    {
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
            row.graphicRaycastError = ex.GetType().Name + ":" + ex.Message;
            return false;
        }
    }

    private static bool ParentCanvasGroupsAllowRaycasts(Transform transform, out string summary)
    {
        bool allowed = true;
        var parts = new List<string>();
        var cursor = transform;
        while (cursor != null)
        {
            foreach (var group in cursor.GetComponents<CanvasGroup>())
            {
                if (group == null) continue;
                parts.Add(HierarchyPath(cursor) + "(blocks=" + group.blocksRaycasts + ";interactable=" + group.interactable + ";ignoreParent=" + group.ignoreParentGroups + ")");
                if (!group.blocksRaycasts) allowed = false;
                if (group.ignoreParentGroups) break;
            }
            cursor = cursor.parent;
        }
        summary = string.Join(" | ", parts.ToArray());
        return allowed;
    }

    private static void SummarizeRows(List<Row> rows, Result result)
    {
        var reasons = new Dictionary<string, int>();
        foreach (var row in rows)
        {
            if (row.hasButton) result.reopenButtonProbeCount++;
            if (row.targetInRegistry) result.reopenRegistryTargetIncludedCount++;
            if (row.raycastReady) result.reopenRaycastReadyButtonCount++;
            if (row.targetDepth == -1) result.targetDepthMinusOneCount++;
            if (row.rectContainsEventAtEventCenter) result.rectContainsEventCameraCount++;
            if (row.rectContainsNullAtEventCenter) result.rectContainsNullCameraAtEventCenterCount++;
            if (row.rectContainsNullAtNullCenter) result.rectContainsNullCameraAtNullCenterCount++;
            if (row.rectContainsMainAtMainCenter) result.rectContainsMainCameraCount++;
            if (row.rectContainsCaptureAtCaptureCenter) result.rectContainsCaptureCameraCount++;
            if (row.targetGraphicRaycastEventCamera) result.graphicRaycastEventCameraCount++;
            if (!reasons.ContainsKey(row.raycastReason)) reasons[row.raycastReason] = 0;
            reasons[row.raycastReason]++;
        }
        result.raycastReasonSummary = DictString(reasons);
        if (result.reopenRaycastReadyButtonCount > 0)
            result.patchDecision = "input_plumbing_improved_in_probe_but_no_final_playable_claim";
        else if (result.rectContainsNullCameraAtNullCenterCount > result.rectContainsEventCameraCount)
            result.patchDecision = "screen_space_camera_mismatch_suspected; no automatic coordinate-only patch applied";
        else if (result.targetDepthMinusOneCount == rows.Count && rows.Count > 0)
            result.patchDecision = "all_button_targets_have_graphic_depth_minus_one; GraphicRaycaster excludes these despite registry and rect passing";
        else if (result.rectContainsEventCameraCount > 0 && result.graphicRaycastEventCameraCount > 0)
            result.patchDecision = "rect_and_graphic_candidates_pass_but_graphicraycaster_returns_zero; inspect raycaster/display/blocking path next";
        else
            result.patchDecision = "evidence_insufficient_for_minimal_patch; trace only";
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
        if (phase == "before") result.before = counts; else result.reopen = counts;
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
        sb.AppendLine("status,buttonScenePath,buttonName,targetScenePath,targetName,boundTargetGraphicType,hasButton,buttonInteractable,buttonActiveSelf,buttonActiveInHierarchy,targetActiveSelf,targetActiveInHierarchy,targetEnabled,targetRaycastTarget,targetLayer,targetDepth,targetMaterialName,targetCull,targetCanvasRendererAlpha,targetGraphicRaycastEventCamera,graphicRaycastError,buttonRectSize,buttonAnchoredPosition,targetRectSize,targetAnchoredPosition,targetPivot,targetLossyScale,canvasPath,canvasRenderMode,canvasActiveSelf,canvasActiveInHierarchy,canvasEnabled,canvasScaleFactor,canvasReferencePixelsPerUnit,canvasPlaneDistance,canvasSortingLayerId,canvasSortingOrder,canvasOverrideSorting,canvasTargetDisplay,canvasWorldCameraName,hasParentCanvas,hasGraphicRaycaster,raycasterEnabled,raycasterActiveInHierarchy,raycasterIgnoreReversedGraphics,raycasterBlockingObjects,raycasterBlockingMask,eventCameraName,worldCameraName,eventCameraEnabled,eventCameraDepth,eventCameraCullingMask,eventCameraTargetDisplay,eventCameraOrthographic,eventCameraOrthographicSize,eventCameraNear,eventCameraFar,eventCameraAspect,eventCameraPixelRect,eventCameraPixelSize,eventCameraClearFlags,eventCameraPosition,worldCameraEnabled,worldCameraDepth,worldCameraCullingMask,worldCameraTargetDisplay,worldCameraOrthographic,worldCameraOrthographicSize,worldCameraNear,worldCameraFar,worldCameraAspect,worldCameraPixelRect,worldCameraPixelSize,worldCameraClearFlags,worldCameraPosition,worldCenter,worldCorners,screenEventCenter,screenNullCenter,screenMainCenter,screenCaptureCenter,screenCornersEvent,screenCornersNull,screenCornersMain,screenCornersCapture,viewportEventCenter,viewportMainCenter,viewportCaptureCenter,eventCameraZ,mainCameraZ,captureCameraZ,eventCameraInFront,mainCameraInFront,captureCameraInFront,rectContainsEventAtEventCenter,localEventOkAtEventCenter,localEventAtEventCenter,rectContainsNullAtEventCenter,localNullOkAtEventCenter,localNullAtEventCenter,rectContainsNullAtNullCenter,localNullOkAtNullCenter,localNullAtNullCenter,rectContainsMainAtMainCenter,localMainOkAtMainCenter,localMainAtMainCenter,rectContainsCaptureAtCaptureCenter,localCaptureOkAtCaptureCenter,localCaptureAtCaptureCenter,canvasGroupBlocksRaycasts,canvasGroupSummary,registryCount,targetInRegistry,registryError,hitCount,hitPaths,raycastReady,raycastReason,evidence");
        foreach (var r in rows)
        {
            sb.AppendLine(string.Join(",", new[]
            {
                Csv(r.status), Csv(r.buttonScenePath), Csv(r.buttonName), Csv(r.targetScenePath), Csv(r.targetName), Csv(r.boundTargetGraphicType),
                Bool(r.hasButton), Bool(r.buttonInteractable), Bool(r.buttonActiveSelf), Bool(r.buttonActiveInHierarchy), Bool(r.targetActiveSelf), Bool(r.targetActiveInHierarchy), Bool(r.targetEnabled), Bool(r.targetRaycastTarget), r.targetLayer.ToString(), r.targetDepth.ToString(), Csv(r.targetMaterialName), Bool(r.targetCull), Csv(r.targetCanvasRendererAlpha), Bool(r.targetGraphicRaycastEventCamera), Csv(r.graphicRaycastError),
                Csv(r.buttonRectSize), Csv(r.buttonAnchoredPosition), Csv(r.targetRectSize), Csv(r.targetAnchoredPosition), Csv(r.targetPivot), Csv(r.targetLossyScale),
                Csv(r.canvasPath), Csv(r.canvasRenderMode), Bool(r.canvasActiveSelf), Bool(r.canvasActiveInHierarchy), Bool(r.canvasEnabled), Csv(r.canvasScaleFactor), Csv(r.canvasReferencePixelsPerUnit), Csv(r.canvasPlaneDistance), r.canvasSortingLayerId.ToString(), r.canvasSortingOrder.ToString(), Bool(r.canvasOverrideSorting), r.canvasTargetDisplay.ToString(), Csv(r.canvasWorldCameraName), Bool(r.hasParentCanvas),
                Bool(r.hasGraphicRaycaster), Bool(r.raycasterEnabled), Bool(r.raycasterActiveInHierarchy), Bool(r.raycasterIgnoreReversedGraphics), Csv(r.raycasterBlockingObjects), r.raycasterBlockingMask.ToString(), Csv(r.eventCameraName), Csv(r.worldCameraName),
                Bool(r.eventCameraEnabled), Csv(r.eventCameraDepth), r.eventCameraCullingMask.ToString(), r.eventCameraTargetDisplay.ToString(), Bool(r.eventCameraOrthographic), Csv(r.eventCameraOrthographicSize), Csv(r.eventCameraNear), Csv(r.eventCameraFar), Csv(r.eventCameraAspect), Csv(r.eventCameraPixelRect), Csv(r.eventCameraPixelSize), Csv(r.eventCameraClearFlags), Csv(r.eventCameraPosition),
                Bool(r.worldCameraEnabled), Csv(r.worldCameraDepth), r.worldCameraCullingMask.ToString(), r.worldCameraTargetDisplay.ToString(), Bool(r.worldCameraOrthographic), Csv(r.worldCameraOrthographicSize), Csv(r.worldCameraNear), Csv(r.worldCameraFar), Csv(r.worldCameraAspect), Csv(r.worldCameraPixelRect), Csv(r.worldCameraPixelSize), Csv(r.worldCameraClearFlags), Csv(r.worldCameraPosition),
                Csv(r.worldCenter), Csv(r.worldCorners), Csv(r.screenEventCenter), Csv(r.screenNullCenter), Csv(r.screenMainCenter), Csv(r.screenCaptureCenter), Csv(r.screenCornersEvent), Csv(r.screenCornersNull), Csv(r.screenCornersMain), Csv(r.screenCornersCapture), Csv(r.viewportEventCenter), Csv(r.viewportMainCenter), Csv(r.viewportCaptureCenter), Csv(r.eventCameraZ), Csv(r.mainCameraZ), Csv(r.captureCameraZ),
                Bool(r.eventCameraInFront), Bool(r.mainCameraInFront), Bool(r.captureCameraInFront),
                Bool(r.rectContainsEventAtEventCenter), Bool(r.localEventOkAtEventCenter), Csv(r.localEventAtEventCenter), Bool(r.rectContainsNullAtEventCenter), Bool(r.localNullOkAtEventCenter), Csv(r.localNullAtEventCenter), Bool(r.rectContainsNullAtNullCenter), Bool(r.localNullOkAtNullCenter), Csv(r.localNullAtNullCenter), Bool(r.rectContainsMainAtMainCenter), Bool(r.localMainOkAtMainCenter), Csv(r.localMainAtMainCenter), Bool(r.rectContainsCaptureAtCaptureCenter), Bool(r.localCaptureOkAtCaptureCenter), Csv(r.localCaptureAtCaptureCenter),
                Bool(r.canvasGroupBlocksRaycasts), Csv(r.canvasGroupSummary), r.registryCount.ToString(), Bool(r.targetInRegistry), Csv(r.registryError), r.hitCount.ToString(), Csv(r.hitPaths), Bool(r.raycastReady), Csv(r.raycastReason), Csv(r.evidence)
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
        sb.AppendLine("  \"eventSystemCountBefore\": " + r.eventSystemCountBefore + ",");
        sb.AppendLine("  \"before\": " + CountsJson(r.before) + ",");
        sb.AppendLine("  \"reopen\": " + CountsJson(r.reopen) + ",");
        sb.AppendLine("  \"reopenButtonProbeCount\": " + r.reopenButtonProbeCount + ",");
        sb.AppendLine("  \"reopenRegistryTargetIncludedCount\": " + r.reopenRegistryTargetIncludedCount + ",");
        sb.AppendLine("  \"reopenRaycastReadyButtonCount\": " + r.reopenRaycastReadyButtonCount + ",");
        sb.AppendLine("  \"rectContainsEventCameraCount\": " + r.rectContainsEventCameraCount + ",");
        sb.AppendLine("  \"rectContainsNullCameraAtEventCenterCount\": " + r.rectContainsNullCameraAtEventCenterCount + ",");
        sb.AppendLine("  \"rectContainsNullCameraAtNullCenterCount\": " + r.rectContainsNullCameraAtNullCenterCount + ",");
        sb.AppendLine("  \"rectContainsMainCameraCount\": " + r.rectContainsMainCameraCount + ",");
        sb.AppendLine("  \"rectContainsCaptureCameraCount\": " + r.rectContainsCaptureCameraCount + ",");
        sb.AppendLine("  \"graphicRaycastEventCameraCount\": " + r.graphicRaycastEventCameraCount + ",");
        sb.AppendLine("  \"targetDepthMinusOneCount\": " + r.targetDepthMinusOneCount + ",");
        sb.AppendLine("  \"raycastReasonSummary\": \"" + Json(r.raycastReasonSummary) + "\",");
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

    private static string DictString(Dictionary<string, int> dict)
    {
        var parts = new List<string>();
        foreach (var pair in dict) parts.Add(pair.Key + ":" + pair.Value);
        return string.Join(", ", parts.ToArray());
    }

    private static Camera CameraByName(string name)
    {
        if (string.IsNullOrEmpty(name) || name == "(overlay/null)") return null;
        foreach (var camera in UnityEngine.Object.FindObjectsOfType<Camera>(true))
            if (camera != null && camera.name == name) return camera;
        return null;
    }

    private static bool GetCanvasRendererCull(Graphic graphic)
    {
        var renderer = graphic != null ? graphic.GetComponent<CanvasRenderer>() : null;
        return renderer != null && renderer.cull;
    }

    private static string GetCanvasRendererAlpha(Graphic graphic)
    {
        var renderer = graphic != null ? graphic.GetComponent<CanvasRenderer>() : null;
        return renderer != null ? Float(renderer.GetAlpha()) : "";
    }

    private static string HierarchyPath(Transform transform) { var names = new List<string>(); var cursor = transform; while (cursor != null) { names.Add(cursor.name); cursor = cursor.parent; } names.Reverse(); return string.Join("/", names.ToArray()); }
    private static string ProjectPath(string assetPath) { return Path.Combine(Application.dataPath, "..", assetPath.Replace("/", "\\")); }
    private static string Float(float value) { return value.ToString("0.###", System.Globalization.CultureInfo.InvariantCulture); }
    private static string Vec2(Vector2 v) { return Float(v.x) + "/" + Float(v.y); }
    private static string Vec3(Vector3 v) { return Float(v.x) + "/" + Float(v.y) + "/" + Float(v.z); }
    private static string RectString(Rect r) { return Float(r.x) + "/" + Float(r.y) + "/" + Float(r.width) + "/" + Float(r.height); }
    private static string JoinVec3(Vector3[] values) { var parts = new List<string>(); foreach (var v in values) parts.Add(Vec3(v)); return string.Join(" | ", parts.ToArray()); }
    private static string JoinScreen(Vector3[] values, Camera camera) { var parts = new List<string>(); foreach (var v in values) parts.Add(Vec2(RectTransformUtility.WorldToScreenPoint(camera, v))); return string.Join(" | ", parts.ToArray()); }
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
        public string status = "", sourceScene = "", scene = "", capture = "", failReason = "", raycastReasonSummary = "", patchDecision = "";
        public bool isFinalRestoredBattleScreen, sourceSceneOpened, sceneSaved, captureExists, reopenValid;
        public int eventSystemCountBefore, reopenButtonProbeCount, reopenRegistryTargetIncludedCount, reopenRaycastReadyButtonCount;
        public int rectContainsEventCameraCount, rectContainsNullCameraAtEventCenterCount, rectContainsNullCameraAtNullCenterCount, rectContainsMainCameraCount, rectContainsCaptureCameraCount, graphicRaycastEventCameraCount, targetDepthMinusOneCount;
        public Counts before = new Counts();
        public Counts reopen = new Counts();
    }

    private sealed class Row
    {
        public string status = "", buttonScenePath = "", buttonName = "", targetScenePath = "", targetName = "", boundTargetGraphicType = "", targetMaterialName = "", graphicRaycastError = "", buttonRectSize = "", buttonAnchoredPosition = "", targetRectSize = "", targetAnchoredPosition = "", targetPivot = "", targetLossyScale = "";
        public string canvasPath = "", canvasRenderMode = "", canvasScaleFactor = "", canvasReferencePixelsPerUnit = "", canvasPlaneDistance = "", canvasWorldCameraName = "", raycasterBlockingObjects = "", eventCameraName = "", worldCameraName = "";
        public string eventCameraDepth = "", eventCameraOrthographicSize = "", eventCameraNear = "", eventCameraFar = "", eventCameraAspect = "", eventCameraPixelRect = "", eventCameraPixelSize = "", eventCameraClearFlags = "", eventCameraPosition = "";
        public string worldCameraDepth = "", worldCameraOrthographicSize = "", worldCameraNear = "", worldCameraFar = "", worldCameraAspect = "", worldCameraPixelRect = "", worldCameraPixelSize = "", worldCameraClearFlags = "", worldCameraPosition = "";
        public string worldCenter = "", worldCorners = "", screenEventCenter = "", screenNullCenter = "", screenMainCenter = "", screenCaptureCenter = "", screenCornersEvent = "", screenCornersNull = "", screenCornersMain = "", screenCornersCapture = "", viewportEventCenter = "", viewportMainCenter = "", viewportCaptureCenter = "", eventCameraZ = "", mainCameraZ = "", captureCameraZ = "";
        public string localEventAtEventCenter = "", localNullAtEventCenter = "", localNullAtNullCenter = "", localMainAtMainCenter = "", localCaptureAtCaptureCenter = "", canvasGroupSummary = "", registryError = "", hitPaths = "", raycastReason = "", evidence = "", targetCanvasRendererAlpha = "";
        public bool hasButton, buttonInteractable, buttonActiveSelf, buttonActiveInHierarchy, targetActiveSelf, targetActiveInHierarchy, targetEnabled, targetRaycastTarget, targetCull, targetGraphicRaycastEventCamera;
        public bool canvasActiveSelf, canvasActiveInHierarchy, canvasEnabled, canvasOverrideSorting, hasParentCanvas, hasGraphicRaycaster, raycasterEnabled, raycasterActiveInHierarchy, raycasterIgnoreReversedGraphics;
        public bool eventCameraEnabled, eventCameraOrthographic, worldCameraEnabled, worldCameraOrthographic, eventCameraInFront, mainCameraInFront, captureCameraInFront;
        public bool rectContainsEventAtEventCenter, localEventOkAtEventCenter, rectContainsNullAtEventCenter, localNullOkAtEventCenter, rectContainsNullAtNullCenter, localNullOkAtNullCenter, rectContainsMainAtMainCenter, localMainOkAtMainCenter, rectContainsCaptureAtCaptureCenter, localCaptureOkAtCaptureCenter;
        public bool canvasGroupBlocksRaycasts = true, targetInRegistry, raycastReady;
        public int targetLayer, targetDepth, canvasSortingLayerId, canvasSortingOrder, canvasTargetDisplay, raycasterBlockingMask, eventCameraCullingMask, eventCameraTargetDisplay, worldCameraCullingMask, worldCameraTargetDisplay, registryCount, hitCount;
    }
}
