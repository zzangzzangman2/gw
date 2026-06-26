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

public static class Battle43ValidateMaskStencilTmpButtonRuntimeFormationSkillBindingEditor
{
    private const string SourceScenePath = "Assets/Scenes/Battle42PersistentBattleHudImagesFromOriginalSpriteEvidence.unity";
    private const string ScenePath = "Assets/Scenes/Battle43PlayableContextValidationCandidate.unity";
    private const string ResultJsonPath = "Assets/RestoreData/battle/BATTLE_43_VALIDATE_MASK_STENCIL_TMP_BUTTON_AND_RUNTIME_FORMATION_SKILL_BINDING_UNITY.json";
    private const string RowsCsvPath = "Assets/RestoreData/battle/BATTLE_43_VALIDATE_MASK_STENCIL_TMP_BUTTON_AND_RUNTIME_FORMATION_SKILL_BINDING_COMPONENTS.csv";
    private const string CapturePath = "Assets/RestoreCaptures/battle_actor/Battle43PlayableContextValidationCandidate_1920x1080.png";
    private const int CaptureWidth = 1920;
    private const int CaptureHeight = 1080;

    [MenuItem("GirlsWar/Battle/BATTLE43 Validate Mask Stencil TMP Button Runtime Formation Skill Binding")]
    public static void Build()
    {
        Directory.CreateDirectory(ProjectPath("Assets/RestoreData/battle"));
        Directory.CreateDirectory(ProjectPath("Assets/RestoreCaptures/battle_actor"));
        var rows = new List<Battle43Row>();
        var result = new Battle43Result();
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

        var scene = EditorSceneManager.OpenScene(SourceScenePath, OpenSceneMode.Single);
        result.sourceSceneOpened = scene.IsValid();
        var camera = FindCaptureCamera();
        if (camera == null) camera = CreateFallbackCamera();
        ConfigureCamera(camera);

        SnapshotCounts(result, "before");
        result.maskLikeTransformCount = CountMaskLikeTransforms(rows);
        result.buttonLikeActiveImageCount = CountButtonLikeActiveImages(rows);
        result.heroCardRootCount = CountTransformsContaining("Battle29BoundHeroCard");
        result.heroListContainerCount = CountTransformsContaining("HeroListContainer");
        result.actorRuntimeRootCount = CountTransformsContaining("Battle39RuntimeActor") + CountTransformsContaining("Battle38Actor");

        result.eventSystemAdded = EnsureEventSystem();
        result.graphicRaycasterAddedCount = AddGraphicRaycasters(rows);
        result.buttonAddedCount = AddEvidenceBackedButtonCandidates(rows);
        Canvas.ForceUpdateCanvases();
        result.raycastReadyButtonCount = ValidateButtonRaycasts(rows, camera);

        SnapshotCounts(result, "after");
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
        Debug.Log("BATTLE43 playable context validation complete. buttons=" + result.reopenButtonCount + ", raycastReady=" + result.reopenRaycastReadyButtonCount);
    }

    private static void SnapshotCounts(Battle43Result result, string phase)
    {
        int canvasCount = UnityEngine.Object.FindObjectsOfType<Canvas>(true).Length;
        int scalerCount = UnityEngine.Object.FindObjectsOfType<CanvasScaler>(true).Length;
        int raycasterCount = UnityEngine.Object.FindObjectsOfType<GraphicRaycaster>(true).Length;
        int imageCount = UnityEngine.Object.FindObjectsOfType<Image>(true).Length;
        int graphicCount = UnityEngine.Object.FindObjectsOfType<Graphic>(true).Length;
        int buttonCount = UnityEngine.Object.FindObjectsOfType<Button>(true).Length;
        int activeButtonCount = CountActiveButtons();
        int activeGraphicCount = CountActiveGraphics();
        int maskCount = UnityEngine.Object.FindObjectsOfType<Mask>(true).Length;
        int rectMaskCount = UnityEngine.Object.FindObjectsOfType<RectMask2D>(true).Length;
        int stencilMaterialCount = CountStencilMaterials();
        int textCount = UnityEngine.Object.FindObjectsOfType<Text>(true).Length;
        int tmpCount = UnityEngine.Object.FindObjectsOfType<TMP_Text>(true).Length;
        int missingScriptCount = CountMissingScripts();

        if (phase == "before")
        {
            result.beforeCanvasCount = canvasCount;
            result.beforeCanvasScalerCount = scalerCount;
            result.beforeGraphicRaycasterCount = raycasterCount;
            result.beforeImageCount = imageCount;
            result.beforeGraphicCount = graphicCount;
            result.beforeButtonCount = buttonCount;
            result.beforeActiveButtonCount = activeButtonCount;
            result.beforeActiveGraphicCount = activeGraphicCount;
            result.beforeMaskCount = maskCount;
            result.beforeRectMask2DCount = rectMaskCount;
            result.beforeStencilMaterialCount = stencilMaterialCount;
            result.beforeTextCount = textCount;
            result.beforeTmpCount = tmpCount;
            result.beforeMissingScriptCount = missingScriptCount;
            return;
        }
        if (phase == "after")
        {
            result.afterCanvasCount = canvasCount;
            result.afterCanvasScalerCount = scalerCount;
            result.afterGraphicRaycasterCount = raycasterCount;
            result.afterImageCount = imageCount;
            result.afterGraphicCount = graphicCount;
            result.afterButtonCount = buttonCount;
            result.afterActiveButtonCount = activeButtonCount;
            result.afterActiveGraphicCount = activeGraphicCount;
            result.afterMaskCount = maskCount;
            result.afterRectMask2DCount = rectMaskCount;
            result.afterStencilMaterialCount = stencilMaterialCount;
            result.afterTextCount = textCount;
            result.afterTmpCount = tmpCount;
            result.afterMissingScriptCount = missingScriptCount;
            return;
        }
        result.reopenCanvasCount = canvasCount;
        result.reopenCanvasScalerCount = scalerCount;
        result.reopenGraphicRaycasterCount = raycasterCount;
        result.reopenImageCount = imageCount;
        result.reopenGraphicCount = graphicCount;
        result.reopenButtonCount = buttonCount;
        result.reopenActiveButtonCount = activeButtonCount;
        result.reopenActiveGraphicCount = activeGraphicCount;
        result.reopenMaskCount = maskCount;
        result.reopenRectMask2DCount = rectMaskCount;
        result.reopenStencilMaterialCount = stencilMaterialCount;
        result.reopenTextCount = textCount;
        result.reopenTmpCount = tmpCount;
        result.reopenMissingScriptCount = missingScriptCount;
    }

    private static bool EnsureEventSystem()
    {
        if (UnityEngine.Object.FindObjectOfType<EventSystem>(true) != null) return false;
        var go = new GameObject("BATTLE43_EvidenceBackedEventSystem");
        go.AddComponent<EventSystem>();
        go.AddComponent<StandaloneInputModule>();
        return true;
    }

    private static int AddGraphicRaycasters(List<Battle43Row> rows)
    {
        int count = 0;
        foreach (var canvas in UnityEngine.Object.FindObjectsOfType<Canvas>(true))
        {
            if (!canvas.gameObject.activeInHierarchy) continue;
            if (canvas.GetComponent<GraphicRaycaster>() != null) continue;
            canvas.gameObject.AddComponent<GraphicRaycaster>();
            count++;
            rows.Add(Row("graphic_raycaster_added", canvas.transform, "UnityEngine.UI.GraphicRaycaster", "BATTLE_UI_COMPONENT_TYPE_EVIDENCE.csv count=14; active ScreenSpaceCamera canvas needs raycast"));
        }
        return count;
    }

    private static int AddEvidenceBackedButtonCandidates(List<Battle43Row> rows)
    {
        int count = 0;
        foreach (var image in UnityEngine.Object.FindObjectsOfType<Image>(true))
        {
            if (image == null || !image.gameObject.activeInHierarchy) continue;
            if (!IsButtonLike(image.transform)) continue;
            var button = image.GetComponent<Button>();
            if (button == null)
            {
                button = image.gameObject.AddComponent<Button>();
                count++;
            }
            image.raycastTarget = true;
            button.targetGraphic = image;
            button.interactable = true;
            button.transition = Selectable.Transition.None;
            rows.Add(Row("button_candidate_bound", image.transform, "UnityEngine.UI.Button", "name/path button-like; BATTLE_UI_COMPONENT_TYPE_EVIDENCE.csv Button count=33; no fake handler attached"));
        }
        return count;
    }

    private static int ValidateButtonRaycasts(List<Battle43Row> rows, Camera camera)
    {
        int ready = 0;
        var eventSystem = UnityEngine.Object.FindObjectOfType<EventSystem>(true);
        foreach (var button in UnityEngine.Object.FindObjectsOfType<Button>(true))
        {
            if (button == null || !button.gameObject.activeInHierarchy || !button.interactable || button.targetGraphic == null) continue;
            var probe = ProbeButtonRaycast(button, camera, eventSystem);
            if (probe.targetHit) ready++;
            rows.Add(Row(probe.targetHit ? "button_raycast_ready" : "button_raycast_miss", button.transform, "UnityEngine.UI.Button",
                "component-only raycast validation; persistent Lua handler still missing; screen=" + probe.screen +
                "; hitCount=" + probe.hitCount +
                "; topHit=" + probe.topHitPath +
                "; hits=" + probe.firstHits +
                "; eventCamera=" + probe.eventCameraName +
                "; reason=" + probe.reason));
        }
        return ready;
    }

    private static Battle43RaycastProbe ProbeButtonRaycast(Button button, Camera camera, EventSystem eventSystem)
    {
        var probe = new Battle43RaycastProbe();
        if (eventSystem == null)
        {
            probe.reason = "missing_event_system";
            return probe;
        }
        var rect = button.transform as RectTransform;
        if (rect == null)
        {
            probe.reason = "missing_rect_transform";
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
        Vector2 screen = RectTransformUtility.WorldToScreenPoint(eventCamera, rect.TransformPoint(rect.rect.center));
        probe.screen = screen.x.ToString("0.###") + "/" + screen.y.ToString("0.###");
        var data = new PointerEventData(eventSystem);
        data.position = screen;
        var hits = new List<RaycastResult>();
        raycaster.Raycast(data, hits);
        probe.hitCount = hits.Count;
        var firstHits = new List<string>();
        foreach (var hit in hits)
        {
            if (hit.gameObject != null)
            {
                if (firstHits.Count < 5) firstHits.Add(HierarchyPath(hit.gameObject.transform));
                if (probe.topHitPath.Length == 0) probe.topHitPath = HierarchyPath(hit.gameObject.transform);
                if (hit.gameObject == button.gameObject || hit.gameObject.transform.IsChildOf(button.transform)) probe.targetHit = true;
            }
        }
        probe.firstHits = string.Join(" | ", firstHits.ToArray());
        probe.reason = probe.targetHit ? "target_hit" : (hits.Count == 0 ? "no_graphic_hits_at_button_center" : "target_not_in_graphic_hits");
        return probe;
    }

    private static int CountMaskLikeTransforms(List<Battle43Row> rows)
    {
        int count = 0;
        foreach (var transform in UnityEngine.Object.FindObjectsOfType<Transform>(true))
        {
            string name = transform.name.ToLowerInvariant();
            if (!name.Contains("mask") && !name.Contains("headmask") && !name.Contains("imgheadmask")) continue;
            count++;
            rows.Add(Row("mask_like_transform", transform, "mask_candidate", "name evidence only; no Mask/RectMask2D patch applied"));
        }
        return count;
    }

    private static int CountButtonLikeActiveImages(List<Battle43Row> rows)
    {
        int count = 0;
        foreach (var image in UnityEngine.Object.FindObjectsOfType<Image>(true))
        {
            if (image != null && image.gameObject.activeInHierarchy && IsButtonLike(image.transform))
            {
                count++;
                rows.Add(Row("active_button_like_image", image.transform, "UnityEngine.UI.Image", "active button/control image candidate"));
            }
        }
        return count;
    }

    private static bool IsButtonLike(Transform transform)
    {
        string path = HierarchyPath(transform).ToLowerInvariant();
        string name = transform.name.ToLowerInvariant();
        return name.StartsWith("btn") ||
               name.StartsWith("bt_") ||
               name.Contains("btn") ||
               path.Contains("/btn") ||
               path.Contains("skip") ||
               path.Contains("zidong") ||
               path.Contains("auto") ||
               path.Contains("kuaijin") ||
               path.Contains("btnleftclosebuff") ||
               path.Contains("btnrightclosebuff");
    }

    private static Battle43Row Row(string status, Transform transform, string componentType, string evidence)
    {
        var row = new Battle43Row();
        row.status = status;
        row.path = HierarchyPath(transform);
        row.name = transform.name;
        row.activeSelf = transform.gameObject.activeSelf;
        row.activeInHierarchy = transform.gameObject.activeInHierarchy;
        row.componentTypes = ComponentTypes(transform);
        row.componentType = componentType;
        row.evidence = evidence;
        var rect = transform as RectTransform;
        if (rect != null)
        {
            row.hasRectTransform = true;
            row.rectSize = Vec2(rect.rect.size);
            row.anchoredPosition = Vec2(rect.anchoredPosition);
            row.anchorMin = Vec2(rect.anchorMin);
            row.anchorMax = Vec2(rect.anchorMax);
            row.pivot = Vec2(rect.pivot);
            row.localScale = Vec3(rect.localScale);
        }
        var graphic = transform.GetComponent<Graphic>();
        if (graphic != null)
        {
            row.hasGraphic = true;
            row.graphicType = graphic.GetType().FullName;
            row.raycastTarget = graphic.raycastTarget;
            row.color = ColorString(graphic.color);
            row.materialName = graphic.material != null ? graphic.material.name : "";
        }
        var button = transform.GetComponent<Button>();
        if (button != null)
        {
            row.hasButton = true;
            row.buttonInteractable = button.interactable;
            row.targetGraphicPath = button.targetGraphic != null ? HierarchyPath(button.targetGraphic.transform) : "";
        }
        var canvas = transform.GetComponentInParent<Canvas>(true);
        if (canvas != null)
        {
            row.canvasPath = HierarchyPath(canvas.transform);
            row.canvasRenderMode = canvas.renderMode.ToString();
            row.canvasWorldCameraName = canvas.worldCamera != null ? canvas.worldCamera.name : "";
            row.canvasSortingOrder = canvas.sortingOrder;
        }
        return row;
    }

    private static string ComponentTypes(Transform transform)
    {
        var names = new List<string>();
        foreach (var component in transform.GetComponents<Component>())
            names.Add(component == null ? "MissingScript" : (component.GetType().FullName ?? component.GetType().Name));
        return string.Join("|", names.ToArray());
    }

    private static Camera FindCaptureCamera()
    {
        var named = GameObject.Find("BattleHudSpriteAtlasTextureRuntimeBindingClip05Camera");
        if (named != null)
        {
            var camera = named.GetComponent<Camera>();
            if (camera != null) return camera;
        }
        if (Camera.main != null) return Camera.main;
        var cameras = UnityEngine.Object.FindObjectsOfType<Camera>(true);
        return cameras != null && cameras.Length > 0 ? cameras[0] : null;
    }

    private static Camera CreateFallbackCamera()
    {
        var go = new GameObject("BATTLE43_FallbackCaptureCamera");
        return go.AddComponent<Camera>();
    }

    private static void ConfigureCamera(Camera camera)
    {
        camera.orthographic = true;
        camera.orthographicSize = 5f;
        camera.clearFlags = CameraClearFlags.SolidColor;
        camera.backgroundColor = Color.black;
        camera.nearClipPlane = 0.01f;
        camera.farClipPlane = 100f;
        camera.cullingMask = ~0;
        camera.depth = 1000f;
        camera.transform.position = new Vector3(0f, 0f, -10f);
        camera.transform.rotation = Quaternion.identity;
    }

    private static void Capture(Camera camera, string fullPath)
    {
        Directory.CreateDirectory(Path.GetDirectoryName(fullPath));
        var rt = new RenderTexture(CaptureWidth, CaptureHeight, 24, RenderTextureFormat.ARGB32);
        var prevTarget = camera.targetTexture;
        var prevActive = RenderTexture.active;
        camera.targetTexture = rt;
        RenderTexture.active = rt;
        Canvas.ForceUpdateCanvases();
        camera.Render();
        var tex = new Texture2D(CaptureWidth, CaptureHeight, TextureFormat.RGB24, false);
        tex.ReadPixels(new Rect(0, 0, CaptureWidth, CaptureHeight), 0, 0);
        tex.Apply();
        File.WriteAllBytes(fullPath, tex.EncodeToPNG());
        camera.targetTexture = prevTarget;
        RenderTexture.active = prevActive;
        UnityEngine.Object.DestroyImmediate(tex);
        UnityEngine.Object.DestroyImmediate(rt);
    }

    private static int CountActiveButtons()
    {
        int count = 0;
        foreach (var button in UnityEngine.Object.FindObjectsOfType<Button>(true))
            if (button != null && button.gameObject.activeInHierarchy && button.interactable) count++;
        return count;
    }

    private static int CountActiveGraphics()
    {
        int count = 0;
        foreach (var graphic in UnityEngine.Object.FindObjectsOfType<Graphic>(true))
            if (graphic != null && graphic.enabled && graphic.gameObject.activeInHierarchy) count++;
        return count;
    }

    private static int CountStencilMaterials()
    {
        int count = 0;
        foreach (var graphic in UnityEngine.Object.FindObjectsOfType<Graphic>(true))
        {
            if (graphic == null || graphic.material == null) continue;
            if (graphic.material.HasProperty("_Stencil") && graphic.material.GetFloat("_Stencil") != 0f) count++;
        }
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

    private static int CountTransformsContaining(string text)
    {
        int count = 0;
        foreach (var transform in UnityEngine.Object.FindObjectsOfType<Transform>(true))
            if (HierarchyPath(transform).IndexOf(text, StringComparison.OrdinalIgnoreCase) >= 0) count++;
        return count;
    }

    private static void WriteOutputs(Battle43Result result, List<Battle43Row> rows)
    {
        WriteRowsCsv(ProjectPath(RowsCsvPath), rows);
        WriteJson(ProjectPath(ResultJsonPath), result);
    }

    private static void WriteRowsCsv(string path, List<Battle43Row> rows)
    {
        Directory.CreateDirectory(Path.GetDirectoryName(path));
        var sb = new StringBuilder();
        sb.AppendLine("status,path,name,componentType,activeSelf,activeInHierarchy,componentTypes,hasRectTransform,rectSize,anchoredPosition,anchorMin,anchorMax,pivot,localScale,canvasPath,canvasRenderMode,canvasWorldCameraName,canvasSortingOrder,hasGraphic,graphicType,raycastTarget,color,materialName,hasButton,buttonInteractable,targetGraphicPath,evidence");
        foreach (var r in rows)
        {
            sb.AppendLine(string.Join(",", new[]
            {
                Csv(r.status), Csv(r.path), Csv(r.name), Csv(r.componentType), Bool(r.activeSelf), Bool(r.activeInHierarchy), Csv(r.componentTypes),
                Bool(r.hasRectTransform), Csv(r.rectSize), Csv(r.anchoredPosition), Csv(r.anchorMin), Csv(r.anchorMax), Csv(r.pivot), Csv(r.localScale),
                Csv(r.canvasPath), Csv(r.canvasRenderMode), Csv(r.canvasWorldCameraName), r.canvasSortingOrder.ToString(),
                Bool(r.hasGraphic), Csv(r.graphicType), Bool(r.raycastTarget), Csv(r.color), Csv(r.materialName),
                Bool(r.hasButton), Bool(r.buttonInteractable), Csv(r.targetGraphicPath), Csv(r.evidence)
            }));
        }
        File.WriteAllText(path, sb.ToString(), new UTF8Encoding(false));
    }

    private static void WriteJson(string path, Battle43Result r)
    {
        Directory.CreateDirectory(Path.GetDirectoryName(path));
        var sb = new StringBuilder();
        sb.AppendLine("{");
        sb.AppendLine("  \"status\": \"battle43_validate_mask_stencil_tmp_button_and_runtime_formation_skill_binding\",");
        sb.AppendLine("  \"isFinalRestoredBattleScreen\": false,");
        sb.AppendLine("  \"sourceScene\": \"" + Json(r.sourceScene) + "\",");
        sb.AppendLine("  \"scene\": \"" + Json(r.scene) + "\",");
        sb.AppendLine("  \"capture\": \"" + Json(r.capture) + "\",");
        sb.AppendLine("  \"sourceSceneOpened\": " + Bool(r.sourceSceneOpened) + ",");
        sb.AppendLine("  \"sceneSaved\": " + Bool(r.sceneSaved) + ",");
        sb.AppendLine("  \"captureExists\": " + Bool(r.captureExists) + ",");
        sb.AppendLine("  \"reopenValid\": " + Bool(r.reopenValid) + ",");
        sb.AppendLine("  \"before\": " + CountsJson(r, "before") + ",");
        sb.AppendLine("  \"after\": " + CountsJson(r, "after") + ",");
        sb.AppendLine("  \"reopen\": " + CountsJson(r, "reopen") + ",");
        sb.AppendLine("  \"maskLikeTransformCount\": " + r.maskLikeTransformCount + ",");
        sb.AppendLine("  \"buttonLikeActiveImageCount\": " + r.buttonLikeActiveImageCount + ",");
        sb.AppendLine("  \"eventSystemAdded\": " + Bool(r.eventSystemAdded) + ",");
        sb.AppendLine("  \"graphicRaycasterAddedCount\": " + r.graphicRaycasterAddedCount + ",");
        sb.AppendLine("  \"buttonAddedCount\": " + r.buttonAddedCount + ",");
        sb.AppendLine("  \"raycastReadyButtonCount\": " + r.raycastReadyButtonCount + ",");
        sb.AppendLine("  \"reopenRaycastReadyButtonCount\": " + r.reopenRaycastReadyButtonCount + ",");
        sb.AppendLine("  \"reopenEventSystemCount\": " + r.reopenEventSystemCount + ",");
        sb.AppendLine("  \"heroCardRootCount\": " + r.heroCardRootCount + ",");
        sb.AppendLine("  \"heroListContainerCount\": " + r.heroListContainerCount + ",");
        sb.AppendLine("  \"actorRuntimeRootCount\": " + r.actorRuntimeRootCount + ",");
        sb.AppendLine("  \"failReason\": \"" + Json(r.failReason) + "\"");
        sb.AppendLine("}");
        File.WriteAllText(path, sb.ToString(), new UTF8Encoding(false));
    }

    private static string CountsJson(Battle43Result r, string phase)
    {
        if (phase == "before")
            return "{\"canvas\":" + r.beforeCanvasCount + ",\"canvasScaler\":" + r.beforeCanvasScalerCount + ",\"graphicRaycaster\":" + r.beforeGraphicRaycasterCount + ",\"image\":" + r.beforeImageCount + ",\"graphic\":" + r.beforeGraphicCount + ",\"activeGraphic\":" + r.beforeActiveGraphicCount + ",\"button\":" + r.beforeButtonCount + ",\"activeButton\":" + r.beforeActiveButtonCount + ",\"mask\":" + r.beforeMaskCount + ",\"rectMask2D\":" + r.beforeRectMask2DCount + ",\"stencilMaterial\":" + r.beforeStencilMaterialCount + ",\"text\":" + r.beforeTextCount + ",\"tmp\":" + r.beforeTmpCount + ",\"missingScript\":" + r.beforeMissingScriptCount + "}";
        if (phase == "after")
            return "{\"canvas\":" + r.afterCanvasCount + ",\"canvasScaler\":" + r.afterCanvasScalerCount + ",\"graphicRaycaster\":" + r.afterGraphicRaycasterCount + ",\"image\":" + r.afterImageCount + ",\"graphic\":" + r.afterGraphicCount + ",\"activeGraphic\":" + r.afterActiveGraphicCount + ",\"button\":" + r.afterButtonCount + ",\"activeButton\":" + r.afterActiveButtonCount + ",\"mask\":" + r.afterMaskCount + ",\"rectMask2D\":" + r.afterRectMask2DCount + ",\"stencilMaterial\":" + r.afterStencilMaterialCount + ",\"text\":" + r.afterTextCount + ",\"tmp\":" + r.afterTmpCount + ",\"missingScript\":" + r.afterMissingScriptCount + "}";
        return "{\"canvas\":" + r.reopenCanvasCount + ",\"canvasScaler\":" + r.reopenCanvasScalerCount + ",\"graphicRaycaster\":" + r.reopenGraphicRaycasterCount + ",\"image\":" + r.reopenImageCount + ",\"graphic\":" + r.reopenGraphicCount + ",\"activeGraphic\":" + r.reopenActiveGraphicCount + ",\"button\":" + r.reopenButtonCount + ",\"activeButton\":" + r.reopenActiveButtonCount + ",\"mask\":" + r.reopenMaskCount + ",\"rectMask2D\":" + r.reopenRectMask2DCount + ",\"stencilMaterial\":" + r.reopenStencilMaterialCount + ",\"text\":" + r.reopenTextCount + ",\"tmp\":" + r.reopenTmpCount + ",\"missingScript\":" + r.reopenMissingScriptCount + "}";
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
    private static string Vec3(Vector3 v) { return v.x.ToString("0.###") + "/" + v.y.ToString("0.###") + "/" + v.z.ToString("0.###"); }
    private static string ColorString(Color c) { return c.r.ToString("0.###") + "/" + c.g.ToString("0.###") + "/" + c.b.ToString("0.###") + "/" + c.a.ToString("0.###"); }
    private static string Bool(bool value) { return value ? "true" : "false"; }
    private static string Json(string value) { return (value ?? "").Replace("\\", "\\\\").Replace("\"", "\\\"").Replace("\r", " ").Replace("\n", " "); }
    private static string Csv(string value) { return "\"" + (value ?? "").Replace("\"", "\"\"") + "\""; }

    private sealed class Battle43Result
    {
        public bool isFinalRestoredBattleScreen;
        public string sourceScene = "";
        public string scene = "";
        public string capture = "";
        public bool sourceSceneOpened;
        public bool sceneSaved;
        public bool captureExists;
        public bool reopenValid;
        public string failReason = "";
        public int beforeCanvasCount, beforeCanvasScalerCount, beforeGraphicRaycasterCount, beforeImageCount, beforeGraphicCount, beforeActiveGraphicCount, beforeButtonCount, beforeActiveButtonCount, beforeMaskCount, beforeRectMask2DCount, beforeStencilMaterialCount, beforeTextCount, beforeTmpCount, beforeMissingScriptCount;
        public int afterCanvasCount, afterCanvasScalerCount, afterGraphicRaycasterCount, afterImageCount, afterGraphicCount, afterActiveGraphicCount, afterButtonCount, afterActiveButtonCount, afterMaskCount, afterRectMask2DCount, afterStencilMaterialCount, afterTextCount, afterTmpCount, afterMissingScriptCount;
        public int reopenCanvasCount, reopenCanvasScalerCount, reopenGraphicRaycasterCount, reopenImageCount, reopenGraphicCount, reopenActiveGraphicCount, reopenButtonCount, reopenActiveButtonCount, reopenMaskCount, reopenRectMask2DCount, reopenStencilMaterialCount, reopenTextCount, reopenTmpCount, reopenMissingScriptCount;
        public int maskLikeTransformCount, buttonLikeActiveImageCount, graphicRaycasterAddedCount, buttonAddedCount, raycastReadyButtonCount, reopenRaycastReadyButtonCount, reopenEventSystemCount;
        public bool eventSystemAdded;
        public int heroCardRootCount, heroListContainerCount, actorRuntimeRootCount;
    }

    private sealed class Battle43RaycastProbe
    {
        public bool targetHit;
        public int hitCount;
        public string screen = "";
        public string eventCameraName = "";
        public string topHitPath = "";
        public string firstHits = "";
        public string reason = "";
    }

    private sealed class Battle43Row
    {
        public string status = "";
        public string path = "";
        public string name = "";
        public string componentType = "";
        public bool activeSelf;
        public bool activeInHierarchy;
        public string componentTypes = "";
        public bool hasRectTransform;
        public string rectSize = "";
        public string anchoredPosition = "";
        public string anchorMin = "";
        public string anchorMax = "";
        public string pivot = "";
        public string localScale = "";
        public string canvasPath = "";
        public string canvasRenderMode = "";
        public string canvasWorldCameraName = "";
        public int canvasSortingOrder;
        public bool hasGraphic;
        public string graphicType = "";
        public bool raycastTarget;
        public string color = "";
        public string materialName = "";
        public bool hasButton;
        public bool buttonInteractable;
        public string targetGraphicPath = "";
        public string evidence = "";
    }
}
