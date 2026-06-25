using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text;

public static class BattleHudAttachToFlowEditor
{
    private const string ManifestPath = "Assets/RestoreData/battle/BATTLE_FLOW_WITH_HUD_ATTACH_MANIFEST.json";
    private const string ResultPath = "Assets/RestoreData/battle/BATTLE_FLOW_WITH_HUD_ATTACH_RESULT.json";
    private const string ResultCsvPath = "Assets/RestoreData/battle/BATTLE_FLOW_WITH_HUD_ATTACH_RESULT.csv";
    private const string BaseScenePath = "Assets/Scenes/BattleRuntimeFlowSkillEffectPlayableMarkers.unity";
    private const string OutputScenePath = "Assets/Scenes/BattleRuntimeFlowWithHudPrototype.unity";
    private const string CapturePath = "Assets/RestoreCaptures/battle_hud/BattleRuntimeFlowWithHudPrototype_1680x720.png";

    [MenuItem("GirlsWar/Battle/Attach Loadable HUD Prefabs To Flow Scene")]
    public static void Build()
    {
        string manifestFullPath = ProjectPath(ManifestPath);
        if (!File.Exists(manifestFullPath))
        {
            Debug.LogError("Missing HUD attach manifest: " + manifestFullPath);
            return;
        }

        string manifestJson = File.ReadAllText(manifestFullPath, Encoding.UTF8);
        var attachments = ReadAttachments(manifestJson);

        if (File.Exists(ProjectPath(BaseScenePath)))
        {
            EditorSceneManager.OpenScene(BaseScenePath, OpenSceneMode.Single);
        }
        else
        {
            EditorSceneManager.NewScene(NewSceneSetup.EmptyScene, NewSceneMode.Single);
        }

        var hudRoot = new GameObject("BattleOriginalHudEvidenceAttachRoot");
        hudRoot.transform.position = new Vector3(0f, 0f, -1.25f);
        var results = new List<BattleHudAttachResult>();
        var bundleCache = new Dictionary<string, AssetBundle>();

        for (int i = 0; i < attachments.Count; i++)
        {
            results.Add(AttachHudRoot(hudRoot.transform, attachments[i], bundleCache, i));
        }

        foreach (var pair in bundleCache)
        {
            if (pair.Value != null) pair.Value.Unload(false);
        }

        var camera = EnsureCaptureCamera();
        string captureNote = Capture(camera);
        WriteResult(ProjectPath(ResultPath), ProjectPath(ResultCsvPath), results, bundleCache.Count, captureNote);

        EditorSceneManager.SaveScene(EditorSceneManager.GetActiveScene(), OutputScenePath);
        AssetDatabase.Refresh();

        int attached = Count(results, r => r.instantiateSuccess);
        int buttons = Sum(results, r => r.buttonCount);
        int missing = Sum(results, r => r.missingScriptCount);
        Debug.Log("BattleHudAttachToFlow generated. attachments=" + results.Count + ", attached=" + attached + ", buttons=" + buttons + ", missingScripts=" + missing + ", capture=" + captureNote);
    }

    private static BattleHudAttachResult AttachHudRoot(Transform root, BattleHudAttachment attachment, Dictionary<string, AssetBundle> cache, int index)
    {
        var result = new BattleHudAttachResult(attachment);
        if (!File.Exists(attachment.absolutePath))
        {
            result.failReason = "bundle_file_not_found";
            CreateMarker(root, "HUDMissingBundle_" + attachment.id, MarkerPosition(index), Color.red, attachment.role + "\n" + result.failReason);
            return result;
        }

        AssetBundle bundle = GetBundle(attachment.absolutePath, cache, result);
        if (bundle == null)
        {
            CreateMarker(root, "HUDLoadFail_" + attachment.id, MarkerPosition(index), Color.red, attachment.role + "\n" + result.failReason);
            return result;
        }

        GameObject prefab = null;
        try
        {
            prefab = bundle.LoadAsset<GameObject>(attachment.prefabAsset);
        }
        catch (Exception ex)
        {
            result.failReason = "LoadAsset_exception:" + Short(ex.Message);
        }
        if (prefab == null)
        {
            if (string.IsNullOrEmpty(result.failReason)) result.failReason = "prefab_asset_not_found";
            CreateMarker(root, "HUDPrefabMissing_" + attachment.id, MarkerPosition(index), Color.yellow, attachment.role + "\n" + result.failReason);
            return result;
        }

        try
        {
            var instance = (GameObject)GameObject.Instantiate(prefab);
            result.originalRootActive = prefab.activeSelf;
            instance.name = "OriginalHUD_" + attachment.order.ToString("00") + "_" + SafeName(Path.GetFileNameWithoutExtension(attachment.prefabAsset));
            instance.transform.SetParent(root, false);
            result.rootLocalScale = Vec(instance.transform.localScale);
            result.rootLocalPosition = Vec(instance.transform.localPosition);
            result.rootSiblingIndex = instance.transform.GetSiblingIndex();

            if (attachment.attachMode == "entry_inactive" || attachment.attachMode == "template_inactive")
            {
                instance.SetActive(false);
            }
            result.sceneRootActive = instance.activeSelf;

            var rect = instance.GetComponent<RectTransform>();
            if (rect != null)
            {
                result.rootHasRectTransform = true;
                result.anchorMin = Vec2(rect.anchorMin);
                result.anchorMax = Vec2(rect.anchorMax);
                result.pivot = Vec2(rect.pivot);
                result.anchoredPosition = Vec2(rect.anchoredPosition);
                result.sizeDelta = Vec2(rect.sizeDelta);
            }

            CountTree(instance, result);
            result.instantiateSuccess = true;

            if (attachment.attachMode == "entry_inactive" || attachment.attachMode == "template_inactive")
            {
                CreateMarker(root, "HUDEntryMarker_" + attachment.id, MarkerPosition(index), Color.cyan, attachment.role + "\nkept inactive\n" + attachment.prefabAsset);
            }
        }
        catch (Exception ex)
        {
            result.failReason = "Instantiate_exception:" + Short(ex.Message);
            CreateMarker(root, "HUDInstantiateFail_" + attachment.id, MarkerPosition(index), Color.yellow, attachment.role + "\n" + result.failReason);
        }
        return result;
    }

    private static AssetBundle GetBundle(string absolutePath, Dictionary<string, AssetBundle> cache, BattleHudAttachResult result)
    {
        if (cache.ContainsKey(absolutePath)) return cache[absolutePath];
        try
        {
            var bundle = AssetBundle.LoadFromFile(absolutePath);
            if (bundle == null)
            {
                result.failReason = "AssetBundle.LoadFromFile_returned_null";
                return null;
            }
            cache[absolutePath] = bundle;
            return bundle;
        }
        catch (Exception ex)
        {
            result.failReason = "AssetBundle.LoadFromFile_exception:" + Short(ex.Message);
            return null;
        }
    }

    private static void CountTree(GameObject root, BattleHudAttachResult result)
    {
        var transforms = root.GetComponentsInChildren<Transform>(true);
        result.gameObjectCount = transforms.Length;
        foreach (var transform in transforms)
        {
            int componentCount = 0;
            foreach (var component in transform.gameObject.GetComponents<Component>())
            {
                componentCount++;
                if (component == null)
                {
                    result.missingScriptCount++;
                    continue;
                }
                string typeName = component.GetType().Name;
                result.AddType(typeName);
                if (typeName == "RectTransform") result.rectTransformCount++;
                else if (typeName == "Canvas") result.canvasCount++;
                else if (typeName == "CanvasScaler") result.canvasScalerCount++;
                else if (typeName == "GraphicRaycaster") result.graphicRaycasterCount++;
                else if (typeName == "Image") result.imageCount++;
                else if (typeName == "RawImage") result.rawImageCount++;
                else if (typeName == "Text") result.textCount++;
                else if (typeName == "TextMeshProUGUI" || typeName.Contains("TMP")) result.tmpCount++;
                else if (typeName == "Button") result.buttonCount++;
            }
            if (componentCount == 0) result.emptyGameObjectCount++;
        }
        result.spriteMaterialFontDependencyUnresolvedCount = result.missingScriptCount;
        if (result.imageCount == 0 && result.textCount == 0 && result.tmpCount == 0 && result.buttonCount == 0 && result.missingScriptCount > 0)
        {
            result.componentResolutionAnalysis = "RectTransform/Canvas resolved, but widget scripts resolve as missing MonoBehaviour in this prototype project. Unity UI module exists, so next join should reconstruct original UI script/type references and sprite-region dependencies.";
            result.clickValidation = "deferred:no_resolved_Button_component";
        }
        else if (result.buttonCount == 0)
        {
            result.componentResolutionAnalysis = "No resolved Button component on attached root.";
            result.clickValidation = "deferred:no_resolved_Button_component";
        }
        else
        {
            result.componentResolutionAnalysis = "Resolved Button components exist; click/raycast validation can run in the next pass.";
            result.clickValidation = "pending";
        }
    }

    private static Camera EnsureCaptureCamera()
    {
        var camera = Camera.main;
        if (camera != null) return camera;
        var existing = UnityEngine.Object.FindObjectOfType<Camera>();
        if (existing != null) return existing;
        var cameraObject = new GameObject("BattleHudAttachCaptureCamera");
        camera = cameraObject.AddComponent<Camera>();
        camera.orthographic = true;
        camera.orthographicSize = 7.0f;
        camera.clearFlags = CameraClearFlags.SolidColor;
        camera.backgroundColor = new Color(0.035f, 0.04f, 0.045f, 1f);
        cameraObject.transform.position = new Vector3(0f, 0f, -10f);
        return camera;
    }

    private static string Capture(Camera camera)
    {
        try
        {
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
    }

    private static void CreateMarker(Transform root, string name, Vector3 position, Color color, string label)
    {
        var go = GameObject.CreatePrimitive(PrimitiveType.Cube);
        go.name = name;
        go.transform.SetParent(root, false);
        go.transform.localPosition = position;
        go.transform.localScale = new Vector3(0.55f, 0.32f, 0.08f);
        var renderer = go.GetComponent<Renderer>();
        var material = new Material(Shader.Find("Standard"));
        material.color = color;
        renderer.sharedMaterial = material;
        AddLabel(go.transform, label, new Vector3(0f, -0.42f, -0.18f), 0.055f);
    }

    private static Vector3 MarkerPosition(int index)
    {
        return new Vector3(-5.4f + (index % 5) * 2.6f, 4.9f - (index / 5) * 0.95f, -0.2f);
    }

    private static void AddLabel(Transform parent, string text, Vector3 localPosition, float size)
    {
        var label = new GameObject("HudAttachEvidenceLabel");
        label.transform.SetParent(parent, false);
        label.transform.localPosition = localPosition;
        var mesh = label.AddComponent<TextMesh>();
        mesh.text = text;
        mesh.fontSize = 34;
        mesh.characterSize = size;
        mesh.anchor = TextAnchor.MiddleCenter;
        mesh.alignment = TextAlignment.Center;
        mesh.color = Color.white;
    }

    private static List<BattleHudAttachment> ReadAttachments(string json)
    {
        var list = new List<BattleHudAttachment>();
        foreach (string item in ExtractObjectBlocks(ExtractArrayBlock(json, "\"attachments\"")))
        {
            list.Add(new BattleHudAttachment
            {
                id = ReadValue(item, "id"),
                order = ReadInt(item, "order"),
                role = ReadValue(item, "role"),
                attachMode = ReadValue(item, "attachMode"),
                reason = ReadValue(item, "reason"),
                bundle = ReadValue(item, "bundle"),
                absolutePath = ReadValue(item, "absolutePath"),
                prefabAsset = ReadValue(item, "prefabAsset"),
                sourceKind = ReadValue(item, "sourceKind"),
            });
        }
        return list;
    }

    private static string ExtractArrayBlock(string json, string key)
    {
        int keyIndex = json.IndexOf(key, StringComparison.Ordinal);
        if (keyIndex < 0) return "";
        int start = json.IndexOf('[', keyIndex);
        if (start < 0) return "";
        int depth = 0;
        bool inString = false;
        bool escape = false;
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
            if (c == '"')
            {
                inString = true;
                continue;
            }
            if (c == '[') depth++;
            if (c == ']') depth--;
            if (depth == 0) return json.Substring(start, i - start + 1);
        }
        return "";
    }

    private static List<string> ExtractObjectBlocks(string arrayBlock)
    {
        var objects = new List<string>();
        int depth = 0;
        int start = -1;
        bool inString = false;
        bool escape = false;
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
            if (c == '"')
            {
                inString = true;
                continue;
            }
            if (c == '{')
            {
                if (depth == 0) start = i;
                depth++;
            }
            else if (c == '}')
            {
                depth--;
                if (depth == 0 && start >= 0) objects.Add(arrayBlock.Substring(start, i - start + 1));
            }
        }
        return objects;
    }

    private static string ReadValue(string block, string key)
    {
        string needle = "\"" + key + "\"";
        int keyIndex = block.IndexOf(needle, StringComparison.Ordinal);
        if (keyIndex < 0) return "";
        int colon = block.IndexOf(':', keyIndex);
        if (colon < 0) return "";
        int quote = block.IndexOf('"', colon + 1);
        if (quote < 0) return "";
        var sb = new StringBuilder();
        bool escape = false;
        for (int i = quote + 1; i < block.Length; i++)
        {
            char c = block[i];
            if (escape)
            {
                if (c == 'n') sb.Append('\n');
                else if (c == 'r') sb.Append('\r');
                else if (c == 't') sb.Append('\t');
                else sb.Append(c);
                escape = false;
                continue;
            }
            if (c == '\\')
            {
                escape = true;
                continue;
            }
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
        if (colon < 0) return 0;
        int start = colon + 1;
        while (start < block.Length && char.IsWhiteSpace(block[start])) start++;
        int end = start;
        while (end < block.Length && (char.IsDigit(block[end]) || block[end] == '-')) end++;
        int value;
        return int.TryParse(block.Substring(start, end - start), out value) ? value : 0;
    }

    private static void WriteResult(string jsonPath, string csvPath, List<BattleHudAttachResult> results, int loadedBundles, string captureNote)
    {
        var sb = new StringBuilder();
        sb.AppendLine("{");
        sb.AppendLine("  \"status\": \"battle_flow_with_hud_attach_complete\",");
        sb.AppendLine("  \"sourceManifest\": \"" + Json(ManifestPath) + "\",");
        sb.AppendLine("  \"baseScene\": \"" + Json(BaseScenePath) + "\",");
        sb.AppendLine("  \"scene\": \"" + Json(OutputScenePath) + "\",");
        sb.AppendLine("  \"capture\": \"" + Json(captureNote) + "\",");
        sb.AppendLine("  \"loadedBundleCount\": " + loadedBundles + ",");
        sb.AppendLine("  \"summary\": {");
        sb.AppendLine("    \"attachmentCount\": " + results.Count + ",");
        sb.AppendLine("    \"attachedRootCount\": " + Count(results, r => r.instantiateSuccess) + ",");
        sb.AppendLine("    \"canvasCount\": " + Sum(results, r => r.canvasCount) + ",");
        sb.AppendLine("    \"rectTransformCount\": " + Sum(results, r => r.rectTransformCount) + ",");
        sb.AppendLine("    \"imageCount\": " + Sum(results, r => r.imageCount + r.rawImageCount) + ",");
        sb.AppendLine("    \"textCount\": " + Sum(results, r => r.textCount + r.tmpCount) + ",");
        sb.AppendLine("    \"buttonCount\": " + Sum(results, r => r.buttonCount) + ",");
        sb.AppendLine("    \"missingScriptCount\": " + Sum(results, r => r.missingScriptCount) + ",");
        sb.AppendLine("    \"spriteMaterialFontDependencyUnresolvedCount\": " + Sum(results, r => r.spriteMaterialFontDependencyUnresolvedCount) + ",");
        sb.AppendLine("    \"clickValidation\": \"" + (Sum(results, r => r.buttonCount) > 0 ? "pending" : "deferred:no_resolved_Button_component") + "\"");
        sb.AppendLine("  },");
        sb.AppendLine("  \"attachedRoots\": [");
        for (int i = 0; i < results.Count; i++)
        {
            var r = results[i];
            sb.AppendLine("    {");
            sb.AppendLine("      \"id\": \"" + Json(r.id) + "\",");
            sb.AppendLine("      \"order\": " + r.order + ",");
            sb.AppendLine("      \"role\": \"" + Json(r.role) + "\",");
            sb.AppendLine("      \"attachMode\": \"" + Json(r.attachMode) + "\",");
            sb.AppendLine("      \"bundle\": \"" + Json(r.bundle) + "\",");
            sb.AppendLine("      \"prefabAsset\": \"" + Json(r.prefabAsset) + "\",");
            sb.AppendLine("      \"instantiateSuccess\": " + Bool(r.instantiateSuccess) + ",");
            sb.AppendLine("      \"failReason\": \"" + Json(r.failReason) + "\",");
            sb.AppendLine("      \"originalRootActive\": " + Bool(r.originalRootActive) + ",");
            sb.AppendLine("      \"sceneRootActive\": " + Bool(r.sceneRootActive) + ",");
            sb.AppendLine("      \"gameObjectCount\": " + r.gameObjectCount + ",");
            sb.AppendLine("      \"rectTransformCount\": " + r.rectTransformCount + ",");
            sb.AppendLine("      \"canvasCount\": " + r.canvasCount + ",");
            sb.AppendLine("      \"canvasScalerCount\": " + r.canvasScalerCount + ",");
            sb.AppendLine("      \"graphicRaycasterCount\": " + r.graphicRaycasterCount + ",");
            sb.AppendLine("      \"imageCount\": " + r.imageCount + ",");
            sb.AppendLine("      \"rawImageCount\": " + r.rawImageCount + ",");
            sb.AppendLine("      \"textCount\": " + r.textCount + ",");
            sb.AppendLine("      \"tmpCount\": " + r.tmpCount + ",");
            sb.AppendLine("      \"buttonCount\": " + r.buttonCount + ",");
            sb.AppendLine("      \"missingScriptCount\": " + r.missingScriptCount + ",");
            sb.AppendLine("      \"spriteMaterialFontDependencyUnresolvedCount\": " + r.spriteMaterialFontDependencyUnresolvedCount + ",");
            sb.AppendLine("      \"rootHasRectTransform\": " + Bool(r.rootHasRectTransform) + ",");
            sb.AppendLine("      \"rootLocalScale\": \"" + Json(r.rootLocalScale) + "\",");
            sb.AppendLine("      \"rootLocalPosition\": \"" + Json(r.rootLocalPosition) + "\",");
            sb.AppendLine("      \"rootSiblingIndex\": " + r.rootSiblingIndex + ",");
            sb.AppendLine("      \"anchorMin\": \"" + Json(r.anchorMin) + "\",");
            sb.AppendLine("      \"anchorMax\": \"" + Json(r.anchorMax) + "\",");
            sb.AppendLine("      \"pivot\": \"" + Json(r.pivot) + "\",");
            sb.AppendLine("      \"anchoredPosition\": \"" + Json(r.anchoredPosition) + "\",");
            sb.AppendLine("      \"sizeDelta\": \"" + Json(r.sizeDelta) + "\",");
            sb.AppendLine("      \"clickValidation\": \"" + Json(r.clickValidation) + "\",");
            sb.AppendLine("      \"componentResolutionAnalysis\": \"" + Json(r.componentResolutionAnalysis) + "\"");
            sb.Append("    }");
            if (i + 1 < results.Count) sb.Append(",");
            sb.AppendLine();
        }
        sb.AppendLine("  ]");
        sb.AppendLine("}");
        File.WriteAllText(jsonPath, sb.ToString(), Encoding.UTF8);

        var lines = new List<string>();
        lines.Add("id,order,role,attachMode,bundle,prefabAsset,instantiateSuccess,failReason,originalRootActive,sceneRootActive,gameObjectCount,rectTransformCount,canvasCount,canvasScalerCount,graphicRaycasterCount,imageCount,rawImageCount,textCount,tmpCount,buttonCount,missingScriptCount,spriteMaterialFontDependencyUnresolvedCount,rootHasRectTransform,rootLocalScale,rootLocalPosition,rootSiblingIndex,anchorMin,anchorMax,pivot,anchoredPosition,sizeDelta,clickValidation,componentResolutionAnalysis");
        foreach (var r in results)
        {
            lines.Add(string.Join(",", new[] {
                Csv(r.id), Csv(r.order.ToString()), Csv(r.role), Csv(r.attachMode), Csv(r.bundle), Csv(r.prefabAsset), Csv(Bool(r.instantiateSuccess)), Csv(r.failReason), Csv(Bool(r.originalRootActive)), Csv(Bool(r.sceneRootActive)),
                Csv(r.gameObjectCount.ToString()), Csv(r.rectTransformCount.ToString()), Csv(r.canvasCount.ToString()), Csv(r.canvasScalerCount.ToString()), Csv(r.graphicRaycasterCount.ToString()), Csv(r.imageCount.ToString()),
                Csv(r.rawImageCount.ToString()), Csv(r.textCount.ToString()), Csv(r.tmpCount.ToString()), Csv(r.buttonCount.ToString()), Csv(r.missingScriptCount.ToString()), Csv(r.spriteMaterialFontDependencyUnresolvedCount.ToString()),
                Csv(Bool(r.rootHasRectTransform)), Csv(r.rootLocalScale), Csv(r.rootLocalPosition), Csv(r.rootSiblingIndex.ToString()), Csv(r.anchorMin), Csv(r.anchorMax), Csv(r.pivot), Csv(r.anchoredPosition), Csv(r.sizeDelta),
                Csv(r.clickValidation), Csv(r.componentResolutionAnalysis)
            }));
        }
        File.WriteAllLines(csvPath, lines, Encoding.UTF8);
    }

    private static string ProjectPath(string assetPath)
    {
        return Path.Combine(Application.dataPath, "..", assetPath);
    }

    private static int Count(List<BattleHudAttachResult> results, Func<BattleHudAttachResult, bool> predicate)
    {
        int count = 0;
        foreach (var r in results) if (predicate(r)) count++;
        return count;
    }

    private static int Sum(List<BattleHudAttachResult> results, Func<BattleHudAttachResult, int> selector)
    {
        int count = 0;
        foreach (var r in results) count += selector(r);
        return count;
    }

    private static string Vec(Vector3 value)
    {
        return value.x.ToString("0.###") + "," + value.y.ToString("0.###") + "," + value.z.ToString("0.###");
    }

    private static string Vec2(Vector2 value)
    {
        return value.x.ToString("0.###") + "," + value.y.ToString("0.###");
    }

    private static string SafeName(string value)
    {
        if (string.IsNullOrEmpty(value)) return "unknown";
        var sb = new StringBuilder();
        foreach (char c in value)
        {
            sb.Append(char.IsLetterOrDigit(c) || c == '_' || c == '-' ? c : '_');
        }
        return sb.ToString();
    }

    private static string Short(string value)
    {
        if (string.IsNullOrEmpty(value)) return "";
        value = value.Replace("\r", " ").Replace("\n", " ");
        return value.Length > 180 ? value.Substring(0, 180) : value;
    }

    private static string Csv(string value)
    {
        value = value ?? "";
        return "\"" + value.Replace("\"", "\"\"") + "\"";
    }

    private static string Json(string value)
    {
        if (string.IsNullOrEmpty(value)) return "";
        var sb = new StringBuilder();
        foreach (char c in value)
        {
            if (c == '\\') sb.Append("\\\\");
            else if (c == '"') sb.Append("\\\"");
            else if (c == '\r' || c == '\n') sb.Append(' ');
            else if (c < 32) sb.Append("\\u").Append(((int)c).ToString("x4"));
            else sb.Append(c);
        }
        return sb.ToString();
    }

    private static string Bool(bool value)
    {
        return value ? "true" : "false";
    }
}

public sealed class BattleHudAttachment
{
    public string id;
    public int order;
    public string role;
    public string attachMode;
    public string reason;
    public string bundle;
    public string absolutePath;
    public string prefabAsset;
    public string sourceKind;
}

public sealed class BattleHudAttachResult
{
    public string id;
    public int order;
    public string role;
    public string attachMode;
    public string bundle;
    public string absolutePath;
    public string prefabAsset;
    public bool instantiateSuccess;
    public string failReason = "";
    public bool originalRootActive;
    public bool sceneRootActive;
    public int gameObjectCount;
    public int emptyGameObjectCount;
    public int rectTransformCount;
    public int canvasCount;
    public int canvasScalerCount;
    public int graphicRaycasterCount;
    public int imageCount;
    public int rawImageCount;
    public int textCount;
    public int tmpCount;
    public int buttonCount;
    public int missingScriptCount;
    public int spriteMaterialFontDependencyUnresolvedCount;
    public bool rootHasRectTransform;
    public string rootLocalScale = "";
    public string rootLocalPosition = "";
    public int rootSiblingIndex;
    public string anchorMin = "";
    public string anchorMax = "";
    public string pivot = "";
    public string anchoredPosition = "";
    public string sizeDelta = "";
    public string clickValidation = "deferred:no_resolved_Button_component";
    public string componentResolutionAnalysis = "";
    private readonly Dictionary<string, int> typeCounts = new Dictionary<string, int>();

    public BattleHudAttachResult(BattleHudAttachment attachment)
    {
        id = attachment.id;
        order = attachment.order;
        role = attachment.role;
        attachMode = attachment.attachMode;
        bundle = attachment.bundle;
        absolutePath = attachment.absolutePath;
        prefabAsset = attachment.prefabAsset;
    }

    public void AddType(string typeName)
    {
        if (!typeCounts.ContainsKey(typeName)) typeCounts[typeName] = 0;
        typeCounts[typeName]++;
    }
}
