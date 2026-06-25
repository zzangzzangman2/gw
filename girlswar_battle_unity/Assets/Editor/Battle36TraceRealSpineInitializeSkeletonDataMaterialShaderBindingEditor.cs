using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Reflection;
using System.Text;

public static class Battle36TraceRealSpineInitializeSkeletonDataMaterialShaderBindingEditor
{
    private const string ResultJsonPath = "Assets/RestoreData/battle/BATTLE_36_TRACE_REAL_SPINE_INITIALIZE_SKELETONDATA_MATERIAL_SHADER_BINDING_UNITY.json";
    private const string ComponentCsvPath = "Assets/RestoreData/battle/BATTLE_36_TRACE_REAL_SPINE_INITIALIZE_SKELETONDATA_MATERIAL_SHADER_BINDING_COMPONENTS.csv";
    private const string ScenePath = "Assets/Scenes/Battle36TraceRealSpineInitializeSkeletonDataMaterialShaderBinding.unity";
    private const string CapturePath = "Assets/RestoreCaptures/battle_actor/Battle36TraceRealSpineInitializeSkeletonDataMaterialShaderBinding_1920x1080.png";
    private const string BundleRoot = "C:/Users/godho/Downloads/girlswar/girlswar_merged_extracted/extracted/unity/clean_unityfs_slices";
    private const string SpineShaderBundle = "download/commonprefabsandres/spinematandshaders.assetbundle";

    [MenuItem("GirlsWar/Battle/BATTLE36 Trace Real Spine Initialize SkeletonData Material Shader Binding")]
    public static void Build()
    {
        Directory.CreateDirectory(ProjectPath("Assets/RestoreData/battle"));
        Directory.CreateDirectory(ProjectPath("Assets/RestoreCaptures/battle_actor"));
        Directory.CreateDirectory(ProjectPath("Assets/Scenes"));

        var targets = new List<ActorTarget>
        {
            new ActorTarget("our", "1002", "1002", "ult", new[] { "ult", "stand", "skill1" }, "download/roleprefabsandres/battleprefabandres/1002.assetbundle", "assets/download/roleprefabsandres/battleprefabandres/1002/hero_1002.prefab", new Vector3(-2.35f, -0.35f, 0f), 0.72f),
            new ActorTarget("our", "1034", "1034", "skill1", new[] { "skill1", "stand", "ult" }, "download/roleprefabsandres/battleprefabandres/1034.assetbundle", "assets/download/roleprefabsandres/battleprefabandres/1034/hero_1034.prefab", new Vector3(-0.2f, -0.35f, 0f), 0.72f),
            new ActorTarget("enemy", "1100111", "3001", "attack", new[] { "attack", "attackR", "stand", "run1" }, "download/roleprefabsandres/battleprefabandres/3001.assetbundle", "assets/download/roleprefabsandres/battleprefabandres/3001/hero_3001.prefab", new Vector3(2.1f, -0.2f, 0f), 0.68f),
        };

        var scene = EditorSceneManager.NewScene(NewSceneSetup.EmptyScene, NewSceneMode.Single);
        var root = new GameObject("BATTLE36_TraceRealSpineInitializeSkeletonDataMaterialShaderBindingRoot");
        var cameraObject = new GameObject("BATTLE36_ProbeCamera");
        var camera = cameraObject.AddComponent<Camera>();
        camera.clearFlags = CameraClearFlags.SolidColor;
        camera.backgroundColor = new Color(0.035f, 0.037f, 0.042f, 1f);
        camera.orthographic = true;
        camera.orthographicSize = 3.4f;
        cameraObject.transform.position = new Vector3(0f, 0f, -10f);

        var opened = new List<AssetBundle>();
        var shaderInfo = LoadSpineShaderDependency(opened);
        var runtimeInfo = ProbeRuntimeTypes();
        var actorResults = new List<ActorProbeResult>();
        var componentRows = new List<ComponentRow>();

        foreach (var target in targets)
        {
            actorResults.Add(ProbeActor(target, root.transform, componentRows, opened));
        }

        Capture(camera, ProjectPath(CapturePath));
        WriteCsv(ProjectPath(ComponentCsvPath), componentRows);
        WriteJson(ProjectPath(ResultJsonPath), actorResults, componentRows, shaderInfo, runtimeInfo);
        EditorSceneManager.SaveScene(scene, ScenePath);

        foreach (var bundle in opened)
        {
            if (bundle != null) bundle.Unload(false);
        }
        AssetDatabase.Refresh();
        Debug.Log("BATTLE36 trace complete. actors=" + actorResults.Count + ", componentRows=" + componentRows.Count);
    }

    private static RuntimeInfo ProbeRuntimeTypes()
    {
        var info = new RuntimeInfo();
        info.skeletonAnimation = TypeExists("Spine.Unity.SkeletonAnimation, spine-unity");
        info.skeletonRenderer = TypeExists("Spine.Unity.SkeletonRenderer, spine-unity");
        info.skeletonDataAsset = TypeExists("Spine.Unity.SkeletonDataAsset, spine-unity");
        info.atlasAsset = TypeExists("Spine.Unity.AtlasAsset, spine-unity") || TypeExists("Spine.Unity.AtlasAssetBase, spine-unity");
        info.meshGenerator = TypeExists("Spine.Unity.MeshGenerator, spine-unity");
        info.skeletonBinary = TypeExists("Spine.SkeletonBinary, spine-csharp") || TypeExists("Spine.SkeletonBinary, spine-unity");
        info.animationState = TypeExists("Spine.AnimationState, spine-csharp") || TypeExists("Spine.AnimationState, spine-unity");
        info.atlasAttachmentLoader = TypeExists("Spine.AtlasAttachmentLoader, spine-csharp") || TypeExists("Spine.AtlasAttachmentLoader, spine-unity");
        info.realRuntimePresent = info.skeletonAnimation && info.meshGenerator && info.skeletonBinary && info.animationState;
        return info;
    }

    private static bool TypeExists(string typeName)
    {
        return Type.GetType(typeName) != null;
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
            info.assetTypes.Add(name + "|" + (asset.GetType().FullName ?? asset.GetType().Name));
            var shader = asset as Shader;
            if (shader != null) info.shaderNames.Add(ShaderInfo(shader));
            var material = asset as Material;
            if (material != null) info.materialNames.Add(MaterialInfo(material));
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
        result.animationCandidates = new List<string>(target.animationCandidates);
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
            UnityEngine.Object asset = null;
            try { asset = bundle.LoadAsset<UnityEngine.Object>(name); }
            catch (Exception ex) { result.loadExceptions.Add(name + " :: " + Short(ex.Message)); }
            if (asset == null) continue;
            result.assetNameCount++;
            var lower = name.ToLowerInvariant();
            if (lower.EndsWith(".prefab")) result.prefabAssetNames.Add(name);
            if (lower.Contains("skeletondata") || lower.Contains("atlas") || lower.EndsWith(".skel.bytes"))
                result.skeletonLikeAssets.Add(name);
            var texture = asset as Texture2D;
            if (texture != null) result.textureNames.Add(texture.name + "(" + texture.width + "x" + texture.height + ")");
            var material = asset as Material;
            if (material != null) result.bundleMaterialNames.Add(MaterialInfo(material));
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
        instance.name = "BATTLE36_LoadableActor_" + target.side + "_" + target.heroDid + "_model_" + target.modelId;
        instance.transform.localScale = Vector3.one * target.scale;
        result.prefabInstantiated = true;

        DumpMeshSnapshot(instance, result, "before_initialize", true);
        AttemptRuntimeTrace(instance, target, result);
        DumpMeshSnapshot(instance, result, "after_runtime_trace", false);
        DumpHierarchy(target, result, instance.transform, instance.name, rows);
        result.realMeshUpdated = result.meshHashChangedFrameCount > 0 || result.meshBoundsChangedFrameCount > 0;
        if (result.skeletonDataNull)
            result.motionReplayStatus = "failed_skeletondata_null_or_empty";
        else if (result.meshHashChangedFrameCount > 0)
            result.motionReplayStatus = "mesh_changes_after_update_float_but_clip05_motion_not_verified";
        else if (result.animationStateSetSucceeded)
            result.motionReplayStatus = "failed_animation_state_set_but_mesh_hash_static";
        else
            result.motionReplayStatus = "failed_animation_state_not_set";
        return result;
    }

    private static void AttemptRuntimeTrace(GameObject instance, ActorTarget target, ActorProbeResult result)
    {
        foreach (var component in instance.GetComponentsInChildren<Component>(true))
        {
            if (component == null)
            {
                result.missingScriptCount++;
                continue;
            }
            var typeName = component.GetType().FullName ?? component.GetType().Name;
            if (typeName != "Spine.Unity.SkeletonAnimation") continue;

            result.skeletonAnimationComponentCount++;
            result.skeletonAnimationAssembly = component.GetType().Assembly.GetName().Name;
            result.serializedAnimationName = ReadStringField(component, "_animationName");
            result.initialValid = ReadBoolField(component, "valid");
            TraceSkeletonDataAsset(component, result);

            try
            {
                InvokeIfExists(component, "Initialize", new[] { typeof(bool), typeof(bool) }, new object[] { true, false });
                result.initializeCalled = true;
                result.afterInitializeValid = ReadBoolField(component, "valid");
                TraceSkeletonRuntimeObjects(component, result);

                object state = ReadProperty(component, "AnimationState");
                result.animationStateNonNull = state != null;
                var set = state != null ? state.GetType().GetMethod("SetAnimation", new[] { typeof(int), typeof(string), typeof(bool) }) : null;
                if (set != null)
                {
                    foreach (var candidate in target.animationCandidates)
                    {
                        if (!string.IsNullOrEmpty(candidate) && result.animationNames.Contains(candidate))
                        {
                            TrySetAnimation(set, state, candidate, result);
                            break;
                        }
                    }
                    if (!result.animationStateSetSucceeded)
                    {
                        foreach (var candidate in target.animationCandidates)
                        {
                            if (!string.IsNullOrEmpty(candidate))
                            {
                                TrySetAnimation(set, state, candidate, result);
                                if (result.animationStateSetSucceeded) break;
                            }
                        }
                    }
                }

                for (int i = 0; i < 12; i++)
                {
                    InvokeIfExists(component, "Update", new[] { typeof(float) }, new object[] { 1f / 30f });
                    InvokeIfExists(component, "LateUpdate", Type.EmptyTypes, new object[0]);
                    InvokeIfExists(component, "LateUpdateMesh", Type.EmptyTypes, new object[0]);
                    var snapshot = CreateMeshFrameSnapshot(instance, i);
                    result.frameSnapshots.Add(snapshot);
                    if (i > 0 && snapshot.meshHash != result.frameSnapshots[i - 1].meshHash) result.meshHashChangedFrameCount++;
                    if (i > 0 && snapshot.meshBoundsJoined != result.frameSnapshots[i - 1].meshBoundsJoined) result.meshBoundsChangedFrameCount++;
                    TraceTrackEntry(state, result, i);
                }
                result.updateFloatCalled = true;
                result.lateUpdateCalled = true;
            }
            catch (Exception ex)
            {
                result.runtimeException = Short(Unwrap(ex));
            }
        }
    }

    private static void TrySetAnimation(MethodInfo set, object state, string animationName, ActorProbeResult result)
    {
        try
        {
            set.Invoke(state, new object[] { 0, animationName, true });
            result.animationStateSetSucceeded = true;
            result.animationStateUsedName = animationName;
            result.animationFallbackUsed = animationName != result.expectedAnimation;
        }
        catch (Exception ex)
        {
            result.animationStateException = Short(Unwrap(ex));
        }
    }

    private static void TraceSkeletonDataAsset(Component component, ActorProbeResult result)
    {
        var sda = ReadField(component, "skeletonDataAsset");
        result.skeletonDataAssetType = sda != null ? sda.GetType().FullName : "";
        result.skeletonDataAssetName = ObjectName(sda);
        if (sda == null)
        {
            result.skeletonDataNull = true;
            return;
        }
        result.skeletonDataAssetIsLoaded = ReadBoolPropertyOrField(sda, "IsLoaded");
        result.skeletonDataAssetScale = ReadFloatPropertyOrField(sda, "scale");
        var skeletonJson = ReadField(sda, "skeletonJSON") as UnityEngine.Object;
        result.skeletonJsonName = skeletonJson != null ? skeletonJson.name : "";
        var atlasAssets = ReadField(sda, "atlasAssets");
        foreach (var atlas in EnumerateCollection(atlasAssets))
        {
            if (atlas == null) continue;
            result.atlasAssetNames.Add(ObjectName(atlas) + "|" + atlas.GetType().FullName);
            foreach (var material in ExtractMaterials(atlas))
            {
                result.atlasMaterialInfos.Add(MaterialInfo(material));
                if (material != null && material.shader != null && !material.shader.isSupported)
                    result.unsupportedShaderMaterialCount++;
                if (material != null && material.mainTexture != null)
                    result.atlasTextureInfos.Add(material.mainTexture.name + "(" + material.mainTexture.width + "x" + material.mainTexture.height + ")");
            }
        }
    }

    private static void TraceSkeletonRuntimeObjects(Component component, ActorProbeResult result)
    {
        var sda = ReadField(component, "skeletonDataAsset");
        object skeletonData = null;
        if (sda != null)
        {
            try
            {
                var method = sda.GetType().GetMethod("GetSkeletonData", new[] { typeof(bool) });
                skeletonData = method != null ? method.Invoke(sda, new object[] { false }) : null;
            }
            catch (Exception ex)
            {
                result.skeletonDataException = Short(Unwrap(ex));
            }
        }
        if (skeletonData == null)
        {
            result.skeletonDataNull = true;
            return;
        }
        result.skeletonDataNull = false;
        result.boneCount = CountCollection(ReadPropertyOrField(skeletonData, "Bones"));
        result.slotCount = CountCollection(ReadPropertyOrField(skeletonData, "Slots"));
        result.skinCount = CountCollection(ReadPropertyOrField(skeletonData, "Skins"));
        var animations = ReadPropertyOrField(skeletonData, "Animations");
        result.animationCount = CountCollection(animations);
        foreach (var animation in EnumerateCollection(animations))
        {
            if (animation == null) continue;
            var name = ReadStringPropertyOrField(animation, "Name");
            if (!string.IsNullOrEmpty(name)) result.animationNames.Add(name);
        }
        result.expectedAnimationInRuntime = result.animationNames.Contains(result.expectedAnimation);
        var skeleton = ReadProperty(component, "Skeleton");
        result.skeletonRuntimeNonNull = skeleton != null;
        var meshGenerator = ReadField(component, "meshGenerator");
        result.meshGeneratorNonNull = meshGenerator != null;
        result.meshGeneratorType = meshGenerator != null ? meshGenerator.GetType().FullName : "";
    }

    private static void TraceTrackEntry(object state, ActorProbeResult result, int frameIndex)
    {
        if (state == null) return;
        try
        {
            var getCurrent = state.GetType().GetMethod("GetCurrent", new[] { typeof(int) });
            var entry = getCurrent != null ? getCurrent.Invoke(state, new object[] { 0 }) : null;
            if (entry == null) return;
            var animation = ReadProperty(entry, "Animation");
            var animationName = ReadStringPropertyOrField(animation, "Name");
            var trackTime = ReadFloatPropertyOrField(entry, "TrackTime");
            var animationTime = ReadFloatPropertyOrField(entry, "AnimationTime");
            result.trackEntries.Add(frameIndex + "|" + animationName + "|track=" + trackTime.ToString("0.###") + "|anim=" + animationTime.ToString("0.###"));
        }
        catch (Exception ex)
        {
            result.trackEntryException = Short(Unwrap(ex));
        }
    }

    private static List<Material> ExtractMaterials(object atlas)
    {
        var materials = new List<Material>();
        var primary = ReadPropertyOrField(atlas, "PrimaryMaterial") as Material;
        if (primary != null) materials.Add(primary);
        foreach (var value in EnumerateCollection(ReadPropertyOrField(atlas, "Materials")))
        {
            var material = value as Material;
            if (material != null) materials.Add(material);
        }
        foreach (var value in EnumerateCollection(ReadPropertyOrField(atlas, "materials")))
        {
            var material = value as Material;
            if (material != null) materials.Add(material);
        }
        return materials;
    }

    private static MeshFrameSnapshot CreateMeshFrameSnapshot(GameObject instance, int frameIndex)
    {
        var snapshot = new MeshFrameSnapshot();
        snapshot.frame = frameIndex;
        int vertices = 0;
        int tris = 0;
        var bounds = new List<string>();
        var hashInput = new StringBuilder();
        foreach (var mf in instance.GetComponentsInChildren<MeshFilter>(true))
        {
            var mesh = mf.sharedMesh;
            if (mesh == null) continue;
            vertices += mesh.vertexCount;
            tris += mesh.triangles != null ? mesh.triangles.Length : 0;
            bounds.Add(mf.name + "|" + Vec(mesh.bounds.center) + "|" + Vec(mesh.bounds.size));
            hashInput.Append(mf.name).Append("|").Append(mesh.vertexCount).Append("|").Append(Vec(mesh.bounds.center)).Append("|").Append(Vec(mesh.bounds.size));
            var verts = mesh.vertices;
            int step = Math.Max(1, verts.Length / 32);
            for (int i = 0; i < verts.Length; i += step)
            {
                hashInput.Append("|").Append(Vec(verts[i]));
            }
        }
        snapshot.meshVertexCount = vertices;
        snapshot.meshTriangleIndexCount = tris;
        snapshot.meshBoundsJoined = string.Join(";", bounds.ToArray());
        snapshot.meshHash = StableHash(hashInput.ToString());
        return snapshot;
    }

    private static void DumpMeshSnapshot(GameObject instance, ActorProbeResult result, string label, bool before)
    {
        var snap = CreateMeshFrameSnapshot(instance, before ? -1 : 99);
        if (before)
        {
            result.meshVertexCountBefore = snap.meshVertexCount;
            result.meshTriangleIndexCountBefore = snap.meshTriangleIndexCount;
            result.meshBoundsBeforeJoined = snap.meshBoundsJoined;
            result.meshHashBefore = snap.meshHash;
        }
        else
        {
            result.meshVertexCountAfter = snap.meshVertexCount;
            result.meshTriangleIndexCountAfter = snap.meshTriangleIndexCount;
            result.meshBoundsAfterJoined = snap.meshBoundsJoined;
            result.meshHashAfter = snap.meshHash;
        }
        foreach (var renderer in instance.GetComponentsInChildren<Renderer>(true))
        {
            foreach (var material in renderer.sharedMaterials)
            {
                if (material == null) continue;
                if (before) result.rendererMaterialBefore.Add(MaterialInfo(material));
                else result.rendererMaterialAfter.Add(MaterialInfo(material));
                var shaderName = material.shader != null ? material.shader.name : "";
                if (material.shader != null && !material.shader.isSupported) result.unsupportedShaderMaterialCount++;
                if (shaderName == "Hidden/InternalErrorShader" || shaderName.ToLowerInvariant().Contains("error"))
                    result.internalErrorShaderMaterialCount++;
            }
        }
    }

    private static void DumpHierarchy(ActorTarget target, ActorProbeResult result, Transform transform, string path, List<ComponentRow> rows)
    {
        var components = transform.gameObject.GetComponents<Component>();
        var typeParts = new List<string>();
        foreach (var component in components)
        {
            typeParts.Add(component == null ? "MissingScript" : (component.GetType().FullName ?? component.GetType().Name));
        }
        var renderer = transform.gameObject.GetComponent<Renderer>();
        var meshFilter = transform.gameObject.GetComponent<MeshFilter>();
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
            activeInHierarchy = transform.gameObject.activeInHierarchy,
            componentTypes = string.Join(";", typeParts.ToArray()),
            rendererType = renderer != null ? renderer.GetType().Name : "",
            rendererEnabled = renderer != null && renderer.enabled,
            materialNames = renderer != null ? MaterialNames(renderer) : "",
            shaderNames = renderer != null ? ShaderNames(renderer) : "",
            shaderSupported = renderer != null ? ShaderSupported(renderer) : "",
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
        sb.AppendLine("side,heroDid,modelId,hierarchyPath,activeInHierarchy,componentTypes,rendererType,rendererEnabled,materialNames,shaderNames,shaderSupported,textureNames,meshVertexCount,meshTriangleIndexCount,localPosition,localScale");
        foreach (var row in rows)
        {
            sb.AppendLine(Csv(row.side) + "," + Csv(row.heroDid) + "," + Csv(row.modelId) + "," + Csv(row.hierarchyPath) + "," + Bool(row.activeInHierarchy) + "," + Csv(row.componentTypes) + "," + Csv(row.rendererType) + "," + Bool(row.rendererEnabled) + "," + Csv(row.materialNames) + "," + Csv(row.shaderNames) + "," + Csv(row.shaderSupported) + "," + Csv(row.textureNames) + "," + row.meshVertexCount + "," + row.meshTriangleIndexCount + "," + Csv(row.localPosition) + "," + Csv(row.localScale));
        }
        File.WriteAllText(path, sb.ToString(), new UTF8Encoding(false));
    }

    private static void WriteJson(string path, List<ActorProbeResult> results, List<ComponentRow> rows, ShaderDependencyInfo shaderInfo, RuntimeInfo runtimeInfo)
    {
        var sb = new StringBuilder();
        int meshChanged = Count(results, r => r.realMeshUpdated);
        int unsupportedShader = Sum(results, r => r.unsupportedShaderMaterialCount);
        int nullSkeletonData = Count(results, r => r.skeletonDataNull);
        int setAnimation = Count(results, r => r.animationStateSetSucceeded);
        sb.AppendLine("{");
        sb.AppendLine("  \"verdict\": \"battle36_trace_real_spine_initialize_skeletondata_material_shader_binding\",");
        sb.AppendLine("  \"visual_status\": \"failed_clip05_actor_motion_not_verified\",");
        sb.AppendLine("  \"isFinalRestoredBattleScreen\": false,");
        sb.AppendLine("  \"scene\": \"" + Json(ScenePath) + "\",");
        sb.AppendLine("  \"capture\": \"" + Json(CapturePath) + "\",");
        sb.AppendLine("  \"runtimeTypePresence\": " + RuntimeInfoJson(runtimeInfo) + ",");
        sb.AppendLine("  \"summary\": {");
        sb.AppendLine("    \"targetActorCount\": " + results.Count + ",");
        sb.AppendLine("    \"componentRowCount\": " + rows.Count + ",");
        sb.AppendLine("    \"bundleLoadSuccess\": " + Count(results, r => r.bundleLoaded) + ",");
        sb.AppendLine("    \"prefabInstantiateSuccess\": " + Count(results, r => r.prefabInstantiated) + ",");
        sb.AppendLine("    \"skeletonAnimationComponentCount\": " + Sum(results, r => r.skeletonAnimationComponentCount) + ",");
        sb.AppendLine("    \"initializeCalledCount\": " + Count(results, r => r.initializeCalled) + ",");
        sb.AppendLine("    \"skeletonDataNullCount\": " + nullSkeletonData + ",");
        sb.AppendLine("    \"meshGeneratorNonNullCount\": " + Count(results, r => r.meshGeneratorNonNull) + ",");
        sb.AppendLine("    \"animationStateSetSucceededCount\": " + setAnimation + ",");
        sb.AppendLine("    \"updateFloatCalledCount\": " + Count(results, r => r.updateFloatCalled) + ",");
        sb.AppendLine("    \"realMeshUpdatedCount\": " + meshChanged + ",");
        sb.AppendLine("    \"unsupportedShaderMaterialCount\": " + unsupportedShader + ",");
        sb.AppendLine("    \"internalErrorShaderMaterialCount\": " + Sum(results, r => r.internalErrorShaderMaterialCount));
        sb.AppendLine("  },");
        sb.AppendLine("  \"shaderDependency\": " + ShaderDependencyJson(shaderInfo) + ",");
        sb.AppendLine("  \"actors\": [");
        for (int i = 0; i < results.Count; i++)
        {
            sb.Append(ActorJson(results[i], "    "));
            if (i + 1 < results.Count) sb.Append(",");
            sb.AppendLine();
        }
        sb.AppendLine("  ]");
        sb.AppendLine("}");
        File.WriteAllText(path, sb.ToString(), new UTF8Encoding(false));
    }

    private static string ActorJson(ActorProbeResult r, string indent)
    {
        var sb = new StringBuilder();
        sb.AppendLine(indent + "{");
        Add(sb, indent, "side", r.side, true);
        Add(sb, indent, "heroDid", r.heroDid, true);
        Add(sb, indent, "modelId", r.modelId, true);
        Add(sb, indent, "expectedAnimation", r.expectedAnimation, true);
        Add(sb, indent, "animationCandidates", r.animationCandidates, true);
        Add(sb, indent, "bundle", r.bundle, true);
        Add(sb, indent, "prefabAsset", r.prefabAsset, true);
        Add(sb, indent, "bundleLoaded", r.bundleLoaded, true);
        Add(sb, indent, "prefabInstantiated", r.prefabInstantiated, true);
        Add(sb, indent, "missingScriptCount", r.missingScriptCount, true);
        Add(sb, indent, "skeletonAnimationComponentCount", r.skeletonAnimationComponentCount, true);
        Add(sb, indent, "skeletonAnimationAssembly", r.skeletonAnimationAssembly, true);
        Add(sb, indent, "serializedAnimationName", r.serializedAnimationName, true);
        Add(sb, indent, "initialValid", r.initialValid, true);
        Add(sb, indent, "initializeCalled", r.initializeCalled, true);
        Add(sb, indent, "afterInitializeValid", r.afterInitializeValid, true);
        Add(sb, indent, "skeletonDataAssetName", r.skeletonDataAssetName, true);
        Add(sb, indent, "skeletonDataAssetType", r.skeletonDataAssetType, true);
        Add(sb, indent, "skeletonDataAssetIsLoaded", r.skeletonDataAssetIsLoaded, true);
        Add(sb, indent, "skeletonDataAssetScale", r.skeletonDataAssetScale, true);
        Add(sb, indent, "skeletonJsonName", r.skeletonJsonName, true);
        Add(sb, indent, "skeletonDataNull", r.skeletonDataNull, true);
        Add(sb, indent, "skeletonDataException", r.skeletonDataException, true);
        Add(sb, indent, "boneCount", r.boneCount, true);
        Add(sb, indent, "slotCount", r.slotCount, true);
        Add(sb, indent, "skinCount", r.skinCount, true);
        Add(sb, indent, "animationCount", r.animationCount, true);
        Add(sb, indent, "animationNames", r.animationNames, true);
        Add(sb, indent, "expectedAnimationInRuntime", r.expectedAnimationInRuntime, true);
        Add(sb, indent, "skeletonRuntimeNonNull", r.skeletonRuntimeNonNull, true);
        Add(sb, indent, "animationStateNonNull", r.animationStateNonNull, true);
        Add(sb, indent, "animationStateSetSucceeded", r.animationStateSetSucceeded, true);
        Add(sb, indent, "animationStateUsedName", r.animationStateUsedName, true);
        Add(sb, indent, "animationFallbackUsed", r.animationFallbackUsed, true);
        Add(sb, indent, "updateFloatCalled", r.updateFloatCalled, true);
        Add(sb, indent, "lateUpdateCalled", r.lateUpdateCalled, true);
        Add(sb, indent, "meshGeneratorNonNull", r.meshGeneratorNonNull, true);
        Add(sb, indent, "meshGeneratorType", r.meshGeneratorType, true);
        Add(sb, indent, "meshVertexCountBefore", r.meshVertexCountBefore, true);
        Add(sb, indent, "meshVertexCountAfter", r.meshVertexCountAfter, true);
        Add(sb, indent, "meshHashBefore", r.meshHashBefore, true);
        Add(sb, indent, "meshHashAfter", r.meshHashAfter, true);
        Add(sb, indent, "meshHashChangedFrameCount", r.meshHashChangedFrameCount, true);
        Add(sb, indent, "meshBoundsChangedFrameCount", r.meshBoundsChangedFrameCount, true);
        Add(sb, indent, "realMeshUpdated", r.realMeshUpdated, true);
        Add(sb, indent, "unsupportedShaderMaterialCount", r.unsupportedShaderMaterialCount, true);
        Add(sb, indent, "internalErrorShaderMaterialCount", r.internalErrorShaderMaterialCount, true);
        Add(sb, indent, "motionReplayStatus", r.motionReplayStatus, true);
        Add(sb, indent, "failReason", r.failReason, true);
        Add(sb, indent, "runtimeException", r.runtimeException, true);
        Add(sb, indent, "animationStateException", r.animationStateException, true);
        Add(sb, indent, "trackEntryException", r.trackEntryException, true);
        Add(sb, indent, "atlasAssetNames", r.atlasAssetNames, true);
        Add(sb, indent, "atlasMaterialInfos", r.atlasMaterialInfos, true);
        Add(sb, indent, "atlasTextureInfos", r.atlasTextureInfos, true);
        Add(sb, indent, "textureNames", r.textureNames, true);
        Add(sb, indent, "bundleMaterialNames", r.bundleMaterialNames, true);
        Add(sb, indent, "rendererMaterialBefore", r.rendererMaterialBefore, true);
        Add(sb, indent, "rendererMaterialAfter", r.rendererMaterialAfter, true);
        Add(sb, indent, "skeletonLikeAssets", r.skeletonLikeAssets, true);
        Add(sb, indent, "trackEntries", r.trackEntries, true);
        sb.AppendLine(indent + "  \"frameSnapshots\": [");
        for (int i = 0; i < r.frameSnapshots.Count; i++)
        {
            var f = r.frameSnapshots[i];
            sb.Append(indent + "    {\"frame\":" + f.frame + ",\"meshVertexCount\":" + f.meshVertexCount + ",\"meshTriangleIndexCount\":" + f.meshTriangleIndexCount + ",\"meshHash\":\"" + Json(f.meshHash) + "\",\"meshBoundsJoined\":\"" + Json(f.meshBoundsJoined) + "\"}");
            if (i + 1 < r.frameSnapshots.Count) sb.Append(",");
            sb.AppendLine();
        }
        sb.AppendLine(indent + "  ]");
        sb.Append(indent + "}");
        return sb.ToString();
    }

    private static void Add(StringBuilder sb, string indent, string name, string value, bool comma)
    {
        sb.AppendLine(indent + "  \"" + name + "\": \"" + Json(value) + "\"," );
    }

    private static void Add(StringBuilder sb, string indent, string name, bool value, bool comma)
    {
        sb.AppendLine(indent + "  \"" + name + "\": " + Bool(value) + ",");
    }

    private static void Add(StringBuilder sb, string indent, string name, int value, bool comma)
    {
        sb.AppendLine(indent + "  \"" + name + "\": " + value + ",");
    }

    private static void Add(StringBuilder sb, string indent, string name, float value, bool comma)
    {
        sb.AppendLine(indent + "  \"" + name + "\": " + value.ToString("0.######") + ",");
    }

    private static void Add(StringBuilder sb, string indent, string name, List<string> values, bool comma)
    {
        sb.AppendLine(indent + "  \"" + name + "\": " + JsonArray(values) + ",");
    }

    private static string RuntimeInfoJson(RuntimeInfo info)
    {
        return "{\"SkeletonAnimation\":" + Bool(info.skeletonAnimation) +
               ",\"SkeletonRenderer\":" + Bool(info.skeletonRenderer) +
               ",\"SkeletonDataAsset\":" + Bool(info.skeletonDataAsset) +
               ",\"AtlasAsset\":" + Bool(info.atlasAsset) +
               ",\"MeshGenerator\":" + Bool(info.meshGenerator) +
               ",\"SkeletonBinary\":" + Bool(info.skeletonBinary) +
               ",\"AnimationState\":" + Bool(info.animationState) +
               ",\"AtlasAttachmentLoader\":" + Bool(info.atlasAttachmentLoader) +
               ",\"realRuntimePresent\":" + Bool(info.realRuntimePresent) + "}";
    }

    private static string ShaderDependencyJson(ShaderDependencyInfo info)
    {
        return "{\"bundle\":\"" + Json(info.bundle) + "\",\"absolutePath\":\"" + Json(info.absolutePath) + "\",\"fileExists\":" + Bool(info.fileExists) + ",\"fileSize\":" + info.fileSize + ",\"loaded\":" + Bool(info.loaded) + ",\"status\":\"" + Json(info.status) + "\",\"shaderNames\":" + JsonArray(info.shaderNames) + ",\"materialNames\":" + JsonArray(info.materialNames) + ",\"assetTypes\":" + JsonArray(info.assetTypes) + ",\"loadExceptions\":" + JsonArray(info.loadExceptions) + "}";
    }

    private static object ReadField(object obj, string name)
    {
        if (obj == null) return null;
        var type = obj.GetType();
        while (type != null)
        {
            var field = type.GetField(name, BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance);
            if (field != null) return field.GetValue(obj);
            type = type.BaseType;
        }
        return null;
    }

    private static object ReadProperty(object obj, string name)
    {
        if (obj == null) return null;
        var type = obj.GetType();
        while (type != null)
        {
            var prop = type.GetProperty(name, BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance);
            if (prop != null) return prop.GetValue(obj, null);
            type = type.BaseType;
        }
        return null;
    }

    private static object ReadPropertyOrField(object obj, string name)
    {
        var value = ReadProperty(obj, name);
        return value ?? ReadField(obj, name);
    }

    private static string ReadStringField(object obj, string name)
    {
        var value = ReadField(obj, name);
        return value as string ?? "";
    }

    private static string ReadStringPropertyOrField(object obj, string name)
    {
        var value = ReadPropertyOrField(obj, name);
        return value != null ? value.ToString() : "";
    }

    private static float ReadFloatPropertyOrField(object obj, string name)
    {
        var value = ReadPropertyOrField(obj, name);
        if (value is float) return (float)value;
        if (value is double) return (float)(double)value;
        return 0f;
    }

    private static bool ReadBoolPropertyOrField(object obj, string name)
    {
        var value = ReadPropertyOrField(obj, name);
        return value is bool && (bool)value;
    }

    private static bool ReadBoolField(object obj, string name)
    {
        var value = ReadField(obj, name);
        return value is bool && (bool)value;
    }

    private static IEnumerable<object> EnumerateCollection(object collection)
    {
        if (collection == null) yield break;
        var asEnumerable = collection as IEnumerable;
        if (asEnumerable != null && !(collection is string))
        {
            foreach (var item in asEnumerable) yield return item;
            yield break;
        }
        var items = ReadField(collection, "Items") as Array;
        int count = CountCollection(collection);
        if (items != null)
        {
            for (int i = 0; i < items.Length && (count <= 0 || i < count); i++)
                yield return items.GetValue(i);
        }
    }

    private static int CountCollection(object collection)
    {
        if (collection == null) return 0;
        var countValue = ReadPropertyOrField(collection, "Count");
        if (countValue is int) return (int)countValue;
        var asCollection = collection as ICollection;
        if (asCollection != null) return asCollection.Count;
        var items = ReadField(collection, "Items") as Array;
        return items != null ? items.Length : 0;
    }

    private static void InvokeIfExists(object obj, string name, Type[] types, object[] args)
    {
        var method = obj.GetType().GetMethod(name, BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance, null, types, null);
        if (method != null) method.Invoke(obj, args);
    }

    private static string ObjectName(object obj)
    {
        var unityObject = obj as UnityEngine.Object;
        return unityObject != null ? unityObject.name : "";
    }

    private static string MaterialInfo(Material material)
    {
        if (material == null) return "";
        var shader = material.shader;
        var tex = material.mainTexture;
        string texInfo = tex != null ? tex.name + "(" + tex.width + "x" + tex.height + ")" : "";
        string shaderInfo = shader != null ? shader.name + "|supported=" + Bool(shader.isSupported) + "|passCount=" + shader.passCount : "";
        return material.name + "|shader=" + shaderInfo + "|mainTex=" + texInfo + "|renderQueue=" + material.renderQueue;
    }

    private static string ShaderInfo(Shader shader)
    {
        return shader.name + "|supported=" + Bool(shader.isSupported) + "|passCount=" + shader.passCount;
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

    private static string ShaderSupported(Renderer renderer)
    {
        var parts = new List<string>();
        foreach (var m in renderer.sharedMaterials)
            if (m != null && m.shader != null) parts.Add(m.shader.name + "=" + Bool(m.shader.isSupported) + "/pass" + m.shader.passCount);
        return string.Join(";", parts.ToArray());
    }

    private static string TextureNames(Renderer renderer)
    {
        var parts = new List<string>();
        foreach (var m in renderer.sharedMaterials) if (m != null && m.mainTexture != null) parts.Add(m.mainTexture.name + "(" + m.mainTexture.width + "x" + m.mainTexture.height + ")");
        return string.Join(";", parts.ToArray());
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

    private static int Sum(List<ActorProbeResult> rows, Func<ActorProbeResult, int> selector)
    {
        int count = 0;
        foreach (var row in rows) count += selector(row);
        return count;
    }

    private static string StableHash(string value)
    {
        unchecked
        {
            uint hash = 2166136261;
            for (int i = 0; i < value.Length; i++)
            {
                hash ^= value[i];
                hash *= 16777619;
            }
            return hash.ToString("x8");
        }
    }

    private static string Unwrap(Exception ex)
    {
        var target = ex as TargetInvocationException;
        if (target != null && target.InnerException != null) return target.InnerException.Message;
        return ex.Message;
    }

    private static string Short(string value)
    {
        if (string.IsNullOrEmpty(value)) return "";
        value = value.Replace("\r", " ").Replace("\n", " ");
        return value.Length > 220 ? value.Substring(0, 220) : value;
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
        public List<string> animationCandidates;
        public string bundle;
        public string prefabAsset;
        public Vector3 position;
        public float scale;

        public ActorTarget(string side, string heroDid, string modelId, string expectedAnimation, string[] animationCandidates, string bundle, string prefabAsset, Vector3 position, float scale)
        {
            this.side = side;
            this.heroDid = heroDid;
            this.modelId = modelId;
            this.expectedAnimation = expectedAnimation;
            this.animationCandidates = new List<string>(animationCandidates);
            this.bundle = bundle;
            this.prefabAsset = prefabAsset;
            this.position = position;
            this.scale = scale;
        }
    }

    private sealed class RuntimeInfo
    {
        public bool skeletonAnimation;
        public bool skeletonRenderer;
        public bool skeletonDataAsset;
        public bool atlasAsset;
        public bool meshGenerator;
        public bool skeletonBinary;
        public bool animationState;
        public bool atlasAttachmentLoader;
        public bool realRuntimePresent;
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

    private sealed class MeshFrameSnapshot
    {
        public int frame;
        public int meshVertexCount;
        public int meshTriangleIndexCount;
        public string meshBoundsJoined = "";
        public string meshHash = "";
    }

    private sealed class ActorProbeResult
    {
        public string side = "";
        public string heroDid = "";
        public string modelId = "";
        public string expectedAnimation = "";
        public List<string> animationCandidates = new List<string>();
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
        public int meshVertexCountBefore;
        public int meshVertexCountAfter;
        public int meshTriangleIndexCountBefore;
        public int meshTriangleIndexCountAfter;
        public string meshBoundsBeforeJoined = "";
        public string meshBoundsAfterJoined = "";
        public string meshHashBefore = "";
        public string meshHashAfter = "";
        public int meshHashChangedFrameCount;
        public int meshBoundsChangedFrameCount;
        public bool realMeshUpdated;
        public int missingScriptCount;
        public int skeletonAnimationComponentCount;
        public string skeletonAnimationAssembly = "";
        public string serializedAnimationName = "";
        public bool initialValid;
        public bool initializeCalled;
        public bool afterInitializeValid;
        public string skeletonDataAssetName = "";
        public string skeletonDataAssetType = "";
        public bool skeletonDataAssetIsLoaded;
        public float skeletonDataAssetScale;
        public string skeletonJsonName = "";
        public bool skeletonDataNull;
        public string skeletonDataException = "";
        public int boneCount;
        public int slotCount;
        public int skinCount;
        public int animationCount;
        public bool expectedAnimationInRuntime;
        public bool skeletonRuntimeNonNull;
        public bool animationStateNonNull;
        public string animationStateUsedName = "";
        public bool animationStateSetSucceeded;
        public bool animationFallbackUsed;
        public bool updateFloatCalled;
        public bool lateUpdateCalled;
        public bool meshGeneratorNonNull;
        public string meshGeneratorType = "";
        public int internalErrorShaderMaterialCount;
        public int unsupportedShaderMaterialCount;
        public string runtimeException = "";
        public string animationStateException = "";
        public string trackEntryException = "";
        public string motionReplayStatus = "not_evaluated";
        public string failReason = "";
        public List<string> animationNames = new List<string>();
        public List<string> atlasAssetNames = new List<string>();
        public List<string> atlasMaterialInfos = new List<string>();
        public List<string> atlasTextureInfos = new List<string>();
        public List<string> textureNames = new List<string>();
        public List<string> bundleMaterialNames = new List<string>();
        public List<string> rendererMaterialBefore = new List<string>();
        public List<string> rendererMaterialAfter = new List<string>();
        public List<string> prefabAssetNames = new List<string>();
        public List<string> skeletonLikeAssets = new List<string>();
        public List<string> loadExceptions = new List<string>();
        public List<string> trackEntries = new List<string>();
        public List<MeshFrameSnapshot> frameSnapshots = new List<MeshFrameSnapshot>();
    }

    private sealed class ComponentRow
    {
        public string side = "";
        public string heroDid = "";
        public string modelId = "";
        public string hierarchyPath = "";
        public bool activeInHierarchy;
        public string componentTypes = "";
        public string rendererType = "";
        public bool rendererEnabled;
        public string materialNames = "";
        public string shaderNames = "";
        public string shaderSupported = "";
        public string textureNames = "";
        public int meshVertexCount;
        public int meshTriangleIndexCount;
        public string localPosition = "";
        public string localScale = "";
    }
}
