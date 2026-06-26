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

public static class Battle44TraceOriginalButtonMonoScriptAndTargetGraphicSerializationEditor
{
    private const string SourceScenePath = "Assets/Scenes/Battle43PlayableContextValidationCandidate.unity";
    private const string ScenePath = "Assets/Scenes/Battle44OriginalButtonTargetGraphicCandidate.unity";
    private const string PatchManifestPath = "Assets/RestoreData/battle/BATTLE_44_ORIGINAL_BUTTON_TARGET_GRAPHIC_PATCH_MANIFEST.csv";
    private const string ResultJsonPath = "Assets/RestoreData/battle/BATTLE_44_TRACE_ORIGINAL_BUTTON_MONOSCRIPT_AND_TARGET_GRAPHIC_SERIALIZATION_UNITY.json";
    private const string RowsCsvPath = "Assets/RestoreData/battle/BATTLE_44_TRACE_ORIGINAL_BUTTON_MONOSCRIPT_AND_TARGET_GRAPHIC_SERIALIZATION_COMPONENTS.csv";
    private const string CapturePath = "Assets/RestoreCaptures/battle_actor/Battle44OriginalButtonTargetGraphicCandidate_1920x1080.png";
    private const int CaptureWidth = 1920;
    private const int CaptureHeight = 1080;

    [MenuItem("GirlsWar/Battle/BATTLE44 Trace Original Button TargetGraphic")]
    public static void Build()
    {
        Directory.CreateDirectory(ProjectPath("Assets/RestoreData/battle"));
        Directory.CreateDirectory(ProjectPath("Assets/RestoreCaptures/battle_actor"));
        var rows = new List<Battle44Row>();
        var result = new Battle44Result();
        result.sourceScene = SourceScenePath;
        result.scene = ScenePath;
        result.capture = CapturePath;
        result.isFinalRestoredBattleScreen = false;

        if (!File.Exists(ProjectPath(SourceScenePath)))
        {
            result.failReason = "source_scene_file_not_found";
            WriteOutputs(result, rows);
            return;
        }

        var manifest = LoadManifest(ProjectPath(PatchManifestPath));
        result.patchManifestCount = manifest.Count;

        var scene = EditorSceneManager.OpenScene(SourceScenePath, OpenSceneMode.Single);
        result.sourceSceneOpened = scene.IsValid();
        var camera = FindCaptureCamera();
        if (camera == null) camera = CreateFallbackCamera();
        ConfigureCamera(camera);

        SnapshotCounts(result, "before");
        result.eventSystemAdded = EnsureEventSystem();
        result.graphicRaycasterAddedCount = AddGraphicRaycasters(rows);

        var originalButtonPaths = new HashSet<string>();
        foreach (var item in manifest)
        {
            var buttonTransform = FindTransformBySuffix(item.buttonSuffix);
            if (buttonTransform == null)
            {
                rows.Add(Row("original_button_root_missing", null, item, null, "original button suffix not found in BATTLE43 candidate scene"));
                continue;
            }
            originalButtonPaths.Add(HierarchyPath(buttonTransform));
            result.matchedButtonCount++;

            Graphic targetGraphic = null;
            Transform targetTransform = null;
            if (!string.IsNullOrEmpty(item.targetSuffix))
            {
                targetTransform = FindTransformBySuffix(item.targetSuffix);
            }
            if (targetTransform == null) targetTransform = buttonTransform;

            if (item.targetFullName == "UnityEngine.UI.Empty4Raycast")
            {
                var empty = targetTransform.GetComponent<Empty4Raycast>();
                if (empty == null)
                {
                    empty = targetTransform.gameObject.AddComponent<Empty4Raycast>();
                    result.empty4RaycastAddedCount++;
                }
                empty.raycastTarget = item.targetRaycastTarget != "0";
                empty.color = ParseColor(item.targetColor, Color.white);
                empty.enabled = true;
                empty.SetAllDirty();
                targetGraphic = empty;
            }
            else
            {
                targetGraphic = targetTransform.GetComponent<Graphic>();
                if (targetGraphic != null)
                {
                    targetGraphic.raycastTarget = item.targetRaycastTarget != "0";
                    targetGraphic.enabled = true;
                    targetGraphic.SetAllDirty();
                }
            }

            if (targetGraphic == null)
            {
                rows.Add(Row("target_graphic_missing", buttonTransform, item, targetTransform, "target transform matched but no Graphic-compatible component exists"));
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
            rows.Add(Row("original_button_target_graphic_bound", buttonTransform, item, targetTransform, "Button root and targetGraphic are mapped from original m_TargetGraphic PPtr; no fake onClick"));
        }

        result.removedHeuristicButtonCount = RemoveHeuristicButtons(originalButtonPaths, rows);
        Canvas.ForceUpdateCanvases();
        SnapshotCounts(result, "after");
        result.raycastReadyButtonCount = ValidateButtonRaycasts(rows, camera);

        EditorSceneManager.SaveScene(scene, ScenePath);
        result.sceneSaved = File.Exists(ProjectPath(ScenePath));
        Capture(camera, ProjectPath(CapturePath));
        result.captureExists = File.Exists(ProjectPath(CapturePath));

        var reopened = EditorSceneManager.OpenScene(ScenePath, OpenSceneMode.Single);
        result.reopenValid = reopened.IsValid();
        SnapshotCounts(result, "reopen");
        result.reopenRaycastReadyButtonCount = ValidateButtonRaycasts(rows, FindCaptureCamera());
        result.reopenEventSystemCount = UnityEngine.Object.FindObjectsOfType<EventSystem>(true).Length;

        WriteOutputs(result, rows);
        AssetDatabase.Refresh();
        Debug.Log("BATTLE44 original Button targetGraphic trace complete. patched=" + result.patchedButtonCount + ", reopenReady=" + result.reopenRaycastReadyButtonCount);
    }

    private static List<Battle44ManifestRow> LoadManifest(string path)
    {
        var rows = new List<Battle44ManifestRow>();
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
            var row = new Battle44ManifestRow();
            row.originalButtonPath = Get(map, "originalButtonPath");
            row.buttonSuffix = Get(map, "buttonSuffix");
            row.targetGraphicRef = Get(map, "targetGraphicRef");
            row.targetFullName = Get(map, "targetFullName");
            row.originalTargetPath = Get(map, "originalTargetPath");
            row.targetSuffix = Get(map, "targetSuffix");
            row.targetRaycastTarget = Get(map, "targetRaycastTarget");
            row.targetColor = Get(map, "targetColor");
            row.buttonComponentPathId = Get(map, "buttonComponentPathId");
            row.targetComponentPathId = Get(map, "targetComponentPathId");
            row.buttonSizeDelta = Get(map, "buttonSizeDelta");
            row.targetSizeDelta = Get(map, "targetSizeDelta");
            rows.Add(row);
        }
        return rows;
    }

    private static int RemoveHeuristicButtons(HashSet<string> originalButtonPaths, List<Battle44Row> rows)
    {
        int removed = 0;
        foreach (var button in UnityEngine.Object.FindObjectsOfType<Button>(true))
        {
            if (button == null) continue;
            string path = HierarchyPath(button.transform);
            if (originalButtonPaths.Contains(path)) continue;
            if (!LooksLikeBattle43Heuristic(path)) continue;
            rows.Add(Row("battle43_child_image_button_removed", button.transform, null, button.targetGraphic != null ? button.targetGraphic.transform : null, "removed BATTLE43 child-Image heuristic Button before applying original Button root mapping"));
            UnityEngine.Object.DestroyImmediate(button);
            removed++;
        }
        return removed;
    }

    private static bool LooksLikeBattle43Heuristic(string path)
    {
        return path.IndexOf("/btn", StringComparison.OrdinalIgnoreCase) >= 0 ||
               path.IndexOf("/BT_", StringComparison.OrdinalIgnoreCase) >= 0 ||
               path.IndexOf("btn_box", StringComparison.OrdinalIgnoreCase) >= 0;
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

    private static bool EnsureEventSystem()
    {
        if (UnityEngine.Object.FindObjectOfType<EventSystem>(true) != null) return false;
        var go = new GameObject("BATTLE44_EvidenceBackedEventSystem");
        go.AddComponent<EventSystem>();
        go.AddComponent<StandaloneInputModule>();
        return true;
    }

    private static int AddGraphicRaycasters(List<Battle44Row> rows)
    {
        int count = 0;
        foreach (var canvas in UnityEngine.Object.FindObjectsOfType<Canvas>(true))
        {
            if (!canvas.gameObject.activeInHierarchy) continue;
            if (canvas.GetComponent<GraphicRaycaster>() != null) continue;
            canvas.gameObject.AddComponent<GraphicRaycaster>();
            rows.Add(Row("graphic_raycaster_added", canvas.transform, null, null, "active Canvas needs GraphicRaycaster for original Button targetGraphic validation"));
            count++;
        }
        return count;
    }

    private static int ValidateButtonRaycasts(List<Battle44Row> rows, Camera camera)
    {
        int ready = 0;
        var reasons = new Dictionary<string, int>();
        var eventSystem = UnityEngine.Object.FindObjectOfType<EventSystem>(true);
        foreach (var button in UnityEngine.Object.FindObjectsOfType<Button>(true))
        {
            if (button == null || !button.gameObject.activeInHierarchy || !button.interactable || button.targetGraphic == null) continue;
            var probe = ProbeButtonRaycast(button, camera, eventSystem);
            if (probe.targetHit) ready++;
            if (!reasons.ContainsKey(probe.reason)) reasons[probe.reason] = 0;
            reasons[probe.reason]++;
            rows.Add(Row(probe.targetHit ? "button_raycast_ready" : "button_raycast_miss", button.transform, null, button.targetGraphic.transform,
                "screen=" + probe.screen + "; hitCount=" + probe.hitCount + "; topHit=" + probe.topHitPath + "; hits=" + probe.firstHits + "; eventCamera=" + probe.eventCameraName + "; reason=" + probe.reason));
        }
        raycastFailureReasons = reasons;
        return ready;
    }

    private static Dictionary<string, int> raycastFailureReasons = new Dictionary<string, int>();

    private static Battle44RaycastProbe ProbeButtonRaycast(Button button, Camera camera, EventSystem eventSystem)
    {
        var probe = new Battle44RaycastProbe();
        if (eventSystem == null)
        {
            probe.reason = "missing_event_system";
            return probe;
        }
        var targetRect = button.targetGraphic != null ? button.targetGraphic.transform as RectTransform : null;
        if (targetRect == null)
        {
            probe.reason = "missing_target_rect_transform";
            return probe;
        }
        var canvas = button.GetComponentInParent<Canvas>(true);
        if (canvas == null)
        {
            probe.reason = "missing_parent_canvas";
            return probe;
        }
        var raycaster = canvas.GetComponent<GraphicRaycaster>();
        if (raycaster == null)
        {
            probe.reason = "missing_graphic_raycaster";
            return probe;
        }
        Camera eventCamera = canvas.renderMode == RenderMode.ScreenSpaceOverlay ? null : raycaster.eventCamera;
        if (eventCamera == null && canvas.renderMode != RenderMode.ScreenSpaceOverlay) eventCamera = canvas.worldCamera != null ? canvas.worldCamera : camera;
        probe.eventCameraName = eventCamera != null ? eventCamera.name : "(overlay/null)";
        Vector2 screen = RectTransformUtility.WorldToScreenPoint(eventCamera, targetRect.TransformPoint(targetRect.rect.center));
        probe.screen = screen.x.ToString("0.###") + "/" + screen.y.ToString("0.###");
        var data = new PointerEventData(eventSystem);
        data.position = screen;
        var hits = new List<RaycastResult>();
        raycaster.Raycast(data, hits);
        probe.hitCount = hits.Count;
        var firstHits = new List<string>();
        foreach (var hit in hits)
        {
            if (hit.gameObject == null) continue;
            if (firstHits.Count < 5) firstHits.Add(HierarchyPath(hit.gameObject.transform));
            if (probe.topHitPath.Length == 0) probe.topHitPath = HierarchyPath(hit.gameObject.transform);
            if (hit.gameObject == button.targetGraphic.gameObject || hit.gameObject.transform.IsChildOf(button.transform)) probe.targetHit = true;
        }
        probe.firstHits = string.Join(" | ", firstHits.ToArray());
        probe.reason = probe.targetHit ? "target_hit" : (hits.Count == 0 ? "no_graphic_hits_at_target_center" : "target_not_in_graphic_hits");
        return probe;
    }

    private static void SnapshotCounts(Battle44Result result, string phase)
    {
        int canvasCount = UnityEngine.Object.FindObjectsOfType<Canvas>(true).Length;
        int raycasterCount = UnityEngine.Object.FindObjectsOfType<GraphicRaycaster>(true).Length;
        int imageCount = UnityEngine.Object.FindObjectsOfType<Image>(true).Length;
        int graphicCount = UnityEngine.Object.FindObjectsOfType<Graphic>(true).Length;
        int buttonCount = UnityEngine.Object.FindObjectsOfType<Button>(true).Length;
        int emptyCount = UnityEngine.Object.FindObjectsOfType<Empty4Raycast>(true).Length;
        int activeGraphicCount = CountActiveGraphics();
        int maskCount = UnityEngine.Object.FindObjectsOfType<Mask>(true).Length;
        int rectMaskCount = UnityEngine.Object.FindObjectsOfType<RectMask2D>(true).Length;
        int textCount = UnityEngine.Object.FindObjectsOfType<Text>(true).Length;
        int tmpCount = UnityEngine.Object.FindObjectsOfType<TMP_Text>(true).Length;
        int missingScriptCount = CountMissingScripts();

        if (phase == "before")
        {
            result.beforeCanvasCount = canvasCount;
            result.beforeGraphicRaycasterCount = raycasterCount;
            result.beforeImageCount = imageCount;
            result.beforeGraphicCount = graphicCount;
            result.beforeButtonCount = buttonCount;
            result.beforeEmpty4RaycastCount = emptyCount;
            result.beforeActiveGraphicCount = activeGraphicCount;
            result.beforeMaskCount = maskCount;
            result.beforeRectMask2DCount = rectMaskCount;
            result.beforeTextCount = textCount;
            result.beforeTmpCount = tmpCount;
            result.beforeMissingScriptCount = missingScriptCount;
            return;
        }
        if (phase == "after")
        {
            result.afterCanvasCount = canvasCount;
            result.afterGraphicRaycasterCount = raycasterCount;
            result.afterImageCount = imageCount;
            result.afterGraphicCount = graphicCount;
            result.afterButtonCount = buttonCount;
            result.afterEmpty4RaycastCount = emptyCount;
            result.afterActiveGraphicCount = activeGraphicCount;
            result.afterMaskCount = maskCount;
            result.afterRectMask2DCount = rectMaskCount;
            result.afterTextCount = textCount;
            result.afterTmpCount = tmpCount;
            result.afterMissingScriptCount = missingScriptCount;
            return;
        }
        result.reopenCanvasCount = canvasCount;
        result.reopenGraphicRaycasterCount = raycasterCount;
        result.reopenImageCount = imageCount;
        result.reopenGraphicCount = graphicCount;
        result.reopenButtonCount = buttonCount;
        result.reopenEmpty4RaycastCount = emptyCount;
        result.reopenActiveGraphicCount = activeGraphicCount;
        result.reopenMaskCount = maskCount;
        result.reopenRectMask2DCount = rectMaskCount;
        result.reopenTextCount = textCount;
        result.reopenTmpCount = tmpCount;
        result.reopenMissingScriptCount = missingScriptCount;
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
        var go = new GameObject("BATTLE44_FallbackCaptureCamera");
        var cam = go.AddComponent<Camera>();
        return cam;
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

    private static Battle44Row Row(string status, Transform buttonTransform, Battle44ManifestRow manifest, Transform targetTransform, string evidence)
    {
        var row = new Battle44Row();
        row.status = status;
        row.buttonScenePath = buttonTransform != null ? HierarchyPath(buttonTransform) : "";
        row.targetScenePath = targetTransform != null ? HierarchyPath(targetTransform) : "";
        if (manifest != null)
        {
            row.originalButtonPath = manifest.originalButtonPath;
            row.buttonSuffix = manifest.buttonSuffix;
            row.originalTargetPath = manifest.originalTargetPath;
            row.targetSuffix = manifest.targetSuffix;
            row.targetFullName = manifest.targetFullName;
            row.targetGraphicRef = manifest.targetGraphicRef;
            row.buttonComponentPathId = manifest.buttonComponentPathId;
            row.targetComponentPathId = manifest.targetComponentPathId;
            row.originalButtonSizeDelta = manifest.buttonSizeDelta;
            row.originalTargetSizeDelta = manifest.targetSizeDelta;
        }
        if (buttonTransform != null)
        {
            row.buttonActiveInHierarchy = buttonTransform.gameObject.activeInHierarchy;
            var rect = buttonTransform as RectTransform;
            if (rect != null)
            {
                row.sceneButtonRectSize = Vec2(rect.rect.size);
                row.sceneButtonAnchoredPosition = Vec2(rect.anchoredPosition);
            }
            var button = buttonTransform.GetComponent<Button>();
            row.hasButton = button != null;
            row.buttonInteractable = button != null && button.interactable;
            if (button != null && button.targetGraphic != null)
            {
                row.boundTargetGraphicPath = HierarchyPath(button.targetGraphic.transform);
                row.boundTargetGraphicType = button.targetGraphic.GetType().FullName;
                row.boundTargetRaycastTarget = button.targetGraphic.raycastTarget;
            }
        }
        if (targetTransform != null)
        {
            var targetRect = targetTransform as RectTransform;
            if (targetRect != null)
            {
                row.sceneTargetRectSize = Vec2(targetRect.rect.size);
                row.sceneTargetAnchoredPosition = Vec2(targetRect.anchoredPosition);
            }
        }
        row.evidence = evidence;
        return row;
    }

    private static void WriteOutputs(Battle44Result result, List<Battle44Row> rows)
    {
        WriteRowsCsv(ProjectPath(RowsCsvPath), rows);
        WriteJson(ProjectPath(ResultJsonPath), result);
    }

    private static void WriteRowsCsv(string path, List<Battle44Row> rows)
    {
        Directory.CreateDirectory(Path.GetDirectoryName(path));
        var sb = new StringBuilder();
        sb.AppendLine("status,originalButtonPath,buttonSuffix,buttonScenePath,buttonComponentPathId,targetGraphicRef,targetFullName,originalTargetPath,targetSuffix,targetScenePath,targetComponentPathId,originalButtonSizeDelta,sceneButtonRectSize,sceneButtonAnchoredPosition,originalTargetSizeDelta,sceneTargetRectSize,sceneTargetAnchoredPosition,hasButton,buttonInteractable,boundTargetGraphicPath,boundTargetGraphicType,boundTargetRaycastTarget,evidence");
        foreach (var r in rows)
        {
            sb.AppendLine(string.Join(",", new[]
            {
                Csv(r.status), Csv(r.originalButtonPath), Csv(r.buttonSuffix), Csv(r.buttonScenePath), Csv(r.buttonComponentPathId),
                Csv(r.targetGraphicRef), Csv(r.targetFullName), Csv(r.originalTargetPath), Csv(r.targetSuffix), Csv(r.targetScenePath), Csv(r.targetComponentPathId),
                Csv(r.originalButtonSizeDelta), Csv(r.sceneButtonRectSize), Csv(r.sceneButtonAnchoredPosition),
                Csv(r.originalTargetSizeDelta), Csv(r.sceneTargetRectSize), Csv(r.sceneTargetAnchoredPosition),
                Bool(r.hasButton), Bool(r.buttonInteractable), Csv(r.boundTargetGraphicPath), Csv(r.boundTargetGraphicType), Bool(r.boundTargetRaycastTarget), Csv(r.evidence)
            }));
        }
        File.WriteAllText(path, sb.ToString(), new UTF8Encoding(false));
    }

    private static void WriteJson(string path, Battle44Result r)
    {
        Directory.CreateDirectory(Path.GetDirectoryName(path));
        var sb = new StringBuilder();
        sb.AppendLine("{");
        sb.AppendLine("  \"status\": \"battle44_trace_original_button_monoscript_and_target_graphic_serialization\",");
        sb.AppendLine("  \"isFinalRestoredBattleScreen\": false,");
        sb.AppendLine("  \"sourceScene\": \"" + Json(r.sourceScene) + "\",");
        sb.AppendLine("  \"scene\": \"" + Json(r.scene) + "\",");
        sb.AppendLine("  \"capture\": \"" + Json(r.capture) + "\",");
        sb.AppendLine("  \"sourceSceneOpened\": " + Bool(r.sourceSceneOpened) + ",");
        sb.AppendLine("  \"sceneSaved\": " + Bool(r.sceneSaved) + ",");
        sb.AppendLine("  \"captureExists\": " + Bool(r.captureExists) + ",");
        sb.AppendLine("  \"reopenValid\": " + Bool(r.reopenValid) + ",");
        sb.AppendLine("  \"patchManifestCount\": " + r.patchManifestCount + ",");
        sb.AppendLine("  \"matchedButtonCount\": " + r.matchedButtonCount + ",");
        sb.AppendLine("  \"patchedButtonCount\": " + r.patchedButtonCount + ",");
        sb.AppendLine("  \"buttonAddedCount\": " + r.buttonAddedCount + ",");
        sb.AppendLine("  \"empty4RaycastAddedCount\": " + r.empty4RaycastAddedCount + ",");
        sb.AppendLine("  \"removedHeuristicButtonCount\": " + r.removedHeuristicButtonCount + ",");
        sb.AppendLine("  \"eventSystemAdded\": " + Bool(r.eventSystemAdded) + ",");
        sb.AppendLine("  \"graphicRaycasterAddedCount\": " + r.graphicRaycasterAddedCount + ",");
        sb.AppendLine("  \"raycastReadyButtonCount\": " + r.raycastReadyButtonCount + ",");
        sb.AppendLine("  \"reopenRaycastReadyButtonCount\": " + r.reopenRaycastReadyButtonCount + ",");
        sb.AppendLine("  \"reopenEventSystemCount\": " + r.reopenEventSystemCount + ",");
        sb.AppendLine("  \"raycastFailureReasons\": " + DictionaryJson(raycastFailureReasons) + ",");
        sb.AppendLine("  \"before\": " + CountsJson(r, "before") + ",");
        sb.AppendLine("  \"after\": " + CountsJson(r, "after") + ",");
        sb.AppendLine("  \"reopen\": " + CountsJson(r, "reopen") + ",");
        sb.AppendLine("  \"reopenButtonCount\": " + r.reopenButtonCount + ",");
        sb.AppendLine("  \"reopenMaskCount\": " + r.reopenMaskCount + ",");
        sb.AppendLine("  \"reopenRectMask2DCount\": " + r.reopenRectMask2DCount + ",");
        sb.AppendLine("  \"reopenTmpCount\": " + r.reopenTmpCount + ",");
        sb.AppendLine("  \"reopenTextCount\": " + r.reopenTextCount + ",");
        sb.AppendLine("  \"failReason\": \"" + Json(r.failReason) + "\"");
        sb.AppendLine("}");
        File.WriteAllText(path, sb.ToString(), new UTF8Encoding(false));
    }

    private static string CountsJson(Battle44Result r, string phase)
    {
        if (phase == "before")
            return "{\"canvas\":" + r.beforeCanvasCount + ",\"graphicRaycaster\":" + r.beforeGraphicRaycasterCount + ",\"image\":" + r.beforeImageCount + ",\"graphic\":" + r.beforeGraphicCount + ",\"activeGraphic\":" + r.beforeActiveGraphicCount + ",\"button\":" + r.beforeButtonCount + ",\"empty4Raycast\":" + r.beforeEmpty4RaycastCount + ",\"mask\":" + r.beforeMaskCount + ",\"rectMask2D\":" + r.beforeRectMask2DCount + ",\"text\":" + r.beforeTextCount + ",\"tmp\":" + r.beforeTmpCount + ",\"missingScript\":" + r.beforeMissingScriptCount + "}";
        if (phase == "after")
            return "{\"canvas\":" + r.afterCanvasCount + ",\"graphicRaycaster\":" + r.afterGraphicRaycasterCount + ",\"image\":" + r.afterImageCount + ",\"graphic\":" + r.afterGraphicCount + ",\"activeGraphic\":" + r.afterActiveGraphicCount + ",\"button\":" + r.afterButtonCount + ",\"empty4Raycast\":" + r.afterEmpty4RaycastCount + ",\"mask\":" + r.afterMaskCount + ",\"rectMask2D\":" + r.afterRectMask2DCount + ",\"text\":" + r.afterTextCount + ",\"tmp\":" + r.afterTmpCount + ",\"missingScript\":" + r.afterMissingScriptCount + "}";
        return "{\"canvas\":" + r.reopenCanvasCount + ",\"graphicRaycaster\":" + r.reopenGraphicRaycasterCount + ",\"image\":" + r.reopenImageCount + ",\"graphic\":" + r.reopenGraphicCount + ",\"activeGraphic\":" + r.reopenActiveGraphicCount + ",\"button\":" + r.reopenButtonCount + ",\"empty4Raycast\":" + r.reopenEmpty4RaycastCount + ",\"mask\":" + r.reopenMaskCount + ",\"rectMask2D\":" + r.reopenRectMask2DCount + ",\"text\":" + r.reopenTextCount + ",\"tmp\":" + r.reopenTmpCount + ",\"missingScript\":" + r.reopenMissingScriptCount + "}";
    }

    private static string DictionaryJson(Dictionary<string, int> dict)
    {
        var parts = new List<string>();
        foreach (var kv in dict) parts.Add("\"" + Json(kv.Key) + "\":" + kv.Value);
        return "{" + string.Join(",", parts.ToArray()) + "}";
    }

    private static List<string> SplitCsvLine(string line)
    {
        var values = new List<string>();
        var sb = new StringBuilder();
        bool quote = false;
        for (int i = 0; i < line.Length; i++)
        {
            char c = line[i];
            if (quote && c == '"' && i + 1 < line.Length && line[i + 1] == '"')
            {
                sb.Append('"');
                i++;
            }
            else if (c == '"')
            {
                quote = !quote;
            }
            else if (c == ',' && !quote)
            {
                values.Add(sb.ToString());
                sb.Length = 0;
            }
            else
            {
                sb.Append(c);
            }
        }
        values.Add(sb.ToString());
        return values;
    }

    private static string Get(Dictionary<string, string> map, string key) { return map.ContainsKey(key) ? map[key] : ""; }

    private static Color ParseColor(string value, Color fallback)
    {
        if (string.IsNullOrEmpty(value)) return fallback;
        var parts = value.Split('/');
        if (parts.Length != 4) return fallback;
        float r, g, b, a;
        if (!float.TryParse(parts[0], NumberStyles.Float, CultureInfo.InvariantCulture, out r)) return fallback;
        if (!float.TryParse(parts[1], NumberStyles.Float, CultureInfo.InvariantCulture, out g)) return fallback;
        if (!float.TryParse(parts[2], NumberStyles.Float, CultureInfo.InvariantCulture, out b)) return fallback;
        if (!float.TryParse(parts[3], NumberStyles.Float, CultureInfo.InvariantCulture, out a)) return fallback;
        return new Color(r, g, b, a);
    }

    private static string HierarchyPath(Transform transform)
    {
        var names = new List<string>();
        var cursor = transform;
        while (cursor != null)
        {
            names.Add(cursor.name);
            cursor = cursor.parent;
        }
        names.Reverse();
        return string.Join("/", names.ToArray());
    }

    private static string ProjectPath(string assetPath) { return Path.Combine(Application.dataPath, "..", assetPath.Replace("/", "\\")); }
    private static string Vec2(Vector2 v) { return v.x.ToString("0.###") + "/" + v.y.ToString("0.###"); }
    private static string Bool(bool value) { return value ? "true" : "false"; }
    private static string Json(string value) { return (value ?? "").Replace("\\", "\\\\").Replace("\"", "\\\"").Replace("\r", " ").Replace("\n", " "); }
    private static string Csv(string value) { return "\"" + (value ?? "").Replace("\"", "\"\"") + "\""; }

    private sealed class Battle44ManifestRow
    {
        public string originalButtonPath = "";
        public string buttonSuffix = "";
        public string targetGraphicRef = "";
        public string targetFullName = "";
        public string originalTargetPath = "";
        public string targetSuffix = "";
        public string targetRaycastTarget = "";
        public string targetColor = "";
        public string buttonComponentPathId = "";
        public string targetComponentPathId = "";
        public string buttonSizeDelta = "";
        public string targetSizeDelta = "";
    }

    private sealed class Battle44Result
    {
        public bool isFinalRestoredBattleScreen;
        public string sourceScene = "";
        public string scene = "";
        public string capture = "";
        public bool sourceSceneOpened, sceneSaved, captureExists, reopenValid, eventSystemAdded;
        public string failReason = "";
        public int patchManifestCount, matchedButtonCount, patchedButtonCount, buttonAddedCount, empty4RaycastAddedCount, removedHeuristicButtonCount, graphicRaycasterAddedCount, raycastReadyButtonCount, reopenRaycastReadyButtonCount, reopenEventSystemCount;
        public int beforeCanvasCount, beforeGraphicRaycasterCount, beforeImageCount, beforeGraphicCount, beforeActiveGraphicCount, beforeButtonCount, beforeEmpty4RaycastCount, beforeMaskCount, beforeRectMask2DCount, beforeTextCount, beforeTmpCount, beforeMissingScriptCount;
        public int afterCanvasCount, afterGraphicRaycasterCount, afterImageCount, afterGraphicCount, afterActiveGraphicCount, afterButtonCount, afterEmpty4RaycastCount, afterMaskCount, afterRectMask2DCount, afterTextCount, afterTmpCount, afterMissingScriptCount;
        public int reopenCanvasCount, reopenGraphicRaycasterCount, reopenImageCount, reopenGraphicCount, reopenActiveGraphicCount, reopenButtonCount, reopenEmpty4RaycastCount, reopenMaskCount, reopenRectMask2DCount, reopenTextCount, reopenTmpCount, reopenMissingScriptCount;
    }

    private sealed class Battle44Row
    {
        public string status = "";
        public string originalButtonPath = "";
        public string buttonSuffix = "";
        public string buttonScenePath = "";
        public string buttonComponentPathId = "";
        public string targetGraphicRef = "";
        public string targetFullName = "";
        public string originalTargetPath = "";
        public string targetSuffix = "";
        public string targetScenePath = "";
        public string targetComponentPathId = "";
        public string originalButtonSizeDelta = "";
        public string sceneButtonRectSize = "";
        public string sceneButtonAnchoredPosition = "";
        public string originalTargetSizeDelta = "";
        public string sceneTargetRectSize = "";
        public string sceneTargetAnchoredPosition = "";
        public bool buttonActiveInHierarchy;
        public bool hasButton;
        public bool buttonInteractable;
        public string boundTargetGraphicPath = "";
        public string boundTargetGraphicType = "";
        public bool boundTargetRaycastTarget;
        public string evidence = "";
    }

    private sealed class Battle44RaycastProbe
    {
        public bool targetHit;
        public int hitCount;
        public string screen = "";
        public string eventCameraName = "";
        public string topHitPath = "";
        public string firstHits = "";
        public string reason = "";
    }
}
