using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text.RegularExpressions;

public static class BattleAssetBackedPreviewSceneBuilder
{
    [MenuItem("GirlsWar/Battle/Build Asset-Backed Preview Scene")]
    public static void Build()
    {
        string manifestPath = Path.Combine(Application.dataPath, "RestoreData", "battle", "BATTLE_ASSET_BACKED_PREVIEW_VISUALS.json");
        string json = File.Exists(manifestPath) ? File.ReadAllText(manifestPath) : "{}";
        var mapLayers = ReadMapLayers(json);
        var actors = ReadActors(json);

        var scene = EditorSceneManager.NewScene(NewSceneSetup.EmptyScene, NewSceneMode.Single);
        var root = new GameObject("BattleAssetBackedPreviewRoot");
        var marker = root.AddComponent<BattleAssetBackedPreviewMarker>();
        marker.visualManifestPath = "Assets/RestoreData/battle/BATTLE_ASSET_BACKED_PREVIEW_VISUALS.json";
        marker.loadMapPath = "Assets/RestoreData/battle/BATTLE_ASSETBUNDLE_LOAD_MAP.json";
        marker.mapLayerCount = mapLayers.Count;
        marker.actorTextureFallbackCount = CountActorVisuals(actors, true);
        marker.missingPlaceholderCount = CountActorVisuals(actors, false);

        var cameraObject = new GameObject("BattlePreviewCamera");
        var camera = cameraObject.AddComponent<Camera>();
        camera.orthographic = true;
        camera.orthographicSize = 5.5f;
        camera.clearFlags = CameraClearFlags.SolidColor;
        camera.backgroundColor = new Color(0.045f, 0.05f, 0.055f, 1f);
        cameraObject.transform.position = new Vector3(0f, 0f, -10f);

        BuildMap(root.transform, mapLayers);
        BuildActors(root.transform, actors);
        AddLabel(root.transform, "BATTLE_09 asset-backed preview | texture fallback now, Spine/AB streaming next", new Vector3(0f, -4.55f, -0.2f), 0.18f, TextAnchor.MiddleCenter);

        EditorSceneManager.SaveScene(scene, "Assets/Scenes/BattleAssetBackedPreview.unity");
        AssetDatabase.Refresh();
        Debug.Log("BattleAssetBackedPreview generated. mapLayers=" + mapLayers.Count + ", textureActors=" + marker.actorTextureFallbackCount + ", missing=" + marker.missingPlaceholderCount);
    }

    private static void BuildMap(Transform root, List<MapLayerRecord> layers)
    {
        float z = 2.5f;
        int index = 0;
        foreach (var layer in layers)
        {
            Texture2D texture = AssetDatabase.LoadAssetAtPath<Texture2D>(layer.unityAssetPath);
            if (texture == null)
            {
                continue;
            }
            float width = Mathf.Clamp(layer.width / 240f, 2.5f, 10.5f);
            float height = Mathf.Clamp(layer.height / 240f, 0.5f, 3.2f);
            float y = 1.55f - index * 0.58f;
            var quad = CreateTexturedQuad("MapLayer_" + index + "_" + layer.name, texture, new Vector3(0f, y, z), new Vector3(width, height, 1f), root);
            AddLabel(quad.transform, layer.name, new Vector3(0f, -height * 0.54f, -0.1f), 0.1f, TextAnchor.MiddleCenter);
            z -= 0.05f;
            index++;
        }
    }

    private static void BuildActors(Transform root, List<ActorVisualRecord> actors)
    {
        int ourIndex = 0;
        int enemyIndex = 0;
        foreach (var actor in actors)
        {
            if (actor.side == "our")
            {
                float x = -3.4f + ourIndex * 1.75f;
                var position = new Vector3(x, -2.35f, 0f);
                CreateActorVisual(root, actor, position, new Vector3(1.05f, 1.35f, 1f), "Our");
                ourIndex++;
            }
            else
            {
                int wave = actor.waveNo > 0 ? actor.waveNo : Mathf.Max(1, (enemyIndex / 3) + 1);
                int lane = enemyIndex % 3;
                float x = 1.1f + lane * 1.45f;
                float y = 2.45f - (wave - 1) * 1.15f;
                CreateActorVisual(root, actor, new Vector3(x, y, 0f), new Vector3(0.82f, 0.95f, 1f), "Enemy_W" + wave);
                enemyIndex++;
            }
        }
    }

    private static void CreateActorVisual(Transform root, ActorVisualRecord actor, Vector3 position, Vector3 scale, string prefix)
    {
        Texture2D texture = string.IsNullOrEmpty(actor.texturePath) ? null : AssetDatabase.LoadAssetAtPath<Texture2D>(actor.texturePath);
        if (texture != null)
        {
            var quad = CreateTexturedQuad("TextureActor_" + prefix + "_" + actor.heroDid, texture, position, scale, root);
            AddLabel(quad.transform, actor.side + " " + actor.heroDid + "\\nmodel=" + actor.model + " prefab=" + actor.prefab, new Vector3(0f, -0.78f, -0.2f), 0.12f, TextAnchor.MiddleCenter);
        }
        else
        {
            var block = CreateBlock("MissingActor_" + prefix + "_" + actor.heroDid, position, scale, new Color(0.22f, 0.22f, 0.24f, 1f), root);
            AddLabel(block.transform, actor.side + " " + actor.heroDid + "\\n" + actor.loadStatus, new Vector3(0f, -0.72f, -0.2f), 0.11f, TextAnchor.MiddleCenter);
        }
    }

    private static GameObject CreateTexturedQuad(string name, Texture2D texture, Vector3 position, Vector3 scale, Transform parent)
    {
        var quad = GameObject.CreatePrimitive(PrimitiveType.Quad);
        quad.name = name;
        quad.transform.SetParent(parent);
        quad.transform.position = position;
        quad.transform.localScale = scale;
        var renderer = quad.GetComponent<Renderer>();
        var material = new Material(Shader.Find("Unlit/Texture"));
        material.mainTexture = texture;
        renderer.sharedMaterial = material;
        return quad;
    }

    private static GameObject CreateBlock(string name, Vector3 position, Vector3 scale, Color color, Transform parent)
    {
        var go = GameObject.CreatePrimitive(PrimitiveType.Cube);
        go.name = name;
        go.transform.SetParent(parent);
        go.transform.position = position;
        go.transform.localScale = scale;
        var renderer = go.GetComponent<Renderer>();
        var material = new Material(Shader.Find("Standard"));
        material.color = color;
        renderer.sharedMaterial = material;
        return go;
    }

    private static void AddLabel(Transform parent, string text, Vector3 localPosition, float size, TextAnchor anchor)
    {
        var label = new GameObject("Label");
        label.transform.SetParent(parent);
        label.transform.localPosition = localPosition;
        var mesh = label.AddComponent<TextMesh>();
        mesh.text = text;
        mesh.fontSize = 36;
        mesh.characterSize = size;
        mesh.anchor = anchor;
        mesh.alignment = TextAlignment.Center;
        mesh.color = Color.white;
    }

    private static List<MapLayerRecord> ReadMapLayers(string json)
    {
        var records = new List<MapLayerRecord>();
        string block = ExtractArrayBlock(json, "\"mapLayers\"");
        foreach (Match match in Regex.Matches(block, "\\{.*?\\}", RegexOptions.Singleline))
        {
            string item = match.Value;
            string asset = ReadString(item, "\"unityAssetPath\"");
            if (string.IsNullOrEmpty(asset))
            {
                continue;
            }
            records.Add(new MapLayerRecord
            {
                name = ReadString(item, "\"name\""),
                unityAssetPath = asset,
                width = ReadInt(item, "\"width\""),
                height = ReadInt(item, "\"height\"")
            });
        }
        return records;
    }

    private static List<ActorVisualRecord> ReadActors(string json)
    {
        var records = new List<ActorVisualRecord>();
        string block = ExtractArrayBlock(json, "\"actors\"");
        foreach (Match match in Regex.Matches(block, "\\{.*?\\\"visualStatus\\\".*?\\}", RegexOptions.Singleline))
        {
            string item = match.Value;
            string texturePath = ReadNestedString(item, "\"textureAsset\"", "\"unityAssetPath\"");
            records.Add(new ActorVisualRecord
            {
                side = ReadString(item, "\"side\""),
                heroDid = ReadInt(item, "\"heroDid\""),
                waveNo = ReadInt(item, "\"waveNo\""),
                model = ReadInt(item, "\"model\""),
                prefab = ReadInt(item, "\"prefab\""),
                loadStatus = ReadString(item, "\"loadStatus\""),
                texturePath = texturePath
            });
        }
        return records;
    }

    private static string ExtractArrayBlock(string json, string key)
    {
        int keyIndex = json.IndexOf(key, StringComparison.Ordinal);
        if (keyIndex < 0)
        {
            return "";
        }
        int start = json.IndexOf('[', keyIndex);
        if (start < 0)
        {
            return "";
        }
        int depth = 0;
        for (int i = start; i < json.Length; i++)
        {
            if (json[i] == '[') depth++;
            if (json[i] == ']') depth--;
            if (depth == 0)
            {
                return json.Substring(start, i - start + 1);
            }
        }
        return "";
    }

    private static string ReadNestedString(string json, string objectKey, string valueKey)
    {
        int keyIndex = json.IndexOf(objectKey, StringComparison.Ordinal);
        if (keyIndex < 0)
        {
            return "";
        }
        int braceStart = json.IndexOf('{', keyIndex);
        if (braceStart < 0)
        {
            return "";
        }
        int braceEnd = json.IndexOf('}', braceStart);
        if (braceEnd < 0)
        {
            return "";
        }
        return ReadString(json.Substring(braceStart, braceEnd - braceStart + 1), valueKey);
    }

    private static string ReadString(string json, string key)
    {
        var match = Regex.Match(json, Regex.Escape(key) + "\\s*:\\s*\"([^\"]*)\"");
        return match.Success ? match.Groups[1].Value : "";
    }

    private static int ReadInt(string json, string key)
    {
        var match = Regex.Match(json, Regex.Escape(key) + "\\s*:\\s*\"?(-?\\d+)\"?");
        return match.Success ? int.Parse(match.Groups[1].Value) : 0;
    }

    private static int CountActorVisuals(List<ActorVisualRecord> records, bool textured)
    {
        int count = 0;
        foreach (var record in records)
        {
            bool hasTexture = !string.IsNullOrEmpty(record.texturePath);
            if (hasTexture == textured)
            {
                count++;
            }
        }
        return count;
    }
}

public sealed class MapLayerRecord
{
    public string name;
    public string unityAssetPath;
    public int width;
    public int height;
}

public sealed class ActorVisualRecord
{
    public string side;
    public int heroDid;
    public int waveNo;
    public int model;
    public int prefab;
    public string loadStatus;
    public string texturePath;
}

public sealed class BattleAssetBackedPreviewMarker : MonoBehaviour
{
    public string visualManifestPath;
    public string loadMapPath;
    public int mapLayerCount;
    public int actorTextureFallbackCount;
    public int missingPlaceholderCount;
}
