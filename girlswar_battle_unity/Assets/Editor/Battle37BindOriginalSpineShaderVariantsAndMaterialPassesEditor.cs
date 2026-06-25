using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Reflection;
using System.Text;

public static class Battle37BindOriginalSpineShaderVariantsAndMaterialPassesEditor
{
    private const string ResultJsonPath = "Assets/RestoreData/battle/BATTLE_37_BIND_ORIGINAL_SPINE_SHADER_VARIANTS_AND_MATERIAL_PASSES_UNITY.json";
    private const string MaterialCsvPath = "Assets/RestoreData/battle/BATTLE_37_BIND_ORIGINAL_SPINE_SHADER_VARIANTS_AND_MATERIAL_PASSES_MATERIALS.csv";
    private const string ComponentCsvPath = "Assets/RestoreData/battle/BATTLE_37_BIND_ORIGINAL_SPINE_SHADER_VARIANTS_AND_MATERIAL_PASSES_COMPONENTS.csv";
    private const string ScenePath = "Assets/Scenes/Battle37BindOriginalSpineShaderVariantsAndMaterialPasses.unity";
    private const string CapturePath = "Assets/RestoreCaptures/battle_actor/Battle37BindOriginalSpineShaderVariantsAndMaterialPasses_1920x1080.png";
    private const string BundleRoot = "C:/Users/godho/Downloads/girlswar/girlswar_merged_extracted/extracted/unity/clean_unityfs_slices";
    private const string SpineShaderBundle = "download/commonprefabsandres/spinematandshaders.assetbundle";

    [MenuItem("GirlsWar/Battle/BATTLE37 Bind Original Spine Shader Variants And Material Passes")]
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
        var root = new GameObject("BATTLE37_BindOriginalSpineShaderVariantsAndMaterialPassesRoot");
        var cameraObject = new GameObject("BATTLE37_ProbeCamera");
        var camera = cameraObject.AddComponent<Camera>();
        camera.clearFlags = CameraClearFlags.SolidColor;
        camera.backgroundColor = new Color(0.035f, 0.037f, 0.042f, 1f);
        camera.orthographic = true;
        camera.orthographicSize = 3.4f;
        cameraObject.transform.position = new Vector3(0f, 0f, -10f);

        var opened = new List<AssetBundle>();
        var shaderBundle = LoadShaderBundle(opened);
        var runtimeInfo = ProbeRuntimeTypes();
        var actors = new List<ActorResult>();
        var materialRows = new List<MaterialRow>();
        var componentRows = new List<ComponentRow>();

        foreach (var target in targets)
        {
            actors.Add(ProbeActor(target, root.transform, opened, materialRows, componentRows));
        }

        Capture(camera, ProjectPath(CapturePath));
        WriteMaterialCsv(ProjectPath(MaterialCsvPath), materialRows);
        WriteComponentCsv(ProjectPath(ComponentCsvPath), componentRows);
        WriteJson(ProjectPath(ResultJsonPath), shaderBundle, runtimeInfo, actors, materialRows, componentRows);
        EditorSceneManager.SaveScene(scene, ScenePath);

        foreach (var bundle in opened)
            if (bundle != null) bundle.Unload(false);
        AssetDatabase.Refresh();
        Debug.Log("BATTLE37 shader/material pass probe complete. actors=" + actors.Count + ", materialRows=" + materialRows.Count);
    }

    private static RuntimeInfo ProbeRuntimeTypes()
    {
        return new RuntimeInfo
        {
            skeletonAnimation = TypeExists("Spine.Unity.SkeletonAnimation, spine-unity"),
            skeletonRenderer = TypeExists("Spine.Unity.SkeletonRenderer, spine-unity"),
            skeletonDataAsset = TypeExists("Spine.Unity.SkeletonDataAsset, spine-unity"),
            meshGenerator = TypeExists("Spine.Unity.MeshGenerator, spine-unity"),
            animationState = TypeExists("Spine.AnimationState, spine-csharp") || TypeExists("Spine.AnimationState, spine-unity"),
        };
    }

    private static bool TypeExists(string typeName)
    {
        return Type.GetType(typeName) != null;
    }

    private static ShaderBundleInfo LoadShaderBundle(List<AssetBundle> opened)
    {
        var info = new ShaderBundleInfo();
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
        foreach (var assetName in bundle.GetAllAssetNames())
        {
            UnityEngine.Object asset = null;
            try { asset = bundle.LoadAsset<UnityEngine.Object>(assetName); }
            catch (Exception ex) { info.loadExceptions.Add(assetName + " :: " + Short(Unwrap(ex))); }
            if (asset == null) continue;
            info.assetTypes.Add(assetName + "|" + (asset.GetType().FullName ?? asset.GetType().Name));
            var shader = asset as Shader;
            if (shader != null) info.shaderAssets.Add(ShaderInfo(shader));
            var material = asset as Material;
            if (material != null) info.materialAssets.Add(MaterialInfo(material));
        }
        return info;
    }

    private static ActorResult ProbeActor(ActorTarget target, Transform root, List<AssetBundle> opened, List<MaterialRow> materialRows, List<ComponentRow> componentRows)
    {
        var result = new ActorResult();
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
            catch (Exception ex) { result.loadExceptions.Add(name + " :: " + Short(Unwrap(ex))); }
            if (asset == null) continue;
            var lower = name.ToLowerInvariant();
            if (lower.EndsWith(".prefab")) result.prefabAssetNames.Add(name);
            if (lower.Contains("skeletondata") || lower.Contains("atlas") || lower.EndsWith(".skel.bytes"))
                result.skeletonLikeAssets.Add(name);
            var material = asset as Material;
            if (material != null)
                TraceAndMaybeRebindMaterial(target, result, "bundle_material", name, material, materialRows);
        }

        var prefab = bundle.LoadAsset<GameObject>(target.prefabAsset);
        if (prefab == null)
        {
            foreach (var prefabName in result.prefabAssetNames)
            {
                if (prefabName.ToLowerInvariant().Contains("hero_"))
                {
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
        instance.name = "BATTLE37_LoadableActor_" + target.side + "_" + target.heroDid + "_model_" + target.modelId;
        instance.transform.localScale = Vector3.one * target.scale;
        result.prefabInstantiated = true;

        TraceRendererMaterials(target, result, instance, "renderer_before_runtime", materialRows);
        TraceSkeletonAndApplyShaderRebind(target, result, instance, materialRows);
        AdvanceAnimation(target, result, instance);
        TraceRendererMaterials(target, result, instance, "renderer_after_runtime", materialRows);
        DumpHierarchy(target, instance.transform, instance.name, componentRows);

        result.realMeshUpdated = result.meshHashChangedFrameCount > 0 || result.meshBoundsChangedFrameCount > 0;
        if (result.realMeshUpdated && result.shaderRebindAppliedCount > 0)
            result.motionReplayStatus = "mesh_changes_after_same_name_spine_shader_rebind_but_clip05_motion_not_verified";
        else if (result.realMeshUpdated)
            result.motionReplayStatus = "mesh_changes_after_update_float_but_shader_rebind_not_applied";
        else
            result.motionReplayStatus = "failed_mesh_hash_static_after_shader_probe";
        return result;
    }

    private static void TraceSkeletonAndApplyShaderRebind(ActorTarget target, ActorResult result, GameObject instance, List<MaterialRow> materialRows)
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
            try
            {
                InvokeIfExists(component, "Initialize", new[] { typeof(bool), typeof(bool) }, new object[] { true, false });
                result.initializeCalled = true;
                result.afterInitializeValid = ReadBoolField(component, "valid");
                var sda = ReadField(component, "skeletonDataAsset");
                result.skeletonDataAssetName = ObjectName(sda);
                result.skeletonDataAssetType = sda != null ? sda.GetType().FullName : "";
                TraceAtlasMaterials(target, result, sda, materialRows);
                TraceSkeletonData(component, result);
            }
            catch (Exception ex)
            {
                result.runtimeException = Short(Unwrap(ex));
            }
        }
    }

    private static void TraceAtlasMaterials(ActorTarget target, ActorResult result, object skeletonDataAsset, List<MaterialRow> materialRows)
    {
        if (skeletonDataAsset == null) return;
        var atlasAssets = ReadField(skeletonDataAsset, "atlasAssets");
        foreach (var atlas in EnumerateCollection(atlasAssets))
        {
            if (atlas == null) continue;
            result.atlasAssetNames.Add(ObjectName(atlas) + "|" + atlas.GetType().FullName);
            foreach (var material in ExtractMaterials(atlas))
            {
                TraceAndMaybeRebindMaterial(target, result, "atlas_material", ObjectName(atlas), material, materialRows);
            }
        }
    }

    private static void TraceSkeletonData(Component component, ActorResult result)
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
        result.skeletonDataNull = skeletonData == null;
        if (skeletonData == null) return;
        result.boneCount = CountCollection(ReadPropertyOrField(skeletonData, "Bones"));
        result.slotCount = CountCollection(ReadPropertyOrField(skeletonData, "Slots"));
        var animations = ReadPropertyOrField(skeletonData, "Animations");
        result.animationCount = CountCollection(animations);
        foreach (var animation in EnumerateCollection(animations))
        {
            var name = ReadStringPropertyOrField(animation, "Name");
            if (!string.IsNullOrEmpty(name)) result.animationNames.Add(name);
        }
        result.expectedAnimationInRuntime = result.animationNames.Contains(result.expectedAnimation);
        result.meshGeneratorNonNull = ReadField(component, "meshGenerator") != null;
    }

    private static void AdvanceAnimation(ActorTarget target, ActorResult result, GameObject instance)
    {
        foreach (var component in instance.GetComponentsInChildren<Component>(true))
        {
            if (component == null || (component.GetType().FullName ?? component.GetType().Name) != "Spine.Unity.SkeletonAnimation") continue;
            try
            {
                var state = ReadProperty(component, "AnimationState");
                result.animationStateNonNull = state != null;
                var set = state != null ? state.GetType().GetMethod("SetAnimation", new[] { typeof(int), typeof(string), typeof(bool) }) : null;
                if (set != null)
                {
                    foreach (var candidate in target.animationCandidates)
                    {
                        if (!string.IsNullOrEmpty(candidate) && (result.animationNames.Contains(candidate) || !result.animationStateSetSucceeded))
                        {
                            try
                            {
                                set.Invoke(state, new object[] { 0, candidate, true });
                                result.animationStateSetSucceeded = true;
                                result.animationStateUsedName = candidate;
                                result.animationFallbackUsed = candidate != target.expectedAnimation;
                                break;
                            }
                            catch (Exception ex)
                            {
                                result.animationStateException = Short(Unwrap(ex));
                            }
                        }
                    }
                }
                for (int i = 0; i < 12; i++)
                {
                    InvokeIfExists(component, "Update", new[] { typeof(float) }, new object[] { 1f / 30f });
                    InvokeIfExists(component, "LateUpdate", Type.EmptyTypes, new object[0]);
                    var snapshot = MeshSnapshot(instance, i);
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

    private static void TraceAndMaybeRebindMaterial(ActorTarget target, ActorResult result, string sourceKind, string sourcePath, Material material, List<MaterialRow> rows)
    {
        if (material == null) return;
        var beforeShader = material.shader;
        var beforeName = beforeShader != null ? beforeShader.name : "";
        bool beforeSupported = beforeShader != null && beforeShader.isSupported;
        int beforePass = beforeShader != null ? beforeShader.passCount : 0;
        var texture = material.mainTexture;
        var row = new MaterialRow
        {
            side = target.side,
            heroDid = target.heroDid,
            modelId = target.modelId,
            sourceKind = sourceKind,
            sourcePath = sourcePath,
            materialName = material.name,
            originalShaderName = beforeName,
            originalShaderSupported = beforeSupported,
            originalShaderPassCount = beforePass,
            mainTextureName = texture != null ? texture.name : "",
            mainTextureSize = texture != null ? texture.width + "x" + texture.height : "",
            renderQueueBefore = material.renderQueue,
            rebindAttempted = !beforeSupported && !string.IsNullOrEmpty(beforeName),
        };
        if (!beforeSupported) result.unsupportedShaderMaterialCount++;

        if (row.rebindAttempted)
        {
            var projectShader = Shader.Find(beforeName);
            row.projectShaderFound = projectShader != null;
            row.projectShaderSupported = projectShader != null && projectShader.isSupported;
            row.projectShaderPassCount = projectShader != null ? projectShader.passCount : 0;
            if (projectShader != null && projectShader.isSupported && projectShader.passCount > 0)
            {
                material.shader = projectShader;
                row.rebindApplied = true;
                result.shaderRebindAppliedCount++;
            }
            else
            {
                row.rebindReason = projectShader == null ? "same_name_project_shader_not_found" : "same_name_project_shader_unsupported_or_no_pass";
                result.shaderRebindFailedCount++;
            }
        }
        var afterShader = material.shader;
        row.afterShaderName = afterShader != null ? afterShader.name : "";
        row.afterShaderSupported = afterShader != null && afterShader.isSupported;
        row.afterShaderPassCount = afterShader != null ? afterShader.passCount : 0;
        row.renderQueueAfter = material.renderQueue;
        if (row.rebindApplied) row.rebindReason = "same_name_spine_shader_supported";
        rows.Add(row);
    }

    private static void TraceRendererMaterials(ActorTarget target, ActorResult result, GameObject instance, string sourceKind, List<MaterialRow> rows)
    {
        foreach (var renderer in instance.GetComponentsInChildren<Renderer>(true))
        {
            foreach (var material in renderer.sharedMaterials)
            {
                TraceAndMaybeRebindMaterial(target, result, sourceKind, HierarchyPath(renderer.transform), material, rows);
            }
        }
    }

    private static void TraceTrackEntry(object state, ActorResult result, int frameIndex)
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

    private static MeshFrameSnapshot MeshSnapshot(GameObject instance, int frame)
    {
        var snap = new MeshFrameSnapshot();
        snap.frame = frame;
        var bounds = new List<string>();
        var hashInput = new StringBuilder();
        foreach (var mf in instance.GetComponentsInChildren<MeshFilter>(true))
        {
            var mesh = mf.sharedMesh;
            if (mesh == null) continue;
            snap.meshVertexCount += mesh.vertexCount;
            snap.meshTriangleIndexCount += mesh.triangles != null ? mesh.triangles.Length : 0;
            bounds.Add(mf.name + "|" + Vec(mesh.bounds.center) + "|" + Vec(mesh.bounds.size));
            hashInput.Append(mf.name).Append("|").Append(mesh.vertexCount).Append("|").Append(Vec(mesh.bounds.center)).Append("|").Append(Vec(mesh.bounds.size));
            var vertices = mesh.vertices;
            int step = Math.Max(1, vertices.Length / 32);
            for (int i = 0; i < vertices.Length; i += step)
                hashInput.Append("|").Append(Vec(vertices[i]));
        }
        snap.meshBoundsJoined = string.Join(";", bounds.ToArray());
        snap.meshHash = StableHash(hashInput.ToString());
        return snap;
    }

    private static void DumpHierarchy(ActorTarget target, Transform transform, string path, List<ComponentRow> rows)
    {
        var renderer = transform.gameObject.GetComponent<Renderer>();
        var meshFilter = transform.gameObject.GetComponent<MeshFilter>();
        rows.Add(new ComponentRow
        {
            side = target.side,
            heroDid = target.heroDid,
            modelId = target.modelId,
            hierarchyPath = path,
            activeInHierarchy = transform.gameObject.activeInHierarchy,
            rendererType = renderer != null ? renderer.GetType().Name : "",
            rendererEnabled = renderer != null && renderer.enabled,
            materialNames = renderer != null ? MaterialNames(renderer) : "",
            shaderNames = renderer != null ? ShaderNames(renderer) : "",
            shaderSupported = renderer != null ? ShaderSupported(renderer) : "",
            textureNames = renderer != null ? TextureNames(renderer) : "",
            meshVertexCount = meshFilter != null && meshFilter.sharedMesh != null ? meshFilter.sharedMesh.vertexCount : 0,
            meshTriangleIndexCount = meshFilter != null && meshFilter.sharedMesh != null && meshFilter.sharedMesh.triangles != null ? meshFilter.sharedMesh.triangles.Length : 0,
        });
        for (int i = 0; i < transform.childCount; i++)
        {
            var child = transform.GetChild(i);
            DumpHierarchy(target, child, path + "/" + child.name, rows);
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

    private static void WriteMaterialCsv(string path, List<MaterialRow> rows)
    {
        var sb = new StringBuilder();
        sb.AppendLine("side,heroDid,modelId,sourceKind,sourcePath,materialName,originalShaderName,originalShaderSupported,originalShaderPassCount,projectShaderFound,projectShaderSupported,projectShaderPassCount,rebindAttempted,rebindApplied,rebindReason,afterShaderName,afterShaderSupported,afterShaderPassCount,mainTextureName,mainTextureSize,renderQueueBefore,renderQueueAfter");
        foreach (var row in rows)
        {
            sb.AppendLine(Csv(row.side) + "," + Csv(row.heroDid) + "," + Csv(row.modelId) + "," + Csv(row.sourceKind) + "," + Csv(row.sourcePath) + "," + Csv(row.materialName) + "," + Csv(row.originalShaderName) + "," + Bool(row.originalShaderSupported) + "," + row.originalShaderPassCount + "," + Bool(row.projectShaderFound) + "," + Bool(row.projectShaderSupported) + "," + row.projectShaderPassCount + "," + Bool(row.rebindAttempted) + "," + Bool(row.rebindApplied) + "," + Csv(row.rebindReason) + "," + Csv(row.afterShaderName) + "," + Bool(row.afterShaderSupported) + "," + row.afterShaderPassCount + "," + Csv(row.mainTextureName) + "," + Csv(row.mainTextureSize) + "," + row.renderQueueBefore + "," + row.renderQueueAfter);
        }
        File.WriteAllText(path, sb.ToString(), new UTF8Encoding(false));
    }

    private static void WriteComponentCsv(string path, List<ComponentRow> rows)
    {
        var sb = new StringBuilder();
        sb.AppendLine("side,heroDid,modelId,hierarchyPath,activeInHierarchy,rendererType,rendererEnabled,materialNames,shaderNames,shaderSupported,textureNames,meshVertexCount,meshTriangleIndexCount");
        foreach (var row in rows)
        {
            sb.AppendLine(Csv(row.side) + "," + Csv(row.heroDid) + "," + Csv(row.modelId) + "," + Csv(row.hierarchyPath) + "," + Bool(row.activeInHierarchy) + "," + Csv(row.rendererType) + "," + Bool(row.rendererEnabled) + "," + Csv(row.materialNames) + "," + Csv(row.shaderNames) + "," + Csv(row.shaderSupported) + "," + Csv(row.textureNames) + "," + row.meshVertexCount + "," + row.meshTriangleIndexCount);
        }
        File.WriteAllText(path, sb.ToString(), new UTF8Encoding(false));
    }

    private static void WriteJson(string path, ShaderBundleInfo shaderBundle, RuntimeInfo runtimeInfo, List<ActorResult> actors, List<MaterialRow> materialRows, List<ComponentRow> componentRows)
    {
        var sb = new StringBuilder();
        sb.AppendLine("{");
        sb.AppendLine("  \"verdict\": \"battle37_bind_original_spine_shader_variants_and_material_passes\",");
        sb.AppendLine("  \"visual_status\": \"failed_clip05_actor_motion_not_verified\",");
        sb.AppendLine("  \"isFinalRestoredBattleScreen\": false,");
        sb.AppendLine("  \"scene\": \"" + Json(ScenePath) + "\",");
        sb.AppendLine("  \"capture\": \"" + Json(CapturePath) + "\",");
        sb.AppendLine("  \"runtimeTypePresence\": " + RuntimeInfoJson(runtimeInfo) + ",");
        sb.AppendLine("  \"summary\": {");
        sb.AppendLine("    \"targetActorCount\": " + actors.Count + ",");
        sb.AppendLine("    \"componentRowCount\": " + componentRows.Count + ",");
        sb.AppendLine("    \"materialRowCount\": " + materialRows.Count + ",");
        sb.AppendLine("    \"bundleLoadSuccess\": " + Count(actors, a => a.bundleLoaded) + ",");
        sb.AppendLine("    \"prefabInstantiateSuccess\": " + Count(actors, a => a.prefabInstantiated) + ",");
        sb.AppendLine("    \"skeletonAnimationComponentCount\": " + Sum(actors, a => a.skeletonAnimationComponentCount) + ",");
        sb.AppendLine("    \"initializeValidCount\": " + Count(actors, a => a.afterInitializeValid) + ",");
        sb.AppendLine("    \"animationStateSetSucceededCount\": " + Count(actors, a => a.animationStateSetSucceeded) + ",");
        sb.AppendLine("    \"updateFloatCalledCount\": " + Count(actors, a => a.updateFloatCalled) + ",");
        sb.AppendLine("    \"meshHashChangedActorCount\": " + Count(actors, a => a.meshHashChangedFrameCount > 0) + ",");
        sb.AppendLine("    \"unsupportedShaderMaterialBeforeCount\": " + Count(materialRows, r => !r.originalShaderSupported) + ",");
        sb.AppendLine("    \"sameNameProjectShaderFoundCount\": " + Count(materialRows, r => r.projectShaderFound) + ",");
        sb.AppendLine("    \"sameNameProjectShaderSupportedCount\": " + Count(materialRows, r => r.projectShaderSupported) + ",");
        sb.AppendLine("    \"shaderRebindAppliedCount\": " + Count(materialRows, r => r.rebindApplied) + ",");
        sb.AppendLine("    \"unsupportedShaderMaterialAfterCount\": " + Count(materialRows, r => !r.afterShaderSupported));
        sb.AppendLine("  },");
        sb.AppendLine("  \"shaderBundle\": " + ShaderBundleJson(shaderBundle) + ",");
        sb.AppendLine("  \"actors\": [");
        for (int i = 0; i < actors.Count; i++)
        {
            sb.Append(ActorJson(actors[i], "    "));
            if (i + 1 < actors.Count) sb.Append(",");
            sb.AppendLine();
        }
        sb.AppendLine("  ]");
        sb.AppendLine("}");
        File.WriteAllText(path, sb.ToString(), new UTF8Encoding(false));
    }

    private static string ActorJson(ActorResult a, string indent)
    {
        var sb = new StringBuilder();
        sb.AppendLine(indent + "{");
        Add(sb, indent, "side", a.side);
        Add(sb, indent, "heroDid", a.heroDid);
        Add(sb, indent, "modelId", a.modelId);
        Add(sb, indent, "expectedAnimation", a.expectedAnimation);
        Add(sb, indent, "animationCandidates", a.animationCandidates);
        Add(sb, indent, "bundle", a.bundle);
        Add(sb, indent, "prefabAsset", a.prefabAsset);
        Add(sb, indent, "bundleLoaded", a.bundleLoaded);
        Add(sb, indent, "prefabInstantiated", a.prefabInstantiated);
        Add(sb, indent, "skeletonAnimationComponentCount", a.skeletonAnimationComponentCount);
        Add(sb, indent, "skeletonAnimationAssembly", a.skeletonAnimationAssembly);
        Add(sb, indent, "serializedAnimationName", a.serializedAnimationName);
        Add(sb, indent, "afterInitializeValid", a.afterInitializeValid);
        Add(sb, indent, "skeletonDataAssetName", a.skeletonDataAssetName);
        Add(sb, indent, "boneCount", a.boneCount);
        Add(sb, indent, "slotCount", a.slotCount);
        Add(sb, indent, "animationCount", a.animationCount);
        Add(sb, indent, "animationNames", a.animationNames);
        Add(sb, indent, "expectedAnimationInRuntime", a.expectedAnimationInRuntime);
        Add(sb, indent, "animationStateSetSucceeded", a.animationStateSetSucceeded);
        Add(sb, indent, "animationStateUsedName", a.animationStateUsedName);
        Add(sb, indent, "animationFallbackUsed", a.animationFallbackUsed);
        Add(sb, indent, "updateFloatCalled", a.updateFloatCalled);
        Add(sb, indent, "meshGeneratorNonNull", a.meshGeneratorNonNull);
        Add(sb, indent, "meshHashChangedFrameCount", a.meshHashChangedFrameCount);
        Add(sb, indent, "meshBoundsChangedFrameCount", a.meshBoundsChangedFrameCount);
        Add(sb, indent, "unsupportedShaderMaterialCount", a.unsupportedShaderMaterialCount);
        Add(sb, indent, "shaderRebindAppliedCount", a.shaderRebindAppliedCount);
        Add(sb, indent, "shaderRebindFailedCount", a.shaderRebindFailedCount);
        Add(sb, indent, "motionReplayStatus", a.motionReplayStatus);
        Add(sb, indent, "runtimeException", a.runtimeException);
        Add(sb, indent, "atlasAssetNames", a.atlasAssetNames);
        Add(sb, indent, "skeletonLikeAssets", a.skeletonLikeAssets);
        Add(sb, indent, "trackEntries", a.trackEntries);
        sb.AppendLine(indent + "  \"frameSnapshots\": [");
        for (int i = 0; i < a.frameSnapshots.Count; i++)
        {
            var f = a.frameSnapshots[i];
            sb.Append(indent + "    {\"frame\":" + f.frame + ",\"meshVertexCount\":" + f.meshVertexCount + ",\"meshTriangleIndexCount\":" + f.meshTriangleIndexCount + ",\"meshHash\":\"" + Json(f.meshHash) + "\",\"meshBoundsJoined\":\"" + Json(f.meshBoundsJoined) + "\"}");
            if (i + 1 < a.frameSnapshots.Count) sb.Append(",");
            sb.AppendLine();
        }
        sb.AppendLine(indent + "  ]");
        sb.Append(indent + "}");
        return sb.ToString();
    }

    private static void Add(StringBuilder sb, string indent, string name, string value) { sb.AppendLine(indent + "  \"" + name + "\": \"" + Json(value) + "\","); }
    private static void Add(StringBuilder sb, string indent, string name, bool value) { sb.AppendLine(indent + "  \"" + name + "\": " + Bool(value) + ","); }
    private static void Add(StringBuilder sb, string indent, string name, int value) { sb.AppendLine(indent + "  \"" + name + "\": " + value + ","); }
    private static void Add(StringBuilder sb, string indent, string name, List<string> values) { sb.AppendLine(indent + "  \"" + name + "\": " + JsonArray(values) + ","); }

    private static string RuntimeInfoJson(RuntimeInfo info)
    {
        return "{\"SkeletonAnimation\":" + Bool(info.skeletonAnimation) + ",\"SkeletonRenderer\":" + Bool(info.skeletonRenderer) + ",\"SkeletonDataAsset\":" + Bool(info.skeletonDataAsset) + ",\"MeshGenerator\":" + Bool(info.meshGenerator) + ",\"AnimationState\":" + Bool(info.animationState) + ",\"realRuntimePresent\":" + Bool(info.skeletonAnimation && info.meshGenerator && info.animationState) + "}";
    }

    private static string ShaderBundleJson(ShaderBundleInfo info)
    {
        return "{\"bundle\":\"" + Json(info.bundle) + "\",\"absolutePath\":\"" + Json(info.absolutePath) + "\",\"fileExists\":" + Bool(info.fileExists) + ",\"fileSize\":" + info.fileSize + ",\"loaded\":" + Bool(info.loaded) + ",\"status\":\"" + Json(info.status) + "\",\"shaderAssets\":" + JsonArray(info.shaderAssets) + ",\"materialAssets\":" + JsonArray(info.materialAssets) + ",\"assetTypes\":" + JsonArray(info.assetTypes) + ",\"loadExceptions\":" + JsonArray(info.loadExceptions) + "}";
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

    private static bool ReadBoolField(object obj, string name)
    {
        var value = ReadField(obj, name);
        return value is bool && (bool)value;
    }

    private static IEnumerable<object> EnumerateCollection(object collection)
    {
        if (collection == null) yield break;
        var enumerable = collection as IEnumerable;
        if (enumerable != null && !(collection is string))
        {
            foreach (var item in enumerable) yield return item;
            yield break;
        }
        var items = ReadField(collection, "Items") as Array;
        int count = CountCollection(collection);
        if (items != null)
            for (int i = 0; i < items.Length && (count <= 0 || i < count); i++) yield return items.GetValue(i);
    }

    private static int CountCollection(object collection)
    {
        if (collection == null) return 0;
        var count = ReadPropertyOrField(collection, "Count");
        if (count is int) return (int)count;
        var c = collection as ICollection;
        if (c != null) return c.Count;
        var items = ReadField(collection, "Items") as Array;
        return items != null ? items.Length : 0;
    }

    private static void InvokeIfExists(object obj, string name, Type[] types, object[] args)
    {
        var method = obj.GetType().GetMethod(name, BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance, null, types, null);
        if (method != null) method.Invoke(obj, args);
    }

    private static string HierarchyPath(Transform transform)
    {
        var parts = new List<string>();
        while (transform != null)
        {
            parts.Add(transform.name);
            transform = transform.parent;
        }
        parts.Reverse();
        return string.Join("/", parts.ToArray());
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
        return material.name + "|shader=" + (shader != null ? ShaderInfo(shader) : "") + "|mainTex=" + (tex != null ? tex.name + "(" + tex.width + "x" + tex.height + ")" : "") + "|renderQueue=" + material.renderQueue;
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

    private static int Count<T>(List<T> rows, Predicate<T> predicate)
    {
        int count = 0;
        foreach (var row in rows) if (predicate(row)) count++;
        return count;
    }

    private static int Sum(List<ActorResult> rows, Func<ActorResult, int> selector)
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

    private static string Bool(bool value) { return value ? "true" : "false"; }
    private static string Json(string value) { return (value ?? "").Replace("\\", "\\\\").Replace("\"", "\\\"").Replace("\r", "\\r").Replace("\n", "\\n"); }
    private static string JsonArray(List<string> values)
    {
        var parts = new List<string>();
        foreach (var value in values) parts.Add("\"" + Json(value) + "\"");
        return "[" + string.Join(",", parts.ToArray()) + "]";
    }
    private static string Csv(string value) { return "\"" + (value ?? "").Replace("\"", "\"\"") + "\""; }

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
        public bool meshGenerator;
        public bool animationState;
    }

    private sealed class ShaderBundleInfo
    {
        public string bundle = "";
        public string absolutePath = "";
        public bool fileExists;
        public long fileSize;
        public bool loaded;
        public string status = "";
        public List<string> shaderAssets = new List<string>();
        public List<string> materialAssets = new List<string>();
        public List<string> assetTypes = new List<string>();
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

    private sealed class ActorResult
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
        public int missingScriptCount;
        public int skeletonAnimationComponentCount;
        public string skeletonAnimationAssembly = "";
        public string serializedAnimationName = "";
        public bool initializeCalled;
        public bool afterInitializeValid;
        public string skeletonDataAssetName = "";
        public string skeletonDataAssetType = "";
        public bool skeletonDataNull;
        public string skeletonDataException = "";
        public int boneCount;
        public int slotCount;
        public int animationCount;
        public bool expectedAnimationInRuntime;
        public bool animationStateNonNull;
        public bool animationStateSetSucceeded;
        public string animationStateUsedName = "";
        public bool animationFallbackUsed;
        public bool updateFloatCalled;
        public bool lateUpdateCalled;
        public bool meshGeneratorNonNull;
        public int meshHashChangedFrameCount;
        public int meshBoundsChangedFrameCount;
        public bool realMeshUpdated;
        public int unsupportedShaderMaterialCount;
        public int shaderRebindAppliedCount;
        public int shaderRebindFailedCount;
        public string motionReplayStatus = "";
        public string failReason = "";
        public string runtimeException = "";
        public string animationStateException = "";
        public string trackEntryException = "";
        public List<string> animationNames = new List<string>();
        public List<string> atlasAssetNames = new List<string>();
        public List<string> skeletonLikeAssets = new List<string>();
        public List<string> prefabAssetNames = new List<string>();
        public List<string> loadExceptions = new List<string>();
        public List<string> trackEntries = new List<string>();
        public List<MeshFrameSnapshot> frameSnapshots = new List<MeshFrameSnapshot>();
    }

    private sealed class MaterialRow
    {
        public string side = "";
        public string heroDid = "";
        public string modelId = "";
        public string sourceKind = "";
        public string sourcePath = "";
        public string materialName = "";
        public string originalShaderName = "";
        public bool originalShaderSupported;
        public int originalShaderPassCount;
        public bool projectShaderFound;
        public bool projectShaderSupported;
        public int projectShaderPassCount;
        public bool rebindAttempted;
        public bool rebindApplied;
        public string rebindReason = "";
        public string afterShaderName = "";
        public bool afterShaderSupported;
        public int afterShaderPassCount;
        public string mainTextureName = "";
        public string mainTextureSize = "";
        public int renderQueueBefore;
        public int renderQueueAfter;
    }

    private sealed class ComponentRow
    {
        public string side = "";
        public string heroDid = "";
        public string modelId = "";
        public string hierarchyPath = "";
        public bool activeInHierarchy;
        public string rendererType = "";
        public bool rendererEnabled;
        public string materialNames = "";
        public string shaderNames = "";
        public string shaderSupported = "";
        public string textureNames = "";
        public int meshVertexCount;
        public int meshTriangleIndexCount;
    }
}
