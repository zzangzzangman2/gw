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
using System.Text.RegularExpressions;

public static class BattleCorrectMapSceneHudPreviewClip05Editor
{
    private const string ResultJsonPath = "Assets/RestoreData/battle/BATTLE_CORRECT_MAP_SCENE_HUD_PREVIEW_CLIP05.json";
    private const string CapturePath = "Assets/RestoreCaptures/battle_hud/BattleCorrectMapSceneHudPreviewClip05_1680x720.png";
    private const string ScenePath = "Assets/Scenes/BattleCorrectMapSceneHudPreviewClip05.unity";
    private const string RuntimeFlowManifestPath = "Assets/RestoreData/battle/BATTLE_RUNTIME_FLOW_MANIFEST.json";
    private const string MergedExtractedRoot = @"C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted";

    [MenuItem("GirlsWar/Battle/Battle 27 Correct Map Scene HUD Preview Clip05")]
    public static void Build()
    {
        BattleHudSpriteAtlasTextureRuntimeBindingClip05Editor.Build();

        var hudRoot = GameObject.Find("BattleHudSpriteAtlasTextureRuntimeBindingClip05Root");
        var camera = GameObject.Find("BattleHudSpriteAtlasTextureRuntimeBindingClip05Camera") != null
            ? GameObject.Find("BattleHudSpriteAtlasTextureRuntimeBindingClip05Camera").GetComponent<Camera>()
            : EnsureCaptureCamera();

        int removedRootCount = RemoveNonCaptureRoots(hudRoot, camera);
        ConfigureCamera(camera);

        var previewRoot = new GameObject("BattleCorrectMapSceneHudPreviewClip05Root");
        previewRoot.transform.position = Vector3.zero;

        var mapLayers = BuildVideoMatchedMap(previewRoot.transform);
        var actorResults = InstantiateRuntimeActors(previewRoot.transform);
        int disabledNonHudTextCount = DisableNonHudText(hudRoot);
        int visibleSceneRendererCount = CountVisibleRenderers(previewRoot);
        int visibleSceneGraphicCount = CountVisibleGraphics(previewRoot);

        Canvas.ForceUpdateCanvases();
        bool captureExists = Capture(camera);
        WriteJson(ProjectPath(ResultJsonPath), mapLayers, actorResults, removedRootCount, disabledNonHudTextCount, visibleSceneRendererCount, visibleSceneGraphicCount, captureExists);

        EditorSceneManager.SaveScene(SceneManager.GetActiveScene(), ScenePath);
        AssetDatabase.Refresh();
        Debug.Log("BattleCorrectMapSceneHudPreviewClip05 generated. layers=" + mapLayers.Count + ", actors=" + actorResults.Count + ", capture=" + captureExists);
    }

    private static List<Battle27MapLayerResult> BuildVideoMatchedMap(Transform root)
    {
        var layers = new List<Battle27MapLayerResult>();
        layers.Add(CreateMapLayer(root, "Map_11003_5", "background_building_warm_lit", "extracted/unity/bundles/b_9d48e387e09bd2e7/images/S/-7856817432204118800_Map_11003_5.png", new Vector3(0f, 2.22f, 0f), 23.333f, 0));
        layers.Add(CreateMapLayer(root, "Map_11003_3", "upper_roof_and_far_depth", "extracted/unity/bundles/b_180ffe459f8c296a/images/S/7288649013814339085_Map_11003_3.png", new Vector3(0f, 2.85f, -0.02f), 23.333f, 1));
        layers.Add(CreateMapLayer(root, "Map_11003_4_2", "middle_house_layer", "extracted/unity/bundles/b_180ffe459f8c296a/images/S/-7820322519759755053_Map_11003_4_2.png", new Vector3(1.35f, 0.82f, -0.04f), 12.4f, 2));
        layers.Add(CreateMapLayer(root, "Map_11003_2", "stone_floor_video_best_match", "extracted/unity/bundles/b_180ffe459f8c296a/images/S/-6485743510393844429_Map_11003_2.png", new Vector3(0f, -2.05f, -0.06f), 23.333f, 3));
        return layers;
    }

    private static Battle27MapLayerResult CreateMapLayer(Transform root, string spriteName, string role, string output, Vector3 position, float worldWidth, int sortingOrder)
    {
        var result = new Battle27MapLayerResult();
        result.spriteName = spriteName;
        result.role = role;
        result.output = output;
        result.absolutePath = Path.Combine(MergedExtractedRoot, output.Replace('/', Path.DirectorySeparatorChar));
        result.exists = File.Exists(result.absolutePath);
        result.worldX = position.x;
        result.worldY = position.y;
        result.worldWidth = worldWidth;
        result.sortingOrder = sortingOrder;
        if (!result.exists) return result;

        try
        {
            var texture = new Texture2D(2, 2, TextureFormat.RGBA32, false);
            texture.name = spriteName + "_battle27_png";
            texture.LoadImage(File.ReadAllBytes(result.absolutePath), false);
            texture.wrapMode = TextureWrapMode.Clamp;
            texture.filterMode = FilterMode.Bilinear;
            result.pixelWidth = texture.width;
            result.pixelHeight = texture.height;
            result.worldHeight = worldWidth * texture.height / Mathf.Max(1f, texture.width);

            var sprite = Sprite.Create(texture, new Rect(0f, 0f, texture.width, texture.height), new Vector2(0.5f, 0.5f), 100f);
            sprite.name = spriteName;

            var go = new GameObject("Battle27MapLayer_" + sortingOrder.ToString("00") + "_" + spriteName);
            go.transform.SetParent(root, false);
            go.transform.position = position;
            float nativeWorldWidth = texture.width / 100f;
            float scale = worldWidth / Mathf.Max(0.001f, nativeWorldWidth);
            go.transform.localScale = new Vector3(scale, scale, 1f);
            var renderer = go.AddComponent<SpriteRenderer>();
            renderer.sprite = sprite;
            renderer.sortingOrder = sortingOrder;
            result.created = true;
        }
        catch (Exception ex)
        {
            result.failReason = ex.GetType().Name + ": " + ex.Message;
        }
        return result;
    }

    private static List<Battle27ActorResult> InstantiateRuntimeActors(Transform root)
    {
        var results = new List<Battle27ActorResult>();
        string manifestPath = ProjectPath(RuntimeFlowManifestPath);
        string json = File.Exists(manifestPath) ? File.ReadAllText(manifestPath, Encoding.UTF8) : "{}";
        var actors = ReadActorSlots(json);
        var bundles = new Dictionary<string, AssetBundle>(StringComparer.OrdinalIgnoreCase);
        foreach (var actor in actors)
        {
            var result = new Battle27ActorResult();
            result.side = actor.side;
            result.wave = actor.wave;
            result.slot = actor.slot;
            result.heroDid = actor.heroDid;
            result.modelId = actor.modelId;
            result.bundle = actor.bundle;
            result.absolutePath = actor.absolutePath;
            result.prefabAsset = actor.prefabAsset;
            result.loadStatus = actor.loadStatus;
            result.missingReason = actor.missingReason;
            result.x = actor.x;
            result.y = actor.y;
            result.scale = actor.scale;

            if (actor.loadStatus != "runtime_prefab" || string.IsNullOrEmpty(actor.absolutePath) || !File.Exists(actor.absolutePath))
            {
                result.instantiated = false;
                if (string.IsNullOrEmpty(result.missingReason)) result.missingReason = "no_runtime_prefab_or_bundle_file";
                results.Add(result);
                continue;
            }

            try
            {
                var bundle = LoadBundle(actor.absolutePath, bundles);
                result.bundleLoaded = bundle != null;
                if (bundle == null)
                {
                    result.failReason = "AssetBundle.LoadFromFile returned null";
                    results.Add(result);
                    continue;
                }
                GameObject prefab = null;
                if (!string.IsNullOrEmpty(actor.prefabAsset))
                {
                    try { prefab = bundle.LoadAsset<GameObject>(actor.prefabAsset); } catch { }
                }
                if (prefab == null)
                {
                    foreach (string assetName in bundle.GetAllAssetNames())
                    {
                        try
                        {
                            prefab = bundle.LoadAsset<GameObject>(assetName);
                            if (prefab != null)
                            {
                                result.prefabAsset = assetName;
                                break;
                            }
                        }
                        catch { }
                    }
                }
                if (prefab == null)
                {
                    result.failReason = "prefab_not_found_in_bundle";
                    results.Add(result);
                    continue;
                }

                var instance = (GameObject)GameObject.Instantiate(prefab);
                instance.name = "Battle27RuntimeActor_" + actor.side + "_w" + actor.wave + "_s" + actor.slot + "_" + actor.modelId;
                instance.transform.SetParent(root, false);
                instance.transform.position = new Vector3(actor.x, actor.y, -0.2f);
                float scale = actor.scale > 0.01f ? actor.scale : 0.7f;
                instance.transform.localScale = new Vector3(scale, scale, scale);
                DisableAllTextInside(instance);
                var actorAtlas = LoadActorAtlasTexture(actor.modelId, result);
                result.materialFallbackCount = RepairActorMaterials(instance, actorAtlas);
                result.actorAtlasTextureAssignCount = BindActorAtlasTexture(instance, actorAtlas);
                result.actorAtlasTextureBoundMaterialCount = CountActorAtlasTextureBound(instance, actorAtlas);
                result.renderOrderFixCount = ApplyActorRenderOrder(instance, actor.side == "enemy" ? 32 : 36);
                result.instantiated = true;
                result.enabledRendererCount = CountEnabledRenderers(instance);
                result.enabledGraphicCount = CountEnabledGraphics(instance);
                result.spineSkeletonGraphicCount = CountTypeName(instance, "Spine.Unity.SkeletonGraphic");
                result.spineSkeletonAnimationCount = CountTypeName(instance, "Spine.Unity.SkeletonAnimation");
            }
            catch (Exception ex)
            {
                result.failReason = ex.GetType().Name + ": " + ex.Message;
            }
            results.Add(result);
        }

        foreach (var pair in bundles)
        {
            if (pair.Value != null) pair.Value.Unload(false);
        }
        return results;
    }

    private static int RemoveNonCaptureRoots(GameObject hudRoot, Camera camera)
    {
        int removed = 0;
        var scene = SceneManager.GetActiveScene();
        foreach (var root in scene.GetRootGameObjects())
        {
            if (hudRoot != null && root == hudRoot) continue;
            if (camera != null && root == camera.gameObject) continue;
            UnityEngine.Object.DestroyImmediate(root);
            removed++;
        }
        return removed;
    }

    private static int DisableNonHudText(GameObject hudRoot)
    {
        int count = 0;
        foreach (var text in UnityEngine.Object.FindObjectsOfType<Text>(true))
        {
            if (hudRoot != null && IsChildOf(text.transform, hudRoot.transform)) continue;
            if (text.enabled) { text.enabled = false; count++; }
        }
        foreach (var tmp in UnityEngine.Object.FindObjectsOfType<TMP_Text>(true))
        {
            if (hudRoot != null && IsChildOf(tmp.transform, hudRoot.transform)) continue;
            if (tmp.enabled) { tmp.enabled = false; count++; }
        }
        foreach (var textMesh in UnityEngine.Object.FindObjectsOfType<TextMesh>(true))
        {
            if (hudRoot != null && IsChildOf(textMesh.transform, hudRoot.transform)) continue;
            if (textMesh.gameObject.activeSelf) { textMesh.gameObject.SetActive(false); count++; }
        }
        return count;
    }

    private static void DisableAllTextInside(GameObject root)
    {
        foreach (var text in root.GetComponentsInChildren<Text>(true)) text.enabled = false;
        foreach (var tmp in root.GetComponentsInChildren<TMP_Text>(true)) tmp.enabled = false;
        foreach (var textMesh in root.GetComponentsInChildren<TextMesh>(true)) textMesh.gameObject.SetActive(false);
    }

    private static Texture2D LoadActorAtlasTexture(string modelId, Battle27ActorResult result)
    {
        string output = ActorAtlasOutput(modelId);
        if (string.IsNullOrEmpty(output)) return null;
        string path = Path.Combine(MergedExtractedRoot, output.Replace('/', Path.DirectorySeparatorChar));
        result.actorAtlasPngPath = path;
        if (!File.Exists(path)) return null;
        try
        {
            var texture = new Texture2D(2, 2, TextureFormat.RGBA32, false);
            texture.name = "Battle27ActorAtlas_" + modelId;
            if (!texture.LoadImage(File.ReadAllBytes(path), false))
            {
                UnityEngine.Object.DestroyImmediate(texture);
                return null;
            }
            texture.wrapMode = TextureWrapMode.Clamp;
            texture.filterMode = FilterMode.Bilinear;
            result.actorAtlasTextureLoaded = true;
            return texture;
        }
        catch
        {
            return null;
        }
    }

    private static string ActorAtlasOutput(string modelId)
    {
        if (modelId == "1002") return "extracted/unity/bundles/b_a11e4439fd9a0a50/images/T/2058673591951818171_1002.png";
        if (modelId == "1034") return "extracted/unity/bundles/b_da97dc9c8e06fcb3/images/T/-8601115882506527001_1034.png";
        if (modelId == "3001") return "extracted/unity/bundles/b_5a764c3b78a2386a/images/T/-9168546056666942066_3001.png";
        return "";
    }

    private static int RepairActorMaterials(GameObject root, Texture2D actorAtlas)
    {
        int count = 0;
        foreach (var renderer in root.GetComponentsInChildren<Renderer>(true))
        {
            var materials = renderer.sharedMaterials;
            bool changed = false;
            for (int i = 0; i < materials.Length; i++)
            {
                if (!NeedsMaterialFallback(materials[i])) continue;
                materials[i] = CreateFallbackMaterial(materials[i], false, actorAtlas);
                changed = true;
                count++;
            }
            if (changed) renderer.sharedMaterials = materials;
        }

        foreach (var graphic in root.GetComponentsInChildren<Graphic>(true))
        {
            if (!NeedsMaterialFallback(graphic.material)) continue;
            graphic.material = CreateFallbackMaterial(graphic.material, true, actorAtlas);
            count++;
        }
        return count;
    }

    private static int BindActorAtlasTexture(GameObject root, Texture2D actorAtlas)
    {
        if (actorAtlas == null) return 0;
        int count = 0;
        foreach (var renderer in root.GetComponentsInChildren<Renderer>(true))
        {
            var materials = renderer.sharedMaterials;
            for (int i = 0; i < materials.Length; i++)
            {
                if (TryAssignMainTexture(materials[i], actorAtlas)) count++;
            }
        }
        foreach (var graphic in root.GetComponentsInChildren<Graphic>(true))
        {
            if (TryAssignMainTexture(graphic.material, actorAtlas)) count++;
        }
        return count;
    }

    private static int CountActorAtlasTextureBound(GameObject root, Texture2D actorAtlas)
    {
        if (actorAtlas == null) return 0;
        int count = 0;
        foreach (var renderer in root.GetComponentsInChildren<Renderer>(true))
        {
            foreach (var material in renderer.sharedMaterials)
            {
                if (MaterialHasMainTexture(material, actorAtlas)) count++;
            }
        }
        foreach (var graphic in root.GetComponentsInChildren<Graphic>(true))
        {
            if (MaterialHasMainTexture(graphic.material, actorAtlas)) count++;
        }
        return count;
    }

    private static bool MaterialHasMainTexture(Material material, Texture texture)
    {
        if (material == null || texture == null) return false;
        try
        {
            return material.HasProperty("_MainTex") && material.GetTexture("_MainTex") == texture;
        }
        catch
        {
            return false;
        }
    }

    private static int ApplyActorRenderOrder(GameObject root, int sortingOrder)
    {
        int count = 0;
        foreach (var renderer in root.GetComponentsInChildren<Renderer>(true))
        {
            renderer.sortingOrder = sortingOrder;
            count++;
        }
        return count;
    }

    private static bool NeedsMaterialFallback(Material material)
    {
        if (material == null || material.shader == null) return true;
        string shaderName = material.shader.name ?? "";
        if (shaderName.IndexOf("InternalErrorShader", StringComparison.OrdinalIgnoreCase) >= 0) return true;
        if (shaderName.IndexOf("Hidden/InternalErrorShader", StringComparison.OrdinalIgnoreCase) >= 0) return true;
        return false;
    }

    private static Material CreateFallbackMaterial(Material source, bool ui, Texture2D actorAtlas)
    {
        Shader shader = ui ? Shader.Find("UI/Default") : Shader.Find("Sprites/Default");
        if (shader == null) shader = Shader.Find("Unlit/Transparent");
        if (shader == null) shader = Shader.Find("Unlit/Texture");
        if (shader == null) shader = Shader.Find("Standard");
        var replacement = new Material(shader);
        replacement.name = (source != null ? source.name : "null_material") + "_battle27_fallback";
        if (source != null)
        {
            TryCopyTexture(source, replacement, "_MainTex");
            TryCopyTexture(source, replacement, "_Texture");
            TryCopyColor(source, replacement, "_Color");
            TryCopyColor(source, replacement, "_TintColor");
        }
        TryAssignMainTexture(replacement, actorAtlas);
        return replacement;
    }

    private static bool TryAssignMainTexture(Material material, Texture texture)
    {
        if (material == null || texture == null) return false;
        try
        {
            if (!material.HasProperty("_MainTex")) return false;
            var existing = material.GetTexture("_MainTex");
            if (existing != null && existing.width > 4 && existing.height > 4) return false;
            material.SetTexture("_MainTex", texture);
            return true;
        }
        catch
        {
            return false;
        }
    }

    private static void TryCopyTexture(Material source, Material target, string property)
    {
        try
        {
            if (source.HasProperty(property) && target.HasProperty("_MainTex"))
            {
                var texture = source.GetTexture(property);
                if (texture != null) target.SetTexture("_MainTex", texture);
            }
        }
        catch { }
    }

    private static void TryCopyColor(Material source, Material target, string property)
    {
        try
        {
            if (source.HasProperty(property) && target.HasProperty("_Color"))
            {
                target.SetColor("_Color", source.GetColor(property));
            }
        }
        catch { }
    }

    private static bool Capture(Camera camera)
    {
        try
        {
            string fullPath = ProjectPath(CapturePath);
            Directory.CreateDirectory(Path.GetDirectoryName(fullPath));
            var rt = new RenderTexture(1680, 720, 24);
            camera.targetTexture = rt;
            var previous = RenderTexture.active;
            RenderTexture.active = rt;
            Canvas.ForceUpdateCanvases();
            camera.Render();
            var texture = new Texture2D(1680, 720, TextureFormat.RGB24, false);
            texture.ReadPixels(new Rect(0, 0, 1680, 720), 0, 0);
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

    private static Camera EnsureCaptureCamera()
    {
        var go = new GameObject("BattleHudSpriteAtlasTextureRuntimeBindingClip05Camera");
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

    private static AssetBundle LoadBundle(string path, Dictionary<string, AssetBundle> bundles)
    {
        if (string.IsNullOrEmpty(path)) return null;
        if (bundles.ContainsKey(path)) return bundles[path];
        if (!File.Exists(path)) return null;
        try
        {
            var bundle = AssetBundle.LoadFromFile(path);
            if (bundle == null) return null;
            bundles[path] = bundle;
            return bundle;
        }
        catch
        {
            return null;
        }
    }

    private static List<Battle27ActorSlot> ReadActorSlots(string json)
    {
        var slots = new List<Battle27ActorSlot>();
        foreach (string block in ExtractObjectBlocks(ExtractArrayBlock(json, "\"actorSlots\"")))
        {
            slots.Add(new Battle27ActorSlot
            {
                side = ReadString(block, "side"),
                wave = ReadInt(block, "wave"),
                slot = ReadInt(block, "slot"),
                heroDid = ReadString(block, "heroDid"),
                modelId = ReadString(block, "modelId"),
                bundle = ReadString(block, "bundle"),
                absolutePath = ReadString(block, "absolutePath"),
                prefabAsset = ReadString(block, "prefabAsset"),
                loadStatus = ReadString(block, "loadStatus"),
                missingReason = ReadString(block, "missingReason"),
                x = ReadFloat(block, "x"),
                y = ReadFloat(block, "y"),
                scale = ReadFloat(block, "scale")
            });
        }
        return slots;
    }

    private static string ExtractArrayBlock(string json, string key)
    {
        int keyIndex = json.IndexOf(key, StringComparison.Ordinal);
        if (keyIndex < 0) return "";
        int start = json.IndexOf('[', keyIndex);
        if (start < 0) return "";
        int depth = 0; bool inString = false; bool escape = false;
        for (int i = start; i < json.Length; i++)
        {
            char c = json[i];
            if (inString)
            {
                if (escape) escape = false;
                else if (c == '\\') escape = true;
                else if (c == '"') inString = false;
                continue;
            }
            if (c == '"') { inString = true; continue; }
            if (c == '[') depth++;
            else if (c == ']') depth--;
            if (depth == 0) return json.Substring(start, i - start + 1);
        }
        return "";
    }

    private static List<string> ExtractObjectBlocks(string arrayBlock)
    {
        var objects = new List<string>();
        int depth = 0; int start = -1; bool inString = false; bool escape = false;
        for (int i = 0; i < arrayBlock.Length; i++)
        {
            char c = arrayBlock[i];
            if (inString)
            {
                if (escape) escape = false;
                else if (c == '\\') escape = true;
                else if (c == '"') inString = false;
                continue;
            }
            if (c == '"') { inString = true; continue; }
            if (c == '{') { if (depth == 0) start = i; depth++; }
            else if (c == '}') { depth--; if (depth == 0 && start >= 0) objects.Add(arrayBlock.Substring(start, i - start + 1)); }
        }
        return objects;
    }

    private static string ReadString(string block, string key)
    {
        var match = Regex.Match(block, "\"" + Regex.Escape(key) + "\"\\s*:\\s*\"((?:\\\\.|[^\"])*)\"");
        return match.Success ? match.Groups[1].Value.Replace("\\\\", "\\") : "";
    }

    private static int ReadInt(string block, string key)
    {
        var match = Regex.Match(block, "\"" + Regex.Escape(key) + "\"\\s*:\\s*(-?\\d+)");
        int value;
        return match.Success && int.TryParse(match.Groups[1].Value, out value) ? value : 0;
    }

    private static float ReadFloat(string block, string key)
    {
        var match = Regex.Match(block, "\"" + Regex.Escape(key) + "\"\\s*:\\s*(-?\\d+(?:\\.\\d+)?)");
        float value;
        return match.Success && float.TryParse(match.Groups[1].Value, System.Globalization.NumberStyles.Float, System.Globalization.CultureInfo.InvariantCulture, out value) ? value : 0f;
    }

    private static int CountVisibleRenderers(GameObject root)
    {
        int count = 0;
        foreach (var renderer in root.GetComponentsInChildren<Renderer>(true))
        {
            if (renderer.enabled && renderer.gameObject.activeInHierarchy) count++;
        }
        return count;
    }

    private static int CountVisibleGraphics(GameObject root)
    {
        int count = 0;
        foreach (var graphic in root.GetComponentsInChildren<Graphic>(true))
        {
            if (graphic.enabled && graphic.gameObject.activeInHierarchy && graphic.color.a > 0.01f) count++;
        }
        return count;
    }

    private static int CountEnabledRenderers(GameObject root)
    {
        int count = 0;
        foreach (var renderer in root.GetComponentsInChildren<Renderer>(true))
        {
            if (renderer.enabled) count++;
        }
        return count;
    }

    private static int CountEnabledGraphics(GameObject root)
    {
        int count = 0;
        foreach (var graphic in root.GetComponentsInChildren<Graphic>(true))
        {
            if (graphic.enabled && graphic.color.a > 0.01f) count++;
        }
        return count;
    }

    private static int CountTypeName(GameObject root, string typeName)
    {
        int count = 0;
        foreach (var component in root.GetComponentsInChildren<Component>(true))
        {
            if (component != null && component.GetType().FullName == typeName) count++;
        }
        return count;
    }

    private static bool IsChildOf(Transform transform, Transform root)
    {
        var cursor = transform;
        while (cursor != null)
        {
            if (cursor == root) return true;
            cursor = cursor.parent;
        }
        return false;
    }

    private static void WriteJson(string path, List<Battle27MapLayerResult> mapLayers, List<Battle27ActorResult> actors, int removedRootCount, int disabledNonHudTextCount, int visibleSceneRendererCount, int visibleSceneGraphicCount, bool captureExists)
    {
        Directory.CreateDirectory(Path.GetDirectoryName(path));
        int createdLayerCount = 0;
        foreach (var layer in mapLayers) if (layer.created) createdLayerCount++;
        int instantiatedActorCount = 0;
        int actorRendererCount = 0;
        int actorGraphicCount = 0;
        int spineGraphicCount = 0;
        int materialFallbackCount = 0;
        int renderOrderFixCount = 0;
        int actorAtlasTextureAssignCount = 0;
        int actorAtlasTextureBoundMaterialCount = 0;
        foreach (var actor in actors)
        {
            if (actor.instantiated) instantiatedActorCount++;
            actorRendererCount += actor.enabledRendererCount;
            actorGraphicCount += actor.enabledGraphicCount;
            spineGraphicCount += actor.spineSkeletonGraphicCount + actor.spineSkeletonAnimationCount;
            materialFallbackCount += actor.materialFallbackCount;
            renderOrderFixCount += actor.renderOrderFixCount;
            actorAtlasTextureAssignCount += actor.actorAtlasTextureAssignCount;
            actorAtlasTextureBoundMaterialCount += actor.actorAtlasTextureBoundMaterialCount;
        }

        var sb = new StringBuilder();
        sb.AppendLine("{");
        sb.AppendLine("  \"status\": \"battle27_correct_map_scene_hud_preview\",");
        sb.AppendLine("  \"isFinalRestoredBattleScreen\": false,");
        sb.AppendLine("  \"referenceVideo\": \"C:\\\\Users\\\\godho\\\\Downloads\\\\플레이.mp4\",");
        sb.AppendLine("  \"referenceClip\": \"clip05 around 486s\",");
        sb.AppendLine("  \"mapChosenByVideoEvidence\": 11003,");
        sb.AppendLine("  \"runtimeFlowManifestMapId\": 11001,");
        sb.AppendLine("  \"capture\": \"" + Json(Path.GetFullPath(ProjectPath(CapturePath))) + "\",");
        sb.AppendLine("  \"captureExists\": " + Bool(captureExists && File.Exists(ProjectPath(CapturePath))) + ",");
        sb.AppendLine("  \"removedDiagnosticRootCount\": " + removedRootCount + ",");
        sb.AppendLine("  \"disabledNonHudTextCount\": " + disabledNonHudTextCount + ",");
        sb.AppendLine("  \"mapLayerCount\": " + mapLayers.Count + ",");
        sb.AppendLine("  \"mapLayerCreatedCount\": " + createdLayerCount + ",");
        sb.AppendLine("  \"runtimeActorSlotCount\": " + actors.Count + ",");
        sb.AppendLine("  \"runtimeActorInstantiatedCount\": " + instantiatedActorCount + ",");
        sb.AppendLine("  \"runtimeActorEnabledRendererCount\": " + actorRendererCount + ",");
        sb.AppendLine("  \"runtimeActorEnabledGraphicCount\": " + actorGraphicCount + ",");
        sb.AppendLine("  \"runtimeActorSpineComponentCount\": " + spineGraphicCount + ",");
        sb.AppendLine("  \"runtimeActorMaterialFallbackCount\": " + materialFallbackCount + ",");
        sb.AppendLine("  \"runtimeActorRenderOrderFixCount\": " + renderOrderFixCount + ",");
        sb.AppendLine("  \"runtimeActorAtlasTextureAssignCount\": " + actorAtlasTextureAssignCount + ",");
        sb.AppendLine("  \"runtimeActorAtlasTextureBoundMaterialCount\": " + actorAtlasTextureBoundMaterialCount + ",");
        sb.AppendLine("  \"sceneVisibleRendererCount\": " + visibleSceneRendererCount + ",");
        sb.AppendLine("  \"sceneVisibleGraphicCount\": " + visibleSceneGraphicCount + ",");
        sb.AppendLine("  \"mapLayers\": [");
        for (int i = 0; i < mapLayers.Count; i++)
        {
            var r = mapLayers[i];
            sb.Append("    {\"spriteName\":\"" + Json(r.spriteName) + "\",\"role\":\"" + Json(r.role) + "\",\"exists\":" + Bool(r.exists) + ",\"created\":" + Bool(r.created) + ",\"pixelWidth\":" + r.pixelWidth + ",\"pixelHeight\":" + r.pixelHeight + ",\"worldX\":" + Num(r.worldX) + ",\"worldY\":" + Num(r.worldY) + ",\"worldWidth\":" + Num(r.worldWidth) + ",\"worldHeight\":" + Num(r.worldHeight) + ",\"sortingOrder\":" + r.sortingOrder + ",\"output\":\"" + Json(r.output) + "\",\"failReason\":\"" + Json(r.failReason) + "\"}");
            sb.AppendLine(i + 1 == mapLayers.Count ? "" : ",");
        }
        sb.AppendLine("  ],");
        sb.AppendLine("  \"actors\": [");
        for (int i = 0; i < actors.Count; i++)
        {
            var r = actors[i];
            sb.Append("    {\"side\":\"" + Json(r.side) + "\",\"wave\":" + r.wave + ",\"slot\":" + r.slot + ",\"heroDid\":\"" + Json(r.heroDid) + "\",\"modelId\":\"" + Json(r.modelId) + "\",\"loadStatus\":\"" + Json(r.loadStatus) + "\",\"bundleLoaded\":" + Bool(r.bundleLoaded) + ",\"instantiated\":" + Bool(r.instantiated) + ",\"enabledRendererCount\":" + r.enabledRendererCount + ",\"enabledGraphicCount\":" + r.enabledGraphicCount + ",\"spineSkeletonGraphicCount\":" + r.spineSkeletonGraphicCount + ",\"spineSkeletonAnimationCount\":" + r.spineSkeletonAnimationCount + ",\"materialFallbackCount\":" + r.materialFallbackCount + ",\"renderOrderFixCount\":" + r.renderOrderFixCount + ",\"actorAtlasTextureLoaded\":" + Bool(r.actorAtlasTextureLoaded) + ",\"actorAtlasTextureAssignCount\":" + r.actorAtlasTextureAssignCount + ",\"actorAtlasTextureBoundMaterialCount\":" + r.actorAtlasTextureBoundMaterialCount + ",\"actorAtlasPngPath\":\"" + Json(r.actorAtlasPngPath) + "\",\"x\":" + Num(r.x) + ",\"y\":" + Num(r.y) + ",\"scale\":" + Num(r.scale) + ",\"bundle\":\"" + Json(r.bundle) + "\",\"prefabAsset\":\"" + Json(r.prefabAsset) + "\",\"missingReason\":\"" + Json(r.missingReason) + "\",\"failReason\":\"" + Json(r.failReason) + "\"}");
            sb.AppendLine(i + 1 == actors.Count ? "" : ",");
        }
        sb.AppendLine("  ]");
        sb.AppendLine("}");
        File.WriteAllText(path, sb.ToString(), Encoding.UTF8);
    }

    private static string ProjectPath(string assetPath) { return Path.Combine(Application.dataPath, "..", assetPath); }
    private static string Json(string value) { return (value ?? "").Replace("\\", "\\\\").Replace("\"", "\\\"").Replace("\r", " ").Replace("\n", " "); }
    private static string Bool(bool value) { return value ? "true" : "false"; }
    private static string Num(float value) { return value.ToString("0.######", System.Globalization.CultureInfo.InvariantCulture); }
}

public sealed class Battle27MapLayerResult
{
    public string spriteName = "";
    public string role = "";
    public string output = "";
    public string absolutePath = "";
    public bool exists;
    public bool created;
    public int pixelWidth;
    public int pixelHeight;
    public float worldX;
    public float worldY;
    public float worldWidth;
    public float worldHeight;
    public int sortingOrder;
    public string failReason = "";
}

public class Battle27ActorSlot
{
    public string side = "";
    public int wave;
    public int slot;
    public string heroDid = "";
    public string modelId = "";
    public string bundle = "";
    public string absolutePath = "";
    public string prefabAsset = "";
    public string loadStatus = "";
    public string missingReason = "";
    public float x;
    public float y;
    public float scale;
}

public sealed class Battle27ActorResult : Battle27ActorSlot
{
    public bool bundleLoaded;
    public bool instantiated;
    public int enabledRendererCount;
    public int enabledGraphicCount;
    public int spineSkeletonGraphicCount;
    public int spineSkeletonAnimationCount;
    public int materialFallbackCount;
    public int renderOrderFixCount;
    public bool actorAtlasTextureLoaded;
    public int actorAtlasTextureAssignCount;
    public int actorAtlasTextureBoundMaterialCount;
    public string actorAtlasPngPath = "";
    public string failReason = "";
}
