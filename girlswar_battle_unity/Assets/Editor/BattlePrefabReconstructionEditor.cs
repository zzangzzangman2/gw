using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;

public static class BattlePrefabReconstructionEditor
{
    private const string ProbeJsonPath = "Assets/RestoreData/battle/BATTLE_ASSETBUNDLE_STREAMING_PROBE.json";
    private const string LoadMapPath = "Assets/RestoreData/battle/BATTLE_ASSETBUNDLE_LOAD_MAP.json";
    private const string RuntimeManifestPath = "Assets/RestoreData/battle/BATTLE_RUNTIME_STREAMING_MANIFEST.json";
    private const string HierarchyJsonPath = "Assets/RestoreData/battle/BATTLE_PREFAB_HIERARCHY_DUMP.json";
    private const string HierarchyCsvPath = "Assets/RestoreData/battle/BATTLE_PREFAB_HIERARCHY_DUMP.csv";
    private const string ScenePath = "Assets/Scenes/BattleRuntimeStreamingReconstruction.unity";

    [MenuItem("GirlsWar/Battle/Build Runtime Streaming Reconstruction")]
    public static void Build()
    {
        string probeJson = File.ReadAllText(ProjectPath(ProbeJsonPath));
        string loadMapJson = File.ReadAllText(ProjectPath(LoadMapPath));
        var probeResults = ReadProbeResults(probeJson);
        var loadMapActors = ReadLoadMapActors(loadMapJson);
        var hierarchyRows = new List<HierarchyRow>();
        var skeletonEvidence = new List<string>();
        var runtimeActors = BuildRuntimeActors(probeResults, loadMapActors);

        var scene = EditorSceneManager.NewScene(NewSceneSetup.EmptyScene, NewSceneMode.Single);
        var root = new GameObject("BattleRuntimeStreamingReconstructionRoot");
        var loader = root.AddComponent<BattleRuntimeStreamingLoader>();
        loader.manifestPath = RuntimeManifestPath;
        loader.loadOnStart = false;

        var cameraObject = new GameObject("RuntimeReconstructionCamera");
        var camera = cameraObject.AddComponent<Camera>();
        camera.orthographic = true;
        camera.orthographicSize = 5.8f;
        camera.clearFlags = CameraClearFlags.SolidColor;
        camera.backgroundColor = new Color(0.05f, 0.055f, 0.06f, 1f);
        cameraObject.transform.position = new Vector3(0f, 0f, -10f);

        var openBundles = new List<AssetBundle>();
        foreach (var actor in runtimeActors)
        {
            if (actor.loadStatus == "runtime_prefab")
            {
                var bundle = AssetBundle.LoadFromFile(actor.absolutePath);
                if (bundle == null)
                {
                    actor.loadStatus = "placeholder";
                    actor.missingReason = "editor_LoadFromFile_null";
                    CreatePlaceholder(root.transform, actor);
                    continue;
                }
                openBundles.Add(bundle);
                CollectSkeletonEvidence(bundle, skeletonEvidence);
                var prefab = bundle.LoadAsset<GameObject>(actor.prefabAsset);
                if (prefab == null)
                {
                    actor.loadStatus = "placeholder";
                    actor.missingReason = "prefab_not_found_in_editor";
                    CreatePlaceholder(root.transform, actor);
                    continue;
                }
                var instance = (GameObject)GameObject.Instantiate(prefab, actor.position, Quaternion.identity, root.transform);
                instance.name = "Reconstructed_" + actor.side + "_" + actor.heroDid;
                instance.transform.localScale = Vector3.one * actor.scale;
                DumpHierarchy(actor, instance.transform, "", hierarchyRows);
                AddLabel(instance.transform, actor.side + " " + actor.heroDid + "\n" + actor.prefabAsset, new Vector3(0f, -1.15f, -0.2f), 0.12f);
            }
            else
            {
                CreatePlaceholder(root.transform, actor);
            }
        }

        WriteRuntimeManifest(runtimeActors);
        WriteHierarchyCsv(hierarchyRows);
        WriteHierarchyJson(hierarchyRows, skeletonEvidence);
        foreach (var bundle in openBundles)
        {
            bundle.Unload(false);
        }

        EditorSceneManager.SaveScene(scene, ScenePath);
        AssetDatabase.Refresh();
        Debug.Log("BattlePrefabReconstruction generated. actors=" + runtimeActors.Count + ", hierarchyObjects=" + hierarchyRows.Count + ", components=" + CountComponents(hierarchyRows));
    }

    private static List<RuntimeActorRecord> BuildRuntimeActors(List<ProbeResultRecord> probeResults, List<LoadMapActorRecord> loadMapActors)
    {
        var probeById = new Dictionary<string, ProbeResultRecord>();
        foreach (var probe in probeResults)
        {
            if (probe.kind == "actor" && probe.instantiateSuccess)
            {
                probeById[probe.id] = probe;
            }
        }

        var actors = new List<RuntimeActorRecord>();
        int ourIndex = 0;
        int enemyIndex = 0;
        foreach (var source in loadMapActors)
        {
            var actor = new RuntimeActorRecord();
            actor.side = source.side;
            actor.heroDid = source.heroDid;
            actor.model = source.model;
            actor.prefab = source.prefab;
            actor.bundle = source.bundle;
            actor.missingReason = source.loadStatus;
            actor.scale = source.side == "our" ? 0.7f : 0.62f;
            if (source.side == "our")
            {
                actor.x = -3.3f + ourIndex * 1.65f;
                actor.y = -2.35f;
                ourIndex++;
            }
            else
            {
                int wave = source.waveNo > 0 ? source.waveNo : Mathf.Max(1, enemyIndex / 3 + 1);
                int lane = enemyIndex % 3;
                actor.x = 1.05f + lane * 1.45f;
                actor.y = 2.35f - (wave - 1) * 1.15f;
                enemyIndex++;
            }

            if (probeById.ContainsKey(source.heroDid))
            {
                var probe = probeById[source.heroDid];
                actor.absolutePath = probe.absolutePath;
                actor.prefabAsset = FindPrefabAsset(probe.assetNameSample, probe.instantiatedAsset);
                actor.loadStatus = "runtime_prefab";
                actor.missingReason = "";
            }
            else
            {
                actor.loadStatus = "placeholder";
            }
            actors.Add(actor);
        }
        return actors;
    }

    private static string FindPrefabAsset(string sample, string instantiatedAsset)
    {
        var parts = sample.Split(';');
        foreach (var part in parts)
        {
            if (part.EndsWith(".prefab", StringComparison.OrdinalIgnoreCase) && part.ToLowerInvariant().Contains(instantiatedAsset.ToLowerInvariant().Replace("hero_", "hero_")))
            {
                return part;
            }
        }
        foreach (var part in parts)
        {
            if (part.EndsWith(".prefab", StringComparison.OrdinalIgnoreCase) && part.ToLowerInvariant().Contains("hero_"))
            {
                return part;
            }
        }
        foreach (var part in parts)
        {
            if (part.EndsWith(".prefab", StringComparison.OrdinalIgnoreCase))
            {
                return part;
            }
        }
        return "";
    }

    private static void DumpHierarchy(RuntimeActorRecord actor, Transform transform, string parentPath, List<HierarchyRow> rows)
    {
        string path = string.IsNullOrEmpty(parentPath) ? transform.name : parentPath + "/" + transform.name;
        var row = new HierarchyRow();
        row.bundleId = actor.heroDid;
        row.assetName = actor.prefabAsset;
        row.hierarchyPath = path;
        row.componentTypes = ComponentTypes(transform.gameObject);
        row.componentCount = transform.gameObject.GetComponents<Component>().Length;
        var renderer = transform.gameObject.GetComponent<Renderer>();
        if (renderer != null)
        {
            row.rendererType = renderer.GetType().Name;
            row.materialNames = MaterialNames(renderer);
            row.textureNames = TextureNames(renderer);
        }
        rows.Add(row);
        for (int i = 0; i < transform.childCount; i++)
        {
            DumpHierarchy(actor, transform.GetChild(i), path, rows);
        }
    }

    private static string ComponentTypes(GameObject go)
    {
        var parts = new List<string>();
        foreach (var c in go.GetComponents<Component>())
        {
            parts.Add(c == null ? "MissingScript" : c.GetType().Name);
        }
        return string.Join(";", parts);
    }

    private static string MaterialNames(Renderer renderer)
    {
        var parts = new List<string>();
        foreach (var m in renderer.sharedMaterials)
        {
            if (m != null) parts.Add(m.name);
        }
        return string.Join(";", parts);
    }

    private static string TextureNames(Renderer renderer)
    {
        var parts = new List<string>();
        foreach (var m in renderer.sharedMaterials)
        {
            if (m == null) continue;
            var tex = m.mainTexture;
            if (tex != null) parts.Add(tex.name);
        }
        return string.Join(";", parts);
    }

    private static void CollectSkeletonEvidence(AssetBundle bundle, List<string> evidence)
    {
        foreach (var name in bundle.GetAllAssetNames())
        {
            string lower = name.ToLowerInvariant();
            if (lower.Contains("skeletondata") || lower.EndsWith(".skel.bytes") || lower.EndsWith(".atlas.txt"))
            {
                if (!evidence.Contains(name)) evidence.Add(name);
            }
        }
    }

    private static void CreatePlaceholder(Transform root, RuntimeActorRecord actor)
    {
        var go = GameObject.CreatePrimitive(PrimitiveType.Cube);
        go.name = "RuntimePlaceholder_" + actor.side + "_" + actor.heroDid;
        go.transform.SetParent(root);
        go.transform.position = actor.position;
        go.transform.localScale = new Vector3(0.8f, 0.65f, 0.1f);
        var renderer = go.GetComponent<Renderer>();
        renderer.sharedMaterial = new Material(Shader.Find("Standard"));
        renderer.sharedMaterial.color = new Color(0.24f, 0.24f, 0.27f, 1f);
        AddLabel(go.transform, actor.side + " " + actor.heroDid + "\n" + actor.missingReason, new Vector3(0f, -0.6f, -0.2f), 0.1f);
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

    private static void WriteRuntimeManifest(List<RuntimeActorRecord> actors)
    {
        var sb = new StringBuilder();
        sb.AppendLine("{");
        sb.AppendLine("  \"status\": \"runtime_streaming_manifest\",");
        sb.AppendLine("  \"actors\": [");
        for (int i = 0; i < actors.Count; i++)
        {
            var a = actors[i];
            sb.AppendLine("    {");
            sb.AppendLine("      \"side\": \"" + Json(a.side) + "\",");
            sb.AppendLine("      \"heroDid\": \"" + Json(a.heroDid) + "\",");
            sb.AppendLine("      \"model\": \"" + Json(a.model) + "\",");
            sb.AppendLine("      \"prefab\": \"" + Json(a.prefab) + "\",");
            sb.AppendLine("      \"bundle\": \"" + Json(a.bundle) + "\",");
            sb.AppendLine("      \"absolutePath\": \"" + Json(a.absolutePath) + "\",");
            sb.AppendLine("      \"prefabAsset\": \"" + Json(a.prefabAsset) + "\",");
            sb.AppendLine("      \"loadStatus\": \"" + Json(a.loadStatus) + "\",");
            sb.AppendLine("      \"missingReason\": \"" + Json(a.missingReason) + "\",");
            sb.AppendLine("      \"x\": " + Float(a.x) + ",");
            sb.AppendLine("      \"y\": " + Float(a.y) + ",");
            sb.AppendLine("      \"scale\": " + Float(a.scale));
            sb.Append("    }");
            if (i + 1 < actors.Count) sb.Append(",");
            sb.AppendLine();
        }
        sb.AppendLine("  ],");
        sb.AppendLine("  \"next\": \"BATTLE_12_CONNECT_BATTLE_FLOW_TO_RUNTIME_LOADER\"");
        sb.AppendLine("}");
        File.WriteAllText(ProjectPath(RuntimeManifestPath), sb.ToString(), Encoding.UTF8);
    }

    private static void WriteHierarchyCsv(List<HierarchyRow> rows)
    {
        var lines = new List<string>();
        lines.Add("bundleId,assetName,hierarchyPath,componentCount,componentTypes,rendererType,materialNames,textureNames");
        foreach (var row in rows)
        {
            lines.Add(string.Join(",", new[] { Csv(row.bundleId), Csv(row.assetName), Csv(row.hierarchyPath), Csv(row.componentCount.ToString()), Csv(row.componentTypes), Csv(row.rendererType), Csv(row.materialNames), Csv(row.textureNames) }));
        }
        File.WriteAllLines(ProjectPath(HierarchyCsvPath), lines, Encoding.UTF8);
    }

    private static void WriteHierarchyJson(List<HierarchyRow> rows, List<string> skeletonEvidence)
    {
        var sb = new StringBuilder();
        sb.AppendLine("{");
        sb.AppendLine("  \"status\": \"hierarchy_dump\",");
        sb.AppendLine("  \"objectCount\": " + rows.Count + ",");
        sb.AppendLine("  \"componentCount\": " + CountComponents(rows) + ",");
        sb.AppendLine("  \"skeletonEvidence\": [");
        for (int i = 0; i < skeletonEvidence.Count; i++)
        {
            sb.Append("    \"" + Json(skeletonEvidence[i]) + "\"");
            if (i + 1 < skeletonEvidence.Count) sb.Append(",");
            sb.AppendLine();
        }
        sb.AppendLine("  ],");
        sb.AppendLine("  \"objects\": [");
        for (int i = 0; i < rows.Count; i++)
        {
            var row = rows[i];
            sb.AppendLine("    {\"bundleId\":\"" + Json(row.bundleId) + "\",\"assetName\":\"" + Json(row.assetName) + "\",\"hierarchyPath\":\"" + Json(row.hierarchyPath) + "\",\"componentCount\":" + row.componentCount + ",\"componentTypes\":\"" + Json(row.componentTypes) + "\",\"rendererType\":\"" + Json(row.rendererType) + "\",\"materialNames\":\"" + Json(row.materialNames) + "\",\"textureNames\":\"" + Json(row.textureNames) + "\"}" + (i + 1 < rows.Count ? "," : ""));
        }
        sb.AppendLine("  ]");
        sb.AppendLine("}");
        File.WriteAllText(ProjectPath(HierarchyJsonPath), sb.ToString(), Encoding.UTF8);
    }

    private static List<ProbeResultRecord> ReadProbeResults(string json)
    {
        var list = new List<ProbeResultRecord>();
        string block = ExtractArrayBlock(json, "\"results\"");
        foreach (string item in ExtractObjectBlocks(block))
        {
            list.Add(new ProbeResultRecord
            {
                kind = ReadValue(item, "kind"),
                id = ReadValue(item, "id"),
                bundle = ReadValue(item, "bundle"),
                absolutePath = ReadValue(item, "absolutePath"),
                assetNameSample = ReadValue(item, "assetNameSample"),
                instantiateSuccess = ReadBool(item, "instantiateSuccess"),
                instantiatedAsset = ReadValue(item, "instantiatedAsset")
            });
        }
        return list;
    }

    private static List<LoadMapActorRecord> ReadLoadMapActors(string json)
    {
        var list = new List<LoadMapActorRecord>();
        string block = ExtractArrayBlock(json, "\"actors\"");
        foreach (string item in ExtractObjectBlocks(block))
        {
            list.Add(new LoadMapActorRecord
            {
                side = ReadValue(item, "side"),
                heroDid = ReadValue(item, "heroDid"),
                waveNo = ReadInt(item, "waveNo"),
                model = ReadValue(item, "model"),
                prefab = ReadValue(item, "prefab"),
                bundle = ReadValue(item, "bundle"),
                loadStatus = ReadValue(item, "loadStatus")
            });
        }
        return list;
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
                if (escape)
                {
                    escape = false;
                }
                else if (c == '\\')
                {
                    escape = true;
                }
                else if (c == '"')
                {
                    inString = false;
                }
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

    private static string ExtractArrayBlock(string json, string key)
    {
        int keyIndex = json.IndexOf(key, StringComparison.Ordinal);
        if (keyIndex < 0) return "";
        int start = json.IndexOf('[', keyIndex);
        if (start < 0) return "";
        int depth = 0;
        for (int i = start; i < json.Length; i++)
        {
            if (json[i] == '[') depth++;
            if (json[i] == ']') depth--;
            if (depth == 0) return json.Substring(start, i - start + 1);
        }
        return "";
    }

    private static string ProjectPath(string assetPath)
    {
        return Path.Combine(Application.dataPath, "..", assetPath);
    }

    private static string ReadString(string json, string key)
    {
        var match = Regex.Match(json, "\"" + Regex.Escape(key) + "\"\\s*:\\s*\"([^\"]*)\"");
        return match.Success ? match.Groups[1].Value : "";
    }

    private static string ReadValue(string json, string key)
    {
        var stringMatch = Regex.Match(json, "\"" + Regex.Escape(key) + "\"\\s*:\\s*\"([^\"]*)\"");
        if (stringMatch.Success) return stringMatch.Groups[1].Value;
        var numberMatch = Regex.Match(json, "\"" + Regex.Escape(key) + "\"\\s*:\\s*(-?\\d+(?:\\.\\d+)?)");
        if (numberMatch.Success) return numberMatch.Groups[1].Value;
        var boolMatch = Regex.Match(json, "\"" + Regex.Escape(key) + "\"\\s*:\\s*(true|false)", RegexOptions.IgnoreCase);
        if (boolMatch.Success) return boolMatch.Groups[1].Value.ToLowerInvariant();
        return "";
    }

    private static bool ReadBool(string json, string key)
    {
        var match = Regex.Match(json, "\"" + Regex.Escape(key) + "\"\\s*:\\s*(true|false)", RegexOptions.IgnoreCase);
        return match.Success && match.Groups[1].Value.ToLowerInvariant() == "true";
    }

    private static int ReadInt(string json, string key)
    {
        var match = Regex.Match(json, "\"" + Regex.Escape(key) + "\"\\s*:\\s*\"?(-?\\d+)\"?");
        return match.Success ? int.Parse(match.Groups[1].Value) : 0;
    }

    private static int CountComponents(List<HierarchyRow> rows)
    {
        int count = 0;
        foreach (var row in rows) count += row.componentCount;
        return count;
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

    private static string Float(float value)
    {
        return value.ToString(System.Globalization.CultureInfo.InvariantCulture);
    }
}

public sealed class ProbeResultRecord
{
    public string kind;
    public string id;
    public string bundle;
    public string absolutePath;
    public string assetNameSample;
    public bool instantiateSuccess;
    public string instantiatedAsset;
}

public sealed class LoadMapActorRecord
{
    public string side;
    public string heroDid;
    public int waveNo;
    public string model;
    public string prefab;
    public string bundle;
    public string loadStatus;
}

public sealed class RuntimeActorRecord
{
    public string side;
    public string heroDid;
    public string model;
    public string prefab;
    public string bundle;
    public string absolutePath;
    public string prefabAsset;
    public string loadStatus;
    public string missingReason;
    public float x;
    public float y;
    public float scale;
    public Vector3 position { get { return new Vector3(x, y, 0f); } }
}

public sealed class HierarchyRow
{
    public string bundleId;
    public string assetName;
    public string hierarchyPath;
    public int componentCount;
    public string componentTypes;
    public string rendererType;
    public string materialNames;
    public string textureNames;
}
