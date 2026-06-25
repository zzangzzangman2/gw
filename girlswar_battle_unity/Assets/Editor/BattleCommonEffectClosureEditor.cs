using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;

public static class BattleCommonEffectClosureEditor
{
    private const string FlowManifestPath = "Assets/RestoreData/battle/BATTLE_RUNTIME_FLOW_MANIFEST.json";
    private const string ClosurePath = "Assets/RestoreData/battle/BATTLE_COMMON_EFFECT_DEPENDENCY_CLOSURE.json";
    private const string PlayablePath = "Assets/RestoreData/battle/BATTLE_SKILL_EFFECT_PLAYABLE_MARKER_MANIFEST.json";
    private const string ResultPath = "Assets/RestoreData/battle/BATTLE_COMMON_EFFECT_DEPENDENCY_CLOSURE_UNITY_RESULT.json";
    private const string ScenePath = "Assets/Scenes/BattleRuntimeFlowSkillEffectPlayableMarkers.unity";

    [MenuItem("GirlsWar/Battle/Close Common Effect Dependencies")]
    public static void Build()
    {
        string closureJson = File.ReadAllText(ProjectPath(ClosurePath));
        string playableJson = File.ReadAllText(ProjectPath(PlayablePath));
        var commonTargets = ReadCommonTargets(closureJson);
        var playableMarkers = ReadPlayableMarkers(playableJson);

        var scene = EditorSceneManager.NewScene(NewSceneSetup.EmptyScene, NewSceneMode.Single);
        var root = new GameObject("BattleRuntimeFlowSkillEffectPlayableMarkersRoot");
        var loader = root.AddComponent<BattleRuntimeFlowLoader>();
        loader.flowManifestPath = FlowManifestPath;
        loader.loadOnStart = false;

        var cameraObject = new GameObject("CommonEffectClosureCamera");
        var camera = cameraObject.AddComponent<Camera>();
        camera.orthographic = true;
        camera.orthographicSize = 6.4f;
        camera.clearFlags = CameraClearFlags.SolidColor;
        camera.backgroundColor = new Color(0.04f, 0.045f, 0.052f, 1f);
        cameraObject.transform.position = new Vector3(0.15f, 0f, -10f);

        loader.BuildPreviewInCurrentScene();

        var markerRoot = new GameObject("PlayableAndCommonEffectEvidenceRoot");
        markerRoot.transform.SetParent(root.transform);
        var commonResults = new List<CommonClosureResult>();
        var playableResults = new List<PlayableMarkerResult>();
        var bundleCache = new Dictionary<string, AssetBundle>();

        for (int i = 0; i < commonTargets.Count; i++)
        {
            commonResults.Add(ProbeCommonDependency(markerRoot.transform, commonTargets[i], bundleCache, i));
        }
        for (int i = 0; i < playableMarkers.Count; i++)
        {
            playableResults.Add(ProbePlayableMarker(markerRoot.transform, playableMarkers[i], bundleCache, i));
        }

        WriteResult(ProjectPath(ResultPath), commonResults, playableResults);
        foreach (var pair in bundleCache)
        {
            if (pair.Value != null) pair.Value.Unload(false);
        }

        EditorSceneManager.SaveScene(scene, ScenePath);
        AssetDatabase.Refresh();
        int commonSuccess = Count(commonResults, r => r.loadSuccess);
        int playableFound = Count(playableResults, r => r.playableFound);
        Debug.Log("BattleCommonEffectClosure generated. common=" + commonResults.Count + ", commonSuccess=" + commonSuccess + ", playableMarkers=" + playableResults.Count + ", playableFound=" + playableFound);
    }

    private static CommonClosureResult ProbeCommonDependency(Transform root, CommonClosureTarget target, Dictionary<string, AssetBundle> cache, int index)
    {
        var result = new CommonClosureResult(target);
        if (!File.Exists(target.absolutePath))
        {
            result.failReason = "aggregate_file_not_found";
            CreateMarker(root, "CommonMissing_" + target.dependencyName, new Vector3(-5.2f + index * 1.9f, 4.55f, -0.4f), Color.red, target.dependencyName + "\naggregate missing");
            return result;
        }

        AssetBundle bundle = GetBundle(target.absolutePath, cache, result);
        if (bundle == null)
        {
            CreateMarker(root, "CommonLoadFail_" + target.dependencyName, new Vector3(-5.2f + index * 1.9f, 4.55f, -0.4f), Color.red, target.dependencyName + "\n" + result.failReason);
            return result;
        }

        result.loadSuccess = true;
        string[] names = bundle.GetAllAssetNames();
        result.assetNameCount = names.Length;
        GameObject firstPrefab = null;
        string firstName = "";
        foreach (string name in names)
        {
            if (name.ToLowerInvariant().Contains(target.dependencyName.ToLowerInvariant()))
            {
                result.matchingAssetCount++;
                if (name.EndsWith(".prefab", StringComparison.OrdinalIgnoreCase))
                {
                    result.matchingPrefabCount++;
                    if (firstPrefab == null)
                    {
                        try
                        {
                            firstPrefab = bundle.LoadAsset<GameObject>(name);
                            firstName = name;
                        }
                        catch (Exception ex)
                        {
                            result.failReason = "common_LoadAsset_exception:" + Short(ex.Message);
                        }
                    }
                }
            }
        }

        Vector3 position = new Vector3(-5.2f + index * 1.9f, 4.55f, -0.4f);
        if (firstPrefab != null)
        {
            try
            {
                var instance = (GameObject)GameObject.Instantiate(firstPrefab, position, Quaternion.identity, root);
                instance.name = "CommonDependency_" + target.dependencyName;
                instance.transform.localScale = Vector3.one * 0.22f;
                result.instantiateSuccess = true;
                result.instantiatedAsset = firstName;
                AddLabel(instance.transform, target.dependencyName + "\n" + firstName, new Vector3(0f, -0.55f, -0.2f), 0.07f);
            }
            catch (Exception ex)
            {
                result.failReason = "common_Instantiate_exception:" + Short(ex.Message);
                CreateMarker(root, "CommonMarker_" + target.dependencyName, position, Color.yellow, target.dependencyName + "\nloaded, instantiate failed");
            }
        }
        else
        {
            result.markerAttached = true;
            CreateMarker(root, "CommonMarker_" + target.dependencyName, position, result.matchingAssetCount > 0 ? Color.green : Color.yellow, target.dependencyName + "\nassets " + result.matchingAssetCount + "\nprefabs " + result.matchingPrefabCount);
        }
        return result;
    }

    private static PlayableMarkerResult ProbePlayableMarker(Transform root, PlayableMarker marker, Dictionary<string, AssetBundle> cache, int index)
    {
        var result = new PlayableMarkerResult(marker);
        AssetBundle bundle = GetBundle(marker.absolutePath, cache, result);
        Vector3 position = new Vector3(marker.x, marker.y, -0.55f);
        if (bundle == null)
        {
            CreateMarker(root, "PlayableMissingBundle_" + marker.skillId, position, Color.red, "playable " + marker.skillId + "\n" + result.failReason);
            return result;
        }

        string expected = marker.expectedPlayableAsset.ToLowerInvariant();
        foreach (string name in bundle.GetAllAssetNames())
        {
            if (name.ToLowerInvariant() == expected)
            {
                result.playableFound = true;
                result.foundAsset = name;
                break;
            }
        }
        result.markerAttached = true;
        CreateMarker(root, "PlayableMarker_" + marker.skillId, position, result.playableFound ? Color.cyan : Color.yellow, "playable " + marker.skillId + "\n" + (result.playableFound ? marker.expectedPlayableAsset : "not found") + "\n" + marker.side + ":" + marker.heroDid);
        return result;
    }

    private static AssetBundle GetBundle(string absolutePath, Dictionary<string, AssetBundle> cache, IBundleProbeResult result)
    {
        if (cache.ContainsKey(absolutePath))
        {
            return cache[absolutePath];
        }
        if (!File.Exists(absolutePath))
        {
            result.failReason = "bundle_file_not_found";
            return null;
        }
        try
        {
            var bundle = AssetBundle.LoadFromFile(absolutePath);
            if (bundle == null)
            {
                result.failReason = "LoadFromFile_returned_null";
                return null;
            }
            cache[absolutePath] = bundle;
            return bundle;
        }
        catch (Exception ex)
        {
            result.failReason = "LoadFromFile_exception:" + Short(ex.Message);
            return null;
        }
    }

    private static void CreateMarker(Transform root, string name, Vector3 position, Color color, string label)
    {
        var go = GameObject.CreatePrimitive(PrimitiveType.Cube);
        go.name = name;
        go.transform.SetParent(root);
        go.transform.position = position;
        go.transform.localScale = new Vector3(0.45f, 0.25f, 0.08f);
        var renderer = go.GetComponent<Renderer>();
        var material = new Material(Shader.Find("Standard"));
        material.color = color;
        renderer.sharedMaterial = material;
        AddLabel(go.transform, label, new Vector3(0f, -0.34f, -0.2f), 0.055f);
    }

    private static void AddLabel(Transform parent, string text, Vector3 localPosition, float size)
    {
        var label = new GameObject("ClosureLabel");
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

    private static List<CommonClosureTarget> ReadCommonTargets(string json)
    {
        var list = new List<CommonClosureTarget>();
        foreach (string item in ExtractObjectBlocks(ExtractArrayBlock(json, "\"commonDependencyTargets\"")))
        {
            list.Add(new CommonClosureTarget
            {
                dependencyName = ReadValue(item, "dependencyName"),
                failedBundle = ReadValue(item, "failedBundle"),
                aggregateBundle = ReadValue(item, "aggregateBundle"),
                absolutePath = ReadValue(item, "absolutePath")
            });
        }
        return list;
    }

    private static List<PlayableMarker> ReadPlayableMarkers(string json)
    {
        var list = new List<PlayableMarker>();
        foreach (string item in ExtractObjectBlocks(ExtractArrayBlock(json, "\"markers\"")))
        {
            list.Add(new PlayableMarker
            {
                skillId = ReadValue(item, "skillId"),
                side = ReadValue(item, "side"),
                heroDid = ReadValue(item, "heroDid"),
                bundle = ReadValue(item, "bundle"),
                absolutePath = ReadValue(item, "absolutePath"),
                prefabAsset = ReadValue(item, "prefabAsset"),
                expectedPlayableAsset = ReadValue(item, "expectedPlayableAsset"),
                x = ReadFloat(item, "x"),
                y = ReadFloat(item, "y"),
                scale = ReadFloat(item, "scale", 0.14f)
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

    private static void WriteResult(string path, List<CommonClosureResult> commonResults, List<PlayableMarkerResult> playableResults)
    {
        var sb = new StringBuilder();
        sb.AppendLine("{");
        sb.AppendLine("  \"status\": \"common_effect_dependency_closure_unity_complete\",");
        sb.AppendLine("  \"scene\": \"Assets/Scenes/BattleRuntimeFlowSkillEffectPlayableMarkers.unity\",");
        sb.AppendLine("  \"summary\": {");
        sb.AppendLine("    \"commonTargets\": " + commonResults.Count + ",");
        sb.AppendLine("    \"commonLoadSuccess\": " + Count(commonResults, r => r.loadSuccess) + ",");
        sb.AppendLine("    \"commonInstantiateSuccess\": " + Count(commonResults, r => r.instantiateSuccess) + ",");
        sb.AppendLine("    \"playableMarkers\": " + playableResults.Count + ",");
        sb.AppendLine("    \"playableFound\": " + Count(playableResults, r => r.playableFound));
        sb.AppendLine("  },");
        sb.AppendLine("  \"commonDependencyResults\": [");
        for (int i = 0; i < commonResults.Count; i++)
        {
            var r = commonResults[i];
            sb.AppendLine("    {\"dependencyName\":\"" + Json(r.dependencyName) + "\",\"failedBundle\":\"" + Json(r.failedBundle) + "\",\"aggregateBundle\":\"" + Json(r.aggregateBundle) + "\",\"absolutePath\":\"" + Json(r.absolutePath) + "\",\"loadSuccess\":" + Bool(r.loadSuccess) + ",\"assetNameCount\":" + r.assetNameCount + ",\"matchingAssetCount\":" + r.matchingAssetCount + ",\"matchingPrefabCount\":" + r.matchingPrefabCount + ",\"instantiateSuccess\":" + Bool(r.instantiateSuccess) + ",\"markerAttached\":" + Bool(r.markerAttached) + ",\"instantiatedAsset\":\"" + Json(r.instantiatedAsset) + "\",\"failReason\":\"" + Json(r.failReason) + "\"}" + (i + 1 < commonResults.Count ? "," : ""));
        }
        sb.AppendLine("  ],");
        sb.AppendLine("  \"playableMarkerResults\": [");
        for (int i = 0; i < playableResults.Count; i++)
        {
            var r = playableResults[i];
            sb.AppendLine("    {\"skillId\":\"" + Json(r.skillId) + "\",\"side\":\"" + Json(r.side) + "\",\"heroDid\":\"" + Json(r.heroDid) + "\",\"bundle\":\"" + Json(r.bundle) + "\",\"expectedPlayableAsset\":\"" + Json(r.expectedPlayableAsset) + "\",\"playableFound\":" + Bool(r.playableFound) + ",\"foundAsset\":\"" + Json(r.foundAsset) + "\",\"markerAttached\":" + Bool(r.markerAttached) + ",\"failReason\":\"" + Json(r.failReason) + "\"}" + (i + 1 < playableResults.Count ? "," : ""));
        }
        sb.AppendLine("  ]");
        sb.AppendLine("}");
        File.WriteAllText(path, sb.ToString(), Encoding.UTF8);
    }

    private static int Count<T>(List<T> results, Func<T, bool> predicate)
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

public interface IBundleProbeResult
{
    string failReason { get; set; }
}

public sealed class CommonClosureTarget
{
    public string dependencyName;
    public string failedBundle;
    public string aggregateBundle;
    public string absolutePath;
}

public sealed class CommonClosureResult : IBundleProbeResult
{
    public string dependencyName;
    public string failedBundle;
    public string aggregateBundle;
    public string absolutePath;
    public bool loadSuccess;
    public int assetNameCount;
    public int matchingAssetCount;
    public int matchingPrefabCount;
    public bool instantiateSuccess;
    public bool markerAttached;
    public string instantiatedAsset = "";
    public string failReason { get; set; }

    public CommonClosureResult(CommonClosureTarget target)
    {
        dependencyName = target.dependencyName;
        failedBundle = target.failedBundle;
        aggregateBundle = target.aggregateBundle;
        absolutePath = target.absolutePath;
        failReason = "";
    }
}

public sealed class PlayableMarker
{
    public string skillId;
    public string side;
    public string heroDid;
    public string bundle;
    public string absolutePath;
    public string prefabAsset;
    public string expectedPlayableAsset;
    public float x;
    public float y;
    public float scale;
}

public sealed class PlayableMarkerResult : IBundleProbeResult
{
    public string skillId;
    public string side;
    public string heroDid;
    public string bundle;
    public string expectedPlayableAsset;
    public bool playableFound;
    public string foundAsset = "";
    public bool markerAttached;
    public string failReason { get; set; }

    public PlayableMarkerResult(PlayableMarker marker)
    {
        skillId = marker.skillId;
        side = marker.side;
        heroDid = marker.heroDid;
        bundle = marker.bundle;
        expectedPlayableAsset = marker.expectedPlayableAsset;
        failReason = "";
    }
}
