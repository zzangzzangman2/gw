using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using System;
using System.Collections.Generic;
using System.IO;
using System.Reflection;
using System.Text;

public static class BattleActorSpineRuntimeClassIdleMotionReplayEditor
{
    private const string ResultJsonPath = "Assets/RestoreData/battle/BATTLE_32_ACTOR_SPINE_RUNTIME_CLASS_IDLE_MOTION_REPLAY_UNITY.json";
    private const string ComponentCsvPath = "Assets/RestoreData/battle/BATTLE_32_ACTOR_SPINE_RUNTIME_CLASS_IDLE_MOTION_REPLAY_COMPONENTS.csv";
    private const string ScenePath = "Assets/Scenes/Battle32ActorSpineRuntimeClassIdleMotionReplay.unity";
    private const string CapturePath = "Assets/RestoreCaptures/battle_actor/Battle32ActorSpineRuntimeClassIdleMotionReplay_1920x1080.png";
    private const string BundleRoot = "C:/Users/godho/Downloads/girlswar/girlswar_merged_extracted/extracted/unity/clean_unityfs_slices";
    private const string SpineShaderBundle = "download/commonprefabsandres/spinematandshaders.assetbundle";

    [MenuItem("GirlsWar/Battle/BATTLE32 Resolve Actor Spine Runtime Class And Idle Motion Replay")]
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
        var root = new GameObject("BATTLE32_ActorSpineRuntimeClassIdleMotionReplayRoot");
        var cameraObject = new GameObject("BATTLE32_StaticProbeCamera");
        var camera = cameraObject.AddComponent<Camera>();
        camera.clearFlags = CameraClearFlags.SolidColor;
        camera.backgroundColor = new Color(0.035f, 0.037f, 0.042f, 1f);
        camera.orthographic = true;
        camera.orthographicSize = 3.4f;
        cameraObject.transform.position = new Vector3(0f, 0f, -10f);

        var lightObject = new GameObject("BATTLE32_ProbeDirectionalLight");
        var light = lightObject.AddComponent<Light>();
        light.type = LightType.Directional;
        light.intensity = 0.65f;
        lightObject.transform.rotation = Quaternion.Euler(35f, 20f, 0f);

        var opened = new List<AssetBundle>();
        var shaderInfo = LoadSpineShaderDependency(opened);
        var spineShader = Shader.Find("Spine/Skeleton");
        var results = new List<ActorProbeResult>();
        var componentRows = new List<ComponentRow>();

        foreach (var target in targets)
        {
            results.Add(ProbeActor(target, root.transform, componentRows, opened, spineShader));
        }

        Capture(camera, ProjectPath(CapturePath));
        WriteCsv(ProjectPath(ComponentCsvPath), componentRows);
        WriteJson(ProjectPath(ResultJsonPath), results, componentRows, shaderInfo, spineShader != null);
        EditorSceneManager.SaveScene(scene, ScenePath);

        foreach (var bundle in opened)
        {
            if (bundle != null) bundle.Unload(false);
        }
        AssetDatabase.Refresh();
        Debug.Log("BATTLE32 actor spine runtime class idle motion replay probe complete. actors=" + results.Count + ", componentRows=" + componentRows.Count);
    }

    private static ShaderDependencyInfo LoadSpineShaderDependency(List<AssetBundle> opened)
    {
        var info = new ShaderDependencyInfo();
        info.bundle = SpineShaderBundle;
        info.absolutePath = Path.Combine(BundleRoot, SpineShaderBundle.Replace("/", "\\"));
        info.fileExists = File.Exists(info.absolutePath);
        if (info.fileExists) info.fileSize = new FileInfo(info.absolutePath).Length;
        if (!info.fileExists)
        {
            info.status = "file_not_found";
            return info;
        }
        var bundle = AssetBundle.LoadFromFile(info.absolutePath);
        if (bundle == null)
        {
            info.status = "load_from_file_null";
            return info;
        }
        opened.Add(bundle);
        info.loaded = true;
        info.status = "loaded";
        foreach (string name in bundle.GetAllAssetNames())
        {
            info.assetNames.Add(name);
            UnityEngine.Object asset = null;
            try { asset = bundle.LoadAsset<UnityEngine.Object>(name); }
            catch (Exception ex) { info.loadExceptions.Add(name + " :: " + Short(ex.Message)); }
            if (asset == null) continue;
            string typeName = asset.GetType().FullName ?? asset.GetType().Name;
            info.assetTypes.Add(name + "|" + typeName);
            if (asset is Shader shader)
            {
                info.shaderNames.Add(shader.name);
            }
            if (asset is Material material)
            {
                string shaderName = material.shader != null ? material.shader.name : "";
                info.materialNames.Add(material.name + "|shader=" + shaderName);
            }
        }
        return info;
    }

    private static ActorProbeResult ProbeActor(ActorTarget target, Transform root, List<ComponentRow> rows, List<AssetBundle> opened, Shader spineShader)
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

        var bundle = AssetBundle.LoadFromFile(result.absoluteBundlePath);
        if (bundle == null)
        {
            result.failReason = "AssetBundle.LoadFromFile_returned_null";
            return result;
        }
        opened.Add(bundle);
        result.bundleLoaded = true;

        foreach (string name in bundle.GetAllAssetNames())
        {
            result.assetNameCount++;
            string lower = name.ToLowerInvariant();
            if (lower.EndsWith(".prefab")) result.prefabAssetNames.Add(name);
            if (lower.Contains("skeletondata") || lower.EndsWith(".skel.bytes") || lower.EndsWith(".atlas.txt") || lower.Contains("_atlas.asset"))
            {
                result.skeletonLikeAssets.Add(name);
            }
            UnityEngine.Object asset = null;
            try { asset = bundle.LoadAsset<UnityEngine.Object>(name); }
            catch (Exception ex) { result.loadExceptions.Add(name + " :: " + Short(ex.Message)); }
            if (asset == null) continue;
            string typeName = asset.GetType().FullName ?? asset.GetType().Name;
            result.AddAssetType(typeName);
            if (asset is TextAsset textAsset)
            {
                if (lower.EndsWith(".atlas.txt"))
                {
                    result.atlasTextBytes += textAsset.bytes != null ? textAsset.bytes.Length : 0;
                    if (string.IsNullOrEmpty(result.atlasFirstLine)) result.atlasFirstLine = FirstLine(textAsset.text);
                }
                if (lower.EndsWith(".skel.bytes"))
                {
                    result.skelBytes += textAsset.bytes != null ? textAsset.bytes.Length : 0;
                    result.idleStringInSkelBytes = ContainsAscii(textAsset.bytes, "idle");
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
                result.materialNamesBefore.Add(material.name + "|shader=" + shaderName + "|mainTex=" + texName);
            }
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

        var instance = (GameObject)GameObject.Instantiate(prefab, target.position, Quaternion.identity, root);
        instance.name = "BATTLE32_LoadableActor_" + target.side + "_" + target.heroDid + "_model_" + target.modelId;
        instance.transform.localScale = Vector3.one * target.scale;
        result.prefabInstantiated = true;

        ApplyShaderFallback(instance, spineShader, result);
        AttemptIdleReplay(instance, result);
        DumpHierarchy(target, result, instance.transform, instance.name, rows);
        result.motionReplayStatus = result.idleReplaySucceeded ? "idle_replay_component_call_succeeded_but_visual_motion_not_verified" : "failed_idle_motion_replay_runtime_bridge_incomplete";
        return result;
    }

    private static void ApplyShaderFallback(GameObject instance, Shader spineShader, ActorProbeResult result)
    {
        foreach (var renderer in instance.GetComponentsInChildren<Renderer>(true))
        {
            foreach (var material in renderer.sharedMaterials)
            {
                if (material == null) continue;
                string before = material.shader != null ? material.shader.name : "";
                if (before == "Hidden/InternalErrorShader" || before.ToLowerInvariant().Contains("error"))
                {
                    result.internalErrorShaderMaterialCount++;
                    if (spineShader != null)
                    {
                        material.shader = spineShader;
                        result.shaderFallbackAppliedCount++;
                    }
                }
                string after = material.shader != null ? material.shader.name : "";
                string texName = material.mainTexture != null ? material.mainTexture.name : "";
                result.materialNamesAfter.Add(material.name + "|before=" + before + "|after=" + after + "|mainTex=" + texName);
            }
        }
    }

    private static void AttemptIdleReplay(GameObject instance, ActorProbeResult result)
    {
        foreach (var component in instance.GetComponentsInChildren<Component>(true))
        {
            if (component == null) continue;
            string typeName = component.GetType().FullName ?? component.GetType().Name;
            if (typeName == "Spine.Unity.SkeletonAnimation")
            {
                result.skeletonAnimationComponentCount++;
                try
                {
                    var startingAnimation = component.GetType().GetField("startingAnimation", BindingFlags.Public | BindingFlags.Instance);
                    if (startingAnimation != null) startingAnimation.SetValue(component, "idle");
                    var startingLoop = component.GetType().GetField("startingLoop", BindingFlags.Public | BindingFlags.Instance);
                    if (startingLoop != null) startingLoop.SetValue(component, true);
                    var initialize = component.GetType().GetMethod("Initialize", new[] { typeof(bool), typeof(bool) });
                    if (initialize != null) initialize.Invoke(component, new object[] { true, true });
                    var setAnimation = component.GetType().GetMethod("SetAnimation", new[] { typeof(int), typeof(string), typeof(bool) });
                    if (setAnimation != null)
                    {
                        setAnimation.Invoke(component, new object[] { 0, "idle", true });
                        result.idleReplaySucceeded = true;
                    }
                    else
                    {
                        result.idleReplayAttemptReason = "SkeletonAnimation resolved but SetAnimation method missing";
                    }
                }
                catch (Exception ex)
                {
                    result.idleReplayAttemptReason = Short(ex.Message);
                }
            }
            else if (typeName.Contains("SkeletonRenderer"))
            {
                result.skeletonRendererComponentCount++;
            }
            else if (typeName.Contains("SkeletonMecanim"))
            {
                result.skeletonMecanimComponentCount++;
            }
        }
        if (result.skeletonAnimationComponentCount == 0 && string.IsNullOrEmpty(result.idleReplayAttemptReason))
        {
            result.idleReplayAttemptReason = "SkeletonAnimation component not resolved from original MissingScript";
        }
    }

    private static void DumpHierarchy(ActorTarget target, ActorProbeResult result, Transform transform, string path, List<ComponentRow> rows)
    {
        var components = transform.gameObject.GetComponents<Component>();
        var typeParts = new List<string>();
        foreach (var component in components)
        {
            string typeName = component == null ? "MissingScript" : (component.GetType().FullName ?? component.GetType().Name);
            typeParts.Add(typeName);
            if (component == null) result.missingScriptCount++;
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

        rows.Add(new ComponentRow
        {
            side = target.side,
            heroDid = target.heroDid,
            modelId = target.modelId,
            hierarchyPath = path,
            componentTypes = string.Join(";", typeParts.ToArray()),
            rendererType = renderer != null ? renderer.GetType().Name : "",
            materialNames = renderer != null ? MaterialNames(renderer) : "",
            shaderNames = renderer != null ? ShaderNames(renderer) : "",
            textureNames = renderer != null ? TextureNames(renderer) : "",
            localPosition = Vec(transform.localPosition),
            localScale = Vec(transform.localScale),
        });

        for (int i = 0; i < transform.childCount; i++)
        {
            var child = transform.GetChild(i);
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

    private static void WriteCsv(string path, List<ComponentRow> rows)
    {
        var sb = new StringBuilder();
        sb.AppendLine("side,heroDid,modelId,hierarchyPath,componentTypes,rendererType,materialNames,shaderNames,textureNames,localPosition,localScale");
        foreach (var row in rows)
        {
            sb.AppendLine(Csv(row.side) + "," + Csv(row.heroDid) + "," + Csv(row.modelId) + "," + Csv(row.hierarchyPath) + "," + Csv(row.componentTypes) + "," + Csv(row.rendererType) + "," + Csv(row.materialNames) + "," + Csv(row.shaderNames) + "," + Csv(row.textureNames) + "," + Csv(row.localPosition) + "," + Csv(row.localScale));
        }
        File.WriteAllText(path, sb.ToString(), new UTF8Encoding(false));
    }

    private static void WriteJson(string path, List<ActorProbeResult> results, List<ComponentRow> rows, ShaderDependencyInfo shaderInfo, bool localSpineShaderFound)
    {
        int loaded = Count(results, r => r.bundleLoaded);
        int instantiated = Count(results, r => r.prefabInstantiated);
        int missingScripts = 0;
        int skeletonLikeAssets = 0;
        int shaderFallbacks = 0;
        int skeletonAnimations = 0;
        int idleReplaySucceeded = 0;
        foreach (var r in results)
        {
            missingScripts += r.missingScriptCount;
            skeletonLikeAssets += r.skeletonLikeAssets.Count;
            shaderFallbacks += r.shaderFallbackAppliedCount;
            skeletonAnimations += r.skeletonAnimationComponentCount;
            if (r.idleReplaySucceeded) idleReplaySucceeded++;
        }

        var sb = new StringBuilder();
        sb.AppendLine("{");
        sb.AppendLine("  \"verdict\": \"battle32_runtime_class_shader_probe_trace_only\",");
        sb.AppendLine("  \"visual_status\": \"failed_actor_idle_motion_not_replayed\",");
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
        sb.AppendLine("    \"skeletonAnimationComponentCount\": " + skeletonAnimations + ",");
        sb.AppendLine("    \"idleReplaySucceededCount\": " + idleReplaySucceeded + ",");
        sb.AppendLine("    \"shaderFallbackAppliedCount\": " + shaderFallbacks + ",");
        sb.AppendLine("    \"localSpineShaderFound\": " + Bool(localSpineShaderFound));
        sb.AppendLine("  },");
        sb.AppendLine("  \"shaderDependency\": {");
        sb.AppendLine("    \"bundle\": \"" + Json(shaderInfo.bundle) + "\",");
        sb.AppendLine("    \"absolutePath\": \"" + Json(shaderInfo.absolutePath) + "\",");
        sb.AppendLine("    \"fileExists\": " + Bool(shaderInfo.fileExists) + ",");
        sb.AppendLine("    \"fileSize\": " + shaderInfo.fileSize + ",");
        sb.AppendLine("    \"loaded\": " + Bool(shaderInfo.loaded) + ",");
        sb.AppendLine("    \"status\": \"" + Json(shaderInfo.status) + "\",");
        sb.AppendLine("    \"shaderNames\": " + JsonArray(shaderInfo.shaderNames) + ",");
        sb.AppendLine("    \"materialNames\": " + JsonArray(shaderInfo.materialNames) + ",");
        sb.AppendLine("    \"assetTypes\": " + JsonArray(shaderInfo.assetTypes) + ",");
        sb.AppendLine("    \"loadExceptions\": " + JsonArray(shaderInfo.loadExceptions));
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
            sb.AppendLine("      \"skeletonComponentCount\": " + r.skeletonComponentCount + ",");
            sb.AppendLine("      \"skeletonAnimationComponentCount\": " + r.skeletonAnimationComponentCount + ",");
            sb.AppendLine("      \"skeletonRendererComponentCount\": " + r.skeletonRendererComponentCount + ",");
            sb.AppendLine("      \"skeletonMecanimComponentCount\": " + r.skeletonMecanimComponentCount + ",");
            sb.AppendLine("      \"shaderFallbackAppliedCount\": " + r.shaderFallbackAppliedCount + ",");
            sb.AppendLine("      \"internalErrorShaderMaterialCount\": " + r.internalErrorShaderMaterialCount + ",");
            sb.AppendLine("      \"atlasTextBytes\": " + r.atlasTextBytes + ",");
            sb.AppendLine("      \"skelBytes\": " + r.skelBytes + ",");
            sb.AppendLine("      \"atlasFirstLine\": \"" + Json(r.atlasFirstLine) + "\",");
            sb.AppendLine("      \"idleStringInSkelBytes\": " + Bool(r.idleStringInSkelBytes) + ",");
            sb.AppendLine("      \"idleReplaySucceeded\": " + Bool(r.idleReplaySucceeded) + ",");
            sb.AppendLine("      \"idleReplayAttemptReason\": \"" + Json(r.idleReplayAttemptReason) + "\",");
            sb.AppendLine("      \"motionReplayStatus\": \"" + Json(r.motionReplayStatus) + "\",");
            sb.AppendLine("      \"failReason\": \"" + Json(r.failReason) + "\",");
            sb.AppendLine("      \"textureNames\": " + JsonArray(r.textureNames) + ",");
            sb.AppendLine("      \"materialNamesBefore\": " + JsonArray(r.materialNamesBefore) + ",");
            sb.AppendLine("      \"materialNamesAfter\": " + JsonArray(r.materialNamesAfter) + ",");
            sb.AppendLine("      \"prefabAssetNames\": " + JsonArray(r.prefabAssetNames) + ",");
            sb.AppendLine("      \"skeletonLikeAssets\": " + JsonArray(r.skeletonLikeAssets) + ",");
            sb.AppendLine("      \"skeletonRuntimeTypeNames\": " + JsonArray(r.skeletonRuntimeTypeNames) + ",");
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

    private static string MaterialNames(Renderer renderer)
    {
        var parts = new List<string>();
        foreach (var m in renderer.sharedMaterials) if (m != null) parts.Add(m.name);
        return string.Join(";", parts.ToArray());
    }

    private static string ShaderNames(Renderer renderer)
    {
        var parts = new List<string>();
        foreach (var m in renderer.sharedMaterials) if (m != null && m.shader != null) parts.Add(m.shader.name);
        return string.Join(";", parts.ToArray());
    }

    private static string TextureNames(Renderer renderer)
    {
        var parts = new List<string>();
        foreach (var m in renderer.sharedMaterials) if (m != null && m.mainTexture != null) parts.Add(m.mainTexture.name);
        return string.Join(";", parts.ToArray());
    }

    private static bool ContainsAscii(byte[] bytes, string needle)
    {
        if (bytes == null || string.IsNullOrEmpty(needle)) return false;
        var pattern = Encoding.ASCII.GetBytes(needle);
        for (int i = 0; i <= bytes.Length - pattern.Length; i++)
        {
            bool ok = true;
            for (int j = 0; j < pattern.Length; j++)
            {
                if (bytes[i + j] != pattern[j]) { ok = false; break; }
            }
            if (ok) return true;
        }
        return false;
    }

    private static int Count(List<ActorProbeResult> rows, Predicate<ActorProbeResult> predicate)
    {
        int count = 0;
        foreach (var row in rows) if (predicate(row)) count++;
        return count;
    }

    private static string FirstLine(string text)
    {
        if (string.IsNullOrEmpty(text)) return "";
        using (var reader = new StringReader(text)) return reader.ReadLine() ?? "";
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
        foreach (var value in values) parts.Add("\"" + Json(value) + "\"");
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

    private sealed class ShaderDependencyInfo
    {
        public string bundle = "";
        public string absolutePath = "";
        public bool fileExists;
        public long fileSize;
        public bool loaded;
        public string status = "";
        public List<string> assetNames = new List<string>();
        public List<string> assetTypes = new List<string>();
        public List<string> shaderNames = new List<string>();
        public List<string> materialNames = new List<string>();
        public List<string> loadExceptions = new List<string>();
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
        public int skeletonAnimationComponentCount;
        public int skeletonRendererComponentCount;
        public int skeletonMecanimComponentCount;
        public int shaderFallbackAppliedCount;
        public int internalErrorShaderMaterialCount;
        public int atlasTextBytes;
        public int skelBytes;
        public bool idleStringInSkelBytes;
        public bool idleReplaySucceeded;
        public string idleReplayAttemptReason = "";
        public string atlasFirstLine = "";
        public string motionReplayStatus = "not_evaluated";
        public string failReason = "";
        public List<string> textureNames = new List<string>();
        public List<string> materialNamesBefore = new List<string>();
        public List<string> materialNamesAfter = new List<string>();
        public List<string> prefabAssetNames = new List<string>();
        public List<string> skeletonLikeAssets = new List<string>();
        public List<string> skeletonRuntimeTypeNames = new List<string>();
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
        public string shaderNames = "";
        public string textureNames = "";
        public string localPosition = "";
        public string localScale = "";
    }
}
