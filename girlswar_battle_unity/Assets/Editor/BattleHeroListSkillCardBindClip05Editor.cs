using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.UI;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text;

public static class BattleHeroListSkillCardBindClip05Editor
{
    private const string ResultJsonPath = "Assets/RestoreData/battle/BATTLE_HERO_LIST_SKILLCARD_BIND_CLIP05.json";
    private const string CapturePath = "Assets/RestoreCaptures/battle_hud/BattleHeroListSkillCardBindClip05_1920x1080.png";
    private const string ScenePath = "Assets/Scenes/BattleHeroListSkillCardBindClip05.unity";
    private const string MergedExtractedRoot = @"C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted";
    private const string SpriteIndexPath = @"C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\indexes\unity_images.csv";
    private const int CaptureWidth = 1920;
    private const int CaptureHeight = 1080;

    [MenuItem("GirlsWar/Battle/Battle 29 Hero List Skill Card Bind Clip05")]
    public static void Build()
    {
        BattleCorrectMapSceneHudPreviewClip05Editor.Build();

        var hudRoot = GameObject.Find("BattleHudSpriteAtlasTextureRuntimeBindingClip05Root");
        var camera = GameObject.Find("BattleHudSpriteAtlasTextureRuntimeBindingClip05Camera") != null
            ? GameObject.Find("BattleHudSpriteAtlasTextureRuntimeBindingClip05Camera").GetComponent<Camera>()
            : null;
        var heroListContainer = FindByPathContains(hudRoot, "root_battle/BottomCenter/HeroListContainer");
        var template = FindByNameContains(hudRoot, "ui_normalbattle_heroitem");
        var spriteIndex = LoadSpritePngIndex();

        var rows = new List<Battle29HeroCardRow>();
        bool templateFound = template != null;
        bool containerFound = heroListContainer != null;
        if (templateFound && containerFound)
        {
            BindHeroCards(heroListContainer.transform as RectTransform, template, spriteIndex, rows);
        }

        Canvas.ForceUpdateCanvases();
        bool captureExists = Capture(camera);
        WriteJson(ProjectPath(ResultJsonPath), templateFound, containerFound, rows, captureExists);
        EditorSceneManager.SaveScene(UnityEngine.SceneManagement.SceneManager.GetActiveScene(), ScenePath);
        AssetDatabase.Refresh();
        Debug.Log("BattleHeroListSkillCardBindClip05 generated. template=" + templateFound + ", container=" + containerFound + ", cards=" + rows.Count);
    }

    private static void BindHeroCards(RectTransform container, GameObject template, Dictionary<string, List<Battle29SpritePngEntry>> spriteIndex, List<Battle29HeroCardRow> rows)
    {
        var heroes = new[]
        {
            new Battle29HeroCardData { slot = 1, heroDid = "1036", heroId = "51469", headSprite = "head1036", headOutput = "extracted/unity/bundles/b_6ca02dad4f8af848/images/S/-1006758698391221614_head1036.png", normalSkill = "1036101", smallSkill = "1036201", bigSkill = "1036301" },
            new Battle29HeroCardData { slot = 2, heroDid = "1002", heroId = "50870", headSprite = "head1002", headOutput = "extracted/unity/bundles/b_6ca02dad4f8af848/images/S/-296058673418415307_head1002.png", normalSkill = "1002101", smallSkill = "1002201", bigSkill = "1002301" },
            new Battle29HeroCardData { slot = 3, heroDid = "1034", heroId = "50874", headSprite = "head1034", headOutput = "extracted/unity/bundles/b_6ca02dad4f8af848/images/S/401204702686331365_head1034.png", normalSkill = "1034101", smallSkill = "1034201", bigSkill = "1034301" },
        };

        var containerRect = container.rect;
        float spacing = Mathf.Clamp(containerRect.width / 4f, 130f, 190f);
        float startX = -spacing;
        for (int i = 0; i < heroes.Length; i++)
        {
            var hero = heroes[i];
            var clone = (GameObject)GameObject.Instantiate(template);
            clone.name = "Battle29BoundHeroCard_" + hero.slot + "_" + hero.heroDid;
            clone.transform.SetParent(container, false);
            clone.SetActive(true);

            var rect = clone.transform as RectTransform;
            if (rect != null)
            {
                rect.anchorMin = new Vector2(0.5f, 0f);
                rect.anchorMax = new Vector2(0.5f, 0f);
                rect.pivot = new Vector2(0.5f, 0f);
                if (rect.sizeDelta.x < 10f || rect.sizeDelta.y < 10f) rect.sizeDelta = new Vector2(180f, 120f);
                rect.anchoredPosition = new Vector2(startX + i * spacing, 0f);
                rect.localScale = Vector3.one;
            }

            int activeFixCount = ActivateVisibleCardChildren(clone);
            int extractedSpriteBindCount = ApplyExtractedSpriteBindings(clone, spriteIndex);
            int headBindCount = BindHeroHeadSprites(clone, hero);
            int hiddenUnresolvedWhiteDataIconCount = HideUnresolvedWhiteDataIcons(clone);
            var row = new Battle29HeroCardRow();
            row.slot = hero.slot;
            row.heroDid = hero.heroDid;
            row.heroId = hero.heroId;
            row.normalSkill = hero.normalSkill;
            row.smallSkill = hero.smallSkill;
            row.bigSkill = hero.bigSkill;
            row.cloneName = clone.name;
            row.hierarchyPath = HierarchyPath(clone.transform, container);
            row.anchoredPosition = rect != null ? Vec2(rect.anchoredPosition) : "";
            row.sizeDelta = rect != null ? Vec2(rect.sizeDelta) : "";
            row.activeFixCount = activeFixCount;
            row.headBindCount = headBindCount;
            row.extractedSpriteBindCount = extractedSpriteBindCount;
            row.hiddenUnresolvedWhiteDataIconCount = hiddenUnresolvedWhiteDataIconCount;
            row.imageCount = clone.GetComponentsInChildren<Image>(true).Length;
            row.visibleImageCount = CountVisibleImages(clone);
            row.visibleWhiteLikeImagePaths = CollectVisibleWhiteLikeImages(clone);
            row.visibleWhiteLikeImageCount = row.visibleWhiteLikeImagePaths.Count;
            row.headSprite = hero.headSprite;
            row.headPngPath = Path.Combine(MergedExtractedRoot, hero.headOutput.Replace('/', Path.DirectorySeparatorChar));
            rows.Add(row);
        }
    }

    private static int ActivateVisibleCardChildren(GameObject root)
    {
        int count = 0;
        foreach (var transform in root.GetComponentsInChildren<Transform>(true))
        {
            string name = transform.name.ToLowerInvariant();
            bool shouldActivate =
                name.Contains("imgicon") ||
                name.Contains("hearbar") ||
                name.Contains("im_smallskill") ||
                name.Contains("im_bigskill") ||
                name.Contains("imgfury") ||
                name.Contains("im_jiantou") ||
                name.Contains("im_head") ||
                name.Contains("tweener");
            if (shouldActivate && !transform.gameObject.activeSelf)
            {
                transform.gameObject.SetActive(true);
                count++;
            }
        }
        return count;
    }

    private static Dictionary<string, List<Battle29SpritePngEntry>> LoadSpritePngIndex()
    {
        var index = new Dictionary<string, List<Battle29SpritePngEntry>>(StringComparer.Ordinal);
        if (!File.Exists(SpriteIndexPath)) return index;
        var lines = File.ReadAllLines(SpriteIndexPath, Encoding.UTF8);
        for (int i = 1; i < lines.Length; i++)
        {
            var parts = lines[i].Split(',');
            if (parts.Length < 7) continue;
            if (string.IsNullOrEmpty(parts[3])) continue;
            var entry = new Battle29SpritePngEntry();
            entry.bundle = parts[0];
            entry.pathId = parts[1];
            entry.assetType = parts[2];
            entry.name = parts[3];
            int.TryParse(parts[4], out entry.width);
            int.TryParse(parts[5], out entry.height);
            entry.output = parts[6];
            entry.absolutePath = Path.Combine(MergedExtractedRoot, entry.output.Replace('/', Path.DirectorySeparatorChar));
            if (!File.Exists(entry.absolutePath)) continue;
            if (!index.ContainsKey(entry.name)) index[entry.name] = new List<Battle29SpritePngEntry>();
            index[entry.name].Add(entry);
        }
        return index;
    }

    private static int ApplyExtractedSpriteBindings(GameObject root, Dictionary<string, List<Battle29SpritePngEntry>> index)
    {
        if (index == null || index.Count == 0) return 0;
        int count = 0;
        var textureCache = new Dictionary<string, Texture2D>(StringComparer.OrdinalIgnoreCase);
        foreach (var image in root.GetComponentsInChildren<Image>(true))
        {
            string spriteName = image.sprite != null ? image.sprite.name : "";
            if (string.IsNullOrEmpty(spriteName)) continue;
            var entry = ChooseSpritePngEntry(spriteName, image, index);
            if (entry == null) continue;
            var texture = LoadIndexedTexture(entry, textureCache);
            if (texture == null) continue;
            var oldSprite = image.sprite;
            float ppu = oldSprite != null && oldSprite.pixelsPerUnit > 0.01f ? oldSprite.pixelsPerUnit : 100f;
            Vector4 border = oldSprite != null ? oldSprite.border : Vector4.zero;
            var sprite = Sprite.Create(texture, new Rect(0f, 0f, texture.width, texture.height), new Vector2(0.5f, 0.5f), ppu, 0, SpriteMeshType.FullRect, border);
            sprite.name = spriteName;
            image.sprite = sprite;
            image.color = new Color(image.color.r, image.color.g, image.color.b, image.color.a);
            count++;
        }
        return count;
    }

    private static Battle29SpritePngEntry ChooseSpritePngEntry(string spriteName, Image image, Dictionary<string, List<Battle29SpritePngEntry>> index)
    {
        if (!index.ContainsKey(spriteName)) return null;
        Battle29SpritePngEntry best = null;
        int bestScore = int.MinValue;
        foreach (var entry in index[spriteName])
        {
            int score = entry.width * entry.height;
            string bundle = (entry.bundle ?? "").ToLowerInvariant();
            if (bundle.Contains("/uibattle.assetbundle")) score += 200000000;
            if (bundle.Contains("/uicommonother.assetbundle")) score += 120000000;
            if (bundle.Contains("/uiherohead/")) score += 250000000;
            if (bundle.Contains("/uiheroheadbattle.assetbundle")) score += 250000000;
            if (bundle.Contains("/uibutton.assetbundle")) score += 40000000;
            if (spriteName.StartsWith("head", StringComparison.Ordinal) && bundle.Contains("/uiherohead/")) score += 300000000;
            if (image != null && image.sprite != null)
            {
                var rect = image.sprite.rect;
                if (Mathf.Abs(rect.width - entry.width) <= 2f && Mathf.Abs(rect.height - entry.height) <= 2f) score += 5000000;
            }
            if (score > bestScore)
            {
                best = entry;
                bestScore = score;
            }
        }
        return best;
    }

    private static Texture2D LoadIndexedTexture(Battle29SpritePngEntry entry, Dictionary<string, Texture2D> cache)
    {
        if (cache.ContainsKey(entry.absolutePath)) return cache[entry.absolutePath];
        try
        {
            byte[] bytes = File.ReadAllBytes(entry.absolutePath);
            var texture = new Texture2D(2, 2, TextureFormat.RGBA32, false);
            texture.name = entry.name + "_battle29_index_png";
            if (!texture.LoadImage(bytes, false))
            {
                UnityEngine.Object.DestroyImmediate(texture);
                return null;
            }
            texture.wrapMode = TextureWrapMode.Clamp;
            texture.filterMode = FilterMode.Bilinear;
            cache[entry.absolutePath] = texture;
            return texture;
        }
        catch
        {
            return null;
        }
    }

    private static int BindHeroHeadSprites(GameObject root, Battle29HeroCardData hero)
    {
        string path = Path.Combine(MergedExtractedRoot, hero.headOutput.Replace('/', Path.DirectorySeparatorChar));
        Sprite sprite = LoadPngSprite(path, hero.headSprite);
        if (sprite == null) return 0;
        int count = 0;
        foreach (var image in root.GetComponentsInChildren<Image>(true))
        {
            string name = image.name.ToLowerInvariant();
            string spriteName = image.sprite != null ? image.sprite.name.ToLowerInvariant() : "";
            bool isHeadSlot = name.Contains("head") || spriteName.StartsWith("head") || root == image.gameObject;
            if (!isHeadSlot) continue;
            image.sprite = sprite;
            image.color = Color.white;
            image.preserveAspect = true;
            count++;
        }
        return count;
    }

    private static Sprite LoadPngSprite(string path, string spriteName)
    {
        if (!File.Exists(path)) return null;
        try
        {
            var texture = new Texture2D(2, 2, TextureFormat.RGBA32, false);
            texture.name = spriteName + "_battle29_png";
            if (!texture.LoadImage(File.ReadAllBytes(path), false))
            {
                UnityEngine.Object.DestroyImmediate(texture);
                return null;
            }
            texture.wrapMode = TextureWrapMode.Clamp;
            texture.filterMode = FilterMode.Bilinear;
            var sprite = Sprite.Create(texture, new Rect(0f, 0f, texture.width, texture.height), new Vector2(0.5f, 0.5f), 100f);
            sprite.name = spriteName;
            return sprite;
        }
        catch
        {
            return null;
        }
    }

    private static GameObject FindByPathContains(GameObject root, string pathNeedle)
    {
        if (root == null) return null;
        foreach (var transform in root.GetComponentsInChildren<Transform>(true))
        {
            string path = HierarchyPath(transform, root.transform).Replace("\\", "/");
            if (path.IndexOf(pathNeedle, StringComparison.OrdinalIgnoreCase) >= 0) return transform.gameObject;
        }
        return null;
    }

    private static GameObject FindByNameContains(GameObject root, string nameNeedle)
    {
        if (root == null) return null;
        foreach (var transform in root.GetComponentsInChildren<Transform>(true))
        {
            if (transform.name.IndexOf(nameNeedle, StringComparison.OrdinalIgnoreCase) >= 0) return transform.gameObject;
        }
        return null;
    }

    private static int CountVisibleImages(GameObject root)
    {
        int count = 0;
        foreach (var image in root.GetComponentsInChildren<Image>(true))
        {
            if (image.enabled && image.gameObject.activeInHierarchy && image.color.a > 0.01f) count++;
        }
        return count;
    }

    private static int HideUnresolvedWhiteDataIcons(GameObject root)
    {
        int count = 0;
        foreach (var image in root.GetComponentsInChildren<Image>(true))
        {
            if (!image.enabled || !image.gameObject.activeInHierarchy || image.color.a <= 0.01f) continue;
            string name = image.name.ToLowerInvariant();
            bool dataIcon = name == "im_frame" || name == "im_quality" || name == "im_zhiye";
            if (!dataIcon) continue;
            bool missingTexture = image.sprite == null;
            try
            {
                missingTexture = image.sprite == null || image.sprite.texture == null || image.sprite.texture.width <= 2 || image.sprite.texture.height <= 2;
            }
            catch
            {
                missingTexture = true;
            }
            if (!missingTexture) continue;
            image.gameObject.SetActive(false);
            count++;
        }
        return count;
    }

    private static List<string> CollectVisibleWhiteLikeImages(GameObject root)
    {
        var paths = new List<string>();
        foreach (var image in root.GetComponentsInChildren<Image>(true))
        {
            if (!image.enabled || !image.gameObject.activeInHierarchy || image.color.a <= 0.01f) continue;
            bool whiteColor = image.color.r > 0.86f && image.color.g > 0.86f && image.color.b > 0.86f;
            bool missingTexture = image.sprite == null;
            try
            {
                missingTexture = image.sprite == null || image.sprite.texture == null || image.sprite.texture.width <= 2 || image.sprite.texture.height <= 2;
            }
            catch
            {
                missingTexture = true;
            }
            if (whiteColor && missingTexture) paths.Add(HierarchyPath(image.transform, root.transform));
        }
        return paths;
    }

    private static bool Capture(Camera camera)
    {
        if (camera == null) return false;
        try
        {
            string fullPath = ProjectPath(CapturePath);
            Directory.CreateDirectory(Path.GetDirectoryName(fullPath));
            var rt = new RenderTexture(CaptureWidth, CaptureHeight, 24);
            camera.targetTexture = rt;
            var previous = RenderTexture.active;
            RenderTexture.active = rt;
            Canvas.ForceUpdateCanvases();
            camera.Render();
            var texture = new Texture2D(CaptureWidth, CaptureHeight, TextureFormat.RGB24, false);
            texture.ReadPixels(new Rect(0, 0, CaptureWidth, CaptureHeight), 0, 0);
            texture.Apply();
            File.WriteAllBytes(fullPath, texture.EncodeToPNG());
            camera.targetTexture = null;
            RenderTexture.active = previous;
            UnityEngine.Object.DestroyImmediate(texture);
            UnityEngine.Object.DestroyImmediate(rt);
            return File.Exists(fullPath);
        }
        catch
        {
            return false;
        }
    }

    private static void WriteJson(string path, bool templateFound, bool containerFound, List<Battle29HeroCardRow> rows, bool captureExists)
    {
        Directory.CreateDirectory(Path.GetDirectoryName(path));
        int headBindCount = 0;
        int extractedSpriteBindCount = 0;
        int hiddenUnresolvedWhiteDataIconCount = 0;
        int visibleImageCount = 0;
        int whiteLikeImageCount = 0;
        foreach (var row in rows)
        {
            headBindCount += row.headBindCount;
            extractedSpriteBindCount += row.extractedSpriteBindCount;
            hiddenUnresolvedWhiteDataIconCount += row.hiddenUnresolvedWhiteDataIconCount;
            visibleImageCount += row.visibleImageCount;
            whiteLikeImageCount += row.visibleWhiteLikeImageCount;
        }

        var sb = new StringBuilder();
        sb.AppendLine("{");
        sb.AppendLine("  \"status\": \"battle29_hero_list_skillcard_bind_clip05\",");
        sb.AppendLine("  \"isFinalRestoredBattleScreen\": false,");
        sb.AppendLine("  \"templateSource\": \"ui_normalbattle_heroitem prefab from battle_ext_prefabs\",");
        sb.AppendLine("  \"targetContainer\": \"ui_normalbattle/root_battle/BottomCenter/HeroListContainer\",");
        sb.AppendLine("  \"templateFound\": " + Bool(templateFound) + ",");
        sb.AppendLine("  \"containerFound\": " + Bool(containerFound) + ",");
        sb.AppendLine("  \"boundHeroCardCount\": " + rows.Count + ",");
        sb.AppendLine("  \"headSpriteBindCount\": " + headBindCount + ",");
        sb.AppendLine("  \"extractedSpriteBindCount\": " + extractedSpriteBindCount + ",");
        sb.AppendLine("  \"hiddenUnresolvedWhiteDataIconCount\": " + hiddenUnresolvedWhiteDataIconCount + ",");
        sb.AppendLine("  \"visibleCardImageCount\": " + visibleImageCount + ",");
        sb.AppendLine("  \"visibleWhiteLikeCardImageCount\": " + whiteLikeImageCount + ",");
        sb.AppendLine("  \"capture\": \"" + Json(Path.GetFullPath(ProjectPath(CapturePath))) + "\",");
        sb.AppendLine("  \"captureExists\": " + Bool(captureExists && File.Exists(ProjectPath(CapturePath))) + ",");
        sb.AppendLine("  \"cards\": [");
        for (int i = 0; i < rows.Count; i++)
        {
            var row = rows[i];
            sb.Append("    {\"slot\":" + row.slot + ",\"heroDid\":\"" + Json(row.heroDid) + "\",\"heroId\":\"" + Json(row.heroId) + "\",\"cloneName\":\"" + Json(row.cloneName) + "\",\"hierarchyPath\":\"" + Json(row.hierarchyPath) + "\",\"anchoredPosition\":\"" + Json(row.anchoredPosition) + "\",\"sizeDelta\":\"" + Json(row.sizeDelta) + "\",\"headSprite\":\"" + Json(row.headSprite) + "\",\"headPngPath\":\"" + Json(row.headPngPath) + "\",\"headBindCount\":" + row.headBindCount + ",\"extractedSpriteBindCount\":" + row.extractedSpriteBindCount + ",\"hiddenUnresolvedWhiteDataIconCount\":" + row.hiddenUnresolvedWhiteDataIconCount + ",\"activeFixCount\":" + row.activeFixCount + ",\"imageCount\":" + row.imageCount + ",\"visibleImageCount\":" + row.visibleImageCount + ",\"visibleWhiteLikeImageCount\":" + row.visibleWhiteLikeImageCount + ",\"visibleWhiteLikeImagePaths\":[");
            for (int w = 0; w < row.visibleWhiteLikeImagePaths.Count; w++)
            {
                sb.Append("\"" + Json(row.visibleWhiteLikeImagePaths[w]) + "\"");
                if (w + 1 < row.visibleWhiteLikeImagePaths.Count) sb.Append(",");
            }
            sb.Append("],\"normalSkill\":\"" + Json(row.normalSkill) + "\",\"smallSkill\":\"" + Json(row.smallSkill) + "\",\"bigSkill\":\"" + Json(row.bigSkill) + "\"}");
            sb.AppendLine(i + 1 == rows.Count ? "" : ",");
        }
        sb.AppendLine("  ]");
        sb.AppendLine("}");
        File.WriteAllText(path, sb.ToString(), Encoding.UTF8);
    }

    private static string HierarchyPath(Transform transform, Transform stop)
    {
        var names = new List<string>();
        var cursor = transform;
        while (cursor != null)
        {
            names.Add(cursor.name);
            if (cursor == stop) break;
            cursor = cursor.parent;
        }
        names.Reverse();
        return string.Join("/", names.ToArray());
    }

    private static string ProjectPath(string assetPath) { return Path.Combine(Application.dataPath, "..", assetPath); }
    private static string Json(string value) { return (value ?? "").Replace("\\", "\\\\").Replace("\"", "\\\"").Replace("\r", " ").Replace("\n", " "); }
    private static string Bool(bool value) { return value ? "true" : "false"; }
    private static string Vec2(Vector2 v) { return v.x.ToString("0.###") + "/" + v.y.ToString("0.###"); }
}

public sealed class Battle29HeroCardData
{
    public int slot;
    public string heroDid = "";
    public string heroId = "";
    public string headSprite = "";
    public string headOutput = "";
    public string normalSkill = "";
    public string smallSkill = "";
    public string bigSkill = "";
}

public sealed class Battle29HeroCardRow
{
    public int slot;
    public string heroDid = "";
    public string heroId = "";
    public string cloneName = "";
    public string hierarchyPath = "";
    public string anchoredPosition = "";
    public string sizeDelta = "";
    public string headSprite = "";
    public string headPngPath = "";
    public int headBindCount;
    public int extractedSpriteBindCount;
    public int hiddenUnresolvedWhiteDataIconCount;
    public int activeFixCount;
    public int imageCount;
    public int visibleImageCount;
    public int visibleWhiteLikeImageCount;
    public List<string> visibleWhiteLikeImagePaths = new List<string>();
    public string normalSkill = "";
    public string smallSkill = "";
    public string bigSkill = "";
}

public sealed class Battle29SpritePngEntry
{
    public string bundle = "";
    public string pathId = "";
    public string assetType = "";
    public string name = "";
    public int width;
    public int height;
    public string output = "";
    public string absolutePath = "";
}
