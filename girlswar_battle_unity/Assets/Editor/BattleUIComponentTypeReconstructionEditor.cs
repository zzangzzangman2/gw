using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.UI;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text;

public static class BattleUIComponentTypeReconstructionEditor
{
    private const string ManifestPath = "Assets/RestoreData/battle/BATTLE_FLOW_WITH_HUD_ATTACH_MANIFEST.json";
    private const string TypeEvidencePath = "Assets/RestoreData/battle/BATTLE_UI_COMPONENT_TYPE_EVIDENCE.json";
    private const string ResultPath = "Assets/RestoreData/battle/BATTLE_UI_COMPONENT_TYPE_RECONSTRUCTION_RESULT.json";
    private const string ResultCsvPath = "Assets/RestoreData/battle/BATTLE_UI_COMPONENT_TYPE_RECONSTRUCTION_COMPONENTS.csv";
    private const string BaseScenePath = "Assets/Scenes/BattleRuntimeFlowSkillEffectPlayableMarkers.unity";
    private const string OutputScenePath = "Assets/Scenes/BattleRuntimeFlowWithHudTypeProbe.unity";
    private const string CapturePath = "Assets/RestoreCaptures/battle_hud/BattleRuntimeFlowWithHudTypeProbe_1680x720.png";

    [MenuItem("GirlsWar/Battle/Reconstruct Battle UI Component Types")]
    public static void Build()
    {
        var attachments = ReadAttachments(File.ReadAllText(ProjectPath(ManifestPath), Encoding.UTF8));
        if (File.Exists(ProjectPath(BaseScenePath)))
        {
            EditorSceneManager.OpenScene(BaseScenePath, OpenSceneMode.Single);
        }
        else
        {
            EditorSceneManager.NewScene(NewSceneSetup.EmptyScene, NewSceneMode.Single);
        }

        var root = new GameObject("BattleUIComponentTypeProbeRoot");
        root.transform.position = new Vector3(0f, 0f, -1.35f);
        var bundleCache = new Dictionary<string, AssetBundle>();
        var results = new List<BattleUITypeProbeResult>();
        for (int i = 0; i < attachments.Count; i++)
        {
            results.Add(Attach(root.transform, attachments[i], bundleCache, i));
        }
        int loadedBundles = bundleCache.Count;
        foreach (var pair in bundleCache)
        {
            if (pair.Value != null) pair.Value.Unload(false);
        }

        var camera = EnsureCaptureCamera();
        string capture = Capture(camera);
        WriteResult(ProjectPath(ResultPath), ProjectPath(ResultCsvPath), results, loadedBundles, capture);
        EditorSceneManager.SaveScene(EditorSceneManager.GetActiveScene(), OutputScenePath);
        AssetDatabase.Refresh();
        Debug.Log("BattleUIComponentTypeReconstruction generated. roots=" + results.Count + ", missing=" + Sum(results, r => r.missingScriptCount) + ", images=" + Sum(results, r => r.imageCount) + ", text=" + Sum(results, r => r.textCount + r.tmpCount) + ", buttons=" + Sum(results, r => r.buttonCount));
    }

    private static BattleUITypeProbeResult Attach(Transform root, BattleUITypeProbeAttachment attachment, Dictionary<string, AssetBundle> cache, int index)
    {
        var result = new BattleUITypeProbeResult(attachment);
        AssetBundle bundle = null;
        if (!cache.TryGetValue(attachment.absolutePath, out bundle))
        {
            try
            {
                bundle = AssetBundle.LoadFromFile(attachment.absolutePath);
                if (bundle == null)
                {
                    result.failReason = "AssetBundle.LoadFromFile_returned_null";
                    return result;
                }
                cache[attachment.absolutePath] = bundle;
            }
            catch (Exception ex)
            {
                result.failReason = "AssetBundle.LoadFromFile_exception:" + Short(ex.Message);
                return result;
            }
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
            return result;
        }

        try
        {
            var instance = (GameObject)GameObject.Instantiate(prefab);
            instance.name = "TypeProbeHUD_" + attachment.order.ToString("00") + "_" + SafeName(Path.GetFileNameWithoutExtension(attachment.prefabAsset));
            instance.transform.SetParent(root, false);
            if (attachment.attachMode == "entry_inactive" || attachment.attachMode == "template_inactive") instance.SetActive(false);
            result.instantiateSuccess = true;
            result.sceneRootActive = instance.activeSelf;
            CountTree(instance, result);
            if (attachment.attachMode == "entry_inactive" || attachment.attachMode == "template_inactive")
            {
                CreateMarker(root, "TypeProbeMarker_" + attachment.id, MarkerPosition(index), Color.cyan, attachment.role + "\ntype probe inactive\n" + Path.GetFileName(attachment.prefabAsset));
            }
        }
        catch (Exception ex)
        {
            result.failReason = "Instantiate_exception:" + Short(ex.Message);
        }
        return result;
    }

    private static void CountTree(GameObject root, BattleUITypeProbeResult result)
    {
        result.gameObjectCount = root.GetComponentsInChildren<Transform>(true).Length;
        foreach (var component in root.GetComponentsInChildren<Component>(true))
        {
            if (component == null)
            {
                result.missingScriptCount++;
                continue;
            }
            string typeName = component.GetType().Name;
            string ns = component.GetType().Namespace ?? "";
            result.AddType(ns + "." + typeName);
            if (component is RectTransform) result.rectTransformCount++;
            if (component is Canvas) result.canvasCount++;
            if (typeName == "CanvasScaler") result.canvasScalerCount++;
            if (typeName == "GraphicRaycaster") result.graphicRaycasterCount++;
            if (component is Button button)
            {
                result.buttonCount++;
                result.buttonValidationCount++;
                if (button.interactable) result.buttonInteractableCount++;
                if (button.targetGraphic == null) result.buttonWithoutTargetGraphicCount++;
                bool hasCanvas = button.GetComponentInParent<Canvas>(true) != null;
                bool hasRaycaster = button.GetComponentInParent<GraphicRaycaster>(true) != null;
                bool hasTarget = button.targetGraphic != null && button.targetGraphic.raycastTarget;
                if (hasCanvas && hasRaycaster && hasTarget) result.raycastReadyButtonCount++;
            }
            if (component is Image) result.imageCount++;
            if (component is RawImage) result.rawImageCount++;
            if (component is Text) result.textCount++;
            if (typeName == "TextMeshProUGUI") result.tmpCount++;
            if (IsProxyType(ns, typeName)) result.proxyResolvedCount++;
            if (IsOfficialUiType(ns, typeName)) result.officialUiResolvedCount++;
        }
        result.clickValidation = result.buttonCount > 0 ? "validated:component_only_raycast_ready_" + result.raycastReadyButtonCount + "_of_" + result.buttonCount : "deferred:no_resolved_Button_component";
    }

    private static bool IsOfficialUiType(string ns, string typeName)
    {
        return ns == "UnityEngine.UI" || ns == "TMPro" || typeName == "TextMeshProUGUI";
    }

    private static bool IsProxyType(string ns, string typeName)
    {
        return ns == "YouYou" || ns == "LuaComponentBinder" || ns == "Spine.Unity" || ns == "Coffee.UIExtensions" || ns == "DG.Tweening" || ns == "SuperScrollView" || typeName == "Empty4Raycast";
    }

    private static Camera EnsureCaptureCamera()
    {
        var camera = UnityEngine.Object.FindObjectOfType<Camera>();
        if (camera != null) return camera;
        var go = new GameObject("BattleUITypeProbeCamera");
        camera = go.AddComponent<Camera>();
        camera.orthographic = true;
        camera.orthographicSize = 7.0f;
        camera.clearFlags = CameraClearFlags.SolidColor;
        camera.backgroundColor = new Color(0.035f, 0.04f, 0.045f, 1f);
        go.transform.position = new Vector3(0f, 0f, -10f);
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
        var label = new GameObject("TypeProbeLabel");
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

    private static List<BattleUITypeProbeAttachment> ReadAttachments(string json)
    {
        var list = new List<BattleUITypeProbeAttachment>();
        foreach (string item in ExtractObjectBlocks(ExtractArrayBlock(json, "\"attachments\"")))
        {
            list.Add(new BattleUITypeProbeAttachment
            {
                id = ReadValue(item, "id"),
                order = ReadInt(item, "order"),
                role = ReadValue(item, "role"),
                attachMode = ReadValue(item, "attachMode"),
                bundle = ReadValue(item, "bundle"),
                absolutePath = ReadValue(item, "absolutePath"),
                prefabAsset = ReadValue(item, "prefabAsset"),
            });
        }
        return list;
    }

    private static string ExtractArrayBlock(string json, string key)
    {
        int keyIndex = json.IndexOf(key, StringComparison.Ordinal);
        if (keyIndex < 0) return "";
        int start = json.IndexOf('[', keyIndex);
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
            if (c == '"') { inString = true; continue; }
            if (c == '{') { if (depth == 0) start = i; depth++; }
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
        int quote = block.IndexOf('"', colon + 1);
        var sb = new StringBuilder();
        bool escape = false;
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
        int value;
        return int.TryParse(block.Substring(start, end - start), out value) ? value : 0;
    }

    private static void WriteResult(string jsonPath, string csvPath, List<BattleUITypeProbeResult> results, int loadedBundles, string capture)
    {
        var beforeJson = File.Exists(ProjectPath(TypeEvidencePath)) ? File.ReadAllText(ProjectPath(TypeEvidencePath), Encoding.UTF8) : "";
        int beforeMissing = ReadInt(beforeJson, "missingScriptCount");
        var sb = new StringBuilder();
        int afterMissing = Sum(results, r => r.missingScriptCount);
        sb.AppendLine("{");
        sb.AppendLine("  \"status\": \"battle_ui_component_type_reconstruction_complete\",");
        sb.AppendLine("  \"scene\": \"" + Json(OutputScenePath) + "\",");
        sb.AppendLine("  \"capture\": \"" + Json(capture) + "\",");
        sb.AppendLine("  \"loadedBundleCount\": " + loadedBundles + ",");
        sb.AppendLine("  \"summary\": {");
        sb.AppendLine("    \"attachedRootCount\": " + Count(results, r => r.instantiateSuccess) + ",");
        sb.AppendLine("    \"beforeMissingScriptCount\": " + beforeMissing + ",");
        sb.AppendLine("    \"afterMissingScriptCount\": " + afterMissing + ",");
        sb.AppendLine("    \"missingScriptReduction\": " + (beforeMissing - afterMissing) + ",");
        sb.AppendLine("    \"canvasCount\": " + Sum(results, r => r.canvasCount) + ",");
        sb.AppendLine("    \"rectTransformCount\": " + Sum(results, r => r.rectTransformCount) + ",");
        sb.AppendLine("    \"imageCount\": " + Sum(results, r => r.imageCount + r.rawImageCount) + ",");
        sb.AppendLine("    \"textCount\": " + Sum(results, r => r.textCount + r.tmpCount) + ",");
        sb.AppendLine("    \"buttonCount\": " + Sum(results, r => r.buttonCount) + ",");
        sb.AppendLine("    \"officialUiResolvedCount\": " + Sum(results, r => r.officialUiResolvedCount) + ",");
        sb.AppendLine("    \"proxyResolvedCount\": " + Sum(results, r => r.proxyResolvedCount) + ",");
        sb.AppendLine("    \"buttonValidationCount\": " + Sum(results, r => r.buttonValidationCount) + ",");
        sb.AppendLine("    \"buttonInteractableCount\": " + Sum(results, r => r.buttonInteractableCount) + ",");
        sb.AppendLine("    \"raycastReadyButtonCount\": " + Sum(results, r => r.raycastReadyButtonCount) + ",");
        sb.AppendLine("    \"buttonWithoutTargetGraphicCount\": " + Sum(results, r => r.buttonWithoutTargetGraphicCount) + ",");
        sb.AppendLine("    \"clickValidation\": \"" + (Sum(results, r => r.buttonCount) > 0 ? "validated:component_only_raycast_ready_" + Sum(results, r => r.raycastReadyButtonCount) + "_of_" + Sum(results, r => r.buttonCount) : "deferred:no_resolved_Button_component") + "\"");
        sb.AppendLine("  },");
        sb.AppendLine("  \"roots\": [");
        for (int i = 0; i < results.Count; i++)
        {
            var r = results[i];
            sb.AppendLine("    {");
            sb.AppendLine("      \"role\": \"" + Json(r.role) + "\",");
            sb.AppendLine("      \"prefabAsset\": \"" + Json(r.prefabAsset) + "\",");
            sb.AppendLine("      \"instantiateSuccess\": " + Bool(r.instantiateSuccess) + ",");
            sb.AppendLine("      \"sceneRootActive\": " + Bool(r.sceneRootActive) + ",");
            sb.AppendLine("      \"gameObjectCount\": " + r.gameObjectCount + ",");
            sb.AppendLine("      \"rectTransformCount\": " + r.rectTransformCount + ",");
            sb.AppendLine("      \"canvasCount\": " + r.canvasCount + ",");
            sb.AppendLine("      \"imageCount\": " + r.imageCount + ",");
            sb.AppendLine("      \"rawImageCount\": " + r.rawImageCount + ",");
            sb.AppendLine("      \"textCount\": " + r.textCount + ",");
            sb.AppendLine("      \"tmpCount\": " + r.tmpCount + ",");
            sb.AppendLine("      \"buttonCount\": " + r.buttonCount + ",");
            sb.AppendLine("      \"missingScriptCount\": " + r.missingScriptCount + ",");
            sb.AppendLine("      \"officialUiResolvedCount\": " + r.officialUiResolvedCount + ",");
            sb.AppendLine("      \"proxyResolvedCount\": " + r.proxyResolvedCount + ",");
            sb.AppendLine("      \"buttonValidationCount\": " + r.buttonValidationCount + ",");
            sb.AppendLine("      \"buttonInteractableCount\": " + r.buttonInteractableCount + ",");
            sb.AppendLine("      \"raycastReadyButtonCount\": " + r.raycastReadyButtonCount + ",");
            sb.AppendLine("      \"buttonWithoutTargetGraphicCount\": " + r.buttonWithoutTargetGraphicCount + ",");
            sb.AppendLine("      \"clickValidation\": \"" + Json(r.clickValidation) + "\"");
            sb.Append("    }");
            if (i + 1 < results.Count) sb.Append(",");
            sb.AppendLine();
        }
        sb.AppendLine("  ]");
        sb.AppendLine("}");
        File.WriteAllText(jsonPath, sb.ToString(), Encoding.UTF8);

        var lines = new List<string>();
        lines.Add("role,prefabAsset,instantiateSuccess,sceneRootActive,gameObjectCount,rectTransformCount,canvasCount,imageCount,rawImageCount,textCount,tmpCount,buttonCount,missingScriptCount,officialUiResolvedCount,proxyResolvedCount,buttonValidationCount,buttonInteractableCount,raycastReadyButtonCount,buttonWithoutTargetGraphicCount,clickValidation");
        foreach (var r in results)
        {
            lines.Add(string.Join(",", new[] { Csv(r.role), Csv(r.prefabAsset), Csv(Bool(r.instantiateSuccess)), Csv(Bool(r.sceneRootActive)), Csv(r.gameObjectCount.ToString()), Csv(r.rectTransformCount.ToString()), Csv(r.canvasCount.ToString()), Csv(r.imageCount.ToString()), Csv(r.rawImageCount.ToString()), Csv(r.textCount.ToString()), Csv(r.tmpCount.ToString()), Csv(r.buttonCount.ToString()), Csv(r.missingScriptCount.ToString()), Csv(r.officialUiResolvedCount.ToString()), Csv(r.proxyResolvedCount.ToString()), Csv(r.buttonValidationCount.ToString()), Csv(r.buttonInteractableCount.ToString()), Csv(r.raycastReadyButtonCount.ToString()), Csv(r.buttonWithoutTargetGraphicCount.ToString()), Csv(r.clickValidation) }));
        }
        File.WriteAllLines(csvPath, lines, Encoding.UTF8);
    }

    private static string ProjectPath(string assetPath) { return Path.Combine(Application.dataPath, "..", assetPath); }
    private static int Count(List<BattleUITypeProbeResult> results, Func<BattleUITypeProbeResult, bool> p) { int c = 0; foreach (var r in results) if (p(r)) c++; return c; }
    private static int Sum(List<BattleUITypeProbeResult> results, Func<BattleUITypeProbeResult, int> p) { int c = 0; foreach (var r in results) c += p(r); return c; }
    private static string Short(string value) { if (string.IsNullOrEmpty(value)) return ""; value = value.Replace("\r", " ").Replace("\n", " "); return value.Length > 180 ? value.Substring(0, 180) : value; }
    private static string SafeName(string value) { return string.IsNullOrEmpty(value) ? "unknown" : value.Replace(" ", "_").Replace(".", "_").Replace("/", "_").Replace("\\", "_"); }
    private static string Csv(string value) { value = value ?? ""; return "\"" + value.Replace("\"", "\"\"") + "\""; }
    private static string Json(string value) { return (value ?? "").Replace("\\", "\\\\").Replace("\"", "\\\"").Replace("\r", " ").Replace("\n", " "); }
    private static string Bool(bool value) { return value ? "true" : "false"; }
}

public sealed class BattleUITypeProbeAttachment
{
    public string id;
    public int order;
    public string role;
    public string attachMode;
    public string bundle;
    public string absolutePath;
    public string prefabAsset;
}

public sealed class BattleUITypeProbeResult
{
    public string role;
    public string prefabAsset;
    public bool instantiateSuccess;
    public bool sceneRootActive;
    public string failReason = "";
    public int gameObjectCount;
    public int rectTransformCount;
    public int canvasCount;
    public int canvasScalerCount;
    public int graphicRaycasterCount;
    public int imageCount;
    public int rawImageCount;
    public int textCount;
    public int tmpCount;
    public int buttonCount;
    public int buttonValidationCount;
    public int buttonInteractableCount;
    public int raycastReadyButtonCount;
    public int buttonWithoutTargetGraphicCount;
    public int missingScriptCount;
    public int officialUiResolvedCount;
    public int proxyResolvedCount;
    public string clickValidation = "deferred:no_resolved_Button_component";
    private readonly Dictionary<string, int> typeCounts = new Dictionary<string, int>();

    public BattleUITypeProbeResult(BattleUITypeProbeAttachment attachment)
    {
        role = attachment.role;
        prefabAsset = attachment.prefabAsset;
    }

    public void AddType(string typeName)
    {
        if (!typeCounts.ContainsKey(typeName)) typeCounts[typeName] = 0;
        typeCounts[typeName]++;
    }
}
