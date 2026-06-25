using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using TMPro;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text;

public static class Battle41TraceBattleHudRuntimeSpriteTexturePersistenceAndCapturePipelineEditor
{
    private const string Battle29ScenePath = "Assets/Scenes/BattleHeroListSkillCardBindClip05.unity";
    private const string Battle40ScenePath = "Assets/Scenes/Battle40HudCameraRenderBindingRuntimeContext.unity";
    private const string ScenePath = "Assets/Scenes/Battle41HudRuntimeSpriteTexturePersistenceTrace.unity";
    private const string ResultJsonPath = "Assets/RestoreData/battle/BATTLE_41_TRACE_BATTLE_HUD_RUNTIME_SPRITE_TEXTURE_PERSISTENCE_AND_CAPTURE_PIPELINE_UNITY.json";
    private const string ComponentsCsvPath = "Assets/RestoreData/battle/BATTLE_41_TRACE_BATTLE_HUD_RUNTIME_SPRITE_TEXTURE_PERSISTENCE_AND_CAPTURE_PIPELINE_COMPONENTS.csv";
    private const string CapturePath = "Assets/RestoreCaptures/battle_actor/Battle41HudRuntimeSpriteTexturePersistenceTrace_1920x1080.png";
    private const string SequenceDir = "Assets/RestoreCaptures/battle_actor/battle41_sequence";
    private const int CaptureWidth = 1920;
    private const int CaptureHeight = 1080;

    [MenuItem("GirlsWar/Battle/BATTLE41 Trace Battle HUD Runtime Sprite Texture Persistence And Capture Pipeline")]
    public static void Build()
    {
        Directory.CreateDirectory(ProjectPath("Assets/RestoreData/battle"));
        Directory.CreateDirectory(ProjectPath("Assets/Scenes"));
        Directory.CreateDirectory(ProjectPath("Assets/RestoreCaptures/battle_actor"));
        Directory.CreateDirectory(ProjectPath(SequenceDir));

        var allRows = new List<Battle41ComponentRow>();
        var summaries = new List<Battle41SceneSummary>();

        summaries.Add(SnapshotScene("battle29_saved_scene_reopen", Battle29ScenePath, false, allRows));
        summaries.Add(SnapshotScene("battle40_saved_scene_reopen_before_copy", Battle40ScenePath, false, allRows));

        var finalSummary = SnapshotScene("battle41_candidate_reopen_after_copy", Battle40ScenePath, true, allRows);
        summaries.Add(finalSummary);

        WriteComponentsCsv(ProjectPath(ComponentsCsvPath), allRows);
        WriteJson(ProjectPath(ResultJsonPath), summaries, allRows);
        AssetDatabase.Refresh();
        Debug.Log("BATTLE41 HUD runtime sprite/texture persistence trace complete. rows=" + allRows.Count);
    }

    private static Battle41SceneSummary SnapshotScene(string phase, string scenePath, bool saveAsBattle41, List<Battle41ComponentRow> rows)
    {
        var summary = new Battle41SceneSummary();
        summary.phase = phase;
        summary.scenePath = scenePath;
        summary.sceneExists = File.Exists(ProjectPath(scenePath));
        if (!summary.sceneExists)
        {
            summary.failReason = "scene_file_not_found";
            return summary;
        }

        var scene = EditorSceneManager.OpenScene(scenePath, OpenSceneMode.Single);
        summary.opened = scene.IsValid();
        var camera = FindCaptureCamera();
        summary.cameraFound = camera != null;
        if (camera == null) camera = CreateFallbackCamera();
        ConfigureCamera(camera);
        Canvas.ForceUpdateCanvases();

        summary.canvasCount = UnityEngine.Object.FindObjectsOfType<Canvas>(true).Length;
        summary.graphicCount = UnityEngine.Object.FindObjectsOfType<Graphic>(true).Length;
        summary.imageCount = UnityEngine.Object.FindObjectsOfType<Image>(true).Length;
        summary.textCount = UnityEngine.Object.FindObjectsOfType<Text>(true).Length + UnityEngine.Object.FindObjectsOfType<TMP_Text>(true).Length;
        summary.canvasRendererCount = UnityEngine.Object.FindObjectsOfType<CanvasRenderer>(true).Length;
        summary.activeGraphicCount = CountActiveGraphics();
        summary.missingScriptCount = CountMissingScripts();
        summary.heroCardRootCount = CountTransformsContaining("Battle29BoundHeroCard");
        summary.heroListContainerCount = CountTransformsContaining("HeroListContainer");
        summary.imageLikeTransformCount = CountImageLikeTransforms(rows, phase);
        summary.imageWithSpriteCount = CountImagesWithSprite();
        summary.imageWithTextureCount = CountImagesWithTexture();
        summary.cameraInfo = CameraInfo(camera);

        if (saveAsBattle41)
        {
            EditorSceneManager.SaveScene(scene, ScenePath);
            summary.savedAs = ScenePath;
            Capture(camera, ProjectPath(CapturePath));
            for (int i = 0; i < 6; i++) Capture(camera, ProjectPath(SequenceDir + "/Battle41RuntimeContext_" + i.ToString("00") + "_1920x1080.png"));
            summary.capture = CapturePath;
            summary.captureExists = File.Exists(ProjectPath(CapturePath));

            var reopened = EditorSceneManager.OpenScene(ScenePath, OpenSceneMode.Single);
            summary.reopenAfterSaveValid = reopened.IsValid();
            summary.reopenAfterSaveGraphicCount = UnityEngine.Object.FindObjectsOfType<Graphic>(true).Length;
            summary.reopenAfterSaveImageCount = UnityEngine.Object.FindObjectsOfType<Image>(true).Length;
            summary.reopenAfterSaveActiveGraphicCount = CountActiveGraphics();
            summary.reopenAfterSaveMissingScriptCount = CountMissingScripts();
            rows.RemoveAll(r => r.phase == phase + "_after_save_reopen");
            CountImageLikeTransforms(rows, phase + "_after_save_reopen");
        }
        return summary;
    }

    private static int CountImageLikeTransforms(List<Battle41ComponentRow> rows, string phase)
    {
        int count = 0;
        foreach (var transform in UnityEngine.Object.FindObjectsOfType<Transform>(true))
        {
            string name = transform.name.ToLowerInvariant();
            bool imageLike = name.Contains("img") || name.StartsWith("im_") || name.Contains("icon") || name.Contains("head") || name.Contains("hp") || name.Contains("skill") || name.Contains("btn") || name.Contains("bg");
            bool cardRelated = HierarchyPath(transform).IndexOf("Battle29BoundHeroCard", StringComparison.OrdinalIgnoreCase) >= 0 ||
                               HierarchyPath(transform).IndexOf("HeroListContainer", StringComparison.OrdinalIgnoreCase) >= 0 ||
                               HierarchyPath(transform).IndexOf("ui_normalbattle", StringComparison.OrdinalIgnoreCase) >= 0 ||
                               HierarchyPath(transform).IndexOf("root_battle", StringComparison.OrdinalIgnoreCase) >= 0;
            if (!imageLike && !cardRelated) continue;
            count++;
            rows.Add(RowForTransform(phase, transform, imageLike, cardRelated));
        }
        return count;
    }

    private static Battle41ComponentRow RowForTransform(string phase, Transform transform, bool imageLike, bool cardRelated)
    {
        var row = new Battle41ComponentRow();
        row.phase = phase;
        row.path = HierarchyPath(transform);
        row.name = transform.name;
        row.imageLikeName = imageLike;
        row.cardRelatedPath = cardRelated;
        row.activeSelf = transform.gameObject.activeSelf;
        row.activeInHierarchy = transform.gameObject.activeInHierarchy;
        row.layer = LayerMask.LayerToName(transform.gameObject.layer);
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
        var canvas = transform.GetComponentInParent<Canvas>(true);
        if (canvas != null)
        {
            row.canvasPath = HierarchyPath(canvas.transform);
            row.canvasRenderMode = canvas.renderMode.ToString();
            row.canvasWorldCameraName = canvas.worldCamera != null ? canvas.worldCamera.name : "";
            row.canvasSortingOrder = canvas.sortingOrder;
        }
        var components = transform.GetComponents<Component>();
        var names = new List<string>();
        int nulls = 0;
        foreach (var component in components)
        {
            if (component == null)
            {
                nulls++;
                names.Add("MissingScript");
                continue;
            }
            names.Add(component.GetType().FullName ?? component.GetType().Name);
        }
        row.componentTypes = string.Join("|", names.ToArray());
        row.nullComponentCount = nulls;
        row.hasCanvasRenderer = transform.GetComponent<CanvasRenderer>() != null;
        var graphic = transform.GetComponent<Graphic>();
        row.hasGraphic = graphic != null;
        if (graphic != null)
        {
            row.graphicType = graphic.GetType().FullName ?? graphic.GetType().Name;
            row.graphicEnabled = graphic.enabled;
            row.raycastTarget = graphic.raycastTarget;
            row.graphicColor = ColorString(graphic.color);
            row.materialName = graphic.material != null ? graphic.material.name : "";
        }
        var image = transform.GetComponent<Image>();
        row.hasImage = image != null;
        if (image != null)
        {
            row.spriteName = image.sprite != null ? image.sprite.name : "";
            row.textureName = image.sprite != null && image.sprite.texture != null ? image.sprite.texture.name : "";
            row.textureSize = image.sprite != null && image.sprite.texture != null ? image.sprite.texture.width + "x" + image.sprite.texture.height : "";
            row.imageType = image.type.ToString();
            row.preserveAspect = image.preserveAspect;
        }
        return row;
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
        var go = new GameObject("BATTLE41_FallbackCaptureCamera");
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

    private static int CountActiveGraphics()
    {
        int count = 0;
        foreach (var graphic in UnityEngine.Object.FindObjectsOfType<Graphic>(true))
            if (graphic != null && graphic.enabled && graphic.gameObject.activeInHierarchy) count++;
        return count;
    }

    private static int CountImagesWithSprite()
    {
        int count = 0;
        foreach (var image in UnityEngine.Object.FindObjectsOfType<Image>(true))
            if (image != null && image.sprite != null) count++;
        return count;
    }

    private static int CountImagesWithTexture()
    {
        int count = 0;
        foreach (var image in UnityEngine.Object.FindObjectsOfType<Image>(true))
            if (image != null && image.sprite != null && image.sprite.texture != null) count++;
        return count;
    }

    private static int CountMissingScripts()
    {
        int count = 0;
        foreach (var transform in UnityEngine.Object.FindObjectsOfType<Transform>(true))
        {
            foreach (var component in transform.GetComponents<Component>())
                if (component == null) count++;
        }
        return count;
    }

    private static int CountTransformsContaining(string text)
    {
        int count = 0;
        foreach (var transform in UnityEngine.Object.FindObjectsOfType<Transform>(true))
            if (transform.name.IndexOf(text, StringComparison.OrdinalIgnoreCase) >= 0) count++;
        return count;
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

    private static void WriteComponentsCsv(string path, List<Battle41ComponentRow> rows)
    {
        var sb = new StringBuilder();
        sb.AppendLine("phase,path,name,imageLikeName,cardRelatedPath,activeSelf,activeInHierarchy,layer,hasRectTransform,rectSize,anchoredPosition,anchorMin,anchorMax,pivot,localScale,canvasPath,canvasRenderMode,canvasWorldCameraName,canvasSortingOrder,componentTypes,nullComponentCount,hasCanvasRenderer,hasGraphic,graphicType,graphicEnabled,raycastTarget,graphicColor,materialName,hasImage,spriteName,textureName,textureSize,imageType,preserveAspect");
        foreach (var row in rows)
        {
            sb.AppendLine(string.Join(",", new[]
            {
                Csv(row.phase), Csv(row.path), Csv(row.name), Bool(row.imageLikeName), Bool(row.cardRelatedPath), Bool(row.activeSelf), Bool(row.activeInHierarchy), Csv(row.layer),
                Bool(row.hasRectTransform), Csv(row.rectSize), Csv(row.anchoredPosition), Csv(row.anchorMin), Csv(row.anchorMax), Csv(row.pivot), Csv(row.localScale),
                Csv(row.canvasPath), Csv(row.canvasRenderMode), Csv(row.canvasWorldCameraName), row.canvasSortingOrder.ToString(),
                Csv(row.componentTypes), row.nullComponentCount.ToString(), Bool(row.hasCanvasRenderer), Bool(row.hasGraphic), Csv(row.graphicType), Bool(row.graphicEnabled),
                Bool(row.raycastTarget), Csv(row.graphicColor), Csv(row.materialName), Bool(row.hasImage), Csv(row.spriteName), Csv(row.textureName), Csv(row.textureSize),
                Csv(row.imageType), Bool(row.preserveAspect)
            }));
        }
        File.WriteAllText(path, sb.ToString(), new UTF8Encoding(false));
    }

    private static void WriteJson(string path, List<Battle41SceneSummary> summaries, List<Battle41ComponentRow> rows)
    {
        var sb = new StringBuilder();
        sb.AppendLine("{");
        sb.AppendLine("  \"status\": \"battle41_hud_runtime_sprite_texture_persistence_trace\",");
        sb.AppendLine("  \"isFinalRestoredBattleScreen\": false,");
        sb.AppendLine("  \"battle29Scene\": \"" + Json(Battle29ScenePath) + "\",");
        sb.AppendLine("  \"battle40Scene\": \"" + Json(Battle40ScenePath) + "\",");
        sb.AppendLine("  \"scene\": \"" + Json(ScenePath) + "\",");
        sb.AppendLine("  \"capture\": \"" + Json(CapturePath) + "\",");
        sb.AppendLine("  \"componentRows\": " + rows.Count + ",");
        sb.AppendLine("  \"summaries\": [");
        for (int i = 0; i < summaries.Count; i++)
        {
            var s = summaries[i];
            sb.Append("    {\"phase\":\"" + Json(s.phase) + "\",\"scenePath\":\"" + Json(s.scenePath) + "\",\"sceneExists\":" + Bool(s.sceneExists) + ",\"opened\":" + Bool(s.opened) + ",\"canvasCount\":" + s.canvasCount + ",\"graphicCount\":" + s.graphicCount + ",\"imageCount\":" + s.imageCount + ",\"textCount\":" + s.textCount + ",\"canvasRendererCount\":" + s.canvasRendererCount + ",\"activeGraphicCount\":" + s.activeGraphicCount + ",\"missingScriptCount\":" + s.missingScriptCount + ",\"heroCardRootCount\":" + s.heroCardRootCount + ",\"heroListContainerCount\":" + s.heroListContainerCount + ",\"imageLikeTransformCount\":" + s.imageLikeTransformCount + ",\"imageWithSpriteCount\":" + s.imageWithSpriteCount + ",\"imageWithTextureCount\":" + s.imageWithTextureCount + ",\"cameraFound\":" + Bool(s.cameraFound) + ",\"cameraInfo\":\"" + Json(s.cameraInfo) + "\",\"savedAs\":\"" + Json(s.savedAs) + "\",\"capture\":\"" + Json(s.capture) + "\",\"captureExists\":" + Bool(s.captureExists) + ",\"reopenAfterSaveValid\":" + Bool(s.reopenAfterSaveValid) + ",\"reopenAfterSaveGraphicCount\":" + s.reopenAfterSaveGraphicCount + ",\"reopenAfterSaveImageCount\":" + s.reopenAfterSaveImageCount + ",\"reopenAfterSaveActiveGraphicCount\":" + s.reopenAfterSaveActiveGraphicCount + ",\"reopenAfterSaveMissingScriptCount\":" + s.reopenAfterSaveMissingScriptCount + ",\"failReason\":\"" + Json(s.failReason) + "\"}");
            sb.AppendLine(i + 1 == summaries.Count ? "" : ",");
        }
        sb.AppendLine("  ]");
        sb.AppendLine("}");
        File.WriteAllText(path, sb.ToString(), new UTF8Encoding(false));
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
    private static string CameraInfo(Camera c) { return c == null ? "" : c.name + "|ortho=" + Bool(c.orthographic) + "|size=" + Num(c.orthographicSize) + "|pos=" + Vec3(c.transform.position) + "|depth=" + Num(c.depth) + "|clear=" + c.clearFlags + "|cull=" + c.cullingMask; }
    private static string ColorString(Color c) { return c.r.ToString("0.###") + "/" + c.g.ToString("0.###") + "/" + c.b.ToString("0.###") + "/" + c.a.ToString("0.###"); }
    private static string Vec2(Vector2 v) { return v.x.ToString("0.###") + "/" + v.y.ToString("0.###"); }
    private static string Vec3(Vector3 v) { return v.x.ToString("0.###") + "/" + v.y.ToString("0.###") + "/" + v.z.ToString("0.###"); }
    private static string Bool(bool value) { return value ? "true" : "false"; }
    private static string Num(float value) { return value.ToString("0.######", System.Globalization.CultureInfo.InvariantCulture); }
    private static string Json(string value) { return (value ?? "").Replace("\\", "\\\\").Replace("\"", "\\\"").Replace("\r", " ").Replace("\n", " "); }
    private static string Csv(string value) { return "\"" + (value ?? "").Replace("\"", "\"\"") + "\""; }

    private sealed class Battle41SceneSummary
    {
        public string phase = "";
        public string scenePath = "";
        public bool sceneExists;
        public bool opened;
        public int canvasCount;
        public int graphicCount;
        public int imageCount;
        public int textCount;
        public int canvasRendererCount;
        public int activeGraphicCount;
        public int missingScriptCount;
        public int heroCardRootCount;
        public int heroListContainerCount;
        public int imageLikeTransformCount;
        public int imageWithSpriteCount;
        public int imageWithTextureCount;
        public bool cameraFound;
        public string cameraInfo = "";
        public string savedAs = "";
        public string capture = "";
        public bool captureExists;
        public bool reopenAfterSaveValid;
        public int reopenAfterSaveGraphicCount;
        public int reopenAfterSaveImageCount;
        public int reopenAfterSaveActiveGraphicCount;
        public int reopenAfterSaveMissingScriptCount;
        public string failReason = "";
    }

    private sealed class Battle41ComponentRow
    {
        public string phase = "";
        public string path = "";
        public string name = "";
        public bool imageLikeName;
        public bool cardRelatedPath;
        public bool activeSelf;
        public bool activeInHierarchy;
        public string layer = "";
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
        public string componentTypes = "";
        public int nullComponentCount;
        public bool hasCanvasRenderer;
        public bool hasGraphic;
        public string graphicType = "";
        public bool graphicEnabled;
        public bool raycastTarget;
        public string graphicColor = "";
        public string materialName = "";
        public bool hasImage;
        public string spriteName = "";
        public string textureName = "";
        public string textureSize = "";
        public string imageType = "";
        public bool preserveAspect;
    }
}
