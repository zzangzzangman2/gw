using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;

public static class BattleSkillEffectAttachEditor
{
    private const string FlowManifestPath = "Assets/RestoreData/battle/BATTLE_RUNTIME_FLOW_MANIFEST.json";
    private const string AttachManifestPath = "Assets/RestoreData/battle/BATTLE_FLOW_SKILL_EFFECT_ATTACH_MANIFEST.json";
    private const string ResultJsonPath = "Assets/RestoreData/battle/BATTLE_FLOW_SKILL_EFFECT_ATTACH_RESULT.json";
    private const string ScenePath = "Assets/Scenes/BattleRuntimeFlowSkillEffectAttach.unity";

    [MenuItem("GirlsWar/Battle/Attach Skill Effects To Flow Scene")]
    public static void Build()
    {
        string manifestFullPath = ProjectPath(AttachManifestPath);
        if (!File.Exists(manifestFullPath))
        {
            Debug.LogError("Missing skill effect attach manifest: " + manifestFullPath);
            return;
        }

        string json = File.ReadAllText(manifestFullPath);
        var attachments = ReadAttachments(json);
        var scene = EditorSceneManager.NewScene(NewSceneSetup.EmptyScene, NewSceneMode.Single);

        var flowRoot = new GameObject("BattleRuntimeFlowWithSkillEffectsRoot");
        var loader = flowRoot.AddComponent<BattleRuntimeFlowLoader>();
        loader.flowManifestPath = FlowManifestPath;
        loader.loadOnStart = false;

        var cameraObject = new GameObject("SkillEffectAttachCamera");
        var camera = cameraObject.AddComponent<Camera>();
        camera.orthographic = true;
        camera.orthographicSize = 6.2f;
        camera.clearFlags = CameraClearFlags.SolidColor;
        camera.backgroundColor = new Color(0.042f, 0.046f, 0.052f, 1f);
        cameraObject.transform.position = new Vector3(0.15f, 0f, -10f);

        loader.BuildPreviewInCurrentScene();

        var effectRoot = new GameObject("OriginalSkillEffectEvidenceRoot");
        effectRoot.transform.SetParent(flowRoot.transform);
        var loadedBundles = new Dictionary<string, AssetBundle>();
        var results = new List<SkillEffectAttachResult>();
        foreach (var attachment in attachments)
        {
            results.Add(AttachSkillEffect(effectRoot.transform, attachment, loadedBundles));
        }

        WriteResult(ProjectPath(ResultJsonPath), results, loadedBundles.Count);
        foreach (var pair in loadedBundles)
        {
            if (pair.Value != null) pair.Value.Unload(false);
        }

        EditorSceneManager.SaveScene(scene, ScenePath);
        AssetDatabase.Refresh();
        int success = Count(results, r => r.instantiateSuccess);
        int fail = results.Count - success;
        Debug.Log("BattleSkillEffectAttach generated. attachments=" + results.Count + ", success=" + success + ", fail=" + fail + ", bundles=" + loadedBundles.Count);
    }

    private static SkillEffectAttachResult AttachSkillEffect(Transform root, SkillEffectAttachment attachment, Dictionary<string, AssetBundle> loadedBundles)
    {
        var result = new SkillEffectAttachResult(attachment);
        if (!File.Exists(attachment.absolutePath))
        {
            result.failReason = "bundle_file_not_found";
            CreateMarker(root, attachment, Color.red, result.failReason);
            return result;
        }

        AssetBundle bundle = null;
        if (!loadedBundles.TryGetValue(attachment.absolutePath, out bundle))
        {
            try
            {
                bundle = AssetBundle.LoadFromFile(attachment.absolutePath);
            }
            catch (Exception ex)
            {
                result.failReason = "LoadFromFile_exception:" + Short(ex.Message);
                CreateMarker(root, attachment, Color.red, result.failReason);
                return result;
            }
            if (bundle == null)
            {
                result.failReason = "LoadFromFile_returned_null";
                CreateMarker(root, attachment, Color.red, result.failReason);
                return result;
            }
            loadedBundles[attachment.absolutePath] = bundle;
        }

        GameObject prefab = null;
        try
        {
            prefab = bundle.LoadAsset<GameObject>(attachment.prefabAsset);
        }
        catch (Exception ex)
        {
            result.failReason = "LoadAsset_exception:" + Short(ex.Message);
            CreateMarker(root, attachment, Color.yellow, result.failReason);
            return result;
        }
        if (prefab == null)
        {
            result.failReason = "prefab_asset_not_found";
            CreateMarker(root, attachment, Color.yellow, result.failReason);
            return result;
        }

        try
        {
            var instance = (GameObject)GameObject.Instantiate(prefab, new Vector3(attachment.x, attachment.y, -0.35f), Quaternion.identity, root);
            instance.name = "AttachedSkillEffect_" + attachment.side + "_" + attachment.heroDid + "_" + attachment.skillId;
            instance.transform.localScale = Vector3.one * attachment.scale;
            result.instantiateSuccess = true;
            result.instantiatedName = instance.name;
            AddLabel(instance.transform, "skill " + attachment.skillId + "\n" + attachment.side + ":" + attachment.heroDid + "\n" + attachment.prefabAsset, new Vector3(0f, -0.72f, -0.2f), 0.075f);
        }
        catch (Exception ex)
        {
            result.failReason = "Instantiate_exception:" + Short(ex.Message);
            CreateMarker(root, attachment, Color.yellow, result.failReason);
        }
        return result;
    }

    private static void CreateMarker(Transform root, SkillEffectAttachment attachment, Color color, string reason)
    {
        var go = GameObject.CreatePrimitive(PrimitiveType.Cube);
        go.name = "SkillEffectAttachMissing_" + attachment.skillId;
        go.transform.SetParent(root);
        go.transform.position = new Vector3(attachment.x, attachment.y, -0.35f);
        go.transform.localScale = new Vector3(0.55f, 0.36f, 0.08f);
        var renderer = go.GetComponent<Renderer>();
        var material = new Material(Shader.Find("Standard"));
        material.color = color;
        renderer.sharedMaterial = material;
        AddLabel(go.transform, "skill " + attachment.skillId + "\n" + reason, new Vector3(0f, -0.45f, -0.2f), 0.075f);
    }

    private static void AddLabel(Transform parent, string text, Vector3 localPosition, float size)
    {
        var label = new GameObject("SkillEffectAttachLabel");
        label.transform.SetParent(parent);
        label.transform.localPosition = localPosition;
        var mesh = label.AddComponent<TextMesh>();
        mesh.text = text;
        mesh.fontSize = 34;
        mesh.characterSize = size;
        mesh.anchor = TextAnchor.MiddleCenter;
        mesh.alignment = TextAlignment.Center;
        mesh.color = Color.white;
    }

    private static List<SkillEffectAttachment> ReadAttachments(string json)
    {
        var list = new List<SkillEffectAttachment>();
        foreach (string item in ExtractObjectBlocks(ExtractArrayBlock(json, "\"attachments\"")))
        {
            list.Add(new SkillEffectAttachment
            {
                skillId = ReadValue(item, "skillId"),
                side = ReadValue(item, "side"),
                heroDid = ReadValue(item, "heroDid"),
                heroId = ReadValue(item, "heroId"),
                wave = ReadValue(item, "wave"),
                slot = ReadValue(item, "slot"),
                bundle = ReadValue(item, "bundle"),
                absolutePath = ReadValue(item, "absolutePath"),
                prefabAsset = ReadValue(item, "prefabAsset"),
                x = ReadFloat(item, "x"),
                y = ReadFloat(item, "y"),
                scale = ReadFloat(item, "scale", 0.32f)
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
                if (depth == 0 && start >= 0)
                {
                    objects.Add(arrayBlock.Substring(start, i - start + 1));
                    start = -1;
                }
            }
        }
        return objects;
    }

    private static string ReadValue(string json, string key)
    {
        var stringMatch = Regex.Match(json, "\"" + Regex.Escape(key) + "\"\\s*:\\s*\"((?:\\\\.|[^\"])*)\"");
        if (stringMatch.Success) return JsonUnescape(stringMatch.Groups[1].Value);
        var numberMatch = Regex.Match(json, "\"" + Regex.Escape(key) + "\"\\s*:\\s*(-?\\d+(?:\\.\\d+)?)");
        if (numberMatch.Success) return numberMatch.Groups[1].Value;
        return "";
    }

    private static float ReadFloat(string json, string key, float fallback = 0f)
    {
        var match = Regex.Match(json, "\"" + Regex.Escape(key) + "\"\\s*:\\s*(-?\\d+(?:\\.\\d+)?)");
        return match.Success ? float.Parse(match.Groups[1].Value, System.Globalization.CultureInfo.InvariantCulture) : fallback;
    }

    private static void WriteResult(string path, List<SkillEffectAttachResult> results, int loadedBundles)
    {
        var sb = new StringBuilder();
        int success = Count(results, r => r.instantiateSuccess);
        sb.AppendLine("{");
        sb.AppendLine("  \"status\": \"skill_effect_attach_complete\",");
        sb.AppendLine("  \"scene\": \"Assets/Scenes/BattleRuntimeFlowSkillEffectAttach.unity\",");
        sb.AppendLine("  \"summary\": {");
        sb.AppendLine("    \"attachments\": " + results.Count + ",");
        sb.AppendLine("    \"instantiateSuccess\": " + success + ",");
        sb.AppendLine("    \"instantiateFail\": " + (results.Count - success) + ",");
        sb.AppendLine("    \"loadedBundles\": " + loadedBundles);
        sb.AppendLine("  },");
        sb.AppendLine("  \"attachments\": [");
        for (int i = 0; i < results.Count; i++)
        {
            var r = results[i];
            sb.AppendLine("    {\"skillId\":\"" + Json(r.skillId) + "\",\"side\":\"" + Json(r.side) + "\",\"heroDid\":\"" + Json(r.heroDid) + "\",\"bundle\":\"" + Json(r.bundle) + "\",\"prefabAsset\":\"" + Json(r.prefabAsset) + "\",\"instantiateSuccess\":" + Bool(r.instantiateSuccess) + ",\"instantiatedName\":\"" + Json(r.instantiatedName) + "\",\"failReason\":\"" + Json(r.failReason) + "\"}" + (i + 1 < results.Count ? "," : ""));
        }
        sb.AppendLine("  ]");
        sb.AppendLine("}");
        File.WriteAllText(path, sb.ToString(), Encoding.UTF8);
    }

    private static int Count(List<SkillEffectAttachResult> results, Func<SkillEffectAttachResult, bool> predicate)
    {
        int count = 0;
        foreach (var r in results) if (predicate(r)) count++;
        return count;
    }

    private static string ProjectPath(string assetPath)
    {
        return Path.Combine(Application.dataPath, "..", assetPath);
    }

    private static string JsonUnescape(string value)
    {
        return value.Replace("\\\\", "\\").Replace("\\\"", "\"").Replace("\\n", "\n").Replace("\\r", "\r");
    }

    private static string Json(string value)
    {
        return (value ?? "").Replace("\\", "\\\\").Replace("\"", "\\\"").Replace("\r", " ").Replace("\n", " ");
    }

    private static string Short(string value)
    {
        if (string.IsNullOrEmpty(value)) return "";
        value = value.Replace("\r", " ").Replace("\n", " ");
        return value.Length > 180 ? value.Substring(0, 180) : value;
    }

    private static string Bool(bool value)
    {
        return value ? "true" : "false";
    }
}

public sealed class SkillEffectAttachment
{
    public string skillId;
    public string side;
    public string heroDid;
    public string heroId;
    public string wave;
    public string slot;
    public string bundle;
    public string absolutePath;
    public string prefabAsset;
    public float x;
    public float y;
    public float scale;
}

public sealed class SkillEffectAttachResult
{
    public string skillId;
    public string side;
    public string heroDid;
    public string bundle;
    public string prefabAsset;
    public bool instantiateSuccess;
    public string instantiatedName = "";
    public string failReason = "";

    public SkillEffectAttachResult(SkillEffectAttachment source)
    {
        skillId = source.skillId;
        side = source.side;
        heroDid = source.heroDid;
        bundle = source.bundle;
        prefabAsset = source.prefabAsset;
    }
}
