using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.UI;
using TMPro;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text;

public static class BattleHudSpriteFontJoinEditor
{
    private const string ManifestPath = "Assets/RestoreData/battle/BATTLE_HUD_SPRITE_REGION_FONT_JOIN_UNITY_MANIFEST.json";
    private const string ResultPath = "Assets/RestoreData/battle/BATTLE_HUD_SPRITE_REGION_FONT_JOIN_RESULT.json";
    private const string ComponentCsvPath = "Assets/RestoreData/battle/BATTLE_HUD_SPRITE_REGION_FONT_JOIN_COMPONENTS.csv";
    private const string BaseScenePath = "Assets/Scenes/BattleRuntimeFlowSkillEffectPlayableMarkers.unity";
    private const string ScenePath = "Assets/Scenes/BattleRuntimeFlowWithHudSpriteFontJoin.unity";
    private const string CapturePath = "Assets/RestoreCaptures/battle_hud/BattleRuntimeFlowWithHudSpriteFontJoin_1680x720.png";

    [MenuItem("GirlsWar/Battle/Join Battle HUD Sprites Fonts And Validate Video Motion")]
    public static void Build()
    {
        string manifestJson = File.ReadAllText(ProjectPath(ManifestPath), Encoding.UTF8);
        var attachments = ReadAttachments(manifestJson);
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
        var spriteToBundles = new Dictionary<string, string>();
        foreach (var sb in spriteBundles)
        {
            LoadBundle(sb.absolutePath, loadedBundles, null);
            AssetBundle bundle;
            if (loadedBundles.TryGetValue(sb.absolutePath, out bundle) && bundle != null)
            {
                foreach (string assetName in bundle.GetAllAssetNames())
                {
                    Sprite sprite = null;
                    try { sprite = bundle.LoadAsset<Sprite>(assetName); } catch { }
                    if (sprite != null && !spriteToBundles.ContainsKey(sprite.name))
                    {
                        spriteToBundles[sprite.name] = sb.bundle;
                    }
                }
            }
        }

        var root = new GameObject("BattleHudSpriteFontJoinRoot");
        root.transform.position = new Vector3(0f, 0f, -1.45f);
        var rootResults = new List<BattleHudSpriteFontRootResult>();
        var componentRows = new List<BattleHudSpriteFontComponentRow>();
        foreach (var attachment in attachments)
        {
            rootResults.Add(Attach(root.transform, attachment, loadedBundles, spriteToBundles, componentRows));
        }

        HideNonHudEvidenceText(root.transform);
        var camera = EnsureCaptureCamera();
        string capture = Capture(camera, root.transform);
        WriteResult(ProjectPath(ResultPath), ProjectPath(ComponentCsvPath), rootResults, componentRows, loadedBundles.Count, spriteToBundles.Count, capture);

        foreach (var pair in loadedBundles)
        {
            if (pair.Value != null) pair.Value.Unload(false);
        }
        EditorSceneManager.SaveScene(EditorSceneManager.GetActiveScene(), ScenePath);
        AssetDatabase.Refresh();
        Debug.Log("BattleHudSpriteFontJoin generated. roots=" + rootResults.Count + ", sprites=" + Sum(rootResults, r => r.resolvedSpriteCount) + ", textFonts=" + Sum(rootResults, r => r.resolvedTextFontCount) + ", tmpFonts=" + Sum(rootResults, r => r.resolvedTmpFontCount) + ", buttons=" + Sum(rootResults, r => r.buttonCount));
    }

    private static BattleHudSpriteFontRootResult Attach(Transform root, BattleHudAttachment19 attachment, Dictionary<string, AssetBundle> bundles, Dictionary<string, string> spriteToBundles, List<BattleHudSpriteFontComponentRow> rows)
    {
        var result = new BattleHudSpriteFontRootResult(attachment);
        AssetBundle bundle = LoadBundle(attachment.absolutePath, bundles, result);
        if (bundle == null) return result;
        GameObject prefab = null;
        try { prefab = bundle.LoadAsset<GameObject>(attachment.prefabAsset); }
        catch (Exception ex) { result.failReason = "LoadAsset_exception:" + Short(ex.Message); }
        if (prefab == null)
        {
            if (string.IsNullOrEmpty(result.failReason)) result.failReason = "prefab_asset_not_found";
            return result;
        }
        try
        {
            var instance = (GameObject)GameObject.Instantiate(prefab);
            instance.name = "SpriteFontJoinHUD_" + attachment.order.ToString("00") + "_" + SafeName(Path.GetFileNameWithoutExtension(attachment.prefabAsset));
            instance.transform.SetParent(root, false);
            if (attachment.attachMode == "entry_inactive" || attachment.attachMode == "template_inactive") instance.SetActive(false);
            result.instantiateSuccess = true;
            result.sceneRootActive = instance.activeSelf;
            CountComponents(instance, attachment, result, spriteToBundles, rows);
        }
        catch (Exception ex)
        {
            result.failReason = "Instantiate_exception:" + Short(ex.Message);
        }
        return result;
    }

    private static void CountComponents(GameObject instance, BattleHudAttachment19 attachment, BattleHudSpriteFontRootResult result, Dictionary<string, string> spriteToBundles, List<BattleHudSpriteFontComponentRow> rows)
    {
        foreach (var transform in instance.GetComponentsInChildren<Transform>(true))
        {
            string path = HierarchyPath(transform, instance.transform);
            foreach (var component in transform.GetComponents<Component>())
            {
                try
                {
                    if (component == null)
                    {
                        result.missingScriptCount++;
                        rows.Add(new BattleHudSpriteFontComponentRow(attachment, path, "MissingScript", "unknown/log-only", "", "", "", "", "", "missing_component"));
                        continue;
                    }
                    if (component is Image image)
                    {
                        result.imageCount++;
                        string spriteName = image.sprite != null ? image.sprite.name : "";
                        string textureName = image.sprite != null && image.sprite.texture != null ? image.sprite.texture.name : "";
                        string bundle = spriteName != "" && spriteToBundles.ContainsKey(spriteName) ? spriteToBundles[spriteName] : "";
                        if (image.sprite != null) result.resolvedSpriteCount++; else result.unresolvedSpriteCount++;
                        rows.Add(new BattleHudSpriteFontComponentRow(attachment, path, component.GetType().FullName, "visual image", spriteName, textureName, bundle, SafeMaterialName(image.material), "", image.sprite != null ? "resolved_sprite_reference" : "sprite_null_or_dependency_unresolved"));
                    }
                    else if (component is RawImage raw)
                    {
                        result.rawImageCount++;
                        string textureName = raw.texture != null ? raw.texture.name : "";
                        if (raw.texture != null) result.resolvedRawTextureCount++;
                        rows.Add(new BattleHudSpriteFontComponentRow(attachment, path, component.GetType().FullName, "raw texture", "", textureName, "", SafeMaterialName(raw.material), "", raw.texture != null ? "resolved_texture_reference" : "texture_null_or_dependency_unresolved"));
                    }
                    else if (component is Text text)
                    {
                        result.textCount++;
                        if (text.font != null) result.resolvedTextFontCount++; else result.unresolvedTextFontCount++;
                        rows.Add(new BattleHudSpriteFontComponentRow(attachment, path, component.GetType().FullName, "text/font", "", "", "", SafeMaterialName(text.material), text.font != null ? text.font.name : "", text.font != null ? "resolved_ugui_font_reference" : "font_null_or_dependency_unresolved"));
                    }
                    else if (component is TextMeshProUGUI tmp)
                    {
                        result.tmpCount++;
                        TMP_FontAsset font = null;
                        try { font = tmp.font; } catch { }
                        if (font != null) result.resolvedTmpFontCount++; else result.unresolvedTmpFontCount++;
                        rows.Add(new BattleHudSpriteFontComponentRow(attachment, path, component.GetType().FullName, "tmp/font", "", "", "", SafeMaterialName(tmp.material), font != null ? font.name : "", font != null ? "resolved_tmp_font_reference" : "tmp_font_null_or_dependency_unresolved"));
                    }
                    else if (component is Button button)
                    {
                        result.buttonCount++;
                        bool hasRaycast = button.targetGraphic != null && button.targetGraphic.raycastTarget && button.GetComponentInParent<GraphicRaycaster>(true) != null && button.GetComponentInParent<Canvas>(true) != null;
                        if (hasRaycast) result.raycastReadyButtonCount++;
                        if (button.onClick != null && button.onClick.GetPersistentEventCount() > 0) result.handlerLinkedButtonCount++;
                        rows.Add(new BattleHudSpriteFontComponentRow(attachment, path, component.GetType().FullName, "button/raycast", "", "", "", "", "", hasRaycast ? "raycast_ready_component_only" : "button_raycast_incomplete"));
                    }
                }
                catch (Exception ex)
                {
                    rows.Add(new BattleHudSpriteFontComponentRow(attachment, path, component != null ? component.GetType().FullName : "MissingScript", "component-probe", "", "", "", "", "", "component_probe_exception:" + Short(ex.Message)));
                }
            }
        }
    }

    private static void HideNonHudEvidenceText(Transform hudRoot)
    {
        foreach (var text in UnityEngine.Object.FindObjectsOfType<Text>(true))
        {
            if (!IsChildOf(text.transform, hudRoot)) text.enabled = false;
        }
        foreach (var tmp in UnityEngine.Object.FindObjectsOfType<TMP_Text>(true))
        {
            if (!IsChildOf(tmp.transform, hudRoot)) tmp.enabled = false;
        }
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

    private static AssetBundle LoadBundle(string path, Dictionary<string, AssetBundle> bundles, BattleHudSpriteFontRootResult result)
    {
        if (string.IsNullOrEmpty(path)) return null;
        if (bundles.ContainsKey(path)) return bundles[path];
        if (!File.Exists(path))
        {
            if (result != null) result.failReason = "bundle_file_not_found";
            return null;
        }
        try
        {
            var bundle = AssetBundle.LoadFromFile(path);
            if (bundle == null)
            {
                if (result != null) result.failReason = "AssetBundle.LoadFromFile_returned_null";
                return null;
            }
            bundles[path] = bundle;
            return bundle;
        }
        catch (Exception ex)
        {
            if (result != null) result.failReason = "AssetBundle.LoadFromFile_exception:" + Short(ex.Message);
            return null;
        }
    }

    private static Camera EnsureCaptureCamera()
    {
        var camera = UnityEngine.Object.FindObjectOfType<Camera>();
        if (camera != null) return camera;
        var go = new GameObject("BattleHudSpriteFontJoinCamera");
        camera = go.AddComponent<Camera>();
        camera.orthographic = true;
        camera.orthographicSize = 7.0f;
        camera.clearFlags = CameraClearFlags.SolidColor;
        camera.backgroundColor = new Color(0.035f, 0.04f, 0.045f, 1f);
        go.transform.position = new Vector3(0f, 0f, -10f);
        return camera;
    }

    private static string Capture(Camera camera, Transform hudRoot)
    {
        var restoredRoots = new List<GameObject>();
        try
        {
            foreach (var sceneRoot in EditorSceneManager.GetActiveScene().GetRootGameObjects())
            {
                if (sceneRoot == hudRoot.gameObject || sceneRoot.GetComponentInChildren<Camera>(true) == camera) continue;
                if (!sceneRoot.activeSelf) continue;
                sceneRoot.SetActive(false);
                restoredRoots.Add(sceneRoot);
            }

            string fullPath = ProjectPath(CapturePath);
            Directory.CreateDirectory(Path.GetDirectoryName(fullPath));
            var rt = new RenderTexture(1680, 720, 24);
            camera.targetTexture = rt;
            var previous = RenderTexture.active;
            RenderTexture.active = rt;
            camera.Render();
            var texture = new Texture2D(1680, 720, TextureFormat.RGB24, false);
            texture.ReadPixels(new Rect(0, 0, 1680, 720), 0, 0);
            texture.Apply();
            File.WriteAllBytes(fullPath, texture.EncodeToPNG());
            camera.targetTexture = null;
            RenderTexture.active = previous;
            UnityEngine.Object.DestroyImmediate(texture);
            UnityEngine.Object.DestroyImmediate(rt);
            return CapturePath;
        }
        catch (Exception ex)
        {
            return "capture_failed:" + Short(ex.Message);
        }
        finally
        {
            foreach (var sceneRoot in restoredRoots)
            {
                if (sceneRoot != null) sceneRoot.SetActive(true);
            }
        }
    }

    private static List<BattleHudAttachment19> ReadAttachments(string json)
    {
        var list = new List<BattleHudAttachment19>();
        foreach (string item in ExtractObjectBlocks(ExtractArrayBlock(json, "\"attachments\"")))
        {
            list.Add(new BattleHudAttachment19
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

    private static List<BattleHudSpriteBundle> ReadSpriteBundles(string json)
    {
        var list = new List<BattleHudSpriteBundle>();
        foreach (string item in ExtractObjectBlocks(ExtractArrayBlock(json, "\"spriteBundles\"")))
        {
            list.Add(new BattleHudSpriteBundle { bundle = ReadValue(item, "bundle"), absolutePath = ReadValue(item, "absolutePath") });
        }
        return list;
    }

    private static void WriteResult(string jsonPath, string csvPath, List<BattleHudSpriteFontRootResult> roots, List<BattleHudSpriteFontComponentRow> rows, int loadedBundles, int spriteIndexCount, string capture)
    {
        int imageCount = Sum(roots, r => r.imageCount);
        int spriteCount = Sum(roots, r => r.resolvedSpriteCount);
        int textFontCount = Sum(roots, r => r.resolvedTextFontCount);
        int tmpFontCount = Sum(roots, r => r.resolvedTmpFontCount);
        int buttonCount = Sum(roots, r => r.buttonCount);
        int raycastReady = Sum(roots, r => r.raycastReadyButtonCount);
        int handlerLinked = Sum(roots, r => r.handlerLinkedButtonCount);
        var sb = new StringBuilder();
        sb.AppendLine("{");
        sb.AppendLine("  \"status\": \"battle_hud_sprite_region_font_join_complete\",");
        sb.AppendLine("  \"scene\": \"" + Json(ScenePath) + "\",");
        sb.AppendLine("  \"capture\": \"" + Json(CapturePath) + "\",");
        sb.AppendLine("  \"loadedBundleCount\": " + loadedBundles + ",");
        sb.AppendLine("  \"loadedSpriteNameIndexCount\": " + spriteIndexCount + ",");
        sb.AppendLine("  \"summary\": {");
        sb.AppendLine("    \"attachedRootCount\": " + roots.Count + ",");
        sb.AppendLine("    \"imageCount\": " + imageCount + ",");
        sb.AppendLine("    \"resolvedSpriteCount\": " + spriteCount + ",");
        sb.AppendLine("    \"unresolvedSpriteCount\": " + Sum(roots, r => r.unresolvedSpriteCount) + ",");
        sb.AppendLine("    \"resolvedTextFontCount\": " + textFontCount + ",");
        sb.AppendLine("    \"resolvedTmpFontCount\": " + tmpFontCount + ",");
        sb.AppendLine("    \"textMaterialResolvedCount\": " + rows.FindAll(r => (r.role == "text/font" || r.role == "tmp/font") && !string.IsNullOrEmpty(r.materialName)).Count + ",");
        sb.AppendLine("    \"buttonCount\": " + buttonCount + ",");
        sb.AppendLine("    \"raycastReadyButtonCount\": " + raycastReady + ",");
        sb.AppendLine("    \"handlerLinkedButtonCount\": " + handlerLinked + ",");
        sb.AppendLine("    \"clickValidation\": \"" + (buttonCount > 0 ? "component_raycast_ready_" + raycastReady + "_of_" + buttonCount + "_handler_linked_" + handlerLinked : "deferred:no_resolved_Button_component") + "\"");
        sb.AppendLine("  },");
        sb.AppendLine("  \"roots\": [");
        for (int i = 0; i < roots.Count; i++)
        {
            var r = roots[i];
            sb.AppendLine("    {");
            sb.AppendLine("      \"role\": \"" + Json(r.role) + "\",");
            sb.AppendLine("      \"prefabAsset\": \"" + Json(r.prefabAsset) + "\",");
            sb.AppendLine("      \"instantiateSuccess\": " + Bool(r.instantiateSuccess) + ",");
            sb.AppendLine("      \"sceneRootActive\": " + Bool(r.sceneRootActive) + ",");
            sb.AppendLine("      \"imageCount\": " + r.imageCount + ",");
            sb.AppendLine("      \"resolvedSpriteCount\": " + r.resolvedSpriteCount + ",");
            sb.AppendLine("      \"unresolvedSpriteCount\": " + r.unresolvedSpriteCount + ",");
            sb.AppendLine("      \"textCount\": " + r.textCount + ",");
            sb.AppendLine("      \"tmpCount\": " + r.tmpCount + ",");
            sb.AppendLine("      \"resolvedTextFontCount\": " + r.resolvedTextFontCount + ",");
            sb.AppendLine("      \"resolvedTmpFontCount\": " + r.resolvedTmpFontCount + ",");
            sb.AppendLine("      \"buttonCount\": " + r.buttonCount + ",");
            sb.AppendLine("      \"raycastReadyButtonCount\": " + r.raycastReadyButtonCount + ",");
            sb.AppendLine("      \"handlerLinkedButtonCount\": " + r.handlerLinkedButtonCount + ",");
            sb.AppendLine("      \"missingScriptCount\": " + r.missingScriptCount + ",");
            sb.AppendLine("      \"failReason\": \"" + Json(r.failReason) + "\"");
            sb.Append("    }");
            if (i + 1 < roots.Count) sb.Append(",");
            sb.AppendLine();
        }
        sb.AppendLine("  ]");
        sb.AppendLine("}");
        File.WriteAllText(jsonPath, sb.ToString(), Encoding.UTF8);

        var lines = new List<string>();
        lines.Add("rootRole,prefabAsset,hierarchyPath,componentType,role,spriteName,textureName,sourceBundle,materialName,fontName,status");
        foreach (var row in rows)
        {
            lines.Add(string.Join(",", new[] { Csv(row.rootRole), Csv(row.prefabAsset), Csv(row.hierarchyPath), Csv(row.componentType), Csv(row.role), Csv(row.spriteName), Csv(row.textureName), Csv(row.sourceBundle), Csv(row.materialName), Csv(row.fontName), Csv(row.status) }));
        }
        File.WriteAllLines(csvPath, lines, Encoding.UTF8);
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
        return sb.ToString();
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
    private static string ProjectPath(string assetPath) { return Path.Combine(Application.dataPath, "..", assetPath); }
    private static int Sum(List<BattleHudSpriteFontRootResult> results, Func<BattleHudSpriteFontRootResult, int> selector) { int c = 0; foreach (var r in results) c += selector(r); return c; }
    private static string Short(string value) { if (string.IsNullOrEmpty(value)) return ""; value = value.Replace("\r", " ").Replace("\n", " "); return value.Length > 180 ? value.Substring(0, 180) : value; }
    private static string SafeMaterialName(Material material) { try { return material != null ? material.name : ""; } catch { return ""; } }
    private static string SafeName(string value) { return string.IsNullOrEmpty(value) ? "unknown" : value.Replace(" ", "_").Replace(".", "_").Replace("/", "_").Replace("\\", "_"); }
    private static string Csv(string value) { value = value ?? ""; return "\"" + value.Replace("\"", "\"\"") + "\""; }
    private static string Json(string value) { return (value ?? "").Replace("\\", "\\\\").Replace("\"", "\\\"").Replace("\r", " ").Replace("\n", " "); }
    private static string Bool(bool value) { return value ? "true" : "false"; }
}

public sealed class BattleHudAttachment19
{
    public string id;
    public int order;
    public string role;
    public string attachMode;
    public string bundle;
    public string absolutePath;
    public string prefabAsset;
}

public sealed class BattleHudSpriteBundle
{
    public string bundle;
    public string absolutePath;
}

public sealed class BattleHudSpriteFontRootResult
{
    public string role;
    public string prefabAsset;
    public bool instantiateSuccess;
    public bool sceneRootActive;
    public string failReason = "";
    public int imageCount;
    public int rawImageCount;
    public int textCount;
    public int tmpCount;
    public int buttonCount;
    public int missingScriptCount;
    public int resolvedSpriteCount;
    public int unresolvedSpriteCount;
    public int resolvedRawTextureCount;
    public int resolvedTextFontCount;
    public int unresolvedTextFontCount;
    public int resolvedTmpFontCount;
    public int unresolvedTmpFontCount;
    public int raycastReadyButtonCount;
    public int handlerLinkedButtonCount;

    public BattleHudSpriteFontRootResult(BattleHudAttachment19 attachment)
    {
        role = attachment.role;
        prefabAsset = attachment.prefabAsset;
    }
}

public sealed class BattleHudSpriteFontComponentRow
{
    public string rootRole;
    public string prefabAsset;
    public string hierarchyPath;
    public string componentType;
    public string role;
    public string spriteName;
    public string textureName;
    public string sourceBundle;
    public string materialName;
    public string fontName;
    public string status;

    public BattleHudSpriteFontComponentRow(BattleHudAttachment19 attachment, string hierarchyPath, string componentType, string role, string spriteName, string textureName, string sourceBundle, string materialName, string fontName, string status)
    {
        rootRole = attachment.role;
        prefabAsset = attachment.prefabAsset;
        this.hierarchyPath = hierarchyPath;
        this.componentType = componentType;
        this.role = role;
        this.spriteName = spriteName;
        this.textureName = textureName;
        this.sourceBundle = sourceBundle;
        this.materialName = materialName;
        this.fontName = fontName;
        this.status = status;
    }
}
