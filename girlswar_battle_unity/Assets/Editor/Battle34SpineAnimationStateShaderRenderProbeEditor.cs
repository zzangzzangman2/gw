using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using System;
using System.Collections.Generic;
using System.IO;
using System.Reflection;
using System.Text;

public static class Battle34SpineAnimationStateShaderRenderProbeEditor
{
    private const string ResultJsonPath = "Assets/RestoreData/battle/BATTLE_34_RECONSTRUCT_SPINE_ANIMATIONSTATE_AND_SHADER_RENDER_FROM_SKEL_ATLAS_UNITY.json";
    private const string ComponentCsvPath = "Assets/RestoreData/battle/BATTLE_34_RECONSTRUCT_SPINE_ANIMATIONSTATE_AND_SHADER_RENDER_FROM_SKEL_ATLAS_UNITY_COMPONENTS.csv";
    private const string ScenePath = "Assets/Scenes/Battle34SpineAnimationStateShaderRenderProbe.unity";
    private const string CapturePath = "Assets/RestoreCaptures/battle_actor/Battle34SpineAnimationStateShaderRenderProbe_1920x1080.png";
    private const string BundleRoot = "C:/Users/godho/Downloads/girlswar/girlswar_merged_extracted/extracted/unity/clean_unityfs_slices";
    private const string SpineShaderBundle = "download/commonprefabsandres/spinematandshaders.assetbundle";

    [MenuItem("GirlsWar/Battle/BATTLE34 Reconstruct Spine AnimationState Shader Render Probe")]
    public static void Build()
    {
        Directory.CreateDirectory(ProjectPath("Assets/RestoreData/battle"));
        Directory.CreateDirectory(ProjectPath("Assets/RestoreCaptures/battle_actor"));
        Directory.CreateDirectory(ProjectPath("Assets/Scenes"));

        var targets = new List<ActorTarget>
        {
            new ActorTarget("our", "1002", "1002", "ult", "download/roleprefabsandres/battleprefabandres/1002.assetbundle", "assets/download/roleprefabsandres/battleprefabandres/1002/hero_1002.prefab", new Vector3(-2.35f, -0.35f, 0f), 0.72f),
            new ActorTarget("our", "1034", "1034", "skill1", "download/roleprefabsandres/battleprefabandres/1034.assetbundle", "assets/download/roleprefabsandres/battleprefabandres/1034/hero_1034.prefab", new Vector3(-0.2f, -0.35f, 0f), 0.72f),
            new ActorTarget("enemy", "1100111", "3001", "attack", "download/roleprefabsandres/battleprefabandres/3001.assetbundle", "assets/download/roleprefabsandres/battleprefabandres/3001/hero_3001.prefab", new Vector3(2.1f, -0.2f, 0f), 0.68f),
        };

        var scene = EditorSceneManager.NewScene(NewSceneSetup.EmptyScene, NewSceneMode.Single);
        var root = new GameObject("BATTLE34_SpineAnimationStateShaderRenderProbeRoot");
        var cameraObject = new GameObject("BATTLE34_ProbeCamera");
        var camera = cameraObject.AddComponent<Camera>();
        camera.clearFlags = CameraClearFlags.SolidColor;
        camera.backgroundColor = new Color(0.035f, 0.037f, 0.042f, 1f);
        camera.orthographic = true;
        camera.orthographicSize = 3.4f;
        cameraObject.transform.position = new Vector3(0f, 0f, -10f);

        var lightObject = new GameObject("BATTLE34_ProbeDirectionalLight");
        var light = lightObject.AddComponent<Light>();
        light.type = LightType.Directional;
        light.intensity = 0.65f;
        lightObject.transform.rotation = Quaternion.Euler(35f, 20f, 0f);

        var opened = new List<AssetBundle>();
        var shaderInfo = LoadSpineShaderDependency(opened);
        var results = new List<ActorProbeResult>();
        var componentRows = new List<ComponentRow>();

        foreach (var target in targets)
        {
            results.Add(ProbeActor(target, root.transform, componentRows, opened));
        }

        Capture(camera, ProjectPath(CapturePath));
        WriteCsv(ProjectPath(ComponentCsvPath), componentRows);
        WriteJson(ProjectPath(ResultJsonPath), results, componentRows, shaderInfo);
        EditorSceneManager.SaveScene(scene, ScenePath);

        foreach (var bundle in opened)
        {
            if (bundle != null) bundle.Unload(false);
        }
        AssetDatabase.Refresh();
        Debug.Log("BATTLE34 Spine AnimationState/shader render probe complete. actors=" + results.Count + ", componentRows=" + componentRows.Count);
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
            UnityEngine.Object asset = null;
            try { asset = bundle.LoadAsset<UnityEngine.Object>(name); }
            catch (Exception ex) { info.loadExceptions.Add(name + " :: " + Short(ex.Message)); }
            if (asset == null) continue;
            var typeName = asset.GetType().FullName ?? asset.GetType().Name;
            info.assetTypes.Add(name + "|" + typeName);
            var shader = asset as Shader;
            if (shader != null) info.shaderNames.Add(shader.name);
            var material = asset as Material;
            if (material != null)
            {
                var shaderName = material.shader != null ? material.shader.name : "";
                info.materialNames.Add(material.name + "|shader=" + shaderName);
            }
        }
        return info;
    }

    private static ActorProbeResult ProbeActor(ActorTarget target, Transform root, List<ComponentRow> rows, List<AssetBundle> opened)
    {
        var result = new ActorProbeResult();
        result.side = target.side;
        result.heroDid = target.heroDid;
        result.modelId = target.modelId;
        result.expectedAnimation = target.expectedAnimation;
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
            UnityEngine.Object asset = null;
            try { asset = bundle.LoadAsset<UnityEngine.Object>(name); }
            catch (Exception ex) { result.loadExceptions.Add(name + " :: " + Short(ex.Message)); }
            if (asset == null) continue;
            var typeName = asset.GetType().FullName ?? asset.GetType().Name;
            result.AddAssetType(typeName);
            var lower = name.ToLowerInvariant();
            if (lower.EndsWith(".prefab")) result.prefabAssetNames.Add(name);
            if (lower.Contains("skeletondata") || lower.Contains("atlas") || lower.EndsWith(".skel.bytes"))
                result.skeletonLikeAssets.Add(name);

            var textAsset = asset as TextAsset;
            if (textAsset != null)
            {
                if (lower.EndsWith(".atlas.txt"))
                {
                    result.atlasTextAssetName = textAsset.name;
                    result.atlasTextBytes = textAsset.bytes != null ? textAsset.bytes.Length : 0;
                    result.atlasFirstLine = FirstLine(textAsset.text);
                    result.atlasRegionCount = CountAtlasRegions(textAsset.text);
                }
                if (lower.EndsWith(".skel.bytes"))
                {
                    result.skelTextAssetName = textAsset.name;
                    result.skelBytes = textAsset.bytes != null ? textAsset.bytes.Length : 0;
                    result.skelContainsExpectedAnimation = ContainsAscii(textAsset.bytes, target.expectedAnimation);
                    result.skelContainsStand = ContainsAscii(textAsset.bytes, "stand");
                    result.skelContainsAttack = ContainsAscii(textAsset.bytes, "attack");
                    result.skelContainsSkill1 = ContainsAscii(textAsset.bytes, "skill1");
                    result.skelContainsUlt = ContainsAscii(textAsset.bytes, "ult");
                }
            }
            var texture = asset as Texture2D;
            if (texture != null)
            {
                result.textureNames.Add(texture.name + "(" + texture.width + "x" + texture.height + ")");
            }
            var material = asset as Material;
            if (material != null)
            {
                var shaderName = material.shader != null ? material.shader.name : "";
                var texName = material.mainTexture != null ? material.mainTexture.name : "";
                result.bundleMaterialNames.Add(material.name + "|shader=" + shaderName + "|mainTex=" + texName);
            }
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
        instance.name = "BATTLE34_LoadableActor_" + target.side + "_" + target.heroDid + "_model_" + target.modelId;
        instance.transform.localScale = Vector3.one * target.scale;
        result.prefabInstantiated = true;

        DumpBeforeState(instance, result);
        AttemptAnimationStateAndMeshUpdate(instance, target, result);
        DumpAfterState(instance, result);
        DumpHierarchy(target, result, instance.transform, instance.name, rows);
        result.motionReplayStatus = result.realMeshUpdated
            ? "mesh_changed_after_runtime_call_but_clip05_motion_not_verified"
            : "failed_real_spine_mesh_update_runtime_bridge_incomplete";
        return result;
    }

    private static void DumpBeforeState(GameObject instance, ActorProbeResult result)
    {
        foreach (var mf in instance.GetComponentsInChildren<MeshFilter>(true))
        {
            result.meshFilterCount++;
            var mesh = mf.sharedMesh;
            if (mesh != null)
            {
                result.meshVertexCountBefore += mesh.vertexCount;
                result.meshTriangleIndexCountBefore += mesh.triangles != null ? mesh.triangles.Length : 0;
                result.meshBoundsBefore.Add(mf.name + "|" + Vec(mesh.bounds.center) + "|" + Vec(mesh.bounds.size));
            }
        }
        foreach (var renderer in instance.GetComponentsInChildren<Renderer>(true))
        {
            result.rendererCount++;
            if (renderer.enabled) result.enabledRendererCount++;
            foreach (var material in renderer.sharedMaterials)
            {
                if (material == null) continue;
                var shaderName = material.shader != null ? material.shader.name : "";
                var texName = material.mainTexture != null ? material.mainTexture.name : "";
                result.rendererMaterialBefore.Add(material.name + "|shader=" + shaderName + "|mainTex=" + texName);
                if (shaderName == "Hidden/InternalErrorShader" || shaderName.ToLowerInvariant().Contains("error")) result.internalErrorShaderMaterialCount++;
            }
        }
    }

    private static void AttemptAnimationStateAndMeshUpdate(GameObject instance, ActorTarget target, ActorProbeResult result)
    {
        foreach (var component in instance.GetComponentsInChildren<Component>(true))
        {
            if (component == null)
            {
                result.missingScriptCount++;
                continue;
            }
            var typeName = component.GetType().FullName ?? component.GetType().Name;
            if (typeName == "Spine.Unity.SkeletonAnimation")
            {
                result.skeletonAnimationComponentCount++;
                result.skeletonAnimationAssembly = component.GetType().Assembly.GetName().Name;
                result.skeletonAnimationType = typeName;
                result.runtimeBridgeKind = HasRealSpineRuntimeTypes() ? "spine_runtime_mesh_generator_type_present" : "proxy_stub_no_mesh_generator_or_skeletonbinary";
                result.serializedAnimationName = ReadStringField(component, "_animationName");
                result.loop = ReadBoolField(component, "loop");
                result.skeletonDataAssetType = ReadObjectFieldType(component, "skeletonDataAsset");
                result.skeletonDataAssetName = ReadObjectFieldName(component, "skeletonDataAsset");

                try
                {
                    InvokeIfExists(component, "Initialize", new[] { typeof(bool), typeof(bool) }, new object[] { true, true });
                    var setAnimation = component.GetType().GetMethod("SetAnimation", new[] { typeof(int), typeof(string), typeof(bool) });
                    if (setAnimation != null)
                    {
                        setAnimation.Invoke(component, new object[] { 0, target.expectedAnimation, target.expectedAnimation == "stand" });
                        result.animationStateSetSucceeded = true;
                    }
                    InvokeIfExists(component, "LateUpdate", Type.EmptyTypes, new object[0]);
                    InvokeIfExists(component, "LateUpdateMesh", Type.EmptyTypes, new object[0]);
                    result.lateUpdateCalled = true;
                }
                catch (Exception ex)
                {
                    result.animationStateException = Short(ex.Message);
                }
            }
            else if (typeName.Contains("SkeletonRenderer"))
            {
                result.skeletonRendererComponentCount++;
            }
        }
    }

    private static void DumpAfterState(GameObject instance, ActorProbeResult result)
    {
        foreach (var mf in instance.GetComponentsInChildren<MeshFilter>(true))
        {
            var mesh = mf.sharedMesh;
            if (mesh != null)
            {
                result.meshVertexCountAfter += mesh.vertexCount;
                result.meshTriangleIndexCountAfter += mesh.triangles != null ? mesh.triangles.Length : 0;
                result.meshBoundsAfter.Add(mf.name + "|" + Vec(mesh.bounds.center) + "|" + Vec(mesh.bounds.size));
            }
        }
        foreach (var renderer in instance.GetComponentsInChildren<Renderer>(true))
        {
            foreach (var material in renderer.sharedMaterials)
            {
                if (material == null) continue;
                var shaderName = material.shader != null ? material.shader.name : "";
                var texName = material.mainTexture != null ? material.mainTexture.name : "";
                result.rendererMaterialAfter.Add(material.name + "|shader=" + shaderName + "|mainTex=" + texName);
            }
        }
        result.realMeshUpdated = result.meshVertexCountAfter > 0 &&
                                 (result.meshVertexCountAfter != result.meshVertexCountBefore ||
                                  result.meshTriangleIndexCountAfter != result.meshTriangleIndexCountBefore);
    }

    private static bool HasRealSpineRuntimeTypes()
    {
        return Type.GetType("Spine.Unity.MeshGenerator, spine-unity") != null &&
               Type.GetType("Spine.SkeletonBinary, spine-unity") != null;
    }

    private static void DumpHierarchy(ActorTarget target, ActorProbeResult result, Transform transform, string path, List<ComponentRow> rows)
    {
        var components = transform.gameObject.GetComponents<Component>();
        var typeParts = new List<string>();
        foreach (var component in components)
        {
            var typeName = component == null ? "MissingScript" : (component.GetType().FullName ?? component.GetType().Name);
            typeParts.Add(typeName);
        }
        var renderer = transform.gameObject.GetComponent<Renderer>();
        var meshFilter = transform.gameObject.GetComponent<MeshFilter>();
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
            meshVertexCount = meshFilter != null && meshFilter.sharedMesh != null ? meshFilter.sharedMesh.vertexCount : 0,
            meshTriangleIndexCount = meshFilter != null && meshFilter.sharedMesh != null && meshFilter.sharedMesh.triangles != null ? meshFilter.sharedMesh.triangles.Length : 0,
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
        sb.AppendLine("side,heroDid,modelId,hierarchyPath,componentTypes,rendererType,materialNames,shaderNames,textureNames,meshVertexCount,meshTriangleIndexCount,localPosition,localScale");
        foreach (var row in rows)
        {
            sb.AppendLine(Csv(row.side) + "," + Csv(row.heroDid) + "," + Csv(row.modelId) + "," + Csv(row.hierarchyPath) + "," + Csv(row.componentTypes) + "," + Csv(row.rendererType) + "," + Csv(row.materialNames) + "," + Csv(row.shaderNames) + "," + Csv(row.textureNames) + "," + row.meshVertexCount + "," + row.meshTriangleIndexCount + "," + Csv(row.localPosition) + "," + Csv(row.localScale));
        }
        File.WriteAllText(path, sb.ToString(), new UTF8Encoding(false));
    }

    private static void WriteJson(string path, List<ActorProbeResult> results, List<ComponentRow> rows, ShaderDependencyInfo shaderInfo)
    {
        int loaded = Count(results, r => r.bundleLoaded);
        int instantiated = Count(results, r => r.prefabInstantiated);
        int skeletonAnimations = Sum(results, r => r.skeletonAnimationComponentCount);
        int animationStateSet = Count(results, r => r.animationStateSetSucceeded);
        int realMeshUpdated = Count(results, r => r.realMeshUpdated);
        int missingScripts = Sum(results, r => r.missingScriptCount);
        int meshVerticesAfter = Sum(results, r => r.meshVertexCountAfter);
        int internalErrorMaterials = Sum(results, r => r.internalErrorShaderMaterialCount);

        var sb = new StringBuilder();
        sb.AppendLine("{");
        sb.AppendLine("  \"verdict\": \"battle34_spine_animationstate_shader_render_probe_trace_only\",");
        sb.AppendLine("  \"visual_status\": \"failed_clip05_actor_motion_not_replayed\",");
        sb.AppendLine("  \"isFinalRestoredBattleScreen\": false,");
        sb.AppendLine("  \"scene\": \"" + Json(ScenePath) + "\",");
        sb.AppendLine("  \"capture\": \"" + Json(CapturePath) + "\",");
        sb.AppendLine("  \"summary\": {");
        sb.AppendLine("    \"targetActorCount\": " + results.Count + ",");
        sb.AppendLine("    \"bundleLoadSuccess\": " + loaded + ",");
        sb.AppendLine("    \"prefabInstantiateSuccess\": " + instantiated + ",");
        sb.AppendLine("    \"componentRowCount\": " + rows.Count + ",");
        sb.AppendLine("    \"missingScriptCount\": " + missingScripts + ",");
        sb.AppendLine("    \"skeletonAnimationComponentCount\": " + skeletonAnimations + ",");
        sb.AppendLine("    \"animationStateSetSucceededCount\": " + animationStateSet + ",");
        sb.AppendLine("    \"realMeshUpdatedCount\": " + realMeshUpdated + ",");
        sb.AppendLine("    \"meshVertexCountAfter\": " + meshVerticesAfter + ",");
        sb.AppendLine("    \"internalErrorShaderMaterialCount\": " + internalErrorMaterials);
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
            sb.AppendLine("      \"expectedAnimation\": \"" + Json(r.expectedAnimation) + "\",");
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
            sb.AppendLine("      \"meshFilterCount\": " + r.meshFilterCount + ",");
            sb.AppendLine("      \"meshVertexCountBefore\": " + r.meshVertexCountBefore + ",");
            sb.AppendLine("      \"meshVertexCountAfter\": " + r.meshVertexCountAfter + ",");
            sb.AppendLine("      \"meshTriangleIndexCountBefore\": " + r.meshTriangleIndexCountBefore + ",");
            sb.AppendLine("      \"meshTriangleIndexCountAfter\": " + r.meshTriangleIndexCountAfter + ",");
            sb.AppendLine("      \"realMeshUpdated\": " + Bool(r.realMeshUpdated) + ",");
            sb.AppendLine("      \"missingScriptCount\": " + r.missingScriptCount + ",");
            sb.AppendLine("      \"skeletonAnimationComponentCount\": " + r.skeletonAnimationComponentCount + ",");
            sb.AppendLine("      \"skeletonRendererComponentCount\": " + r.skeletonRendererComponentCount + ",");
            sb.AppendLine("      \"skeletonAnimationAssembly\": \"" + Json(r.skeletonAnimationAssembly) + "\",");
            sb.AppendLine("      \"skeletonAnimationType\": \"" + Json(r.skeletonAnimationType) + "\",");
            sb.AppendLine("      \"runtimeBridgeKind\": \"" + Json(r.runtimeBridgeKind) + "\",");
            sb.AppendLine("      \"serializedAnimationName\": \"" + Json(r.serializedAnimationName) + "\",");
            sb.AppendLine("      \"loop\": " + Bool(r.loop) + ",");
            sb.AppendLine("      \"skeletonDataAssetName\": \"" + Json(r.skeletonDataAssetName) + "\",");
            sb.AppendLine("      \"skeletonDataAssetType\": \"" + Json(r.skeletonDataAssetType) + "\",");
            sb.AppendLine("      \"animationStateSetSucceeded\": " + Bool(r.animationStateSetSucceeded) + ",");
            sb.AppendLine("      \"lateUpdateCalled\": " + Bool(r.lateUpdateCalled) + ",");
            sb.AppendLine("      \"animationStateException\": \"" + Json(r.animationStateException) + "\",");
            sb.AppendLine("      \"motionReplayStatus\": \"" + Json(r.motionReplayStatus) + "\",");
            sb.AppendLine("      \"failReason\": \"" + Json(r.failReason) + "\",");
            sb.AppendLine("      \"atlasTextAssetName\": \"" + Json(r.atlasTextAssetName) + "\",");
            sb.AppendLine("      \"atlasTextBytes\": " + r.atlasTextBytes + ",");
            sb.AppendLine("      \"atlasFirstLine\": \"" + Json(r.atlasFirstLine) + "\",");
            sb.AppendLine("      \"atlasRegionCount\": " + r.atlasRegionCount + ",");
            sb.AppendLine("      \"skelTextAssetName\": \"" + Json(r.skelTextAssetName) + "\",");
            sb.AppendLine("      \"skelBytes\": " + r.skelBytes + ",");
            sb.AppendLine("      \"skelContainsExpectedAnimation\": " + Bool(r.skelContainsExpectedAnimation) + ",");
            sb.AppendLine("      \"skelContainsStand\": " + Bool(r.skelContainsStand) + ",");
            sb.AppendLine("      \"skelContainsAttack\": " + Bool(r.skelContainsAttack) + ",");
            sb.AppendLine("      \"skelContainsSkill1\": " + Bool(r.skelContainsSkill1) + ",");
            sb.AppendLine("      \"skelContainsUlt\": " + Bool(r.skelContainsUlt) + ",");
            sb.AppendLine("      \"textureNames\": " + JsonArray(r.textureNames) + ",");
            sb.AppendLine("      \"bundleMaterialNames\": " + JsonArray(r.bundleMaterialNames) + ",");
            sb.AppendLine("      \"rendererMaterialBefore\": " + JsonArray(r.rendererMaterialBefore) + ",");
            sb.AppendLine("      \"rendererMaterialAfter\": " + JsonArray(r.rendererMaterialAfter) + ",");
            sb.AppendLine("      \"meshBoundsBefore\": " + JsonArray(r.meshBoundsBefore) + ",");
            sb.AppendLine("      \"meshBoundsAfter\": " + JsonArray(r.meshBoundsAfter) + ",");
            sb.AppendLine("      \"prefabAssetNames\": " + JsonArray(r.prefabAssetNames) + ",");
            sb.AppendLine("      \"skeletonLikeAssets\": " + JsonArray(r.skeletonLikeAssets) + ",");
            sb.AppendLine("      \"loadExceptions\": " + JsonArray(r.loadExceptions));
            sb.Append("    }");
            if (i + 1 < results.Count) sb.Append(",");
            sb.AppendLine();
        }
        sb.AppendLine("  ]");
        sb.AppendLine("}");
        File.WriteAllText(path, sb.ToString(), new UTF8Encoding(false));
    }

    private static void InvokeIfExists(object obj, string name, Type[] types, object[] args)
    {
        var method = obj.GetType().GetMethod(name, BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance, null, types, null);
        if (method != null) method.Invoke(obj, args);
    }

    private static string ReadStringField(object obj, string name)
    {
        var field = obj.GetType().GetField(name, BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance);
        return field != null ? (field.GetValue(obj) as string ?? "") : "";
    }

    private static bool ReadBoolField(object obj, string name)
    {
        var field = obj.GetType().GetField(name, BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance);
        return field != null && field.FieldType == typeof(bool) && (bool)field.GetValue(obj);
    }

    private static string ReadObjectFieldType(object obj, string name)
    {
        var field = obj.GetType().GetField(name, BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance);
        var value = field != null ? field.GetValue(obj) : null;
        return value != null ? value.GetType().FullName : "";
    }

    private static string ReadObjectFieldName(object obj, string name)
    {
        var field = obj.GetType().GetField(name, BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance);
        var value = field != null ? field.GetValue(obj) as UnityEngine.Object : null;
        return value != null ? value.name : "";
    }

    private static int CountAtlasRegions(string text)
    {
        if (string.IsNullOrEmpty(text)) return 0;
        int count = 0;
        var lines = text.Split('\n');
        for (int i = 0; i < lines.Length; i++)
        {
            var line = lines[i].Trim();
            if (line.Length == 0 || line.Contains(":") || line.EndsWith(".png", StringComparison.OrdinalIgnoreCase)) continue;
            if (i + 1 < lines.Length && lines[i + 1].Contains(":")) count++;
        }
        return count;
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

    private static int Sum(List<ActorProbeResult> rows, Func<ActorProbeResult, int> selector)
    {
        int count = 0;
        foreach (var row in rows) count += selector(row);
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
        public string expectedAnimation;
        public string bundle;
        public string prefabAsset;
        public Vector3 position;
        public float scale;

        public ActorTarget(string side, string heroDid, string modelId, string expectedAnimation, string bundle, string prefabAsset, Vector3 position, float scale)
        {
            this.side = side;
            this.heroDid = heroDid;
            this.modelId = modelId;
            this.expectedAnimation = expectedAnimation;
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
        public string expectedAnimation = "";
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
        public int meshFilterCount;
        public int meshVertexCountBefore;
        public int meshVertexCountAfter;
        public int meshTriangleIndexCountBefore;
        public int meshTriangleIndexCountAfter;
        public bool realMeshUpdated;
        public int missingScriptCount;
        public int skeletonAnimationComponentCount;
        public int skeletonRendererComponentCount;
        public string skeletonAnimationAssembly = "";
        public string skeletonAnimationType = "";
        public string runtimeBridgeKind = "";
        public string serializedAnimationName = "";
        public bool loop;
        public string skeletonDataAssetName = "";
        public string skeletonDataAssetType = "";
        public bool animationStateSetSucceeded;
        public bool lateUpdateCalled;
        public string animationStateException = "";
        public string atlasTextAssetName = "";
        public int atlasTextBytes;
        public string atlasFirstLine = "";
        public int atlasRegionCount;
        public string skelTextAssetName = "";
        public int skelBytes;
        public bool skelContainsExpectedAnimation;
        public bool skelContainsStand;
        public bool skelContainsAttack;
        public bool skelContainsSkill1;
        public bool skelContainsUlt;
        public int internalErrorShaderMaterialCount;
        public string motionReplayStatus = "not_evaluated";
        public string failReason = "";
        public List<string> textureNames = new List<string>();
        public List<string> bundleMaterialNames = new List<string>();
        public List<string> rendererMaterialBefore = new List<string>();
        public List<string> rendererMaterialAfter = new List<string>();
        public List<string> meshBoundsBefore = new List<string>();
        public List<string> meshBoundsAfter = new List<string>();
        public List<string> prefabAssetNames = new List<string>();
        public List<string> skeletonLikeAssets = new List<string>();
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
        public int meshVertexCount;
        public int meshTriangleIndexCount;
        public string localPosition = "";
        public string localScale = "";
    }
}
