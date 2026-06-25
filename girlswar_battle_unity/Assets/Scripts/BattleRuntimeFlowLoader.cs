using UnityEngine;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text.RegularExpressions;

public sealed class BattleRuntimeFlowLoader : MonoBehaviour
{
    public string flowManifestPath = "Assets/RestoreData/battle/BATTLE_RUNTIME_FLOW_MANIFEST.json";
    public bool loadOnStart = true;

    private readonly List<AssetBundle> loadedBundles = new List<AssetBundle>();

    private void Start()
    {
        if (loadOnStart)
        {
            BuildPreviewInCurrentScene();
        }
    }

    public void BuildPreviewInCurrentScene()
    {
        string fullPath = Path.Combine(Application.dataPath, "..", flowManifestPath);
        if (!File.Exists(fullPath))
        {
            Debug.LogWarning("Missing battle runtime flow manifest: " + fullPath);
            return;
        }

        string json = File.ReadAllText(fullPath);
        CreateMapShell(json);
        foreach (var slot in ParseSlots(json))
        {
            if (slot.loadStatus == "runtime_prefab")
            {
                LoadActor(slot);
            }
            else
            {
                CreatePlaceholder(slot);
            }
        }
    }

    private void CreateMapShell(string json)
    {
        var map = GameObject.CreatePrimitive(PrimitiveType.Quad);
        map.name = "FlowMap_11001_EvidenceShell";
        map.transform.SetParent(transform);
        map.transform.position = new Vector3(0.35f, 0f, 0.35f);
        map.transform.localScale = new Vector3(9.8f, 5.8f, 1f);
        var renderer = map.GetComponent<Renderer>();
        renderer.sharedMaterial = new Material(Shader.Find("Sprites/Default"));
        renderer.sharedMaterial.color = new Color(0.105f, 0.13f, 0.15f, 1f);

        string summary = "ProcedureNormalBattle flow shell"
            + "\nmapId " + ReadValue(json, "mapId")
            + " / battleType " + ReadValue(json, "battleType")
            + " / seed " + ReadValue(json, "randomSeed")
            + "\nNo invented AI or skill animation";
        AddLabel(map.transform, summary, new Vector3(0f, 0.47f, -0.2f), 0.065f);
    }

    private void LoadActor(BattleFlowSlot slot)
    {
        if (!File.Exists(slot.absolutePath))
        {
            slot.missingReason = "bundle_file_not_found";
            CreatePlaceholder(slot);
            return;
        }

        var bundle = AssetBundle.LoadFromFile(slot.absolutePath);
        if (bundle == null)
        {
            slot.missingReason = "LoadFromFile_returned_null";
            CreatePlaceholder(slot);
            return;
        }
        loadedBundles.Add(bundle);

        var prefab = bundle.LoadAsset<GameObject>(slot.prefabAsset);
        if (prefab == null)
        {
            slot.missingReason = "prefab_asset_not_found";
            CreatePlaceholder(slot);
            return;
        }

        var go = Instantiate(prefab, slot.position, Quaternion.identity, transform);
        go.name = "FlowActor_" + slot.side + "_w" + slot.wave + "_s" + slot.slot + "_" + slot.heroDid;
        go.transform.localScale = Vector3.one * slot.scale;
        AddLabel(go.transform, slot.side + " slot " + slot.slot + "\n" + slot.heroDid + " / " + slot.modelId + "\n" + slot.prefabAsset, new Vector3(0f, -1.2f, -0.2f), 0.1f);
    }

    private void CreatePlaceholder(BattleFlowSlot slot)
    {
        var go = GameObject.CreatePrimitive(PrimitiveType.Cube);
        go.name = "FlowMissing_" + slot.side + "_w" + slot.wave + "_s" + slot.slot + "_" + slot.heroDid;
        go.transform.SetParent(transform);
        go.transform.position = slot.position;
        go.transform.localScale = new Vector3(0.85f, 0.7f, 0.12f);
        var renderer = go.GetComponent<Renderer>();
        renderer.sharedMaterial = new Material(Shader.Find("Standard"));
        renderer.sharedMaterial.color = slot.side == "our" ? new Color(0.28f, 0.24f, 0.20f, 1f) : new Color(0.22f, 0.22f, 0.27f, 1f);
        AddLabel(go.transform, slot.side + " slot " + slot.slot + "\n" + slot.heroDid + " / " + slot.modelId + "\n" + slot.missingReason, new Vector3(0f, -0.7f, -0.2f), 0.085f);
    }

    private void AddLabel(Transform parent, string text, Vector3 localPosition, float size)
    {
        var label = new GameObject("FlowLabel");
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

    private List<BattleFlowSlot> ParseSlots(string json)
    {
        var slots = new List<BattleFlowSlot>();
        string block = ExtractArrayBlock(json, "\"actorSlots\"");
        foreach (string item in ExtractObjectBlocks(block))
        {
            slots.Add(new BattleFlowSlot
            {
                side = ReadValue(item, "side"),
                wave = ReadInt(item, "wave"),
                slot = ReadInt(item, "slot"),
                index = ReadInt(item, "index"),
                heroDid = ReadValue(item, "heroDid"),
                heroId = ReadValue(item, "heroId"),
                modelId = ReadValue(item, "modelId"),
                prefab = ReadValue(item, "prefab"),
                bundle = ReadValue(item, "bundle"),
                absolutePath = ReadValue(item, "absolutePath"),
                prefabAsset = ReadValue(item, "prefabAsset"),
                loadStatus = ReadValue(item, "loadStatus"),
                missingReason = ReadValue(item, "missingReason"),
                x = ReadFloat(item, "x"),
                y = ReadFloat(item, "y"),
                scale = ReadFloat(item, "scale", 0.7f)
            });
        }
        return slots;
    }

    private string ExtractArrayBlock(string json, string key)
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

    private List<string> ExtractObjectBlocks(string arrayBlock)
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

    private string ReadValue(string json, string key)
    {
        var stringMatch = Regex.Match(json, "\"" + Regex.Escape(key) + "\"\\s*:\\s*\"((?:\\\\.|[^\"])*)\"");
        if (stringMatch.Success) return JsonUnescape(stringMatch.Groups[1].Value);
        var numberMatch = Regex.Match(json, "\"" + Regex.Escape(key) + "\"\\s*:\\s*(-?\\d+(?:\\.\\d+)?)");
        if (numberMatch.Success) return numberMatch.Groups[1].Value;
        return "";
    }

    private int ReadInt(string json, string key)
    {
        var match = Regex.Match(json, "\"" + Regex.Escape(key) + "\"\\s*:\\s*\"?(-?\\d+)\"?");
        return match.Success ? int.Parse(match.Groups[1].Value) : 0;
    }

    private float ReadFloat(string json, string key, float fallback = 0f)
    {
        var match = Regex.Match(json, "\"" + Regex.Escape(key) + "\"\\s*:\\s*(-?\\d+(?:\\.\\d+)?)");
        return match.Success ? float.Parse(match.Groups[1].Value, System.Globalization.CultureInfo.InvariantCulture) : fallback;
    }

    private string JsonUnescape(string value)
    {
        return value.Replace("\\\\", "\\").Replace("\\\"", "\"").Replace("\\n", "\n").Replace("\\r", "\r");
    }

    private sealed class BattleFlowSlot
    {
        public string side;
        public int wave;
        public int slot;
        public int index;
        public string heroDid;
        public string heroId;
        public string modelId;
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
}
