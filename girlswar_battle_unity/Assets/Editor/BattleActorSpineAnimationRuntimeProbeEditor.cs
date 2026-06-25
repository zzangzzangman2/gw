using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text;

public static class BattleActorSpineAnimationRuntimeProbeEditor
{
    private const string ResultJsonPath = "Assets/RestoreData/battle/BATTLE_31_ACTOR_SPINE_ANIMATION_RUNTIME_PROBE_UNITY.json";
    private const string ComponentCsvPath = "Assets/RestoreData/battle/BATTLE_31_ACTOR_SPINE_ANIMATION_RUNTIME_PROBE_COMPONENTS.csv";
    private const string ScenePath = "Assets/Scenes/Battle31ActorSpineAnimationRuntimeProbe.unity";
    private const string CapturePath = "Assets/RestoreCaptures/battle_actor/Battle31ActorSpineAnimationRuntimeProbe_1920x1080.png";
    private const string BundleRoot = "C:/Users/godho/Downloads/girlswar/girlswar_merged_extracted/extracted/unity/clean_unityfs_slices";

    [MenuItem("GirlsWar/Battle/BATTLE31 Actor Spine Animation Runtime Probe")]
    public static void Build()
    {
        Directory.CreateDirectory(ProjectPath("Assets/RestoreData/battle"));
        Directory.CreateDirectory(ProjectPath("Assets/RestoreCaptures/battle_actor"));

        var targets = new List<ActorTarget>
        {
            new ActorTarget("our", "1002", "1002", "download/roleprefabsandres/battleprefabandres/1002.assetbundle", "assets/download/roleprefabsandres/battleprefabandres/1002/hero_1002.prefab", new Vector3(-2.35f, -0.35f, 0f), 0.72f),
            new ActorTarget("our", "1034", "1034", "download/roleprefabsandres/battleprefabandres/1034.assetbundle", "assets/download/roleprefabsandres/battleprefabandres/1034/hero_1034.prefab", new Vector3(-0.2f, -0.35f, 0f), 0.72f),
            new ActorTarget("enemy", "1100111", "3001", "download/roleprefabsandres/battleprefabandres/3001.assetbundle", "assets/download/roleprefabsandres/battleprefabandres/3001/hero_3001.prefab", new Vector3(2.1f, -0.2f, 0f), 0.68f),
        };

        var scene = EditorSceneManager.NewScene(NewSceneSetup.EmptyScene, NewSceneMode.Single);
        var root = new GameObject("BATTLE31_ActorSpineAnimationRuntimeProbeRoot");
        var cameraObject = new GameObject("BATTLE31_StaticProbeCamera");
        var camera = cameraObject.AddComponent<Camera>();
        camera.clearFlags = CameraClearFlags.SolidColor;
        camera.backgroundColor = new Color(0.035f, 0.037f, 0.042f, 1f);
        camera.orthographic = true;
        camera.orthographicSize = 3.4f;
        cameraObject.transform.position = new Vector3(0f, 0f, -10f);

        var lightObject = new GameObject("BATTLE31_ProbeDirectionalLight");
        var light = lightObject.AddComponent<Light>();
        light.type = LightType.Directional;
        light.intensity = 0.65f;
        lightObject.transform.rotation = Quaternion.Euler(35f, 20f, 0f);

        var results = new List<ActorProbeResult>();
        var componentRows = new List<ComponentRow>();
        var opened = new List<AssetBundle>();

        foreach (var target in targets)
        {
            var result = ProbeActor(target, root.transform, componentRows, opened);
            results.Add(result);
        }

        Capture(camera, ProjectPath(CapturePath));
        WriteCsv(ProjectPath(ComponentCsvPath), componentRows);
        WriteJson(ProjectPath(ResultJsonPath), results, componentRows);
        EditorSceneManager.SaveScene(scene, ScenePath);
        foreach (var bundle in opened)
        {
            if (bundle != null) bundle.Unload(false);
        }
        AssetDatabase.Refresh();
        Debug.Log("BATTLE31 actor spine animation runtime probe complete. actors=" + results.Count + ", componentRows=" + componentRows.Count);
    }

    private static ActorProbeResult ProbeActor(ActorTarget target, Transform root, List<ComponentRow> rows, List<AssetBundle> opened)
    {
        var result = new ActorProbeResult();
        result.side = target.side;
        result.heroDid = target.heroDid;
        result.modelId = target.modelId;
        result.bundle = target.bundle;
        result.prefabAsset = target.prefabAsset;
        result.absoluteBundlePath = Path.Combine(BundleRoot, target.bundle.Replace("/", "\\"));
        result.fileExists = File.Exists(result.absoluteBundlePath);
        if (result.fileExists) result.fileSize = new FileInfo(result.absoluteBundlePath).Length;
        if (!result.fileExists)
        {
            result.failReason = "bundle_file_not_found";
            return result;
        }

        AssetBundle bundle = AssetBundle.LoadFromFile(result.absoluteBundlePath);
        if (bundle == null)
        {
            result.failReason = "AssetBundle.LoadFromFile_returned_null";
            return result;
        }
        opened.Add(bundle);
        result.bundleLoaded = true;
        var names = bundle.GetAllAssetNames();
        result.assetNameCount = names.Length;

        foreach (string name in names)
        {
            string lower = name.ToLowerInvariant();
            if (lower.EndsWith(".prefab")) result.prefabAssetNames.Add(name);
            if (lower.Contains("skeletondata") || lower.EndsWith(".skel.bytes") || lower.EndsWith(".atlas.txt") || lower.Contains("_atlas.asset"))
            {
                result.skeletonLikeAssets.Add(name);
            }

            UnityEngine.Object asset = null;
            try { asset = bundle.LoadAsset<UnityEngine.Object>(name); }
            catch (Exception ex)
            {
                result.loadExceptions.Add(name + " :: " + Short(ex.Message));
            }
            if (asset == null) continue;
            string typeName = asset.GetType().FullName ?? asset.GetType().Name;
            result.AddAssetType(typeName);
            if (asset is TextAsset textAsset)
            {
                if (lower.EndsWith(".atlas.txt")) result.atlasTextBytes += textAsset.bytes != null ? textAsset.bytes.Length : 0;
                if (lower.EndsWith(".skel.bytes")) result.skelBytes += textAsset.bytes != null ? textAsset.bytes.Length : 0;
                if (lower.EndsWith(".atlas.txt") && string.IsNullOrEmpty(result.atlasFirstLine))
                {
                    result.atlasFirstLine = FirstLine(textAsset.text);
                }
            }
            if (asset is Texture2D texture)
            {
                result.textureNames.Add(texture.name + "(" + texture.width + "x" + texture.height + ")");
            }
            if (asset is Material material)
            {
                string shaderName = material.shader != null ? material.shader.name : "";
                string texName = material.mainTexture != null ? material.mainTexture.name : "";
                result.materialNames.Add(material.name + "|shader=" + shaderName + "|mainTex=" + texName);
            }
            if (typeName.ToLowerInvariant().Contains("animationclip")) result.animationCandidateAssets.Add(name + "|" + typeName);
            if (typeName.ToLowerInvariant().Contains("timeline")) result.timelineCandidateAssets.Add(name + "|" + typeName);
            if (typeName.ToLowerInvariant().Contains("skeleton")) result.skeletonRuntimeTypeNames.Add(typeName);
        }

        var prefab = bundle.LoadAsset<GameObject>(target.prefabAsset);
        if (prefab == null)
        {
            foreach (var prefabName in result.prefabAssetNames)
            {
                if (prefabName.ToLowerInvariant().Contains("hero_"))
                {
                    target.prefabAsset = prefabName;
                    result.prefabAsset = prefabName;
                    prefab = bundle.LoadAsset<GameObject>(prefabName);
                    break;
                }
            }
        }
        if (prefab == null)
        {
            result.failReason = "prefab_not_found";
            return result;
        }

        GameObject instance = (GameObject)GameObject.Instantiate(prefab, target.position, Quaternion.identity, root);
        instance.name = "BATTLE31_LoadableActor_" + target.side + "_" + target.heroDid + "_model_" + target.modelId;
        instance.transform.localScale = Vector3.one * target.scale;
        result.prefabInstantiated = true;
        DumpHierarchy(target, result, instance.transform, instance.name, rows);
        result.motionReplayStatus = result.missingScriptCount > 0 ? "failed_missing_runtime_spine_animation_class" : "trace_only_no_animation_state_replay";
        return result;
    }

    private static void DumpHierarchy(ActorTarget target, ActorProbeResult result, Transform transform, string path, List<ComponentRow> rows)
    {
        var components = transform.gameObject.GetComponents<Component>();
        var typeParts = new List<string>();
        foreach (var component in components)
        {
            string typeName = component == null ? "MissingScript" : (component.GetType().FullName ?? component.GetType().Name);
            typeParts.Add(typeName);
            if (component == null)
            {
                result.missingScriptCount++;
                result.missingScriptClassCandidates.Add("Spine.Unity.SkeletonAnimation|Spine.Unity.SkeletonRenderer|Spine.Unity.SkeletonMecanim");
            }
            else
            {
                string lower = typeName.ToLowerInvariant();
                if (lower.Contains("animator")) result.animatorComponentCount++;
                if (lower.Contains("animation")) result.animationComponentCount++;
                if (lower.Contains("particle")) result.particleSystemCount++;
                if (lower.Contains("playable")) result.playableDirectorCount++;
                if (lower.Contains("skeleton")) result.skeletonComponentCount++;
            }
        }

        var renderer = transform.gameObject.GetComponent<Renderer>();
        if (renderer != null)
        {
            result.rendererCount++;
            if (renderer.enabled) result.enabledRendererCount++;
        }

        var row = new ComponentRow();
        row.side = target.side;
        row.heroDid = target.heroDid;
        row.modelId = target.modelId;
        row.hierarchyPath = path;
        row.componentTypes = string.Join(";", typeParts.ToArray());
        row.rendererType = renderer != null ? renderer.GetType().Name : "";
        row.materialNames = renderer != null ? MaterialNames(renderer) : "";
        row.textureNames = renderer != null ? TextureNames(renderer) : "";
        row.localPosition = Vec(transform.localPosition);
        row.localScale = Vec(transform.localScale);
        rows.Add(row);

        for (int i = 0; i < transform.childCount; i++)
        {
            Transform child = transform.GetChild(i);
            DumpHierarchy(target, result, child, path + "/" + child.name, rows);
        }
    }

    private static void Capture(Camera camera, string fullPath)
    {
        var rt = new RenderTexture(1920, 1080, 24, RenderTextureFormat.ARGB32);
        var prevTarget = camera.targetTexture;
        var prevActive = RenderTexture.active;
        camera.targetTexture = rt;
        RenderTexture.active = rt;
        camera.Render();
        var tex = new Texture2D(1920, 1080, TextureFormat.RGB24, false);
        tex.ReadPixels(new Rect(0, 0, 1920, 1080), 0, 0);
        tex.Apply();
        File.WriteAllBytes(fullPath, tex.EncodeToPNG());
        camera.targetTexture = prevTarget;
        RenderTexture.active = prevActive;
        UnityEngine.Object.DestroyImmediate(tex);
        UnityEngine.Object.DestroyImmediate(rt);
    }

    private static string MaterialNames(Renderer renderer)
    {
        var parts = new List<string>();
        foreach (var m in renderer.sharedMaterials)
        {
            if (m != null) parts.Add(m.name);
        }
        return string.Join(";", parts.ToArray());
    }

    private static string TextureNames(Renderer renderer)
    {
        var parts = new List<string>();
        foreach (var m in renderer.sharedMaterials)
        {
            if (m != null && m.mainTexture != null) parts.Add(m.mainTexture.name);
        }
        return string.Join(";", parts.ToArray());
    }

    private static void WriteCsv(string path, List<ComponentRow> rows)
    {
        var sb = new StringBuilder();
        sb.AppendLine("side,heroDid,modelId,hierarchyPath,componentTypes,rendererType,materialNames,textureNames,localPosition,localScale");
        foreach (var row in rows)
        {
            sb.AppendLine(Csv(row.side) + "," + Csv(row.heroDid) + "," + Csv(row.modelId) + "," + Csv(row.hierarchyPath) + "," + Csv(row.componentTypes) + "," + Csv(row.rendererType) + "," + Csv(row.materialNames) + "," + Csv(row.textureNames) + "," + Csv(row.localPosition) + "," + Csv(row.localScale));
        }
        File.WriteAllText(path, sb.ToString(), new UTF8Encoding(false));
    }

    private static void WriteJson(string path, List<ActorProbeResult> results, List<ComponentRow> rows)
    {
        int loaded = Count(results, r => r.bundleLoaded);
        int instantiated = Count(results, r => r.prefabInstantiated);
        int missingScripts = 0;
        int skeletonLikeAssets = 0;
        int animationCandidates = 0;
        int timelineCandidates = 0;
        foreach (var r in results)
        {
            missingScripts += r.missingScriptCount;
            skeletonLikeAssets += r.skeletonLikeAssets.Count;
            animationCandidates += r.animationCandidateAssets.Count;
            timelineCandidates += r.timelineCandidateAssets.Count;
        }

        var sb = new StringBuilder();
        sb.AppendLine("{");
        sb.AppendLine("  \"verdict\": \"battle31_actor_spine_animation_probe_trace_only\",");
        sb.AppendLine("  \"visual_status\": \"failed_actor_motion_runtime_replay_missing\",");
        sb.AppendLine("  \"isFinalRestoredBattleScreen\": false,");
        sb.AppendLine("  \"scene\": \"" + Json(ScenePath) + "\",");
        sb.AppendLine("  \"capture\": \"" + Json(CapturePath) + "\",");
        sb.AppendLine("  \"summary\": {");
        sb.AppendLine("    \"targetActorCount\": " + results.Count + ",");
        sb.AppendLine("    \"bundleLoadSuccess\": " + loaded + ",");
        sb.AppendLine("    \"prefabInstantiateSuccess\": " + instantiated + ",");
        sb.AppendLine("    \"componentRowCount\": " + rows.Count + ",");
        sb.AppendLine("    \"missingScriptCount\": " + missingScripts + ",");
        sb.AppendLine("    \"skeletonLikeAssetCount\": " + skeletonLikeAssets + ",");
        sb.AppendLine("    \"animationCandidateAssetCount\": " + animationCandidates + ",");
        sb.AppendLine("    \"timelineCandidateAssetCount\": " + timelineCandidates);
        sb.AppendLine("  },");
        sb.AppendLine("  \"actors\": [");
        for (int i = 0; i < results.Count; i++)
        {
            var r = results[i];
            sb.AppendLine("    {");
            sb.AppendLine("      \"side\": \"" + Json(r.side) + "\",");
            sb.AppendLine("      \"heroDid\": \"" + Json(r.heroDid) + "\",");
            sb.AppendLine("      \"modelId\": \"" + Json(r.modelId) + "\",");
            sb.AppendLine("      \"bundle\": \"" + Json(r.bundle) + "\",");
            sb.AppendLine("      \"absoluteBundlePath\": \"" + Json(r.absoluteBundlePath) + "\",");
            sb.AppendLine("      \"fileExists\": " + Bool(r.fileExists) + ",");
            sb.AppendLine("      \"fileSize\": " + r.fileSize + ",");
            sb.AppendLine("      \"bundleLoaded\": " + Bool(r.bundleLoaded) + ",");
            sb.AppendLine("      \"prefabAsset\": \"" + Json(r.prefabAsset) + "\",");
            sb.AppendLine("      \"prefabInstantiated\": " + Bool(r.prefabInstantiated) + ",");
            sb.AppendLine("      \"assetNameCount\": " + r.assetNameCount + ",");
            sb.AppendLine("      \"rendererCount\": " + r.rendererCount + ",");
            sb.AppendLine("      \"enabledRendererCount\": " + r.enabledRendererCount + ",");
            sb.AppendLine("      \"missingScriptCount\": " + r.missingScriptCount + ",");
            sb.AppendLine("      \"animatorComponentCount\": " + r.animatorComponentCount + ",");
            sb.AppendLine("      \"animationComponentCount\": " + r.animationComponentCount + ",");
            sb.AppendLine("      \"particleSystemCount\": " + r.particleSystemCount + ",");
            sb.AppendLine("      \"playableDirectorCount\": " + r.playableDirectorCount + ",");
            sb.AppendLine("      \"skeletonComponentCount\": " + r.skeletonComponentCount + ",");
            sb.AppendLine("      \"atlasTextBytes\": " + r.atlasTextBytes + ",");
            sb.AppendLine("      \"skelBytes\": " + r.skelBytes + ",");
            sb.AppendLine("      \"atlasFirstLine\": \"" + Json(r.atlasFirstLine) + "\",");
            sb.AppendLine("      \"motionReplayStatus\": \"" + Json(r.motionReplayStatus) + "\",");
            sb.AppendLine("      \"failReason\": \"" + Json(r.failReason) + "\",");
            sb.AppendLine("      \"textureNames\": " + JsonArray(r.textureNames) + ",");
            sb.AppendLine("      \"materialNames\": " + JsonArray(r.materialNames) + ",");
            sb.AppendLine("      \"prefabAssetNames\": " + JsonArray(r.prefabAssetNames) + ",");
            sb.AppendLine("      \"skeletonLikeAssets\": " + JsonArray(r.skeletonLikeAssets) + ",");
            sb.AppendLine("      \"skeletonRuntimeTypeNames\": " + JsonArray(r.skeletonRuntimeTypeNames) + ",");
            sb.AppendLine("      \"animationCandidateAssets\": " + JsonArray(r.animationCandidateAssets) + ",");
            sb.AppendLine("      \"timelineCandidateAssets\": " + JsonArray(r.timelineCandidateAssets) + ",");
            sb.AppendLine("      \"missingScriptClassCandidates\": " + JsonArray(Unique(r.missingScriptClassCandidates)) + ",");
            sb.AppendLine("      \"loadExceptions\": " + JsonArray(r.loadExceptions));
            sb.Append("    }");
            if (i + 1 < results.Count) sb.Append(",");
            sb.AppendLine();
        }
        sb.AppendLine("  ]");
        sb.AppendLine("}");
        File.WriteAllText(path, sb.ToString(), new UTF8Encoding(false));
    }

    private static string ProjectPath(string assetRelativePath)
    {
        return Path.Combine(Application.dataPath, "..", assetRelativePath.Replace("/", "\\"));
    }

    private static int Count(List<ActorProbeResult> rows, Predicate<ActorProbeResult> predicate)
    {
        int count = 0;
        foreach (var row in rows) if (predicate(row)) count++;
        return count;
    }

    private static List<string> Unique(List<string> input)
    {
        var seen = new HashSet<string>();
        var output = new List<string>();
        foreach (var item in input)
        {
            if (!string.IsNullOrEmpty(item) && seen.Add(item)) output.Add(item);
        }
        return output;
    }

    private static string FirstLine(string text)
    {
        if (string.IsNullOrEmpty(text)) return "";
        using (var reader = new StringReader(text))
        {
            return reader.ReadLine() ?? "";
        }
    }

    private static string Short(string value)
    {
        if (string.IsNullOrEmpty(value)) return "";
        value = value.Replace("\r", " ").Replace("\n", " ");
        return value.Length > 180 ? value.Substring(0, 180) : value;
    }

    private static string Vec(Vector3 v)
    {
        return v.x.ToString("0.###") + "/" + v.y.ToString("0.###") + "/" + v.z.ToString("0.###");
    }

    private static string Bool(bool value)
    {
        return value ? "true" : "false";
    }

    private static string Json(string value)
    {
        if (value == null) return "";
        return value.Replace("\\", "\\\\").Replace("\"", "\\\"").Replace("\r", "\\r").Replace("\n", "\\n");
    }

    private static string JsonArray(List<string> values)
    {
        var parts = new List<string>();
        foreach (var value in values)
        {
            parts.Add("\"" + Json(value) + "\"");
        }
        return "[" + string.Join(",", parts.ToArray()) + "]";
    }

    private static string Csv(string value)
    {
        if (value == null) value = "";
        return "\"" + value.Replace("\"", "\"\"") + "\"";
    }

    private sealed class ActorTarget
    {
        public string side;
        public string heroDid;
        public string modelId;
        public string bundle;
        public string prefabAsset;
        public Vector3 position;
        public float scale;

        public ActorTarget(string side, string heroDid, string modelId, string bundle, string prefabAsset, Vector3 position, float scale)
        {
            this.side = side;
            this.heroDid = heroDid;
            this.modelId = modelId;
            this.bundle = bundle;
            this.prefabAsset = prefabAsset;
            this.position = position;
            this.scale = scale;
        }
    }

    private sealed class ActorProbeResult
    {
        public string side = "";
        public string heroDid = "";
        public string modelId = "";
        public string bundle = "";
        public string absoluteBundlePath = "";
        public string prefabAsset = "";
        public bool fileExists;
        public long fileSize;
        public bool bundleLoaded;
        public bool prefabInstantiated;
        public int assetNameCount;
        public int rendererCount;
        public int enabledRendererCount;
        public int missingScriptCount;
        public int animatorComponentCount;
        public int animationComponentCount;
        public int particleSystemCount;
        public int playableDirectorCount;
        public int skeletonComponentCount;
        public int atlasTextBytes;
        public int skelBytes;
        public string atlasFirstLine = "";
        public string motionReplayStatus = "not_evaluated";
        public string failReason = "";
        public List<string> textureNames = new List<string>();
        public List<string> materialNames = new List<string>();
        public List<string> prefabAssetNames = new List<string>();
        public List<string> skeletonLikeAssets = new List<string>();
        public List<string> skeletonRuntimeTypeNames = new List<string>();
        public List<string> animationCandidateAssets = new List<string>();
        public List<string> timelineCandidateAssets = new List<string>();
        public List<string> missingScriptClassCandidates = new List<string>();
        public List<string> loadExceptions = new List<string>();
        public Dictionary<string, int> assetTypeCounts = new Dictionary<string, int>();

        public void AddAssetType(string typeName)
        {
            if (!assetTypeCounts.ContainsKey(typeName)) assetTypeCounts[typeName] = 0;
            assetTypeCounts[typeName]++;
        }
    }

    private sealed class ComponentRow
    {
        public string side = "";
        public string heroDid = "";
        public string modelId = "";
        public string hierarchyPath = "";
        public string componentTypes = "";
        public string rendererType = "";
        public string materialNames = "";
        public string textureNames = "";
        public string localPosition = "";
        public string localScale = "";
    }
}
