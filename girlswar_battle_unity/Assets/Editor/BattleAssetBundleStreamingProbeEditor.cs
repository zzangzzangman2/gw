using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text;

public static class BattleAssetBundleStreamingProbeEditor
{
    private const string TargetsPath = "Assets/RestoreData/battle/BATTLE_ASSETBUNDLE_STREAMING_TARGETS.csv";
    private const string ResultJsonPath = "Assets/RestoreData/battle/BATTLE_ASSETBUNDLE_STREAMING_PROBE.json";
    private const string ResultCsvPath = "Assets/RestoreData/battle/BATTLE_ASSETBUNDLE_STREAMING_PROBE.csv";
    private const string ScenePath = "Assets/Scenes/BattleAssetBundleStreamingProbe.unity";

    [MenuItem("GirlsWar/Battle/Probe AssetBundle Streaming")]
    public static void Build()
    {
        string targetFullPath = Path.Combine(Application.dataPath, "..", TargetsPath);
        var targets = ReadTargets(targetFullPath);
        var scene = EditorSceneManager.NewScene(NewSceneSetup.EmptyScene, NewSceneMode.Single);
        var root = new GameObject("BattleAssetBundleStreamingProbeRoot");
        var marker = root.AddComponent<BattleAssetBundleStreamingProbeMarker>();
        marker.targetsCsv = TargetsPath;
        marker.resultJson = ResultJsonPath;
        marker.targetCount = targets.Count;

        var cameraObject = new GameObject("StreamingProbeCamera");
        var camera = cameraObject.AddComponent<Camera>();
        camera.orthographic = true;
        camera.orthographicSize = 5.6f;
        camera.backgroundColor = new Color(0.045f, 0.048f, 0.052f, 1f);
        camera.clearFlags = CameraClearFlags.SolidColor;
        cameraObject.transform.position = new Vector3(0f, 0f, -10f);

        var results = new List<ProbeResult>();
        int index = 0;
        foreach (var target in targets)
        {
            var result = Probe(target, root.transform, index);
            results.Add(result);
            index++;
        }

        marker.loadSuccessCount = Count(results, r => r.loadSuccess);
        marker.loadFailCount = results.Count - marker.loadSuccessCount;
        marker.instantiateSuccessCount = Count(results, r => r.instantiateSuccess);
        marker.textureFallbackCount = Count(results, r => r.textureFallback);

        WriteCsv(Path.Combine(Application.dataPath, "..", ResultCsvPath), results);
        WriteJson(Path.Combine(Application.dataPath, "..", ResultJsonPath), results, marker);
        EditorSceneManager.SaveScene(scene, ScenePath);
        AssetDatabase.Refresh();
        Debug.Log("BattleAssetBundleStreamingProbe generated. success=" + marker.loadSuccessCount + ", fail=" + marker.loadFailCount + ", instantiate=" + marker.instantiateSuccessCount + ", textureFallback=" + marker.textureFallbackCount);
    }

    private static ProbeResult Probe(ProbeTarget target, Transform root, int index)
    {
        var result = new ProbeResult(target);
        result.fileExists = File.Exists(target.absolutePath);
        if (result.fileExists)
        {
            result.size = new FileInfo(target.absolutePath).Length;
        }
        if (!result.fileExists)
        {
            result.failReason = "file_not_found";
            CreateMarker(root, "Fail_" + target.kind + "_" + target.id, index, Color.red, target.label + "\\nfile_not_found");
            return result;
        }

        AssetBundle bundle = null;
        try
        {
            bundle = AssetBundle.LoadFromFile(target.absolutePath);
            if (bundle == null)
            {
                result.failReason = "AssetBundle.LoadFromFile_returned_null";
                CreateMarker(root, "Fail_" + target.kind + "_" + target.id, index, Color.red, target.label + "\\nLoadFromFile null");
                return result;
            }
            result.loadSuccess = true;
            string[] names = bundle.GetAllAssetNames();
            result.assetNameCount = names.Length;
            result.assetNameSample = Sample(names, 8);
            GameObject firstPrefab = null;
            Texture2D firstTexture = null;
            Sprite firstSprite = null;

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
                if (asset is GameObject go && firstPrefab == null)
                {
                    firstPrefab = go;
                }
                if (asset is Texture2D tex && firstTexture == null)
                {
                    firstTexture = tex;
                }
                if (asset is Sprite sprite && firstSprite == null)
                {
                    firstSprite = sprite;
                }
            }

            Vector3 position = PositionFor(index);
            if (firstPrefab != null)
            {
                try
                {
                    var instance = (GameObject)GameObject.Instantiate(firstPrefab, position, Quaternion.identity, root);
                    instance.name = "Instantiated_" + target.kind + "_" + target.id;
                    instance.transform.localScale = Vector3.one * (target.kind == "map" ? 0.35f : 0.8f);
                    result.instantiateSuccess = true;
                    result.instantiatedAsset = firstPrefab.name;
                    AddLabel(instance.transform, target.label + "\\ninstantiated " + firstPrefab.name, new Vector3(0f, -1.05f, -0.2f), 0.12f);
                }
                catch (Exception ex)
                {
                    result.instantiateSuccess = false;
                    result.failReason = "instantiate_failed:" + Short(ex.Message);
                }
            }

            if (!result.instantiateSuccess)
            {
                if (firstTexture != null)
                {
                    CreateTextureQuad(root, "TextureFallback_" + target.kind + "_" + target.id, firstTexture, position, target.kind == "map" ? new Vector3(3.4f, 1.4f, 1f) : new Vector3(1f, 1f, 1f), target.label + "\\nTexture2D fallback " + firstTexture.name);
                    result.textureFallback = true;
                    result.textureFallbackAsset = firstTexture.name;
                }
                else if (firstSprite != null && firstSprite.texture != null)
                {
                    CreateTextureQuad(root, "SpriteFallback_" + target.kind + "_" + target.id, firstSprite.texture, position, target.kind == "map" ? new Vector3(3.4f, 1.4f, 1f) : new Vector3(1f, 1f, 1f), target.label + "\\nSprite fallback " + firstSprite.name);
                    result.textureFallback = true;
                    result.textureFallbackAsset = firstSprite.name;
                }
                else
                {
                    CreateMarker(root, "LoadedNoVisual_" + target.kind + "_" + target.id, index, Color.yellow, target.label + "\\nloaded, no visual fallback");
                }
            }
        }
        catch (Exception ex)
        {
            result.loadSuccess = false;
            result.failReason = "load_exception:" + Short(ex.Message);
            CreateMarker(root, "Fail_" + target.kind + "_" + target.id, index, Color.red, target.label + "\\n" + result.failReason);
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
        float x = -4.2f + (index % 4) * 2.7f;
        float y = 1.8f - (index / 4) * 2.4f;
        return new Vector3(x, y, 0f);
    }

    private static void CreateMarker(Transform root, string name, int index, Color color, string label)
    {
        var go = GameObject.CreatePrimitive(PrimitiveType.Cube);
        go.name = name;
        go.transform.SetParent(root);
        go.transform.position = PositionFor(index);
        go.transform.localScale = new Vector3(1.2f, 0.8f, 0.1f);
        var renderer = go.GetComponent<Renderer>();
        var material = new Material(Shader.Find("Standard"));
        material.color = color;
        renderer.sharedMaterial = material;
        AddLabel(go.transform, label, new Vector3(0f, -0.72f, -0.2f), 0.11f);
    }

    private static void CreateTextureQuad(Transform root, string name, Texture2D texture, Vector3 position, Vector3 scale, string label)
    {
        var quad = GameObject.CreatePrimitive(PrimitiveType.Quad);
        quad.name = name;
        quad.transform.SetParent(root);
        quad.transform.position = position;
        quad.transform.localScale = scale;
        var renderer = quad.GetComponent<Renderer>();
        var material = new Material(Shader.Find("Unlit/Texture"));
        material.mainTexture = texture;
        renderer.sharedMaterial = material;
        AddLabel(quad.transform, label, new Vector3(0f, -0.82f, -0.2f), 0.11f);
    }

    private static void AddLabel(Transform parent, string text, Vector3 localPosition, float size)
    {
        var label = new GameObject("Label");
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

    private static List<ProbeTarget> ReadTargets(string path)
    {
        var list = new List<ProbeTarget>();
        if (!File.Exists(path))
        {
            return list;
        }
        var lines = File.ReadAllLines(path, Encoding.UTF8);
        for (int i = 1; i < lines.Length; i++)
        {
            if (string.IsNullOrWhiteSpace(lines[i]))
            {
                continue;
            }
            var parts = SplitCsvLine(lines[i]);
            if (parts.Count < 9)
            {
                continue;
            }
            list.Add(new ProbeTarget
            {
                kind = parts[0],
                id = parts[1],
                label = parts[2],
                bundle = parts[3],
                absolutePath = parts[4],
                indexFileExists = parts[5],
                indexSize = parts[6],
                indexStatus = parts[7],
                indexObjectCount = parts[8],
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
                quote = !quote;
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

    private static void WriteCsv(string path, List<ProbeResult> results)
    {
        var lines = new List<string>();
        lines.Add("kind,id,label,bundle,absolutePath,fileExists,size,loadSuccess,failReason,assetNameCount,assetNameSample,gameObjectCount,texture2DCount,spriteCount,materialCount,textAssetCount,skeletonLikeCount,instantiateSuccess,instantiatedAsset,textureFallback,textureFallbackAsset,dependencyMissing,dependencyNotes");
        foreach (var r in results)
        {
            lines.Add(string.Join(",", new[]
            {
                Csv(r.kind), Csv(r.id), Csv(r.label), Csv(r.bundle), Csv(r.absolutePath), Csv(r.fileExists.ToString()), Csv(r.size.ToString()),
                Csv(r.loadSuccess.ToString()), Csv(r.failReason), Csv(r.assetNameCount.ToString()), Csv(r.assetNameSample),
                Csv(r.gameObjectCount.ToString()), Csv(r.texture2DCount.ToString()), Csv(r.spriteCount.ToString()), Csv(r.materialCount.ToString()),
                Csv(r.textAssetCount.ToString()), Csv(r.skeletonLikeCount.ToString()), Csv(r.instantiateSuccess.ToString()), Csv(r.instantiatedAsset),
                Csv(r.textureFallback.ToString()), Csv(r.textureFallbackAsset), Csv(r.dependencyMissing.ToString()), Csv(r.dependencyNotes)
            }));
        }
        File.WriteAllLines(path, lines, Encoding.UTF8);
    }

    private static void WriteJson(string path, List<ProbeResult> results, BattleAssetBundleStreamingProbeMarker marker)
    {
        var sb = new StringBuilder();
        sb.AppendLine("{");
        sb.AppendLine("  \"status\": \"unity_probe_complete\",");
        sb.AppendLine("  \"scene\": \"Assets/Scenes/BattleAssetBundleStreamingProbe.unity\",");
        sb.AppendLine("  \"targetsCsv\": \"" + Json(TargetsPath) + "\",");
        sb.AppendLine("  \"summary\": {");
        sb.AppendLine("    \"targetCount\": " + marker.targetCount + ",");
        sb.AppendLine("    \"loadSuccess\": " + marker.loadSuccessCount + ",");
        sb.AppendLine("    \"loadFail\": " + marker.loadFailCount + ",");
        sb.AppendLine("    \"instantiateSuccess\": " + marker.instantiateSuccessCount + ",");
        sb.AppendLine("    \"textureFallback\": " + marker.textureFallbackCount);
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
            sb.AppendLine("      \"fileExists\": " + Bool(r.fileExists) + ",");
            sb.AppendLine("      \"size\": " + r.size + ",");
            sb.AppendLine("      \"loadSuccess\": " + Bool(r.loadSuccess) + ",");
            sb.AppendLine("      \"failReason\": \"" + Json(r.failReason) + "\",");
            sb.AppendLine("      \"assetNameCount\": " + r.assetNameCount + ",");
            sb.AppendLine("      \"assetNameSample\": \"" + Json(r.assetNameSample) + "\",");
            sb.AppendLine("      \"typeCounts\": {\"GameObject\": " + r.gameObjectCount + ", \"Texture2D\": " + r.texture2DCount + ", \"Sprite\": " + r.spriteCount + ", \"Material\": " + r.materialCount + ", \"TextAsset\": " + r.textAssetCount + ", \"SkeletonLike\": " + r.skeletonLikeCount + "},");
            sb.AppendLine("      \"instantiateSuccess\": " + Bool(r.instantiateSuccess) + ",");
            sb.AppendLine("      \"instantiatedAsset\": \"" + Json(r.instantiatedAsset) + "\",");
            sb.AppendLine("      \"textureFallback\": " + Bool(r.textureFallback) + ",");
            sb.AppendLine("      \"textureFallbackAsset\": \"" + Json(r.textureFallbackAsset) + "\",");
            sb.AppendLine("      \"dependencyMissing\": " + Bool(r.dependencyMissing) + ",");
            sb.AppendLine("      \"dependencyNotes\": \"" + Json(r.dependencyNotes) + "\"");
            sb.Append("    }");
            if (i + 1 < results.Count) sb.Append(",");
            sb.AppendLine();
        }
        sb.AppendLine("  ],");
        sb.AppendLine("  \"classification\": \"direct AssetBundle streaming succeeded for loaded targets; keep BATTLE_09 extracted texture fallback as a visual backup\",");
        sb.AppendLine("  \"nextBattle11Recommendation\": \"Build extracted-prefab reconstruction for the streamed actor bundles, using loaded GameObject names plus copied skel/atlas/texture evidence.\"");
        sb.AppendLine("}");
        File.WriteAllText(path, sb.ToString(), Encoding.UTF8);
    }

    private static int Count(List<ProbeResult> results, Func<ProbeResult, bool> predicate)
    {
        int count = 0;
        foreach (var r in results)
        {
            if (predicate(r)) count++;
        }
        return count;
    }

    private static string Sample(string[] values, int max)
    {
        var items = new List<string>();
        for (int i = 0; i < values.Length && i < max; i++)
        {
            items.Add(values[i]);
        }
        return string.Join(";", items);
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
        return (value ?? "").Replace("\\", "\\\\").Replace("\"", "\\\"").Replace("\r", " ").Replace("\n", " ");
    }

    private static string Bool(bool value)
    {
        return value ? "true" : "false";
    }
}

public sealed class ProbeTarget
{
    public string kind;
    public string id;
    public string label;
    public string bundle;
    public string absolutePath;
    public string indexFileExists;
    public string indexSize;
    public string indexStatus;
    public string indexObjectCount;
}

public sealed class ProbeResult
{
    public string kind;
    public string id;
    public string label;
    public string bundle;
    public string absolutePath;
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
    public int skeletonLikeCount;
    public bool instantiateSuccess;
    public string instantiatedAsset = "";
    public bool textureFallback;
    public string textureFallbackAsset = "";
    public bool dependencyMissing;
    public string dependencyNotes = "";

    public ProbeResult(ProbeTarget target)
    {
        kind = target.kind;
        id = target.id;
        label = target.label;
        bundle = target.bundle;
        absolutePath = target.absolutePath;
    }

    public void AddType(string typeName, string assetName)
    {
        if (typeName == "GameObject") gameObjectCount++;
        if (typeName == "Texture2D") texture2DCount++;
        if (typeName == "Sprite") spriteCount++;
        if (typeName == "Material") materialCount++;
        if (typeName == "TextAsset") textAssetCount++;
        string lower = (assetName ?? "").ToLowerInvariant();
        if (lower.EndsWith(".skel") || lower.EndsWith(".skel.bytes") || lower.EndsWith(".atlas") || lower.Contains("skeletondata") || lower.Contains("_atlas.asset") || typeName.ToLowerInvariant().Contains("skeleton"))
        {
            skeletonLikeCount++;
        }
    }
}

public sealed class BattleAssetBundleStreamingProbeMarker : MonoBehaviour
{
    public string targetsCsv;
    public string resultJson;
    public int targetCount;
    public int loadSuccessCount;
    public int loadFailCount;
    public int instantiateSuccessCount;
    public int textureFallbackCount;
}
