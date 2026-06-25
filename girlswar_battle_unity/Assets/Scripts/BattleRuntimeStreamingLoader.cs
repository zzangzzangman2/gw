using UnityEngine;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text.RegularExpressions;

public sealed class BattleRuntimeStreamingLoader : MonoBehaviour
{
    public string manifestPath = "Assets/RestoreData/battle/BATTLE_RUNTIME_STREAMING_MANIFEST.json";
    public bool loadOnStart = true;

    private readonly List<AssetBundle> loadedBundles = new List<AssetBundle>();

    private void Start()
    {
        if (loadOnStart)
        {
            Load();
        }
    }

    public void Load()
    {
        string fullPath = Path.Combine(Application.dataPath, "..", manifestPath);
        if (!File.Exists(fullPath))
        {
            Debug.LogWarning("Missing battle runtime streaming manifest: " + fullPath);
            return;
        }
        string json = File.ReadAllText(fullPath);
        foreach (var actor in ParseActors(json))
        {
            if (actor.loadStatus == "runtime_prefab")
            {
                LoadActor(actor);
            }
            else
            {
                CreatePlaceholder(actor);
            }
        }
    }

    private void LoadActor(RuntimeActor actor)
    {
        if (!File.Exists(actor.absolutePath))
        {
            actor.missingReason = "bundle_file_not_found";
            CreatePlaceholder(actor);
            return;
        }
        var bundle = AssetBundle.LoadFromFile(actor.absolutePath);
        if (bundle == null)
        {
            actor.missingReason = "LoadFromFile_returned_null";
            CreatePlaceholder(actor);
            return;
        }
        loadedBundles.Add(bundle);
        var prefab = bundle.LoadAsset<GameObject>(actor.prefabAsset);
        if (prefab == null)
        {
            actor.missingReason = "prefab_asset_not_found";
            CreatePlaceholder(actor);
            return;
        }
        var go = Instantiate(prefab, actor.position, Quaternion.identity, transform);
        go.name = "RuntimeActor_" + actor.side + "_" + actor.heroDid;
        go.transform.localScale = Vector3.one * actor.scale;
        AddLabel(go.transform, actor.side + " " + actor.heroDid + "\n" + actor.prefabAsset, new Vector3(0f, -1.15f, -0.2f), 0.12f);
    }

    private void CreatePlaceholder(RuntimeActor actor)
    {
        var go = GameObject.CreatePrimitive(PrimitiveType.Cube);
        go.name = "RuntimeMissing_" + actor.side + "_" + actor.heroDid;
        go.transform.SetParent(transform);
        go.transform.position = actor.position;
        go.transform.localScale = new Vector3(0.85f, 0.7f, 0.1f);
        var renderer = go.GetComponent<Renderer>();
        renderer.material.color = new Color(0.26f, 0.24f, 0.24f, 1f);
        AddLabel(go.transform, actor.side + " " + actor.heroDid + "\n" + actor.missingReason, new Vector3(0f, -0.65f, -0.2f), 0.1f);
    }

    private void AddLabel(Transform parent, string text, Vector3 localPosition, float size)
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

    private List<RuntimeActor> ParseActors(string json)
    {
        var actors = new List<RuntimeActor>();
        string block = ExtractArrayBlock(json, "\"actors\"");
        foreach (Match match in Regex.Matches(block, "\\{.*?\\}", RegexOptions.Singleline))
        {
            string item = match.Value;
            actors.Add(new RuntimeActor
            {
                side = ReadString(item, "side"),
                heroDid = ReadString(item, "heroDid"),
                bundle = ReadString(item, "bundle"),
                absolutePath = ReadString(item, "absolutePath"),
                prefabAsset = ReadString(item, "prefabAsset"),
                loadStatus = ReadString(item, "loadStatus"),
                missingReason = ReadString(item, "missingReason"),
                position = new Vector3(ReadFloat(item, "x"), ReadFloat(item, "y"), 0f),
                scale = ReadFloat(item, "scale", 0.85f)
            });
        }
        return actors;
    }

    private string ExtractArrayBlock(string json, string key)
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

    private string ReadString(string json, string key)
    {
        var match = Regex.Match(json, "\"" + Regex.Escape(key) + "\"\\s*:\\s*\"([^\"]*)\"");
        return match.Success ? match.Groups[1].Value : "";
    }

    private float ReadFloat(string json, string key, float fallback = 0f)
    {
        var match = Regex.Match(json, "\"" + Regex.Escape(key) + "\"\\s*:\\s*(-?\\d+(?:\\.\\d+)?)");
        return match.Success ? float.Parse(match.Groups[1].Value, System.Globalization.CultureInfo.InvariantCulture) : fallback;
    }

    private sealed class RuntimeActor
    {
        public string side;
        public string heroDid;
        public string bundle;
        public string absolutePath;
        public string prefabAsset;
        public string loadStatus;
        public string missingReason;
        public Vector3 position;
        public float scale;
    }
}
