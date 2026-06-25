using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.UI;
using TMPro;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text;

public static class BattleHudExternalDependencyLoadClip05Editor
{
    private const string ManifestPath = "Assets/RestoreData/battle/BATTLE_HUD_EXTERNAL_DEPENDENCY_LOAD_MANIFEST.json";
    private const string BaseScenePath = "Assets/Scenes/BattleRuntimeFlowSkillEffectPlayableMarkers.unity";
    private const string LiveJsonPath = "Assets/RestoreData/battle/BATTLE_HUD_EXTERNAL_DEPENDENCY_LOAD_CLIP05_VISUAL.json";
    private const string LiveCsvPath = "Assets/RestoreData/battle/BATTLE_HUD_EXTERNAL_DEPENDENCY_LOAD_CLIP05_VISUAL_COMPONENTS.csv";
    private const string CapturePath = "Assets/RestoreCaptures/battle_hud/BattleHudExternalDependencyLoadClip05_1680x720.png";

    [MenuItem("GirlsWar/Battle/Battle HUD External Dependency Load Clip05 Visual")]
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
        var loadResults = new List<BattleHudExternalBundleLoadResult23>();
        foreach (var db in dependencyBundles) LoadBundleWithResult(db.bundle, db.absolutePath, loadedBundles, loadResults, "external_dependency");
        foreach (var sb in spriteBundles) LoadBundle(sb.absolutePath, loadedBundles);
        var hudRoot = InstantiateLiveHudRoots(attachments, loadedBundles);
        var camera = EnsureCaptureCamera();
        DisableNonHudTextComponents(hudRoot);
        var canvasFixCount = ApplyCaptureCanvasFix(hudRoot, camera);
        Canvas.ForceUpdateCanvases();

        var rows = new List<BattleHudExternalDependencyRow23>();
        TraceComponents(hudRoot, camera, rows);
        bool captureExists = Capture(camera);
        WriteCsv(ProjectPath(LiveCsvPath), rows);
        WriteJson(ProjectPath(LiveJsonPath), rows, loadResults, hudRoot != null, hudRoot != null ? hudRoot.transform.childCount : 0, canvasFixCount, captureExists);

        foreach (var pair in loadedBundles)
        {
            if (pair.Value != null) pair.Value.Unload(false);
        }
        AssetDatabase.Refresh();
        Debug.Log("BattleHudExternalDependencyLoadClip05 generated. rows=" + rows.Count + ", deps=" + loadResults.Count + ", visibleOriginal=" + Count(rows, r => r.visibleOriginalSpriteCandidate) + ", placeholders=" + Count(rows, r => r.visiblePlaceholderBlock));
    }

    private static GameObject InstantiateLiveHudRoots(List<BattleHudAttachment23> attachments, Dictionary<string, AssetBundle> bundles)
    {
        var root = new GameObject("BattleHudExternalDependencyLoadLiveHudRoot");
        root.transform.position = Vector3.zero;
        foreach (var attachment in attachments)
        {
            AssetBundle bundle = LoadBundle(attachment.absolutePath, bundles);
            if (bundle == null) continue;
            GameObject prefab = null;
            try { prefab = bundle.LoadAsset<GameObject>(attachment.prefabAsset); } catch { }
            if (prefab == null) continue;
            var instance = (GameObject)GameObject.Instantiate(prefab);
            instance.name = "ExternalDependencyHUD_" + attachment.order.ToString("00") + "_" + SafeName(Path.GetFileNameWithoutExtension(attachment.prefabAsset));
            instance.transform.SetParent(root.transform, false);
            var marker = instance.AddComponent<BattleHudExternalDependencySourceMarker23>();
            marker.role = attachment.role;
            marker.bundle = attachment.bundle;
            marker.prefabAsset = attachment.prefabAsset;
            if (attachment.attachMode == "entry_inactive" || attachment.attachMode == "template_inactive") instance.SetActive(false);
        }
        return root;
    }

    private static void TraceComponents(GameObject hudRoot, Camera camera, List<BattleHudExternalDependencyRow23> rows)
    {
        if (hudRoot == null) return;
        foreach (var component in hudRoot.GetComponentsInChildren<Component>(true))
        {
            if (component == null) continue;
            if (!(component is Image) && !(component is RawImage) && !(component is Text) && !(component is TextMeshProUGUI) && !(component is Button)) continue;
            var marker = component.GetComponentInParent<BattleHudExternalDependencySourceMarker23>(true);
            var row = new BattleHudExternalDependencyRow23();
            row.prefabRoot = marker != null ? marker.role : "";
            row.sourceBundle = marker != null ? marker.bundle : "";
            row.sourcePrefabPath = marker != null ? marker.prefabAsset : "";
            row.hierarchyPath = HierarchyPath(component.transform, hudRoot.transform);
            row.componentType = component.GetType().FullName;
            row.activeInHierarchy = component.gameObject.activeInHierarchy;
            row.enabled = IsEnabled(component);
            row.visibleOnCamera = Project(component.transform as RectTransform, camera, row);
            row.screenZone = Zone(row);

            if (component is Image image)
            {
                row.role = "Image";
                row.spriteName = image.sprite != null ? image.sprite.name : "";
                row.textureName = image.sprite != null && image.sprite.texture != null ? image.sprite.texture.name : "";
                row.textureSize = image.sprite != null && image.sprite.texture != null ? image.sprite.texture.width + "x" + image.sprite.texture.height : "";
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

    private static string Reason(BattleHudExternalDependencyRow23 row)
    {
        if (row.role == "Image" && !row.hasResolvedSprite) return "sprite_pptr_unresolved";
        if (row.role == "RawImage" && !row.hasResolvedSprite) return "material_pptr_unresolved";
        if ((row.role == "Text" || row.role == "TMP") && string.IsNullOrEmpty(row.fontName)) return "font_pptr_unresolved";
        if (row.visiblePlaceholderBlock) return "default_white_placeholder_block";
        if (!row.visibleOnCamera && row.activeInHierarchy) return "mask_or_canvas_false_positive";
        return "";
    }

    private static bool Project(RectTransform rect, Camera camera, BattleHudExternalDependencyRow23 row)
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

    private static string Zone(BattleHudExternalDependencyRow23 row)
    {
        if (!row.visibleOnCamera) return "offscreen";
        var zones = new List<string>();
        if (row.screenMaxY >= 0.82f) zones.Add("top");
        if (row.screenMinY <= 0.28f) zones.Add("bottom");
        if (row.screenMaxX >= 0.82f) zones.Add("right");
        if (zones.Count == 0) zones.Add("middle");
        return string.Join("+", zones.ToArray());
    }

    private static int ApplyCaptureCanvasFix(GameObject hudRoot, Camera camera)
    {
        int count = 0;
        if (hudRoot == null) return count;
        foreach (var canvas in hudRoot.GetComponentsInChildren<Canvas>(true))
        {
            if (canvas.renderMode == RenderMode.ScreenSpaceOverlay || canvas.renderMode == RenderMode.WorldSpace || canvas.worldCamera == null)
            {
                canvas.renderMode = RenderMode.ScreenSpaceCamera;
                canvas.worldCamera = camera;
                canvas.planeDistance = 4f;
                canvas.sortingOrder = Math.Max(canvas.sortingOrder, 100);
                count++;
            }
        }
        return count;
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
        var go = new GameObject("BattleHudExternalDependencyLoadCamera");
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

    private static void WriteCsv(string path, List<BattleHudExternalDependencyRow23> rows)
    {
        Directory.CreateDirectory(Path.GetDirectoryName(path));
        var lines = new List<string>();
        lines.Add("prefabRoot,sourceBundle,sourcePrefabPath,hierarchyPath,componentType,role,activeInHierarchy,enabled,visibleOnCamera,screenZone,areaRatio,spriteName,textureName,textureSize,materialName,fontName,color,alpha,imageType,preserveAspect,raycastTarget,buttonInteractable,buttonPersistentHandlerCount,targetGraphicPath,visibleOriginalSpriteCandidate,visiblePlaceholderBlock,unresolvedReason");
        foreach (var r in rows)
        {
            lines.Add(string.Join(",", new string[] {
                Csv(r.prefabRoot), Csv(r.sourceBundle), Csv(r.sourcePrefabPath), Csv(r.hierarchyPath), Csv(r.componentType), Csv(r.role), Bool(r.activeInHierarchy), Bool(r.enabled), Bool(r.visibleOnCamera), Csv(r.screenZone), Num(r.areaRatio), Csv(r.spriteName), Csv(r.textureName), Csv(r.textureSize), Csv(r.materialName), Csv(r.fontName), Csv(r.color), Num(r.alpha), Csv(r.imageType), Bool(r.preserveAspect), Bool(r.raycastTarget), Bool(r.buttonInteractable), r.buttonPersistentHandlerCount.ToString(), Csv(r.targetGraphicPath), Bool(r.visibleOriginalSpriteCandidate), Bool(r.visiblePlaceholderBlock), Csv(r.unresolvedReason)
            }));
        }
        File.WriteAllLines(path, lines, Encoding.UTF8);
    }

    private static void WriteJson(string path, List<BattleHudExternalDependencyRow23> rows, List<BattleHudExternalBundleLoadResult23> loadResults, bool hudRootFound, int liveHudInstantiateCount, int canvasFixCount, bool captureExists)
    {
        Directory.CreateDirectory(Path.GetDirectoryName(path));
        int visibleOriginal = Count(rows, r => r.visibleOriginalSpriteCandidate);
        int placeholders = Count(rows, r => r.visiblePlaceholderBlock);
        int visible = Count(rows, r => r.visibleOnCamera && r.activeInHierarchy && r.enabled);
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
        sb.AppendLine("  \"placeholderBlockVisible\": " + Bool(placeholders > 0) + ",");
        sb.AppendLine("  \"cameraVisibleOriginalHud\": " + Bool(placeholders == 0 && visibleOriginal > 0) + ",");
        sb.AppendLine("  \"captureVisualizationFixApplied\": " + Bool(canvasFixCount > 0) + ",");
        sb.AppendLine("  \"canvasFixCount\": " + canvasFixCount + ",");
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
        sb.AppendLine("  \"liveCsv\": \"" + Json(ProjectPath(LiveCsvPath)) + "\"");
        sb.AppendLine("}");
        File.WriteAllText(path, sb.ToString(), Encoding.UTF8);
    }

    private static AssetBundle LoadBundleWithResult(string bundleName, string path, Dictionary<string, AssetBundle> bundles, List<BattleHudExternalBundleLoadResult23> results, string role)
    {
        var result = new BattleHudExternalBundleLoadResult23();
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

    private static List<BattleHudAttachment23> ReadAttachments(string json)
    {
        var list = new List<BattleHudAttachment23>();
        foreach (string item in ExtractObjectBlocks(ExtractArrayBlock(json, "\"attachments\"")))
        {
            list.Add(new BattleHudAttachment23
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

    private static List<BattleHudSpriteBundle23> ReadSpriteBundles(string json)
    {
        var list = new List<BattleHudSpriteBundle23>();
        foreach (string item in ExtractObjectBlocks(ExtractArrayBlock(json, "\"spriteBundles\"")))
        {
            list.Add(new BattleHudSpriteBundle23 { bundle = ReadValue(item, "bundle"), absolutePath = ReadValue(item, "absolutePath") });
        }
        return list;
    }

    private static List<BattleHudSpriteBundle23> ReadDependencyBundles(string json)
    {
        var list = new List<BattleHudSpriteBundle23>();
        foreach (string item in ExtractObjectBlocks(ExtractArrayBlock(json, "\"dependencyBundles\"")))
        {
            list.Add(new BattleHudSpriteBundle23 { bundle = ReadValue(item, "bundle"), absolutePath = ReadValue(item, "absolutePath") });
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

    private static int Count(List<BattleHudExternalDependencyRow23> rows, Func<BattleHudExternalDependencyRow23, bool> predicate) { int c = 0; foreach (var r in rows) if (predicate(r)) c++; return c; }
    private static int CountBundle(List<BattleHudExternalBundleLoadResult23> rows, Func<BattleHudExternalBundleLoadResult23, bool> predicate) { int c = 0; foreach (var r in rows) if (predicate(r)) c++; return c; }
    private static string ProjectPath(string assetPath) { return Path.Combine(Application.dataPath, "..", assetPath); }
    private static string SafeMaterialName(Material material) { try { return material != null ? material.name : ""; } catch { return ""; } }
    private static string SafeName(string value) { return string.IsNullOrEmpty(value) ? "unknown" : value.Replace(" ", "_").Replace(".", "_").Replace("/", "_").Replace("\\", "_"); }
    private static string Short(string value, int max) { if (string.IsNullOrEmpty(value)) return ""; value = value.Replace("\r", " ").Replace("\n", " "); return value.Length > max ? value.Substring(0, max) : value; }
    private static string[] First(string[] values, int count) { if (values == null) return new string[0]; int n = Math.Min(values.Length, count); var result = new string[n]; Array.Copy(values, result, n); return result; }
    private static string ColorString(Color color) { return color.r.ToString("0.###") + "/" + color.g.ToString("0.###") + "/" + color.b.ToString("0.###") + "/" + color.a.ToString("0.###"); }
    private static string Csv(string value) { value = value ?? ""; return "\"" + value.Replace("\"", "\"\"") + "\""; }
    private static string Json(string value) { return (value ?? "").Replace("\\", "\\\\").Replace("\"", "\\\"").Replace("\r", " ").Replace("\n", " "); }
    private static string Bool(bool value) { return value ? "true" : "false"; }
    private static string Num(float value) { return value.ToString("0.######", System.Globalization.CultureInfo.InvariantCulture); }
}

public sealed class BattleHudExternalDependencySourceMarker23 : MonoBehaviour
{
    public string role;
    public string bundle;
    public string prefabAsset;
}

public sealed class BattleHudAttachment23
{
    public string id;
    public int order;
    public string role;
    public string attachMode;
    public string bundle;
    public string absolutePath;
    public string prefabAsset;
}

public sealed class BattleHudSpriteBundle23
{
    public string bundle;
    public string absolutePath;
}

public sealed class BattleHudExternalBundleLoadResult23
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

public sealed class BattleHudExternalDependencyRow23
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
    public string spriteName = "";
    public string textureName = "";
    public string textureSize = "";
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

