using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using System.IO;
using System.Text.RegularExpressions;

public static class BattleRuntimeFlowPrototypeEditor
{
    private const string FlowManifestPath = "Assets/RestoreData/battle/BATTLE_RUNTIME_FLOW_MANIFEST.json";
    private const string ScenePath = "Assets/Scenes/BattleRuntimeFlowPrototype.unity";

    [MenuItem("GirlsWar/Battle/Build Runtime Flow Prototype")]
    public static void Build()
    {
        string fullManifestPath = ProjectPath(FlowManifestPath);
        if (!File.Exists(fullManifestPath))
        {
            Debug.LogError("Missing runtime flow manifest: " + fullManifestPath);
            return;
        }

        string json = File.ReadAllText(fullManifestPath);
        var scene = EditorSceneManager.NewScene(NewSceneSetup.EmptyScene, NewSceneMode.Single);
        var root = new GameObject("BattleRuntimeFlowPrototypeRoot");
        var loader = root.AddComponent<BattleRuntimeFlowLoader>();
        loader.flowManifestPath = FlowManifestPath;
        loader.loadOnStart = false;

        var cameraObject = new GameObject("RuntimeFlowCamera");
        var camera = cameraObject.AddComponent<Camera>();
        camera.orthographic = true;
        camera.orthographicSize = 5.8f;
        camera.clearFlags = CameraClearFlags.SolidColor;
        camera.backgroundColor = new Color(0.045f, 0.05f, 0.055f, 1f);
        cameraObject.transform.position = new Vector3(0.2f, 0f, -10f);

        loader.BuildPreviewInCurrentScene();
        EditorSceneManager.SaveScene(scene, ScenePath);
        AssetDatabase.Refresh();

        int slots = ReadInt(json, "actorSlots");
        int loadable = Regex.Matches(ExtractArrayBlock(json, "\"actorSlots\""), "\"loadStatus\"\\s*:\\s*\"runtime_prefab\"").Count;
        int missing = Regex.Matches(ExtractArrayBlock(json, "\"actorSlots\""), "\"loadStatus\"\\s*:\\s*\"placeholder\"").Count;
        Debug.Log("BattleRuntimeFlowPrototype generated. slots=" + slots + ", loadable=" + loadable + ", missing=" + missing);
    }

    private static string ExtractArrayBlock(string json, string key)
    {
        int keyIndex = json.IndexOf(key, System.StringComparison.Ordinal);
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

    private static int ReadInt(string json, string key)
    {
        var match = Regex.Match(json, "\"" + Regex.Escape(key) + "\"\\s*:\\s*\"?(-?\\d+)\"?");
        return match.Success ? int.Parse(match.Groups[1].Value) : 0;
    }

    private static string ProjectPath(string assetPath)
    {
        return Path.Combine(Application.dataPath, "..", assetPath);
    }
}
