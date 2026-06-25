using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text.RegularExpressions;

public static class BattlePrototypeSceneBuilder
{
    [MenuItem("GirlsWar/Battle/Build Minimal Prototype Scene")]
    public static void Build()
    {
        string dataRoot = Path.Combine(Application.dataPath, "RestoreData", "battle");
        string manifestPath = Path.Combine(dataRoot, "BATTLE_PROTOTYPE_MANIFEST.json");
        string payloadPath = Path.Combine(dataRoot, "BATTLE_TEST_PAYLOAD.json");
        string loadMapPath = Path.Combine(dataRoot, "BATTLE_ASSETBUNDLE_LOAD_MAP.json");
        string manifestJson = File.Exists(manifestPath) ? File.ReadAllText(manifestPath) : "{}";
        string payloadJson = File.Exists(payloadPath) ? File.ReadAllText(payloadPath) : "{}";
        string loadMapJson = File.Exists(loadMapPath) ? File.ReadAllText(loadMapPath) : "{}";
        int mapId = ReadInt(manifestJson, "\"mapId\"");
        int battleType = ReadInt(manifestJson, "\"battleType\"");
        int randomSeed = ReadInt(manifestJson, "\"randomSeed\"");
        var actors = ReadActors(manifestJson);
        int missingBundles = Regex.Matches(manifestJson, "\"exists\"\\s*:\\s*false").Count;

        var scene = EditorSceneManager.NewScene(NewSceneSetup.EmptyScene, NewSceneMode.Single);
        var root = new GameObject("BattlePrototypeRoot");
        var marker = root.AddComponent<BattlePrototypeManifestMarker>();
        marker.manifestPath = "Assets/RestoreData/battle/BATTLE_PROTOTYPE_MANIFEST.json";
        marker.payloadPath = "Assets/RestoreData/battle/BATTLE_TEST_PAYLOAD.json";
        marker.loadMapPath = "Assets/RestoreData/battle/BATTLE_ASSETBUNDLE_LOAD_MAP.json";
        marker.mapId = mapId;
        marker.battleType = battleType;
        marker.randomSeed = randomSeed;
        marker.missingBundleCount = missingBundles;
        marker.loadMapBytes = loadMapJson.Length;

        var manifest = new GameObject("ManifestSource");
        manifest.transform.SetParent(root.transform);
        AddLabel(manifest.transform, "manifest + payload source", new Vector3(0f, 3.4f, 0f), 0.22f);

        var cameraObject = new GameObject("BattleCamera");
        var camera = cameraObject.AddComponent<Camera>();
        camera.orthographic = true;
        camera.orthographicSize = 5.2f;
        camera.clearFlags = CameraClearFlags.SolidColor;
        camera.backgroundColor = new Color(0.08f, 0.09f, 0.11f, 1f);
        cameraObject.transform.position = new Vector3(0f, 0f, -10f);

        var map = CreateBlock("Map_11001_Background", new Vector3(0f, 0.75f, 0f), new Vector3(9.5f, 3.8f, 0.1f), new Color(0.18f, 0.24f, 0.28f, 1f), root.transform);
        AddLabel(map.transform, "mapId=" + mapId + " battleType=" + battleType + " seed=" + randomSeed, new Vector3(0f, 1.9f, -0.2f), 0.24f);

        int ourIndex = 0;
        int enemyIndex = 0;
        foreach (var actor in actors)
        {
            if (actor.side == "our")
            {
                float x = -4.2f + (ourIndex * 1.7f);
                var go = CreateBlock("OurActor_" + actor.heroDid, new Vector3(x, -1.9f, 0f), new Vector3(1.2f, 1.0f, 0.1f), new Color(0.20f, 0.45f, 0.62f, 1f), root.transform);
                AddLabel(go.transform, actor.ToLabel(), new Vector3(0f, -0.75f, -0.2f), 0.16f);
                ourIndex++;
            }
            else if (actor.side == "enemy")
            {
                int wave = Mathf.Max(1, actor.waveNo);
                int lane = enemyIndex % 3;
                float x = 0.8f + lane * 1.65f;
                float y = 2.05f - (wave - 1) * 1.18f;
                var go = CreateBlock("EnemyActor_W" + wave + "_" + actor.heroDid, new Vector3(x, y, 0f), new Vector3(1.05f, 0.78f, 0.1f), new Color(0.55f, 0.25f, 0.22f, 1f), root.transform);
                AddLabel(go.transform, actor.ToLabel(), new Vector3(0f, -0.58f, -0.2f), 0.13f);
                enemyIndex++;
            }
        }

        var summary = new GameObject("SkillResourceSummary");
        summary.transform.SetParent(root.transform);
        AddLabel(summary.transform, "actors=" + actors.Count + " missingBundles=" + missingBundles + " payloadBytes=" + payloadJson.Length, new Vector3(0f, -3.2f, 0f), 0.2f);

        EditorSceneManager.SaveScene(scene, "Assets/Scenes/BattlePrototype.unity");
        AssetDatabase.Refresh();
        Debug.Log("BattlePrototype scene generated. actors=" + actors.Count + ", missingBundles=" + missingBundles);
    }

    private static GameObject CreateBlock(string name, Vector3 position, Vector3 scale, Color color, Transform parent)
    {
        var go = GameObject.CreatePrimitive(PrimitiveType.Cube);
        go.name = name;
        go.transform.SetParent(parent);
        go.transform.position = position;
        go.transform.localScale = scale;
        var renderer = go.GetComponent<Renderer>();
        if (renderer != null)
        {
            var material = new Material(Shader.Find("Standard"));
            material.color = color;
            renderer.sharedMaterial = material;
        }
        return go;
    }

    private static void AddLabel(Transform parent, string text, Vector3 localPosition, float size)
    {
        var label = new GameObject("Label");
        label.transform.SetParent(parent);
        label.transform.localPosition = localPosition;
        var mesh = label.AddComponent<TextMesh>();
        mesh.text = text;
        mesh.fontSize = 32;
        mesh.characterSize = size;
        mesh.anchor = TextAnchor.MiddleCenter;
        mesh.alignment = TextAlignment.Center;
        mesh.color = Color.white;
    }

    private static int ReadInt(string json, string key)
    {
        var match = Regex.Match(json, Regex.Escape(key) + "\\s*:\\s*(-?\\d+)");
        return match.Success ? int.Parse(match.Groups[1].Value) : 0;
    }

    private static List<BattleActorRecord> ReadActors(string json)
    {
        var actors = new List<BattleActorRecord>();
        var actorsStart = json.IndexOf("\"actors\"", StringComparison.Ordinal);
        if (actorsStart < 0)
        {
            return actors;
        }
        var bundlesStart = json.IndexOf("\"bundles\"", actorsStart, StringComparison.Ordinal);
        string actorsJson = bundlesStart > actorsStart ? json.Substring(actorsStart, bundlesStart - actorsStart) : json.Substring(actorsStart);
        foreach (Match match in Regex.Matches(actorsJson, "\\{[^{}]*\"payloadHeroDid\"[^{}]*\\}", RegexOptions.Singleline))
        {
            string block = match.Value;
            actors.Add(new BattleActorRecord
            {
                side = ReadString(block, "\"side\""),
                waveNo = ReadInt(block, "\"waveNo\""),
                heroDid = ReadInt(block, "\"payloadHeroDid\""),
                heroId = ReadInt(block, "\"payloadHeroId\""),
                modelId = ReadInt(block, "\"modelId\""),
                prefabId = ReadInt(block, "\"prefabId\""),
                bundle = ReadString(block, "\"actorBundle\""),
                bundleExists = Regex.IsMatch(block, "\"actorBundleExists\"\\s*:\\s*true")
            });
        }
        return actors;
    }

    private static string ReadString(string json, string key)
    {
        var match = Regex.Match(json, Regex.Escape(key) + "\\s*:\\s*\"([^\"]*)\"");
        return match.Success ? match.Groups[1].Value : "";
    }
}

public sealed class BattleActorRecord
{
    public string side;
    public int waveNo;
    public int heroDid;
    public int heroId;
    public int modelId;
    public int prefabId;
    public string bundle;
    public bool bundleExists;

    public string ToLabel()
    {
        return side + "\\nheroDid=" + heroDid + " heroId=" + heroId + "\\nmodel=" + modelId + " prefab=" + prefabId + "\\n" + (string.IsNullOrEmpty(bundle) ? "bundle=missing" : bundle) + "\\nexists=" + bundleExists;
    }
}

public sealed class BattlePrototypeManifestMarker : MonoBehaviour
{
    public string manifestPath = "Assets/RestoreData/battle/BATTLE_PROTOTYPE_MANIFEST.json";
    public string payloadPath = "Assets/RestoreData/battle/BATTLE_TEST_PAYLOAD.json";
    public string loadMapPath = "Assets/RestoreData/battle/BATTLE_ASSETBUNDLE_LOAD_MAP.json";
    public int mapId;
    public int battleType;
    public int randomSeed;
    public int missingBundleCount;
    public int loadMapBytes;

    public string GetLoadMapJson()
    {
        var fullPath = Path.Combine(Application.dataPath, "..", loadMapPath);
        return File.Exists(fullPath) ? File.ReadAllText(fullPath) : "{}";
    }
}
