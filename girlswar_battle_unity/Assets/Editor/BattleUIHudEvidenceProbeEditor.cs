using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text;

public static class BattleUIHudEvidenceProbeEditor
{
    private const string TargetsPath = "Assets/RestoreData/battle/BATTLE_UI_HUD_BUNDLE_TARGETS.csv";
    private const string ResultJsonPath = "Assets/RestoreData/battle/BATTLE_UI_HUD_BUNDLE_PROBE.json";
    private const string ResultCsvPath = "Assets/RestoreData/battle/BATTLE_UI_HUD_BUNDLE_PROBE.csv";
    private const string ScenePath = "Assets/Scenes/BattleUIHudEvidenceProbe.unity";

    [MenuItem("GirlsWar/Battle/Probe Battle UI HUD Evidence")]
    public static void Build()
    {
        var targets = ReadTargets(ProjectPath(TargetsPath));
        var scene = EditorSceneManager.NewScene(NewSceneSetup.EmptyScene, NewSceneMode.Single);
        var root = new GameObject("BattleUIHudEvidenceProbeRoot");

        var cameraObject = new GameObject("BattleUIHudEvidenceCamera");
        var camera = cameraObject.AddComponent<Camera>();
        camera.orthographic = true;
        camera.orthographicSize = 7.4f;
        camera.backgroundColor = new Color(0.035f, 0.04f, 0.045f, 1f);
        camera.clearFlags = CameraClearFlags.SolidColor;
        cameraObject.transform.position = new Vector3(0f, 0f, -10f);

        var results = new List<BattleUIHudProbeResult>();
        for (int i = 0; i < targets.Count; i++)
        {
            results.Add(Probe(targets[i], root.transform, i));
        }

        WriteCsv(ProjectPath(ResultCsvPath), results);
        WriteJson(ProjectPath(ResultJsonPath), results);
        EditorSceneManager.SaveScene(scene, ScenePath);
        AssetDatabase.Refresh();

        int success = Count(results, r => r.loadSuccess);
        int prefabs = Sum(results, r => r.prefabRootCount);
        int buttons = Sum(results, r => r.buttonComponentCount);
        Debug.Log("BattleUIHudEvidenceProbe generated. targets=" + results.Count + ", success=" + success + ", prefabs=" + prefabs + ", buttons=" + buttons);
    }

    private static BattleUIHudProbeResult Probe(BattleUIHudTarget target, Transform root, int index)
    {
        var result = new BattleUIHudProbeResult(target);
        result.fileExists = File.Exists(target.absolutePath);
        if (result.fileExists)
        {
            result.size = new FileInfo(target.absolutePath).Length;
            result.unityFsHeader = Header(target.absolutePath);
        }
        if (!result.fileExists)
        {
            result.failReason = "file_not_found";
            CreateMarker(root, target.id, index, Color.red, target.bundle + "\nfile_not_found");
            return result;
        }

        AssetBundle bundle = null;
        try
        {
            bundle = AssetBundle.LoadFromFile(target.absolutePath);
            if (bundle == null)
            {
                result.failReason = "AssetBundle.LoadFromFile_returned_null";
                CreateMarker(root, target.id, index, Color.red, target.bundle + "\nLoadFromFile null");
                return result;
            }
            result.loadSuccess = true;
            string[] assetNames = bundle.GetAllAssetNames();
            result.assetNameCount = assetNames.Length;
            result.assetNameSample = Sample(assetNames, 14);

            GameObject firstUiPrefab = null;
            string firstUiPrefabAsset = "";
            foreach (string assetName in assetNames)
            {
                UnityEngine.Object asset = null;
                try
                {
                    asset = bundle.LoadAsset<UnityEngine.Object>(assetName);
                }
                catch (Exception ex)
                {
                    result.dependencyMissing = true;
                    result.dependencyNotes += Short(ex.Message) + ";";
                    continue;
                }
                if (asset == null) continue;
                result.AddAssetType(asset.GetType().Name);
                if (asset is GameObject go)
                {
                    result.prefabRootCount++;
                    if (result.prefabRootSample.Length < 900)
                    {
                        if (result.prefabRootSample.Length > 0) result.prefabRootSample += ";";
                        result.prefabRootSample += assetName;
                    }
                    var componentCounts = CountPrefabComponents(go);
                    result.AddComponentCounts(componentCounts);
                    if (firstUiPrefab == null && (componentCounts.rectTransform > 0 || componentCounts.canvas > 0 || componentCounts.button > 0 || componentCounts.image > 0))
                    {
                        firstUiPrefab = go;
                        firstUiPrefabAsset = assetName;
                    }
                }
            }

            if (firstUiPrefab != null)
            {
                try
                {
                    var instance = (GameObject)GameObject.Instantiate(firstUiPrefab);
                    instance.name = "UIHudEvidencePrefabValidation_" + target.id;
                    result.prefabInstantiateSuccess = true;
                    result.instantiatedPrefabAsset = firstUiPrefabAsset;
                    GameObject.DestroyImmediate(instance);
                }
                catch (Exception ex)
                {
                    result.failReason = "prefab_instantiate_failed:" + Short(ex.Message);
                }
            }
            Color color = result.prefabRootCount > 0 ? Color.green : (result.spriteCount > 0 ? Color.cyan : Color.yellow);
            CreateMarker(root, target.id, index, color, target.bundle + "\nprefabs " + result.prefabRootCount + " rect " + result.rectTransformCount + "\nimg " + result.imageComponentCount + " text " + (result.textComponentCount + result.tmpComponentCount) + " btn " + result.buttonComponentCount);
        }
        catch (Exception ex)
        {
            result.loadSuccess = false;
            result.failReason = "load_exception:" + Short(ex.Message);
            CreateMarker(root, target.id, index, Color.red, target.bundle + "\n" + result.failReason);
        }
        finally
        {
            if (bundle != null) bundle.Unload(false);
        }
        return result;
    }

    private static ComponentCount CountPrefabComponents(GameObject go)
    {
        var count = new ComponentCount();
        foreach (var component in go.GetComponentsInChildren<Component>(true))
        {
            if (component == null)
            {
                count.missingScript++;
                continue;
            }
            string typeName = component.GetType().Name;
            if (typeName == "RectTransform") count.rectTransform++;
            else if (typeName == "Image") count.image++;
            else if (typeName == "RawImage") count.rawImage++;
            else if (typeName == "Text") count.text++;
            else if (typeName == "TextMeshProUGUI" || typeName.Contains("TMP")) count.tmp++;
            else if (typeName == "Button") count.button++;
            else if (typeName == "Canvas") count.canvas++;
            else if (typeName == "CanvasScaler") count.canvasScaler++;
            else if (typeName == "GraphicRaycaster") count.graphicRaycaster++;
            else if (typeName == "Animator") count.animator++;
            else if (typeName == "CanvasGroup") count.canvasGroup++;
        }
        return count;
    }

    private static void CreateMarker(Transform root, string id, int index, Color color, string label)
    {
        var marker = GameObject.CreatePrimitive(PrimitiveType.Cube);
        marker.name = "BattleUIHudProbeMarker_" + id;
        marker.transform.SetParent(root);
        marker.transform.position = PositionFor(index);
        marker.transform.localScale = new Vector3(1.45f, 0.65f, 0.1f);
        var renderer = marker.GetComponent<Renderer>();
        var material = new Material(Shader.Find("Standard"));
        material.color = color;
        renderer.sharedMaterial = material;
        AddLabel(marker.transform, label, new Vector3(0f, -0.65f, -0.2f), 0.075f);
    }

    private static Vector3 PositionFor(int index)
    {
        float x = -5.6f + (index % 4) * 3.75f;
        float y = 4.75f - (index / 4) * 1.95f;
        return new Vector3(x, y, 0f);
    }

    private static void AddLabel(Transform parent, string text, Vector3 localPosition, float size)
    {
        var label = new GameObject("HUDProbeLabel");
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

    private static List<BattleUIHudTarget> ReadTargets(string path)
    {
        var list = new List<BattleUIHudTarget>();
        if (!File.Exists(path)) return list;
        var lines = File.ReadAllLines(path, Encoding.UTF8);
        for (int i = 1; i < lines.Length; i++)
        {
            if (string.IsNullOrWhiteSpace(lines[i])) continue;
            var parts = SplitCsvLine(lines[i]);
            if (parts.Count < 6) continue;
            list.Add(new BattleUIHudTarget
            {
                id = parts[0],
                kind = parts[1],
                bundle = parts[2],
                absolutePath = parts[3],
                priority = parts[4],
                hudScopes = parts[5],
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

    private static void WriteCsv(string path, List<BattleUIHudProbeResult> results)
    {
        var lines = new List<string>();
        lines.Add("id,kind,bundle,absolutePath,fileExists,unityFsHeader,size,loadSuccess,failReason,assetNameCount,gameObjectCount,spriteCount,texture2DCount,materialCount,textAssetCount,fontCount,prefabRootCount,prefabInstantiateSuccess,instantiatedPrefabAsset,rectTransformCount,imageComponentCount,rawImageComponentCount,textComponentCount,tmpComponentCount,buttonComponentCount,canvasCount,canvasScalerCount,graphicRaycasterCount,animatorCount,canvasGroupCount,missingScriptCount,prefabRootSample,assetNameSample,dependencyMissing,dependencyNotes,hudScopes");
        foreach (var r in results)
        {
            lines.Add(string.Join(",", new[]
            {
                Csv(r.id), Csv(r.kind), Csv(r.bundle), Csv(r.absolutePath), Csv(Bool(r.fileExists)), Csv(r.unityFsHeader), Csv(r.size.ToString()), Csv(Bool(r.loadSuccess)), Csv(r.failReason),
                Csv(r.assetNameCount.ToString()), Csv(r.gameObjectCount.ToString()), Csv(r.spriteCount.ToString()), Csv(r.texture2DCount.ToString()), Csv(r.materialCount.ToString()), Csv(r.textAssetCount.ToString()), Csv(r.fontCount.ToString()),
                Csv(r.prefabRootCount.ToString()), Csv(Bool(r.prefabInstantiateSuccess)), Csv(r.instantiatedPrefabAsset), Csv(r.rectTransformCount.ToString()), Csv(r.imageComponentCount.ToString()), Csv(r.rawImageComponentCount.ToString()),
                Csv(r.textComponentCount.ToString()), Csv(r.tmpComponentCount.ToString()), Csv(r.buttonComponentCount.ToString()), Csv(r.canvasCount.ToString()), Csv(r.canvasScalerCount.ToString()), Csv(r.graphicRaycasterCount.ToString()),
                Csv(r.animatorCount.ToString()), Csv(r.canvasGroupCount.ToString()), Csv(r.missingScriptCount.ToString()), Csv(r.prefabRootSample), Csv(r.assetNameSample), Csv(Bool(r.dependencyMissing)), Csv(r.dependencyNotes), Csv(r.hudScopes)
            }));
        }
        File.WriteAllLines(path, lines, Encoding.UTF8);
    }

    private static void WriteJson(string path, List<BattleUIHudProbeResult> results)
    {
        var sb = new StringBuilder();
        sb.AppendLine("{");
        sb.AppendLine("  \"status\": \"battle_ui_hud_bundle_probe_complete\",");
        sb.AppendLine("  \"scene\": \"Assets/Scenes/BattleUIHudEvidenceProbe.unity\",");
        sb.AppendLine("  \"targetsCsv\": \"" + Json(TargetsPath) + "\",");
        sb.AppendLine("  \"summary\": {");
        sb.AppendLine("    \"targetCount\": " + results.Count + ",");
        sb.AppendLine("    \"loadSuccess\": " + Count(results, r => r.loadSuccess) + ",");
        sb.AppendLine("    \"loadFail\": " + Count(results, r => !r.loadSuccess) + ",");
        sb.AppendLine("    \"prefabRootCount\": " + Sum(results, r => r.prefabRootCount) + ",");
        sb.AppendLine("    \"canvasCount\": " + Sum(results, r => r.canvasCount) + ",");
        sb.AppendLine("    \"imageCount\": " + Sum(results, r => r.imageComponentCount) + ",");
        sb.AppendLine("    \"textCount\": " + Sum(results, r => r.textComponentCount + r.tmpComponentCount) + ",");
        sb.AppendLine("    \"buttonCount\": " + Sum(results, r => r.buttonComponentCount));
        sb.AppendLine("  },");
        sb.AppendLine("  \"results\": [");
        for (int i = 0; i < results.Count; i++)
        {
            var r = results[i];
            sb.AppendLine("    {");
            sb.AppendLine("      \"id\": \"" + Json(r.id) + "\",");
            sb.AppendLine("      \"kind\": \"" + Json(r.kind) + "\",");
            sb.AppendLine("      \"bundle\": \"" + Json(r.bundle) + "\",");
            sb.AppendLine("      \"absolutePath\": \"" + Json(r.absolutePath) + "\",");
            sb.AppendLine("      \"hudScopes\": \"" + Json(r.hudScopes) + "\",");
            sb.AppendLine("      \"fileExists\": " + Bool(r.fileExists) + ",");
            sb.AppendLine("      \"unityFsHeader\": \"" + Json(r.unityFsHeader) + "\",");
            sb.AppendLine("      \"size\": " + r.size + ",");
            sb.AppendLine("      \"loadSuccess\": " + Bool(r.loadSuccess) + ",");
            sb.AppendLine("      \"failReason\": \"" + Json(r.failReason) + "\",");
            sb.AppendLine("      \"assetNameCount\": " + r.assetNameCount + ",");
            sb.AppendLine("      \"assetNameSample\": \"" + Json(r.assetNameSample) + "\",");
            sb.AppendLine("      \"typeCounts\": {\"GameObject\": " + r.gameObjectCount + ", \"Sprite\": " + r.spriteCount + ", \"Texture2D\": " + r.texture2DCount + ", \"Material\": " + r.materialCount + ", \"TextAsset\": " + r.textAssetCount + ", \"Font\": " + r.fontCount + "},");
            sb.AppendLine("      \"gameObjectCount\": " + r.gameObjectCount + ",");
            sb.AppendLine("      \"spriteCount\": " + r.spriteCount + ",");
            sb.AppendLine("      \"texture2DCount\": " + r.texture2DCount + ",");
            sb.AppendLine("      \"materialCount\": " + r.materialCount + ",");
            sb.AppendLine("      \"textAssetCount\": " + r.textAssetCount + ",");
            sb.AppendLine("      \"fontCount\": " + r.fontCount + ",");
            sb.AppendLine("      \"prefabRootCount\": " + r.prefabRootCount + ",");
            sb.AppendLine("      \"prefabRootSample\": \"" + Json(r.prefabRootSample) + "\",");
            sb.AppendLine("      \"prefabInstantiateSuccess\": " + Bool(r.prefabInstantiateSuccess) + ",");
            sb.AppendLine("      \"instantiatedPrefabAsset\": \"" + Json(r.instantiatedPrefabAsset) + "\",");
            sb.AppendLine("      \"rectTransformCount\": " + r.rectTransformCount + ",");
            sb.AppendLine("      \"imageComponentCount\": " + r.imageComponentCount + ",");
            sb.AppendLine("      \"rawImageComponentCount\": " + r.rawImageComponentCount + ",");
            sb.AppendLine("      \"textComponentCount\": " + r.textComponentCount + ",");
            sb.AppendLine("      \"tmpComponentCount\": " + r.tmpComponentCount + ",");
            sb.AppendLine("      \"buttonComponentCount\": " + r.buttonComponentCount + ",");
            sb.AppendLine("      \"canvasCount\": " + r.canvasCount + ",");
            sb.AppendLine("      \"canvasScalerCount\": " + r.canvasScalerCount + ",");
            sb.AppendLine("      \"graphicRaycasterCount\": " + r.graphicRaycasterCount + ",");
            sb.AppendLine("      \"animatorCount\": " + r.animatorCount + ",");
            sb.AppendLine("      \"canvasGroupCount\": " + r.canvasGroupCount + ",");
            sb.AppendLine("      \"missingScriptCount\": " + r.missingScriptCount + ",");
            sb.AppendLine("      \"dependencyMissing\": " + Bool(r.dependencyMissing) + ",");
            sb.AppendLine("      \"dependencyNotes\": \"" + Json(r.dependencyNotes) + "\"");
            sb.Append("    }");
            if (i + 1 < results.Count) sb.Append(",");
            sb.AppendLine();
        }
        sb.AppendLine("  ],");
        sb.AppendLine("  \"note\": \"Evidence probe only. Do not treat markers or whole atlases as final HUD restoration.\"");
        sb.AppendLine("}");
        File.WriteAllText(path, sb.ToString(), Encoding.UTF8);
    }

    private static string Header(string path)
    {
        try
        {
            byte[] data = File.ReadAllBytes(path);
            int length = Math.Min(16, data.Length);
            return Encoding.ASCII.GetString(data, 0, length);
        }
        catch
        {
            return "";
        }
    }

    private static int Count(List<BattleUIHudProbeResult> results, Func<BattleUIHudProbeResult, bool> predicate)
    {
        int count = 0;
        foreach (var r in results) if (predicate(r)) count++;
        return count;
    }

    private static int Sum(List<BattleUIHudProbeResult> results, Func<BattleUIHudProbeResult, int> selector)
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
        if (string.IsNullOrEmpty(value)) return "";
        var sb = new StringBuilder();
        foreach (char c in value)
        {
            if (c == '\\') sb.Append("\\\\");
            else if (c == '"') sb.Append("\\\"");
            else if (c == '\r' || c == '\n') sb.Append(' ');
            else if (c < 32) sb.Append("\\u").Append(((int)c).ToString("x4"));
            else sb.Append(c);
        }
        return sb.ToString();
    }

    private static string Bool(bool value)
    {
        return value ? "true" : "false";
    }
}

public sealed class BattleUIHudTarget
{
    public string id;
    public string kind;
    public string bundle;
    public string absolutePath;
    public string priority;
    public string hudScopes;
}

public sealed class ComponentCount
{
    public int rectTransform;
    public int image;
    public int rawImage;
    public int text;
    public int tmp;
    public int button;
    public int canvas;
    public int canvasScaler;
    public int graphicRaycaster;
    public int animator;
    public int canvasGroup;
    public int missingScript;
}

public sealed class BattleUIHudProbeResult
{
    public string id;
    public string kind;
    public string bundle;
    public string absolutePath;
    public string hudScopes;
    public bool fileExists;
    public string unityFsHeader = "";
    public long size;
    public bool loadSuccess;
    public string failReason = "";
    public int assetNameCount;
    public string assetNameSample = "";
    public int gameObjectCount;
    public int spriteCount;
    public int texture2DCount;
    public int materialCount;
    public int textAssetCount;
    public int fontCount;
    public int prefabRootCount;
    public string prefabRootSample = "";
    public bool prefabInstantiateSuccess;
    public string instantiatedPrefabAsset = "";
    public int rectTransformCount;
    public int imageComponentCount;
    public int rawImageComponentCount;
    public int textComponentCount;
    public int tmpComponentCount;
    public int buttonComponentCount;
    public int canvasCount;
    public int canvasScalerCount;
    public int graphicRaycasterCount;
    public int animatorCount;
    public int canvasGroupCount;
    public int missingScriptCount;
    public bool dependencyMissing;
    public string dependencyNotes = "";

    public BattleUIHudProbeResult(BattleUIHudTarget target)
    {
        id = target.id;
        kind = target.kind;
        bundle = target.bundle;
        absolutePath = target.absolutePath;
        hudScopes = target.hudScopes;
    }

    public void AddAssetType(string typeName)
    {
        if (typeName == "GameObject") gameObjectCount++;
        else if (typeName == "Sprite") spriteCount++;
        else if (typeName == "Texture2D") texture2DCount++;
        else if (typeName == "Material") materialCount++;
        else if (typeName == "TextAsset") textAssetCount++;
        else if (typeName == "Font" || typeName.Contains("Font")) fontCount++;
    }

    public void AddComponentCounts(ComponentCount counts)
    {
        rectTransformCount += counts.rectTransform;
        imageComponentCount += counts.image;
        rawImageComponentCount += counts.rawImage;
        textComponentCount += counts.text;
        tmpComponentCount += counts.tmp;
        buttonComponentCount += counts.button;
        canvasCount += counts.canvas;
        canvasScalerCount += counts.canvasScaler;
        graphicRaycasterCount += counts.graphicRaycaster;
        animatorCount += counts.animator;
        canvasGroupCount += counts.canvasGroup;
        missingScriptCount += counts.missingScript;
    }
}
