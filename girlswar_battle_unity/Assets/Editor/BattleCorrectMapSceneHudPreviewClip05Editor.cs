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
    private const string CapturePath = "Assets/RestoreCaptures/battle_hud/BattleCorrectMapSceneHudPreviewClip05_1920x1080.png";
    private const string ScenePath = "Assets/Scenes/BattleCorrectMapSceneHudPreviewClip05.unity";
    private const string RuntimeFlowManifestPath = "Assets/RestoreData/battle/BATTLE_RUNTIME_FLOW_MANIFEST.json";
    private const string MergedExtractedRoot = @"C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted";
    private const string Battlemap11003CleanBundlePath = @"C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\extracted\unity\clean_unityfs_slices\download\map\battlemap\11003.assetbundle";
    private const string Battlemap11003MergedBundlePath = @"C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\merged_content\AssetBundles\download\map\battlemap\11003.assetbundle";
    private const string Battlemap11003OverlayBundlePath = @"C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\restore_overlay\Android\data\com.girlwars.kr\files\build\download\map\battlemap\11003.assetbundle";
    private const string SpriteIndexPath = @"C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\indexes\unity_images.csv";
    private const int CaptureWidth = 1920;
    private const int CaptureHeight = 1080;

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

        var mapLayers = BuildVideoMatchedMapFromOriginalBundle(previewRoot.transform);
        bool originalBundleMapCreated = false;
        foreach (var layer in mapLayers) if (layer.created) originalBundleMapCreated = true;
        if (originalBundleMapCreated)
        {
            DisableOriginalBattlemapBundleVisualRoot();
        }
        mapLayers.AddRange(BuildVideoMatchedMap(previewRoot.transform));
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
        layers.Add(CreateMapLayerPixel(root, "Map_11003_11", "pixel_space_sky_mountain_strip_from_video_1920x1080", "extracted/unity/bundles/b_9d48e387e09bd2e7/images/S/5971460981514339809_Map_11003_11.png", 0f, 0f, 0));
        layers.Add(CreateMapLayerPixel(root, "Map_11003_5", "pixel_space_background_buildings_from_video_1920x1080", "extracted/unity/bundles/b_9d48e387e09bd2e7/images/S/-7856817432204118800_Map_11003_5.png", 0f, 0f, 1));
        layers.Add(CreateMapLayerPixel(root, "Map_11003_4_2", "pixel_space_center_house_from_original_prefab_name_bg4_2", "extracted/unity/bundles/b_180ffe459f8c296a/images/S/-7820322519759755053_Map_11003_4_2.png", 455f, 105f, 2));
        layers.Add(CreateMapLayerPixel(root, "Map_11003_4_1", "pixel_space_center_house_curtain_from_original_prefab_name_bg4_1", "extracted/unity/bundles/b_180ffe459f8c296a/images/S/-8270640840813032502_Map_11003_4_1.png", 710f, 260f, 3));
        layers.Add(CreateMapLayerPixel(root, "Map_11003_3", "pixel_space_midground_debris_from_video_1920x1080", "extracted/unity/bundles/b_180ffe459f8c296a/images/S/7288649013814339085_Map_11003_3.png", 0f, 335f, 4));
        layers.Add(CreateMapLayerPixel(root, "Map_11003_2", "pixel_space_stone_floor_video_best_match", "extracted/unity/bundles/b_180ffe459f8c296a/images/S/-6485743510393844429_Map_11003_2.png", 0f, 430f, 5));
        layers.Add(CreateMapLayerPixel(root, "Map_11003_1_3", "pixel_space_bottom_foreground_from_original_prefab_name_bg1_3", "extracted/unity/bundles/b_180ffe459f8c296a/images/S/-2714483910561799702_Map_11003_1_3.png", 700f, 895f, 6));
        layers.Add(CreateMapLayerPixel(root, "Map_11003_1_4", "pixel_space_bottom_foreground_from_original_prefab_name_bg1_4", "extracted/unity/bundles/b_180ffe459f8c296a/images/S/-7114534193537288331_Map_11003_1_4.png", 1200f, 905f, 7));
        layers.Add(CreateMapLayerPixel(root, "Map_11003_1_1", "pixel_space_bottom_foreground_from_original_prefab_name_bg1_1", "extracted/unity/bundles/b_180ffe459f8c296a/images/S/-8534531834521366686_Map_11003_1_1.png", 1500f, 900f, 8));
        return layers;
    }

    private static Battle27MapLayerResult CreateMapLayerPixel(Transform root, string spriteName, string role, string output, float pixelX, float pixelY, int sortingOrder)
    {
        var result = new Battle27MapLayerResult();
        result.spriteName = spriteName;
        result.role = role;
        result.output = output;
        result.absolutePath = Path.Combine(MergedExtractedRoot, output.Replace('/', Path.DirectorySeparatorChar));
        result.exists = File.Exists(result.absolutePath);
        result.pixelX = pixelX;
        result.pixelY = pixelY;
        result.sortingOrder = sortingOrder;
        if (!result.exists) return result;

        try
        {
            var texture = new Texture2D(2, 2, TextureFormat.RGBA32, false);
            texture.name = spriteName + "_battle27_pixel_png";
            texture.LoadImage(File.ReadAllBytes(result.absolutePath), false);
            texture.wrapMode = TextureWrapMode.Clamp;
            texture.filterMode = FilterMode.Bilinear;
            result.pixelWidth = texture.width;
            result.pixelHeight = texture.height;

            float pixelsPerWorldUnit = CaptureHeight / (5f * 2f);
            result.worldWidth = texture.width / pixelsPerWorldUnit;
            result.worldHeight = texture.height / pixelsPerWorldUnit;
            result.worldX = ((pixelX + texture.width * 0.5f) - CaptureWidth * 0.5f) / pixelsPerWorldUnit;
            result.worldY = (CaptureHeight * 0.5f - (pixelY + texture.height * 0.5f)) / pixelsPerWorldUnit;

            var sprite = Sprite.Create(texture, new Rect(0f, 0f, texture.width, texture.height), new Vector2(0.5f, 0.5f), 100f);
            sprite.name = spriteName;

            var go = new GameObject("Battle27PixelMapLayer_" + sortingOrder.ToString("00") + "_" + spriteName);
            go.transform.SetParent(root, false);
            go.transform.position = new Vector3(result.worldX, result.worldY, 0f - sortingOrder * 0.02f);
            float nativeWorldWidth = texture.width / 100f;
            float scale = result.worldWidth / Mathf.Max(0.001f, nativeWorldWidth);
            go.transform.localScale = new Vector3(scale, scale, 1f);
            var renderer = go.AddComponent<SpriteRenderer>();
            renderer.sprite = sprite;
            renderer.sortingOrder = sortingOrder;
            result.rendererCount = 1;
            result.created = true;
        }
        catch (Exception ex)
        {
            result.failReason = ex.GetType().Name + ": " + ex.Message;
        }
        return result;
    }

    private static int DisableOriginalBattlemapBundleVisualRoot()
    {
        var go = GameObject.Find("Battle27OriginalBattlemap11003Prefab");
        if (go == null) return 0;
        go.SetActive(false);
        return 1;
    }

    private static List<Battle27MapLayerResult> BuildVideoMatchedMapFromOriginalBundle(Transform root)
    {
        var layers = new List<Battle27MapLayerResult>();
        var result = new Battle27MapLayerResult();
        result.spriteName = "11003.assetbundle";
        result.role = "original_battlemap_prefab_scene_bundle";
        string[] candidates = Battlemap11003BundleCandidates();
        result.output = FirstJoined(candidates, 3);
        result.exists = AnyExisting(candidates);
        layers.Add(result);
        if (!result.exists)
        {
            result.failReason = "battlemap_11003_bundle_missing";
            return layers;
        }

        var loadFailures = new List<string>();
        foreach (string candidate in candidates)
        {
            if (!File.Exists(candidate)) continue;
            result.absolutePath = candidate;
            AssetBundle bundle = null;
            try
            {
                bundle = AssetBundle.LoadFromFile(candidate);
                if (bundle == null)
                {
                    loadFailures.Add(candidate + ": AssetBundle.LoadFromFile returned null");
                    continue;
                }

                string[] assetNames = bundle.GetAllAssetNames();
                result.bundleAssetNameSample = FirstJoined(assetNames, 8);
                GameObject prefab = null;
                string prefabAssetName = "";
                foreach (string assetName in assetNames)
                {
                    try
                    {
                        prefab = bundle.LoadAsset<GameObject>(assetName);
                        if (prefab != null)
                        {
                            prefabAssetName = assetName;
                            break;
                        }
                    }
                    catch { }
                }
                if (prefab == null)
                {
                    try
                    {
                        var all = bundle.LoadAllAssets<GameObject>();
                        if (all != null && all.Length > 0)
                        {
                            prefab = all[0];
                            prefabAssetName = prefab.name;
                        }
                    }
                    catch { }
                }
                if (prefab == null)
                {
                    loadFailures.Add(candidate + ": no_GameObject_asset_found_in_battlemap_bundle");
                    continue;
                }

                var instance = (GameObject)GameObject.Instantiate(prefab);
                instance.name = "Battle27OriginalBattlemap11003Prefab";
                instance.transform.SetParent(root, false);
                instance.transform.localPosition = Vector3.zero;
                instance.transform.localRotation = Quaternion.identity;
                instance.transform.localScale = Vector3.one;
                result.created = true;
                result.prefabAssetName = prefabAssetName;
                result.prefabInstanceName = instance.name;
                result.spriteRendererNameSample = CollectSpriteRendererNameSample(instance, false);
                result.spriteRendererSpriteSample = CollectSpriteRendererNameSample(instance, true);
                result.nullSpriteRendererCount = CountNullSpriteRenderers(instance);
                result.mapSpriteTextureBindCount = BindOriginalBattlemapSpriteTextures(instance);
                result.rendererCount = CountEnabledRenderers(instance);
                result.particleSystemCount = CountTypeName(instance, "UnityEngine.ParticleSystem");
                result.materialFallbackCount = RepairMapMaterials(instance);
                result.renderOrderFixCount = PreserveMapRenderers(instance);
                result.failReason = loadFailures.Count > 0 ? "fallback_attempts_before_success: " + string.Join(" | ", loadFailures.ToArray()) : "";
                return layers;
            }
            catch (Exception ex)
            {
                loadFailures.Add(candidate + ": " + ex.GetType().Name + ": " + ex.Message);
            }
            finally
            {
                if (bundle != null) bundle.Unload(false);
            }
        }
        result.failReason = string.Join(" | ", loadFailures.ToArray());
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

    private static int PreserveMapRenderers(GameObject root)
    {
        int count = 0;
        foreach (var renderer in root.GetComponentsInChildren<SpriteRenderer>(true))
        {
            renderer.enabled = true;
            count++;
        }
        return count;
    }

    private static int BindOriginalBattlemapSpriteTextures(GameObject root)
    {
        var index = LoadMapSpriteIndex();
        if (index.Count == 0) return 0;
        var textureCache = new Dictionary<string, Texture2D>(StringComparer.OrdinalIgnoreCase);
        int count = 0;
        foreach (var renderer in root.GetComponentsInChildren<SpriteRenderer>(true))
        {
            string spriteName = renderer.sprite != null ? renderer.sprite.name : "";
            string objectName = renderer.gameObject.name.Replace("(Clone)", "").Trim();
            string key = "";
            if (!string.IsNullOrEmpty(spriteName) && index.ContainsKey(spriteName)) key = spriteName;
            else if (!string.IsNullOrEmpty(objectName) && index.ContainsKey(objectName)) key = objectName;
            else
            {
                key = ResolveBattlemapSpriteNameFromRendererName(objectName, index);
            }
            if (string.IsNullOrEmpty(key))
            {
                key = ResolveBattlemapSpriteNameFromRendererName(spriteName, index);
            }
            if (string.IsNullOrEmpty(key))
            {
                foreach (var pair in index)
                {
                    if (objectName.IndexOf(pair.Key, StringComparison.OrdinalIgnoreCase) >= 0)
                    {
                        key = pair.Key;
                        break;
                    }
                }
            }
            if (string.IsNullOrEmpty(key)) continue;
            string path = index[key];
            var texture = LoadTextureCached(path, textureCache);
            if (texture == null) continue;
            float ppu = renderer.sprite != null && renderer.sprite.pixelsPerUnit > 0.01f ? renderer.sprite.pixelsPerUnit : 100f;
            var sprite = Sprite.Create(texture, new Rect(0f, 0f, texture.width, texture.height), new Vector2(0.5f, 0.5f), ppu);
            sprite.name = key;
            renderer.sprite = sprite;
            count++;
        }
        return count;
    }

    private static string ResolveBattlemapSpriteNameFromRendererName(string rendererName, Dictionary<string, string> index)
    {
        if (string.IsNullOrEmpty(rendererName) || index == null || index.Count == 0) return "";
        var match = Regex.Match(rendererName, @"^bg(\d+)_(\d+)$", RegexOptions.IgnoreCase);
        if (!match.Success) return "";
        string group = match.Groups[1].Value;
        string sub = match.Groups[2].Value;
        string withSub = "Map_11003_" + group + "_" + sub;
        if (index.ContainsKey(withSub)) return withSub;
        if (sub == "1")
        {
            string withoutSub = "Map_11003_" + group;
            if (index.ContainsKey(withoutSub)) return withoutSub;
        }
        return "";
    }

    private static Dictionary<string, string> LoadMapSpriteIndex()
    {
        var index = new Dictionary<string, string>(StringComparer.Ordinal);
        if (!File.Exists(SpriteIndexPath)) return index;
        var lines = File.ReadAllLines(SpriteIndexPath, Encoding.UTF8);
        for (int i = 1; i < lines.Length; i++)
        {
            var parts = lines[i].Split(',');
            if (parts.Length < 7) continue;
            string bundle = parts[0];
            string assetType = parts[2];
            string name = parts[3];
            string output = parts[6];
            if (assetType != "Sprite") continue;
            if (!name.StartsWith("Map_11003", StringComparison.Ordinal)) continue;
            if (bundle.IndexOf("/battlemap/map_11003/", StringComparison.OrdinalIgnoreCase) < 0) continue;
            string path = Path.Combine(MergedExtractedRoot, output.Replace('/', Path.DirectorySeparatorChar));
            if (!File.Exists(path)) continue;
            if (!index.ContainsKey(name)) index[name] = path;
        }
        return index;
    }

    private static Texture2D LoadTextureCached(string path, Dictionary<string, Texture2D> cache)
    {
        if (cache.ContainsKey(path)) return cache[path];
        try
        {
            var texture = new Texture2D(2, 2, TextureFormat.RGBA32, false);
            texture.name = Path.GetFileNameWithoutExtension(path) + "_battle27_map_png";
            if (!texture.LoadImage(File.ReadAllBytes(path), false))
            {
                UnityEngine.Object.DestroyImmediate(texture);
                return null;
            }
            texture.wrapMode = TextureWrapMode.Clamp;
            texture.filterMode = FilterMode.Bilinear;
            cache[path] = texture;
            return texture;
        }
        catch
        {
            return null;
        }
    }

    private static string CollectSpriteRendererNameSample(GameObject root, bool spriteNames)
    {
        var values = new List<string>();
        foreach (var renderer in root.GetComponentsInChildren<SpriteRenderer>(true))
        {
            string value = spriteNames ? (renderer.sprite != null ? renderer.sprite.name : "null_sprite") : renderer.gameObject.name;
            if (string.IsNullOrEmpty(value)) value = "(empty)";
            values.Add(value);
            if (values.Count >= 12) break;
        }
        return string.Join(";", values.ToArray());
    }

    private static int CountNullSpriteRenderers(GameObject root)
    {
        int count = 0;
        foreach (var renderer in root.GetComponentsInChildren<SpriteRenderer>(true))
        {
            if (renderer.sprite == null) count++;
        }
        return count;
    }

    private static int RepairMapMaterials(GameObject root)
    {
        int count = 0;
        foreach (var renderer in root.GetComponentsInChildren<Renderer>(true))
        {
            var materials = renderer.sharedMaterials;
            bool changed = false;
            for (int i = 0; i < materials.Length; i++)
            {
                if (!NeedsMaterialFallback(materials[i])) continue;
                materials[i] = CreateFallbackMaterial(materials[i], false, null);
                changed = true;
                count++;
            }
            if (changed) renderer.sharedMaterials = materials;
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
            sb.Append("    {\"spriteName\":\"" + Json(r.spriteName) + "\",\"role\":\"" + Json(r.role) + "\",\"exists\":" + Bool(r.exists) + ",\"created\":" + Bool(r.created) + ",\"pixelX\":" + Num(r.pixelX) + ",\"pixelY\":" + Num(r.pixelY) + ",\"pixelWidth\":" + r.pixelWidth + ",\"pixelHeight\":" + r.pixelHeight + ",\"worldX\":" + Num(r.worldX) + ",\"worldY\":" + Num(r.worldY) + ",\"worldWidth\":" + Num(r.worldWidth) + ",\"worldHeight\":" + Num(r.worldHeight) + ",\"sortingOrder\":" + r.sortingOrder + ",\"rendererCount\":" + r.rendererCount + ",\"particleSystemCount\":" + r.particleSystemCount + ",\"materialFallbackCount\":" + r.materialFallbackCount + ",\"renderOrderFixCount\":" + r.renderOrderFixCount + ",\"nullSpriteRendererCount\":" + r.nullSpriteRendererCount + ",\"mapSpriteTextureBindCount\":" + r.mapSpriteTextureBindCount + ",\"spriteRendererNameSample\":\"" + Json(r.spriteRendererNameSample) + "\",\"spriteRendererSpriteSample\":\"" + Json(r.spriteRendererSpriteSample) + "\",\"prefabAssetName\":\"" + Json(r.prefabAssetName) + "\",\"prefabInstanceName\":\"" + Json(r.prefabInstanceName) + "\",\"bundleAssetNameSample\":\"" + Json(r.bundleAssetNameSample) + "\",\"output\":\"" + Json(r.output) + "\",\"failReason\":\"" + Json(r.failReason) + "\"}");
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
    private static string[] Battlemap11003BundleCandidates()
    {
        return new[]
        {
            Battlemap11003CleanBundlePath,
            Battlemap11003MergedBundlePath,
            Battlemap11003OverlayBundlePath
        };
    }

    private static bool AnyExisting(string[] values)
    {
        if (values == null) return false;
        foreach (string value in values) if (!string.IsNullOrEmpty(value) && File.Exists(value)) return true;
        return false;
    }

    private static string FirstJoined(string[] values, int limit)
    {
        if (values == null || values.Length == 0) return "";
        var sample = new List<string>();
        for (int i = 0; i < values.Length && i < limit; i++) sample.Add(values[i]);
        return string.Join(";", sample.ToArray());
    }
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
    public float pixelX;
    public float pixelY;
    public int pixelWidth;
    public int pixelHeight;
    public float worldX;
    public float worldY;
    public float worldWidth;
    public float worldHeight;
    public int sortingOrder;
    public int rendererCount;
    public int particleSystemCount;
    public int materialFallbackCount;
    public int renderOrderFixCount;
    public int nullSpriteRendererCount;
    public int mapSpriteTextureBindCount;
    public string spriteRendererNameSample = "";
    public string spriteRendererSpriteSample = "";
    public string prefabAssetName = "";
    public string prefabInstanceName = "";
    public string bundleAssetNameSample = "";
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
