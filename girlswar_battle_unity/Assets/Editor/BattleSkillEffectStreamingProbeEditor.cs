using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text;

public static class BattleSkillEffectStreamingProbeEditor
{
    private const string TargetsPath = "Assets/RestoreData/battle/BATTLE_SKILL_EFFECT_STREAMING_TARGETS.csv";
    private const string ResultJsonPath = "Assets/RestoreData/battle/BATTLE_SKILL_EFFECT_STREAMING_UNITY_BUNDLE_PROBE.json";
    private const string ResultCsvPath = "Assets/RestoreData/battle/BATTLE_SKILL_EFFECT_STREAMING_UNITY_BUNDLE_PROBE.csv";
    private const string ScenePath = "Assets/Scenes/BattleSkillEffectStreamingProbe.unity";

    [MenuItem("GirlsWar/Battle/Probe Skill Effect Streaming")]
    public static void Build()
    {
        string targetFullPath = ProjectPath(TargetsPath);
        var targets = ReadTargets(targetFullPath);
        var scene = EditorSceneManager.NewScene(NewSceneSetup.EmptyScene, NewSceneMode.Single);
        var root = new GameObject("BattleSkillEffectStreamingProbeRoot");
        var marker = root.AddComponent<BattleSkillEffectStreamingProbeMarker>();
        marker.targetsCsv = TargetsPath;
        marker.resultJson = ResultJsonPath;
        marker.targetCount = targets.Count;

        var cameraObject = new GameObject("SkillEffectProbeCamera");
        var camera = cameraObject.AddComponent<Camera>();
        camera.orthographic = true;
        camera.orthographicSize = 7.2f;
        camera.backgroundColor = new Color(0.04f, 0.045f, 0.05f, 1f);
        camera.clearFlags = CameraClearFlags.SolidColor;
        cameraObject.transform.position = new Vector3(0f, 0f, -10f);

        var results = new List<SkillEffectProbeResult>();
        for (int i = 0; i < targets.Count; i++)
        {
            var result = Probe(targets[i], root.transform, i);
            results.Add(result);
        }

        marker.loadSuccessCount = Count(results, r => r.loadSuccess);
        marker.loadFailCount = results.Count - marker.loadSuccessCount;
        marker.instantiatedMarkerCount = Count(results, r => r.instantiateSuccess);
        marker.loadableEffectPrefabCount = Sum(results, r => r.loadableEffectPrefabCount);
        marker.matchingTimelinePrefabCount = Sum(results, r => r.matchingTimelinePrefabCount);

        WriteCsv(ProjectPath(ResultCsvPath), results);
        WriteJson(ProjectPath(ResultJsonPath), results, marker);
        EditorSceneManager.SaveScene(scene, ScenePath);
        AssetDatabase.Refresh();
        Debug.Log("BattleSkillEffectStreamingProbe generated. success=" + marker.loadSuccessCount + ", fail=" + marker.loadFailCount + ", instantiated=" + marker.instantiatedMarkerCount + ", prefabs=" + marker.loadableEffectPrefabCount + ", timelines=" + marker.matchingTimelinePrefabCount);
    }

    private static SkillEffectProbeResult Probe(SkillEffectProbeTarget target, Transform root, int index)
    {
        var result = new SkillEffectProbeResult(target);
        result.fileExists = File.Exists(target.absolutePath);
        if (result.fileExists)
        {
            result.size = new FileInfo(target.absolutePath).Length;
        }
        if (!result.fileExists)
        {
            result.failReason = "file_not_found";
            CreateMarker(root, "SkillEffectMissing_" + target.id, index, Color.red, target.bundle + "\nfile_not_found");
            return result;
        }

        AssetBundle bundle = null;
        try
        {
            bundle = AssetBundle.LoadFromFile(target.absolutePath);
            if (bundle == null)
            {
                result.failReason = "AssetBundle.LoadFromFile_returned_null";
                CreateMarker(root, "SkillEffectLoadNull_" + target.id, index, Color.red, target.bundle + "\nLoadFromFile null");
                return result;
            }

            result.loadSuccess = true;
            string[] names = bundle.GetAllAssetNames();
            result.assetNameCount = names.Length;
            result.assetNameSample = Sample(names, 12);
            var expectedIds = SplitSemi(target.expectedPrefabIds);
            var firstInstantiable = "";
            GameObject firstPrefab = null;

            foreach (string name in names)
            {
                UnityEngine.Object asset = null;
                try
                {
                    asset = bundle.LoadAsset<UnityEngine.Object>(name);
                }
                catch (Exception ex)
                {
                    result.dependencyMissing = true;
                    result.dependencyNotes += Short(ex.Message) + ";";
                    continue;
                }
                if (asset == null)
                {
                    continue;
                }
                string typeName = asset.GetType().Name;
                result.AddType(typeName, name);
                bool isPrefabName = name.EndsWith(".prefab", StringComparison.OrdinalIgnoreCase);
                bool matchesExpected = MatchesAny(name, expectedIds);
                if (isPrefabName && matchesExpected)
                {
                    result.matchingTimelinePrefabCount++;
                }
                if (asset is GameObject go && isPrefabName)
                {
                    result.loadableEffectPrefabCount++;
                    if (firstPrefab == null && (matchesExpected || firstInstantiable == ""))
                    {
                        firstPrefab = go;
                        firstInstantiable = name;
                    }
                }
            }

            if (firstPrefab != null)
            {
                try
                {
                    var instance = (GameObject)GameObject.Instantiate(firstPrefab, PositionFor(index), Quaternion.identity, root);
                    instance.name = "SkillEffectProbe_" + target.id;
                    instance.transform.localScale = Vector3.one * 0.55f;
                    result.instantiateSuccess = true;
                    result.instantiatedAsset = firstInstantiable;
                    AddLabel(instance.transform, target.bundle + "\n" + Short(firstInstantiable) + "\nskills " + target.skillIds, new Vector3(0f, -1.1f, -0.2f), 0.09f);
                }
                catch (Exception ex)
                {
                    result.failReason = "instantiate_failed:" + Short(ex.Message);
                    CreateMarker(root, "SkillEffectInstantiateFail_" + target.id, index, Color.yellow, target.bundle + "\n" + result.failReason);
                }
            }
            else
            {
                CreateMarker(root, "SkillEffectLoadedNoPrefab_" + target.id, index, Color.yellow, target.bundle + "\nloaded, no GameObject prefab");
            }
        }
        catch (Exception ex)
        {
            result.loadSuccess = false;
            result.failReason = "load_exception:" + Short(ex.Message);
            CreateMarker(root, "SkillEffectFail_" + target.id, index, Color.red, target.bundle + "\n" + result.failReason);
        }
        finally
        {
            if (bundle != null)
            {
                bundle.Unload(false);
            }
        }
        return result;
    }

    private static Vector3 PositionFor(int index)
    {
        float x = -5.2f + (index % 4) * 3.45f;
        float y = 4.0f - (index / 4) * 2.55f;
        return new Vector3(x, y, 0f);
    }

    private static void CreateMarker(Transform root, string name, int index, Color color, string label)
    {
        var go = GameObject.CreatePrimitive(PrimitiveType.Cube);
        go.name = name;
        go.transform.SetParent(root);
        go.transform.position = PositionFor(index);
        go.transform.localScale = new Vector3(1.35f, 0.82f, 0.12f);
        var renderer = go.GetComponent<Renderer>();
        var material = new Material(Shader.Find("Standard"));
        material.color = color;
        renderer.sharedMaterial = material;
        AddLabel(go.transform, label, new Vector3(0f, -0.8f, -0.2f), 0.09f);
    }

    private static void AddLabel(Transform parent, string text, Vector3 localPosition, float size)
    {
        var label = new GameObject("SkillEffectProbeLabel");
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

    private static List<SkillEffectProbeTarget> ReadTargets(string path)
    {
        var list = new List<SkillEffectProbeTarget>();
        if (!File.Exists(path))
        {
            return list;
        }
        var lines = File.ReadAllLines(path, Encoding.UTF8);
        for (int i = 1; i < lines.Length; i++)
        {
            if (string.IsNullOrWhiteSpace(lines[i])) continue;
            var parts = SplitCsvLine(lines[i]);
            if (parts.Count < 10) continue;
            list.Add(new SkillEffectProbeTarget
            {
                kind = parts[0],
                id = parts[1],
                label = parts[2],
                bundle = parts[3],
                absolutePath = parts[4],
                skillIds = parts[5],
                expectedPrefabIds = parts[6],
                expectedTimelineAssets = parts[7],
                bundleExistsAtPrep = parts[8],
                candidateSources = parts[9],
            });
        }
        return list;
    }

    private static List<string> SplitCsvLine(string line)
    {
        var result = new List<string>();
        var sb = new StringBuilder();
        bool quote = false;
        for (int i = 0; i < line.Length; i++)
        {
            char c = line[i];
            if (c == '"')
            {
                if (quote && i + 1 < line.Length && line[i + 1] == '"')
                {
                    sb.Append('"');
                    i++;
                }
                else
                {
                    quote = !quote;
                }
                continue;
            }
            if (c == ',' && !quote)
            {
                result.Add(sb.ToString());
                sb.Length = 0;
            }
            else
            {
                sb.Append(c);
            }
        }
        result.Add(sb.ToString());
        return result;
    }

    private static void WriteCsv(string path, List<SkillEffectProbeResult> results)
    {
        var lines = new List<string>();
        lines.Add("kind,id,label,bundle,absolutePath,skillIds,fileExists,size,loadSuccess,failReason,assetNameCount,assetNameSample,gameObjectCount,texture2DCount,spriteCount,materialCount,textAssetCount,animationClipCount,playableAssetCount,matchingTimelinePrefabCount,loadableEffectPrefabCount,instantiateSuccess,instantiatedAsset,dependencyMissing,dependencyNotes");
        foreach (var r in results)
        {
            lines.Add(string.Join(",", new[]
            {
                Csv(r.kind), Csv(r.id), Csv(r.label), Csv(r.bundle), Csv(r.absolutePath), Csv(r.skillIds), Csv(Bool(r.fileExists)), Csv(r.size.ToString()),
                Csv(Bool(r.loadSuccess)), Csv(r.failReason), Csv(r.assetNameCount.ToString()), Csv(r.assetNameSample), Csv(r.gameObjectCount.ToString()),
                Csv(r.texture2DCount.ToString()), Csv(r.spriteCount.ToString()), Csv(r.materialCount.ToString()), Csv(r.textAssetCount.ToString()),
                Csv(r.animationClipCount.ToString()), Csv(r.playableAssetCount.ToString()), Csv(r.matchingTimelinePrefabCount.ToString()),
                Csv(r.loadableEffectPrefabCount.ToString()), Csv(Bool(r.instantiateSuccess)), Csv(r.instantiatedAsset), Csv(Bool(r.dependencyMissing)), Csv(r.dependencyNotes)
            }));
        }
        File.WriteAllLines(path, lines, Encoding.UTF8);
    }

    private static void WriteJson(string path, List<SkillEffectProbeResult> results, BattleSkillEffectStreamingProbeMarker marker)
    {
        var sb = new StringBuilder();
        sb.AppendLine("{");
        sb.AppendLine("  \"status\": \"unity_skill_effect_probe_complete\",");
        sb.AppendLine("  \"scene\": \"Assets/Scenes/BattleSkillEffectStreamingProbe.unity\",");
        sb.AppendLine("  \"targetsCsv\": \"" + Json(TargetsPath) + "\",");
        sb.AppendLine("  \"summary\": {");
        sb.AppendLine("    \"targetCount\": " + marker.targetCount + ",");
        sb.AppendLine("    \"loadSuccess\": " + marker.loadSuccessCount + ",");
        sb.AppendLine("    \"loadFail\": " + marker.loadFailCount + ",");
        sb.AppendLine("    \"instantiatedMarkerCount\": " + marker.instantiatedMarkerCount + ",");
        sb.AppendLine("    \"loadableEffectPrefabCount\": " + marker.loadableEffectPrefabCount + ",");
        sb.AppendLine("    \"matchingTimelinePrefabCount\": " + marker.matchingTimelinePrefabCount);
        sb.AppendLine("  },");
        sb.AppendLine("  \"results\": [");
        for (int i = 0; i < results.Count; i++)
        {
            var r = results[i];
            sb.AppendLine("    {");
            sb.AppendLine("      \"kind\": \"" + Json(r.kind) + "\",");
            sb.AppendLine("      \"id\": \"" + Json(r.id) + "\",");
            sb.AppendLine("      \"label\": \"" + Json(r.label) + "\",");
            sb.AppendLine("      \"bundle\": \"" + Json(r.bundle) + "\",");
            sb.AppendLine("      \"absolutePath\": \"" + Json(r.absolutePath) + "\",");
            sb.AppendLine("      \"skillIds\": \"" + Json(r.skillIds) + "\",");
            sb.AppendLine("      \"expectedPrefabIds\": \"" + Json(r.expectedPrefabIds) + "\",");
            sb.AppendLine("      \"fileExists\": " + Bool(r.fileExists) + ",");
            sb.AppendLine("      \"size\": " + r.size + ",");
            sb.AppendLine("      \"loadSuccess\": " + Bool(r.loadSuccess) + ",");
            sb.AppendLine("      \"failReason\": \"" + Json(r.failReason) + "\",");
            sb.AppendLine("      \"assetNameCount\": " + r.assetNameCount + ",");
            sb.AppendLine("      \"assetNameSample\": \"" + Json(r.assetNameSample) + "\",");
            sb.AppendLine("      \"typeCounts\": {\"GameObject\": " + r.gameObjectCount + ", \"Texture2D\": " + r.texture2DCount + ", \"Sprite\": " + r.spriteCount + ", \"Material\": " + r.materialCount + ", \"TextAsset\": " + r.textAssetCount + ", \"AnimationClip\": " + r.animationClipCount + ", \"PlayableAsset\": " + r.playableAssetCount + "},");
            sb.AppendLine("      \"matchingTimelinePrefabCount\": " + r.matchingTimelinePrefabCount + ",");
            sb.AppendLine("      \"loadableEffectPrefabCount\": " + r.loadableEffectPrefabCount + ",");
            sb.AppendLine("      \"instantiateSuccess\": " + Bool(r.instantiateSuccess) + ",");
            sb.AppendLine("      \"instantiatedAsset\": \"" + Json(r.instantiatedAsset) + "\",");
            sb.AppendLine("      \"dependencyMissing\": " + Bool(r.dependencyMissing) + ",");
            sb.AppendLine("      \"dependencyNotes\": \"" + Json(r.dependencyNotes) + "\"");
            sb.Append("    }");
            if (i + 1 < results.Count) sb.Append(",");
            sb.AppendLine();
        }
        sb.AppendLine("  ]");
        sb.AppendLine("}");
        File.WriteAllText(path, sb.ToString(), Encoding.UTF8);
    }

    private static List<string> SplitSemi(string text)
    {
        var list = new List<string>();
        foreach (string part in (text ?? "").Split(';'))
        {
            if (!string.IsNullOrWhiteSpace(part)) list.Add(part.Trim().ToLowerInvariant());
        }
        return list;
    }

    private static bool MatchesAny(string value, List<string> needles)
    {
        string lower = (value ?? "").ToLowerInvariant();
        foreach (string needle in needles)
        {
            if (!string.IsNullOrEmpty(needle) && lower.Contains(needle)) return true;
        }
        return false;
    }

    private static int Count(List<SkillEffectProbeResult> results, Func<SkillEffectProbeResult, bool> predicate)
    {
        int count = 0;
        foreach (var r in results) if (predicate(r)) count++;
        return count;
    }

    private static int Sum(List<SkillEffectProbeResult> results, Func<SkillEffectProbeResult, int> selector)
    {
        int count = 0;
        foreach (var r in results) count += selector(r);
        return count;
    }

    private static string Sample(string[] values, int max)
    {
        var items = new List<string>();
        for (int i = 0; i < values.Length && i < max; i++) items.Add(values[i]);
        return string.Join(";", items);
    }

    private static string Short(string value)
    {
        if (string.IsNullOrEmpty(value)) return "";
        value = value.Replace("\r", " ").Replace("\n", " ");
        return value.Length > 180 ? value.Substring(0, 180) : value;
    }

    private static string ProjectPath(string assetPath)
    {
        return Path.Combine(Application.dataPath, "..", assetPath);
    }

    private static string Csv(string value)
    {
        value = value ?? "";
        return "\"" + value.Replace("\"", "\"\"") + "\"";
    }

    private static string Json(string value)
    {
        return (value ?? "").Replace("\\", "\\\\").Replace("\"", "\\\"").Replace("\r", " ").Replace("\n", " ");
    }

    private static string Bool(bool value)
    {
        return value ? "true" : "false";
    }
}

public sealed class SkillEffectProbeTarget
{
    public string kind;
    public string id;
    public string label;
    public string bundle;
    public string absolutePath;
    public string skillIds;
    public string expectedPrefabIds;
    public string expectedTimelineAssets;
    public string bundleExistsAtPrep;
    public string candidateSources;
}

public sealed class SkillEffectProbeResult
{
    public string kind;
    public string id;
    public string label;
    public string bundle;
    public string absolutePath;
    public string skillIds;
    public string expectedPrefabIds;
    public bool fileExists;
    public long size;
    public bool loadSuccess;
    public string failReason = "";
    public int assetNameCount;
    public string assetNameSample = "";
    public int gameObjectCount;
    public int texture2DCount;
    public int spriteCount;
    public int materialCount;
    public int textAssetCount;
    public int animationClipCount;
    public int playableAssetCount;
    public int matchingTimelinePrefabCount;
    public int loadableEffectPrefabCount;
    public bool instantiateSuccess;
    public string instantiatedAsset = "";
    public bool dependencyMissing;
    public string dependencyNotes = "";

    public SkillEffectProbeResult(SkillEffectProbeTarget target)
    {
        kind = target.kind;
        id = target.id;
        label = target.label;
        bundle = target.bundle;
        absolutePath = target.absolutePath;
        skillIds = target.skillIds;
        expectedPrefabIds = target.expectedPrefabIds;
    }

    public void AddType(string typeName, string assetName)
    {
        if (typeName == "GameObject") gameObjectCount++;
        if (typeName == "Texture2D") texture2DCount++;
        if (typeName == "Sprite") spriteCount++;
        if (typeName == "Material") materialCount++;
        if (typeName == "TextAsset") textAssetCount++;
        if (typeName == "AnimationClip") animationClipCount++;
        if (typeName.Contains("Playable")) playableAssetCount++;
    }
}

public sealed class BattleSkillEffectStreamingProbeMarker : MonoBehaviour
{
    public string targetsCsv;
    public string resultJson;
    public int targetCount;
    public int loadSuccessCount;
    public int loadFailCount;
    public int instantiatedMarkerCount;
    public int loadableEffectPrefabCount;
    public int matchingTimelinePrefabCount;
}
