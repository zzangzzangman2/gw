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

public static class Battle42RebuildPersistentBattleHudImageComponentsFromOriginalPrefabPptrAndSpritesEditor
{
    private const string SourceScenePath = "Assets/Scenes/Battle40HudCameraRenderBindingRuntimeContext.unity";
    private const string ScenePath = "Assets/Scenes/Battle42PersistentBattleHudImagesFromOriginalSpriteEvidence.unity";
    private const string ResultJsonPath = "Assets/RestoreData/battle/BATTLE_42_REBUILD_PERSISTENT_BATTLE_HUD_IMAGE_COMPONENTS_FROM_ORIGINAL_PREFAB_PPTR_AND_SPRITES_UNITY.json";
    private const string RowsCsvPath = "Assets/RestoreData/battle/BATTLE_42_REBUILD_PERSISTENT_BATTLE_HUD_IMAGE_COMPONENTS_FROM_ORIGINAL_PREFAB_PPTR_AND_SPRITES_COMPONENTS.csv";
    private const string CapturePath = "Assets/RestoreCaptures/battle_actor/Battle42PersistentBattleHudImagesFromOriginalSpriteEvidence_1920x1080.png";
    private const string SequenceDir = "Assets/RestoreCaptures/battle_actor/battle42_sequence";
    private const string PersistentSpriteDir = "Assets/RestoreData/battle/PersistentHudSprites/BATTLE42";
    private const int CaptureWidth = 1920;
    private const int CaptureHeight = 1080;

    [MenuItem("GirlsWar/Battle/BATTLE42 Rebuild Persistent Battle HUD Image Components From Original Prefab PPtr And Sprites")]
    public static void Build()
    {
        Directory.CreateDirectory(ProjectPath("Assets/RestoreData/battle"));
        Directory.CreateDirectory(ProjectPath(PersistentSpriteDir));
        Directory.CreateDirectory(ProjectPath("Assets/RestoreCaptures/battle_actor"));
        Directory.CreateDirectory(ProjectPath(SequenceDir));

        var rows = new List<Battle42HudImageRow>();
        var result = new Battle42Result();
        result.sourceScene = SourceScenePath;
        result.scene = ScenePath;
        result.capture = CapturePath;
        result.persistentSpriteDir = PersistentSpriteDir;
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

        result.beforeImageCount = UnityEngine.Object.FindObjectsOfType<Image>(true).Length;
        result.beforeGraphicCount = UnityEngine.Object.FindObjectsOfType<Graphic>(true).Length;
        result.beforeMissingScriptCount = CountMissingScripts();
        result.beforeActiveGraphicCount = CountActiveGraphics();

        var markers = UnityEngine.Object.FindObjectsOfType<BattleHudExtractedSpriteBindingMarker25>(true);
        result.originalSpriteMarkerCount = markers.Length;
        var spriteCache = new Dictionary<string, Sprite>(StringComparer.OrdinalIgnoreCase);

        foreach (var marker in markers)
        {
            var row = new Battle42HudImageRow();
            row.path = HierarchyPath(marker.transform);
            row.name = marker.name;
            row.spriteName = marker.spriteName ?? "";
            row.bundle = marker.bundle ?? "";
            row.pathId = marker.pathId ?? "";
            row.sourcePngPath = marker.absolutePath ?? "";
            row.sourceWidth = marker.width;
            row.sourceHeight = marker.height;
            row.activeSelf = marker.gameObject.activeSelf;
            row.activeInHierarchy = marker.gameObject.activeInHierarchy;
            row.canvasPath = CanvasPath(marker.transform);
            row.reason = "original BattleHudExtractedSpriteBindingMarker25";

            var rect = marker.transform as RectTransform;
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

            if (rect == null)
            {
                row.status = "skipped_no_rect_transform";
                rows.Add(row);
                continue;
            }
            if (string.IsNullOrEmpty(row.sourcePngPath) || !File.Exists(row.sourcePngPath))
            {
                row.status = "skipped_source_png_missing";
                rows.Add(row);
                continue;
            }

            var sprite = LoadPersistentSprite(marker, spriteCache, row);
            if (sprite == null)
            {
                row.status = "skipped_sprite_import_failed";
                rows.Add(row);
                continue;
            }

            var image = marker.GetComponent<Image>();
            if (image == null)
            {
                image = marker.gameObject.AddComponent<Image>();
                row.addedImageComponent = true;
            }
            image.sprite = sprite;
            image.color = Color.white;
            image.raycastTarget = false;
            image.type = Image.Type.Simple;
            image.preserveAspect = IsHeadSprite(row.spriteName, marker.name);
            row.imageType = image.type.ToString();
            row.preserveAspect = image.preserveAspect;
            row.spriteAssetPath = AssetDatabase.GetAssetPath(sprite);
            row.spriteAssetName = sprite.name;
            row.status = "persistent_image_sprite_bound";
            rows.Add(row);
        }

        AssetDatabase.SaveAssets();
        Canvas.ForceUpdateCanvases();
        result.reconstructedImageCount = Count(rows, r => r.status == "persistent_image_sprite_bound");
        result.importedSpriteAssetCount = CountUniqueSpriteAssets(rows);
        result.afterImageCount = UnityEngine.Object.FindObjectsOfType<Image>(true).Length;
        result.afterGraphicCount = UnityEngine.Object.FindObjectsOfType<Graphic>(true).Length;
        result.afterImageWithSpriteCount = CountImagesWithSprite();
        result.afterImageWithTextureCount = CountImagesWithTexture();
        result.afterActiveGraphicCount = CountActiveGraphics();
        result.afterMissingScriptCount = CountMissingScripts();

        EditorSceneManager.SaveScene(scene, ScenePath);
        result.sceneSaved = File.Exists(ProjectPath(ScenePath));
        Capture(camera, ProjectPath(CapturePath));
        for (int i = 0; i < 6; i++) Capture(camera, ProjectPath(SequenceDir + "/Battle42PersistentHud_" + i.ToString("00") + "_1920x1080.png"));
        result.captureExists = File.Exists(ProjectPath(CapturePath));

        var reopened = EditorSceneManager.OpenScene(ScenePath, OpenSceneMode.Single);
        result.reopenValid = reopened.IsValid();
        result.reopenImageCount = UnityEngine.Object.FindObjectsOfType<Image>(true).Length;
        result.reopenGraphicCount = UnityEngine.Object.FindObjectsOfType<Graphic>(true).Length;
        result.reopenImageWithSpriteCount = CountImagesWithSprite();
        result.reopenImageWithTextureCount = CountImagesWithTexture();
        result.reopenActiveGraphicCount = CountActiveGraphics();
        result.reopenMissingScriptCount = CountMissingScripts();
        result.reopenTextCount = UnityEngine.Object.FindObjectsOfType<Text>(true).Length + UnityEngine.Object.FindObjectsOfType<TMP_Text>(true).Length;
        result.reopenCanvasCount = UnityEngine.Object.FindObjectsOfType<Canvas>(true).Length;

        WriteOutputs(result, rows);
        AssetDatabase.Refresh();
        Debug.Log("BATTLE42 persistent HUD Image rebuild complete. reconstructed=" + result.reconstructedImageCount + ", reopenImages=" + result.reopenImageCount);
    }

    private static Sprite LoadPersistentSprite(BattleHudExtractedSpriteBindingMarker25 marker, Dictionary<string, Sprite> cache, Battle42HudImageRow row)
    {
        string source = marker.absolutePath ?? "";
        if (cache.ContainsKey(source)) return cache[source];
        string fileName = Safe(marker.bundle) + "_" + Safe(marker.pathId) + "_" + Safe(marker.spriteName) + ".png";
        string assetPath = PersistentSpriteDir + "/" + fileName;
        string fullPath = ProjectPath(assetPath);
        Directory.CreateDirectory(Path.GetDirectoryName(fullPath));
        if (!File.Exists(fullPath) || new FileInfo(fullPath).Length != new FileInfo(source).Length)
        {
            File.Copy(source, fullPath, true);
            row.copiedSourcePng = true;
        }
        AssetDatabase.ImportAsset(assetPath, ImportAssetOptions.ForceUpdate);
        var importer = AssetImporter.GetAtPath(assetPath) as TextureImporter;
        if (importer != null)
        {
            bool dirty = false;
            if (importer.textureType != TextureImporterType.Sprite) { importer.textureType = TextureImporterType.Sprite; dirty = true; }
            if (importer.spriteImportMode != SpriteImportMode.Single) { importer.spriteImportMode = SpriteImportMode.Single; dirty = true; }
            if (!importer.alphaIsTransparency) { importer.alphaIsTransparency = true; dirty = true; }
            if (importer.mipmapEnabled) { importer.mipmapEnabled = false; dirty = true; }
            if (dirty) importer.SaveAndReimport();
        }
        var sprite = AssetDatabase.LoadAssetAtPath<Sprite>(assetPath);
        if (sprite != null) sprite.name = marker.spriteName;
        row.spriteAssetPath = assetPath;
        cache[source] = sprite;
        return sprite;
    }

    private static bool IsHeadSprite(string spriteName, string objectName)
    {
        string s = (spriteName ?? "").ToLowerInvariant();
        string n = (objectName ?? "").ToLowerInvariant();
        return s.StartsWith("head") || s.StartsWith("battlehead") || n.Contains("head");
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
        var go = new GameObject("BATTLE42_FallbackCaptureCamera");
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

    private static int CountMissingScripts()
    {
        int count = 0;
        foreach (var transform in UnityEngine.Object.FindObjectsOfType<Transform>(true))
            foreach (var component in transform.GetComponents<Component>())
                if (component == null) count++;
        return count;
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

    private static int Count(List<Battle42HudImageRow> rows, Func<Battle42HudImageRow, bool> predicate)
    {
        int count = 0;
        foreach (var row in rows) if (predicate(row)) count++;
        return count;
    }

    private static int CountUniqueSpriteAssets(List<Battle42HudImageRow> rows)
    {
        var seen = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
        foreach (var row in rows)
            if (!string.IsNullOrEmpty(row.spriteAssetPath)) seen.Add(row.spriteAssetPath);
        return seen.Count;
    }

    private static void WriteOutputs(Battle42Result result, List<Battle42HudImageRow> rows)
    {
        WriteRowsCsv(ProjectPath(RowsCsvPath), rows);
        WriteJson(ProjectPath(ResultJsonPath), result, rows);
    }

    private static void WriteRowsCsv(string path, List<Battle42HudImageRow> rows)
    {
        Directory.CreateDirectory(Path.GetDirectoryName(path));
        var sb = new StringBuilder();
        sb.AppendLine("status,path,name,activeSelf,activeInHierarchy,canvasPath,hasRectTransform,rectSize,anchoredPosition,anchorMin,anchorMax,pivot,localScale,spriteName,bundle,pathId,sourceWidth,sourceHeight,sourcePngPath,copiedSourcePng,spriteAssetPath,spriteAssetName,addedImageComponent,imageType,preserveAspect,reason");
        foreach (var r in rows)
        {
            sb.AppendLine(string.Join(",", new[]
            {
                Csv(r.status), Csv(r.path), Csv(r.name), Bool(r.activeSelf), Bool(r.activeInHierarchy), Csv(r.canvasPath), Bool(r.hasRectTransform),
                Csv(r.rectSize), Csv(r.anchoredPosition), Csv(r.anchorMin), Csv(r.anchorMax), Csv(r.pivot), Csv(r.localScale),
                Csv(r.spriteName), Csv(r.bundle), Csv(r.pathId), r.sourceWidth.ToString(), r.sourceHeight.ToString(), Csv(r.sourcePngPath),
                Bool(r.copiedSourcePng), Csv(r.spriteAssetPath), Csv(r.spriteAssetName), Bool(r.addedImageComponent), Csv(r.imageType), Bool(r.preserveAspect), Csv(r.reason)
            }));
        }
        File.WriteAllText(path, sb.ToString(), new UTF8Encoding(false));
    }

    private static void WriteJson(string path, Battle42Result r, List<Battle42HudImageRow> rows)
    {
        Directory.CreateDirectory(Path.GetDirectoryName(path));
        var sb = new StringBuilder();
        sb.AppendLine("{");
        sb.AppendLine("  \"status\": \"battle42_rebuild_persistent_battle_hud_image_components_from_original_prefab_pptr_and_sprites\",");
        sb.AppendLine("  \"isFinalRestoredBattleScreen\": false,");
        sb.AppendLine("  \"sourceScene\": \"" + Json(r.sourceScene) + "\",");
        sb.AppendLine("  \"scene\": \"" + Json(r.scene) + "\",");
        sb.AppendLine("  \"capture\": \"" + Json(r.capture) + "\",");
        sb.AppendLine("  \"persistentSpriteDir\": \"" + Json(r.persistentSpriteDir) + "\",");
        sb.AppendLine("  \"sourceSceneOpened\": " + Bool(r.sourceSceneOpened) + ",");
        sb.AppendLine("  \"sceneSaved\": " + Bool(r.sceneSaved) + ",");
        sb.AppendLine("  \"captureExists\": " + Bool(r.captureExists) + ",");
        sb.AppendLine("  \"reopenValid\": " + Bool(r.reopenValid) + ",");
        sb.AppendLine("  \"originalSpriteMarkerCount\": " + r.originalSpriteMarkerCount + ",");
        sb.AppendLine("  \"reconstructedImageCount\": " + r.reconstructedImageCount + ",");
        sb.AppendLine("  \"importedSpriteAssetCount\": " + r.importedSpriteAssetCount + ",");
        sb.AppendLine("  \"beforeImageCount\": " + r.beforeImageCount + ",");
        sb.AppendLine("  \"beforeGraphicCount\": " + r.beforeGraphicCount + ",");
        sb.AppendLine("  \"beforeActiveGraphicCount\": " + r.beforeActiveGraphicCount + ",");
        sb.AppendLine("  \"beforeMissingScriptCount\": " + r.beforeMissingScriptCount + ",");
        sb.AppendLine("  \"afterImageCount\": " + r.afterImageCount + ",");
        sb.AppendLine("  \"afterGraphicCount\": " + r.afterGraphicCount + ",");
        sb.AppendLine("  \"afterImageWithSpriteCount\": " + r.afterImageWithSpriteCount + ",");
        sb.AppendLine("  \"afterImageWithTextureCount\": " + r.afterImageWithTextureCount + ",");
        sb.AppendLine("  \"afterActiveGraphicCount\": " + r.afterActiveGraphicCount + ",");
        sb.AppendLine("  \"afterMissingScriptCount\": " + r.afterMissingScriptCount + ",");
        sb.AppendLine("  \"reopenCanvasCount\": " + r.reopenCanvasCount + ",");
        sb.AppendLine("  \"reopenImageCount\": " + r.reopenImageCount + ",");
        sb.AppendLine("  \"reopenGraphicCount\": " + r.reopenGraphicCount + ",");
        sb.AppendLine("  \"reopenImageWithSpriteCount\": " + r.reopenImageWithSpriteCount + ",");
        sb.AppendLine("  \"reopenImageWithTextureCount\": " + r.reopenImageWithTextureCount + ",");
        sb.AppendLine("  \"reopenActiveGraphicCount\": " + r.reopenActiveGraphicCount + ",");
        sb.AppendLine("  \"reopenTextCount\": " + r.reopenTextCount + ",");
        sb.AppendLine("  \"reopenMissingScriptCount\": " + r.reopenMissingScriptCount + ",");
        sb.AppendLine("  \"failReason\": \"" + Json(r.failReason) + "\",");
        sb.AppendLine("  \"rowCount\": " + rows.Count + ",");
        sb.AppendLine("  \"boundRowSample\": [");
        int written = 0;
        foreach (var row in rows)
        {
            if (row.status != "persistent_image_sprite_bound") continue;
            if (written > 0) sb.AppendLine(",");
            sb.Append("    {\"path\":\"" + Json(row.path) + "\",\"spriteName\":\"" + Json(row.spriteName) + "\",\"bundle\":\"" + Json(row.bundle) + "\",\"pathId\":\"" + Json(row.pathId) + "\",\"spriteAssetPath\":\"" + Json(row.spriteAssetPath) + "\",\"activeInHierarchy\":" + Bool(row.activeInHierarchy) + "}");
            written++;
            if (written >= 20) break;
        }
        sb.AppendLine();
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

    private static string CanvasPath(Transform transform)
    {
        var canvas = transform.GetComponentInParent<Canvas>(true);
        return canvas == null ? "" : HierarchyPath(canvas.transform);
    }

    private static string ProjectPath(string assetPath) { return Path.Combine(Application.dataPath, "..", assetPath.Replace("/", "\\")); }
    private static string Safe(string value)
    {
        value = string.IsNullOrEmpty(value) ? "unknown" : value;
        foreach (char c in Path.GetInvalidFileNameChars()) value = value.Replace(c, '_');
        return value.Replace("/", "_").Replace("\\", "_").Replace(" ", "_").Replace(":", "_");
    }
    private static string Vec2(Vector2 v) { return v.x.ToString("0.###") + "/" + v.y.ToString("0.###"); }
    private static string Vec3(Vector3 v) { return v.x.ToString("0.###") + "/" + v.y.ToString("0.###") + "/" + v.z.ToString("0.###"); }
    private static string Bool(bool value) { return value ? "true" : "false"; }
    private static string Json(string value) { return (value ?? "").Replace("\\", "\\\\").Replace("\"", "\\\"").Replace("\r", " ").Replace("\n", " "); }
    private static string Csv(string value) { return "\"" + (value ?? "").Replace("\"", "\"\"") + "\""; }

    private sealed class Battle42Result
    {
        public bool isFinalRestoredBattleScreen;
        public string sourceScene = "";
        public string scene = "";
        public string capture = "";
        public string persistentSpriteDir = "";
        public bool sourceSceneOpened;
        public bool sceneSaved;
        public bool captureExists;
        public bool reopenValid;
        public int originalSpriteMarkerCount;
        public int reconstructedImageCount;
        public int importedSpriteAssetCount;
        public int beforeImageCount;
        public int beforeGraphicCount;
        public int beforeActiveGraphicCount;
        public int beforeMissingScriptCount;
        public int afterImageCount;
        public int afterGraphicCount;
        public int afterImageWithSpriteCount;
        public int afterImageWithTextureCount;
        public int afterActiveGraphicCount;
        public int afterMissingScriptCount;
        public int reopenCanvasCount;
        public int reopenImageCount;
        public int reopenGraphicCount;
        public int reopenImageWithSpriteCount;
        public int reopenImageWithTextureCount;
        public int reopenActiveGraphicCount;
        public int reopenTextCount;
        public int reopenMissingScriptCount;
        public string failReason = "";
    }

    private sealed class Battle42HudImageRow
    {
        public string status = "";
        public string path = "";
        public string name = "";
        public bool activeSelf;
        public bool activeInHierarchy;
        public string canvasPath = "";
        public bool hasRectTransform;
        public string rectSize = "";
        public string anchoredPosition = "";
        public string anchorMin = "";
        public string anchorMax = "";
        public string pivot = "";
        public string localScale = "";
        public string spriteName = "";
        public string bundle = "";
        public string pathId = "";
        public int sourceWidth;
        public int sourceHeight;
        public string sourcePngPath = "";
        public bool copiedSourcePng;
        public string spriteAssetPath = "";
        public string spriteAssetName = "";
        public bool addedImageComponent;
        public string imageType = "";
        public bool preserveAspect;
        public string reason = "";
    }
}
