using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.UI;
using TMPro;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text;

public static class BattleHudSpriteAtlasTextureRuntimeBindingClip05Editor
{
    private const string ManifestPath = "Assets/RestoreData/battle/BATTLE_HUD_EXTERNAL_DEPENDENCY_LOAD_MANIFEST.json";
    private const string BaseScenePath = "Assets/Scenes/BattleRuntimeFlowSkillEffectPlayableMarkers.unity";
    private const string LiveJsonPath = "Assets/RestoreData/battle/BATTLE_HUD_SPRITE_ATLAS_TEXTURE_RUNTIME_BINDING_CLIP05.json";
    private const string LiveCsvPath = "Assets/RestoreData/battle/BATTLE_HUD_SPRITE_ATLAS_TEXTURE_RUNTIME_BINDING_CLIP05_COMPONENTS.csv";
    private const string CapturePath = "Assets/RestoreCaptures/battle_hud/BattleHudSpriteAtlasTextureRuntimeBindingClip05_1680x720.png";
    private const string SpriteIndexPath = @"C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\indexes\unity_images.csv";

    [MenuItem("GirlsWar/Battle/Battle HUD Sprite Atlas Texture Runtime Binding Clip05")]
    public static void Build()
    {
        string manifestJson = File.Exists(ProjectPath(ManifestPath)) ? File.ReadAllText(ProjectPath(ManifestPath), Encoding.UTF8) : "{}";
        var attachments = ReadAttachments(manifestJson);
        var dependencyBundles = ReadDependencyBundles(manifestJson);
        var spriteBundles = ReadSpriteBundles(manifestJson);

        if (File.Exists(ProjectPath(BaseScenePath)))
        {
            EditorSceneManager.OpenScene(BaseScenePath, OpenSceneMode.Single);
        }
        else
        {
            EditorSceneManager.NewScene(NewSceneSetup.EmptyScene, NewSceneMode.Single);
        }

        var loadedBundles = new Dictionary<string, AssetBundle>();
        var loadResults = new List<BattleHudBundleLoadResult25>();
        foreach (var db in dependencyBundles) LoadBundleWithResult(db.bundle, db.absolutePath, loadedBundles, loadResults, "external_dependency");
        foreach (var sb in spriteBundles) LoadBundle(sb.absolutePath, loadedBundles);
        var hudRoot = InstantiateLiveHudRoots(attachments, loadedBundles);
        var camera = EnsureCaptureCamera();
        DisableNonHudTextComponents(hudRoot);
        var canvasFixes = ApplyCaptureCanvasFix(hudRoot, camera);
        var activeStateFixCount = ApplyClip05LuaActiveStateFix(hudRoot);
        var spritePngIndex = LoadSpritePngIndex();
        int extractedSpriteTextureBindCount = ApplyExtractedSpriteTextureBindings(hudRoot, spritePngIndex);
        Canvas.ForceUpdateCanvases();

        var rows = new List<BattleHudSpriteAtlasRow25>();
        TraceComponents(hudRoot, camera, rows);
        bool captureExists = Capture(camera);
        WriteCsv(ProjectPath(LiveCsvPath), rows);
        WriteJson(ProjectPath(LiveJsonPath), rows, loadResults, canvasFixes, hudRoot != null, hudRoot != null ? hudRoot.transform.childCount : 0, activeStateFixCount, extractedSpriteTextureBindCount, captureExists);

        foreach (var pair in loadedBundles)
        {
            if (pair.Value != null) pair.Value.Unload(false);
        }
        AssetDatabase.Refresh();
        Debug.Log("BattleHudSpriteAtlasTextureRuntimeBindingClip05 generated. rows=" + rows.Count + ", deps=" + loadResults.Count + ", extractedSpriteTextureBinds=" + extractedSpriteTextureBindCount + ", visibleOriginal=" + Count(rows, r => r.visibleOriginalSpriteCandidate) + ", placeholders=" + Count(rows, r => r.visiblePlaceholderBlock));
    }

    private static GameObject InstantiateLiveHudRoots(List<BattleHudAttachment25> attachments, Dictionary<string, AssetBundle> bundles)
    {
        var root = new GameObject("BattleHudSpriteAtlasTextureRuntimeBindingClip05Root");
        root.transform.position = Vector3.zero;
        foreach (var attachment in attachments)
        {
            AssetBundle bundle = LoadBundle(attachment.absolutePath, bundles);
            if (bundle == null) continue;
            GameObject prefab = null;
            try { prefab = bundle.LoadAsset<GameObject>(attachment.prefabAsset); } catch { }
            if (prefab == null) continue;
            var instance = (GameObject)GameObject.Instantiate(prefab);
            instance.name = "CanvasLuaStateHUD_" + attachment.order.ToString("00") + "_" + SafeName(Path.GetFileNameWithoutExtension(attachment.prefabAsset));
            instance.transform.SetParent(root.transform, false);
            var marker = instance.AddComponent<BattleHudSpriteAtlasSourceMarker25>();
            marker.role = attachment.role;
            marker.bundle = attachment.bundle;
            marker.prefabAsset = attachment.prefabAsset;
            if (attachment.attachMode == "entry_inactive" || attachment.attachMode == "template_inactive") instance.SetActive(false);
        }
        return root;
    }

    private static Dictionary<string, List<BattleHudSpritePngEntry25>> LoadSpritePngIndex()
    {
        var index = new Dictionary<string, List<BattleHudSpritePngEntry25>>(StringComparer.Ordinal);
        if (!File.Exists(SpriteIndexPath)) return index;
        var lines = File.ReadAllLines(SpriteIndexPath, Encoding.UTF8);
        for (int i = 1; i < lines.Length; i++)
        {
            var parts = lines[i].Split(',');
            if (parts.Length < 7) continue;
            if (parts[2] != "Sprite") continue;
            var entry = new BattleHudSpritePngEntry25();
            entry.bundle = parts[0];
            entry.pathId = parts[1];
            entry.name = parts[3];
            int.TryParse(parts[4], out entry.width);
            int.TryParse(parts[5], out entry.height);
            entry.output = parts[6];
            entry.absolutePath = Path.Combine(@"C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted", entry.output.Replace('/', Path.DirectorySeparatorChar));
            if (string.IsNullOrEmpty(entry.name) || !File.Exists(entry.absolutePath)) continue;
            if (!index.ContainsKey(entry.name)) index[entry.name] = new List<BattleHudSpritePngEntry25>();
            index[entry.name].Add(entry);
        }
        return index;
    }

    private static int ApplyExtractedSpriteTextureBindings(GameObject hudRoot, Dictionary<string, List<BattleHudSpritePngEntry25>> index)
    {
        if (hudRoot == null || index == null || index.Count == 0) return 0;
        int count = 0;
        var textureCache = new Dictionary<string, Texture2D>(StringComparer.OrdinalIgnoreCase);
        foreach (var image in hudRoot.GetComponentsInChildren<Image>(true))
        {
            string spriteName = image.sprite != null ? image.sprite.name : "";
            if (string.IsNullOrEmpty(spriteName)) continue;
            bool needsTexture = true;
            try
            {
                var current = image.sprite.texture;
                needsTexture = current == null || current.width <= 2 || current.height <= 2;
            }
            catch
            {
                needsTexture = true;
            }
            if (!needsTexture) continue;
            var entry = ChooseSpritePngEntry(spriteName, image, index);
            if (entry == null) continue;
            Texture2D texture = LoadPngTexture(entry, textureCache);
            if (texture == null) continue;
            var oldSprite = image.sprite;
            float ppu = oldSprite != null && oldSprite.pixelsPerUnit > 0.01f ? oldSprite.pixelsPerUnit : 100f;
            Vector4 border = oldSprite != null ? oldSprite.border : Vector4.zero;
            var sprite = Sprite.Create(texture, new Rect(0f, 0f, texture.width, texture.height), new Vector2(0.5f, 0.5f), ppu, 0, SpriteMeshType.FullRect, border);
            sprite.name = spriteName;
            image.sprite = sprite;
            var marker = image.gameObject.GetComponent<BattleHudExtractedSpriteBindingMarker25>();
            if (marker == null) marker = image.gameObject.AddComponent<BattleHudExtractedSpriteBindingMarker25>();
            marker.spriteName = spriteName;
            marker.bundle = entry.bundle;
            marker.pathId = entry.pathId;
            marker.absolutePath = entry.absolutePath;
            marker.width = entry.width;
            marker.height = entry.height;
            count++;
        }
        return count;
    }

    private static BattleHudSpritePngEntry25 ChooseSpritePngEntry(string spriteName, Image image, Dictionary<string, List<BattleHudSpritePngEntry25>> index)
    {
        if (!index.ContainsKey(spriteName)) return null;
        BattleHudSpritePngEntry25 best = null;
        int bestScore = int.MinValue;
        foreach (var entry in index[spriteName])
        {
            int score = entry.width * entry.height;
            string bundle = (entry.bundle ?? "").ToLowerInvariant();
            if (bundle.Contains("/uibattle.assetbundle")) score += 100000000;
            if (spriteName.StartsWith("battlehead", StringComparison.Ordinal) && bundle.Contains("/uiheroheadbattle.assetbundle")) score += 200000000;
            if (spriteName.StartsWith("head", StringComparison.Ordinal) && bundle.Contains("/uiherohead/")) score += 200000000;
            if (spriteName.StartsWith("UI_buzhen", StringComparison.Ordinal) && bundle.Contains("/uicommonother.assetbundle")) score += 200000000;
            if (spriteName.IndexOf("buff", StringComparison.OrdinalIgnoreCase) >= 0 && bundle.Contains("/uibufficon.assetbundle")) score += 50000000;
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

    private static Texture2D LoadPngTexture(BattleHudSpritePngEntry25 entry, Dictionary<string, Texture2D> cache)
    {
        if (cache.ContainsKey(entry.absolutePath)) return cache[entry.absolutePath];
        try
        {
            byte[] bytes = File.ReadAllBytes(entry.absolutePath);
            var texture = new Texture2D(2, 2, TextureFormat.RGBA32, false);
            texture.name = entry.name + "_extracted_png";
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

    private static void TraceComponents(GameObject hudRoot, Camera camera, List<BattleHudSpriteAtlasRow25> rows)
    {
        if (hudRoot == null) return;
        foreach (var component in hudRoot.GetComponentsInChildren<Component>(true))
        {
            if (component == null) continue;
            if (!(component is Image) && !(component is RawImage) && !(component is Text) && !(component is TextMeshProUGUI) && !(component is Button)) continue;
            var marker = component.GetComponentInParent<BattleHudSpriteAtlasSourceMarker25>(true);
            var row = new BattleHudSpriteAtlasRow25();
            row.prefabRoot = marker != null ? marker.role : "";
            row.sourceBundle = marker != null ? marker.bundle : "";
            row.sourcePrefabPath = marker != null ? marker.prefabAsset : "";
            row.hierarchyPath = HierarchyPath(component.transform, hudRoot.transform);
            row.componentType = component.GetType().FullName;
            row.activeInHierarchy = component.gameObject.activeInHierarchy;
            row.enabled = IsEnabled(component);
            row.visibleOnCamera = Project(component.transform as RectTransform, camera, row);
            row.screenZone = Zone(row);
            CaptureRectAndCanvas(component.transform as RectTransform, row);

            if (component is Image image)
            {
                row.role = "Image";
                FillSpriteInfo(image.sprite, row);
                FillExtractedSpriteBindingInfo(image, row);
                row.materialName = SafeMaterialName(image.material);
                row.color = ColorString(image.color);
                row.alpha = image.color.a;
                row.imageType = image.type.ToString();
                row.preserveAspect = image.preserveAspect;
                row.raycastTarget = image.raycastTarget;
                row.hasResolvedSprite = image.sprite != null;
                row.isDefaultWhiteLike = image.sprite == null && image.color.a > 0.01f && image.color.r > 0.85f && image.color.g > 0.85f && image.color.b > 0.85f;
            }
            else if (component is RawImage raw)
            {
                row.role = "RawImage";
                row.textureName = raw.texture != null ? raw.texture.name : "";
                row.textureSize = raw.texture != null ? raw.texture.width + "x" + raw.texture.height : "";
                row.materialName = SafeMaterialName(raw.material);
                row.color = ColorString(raw.color);
                row.alpha = raw.color.a;
                row.raycastTarget = raw.raycastTarget;
                row.hasResolvedSprite = raw.texture != null;
                row.isDefaultWhiteLike = raw.texture == null && raw.color.a > 0.01f && raw.color.r > 0.85f && raw.color.g > 0.85f && raw.color.b > 0.85f;
                row.textureIsNull = raw.texture == null;
            }
            else if (component is Text text)
            {
                row.role = "Text";
                row.materialName = SafeMaterialName(text.material);
                row.fontName = text.font != null ? text.font.name : "";
                row.color = ColorString(text.color);
                row.alpha = text.color.a;
                row.textSample = Short(text.text, 80);
            }
            else if (component is TextMeshProUGUI tmp)
            {
                row.role = "TMP";
                TMP_FontAsset font = null;
                try { font = tmp.font; } catch { }
                row.materialName = SafeMaterialName(tmp.material);
                row.fontName = font != null ? font.name : "";
                row.color = ColorString(tmp.color);
                row.alpha = tmp.color.a;
                row.textSample = Short(tmp.text, 80);
            }
            else if (component is Button button)
            {
                row.role = "Button";
                row.raycastTarget = button.targetGraphic != null && button.targetGraphic.raycastTarget;
                row.buttonInteractable = button.interactable;
                row.buttonPersistentHandlerCount = button.onClick != null ? button.onClick.GetPersistentEventCount() : 0;
                row.targetGraphicPath = button.targetGraphic != null ? HierarchyPath(button.targetGraphic.transform, hudRoot.transform) : "";
            }

            row.visiblePlaceholderBlock = row.visibleOnCamera && row.activeInHierarchy && row.enabled && row.alpha > 0.01f && row.role != "Button" && row.areaRatio >= 0.01f && (row.isDefaultWhiteLike || (!row.hasResolvedSprite && (row.role == "Image" || row.role == "RawImage")));
            row.visibleOriginalSpriteCandidate = row.visibleOnCamera && row.activeInHierarchy && row.enabled && row.hasResolvedSprite && (row.role == "Image" || row.role == "RawImage") && !row.visiblePlaceholderBlock;
            row.unresolvedReason = Reason(row);
            rows.Add(row);
        }
    }

    private static string Reason(BattleHudSpriteAtlasRow25 row)
    {
        if (row.role == "Image" && !row.hasResolvedSprite) return "sprite_pptr_unresolved";
        if (row.role == "RawImage" && !row.hasResolvedSprite) return "material_pptr_unresolved";
        if ((row.role == "Text" || row.role == "TMP") && string.IsNullOrEmpty(row.fontName)) return "font_pptr_unresolved";
        if (row.visiblePlaceholderBlock) return "default_white_placeholder_block";
        if (!row.visibleOnCamera && row.activeInHierarchy) return "mask_or_canvas_false_positive";
        return "";
    }

    private static bool Project(RectTransform rect, Camera camera, BattleHudSpriteAtlasRow25 row)
    {
        if (rect == null) return false;
        Vector3[] corners = new Vector3[4];
        rect.GetWorldCorners(corners);
        float minX = 1f, maxX = 0f, minY = 1f, maxY = 0f;
        bool any = false;
        for (int i = 0; i < 4; i++)
        {
            Vector3 v = camera.WorldToViewportPoint(corners[i]);
            if (v.z < 0f) continue;
            minX = Mathf.Min(minX, v.x);
            maxX = Mathf.Max(maxX, v.x);
            minY = Mathf.Min(minY, v.y);
            maxY = Mathf.Max(maxY, v.y);
            any = true;
        }
        row.screenMinX = minX; row.screenMaxX = maxX; row.screenMinY = minY; row.screenMaxY = maxY;
        row.areaRatio = Mathf.Max(0f, Mathf.Min(1f, maxX) - Mathf.Max(0f, minX)) * Mathf.Max(0f, Mathf.Min(1f, maxY) - Mathf.Max(0f, minY));
        return any && maxX >= 0f && minX <= 1f && maxY >= 0f && minY <= 1f;
    }

    private static string Zone(BattleHudSpriteAtlasRow25 row)
    {
        if (!row.visibleOnCamera) return "offscreen";
        var zones = new List<string>();
        if (row.screenMaxY >= 0.82f) zones.Add("top");
        if (row.screenMinY <= 0.28f) zones.Add("bottom");
        if (row.screenMaxX >= 0.82f) zones.Add("right");
        if (zones.Count == 0) zones.Add("middle");
        return string.Join("+", zones.ToArray());
    }

    private static List<BattleHudCanvasFix25> ApplyCaptureCanvasFix(GameObject hudRoot, Camera camera)
    {
        var fixes = new List<BattleHudCanvasFix25>();
        if (hudRoot == null) return fixes;
        foreach (var canvas in hudRoot.GetComponentsInChildren<Canvas>(true))
        {
            var fix = new BattleHudCanvasFix25();
            fix.canvasPath = HierarchyPath(canvas.transform, hudRoot.transform);
            fix.beforeRenderMode = canvas.renderMode.ToString();
            fix.beforeWorldCameraName = canvas.worldCamera != null ? canvas.worldCamera.name : "";
            fix.beforePlaneDistance = canvas.planeDistance;
            fix.beforeSortingOrder = canvas.sortingOrder;
            if (canvas.renderMode == RenderMode.ScreenSpaceOverlay || canvas.renderMode == RenderMode.WorldSpace || canvas.worldCamera == null)
            {
                canvas.renderMode = RenderMode.ScreenSpaceCamera;
                canvas.worldCamera = camera;
                canvas.planeDistance = 4f;
                canvas.sortingOrder = Math.Max(canvas.sortingOrder, 100);
                fix.changed = true;
            }
            fix.afterRenderMode = canvas.renderMode.ToString();
            fix.afterWorldCameraName = canvas.worldCamera != null ? canvas.worldCamera.name : "";
            fix.afterPlaneDistance = canvas.planeDistance;
            fix.afterSortingOrder = canvas.sortingOrder;
            if (fix.changed) fixes.Add(fix);
        }
        return fixes;
    }

    private static int ApplyClip05LuaActiveStateFix(GameObject hudRoot)
    {
        int count = 0;
        if (hudRoot == null) return count;
        foreach (var transform in hudRoot.GetComponentsInChildren<Transform>(true))
        {
            string path = HierarchyPath(transform, hudRoot.transform);
            if (path.Contains("/root_opra/root_buff") || path.EndsWith("/root_opra/root_buff"))
            {
                if (transform.gameObject.activeSelf)
                {
                    transform.gameObject.SetActive(false);
                    count++;
                }
            }
        }
        return count;
    }

    private static void CaptureRectAndCanvas(RectTransform rect, BattleHudSpriteAtlasRow25 row)
    {
        if (rect == null) return;
        row.anchorMin = Vec2(rect.anchorMin);
        row.anchorMax = Vec2(rect.anchorMax);
        row.pivot = Vec2(rect.pivot);
        row.sizeDelta = Vec2(rect.sizeDelta);
        row.anchoredPosition = Vec2(rect.anchoredPosition);
        row.localScale = Vec3(rect.localScale);
        row.lossyScale = Vec3(rect.lossyScale);
        var canvas = rect.GetComponentInParent<Canvas>(true);
        if (canvas != null)
        {
            row.canvasPath = HierarchyPath(canvas.transform, null);
            row.canvasRenderMode = canvas.renderMode.ToString();
            row.canvasWorldCameraName = canvas.worldCamera != null ? canvas.worldCamera.name : "";
            row.canvasPlaneDistance = canvas.planeDistance;
            row.canvasSortingLayer = canvas.sortingLayerName;
            row.canvasSortingOrder = canvas.sortingOrder;
            row.canvasScaleFactor = canvas.scaleFactor;
            row.canvasReferencePixelsPerUnit = canvas.referencePixelsPerUnit;
            row.canvasHasWorldCamera = canvas.worldCamera != null;
            var canvasRect = canvas.transform as RectTransform;
            if (canvasRect != null) row.canvasRootRectSize = Vec2(canvasRect.rect.size);
        }
        var scaler = rect.GetComponentInParent<CanvasScaler>(true);
        if (scaler != null)
        {
            row.scalerUiScaleMode = scaler.uiScaleMode.ToString();
            row.scalerReferenceResolution = Vec2(scaler.referenceResolution);
            row.scalerScreenMatchMode = scaler.screenMatchMode.ToString();
            row.scalerMatchWidthOrHeight = scaler.matchWidthOrHeight;
            row.canvasScalerUiScaleMode = row.scalerUiScaleMode;
            row.canvasScalerReferenceResolution = row.scalerReferenceResolution;
            row.canvasScalerScreenMatchMode = row.scalerScreenMatchMode;
            row.canvasScalerMatchWidthOrHeight = row.scalerMatchWidthOrHeight;
        }
    }

    private static void FillSpriteInfo(Sprite sprite, BattleHudSpriteAtlasRow25 row)
    {
        row.spriteName = sprite != null ? sprite.name : "";
        row.textureIsNull = true;
        if (sprite == null) return;
        row.spriteRect = RectString(sprite.rect);
        row.spriteBorder = Vec4(sprite.border);
        row.spritePixelsPerUnit = sprite.pixelsPerUnit;
        row.spritePacked = sprite.packed;
        row.spritePackingMode = sprite.packingMode.ToString();
        row.spritePackingRotation = sprite.packingRotation.ToString();
        try
        {
            Texture2D texture = sprite.texture;
            row.textureIsNull = texture == null;
            row.textureName = texture != null ? texture.name : "";
            row.textureSize = texture != null ? texture.width + "x" + texture.height : "";
            row.textureInstanceId = texture != null ? texture.GetInstanceID() : 0;
        }
        catch (Exception ex)
        {
            row.textureIsNull = true;
            row.textureAccessError = ex.GetType().Name;
        }
    }

    private static void FillExtractedSpriteBindingInfo(Image image, BattleHudSpriteAtlasRow25 row)
    {
        var marker = image != null ? image.GetComponent<BattleHudExtractedSpriteBindingMarker25>() : null;
        if (marker == null) return;
        row.extractedSpritePngPath = marker.absolutePath;
        row.extractedSpriteBundle = marker.bundle;
        row.extractedSpritePathId = marker.pathId;
        row.extractedSpritePngSize = marker.width + "x" + marker.height;
    }

    private static void DisableNonHudTextComponents(GameObject hudRoot)
    {
        foreach (var text in UnityEngine.Object.FindObjectsOfType<Text>(true)) if (!IsChildOf(text.transform, hudRoot)) text.enabled = false;
        foreach (var tmp in UnityEngine.Object.FindObjectsOfType<TMP_Text>(true)) if (!IsChildOf(tmp.transform, hudRoot)) tmp.enabled = false;
        foreach (var textMesh in UnityEngine.Object.FindObjectsOfType<TextMesh>(true)) if (!IsChildOf(textMesh.transform, hudRoot)) textMesh.gameObject.SetActive(false);
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
        catch { return false; }
    }

    private static Camera EnsureCaptureCamera()
    {
        var go = new GameObject("BattleHudSpriteAtlasTextureRuntimeBindingClip05Camera");
        var camera = go.AddComponent<Camera>();
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
        return camera;
    }

    private static void WriteCsv(string path, List<BattleHudSpriteAtlasRow25> rows)
    {
        Directory.CreateDirectory(Path.GetDirectoryName(path));
        var lines = new List<string>();
        lines.Add("prefabRoot,sourceBundle,sourcePrefabPath,hierarchyPath,componentType,role,activeInHierarchy,enabled,visibleOnCamera,screenZone,areaRatio,screenMinX,screenMaxX,screenMinY,screenMaxY,anchorMin,anchorMax,pivot,sizeDelta,anchoredPosition,localScale,lossyScale,canvasPath,canvasRenderMode,canvasWorldCameraName,canvasPlaneDistance,canvasSortingLayer,canvasSortingOrder,canvasScaleFactor,canvasReferencePixelsPerUnit,canvasHasWorldCamera,canvasScalerUiScaleMode,canvasScalerReferenceResolution,canvasScalerMatchWidthOrHeight,canvasScalerScreenMatchMode,canvasRootRectSize,scalerUiScaleMode,scalerReferenceResolution,scalerScreenMatchMode,scalerMatchWidthOrHeight,spriteName,textureName,textureSize,textureIsNull,textureInstanceId,textureAccessError,extractedSpriteBundle,extractedSpritePathId,extractedSpritePngSize,extractedSpritePngPath,spriteRect,spriteBorder,spritePixelsPerUnit,spritePacked,spritePackingMode,spritePackingRotation,materialName,fontName,color,alpha,imageType,preserveAspect,raycastTarget,buttonInteractable,buttonPersistentHandlerCount,targetGraphicPath,visibleOriginalSpriteCandidate,visiblePlaceholderBlock,unresolvedReason");
        foreach (var r in rows)
        {
            lines.Add(string.Join(",", new string[] {
                Csv(r.prefabRoot), Csv(r.sourceBundle), Csv(r.sourcePrefabPath), Csv(r.hierarchyPath), Csv(r.componentType), Csv(r.role), Bool(r.activeInHierarchy), Bool(r.enabled), Bool(r.visibleOnCamera), Csv(r.screenZone), Num(r.areaRatio), Num(r.screenMinX), Num(r.screenMaxX), Num(r.screenMinY), Num(r.screenMaxY), Csv(r.anchorMin), Csv(r.anchorMax), Csv(r.pivot), Csv(r.sizeDelta), Csv(r.anchoredPosition), Csv(r.localScale), Csv(r.lossyScale), Csv(r.canvasPath), Csv(r.canvasRenderMode), Csv(r.canvasWorldCameraName), Num(r.canvasPlaneDistance), Csv(r.canvasSortingLayer), r.canvasSortingOrder.ToString(), Num(r.canvasScaleFactor), Num(r.canvasReferencePixelsPerUnit), Bool(r.canvasHasWorldCamera), Csv(r.canvasScalerUiScaleMode), Csv(r.canvasScalerReferenceResolution), Num(r.canvasScalerMatchWidthOrHeight), Csv(r.canvasScalerScreenMatchMode), Csv(r.canvasRootRectSize), Csv(r.scalerUiScaleMode), Csv(r.scalerReferenceResolution), Csv(r.scalerScreenMatchMode), Num(r.scalerMatchWidthOrHeight), Csv(r.spriteName), Csv(r.textureName), Csv(r.textureSize), Bool(r.textureIsNull), r.textureInstanceId.ToString(), Csv(r.textureAccessError), Csv(r.extractedSpriteBundle), Csv(r.extractedSpritePathId), Csv(r.extractedSpritePngSize), Csv(r.extractedSpritePngPath), Csv(r.spriteRect), Csv(r.spriteBorder), Num(r.spritePixelsPerUnit), Bool(r.spritePacked), Csv(r.spritePackingMode), Csv(r.spritePackingRotation), Csv(r.materialName), Csv(r.fontName), Csv(r.color), Num(r.alpha), Csv(r.imageType), Bool(r.preserveAspect), Bool(r.raycastTarget), Bool(r.buttonInteractable), r.buttonPersistentHandlerCount.ToString(), Csv(r.targetGraphicPath), Bool(r.visibleOriginalSpriteCandidate), Bool(r.visiblePlaceholderBlock), Csv(r.unresolvedReason)
            }));
        }
        File.WriteAllLines(path, lines, Encoding.UTF8);
    }

    private static void WriteJson(string path, List<BattleHudSpriteAtlasRow25> rows, List<BattleHudBundleLoadResult25> loadResults, List<BattleHudCanvasFix25> canvasFixes, bool hudRootFound, int liveHudInstantiateCount, int activeStateFixCount, int extractedSpriteTextureBindCount, bool captureExists)
    {
        Directory.CreateDirectory(Path.GetDirectoryName(path));
        int visibleOriginal = Count(rows, r => r.visibleOriginalSpriteCandidate);
        int placeholders = Count(rows, r => r.visiblePlaceholderBlock);
        int visible = Count(rows, r => r.visibleOnCamera && r.activeInHierarchy && r.enabled);
        int textureBlank = Count(rows, r => r.visibleOriginalSpriteCandidate && (r.textureIsNull || string.IsNullOrEmpty(r.textureName)));
        int loadedDeps = CountBundle(loadResults, r => r.loadSuccess);
        var sb = new StringBuilder();
        sb.AppendLine("{");
        sb.AppendLine("  \"hudRootFound\": " + Bool(hudRootFound) + ",");
        sb.AppendLine("  \"externalDependencyBundleCount\": " + loadResults.Count + ",");
        sb.AppendLine("  \"externalDependencyLoadSuccessCount\": " + loadedDeps + ",");
        sb.AppendLine("  \"externalDependencyLoadFailCount\": " + (loadResults.Count - loadedDeps) + ",");
        sb.AppendLine("  \"liveHudInstantiateCount\": " + liveHudInstantiateCount + ",");
        sb.AppendLine("  \"componentRowCount\": " + rows.Count + ",");
        sb.AppendLine("  \"visibleComponentCount\": " + visible + ",");
        sb.AppendLine("  \"visibleOriginalSpriteCount\": " + visibleOriginal + ",");
        sb.AppendLine("  \"visiblePlaceholderBlockCount\": " + placeholders + ",");
        sb.AppendLine("  \"visibleSpriteTextureBlankCount\": " + textureBlank + ",");
        sb.AppendLine("  \"placeholderBlockVisible\": " + Bool(placeholders > 0) + ",");
        sb.AppendLine("  \"cameraVisibleOriginalHud\": " + Bool(placeholders == 0 && visibleOriginal > 0) + ",");
        sb.AppendLine("  \"captureVisualizationFixApplied\": " + Bool(canvasFixes.Count > 0) + ",");
        sb.AppendLine("  \"canvasFixCount\": " + canvasFixes.Count + ",");
        sb.AppendLine("  \"clip05LuaActiveStateFixApplied\": " + Bool(activeStateFixCount > 0) + ",");
        sb.AppendLine("  \"clip05LuaActiveStateFixCount\": " + activeStateFixCount + ",");
        sb.AppendLine("  \"extractedSpriteTextureBindCount\": " + extractedSpriteTextureBindCount + ",");
        sb.AppendLine("  \"extractedSpriteTextureBoundVisibleCount\": " + Count(rows, r => r.visibleOnCamera && r.activeInHierarchy && !string.IsNullOrEmpty(r.extractedSpritePngPath)) + ",");
        sb.AppendLine("  \"capture\": \"" + Json(Path.GetFullPath(ProjectPath(CapturePath))) + "\",");
        sb.AppendLine("  \"captureExists\": " + Bool(captureExists && File.Exists(ProjectPath(CapturePath))) + ",");
        sb.AppendLine("  \"externalDependencyBundles\": [");
        for (int i = 0; i < loadResults.Count; i++)
        {
            var r = loadResults[i];
            sb.Append("    {\"bundle\":\"" + Json(r.bundle) + "\",\"absolutePath\":\"" + Json(r.absolutePath) + "\",\"exists\":" + Bool(r.exists) + ",\"loadSuccess\":" + Bool(r.loadSuccess) + ",\"assetNameCount\":" + r.assetNameCount + ",\"sample\":\"" + Json(r.sample) + "\",\"failReason\":\"" + Json(r.failReason) + "\"}");
            sb.AppendLine(i + 1 == loadResults.Count ? "" : ",");
        }
        sb.AppendLine("  ],");
        sb.AppendLine("  \"canvasFixes\": [");
        for (int i = 0; i < canvasFixes.Count; i++)
        {
            var r = canvasFixes[i];
            sb.Append("    {\"canvasPath\":\"" + Json(r.canvasPath) + "\",\"beforeRenderMode\":\"" + Json(r.beforeRenderMode) + "\",\"beforeWorldCameraName\":\"" + Json(r.beforeWorldCameraName) + "\",\"beforePlaneDistance\":" + Num(r.beforePlaneDistance) + ",\"beforeSortingOrder\":" + r.beforeSortingOrder + ",\"afterRenderMode\":\"" + Json(r.afterRenderMode) + "\",\"afterWorldCameraName\":\"" + Json(r.afterWorldCameraName) + "\",\"afterPlaneDistance\":" + Num(r.afterPlaneDistance) + ",\"afterSortingOrder\":" + r.afterSortingOrder + "}");
            sb.AppendLine(i + 1 == canvasFixes.Count ? "" : ",");
        }
        sb.AppendLine("  ],");
        sb.AppendLine("  \"canvasScalerSummary\": [");
        WriteCanvasSummary(sb, rows);
        sb.AppendLine("  ],");
        sb.AppendLine("  \"liveCsv\": \"" + Json(ProjectPath(LiveCsvPath)) + "\"");
        sb.AppendLine("}");
        File.WriteAllText(path, sb.ToString(), Encoding.UTF8);
    }

    private static void WriteCanvasSummary(StringBuilder sb, List<BattleHudSpriteAtlasRow25> rows)
    {
        var seen = new HashSet<string>();
        int written = 0;
        foreach (var r in rows)
        {
            if (string.IsNullOrEmpty(r.canvasPath) || seen.Contains(r.canvasPath)) continue;
            seen.Add(r.canvasPath);
            if (written > 0) sb.AppendLine(",");
            sb.Append("    {\"canvasPath\":\"" + Json(r.canvasPath) + "\",\"canvasRenderMode\":\"" + Json(r.canvasRenderMode) + "\",\"canvasWorldCameraName\":\"" + Json(r.canvasWorldCameraName) + "\",\"canvasPlaneDistance\":" + Num(r.canvasPlaneDistance) + ",\"canvasSortingOrder\":" + r.canvasSortingOrder + ",\"canvasScalerUiScaleMode\":\"" + Json(r.canvasScalerUiScaleMode) + "\",\"canvasScalerReferenceResolution\":\"" + Json(r.canvasScalerReferenceResolution) + "\",\"canvasScalerMatchWidthOrHeight\":" + Num(r.canvasScalerMatchWidthOrHeight) + ",\"canvasScalerScreenMatchMode\":\"" + Json(r.canvasScalerScreenMatchMode) + "\",\"canvasRootRectSize\":\"" + Json(r.canvasRootRectSize) + "\"}");
            written++;
            if (written >= 20) break;
        }
        if (written > 0) sb.AppendLine();
    }

    private static AssetBundle LoadBundleWithResult(string bundleName, string path, Dictionary<string, AssetBundle> bundles, List<BattleHudBundleLoadResult25> results, string role)
    {
        var result = new BattleHudBundleLoadResult25();
        result.role = role;
        result.bundle = bundleName;
        result.absolutePath = path;
        result.exists = !string.IsNullOrEmpty(path) && File.Exists(path);
        if (!result.exists)
        {
            result.failReason = "file_not_found";
            results.Add(result);
            return null;
        }
        var bundle = LoadBundle(path, bundles);
        result.loadSuccess = bundle != null;
        result.failReason = bundle != null ? "" : "AssetBundle.LoadFromFile returned null";
        if (bundle != null)
        {
            try
            {
                var names = bundle.GetAllAssetNames();
                result.assetNameCount = names != null ? names.Length : 0;
                if (names != null && names.Length > 0) result.sample = Short(string.Join("|", First(names, 8)), 300);
            }
            catch (Exception ex) { result.failReason = "GetAllAssetNames failed: " + ex.GetType().Name; }
        }
        results.Add(result);
        return bundle;
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
        catch { return null; }
    }

    private static List<BattleHudAttachment25> ReadAttachments(string json)
    {
        var list = new List<BattleHudAttachment25>();
        foreach (string item in ExtractObjectBlocks(ExtractArrayBlock(json, "\"attachments\"")))
        {
            list.Add(new BattleHudAttachment25
            {
                id = ReadValue(item, "id"),
                order = ReadInt(item, "order"),
                role = ReadValue(item, "role"),
                attachMode = ReadValue(item, "attachMode"),
                bundle = ReadValue(item, "bundle"),
                absolutePath = ReadValue(item, "absolutePath"),
                prefabAsset = ReadValue(item, "prefabAsset")
            });
        }
        return list;
    }

    private static List<BattleHudSpriteBundle25> ReadSpriteBundles(string json)
    {
        var list = new List<BattleHudSpriteBundle25>();
        foreach (string item in ExtractObjectBlocks(ExtractArrayBlock(json, "\"spriteBundles\"")))
        {
            list.Add(new BattleHudSpriteBundle25 { bundle = ReadValue(item, "bundle"), absolutePath = ReadValue(item, "absolutePath") });
        }
        return list;
    }

    private static List<BattleHudSpriteBundle25> ReadDependencyBundles(string json)
    {
        var list = new List<BattleHudSpriteBundle25>();
        foreach (string item in ExtractObjectBlocks(ExtractArrayBlock(json, "\"dependencyBundles\"")))
        {
            list.Add(new BattleHudSpriteBundle25 { bundle = ReadValue(item, "bundle"), absolutePath = ReadValue(item, "absolutePath") });
        }
        return list;
    }

    private static string ExtractArrayBlock(string json, string key)
    {
        int keyIndex = json.IndexOf(key, StringComparison.Ordinal);
        if (keyIndex < 0) return "";
        int start = json.IndexOf('[', keyIndex);
        int depth = 0; bool inString = false; bool escape = false;
        for (int i = start; i < json.Length; i++)
        {
            char c = json[i];
            if (inString) { if (escape) escape = false; else if (c == '\\') escape = true; else if (c == '"') inString = false; continue; }
            if (c == '"') { inString = true; continue; }
            if (c == '[') depth++;
            if (c == ']') depth--;
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
            if (inString) { if (escape) escape = false; else if (c == '\\') escape = true; else if (c == '"') inString = false; continue; }
            if (c == '"') { inString = true; continue; }
            if (c == '{') { if (depth == 0) start = i; depth++; }
            else if (c == '}') { depth--; if (depth == 0 && start >= 0) objects.Add(arrayBlock.Substring(start, i - start + 1)); }
        }
        return objects;
    }

    private static string ReadValue(string block, string key)
    {
        string needle = "\"" + key + "\"";
        int keyIndex = block.IndexOf(needle, StringComparison.Ordinal);
        if (keyIndex < 0) return "";
        int colon = block.IndexOf(':', keyIndex);
        int quote = block.IndexOf('"', colon + 1);
        var sb = new StringBuilder(); bool escape = false;
        for (int i = quote + 1; i < block.Length; i++)
        {
            char c = block[i];
            if (escape) { sb.Append(c); escape = false; continue; }
            if (c == '\\') { escape = true; continue; }
            if (c == '"') return sb.ToString();
            sb.Append(c);
        }
        return "";
    }

    private static int ReadInt(string block, string key)
    {
        string needle = "\"" + key + "\"";
        int keyIndex = block.IndexOf(needle, StringComparison.Ordinal);
        if (keyIndex < 0) return 0;
        int colon = block.IndexOf(':', keyIndex);
        int start = colon + 1;
        while (start < block.Length && char.IsWhiteSpace(block[start])) start++;
        int end = start;
        while (end < block.Length && (char.IsDigit(block[end]) || block[end] == '-')) end++;
        int value; return int.TryParse(block.Substring(start, end - start), out value) ? value : 0;
    }

    private static bool IsChildOf(Transform transform, GameObject root)
    {
        if (root == null || transform == null) return false;
        var cursor = transform;
        while (cursor != null)
        {
            if (cursor == root.transform) return true;
            cursor = cursor.parent;
        }
        return false;
    }

    private static bool IsEnabled(Component component)
    {
        if (component is Behaviour b) return b.enabled;
        return true;
    }

    private static string HierarchyPath(Transform t, Transform stop)
    {
        var names = new List<string>();
        while (t != null)
        {
            names.Add(t.name);
            if (t == stop) break;
            t = t.parent;
        }
        names.Reverse();
        return string.Join("/", names.ToArray());
    }

    private static int Count(List<BattleHudSpriteAtlasRow25> rows, Func<BattleHudSpriteAtlasRow25, bool> predicate) { int c = 0; foreach (var r in rows) if (predicate(r)) c++; return c; }
    private static int CountBundle(List<BattleHudBundleLoadResult25> rows, Func<BattleHudBundleLoadResult25, bool> predicate) { int c = 0; foreach (var r in rows) if (predicate(r)) c++; return c; }
    private static string ProjectPath(string assetPath) { return Path.Combine(Application.dataPath, "..", assetPath); }
    private static string SafeMaterialName(Material material) { try { return material != null ? material.name : ""; } catch { return ""; } }
    private static string SafeName(string value) { return string.IsNullOrEmpty(value) ? "unknown" : value.Replace(" ", "_").Replace(".", "_").Replace("/", "_").Replace("\\", "_"); }
    private static string Short(string value, int max) { if (string.IsNullOrEmpty(value)) return ""; value = value.Replace("\r", " ").Replace("\n", " "); return value.Length > max ? value.Substring(0, max) : value; }
    private static string[] First(string[] values, int count) { if (values == null) return new string[0]; int n = Math.Min(values.Length, count); var result = new string[n]; Array.Copy(values, result, n); return result; }
    private static string ColorString(Color color) { return color.r.ToString("0.###") + "/" + color.g.ToString("0.###") + "/" + color.b.ToString("0.###") + "/" + color.a.ToString("0.###"); }
    private static string RectString(Rect rect) { return rect.x.ToString("0.###") + "/" + rect.y.ToString("0.###") + "/" + rect.width.ToString("0.###") + "/" + rect.height.ToString("0.###"); }
    private static string Vec2(Vector2 v) { return v.x.ToString("0.###") + "/" + v.y.ToString("0.###"); }
    private static string Vec3(Vector3 v) { return v.x.ToString("0.###") + "/" + v.y.ToString("0.###") + "/" + v.z.ToString("0.###"); }
    private static string Vec4(Vector4 v) { return v.x.ToString("0.###") + "/" + v.y.ToString("0.###") + "/" + v.z.ToString("0.###") + "/" + v.w.ToString("0.###"); }
    private static string Csv(string value) { value = value ?? ""; return "\"" + value.Replace("\"", "\"\"") + "\""; }
    private static string Json(string value) { return (value ?? "").Replace("\\", "\\\\").Replace("\"", "\\\"").Replace("\r", " ").Replace("\n", " "); }
    private static string Bool(bool value) { return value ? "true" : "false"; }
    private static string Num(float value) { return value.ToString("0.######", System.Globalization.CultureInfo.InvariantCulture); }
}

public sealed class BattleHudSpriteAtlasSourceMarker25 : MonoBehaviour
{
    public string role;
    public string bundle;
    public string prefabAsset;
}

public sealed class BattleHudExtractedSpriteBindingMarker25 : MonoBehaviour
{
    public string spriteName;
    public string bundle;
    public string pathId;
    public string absolutePath;
    public int width;
    public int height;
}

public sealed class BattleHudAttachment25
{
    public string id;
    public int order;
    public string role;
    public string attachMode;
    public string bundle;
    public string absolutePath;
    public string prefabAsset;
}

public sealed class BattleHudSpriteBundle25
{
    public string bundle;
    public string absolutePath;
}

public sealed class BattleHudBundleLoadResult25
{
    public string role = "";
    public string bundle = "";
    public string absolutePath = "";
    public bool exists;
    public bool loadSuccess;
    public int assetNameCount;
    public string sample = "";
    public string failReason = "";
}

public sealed class BattleHudCanvasFix25
{
    public string canvasPath = "";
    public bool changed;
    public string beforeRenderMode = "";
    public string beforeWorldCameraName = "";
    public float beforePlaneDistance;
    public int beforeSortingOrder;
    public string afterRenderMode = "";
    public string afterWorldCameraName = "";
    public float afterPlaneDistance;
    public int afterSortingOrder;
}

public sealed class BattleHudSpritePngEntry25
{
    public string bundle = "";
    public string pathId = "";
    public string name = "";
    public int width;
    public int height;
    public string output = "";
    public string absolutePath = "";
}

public sealed class BattleHudSpriteAtlasRow25
{
    public string prefabRoot = "";
    public string sourceBundle = "";
    public string sourcePrefabPath = "";
    public string hierarchyPath = "";
    public string componentType = "";
    public string role = "";
    public bool activeInHierarchy;
    public bool enabled;
    public bool visibleOnCamera;
    public string screenZone = "";
    public float screenMinX;
    public float screenMaxX;
    public float screenMinY;
    public float screenMaxY;
    public float areaRatio;
    public string anchorMin = "";
    public string anchorMax = "";
    public string pivot = "";
    public string sizeDelta = "";
    public string anchoredPosition = "";
    public string localScale = "";
    public string lossyScale = "";
    public string canvasPath = "";
    public string canvasRenderMode = "";
    public string canvasWorldCameraName = "";
    public float canvasPlaneDistance;
    public string canvasSortingLayer = "";
    public int canvasSortingOrder;
    public float canvasScaleFactor;
    public float canvasReferencePixelsPerUnit;
    public bool canvasHasWorldCamera;
    public string canvasScalerUiScaleMode = "";
    public string canvasScalerReferenceResolution = "";
    public float canvasScalerMatchWidthOrHeight;
    public string canvasScalerScreenMatchMode = "";
    public string canvasRootRectSize = "";
    public string scalerUiScaleMode = "";
    public string scalerReferenceResolution = "";
    public string scalerScreenMatchMode = "";
    public float scalerMatchWidthOrHeight;
    public string spriteName = "";
    public string textureName = "";
    public string textureSize = "";
    public bool textureIsNull;
    public int textureInstanceId;
    public string textureAccessError = "";
    public string extractedSpriteBundle = "";
    public string extractedSpritePathId = "";
    public string extractedSpritePngSize = "";
    public string extractedSpritePngPath = "";
    public string spriteRect = "";
    public string spriteBorder = "";
    public float spritePixelsPerUnit;
    public bool spritePacked;
    public string spritePackingMode = "";
    public string spritePackingRotation = "";
    public string materialName = "";
    public string fontName = "";
    public string textSample = "";
    public string color = "";
    public float alpha;
    public string imageType = "";
    public bool preserveAspect;
    public bool raycastTarget;
    public bool buttonInteractable;
    public int buttonPersistentHandlerCount;
    public string targetGraphicPath = "";
    public bool hasResolvedSprite;
    public bool isDefaultWhiteLike;
    public bool visibleOriginalSpriteCandidate;
    public bool visiblePlaceholderBlock;
    public string unresolvedReason = "";
}




