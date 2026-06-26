using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.SceneManagement;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Reflection;
using System.Text;

public static class Battle57RehydrateSourceBackedAssetBundleActorsEditor
{
    private const string Prefix = "BATTLE_57_REHYDRATE_SOURCE_BACKED_ASSETBUNDLE_ACTORS_IN_CANDIDATE_BUILDER_AND_CAPTURE_VALIDATE_NO_FAKE_MESH";
    private const string BaseScenePath = "Assets/Scenes/Battle51LuaBridgeRaycasterRegistrationCandidate.unity";
    private const string FallbackScenePath = "Assets/Scenes/Battle39RuntimeActorsMap11003HudContextCandidate.unity";
    private const string OutputScenePath = "Assets/Scenes/Battle57RuntimeRehydratedAssetBundleActorsCandidate.unity";
    private const string BundleRoot = "C:/Users/godho/Downloads/girlswar/girlswar_merged_extracted/extracted/unity/clean_unityfs_slices";
    private const string CapturePath = "Assets/RestoreCaptures/battle_actor/Battle57RuntimeRehydratedAssetBundleActorsCandidate_1920x1080.png";
    private const string BaselineCapturePath = "Assets/RestoreCaptures/battle_actor/Battle57RuntimeRehydratedAssetBundleActorsCandidate_without_actors_1920x1080.png";
    private const string DiffCapturePath = "Assets/RestoreCaptures/battle_actor/Battle57RuntimeRehydratedAssetBundleActorsCandidate_actor_diff_1920x1080.png";
    private const string SummaryPath = "Assets/RestoreData/battle/BATTLE_57_REHYDRATE_SOURCE_BACKED_ASSETBUNDLE_ACTORS_IN_CANDIDATE_BUILDER_AND_CAPTURE_VALIDATE_NO_FAKE_MESH_UNITY_SUMMARY.json";
    private const string MappingCsvPath = "Assets/RestoreData/battle/BATTLE_57_REHYDRATE_SOURCE_BACKED_ASSETBUNDLE_ACTORS_IN_CANDIDATE_BUILDER_AND_CAPTURE_VALIDATE_NO_FAKE_MESH_REHYDRATION_MAPPING.csv";
    private const string RendererCsvPath = "Assets/RestoreData/battle/BATTLE_57_REHYDRATE_SOURCE_BACKED_ASSETBUNDLE_ACTORS_IN_CANDIDATE_BUILDER_AND_CAPTURE_VALIDATE_NO_FAKE_MESH_RENDERERS.csv";
    private const string VisibilityCsvPath = "Assets/RestoreData/battle/BATTLE_57_REHYDRATE_SOURCE_BACKED_ASSETBUNDLE_ACTORS_IN_CANDIDATE_BUILDER_AND_CAPTURE_VALIDATE_NO_FAKE_MESH_VISIBILITY.csv";
    private const int CaptureWidth = 1920;
    private const int CaptureHeight = 1080;

    private static readonly ActorTarget[] Targets = new[]
    {
        new ActorTarget("our", 0, 2, "1002", "1002", "ult", new[] { "ult", "stand", "skill1" }, "download/roleprefabsandres/battleprefabandres/1002.assetbundle", "assets/download/roleprefabsandres/battleprefabandres/1002/hero_1002.prefab", new Vector3(-1.65f, -2.35f, -0.2f), 0.70f, 36),
        new ActorTarget("our", 0, 3, "1034", "1034", "skill1", new[] { "skill1", "stand", "ult" }, "download/roleprefabsandres/battleprefabandres/1034.assetbundle", "assets/download/roleprefabsandres/battleprefabandres/1034/hero_1034.prefab", new Vector3(0f, -2.35f, -0.2f), 0.70f, 36),
        new ActorTarget("enemy", 1, 1, "1100111", "3001", "attack", new[] { "attack", "attackR", "stand", "run1" }, "download/roleprefabsandres/battleprefabandres/3001.assetbundle", "assets/download/roleprefabsandres/battleprefabandres/3001/hero_3001.prefab", new Vector3(1.05f, 2.35f, -0.2f), 0.62f, 32),
    };

    [MenuItem("GirlsWar/Battle/BATTLE57 Rehydrate Source Backed AssetBundle Actors")]
    public static void Build()
    {
        Directory.CreateDirectory(ProjectPath("Assets/RestoreData/battle"));
        Directory.CreateDirectory(ProjectPath("Assets/RestoreCaptures/battle_actor"));
        Directory.CreateDirectory(ProjectPath("Assets/Scenes"));

        var summary = new Summary();
        summary.prefix = Prefix;
        summary.baseScene = BaseScenePath;
        summary.outputScene = OutputScenePath;
        summary.isFinalRestoredBattleScreen = false;
        summary.runtimeRehydrateUsed = true;
        summary.sourceBackedPersistentImportUsed = false;
        summary.fakeMeshUsed = false;
        summary.fakeHandlerUsed = false;
        summary.patchDecision = "candidate_runtime_rehydrate_patch_no_fake_mesh";
        summary.nextBlocker = "XLUA_GAMEENTRY_MODULESINIT_HANDLER_BINDING_AND_FULL_PAYLOAD_GAPS_REMAIN";

        AssetBundle.UnloadAllAssetBundles(false);
        var opened = new List<AssetBundle>();
        Scene scene;
        if (File.Exists(ProjectPath(BaseScenePath)))
        {
            scene = EditorSceneManager.OpenScene(BaseScenePath, OpenSceneMode.Single);
            summary.baseSceneOpened = true;
        }
        else if (File.Exists(ProjectPath(FallbackScenePath)))
        {
            scene = EditorSceneManager.OpenScene(FallbackScenePath, OpenSceneMode.Single);
            summary.baseSceneOpened = true;
            summary.baseScene = FallbackScenePath;
        }
        else
        {
            scene = EditorSceneManager.NewScene(NewSceneSetup.EmptyScene, NewSceneMode.Single);
            summary.baseSceneOpened = false;
            summary.failReason = "base_scene_not_found";
        }

        var mappingRows = new List<Dictionary<string, string>>();
        var rendererRows = new List<Dictionary<string, string>>();
        var visibilityRows = new List<Dictionary<string, string>>();
        summary.disabledHollowShellCount = DisableExistingRuntimeActorShells(mappingRows);

        var camera = FindCaptureCamera();
        if (camera == null)
        {
            camera = CreateFallbackCamera();
            summary.captureCameraCreated = true;
        }
        ConfigureCameraForCapture(camera);
        summary.captureCameraName = camera.name;
        summary.captureCameraPixelRect = RectString(camera.pixelRect);
        summary.captureCameraOrthographic = camera.orthographic;
        summary.captureCameraOrthographicSize = camera.orthographicSize;
        summary.captureCameraCullingMask = camera.cullingMask;

        var root = new GameObject("BATTLE57_SourceBackedRuntimeRehydratedActors");
        root.transform.position = Vector3.zero;

        var shaderBundle = LoadShaderBundle(opened);
        summary.shaderBundleLoaded = shaderBundle.loaded;
        summary.shaderBundleShaderCount = shaderBundle.shaderCount;

        var actors = new List<ActorRuntime>();
        foreach (var target in Targets)
        {
            var actor = LoadActor(target, root.transform, opened);
            actors.Add(actor);
            mappingRows.Add(MappingRow(actor));
        }

        for (int frame = 0; frame < 12; frame++)
            foreach (var actor in actors) StepActor(actor, 1f / 15f);

        Canvas.ForceUpdateCanvases();
        foreach (var actor in actors)
        {
            AppendRendererRows(actor, rendererRows);
            visibilityRows.Add(VisibilityRow(actor, camera));
        }

        SetActorsActive(actors, false);
        var baseline = Capture(camera, ProjectPath(BaselineCapturePath));
        SetActorsActive(actors, true);
        Canvas.ForceUpdateCanvases();
        var withActors = Capture(camera, ProjectPath(CapturePath));
        var diff = WriteDiff(ProjectPath(DiffCapturePath), baseline, withActors);
        ApplyDiffStats(actors, camera, baseline, withActors, visibilityRows);

        summary.actorRows = actors.Count;
        summary.bundleLoadedActorRows = Count(actors, a => a.bundleLoaded);
        summary.prefabInstantiatedRows = Count(actors, a => a.prefabInstantiated);
        summary.meshReadyRows = Count(actors, a => a.meshVertexCount > 0);
        summary.materialReadyRows = Count(actors, a => a.materialSlotCount > 0 && a.materialNullCount == 0 && a.unsupportedShaderMaterialCount == 0);
        summary.skeletonAnimationRows = Count(actors, a => a.skeletonAnimationComponentCount > 0);
        summary.animationStateSetRows = Count(actors, a => a.animationStateSetSucceeded);
        summary.boundsNonZeroRows = Count(actors, a => a.boundsSize != "0/0/0" && !string.IsNullOrEmpty(a.boundsSize));
        summary.pixelDiffRows = CountVisibilityDiffRows(visibilityRows);
        summary.totalDiffPixels = diff.changedPixels;
        summary.capture = CapturePath;
        summary.baselineCapture = BaselineCapturePath;
        summary.diffCapture = DiffCapturePath;
        summary.captureExists = File.Exists(ProjectPath(CapturePath));
        summary.sceneSaved = EditorSceneManager.SaveScene(scene, OutputScenePath);

        WriteCsv(ProjectPath(MappingCsvPath), mappingRows, MappingHeaders());
        WriteCsv(ProjectPath(RendererCsvPath), rendererRows, RendererHeaders());
        WriteCsv(ProjectPath(VisibilityCsvPath), visibilityRows, VisibilityHeaders());
        WriteSummary(ProjectPath(SummaryPath), summary);

        foreach (var bundle in opened)
            if (bundle != null) bundle.Unload(false);
        AssetDatabase.Refresh();
        UnityEngine.Object.DestroyImmediate(baseline);
        UnityEngine.Object.DestroyImmediate(withActors);
        Debug.Log("BATTLE57 runtime rehydrate complete. actors=" + actors.Count + " meshReady=" + summary.meshReadyRows + " diffPixels=" + summary.totalDiffPixels);
    }

    private static ShaderBundleInfo LoadShaderBundle(List<AssetBundle> opened)
    {
        var info = new ShaderBundleInfo();
        info.bundle = "download/commonprefabsandres/spinematandshaders.assetbundle";
        info.absolutePath = Path.Combine(BundleRoot, info.bundle.Replace("/", "\\"));
        info.fileExists = File.Exists(info.absolutePath);
        if (!info.fileExists) { info.status = "file_not_found"; return info; }
        var bundle = AssetBundle.LoadFromFile(info.absolutePath);
        if (bundle == null) { info.status = "load_from_file_null"; return info; }
        opened.Add(bundle);
        info.loaded = true;
        info.status = "loaded";
        foreach (var assetName in bundle.GetAllAssetNames())
            if (bundle.LoadAsset<Shader>(assetName) != null) info.shaderCount++;
        return info;
    }

    private static ActorRuntime LoadActor(ActorTarget target, Transform root, List<AssetBundle> opened)
    {
        var runtime = new ActorRuntime();
        runtime.target = target;
        runtime.absoluteBundlePath = Path.Combine(BundleRoot, target.bundle.Replace("/", "\\"));
        runtime.bundleFileExists = File.Exists(runtime.absoluteBundlePath);
        if (!runtime.bundleFileExists) { runtime.failReason = "bundle_file_not_found"; return runtime; }
        var bundle = AssetBundle.LoadFromFile(runtime.absoluteBundlePath);
        if (bundle == null) { runtime.failReason = "AssetBundle.LoadFromFile_returned_null"; return runtime; }
        opened.Add(bundle);
        runtime.bundleLoaded = true;

        var prefab = bundle.LoadAsset<GameObject>(target.prefabAsset);
        if (prefab == null)
        {
            foreach (var name in bundle.GetAllAssetNames())
            {
                var lower = name.ToLowerInvariant();
                if (lower.EndsWith(".prefab") && lower.Contains("hero_"))
                {
                    runtime.usedPrefabAsset = name;
                    prefab = bundle.LoadAsset<GameObject>(name);
                    break;
                }
            }
        }
        else runtime.usedPrefabAsset = target.prefabAsset;
        if (prefab == null) { runtime.failReason = "prefab_not_found"; return runtime; }

        runtime.instance = (GameObject)GameObject.Instantiate(prefab, target.position, Quaternion.identity, root);
        runtime.instance.name = "BATTLE57_SourceBackedActor_" + target.side + "_w" + target.wave + "_s" + target.slot + "_" + target.heroDid + "_model_" + target.modelId;
        runtime.instance.transform.localScale = Vector3.one * target.scale;
        runtime.prefabInstantiated = true;
        runtime.instanceHierarchyPath = HierarchyPath(runtime.instance.transform);

        ApplyRenderOrder(runtime);
        RebindMaterials(runtime);
        InitializeAndSetAnimation(runtime);
        RefreshStats(runtime);
        return runtime;
    }

    private static int DisableExistingRuntimeActorShells(List<Dictionary<string, string>> rows)
    {
        int count = 0;
        foreach (var t in UnityEngine.Object.FindObjectsOfType<Transform>(true))
        {
            if (t == null || t.gameObject == null) continue;
            if (!(t.name.StartsWith("BATTLE39_RuntimeActor_", StringComparison.Ordinal) || t.name.StartsWith("Battle27RuntimeActor_", StringComparison.Ordinal))) continue;
            if (!t.gameObject.activeSelf) continue;
            var row = NewRow(MappingHeaders());
            row["mappingKind"] = "disabled_existing_hollow_shell";
            row["oldSceneActorPath"] = HierarchyPath(t);
            row["oldHadMesh"] = Bool(HasMesh(t.gameObject));
            row["oldHadMaterial"] = Bool(HasMaterial(t.gameObject));
            row["replacementPolicy"] = "deactivated_before_source_assetbundle_rehydrate";
            rows.Add(row);
            t.gameObject.SetActive(false);
            count++;
        }
        return count;
    }

    private static void ApplyRenderOrder(ActorRuntime runtime)
    {
        if (runtime.instance == null) return;
        foreach (var renderer in runtime.instance.GetComponentsInChildren<Renderer>(true))
        {
            renderer.sortingOrder = runtime.target.sortingOrder;
            runtime.renderOrderAppliedCount++;
        }
    }

    private static void RebindMaterials(ActorRuntime runtime)
    {
        if (runtime.instance == null) return;
        foreach (var renderer in runtime.instance.GetComponentsInChildren<Renderer>(true))
        {
            foreach (var material in renderer.sharedMaterials)
            {
                if (material == null || material.shader == null) continue;
                runtime.materialRows.Add("before|" + MaterialInfo(material));
                if (material.shader.isSupported && material.shader.passCount > 0) continue;
                var shader = Shader.Find(material.shader.name);
                if (shader != null && shader.isSupported && shader.passCount > 0)
                {
                    material.shader = shader;
                    runtime.shaderRebindAppliedCount++;
                }
                else runtime.shaderRebindFailedCount++;
                runtime.materialRows.Add("after|" + MaterialInfo(material));
            }
        }
    }

    private static void InitializeAndSetAnimation(ActorRuntime runtime)
    {
        if (runtime.instance == null) return;
        foreach (var component in runtime.instance.GetComponentsInChildren<Component>(true))
        {
            if (component == null) { runtime.missingScriptCount++; continue; }
            if ((component.GetType().FullName ?? component.GetType().Name) != "Spine.Unity.SkeletonAnimation") continue;
            runtime.skeletonAnimation = component;
            runtime.skeletonAnimationComponentCount++;
            runtime.serializedAnimationName = ReadStringField(component, "_animationName");
            try
            {
                InvokeIfExists(component, "Initialize", new[] { typeof(bool), typeof(bool) }, new object[] { true, false });
                runtime.afterInitializeValid = ReadBoolField(component, "valid");
                TraceSkeleton(component, runtime);
                var state = ReadProperty(component, "AnimationState");
                runtime.animationStateNonNull = state != null;
                var set = state != null ? state.GetType().GetMethod("SetAnimation", new[] { typeof(int), typeof(string), typeof(bool) }) : null;
                if (set != null)
                {
                    foreach (var candidate in runtime.target.animationCandidates)
                    {
                        if (string.IsNullOrEmpty(candidate)) continue;
                        if (runtime.animationNames.Count > 0 && !runtime.animationNames.Contains(candidate)) continue;
                        set.Invoke(state, new object[] { 0, candidate, true });
                        runtime.animationStateSetSucceeded = true;
                        runtime.animationStateUsedName = candidate;
                        break;
                    }
                }
            }
            catch (Exception ex) { runtime.runtimeException = Short(Unwrap(ex)); }
        }
    }

    private static void TraceSkeleton(Component component, ActorRuntime runtime)
    {
        var sda = ReadField(component, "skeletonDataAsset");
        runtime.skeletonDataAssetName = ObjectName(sda);
        runtime.skeletonDataNull = sda == null;
        if (sda == null) return;
        var method = sda.GetType().GetMethod("GetSkeletonData", new[] { typeof(bool) });
        var skeletonData = method != null ? method.Invoke(sda, new object[] { false }) : null;
        if (skeletonData == null) return;
        runtime.boneCount = CountCollection(ReadPropertyOrField(skeletonData, "Bones"));
        runtime.slotCount = CountCollection(ReadPropertyOrField(skeletonData, "Slots"));
        var animations = ReadPropertyOrField(skeletonData, "Animations");
        runtime.animationCount = CountCollection(animations);
        foreach (var animation in EnumerateCollection(animations))
        {
            var name = ReadStringPropertyOrField(animation, "Name");
            if (!string.IsNullOrEmpty(name)) runtime.animationNames.Add(name);
        }
    }

    private static void StepActor(ActorRuntime runtime, float dt)
    {
        if (runtime.skeletonAnimation == null) return;
        InvokeIfExists(runtime.skeletonAnimation, "Update", new[] { typeof(float) }, new object[] { dt });
        InvokeIfExists(runtime.skeletonAnimation, "LateUpdate", Type.EmptyTypes, new object[0]);
        RefreshStats(runtime);
    }

    private static void RefreshStats(ActorRuntime runtime)
    {
        if (runtime.instance == null) return;
        runtime.meshFilterCount = 0;
        runtime.meshFilterWithMeshCount = 0;
        runtime.meshVertexCount = 0;
        runtime.meshTriangleIndexCount = 0;
        foreach (var mf in runtime.instance.GetComponentsInChildren<MeshFilter>(true))
        {
            runtime.meshFilterCount++;
            if (mf.sharedMesh == null) continue;
            runtime.meshFilterWithMeshCount++;
            runtime.meshVertexCount += mf.sharedMesh.vertexCount;
            runtime.meshTriangleIndexCount += mf.sharedMesh.triangles != null ? mf.sharedMesh.triangles.Length : 0;
        }
        runtime.rendererCount = 0;
        runtime.enabledRendererCount = 0;
        runtime.materialSlotCount = 0;
        runtime.materialNullCount = 0;
        runtime.unsupportedShaderMaterialCount = 0;
        foreach (var renderer in runtime.instance.GetComponentsInChildren<Renderer>(true))
        {
            runtime.rendererCount++;
            if (renderer.enabled) runtime.enabledRendererCount++;
            foreach (var material in renderer.sharedMaterials)
            {
                runtime.materialSlotCount++;
                if (material == null) { runtime.materialNullCount++; runtime.unsupportedShaderMaterialCount++; continue; }
                if (material.shader == null || !material.shader.isSupported || material.shader.passCount == 0) runtime.unsupportedShaderMaterialCount++;
            }
        }
        runtime.bounds = CombinedBounds(runtime.instance, out var b);
        runtime.lastBounds = b;
        runtime.boundsSize = Vec(b.size);
        runtime.meshHash = MeshHash(runtime.instance);
    }

    private static Dictionary<string, string> MappingRow(ActorRuntime actor)
    {
        var row = NewRow(MappingHeaders());
        row["mappingKind"] = "source_assetbundle_runtime_rehydrate";
        FillTarget(row, actor.target);
        row["bundleFileExists"] = Bool(actor.bundleFileExists);
        row["bundleLoaded"] = Bool(actor.bundleLoaded);
        row["prefabAsset"] = actor.usedPrefabAsset;
        row["prefabInstantiated"] = Bool(actor.prefabInstantiated);
        row["newActorPath"] = actor.instanceHierarchyPath;
        row["position"] = Vec(actor.target.position);
        row["scale"] = actor.target.scale.ToString(CultureInfo.InvariantCulture);
        row["expectedAnimation"] = actor.target.expectedAnimation;
        row["animationStateSet"] = Bool(actor.animationStateSetSucceeded);
        row["animationUsed"] = actor.animationStateUsedName;
        row["skeletonDataAsset"] = actor.skeletonDataAssetName;
        row["replacementPolicy"] = "runtime_rehydrate_from_original_local_assetbundle_no_fake_mesh";
        row["failReason"] = actor.failReason;
        return row;
    }

    private static void AppendRendererRows(ActorRuntime actor, List<Dictionary<string, string>> rows)
    {
        if (actor.instance == null) return;
        foreach (var renderer in actor.instance.GetComponentsInChildren<Renderer>(true))
        {
            var row = NewRow(RendererHeaders());
            FillTarget(row, actor.target);
            row["actorPath"] = actor.instanceHierarchyPath;
            row["rendererPath"] = HierarchyPath(renderer.transform);
            row["rendererType"] = renderer.GetType().FullName;
            row["rendererEnabled"] = Bool(renderer.enabled);
            row["sortingLayer"] = renderer.sortingLayerName;
            row["sortingOrder"] = renderer.sortingOrder.ToString(CultureInfo.InvariantCulture);
            row["boundsCenter"] = Vec(renderer.bounds.center);
            row["boundsSize"] = Vec(renderer.bounds.size);
            row["materialSlotCount"] = renderer.sharedMaterials.Length.ToString(CultureInfo.InvariantCulture);
            var names = new List<string>();
            var shaders = new List<string>();
            var textures = new List<string>();
            int nulls = 0, unsupported = 0;
            foreach (var mat in renderer.sharedMaterials)
            {
                if (mat == null) { nulls++; unsupported++; continue; }
                names.Add(mat.name);
                if (mat.shader == null) unsupported++;
                else
                {
                    shaders.Add(mat.shader.name + "|supported=" + Bool(mat.shader.isSupported) + "|passes=" + mat.shader.passCount);
                    if (!mat.shader.isSupported || mat.shader.passCount == 0) unsupported++;
                }
                if (mat.mainTexture != null) textures.Add(mat.mainTexture.name);
            }
            row["materialNames"] = string.Join("|", names.ToArray());
            row["shaderNames"] = string.Join("|", shaders.ToArray());
            row["textureNames"] = string.Join("|", textures.ToArray());
            row["materialNullCount"] = nulls.ToString(CultureInfo.InvariantCulture);
            row["unsupportedShaderMaterialCount"] = unsupported.ToString(CultureInfo.InvariantCulture);
            var mf = renderer.GetComponent<MeshFilter>();
            row["meshNonNull"] = Bool(mf != null && mf.sharedMesh != null);
            row["meshVertexCount"] = mf != null && mf.sharedMesh != null ? mf.sharedMesh.vertexCount.ToString(CultureInfo.InvariantCulture) : "0";
            row["meshTriangleIndexCount"] = mf != null && mf.sharedMesh != null && mf.sharedMesh.triangles != null ? mf.sharedMesh.triangles.Length.ToString(CultureInfo.InvariantCulture) : "0";
            row["shaderRebindAppliedCount"] = actor.shaderRebindAppliedCount.ToString(CultureInfo.InvariantCulture);
            rows.Add(row);
        }
    }

    private static Dictionary<string, string> VisibilityRow(ActorRuntime actor, Camera camera)
    {
        var row = NewRow(VisibilityHeaders());
        FillTarget(row, actor.target);
        row["actorPath"] = actor.instanceHierarchyPath;
        row["activeInHierarchy"] = Bool(actor.instance != null && actor.instance.activeInHierarchy);
        row["meshReady"] = Bool(actor.meshVertexCount > 0);
        row["materialReady"] = Bool(actor.materialSlotCount > 0 && actor.materialNullCount == 0 && actor.unsupportedShaderMaterialCount == 0);
        row["rendererCount"] = actor.rendererCount.ToString(CultureInfo.InvariantCulture);
        row["enabledRendererCount"] = actor.enabledRendererCount.ToString(CultureInfo.InvariantCulture);
        row["meshVertexCount"] = actor.meshVertexCount.ToString(CultureInfo.InvariantCulture);
        row["bounds"] = actor.bounds;
        row["boundsSize"] = actor.boundsSize;
        row["screenRect"] = actor.boundsSize == "0/0/0" ? "" : ScreenRect(camera, actor.lastBounds);
        row["screenCenterNorm"] = actor.boundsSize == "0/0/0" ? "" : ScreenCenterNorm(camera, actor.lastBounds);
        row["screenAreaRatio"] = actor.boundsSize == "0/0/0" ? "0" : ScreenAreaRatio(camera, actor.lastBounds).ToString("0.########", CultureInfo.InvariantCulture);
        row["cameraName"] = camera != null ? camera.name : "";
        row["cameraPixelRect"] = camera != null ? RectString(camera.pixelRect) : "";
        row["cameraIncludesLayer"] = Bool(camera != null && actor.instance != null && ((camera.cullingMask & (1 << actor.instance.layer)) != 0));
        row["frustumCandidate"] = Bool(camera != null && actor.boundsSize != "0/0/0" && GeometryUtility.TestPlanesAABB(GeometryUtility.CalculateFrustumPlanes(camera), actor.lastBounds));
        row["meshHash"] = actor.meshHash;
        return row;
    }

    private static void ApplyDiffStats(List<ActorRuntime> actors, Camera camera, Texture2D baseline, Texture2D withActors, List<Dictionary<string, string>> rows)
    {
        foreach (var row in rows)
        {
            var actor = FindActor(actors, row["heroDid"], row["modelId"]);
            if (actor == null || camera == null || baseline == null || withActors == null || actor.boundsSize == "0/0/0")
            {
                row["actorPixelDiffCount"] = "0";
                row["actorPixelDiffRatioInRect"] = "0";
                row["capturePixelSignal"] = "False";
                continue;
            }
            var rect = PixelRect(camera, actor.lastBounds, baseline.width, baseline.height);
            int checkedPixels = 0;
            int changed = 0;
            for (int y = rect.yMin; y < rect.yMax; y += Math.Max(1, rect.height / 96))
            {
                for (int x = rect.xMin; x < rect.xMax; x += Math.Max(1, rect.width / 96))
                {
                    checkedPixels++;
                    var a = baseline.GetPixel(x, y);
                    var b = withActors.GetPixel(x, y);
                    if (ColorDelta(a, b) > 0.035f) changed++;
                }
            }
            row["actorPixelRect"] = rect.xMin + "/" + rect.yMin + "/" + rect.xMax + "/" + rect.yMax;
            row["actorPixelSampleCount"] = checkedPixels.ToString(CultureInfo.InvariantCulture);
            row["actorPixelDiffCount"] = changed.ToString(CultureInfo.InvariantCulture);
            row["actorPixelDiffRatioInRect"] = (checkedPixels == 0 ? 0f : (float)changed / checkedPixels).ToString("0.########", CultureInfo.InvariantCulture);
            row["capturePixelSignal"] = Bool(changed > 0);
        }
    }

    private static Texture2D Capture(Camera camera, string fullPath)
    {
        Directory.CreateDirectory(Path.GetDirectoryName(fullPath));
        var rt = new RenderTexture(CaptureWidth, CaptureHeight, 24, RenderTextureFormat.ARGB32);
        var prevTarget = camera.targetTexture;
        var prevActive = RenderTexture.active;
        camera.targetTexture = rt;
        RenderTexture.active = rt;
        Canvas.ForceUpdateCanvases();
        camera.Render();
        var tex = new Texture2D(CaptureWidth, CaptureHeight, TextureFormat.RGB24, false);
        tex.ReadPixels(new Rect(0, 0, CaptureWidth, CaptureHeight), 0, 0);
        tex.Apply();
        File.WriteAllBytes(fullPath, tex.EncodeToPNG());
        camera.targetTexture = prevTarget;
        RenderTexture.active = prevActive;
        UnityEngine.Object.DestroyImmediate(rt);
        return tex;
    }

    private static DiffStats WriteDiff(string fullPath, Texture2D a, Texture2D b)
    {
        var stats = new DiffStats();
        if (a == null || b == null) return stats;
        var diff = new Texture2D(a.width, a.height, TextureFormat.RGB24, false);
        for (int y = 0; y < a.height; y++)
        {
            for (int x = 0; x < a.width; x++)
            {
                var d = ColorDelta(a.GetPixel(x, y), b.GetPixel(x, y));
                if (d > 0.035f) stats.changedPixels++;
                diff.SetPixel(x, y, d > 0.035f ? Color.white : Color.black);
            }
        }
        diff.Apply();
        Directory.CreateDirectory(Path.GetDirectoryName(fullPath));
        File.WriteAllBytes(fullPath, diff.EncodeToPNG());
        UnityEngine.Object.DestroyImmediate(diff);
        return stats;
    }

    private static Camera FindCaptureCamera()
    {
        var named = GameObject.Find("BattleHudSpriteAtlasTextureRuntimeBindingClip05Camera");
        if (named != null)
        {
            var camera = named.GetComponent<Camera>();
            if (camera != null) return camera;
        }
        if (Camera.main != null) return Camera.main;
        var cameras = UnityEngine.Object.FindObjectsOfType<Camera>(true);
        return cameras != null && cameras.Length > 0 ? cameras[0] : null;
    }

    private static Camera CreateFallbackCamera()
    {
        var cameraObject = new GameObject("BATTLE57_FallbackCaptureCamera");
        var camera = cameraObject.AddComponent<Camera>();
        camera.clearFlags = CameraClearFlags.SolidColor;
        camera.backgroundColor = new Color(0.035f, 0.037f, 0.042f, 1f);
        camera.orthographic = true;
        camera.orthographicSize = 5f;
        cameraObject.transform.position = new Vector3(0f, 0f, -10f);
        return camera;
    }

    private static void ConfigureCameraForCapture(Camera camera)
    {
        if (camera == null) return;
        camera.enabled = true;
        camera.cullingMask = ~0;
        camera.nearClipPlane = 0.01f;
        camera.farClipPlane = 1000f;
        if (!camera.orthographic) camera.orthographic = true;
        if (camera.orthographicSize <= 0f) camera.orthographicSize = 5f;
    }

    private static void SetActorsActive(List<ActorRuntime> actors, bool active)
    {
        foreach (var actor in actors)
            if (actor.instance != null) actor.instance.SetActive(active);
    }

    private static ActorRuntime FindActor(List<ActorRuntime> actors, string heroDid, string modelId)
    {
        foreach (var actor in actors)
            if (actor.target.heroDid == heroDid && actor.target.modelId == modelId) return actor;
        return null;
    }

    private static RectInt PixelRect(Camera camera, Bounds bounds, int width, int height)
    {
        var min = new Vector2(99999f, 99999f);
        var max = new Vector2(-99999f, -99999f);
        foreach (var p in BoundsCorners(bounds))
        {
            var sp = camera.WorldToScreenPoint(p);
            float sx = camera.pixelRect.width > 0f ? width / camera.pixelRect.width : 1f;
            float sy = camera.pixelRect.height > 0f ? height / camera.pixelRect.height : 1f;
            float px = (sp.x - camera.pixelRect.x) * sx;
            float py = (sp.y - camera.pixelRect.y) * sy;
            min.x = Mathf.Min(min.x, px);
            min.y = Mathf.Min(min.y, py);
            max.x = Mathf.Max(max.x, px);
            max.y = Mathf.Max(max.y, py);
        }
        int x0 = Mathf.Clamp(Mathf.FloorToInt(min.x), 0, width - 1);
        int y0 = Mathf.Clamp(Mathf.FloorToInt(min.y), 0, height - 1);
        int x1 = Mathf.Clamp(Mathf.CeilToInt(max.x), 0, width);
        int y1 = Mathf.Clamp(Mathf.CeilToInt(max.y), 0, height);
        if (x1 <= x0) x1 = Mathf.Min(width, x0 + 1);
        if (y1 <= y0) y1 = Mathf.Min(height, y0 + 1);
        return new RectInt(x0, y0, x1 - x0, y1 - y0);
    }

    private static string CombinedBounds(GameObject instance, out Bounds combined)
    {
        combined = new Bounds(Vector3.zero, Vector3.zero);
        if (instance == null) return "";
        bool has = false;
        foreach (var renderer in instance.GetComponentsInChildren<Renderer>(true))
        {
            if (!renderer.enabled) continue;
            if (!has) { combined = renderer.bounds; has = true; }
            else combined.Encapsulate(renderer.bounds);
        }
        if (!has) return "";
        return Vec(combined.center) + "|" + Vec(combined.size);
    }

    private static string ScreenRect(Camera camera, Bounds bounds)
    {
        if (camera == null) return "";
        var min = new Vector2(99999f, 99999f);
        var max = new Vector2(-99999f, -99999f);
        foreach (var p in BoundsCorners(bounds))
        {
            var sp = camera.WorldToScreenPoint(p);
            min.x = Mathf.Min(min.x, sp.x);
            min.y = Mathf.Min(min.y, sp.y);
            max.x = Mathf.Max(max.x, sp.x);
            max.y = Mathf.Max(max.y, sp.y);
        }
        return min.x.ToString("0.##", CultureInfo.InvariantCulture) + "/" + min.y.ToString("0.##", CultureInfo.InvariantCulture) + "/" + max.x.ToString("0.##", CultureInfo.InvariantCulture) + "/" + max.y.ToString("0.##", CultureInfo.InvariantCulture);
    }

    private static string ScreenCenterNorm(Camera camera, Bounds bounds)
    {
        if (camera == null) return "";
        var sp = camera.WorldToScreenPoint(bounds.center);
        return (sp.x / CaptureWidth).ToString("0.######", CultureInfo.InvariantCulture) + "/" + (1f - sp.y / CaptureHeight).ToString("0.######", CultureInfo.InvariantCulture);
    }

    private static float ScreenAreaRatio(Camera camera, Bounds bounds)
    {
        if (camera == null) return 0f;
        var rect = PixelRect(camera, bounds, CaptureWidth, CaptureHeight);
        return (float)(rect.width * rect.height) / (CaptureWidth * CaptureHeight);
    }

    private static List<Vector3> BoundsCorners(Bounds b)
    {
        var min = b.min;
        var max = b.max;
        return new List<Vector3>
        {
            new Vector3(min.x, min.y, min.z), new Vector3(max.x, min.y, min.z),
            new Vector3(min.x, max.y, min.z), new Vector3(max.x, max.y, min.z),
            new Vector3(min.x, min.y, max.z), new Vector3(max.x, min.y, max.z),
            new Vector3(min.x, max.y, max.z), new Vector3(max.x, max.y, max.z),
        };
    }

    private static string MeshHash(GameObject instance)
    {
        if (instance == null) return "";
        var sb = new StringBuilder();
        foreach (var mf in instance.GetComponentsInChildren<MeshFilter>(true))
        {
            var mesh = mf.sharedMesh;
            if (mesh == null) continue;
            sb.Append(mf.name).Append("|").Append(mesh.vertexCount).Append("|").Append(Vec(mesh.bounds.center)).Append("|").Append(Vec(mesh.bounds.size));
            var verts = mesh.vertices;
            int step = Math.Max(1, verts.Length / 32);
            for (int i = 0; i < verts.Length; i += step) sb.Append("|").Append(Vec(verts[i]));
        }
        return StableHash(sb.ToString());
    }

    private static string StableHash(string text)
    {
        unchecked
        {
            uint hash = 2166136261;
            foreach (char c in text ?? "") { hash ^= c; hash *= 16777619; }
            return hash.ToString("X8", CultureInfo.InvariantCulture);
        }
    }

    private static bool HasMesh(GameObject go)
    {
        if (go == null) return false;
        foreach (var mf in go.GetComponentsInChildren<MeshFilter>(true))
            if (mf.sharedMesh != null && mf.sharedMesh.vertexCount > 0) return true;
        return false;
    }

    private static bool HasMaterial(GameObject go)
    {
        if (go == null) return false;
        foreach (var r in go.GetComponentsInChildren<Renderer>(true))
            foreach (var mat in r.sharedMaterials)
                if (mat != null) return true;
        return false;
    }

    private static float ColorDelta(Color a, Color b)
    {
        return Mathf.Abs(a.r - b.r) + Mathf.Abs(a.g - b.g) + Mathf.Abs(a.b - b.b);
    }

    private static int CountVisibilityDiffRows(List<Dictionary<string, string>> rows)
    {
        int n = 0;
        foreach (var row in rows)
            if (row.ContainsKey("capturePixelSignal") && row["capturePixelSignal"] == "True") n++;
        return n;
    }

    private static int Count(List<ActorRuntime> actors, Predicate<ActorRuntime> predicate)
    {
        int n = 0;
        foreach (var a in actors) if (predicate(a)) n++;
        return n;
    }

    private static string MaterialInfo(Material material)
    {
        if (material == null) return "<null>";
        var texture = material.mainTexture as Texture2D;
        return material.name + "|shader=" + (material.shader != null ? material.shader.name : "") + "|supported=" + (material.shader != null ? Bool(material.shader.isSupported) : "False") + "|passes=" + (material.shader != null ? material.shader.passCount.ToString(CultureInfo.InvariantCulture) : "0") + "|texture=" + (texture != null ? texture.name + ":" + texture.width + "x" + texture.height : "");
    }

    private static void FillTarget(Dictionary<string, string> row, ActorTarget target)
    {
        row["side"] = target.side;
        row["wave"] = target.wave.ToString(CultureInfo.InvariantCulture);
        row["slot"] = target.slot.ToString(CultureInfo.InvariantCulture);
        row["heroDid"] = target.heroDid;
        row["modelId"] = target.modelId;
        row["bundle"] = target.bundle;
    }

    private static void WriteCsv(string path, List<Dictionary<string, string>> rows, string[] headers)
    {
        Directory.CreateDirectory(Path.GetDirectoryName(path));
        var sb = new StringBuilder();
        sb.AppendLine(string.Join(",", headers));
        foreach (var row in rows)
        {
            for (int i = 0; i < headers.Length; i++)
            {
                if (i > 0) sb.Append(",");
                sb.Append(Csv(row.ContainsKey(headers[i]) ? row[headers[i]] : ""));
            }
            sb.AppendLine();
        }
        File.WriteAllText(path, sb.ToString(), new UTF8Encoding(true));
    }

    private static void WriteSummary(string path, Summary s)
    {
        Directory.CreateDirectory(Path.GetDirectoryName(path));
        var sb = new StringBuilder();
        sb.AppendLine("{");
        Add(sb, "prefix", s.prefix, true);
        Add(sb, "baseScene", s.baseScene, true);
        Add(sb, "outputScene", s.outputScene, true);
        Add(sb, "baseSceneOpened", s.baseSceneOpened, true);
        Add(sb, "sceneSaved", s.sceneSaved, true);
        Add(sb, "runtimeRehydrateUsed", s.runtimeRehydrateUsed, true);
        Add(sb, "sourceBackedPersistentImportUsed", s.sourceBackedPersistentImportUsed, true);
        Add(sb, "fakeMeshUsed", s.fakeMeshUsed, true);
        Add(sb, "fakeHandlerUsed", s.fakeHandlerUsed, true);
        Add(sb, "isFinalRestoredBattleScreen", s.isFinalRestoredBattleScreen, true);
        Add(sb, "patchDecision", s.patchDecision, true);
        Add(sb, "actorRows", s.actorRows, true);
        Add(sb, "bundleLoadedActorRows", s.bundleLoadedActorRows, true);
        Add(sb, "prefabInstantiatedRows", s.prefabInstantiatedRows, true);
        Add(sb, "meshReadyRows", s.meshReadyRows, true);
        Add(sb, "materialReadyRows", s.materialReadyRows, true);
        Add(sb, "skeletonAnimationRows", s.skeletonAnimationRows, true);
        Add(sb, "animationStateSetRows", s.animationStateSetRows, true);
        Add(sb, "boundsNonZeroRows", s.boundsNonZeroRows, true);
        Add(sb, "pixelDiffRows", s.pixelDiffRows, true);
        Add(sb, "totalDiffPixels", s.totalDiffPixels, true);
        Add(sb, "disabledHollowShellCount", s.disabledHollowShellCount, true);
        Add(sb, "shaderBundleLoaded", s.shaderBundleLoaded, true);
        Add(sb, "shaderBundleShaderCount", s.shaderBundleShaderCount, true);
        Add(sb, "captureCameraName", s.captureCameraName, true);
        Add(sb, "captureCameraPixelRect", s.captureCameraPixelRect, true);
        Add(sb, "captureCameraOrthographic", s.captureCameraOrthographic, true);
        Add(sb, "captureCameraOrthographicSize", s.captureCameraOrthographicSize, true);
        Add(sb, "captureCameraCullingMask", s.captureCameraCullingMask, true);
        Add(sb, "captureCameraCreated", s.captureCameraCreated, true);
        Add(sb, "capture", s.capture, true);
        Add(sb, "baselineCapture", s.baselineCapture, true);
        Add(sb, "diffCapture", s.diffCapture, true);
        Add(sb, "captureExists", s.captureExists, true);
        Add(sb, "nextBlocker", s.nextBlocker, true);
        Add(sb, "failReason", s.failReason, false);
        sb.AppendLine("}");
        File.WriteAllText(path, sb.ToString(), Encoding.UTF8);
    }

    private static string[] MappingHeaders()
    {
        return new[] { "mappingKind", "side", "wave", "slot", "heroDid", "modelId", "bundle", "bundleFileExists", "bundleLoaded", "prefabAsset", "prefabInstantiated", "oldSceneActorPath", "oldHadMesh", "oldHadMaterial", "newActorPath", "position", "scale", "expectedAnimation", "animationStateSet", "animationUsed", "skeletonDataAsset", "replacementPolicy", "failReason" };
    }

    private static string[] RendererHeaders()
    {
        return new[] { "side", "wave", "slot", "heroDid", "modelId", "bundle", "actorPath", "rendererPath", "rendererType", "rendererEnabled", "sortingLayer", "sortingOrder", "boundsCenter", "boundsSize", "materialSlotCount", "materialNames", "shaderNames", "textureNames", "materialNullCount", "unsupportedShaderMaterialCount", "meshNonNull", "meshVertexCount", "meshTriangleIndexCount", "shaderRebindAppliedCount" };
    }

    private static string[] VisibilityHeaders()
    {
        return new[] { "side", "wave", "slot", "heroDid", "modelId", "bundle", "actorPath", "activeInHierarchy", "meshReady", "materialReady", "rendererCount", "enabledRendererCount", "meshVertexCount", "bounds", "boundsSize", "screenRect", "screenCenterNorm", "screenAreaRatio", "cameraName", "cameraPixelRect", "cameraIncludesLayer", "frustumCandidate", "meshHash", "actorPixelRect", "actorPixelSampleCount", "actorPixelDiffCount", "actorPixelDiffRatioInRect", "capturePixelSignal" };
    }

    private static Dictionary<string, string> NewRow(string[] headers)
    {
        var row = new Dictionary<string, string>();
        foreach (var h in headers) row[h] = "";
        return row;
    }

    private static string Csv(string value)
    {
        value = value ?? "";
        if (value.IndexOfAny(new[] { ',', '"', '\n', '\r' }) >= 0) return "\"" + value.Replace("\"", "\"\"") + "\"";
        return value;
    }

    private static void Add(StringBuilder sb, string name, string value, bool comma) { sb.AppendLine("  \"" + name + "\": \"" + Json(value) + "\"" + (comma ? "," : "")); }
    private static void Add(StringBuilder sb, string name, bool value, bool comma) { sb.AppendLine("  \"" + name + "\": " + (value ? "true" : "false") + (comma ? "," : "")); }
    private static void Add(StringBuilder sb, string name, int value, bool comma) { sb.AppendLine("  \"" + name + "\": " + value.ToString(CultureInfo.InvariantCulture) + (comma ? "," : "")); }
    private static void Add(StringBuilder sb, string name, float value, bool comma) { sb.AppendLine("  \"" + name + "\": " + value.ToString(CultureInfo.InvariantCulture) + (comma ? "," : "")); }
    private static string Json(string value) { return (value ?? "").Replace("\\", "\\\\").Replace("\"", "\\\""); }
    private static string Bool(bool value) { return value ? "True" : "False"; }
    private static string Vec(Vector3 v) { return v.x.ToString(CultureInfo.InvariantCulture) + "/" + v.y.ToString(CultureInfo.InvariantCulture) + "/" + v.z.ToString(CultureInfo.InvariantCulture); }
    private static string RectString(Rect r) { return r.x.ToString(CultureInfo.InvariantCulture) + "/" + r.y.ToString(CultureInfo.InvariantCulture) + "/" + r.width.ToString(CultureInfo.InvariantCulture) + "/" + r.height.ToString(CultureInfo.InvariantCulture); }
    private static string ProjectPath(string assetPath) { return Path.Combine(Application.dataPath, "..", assetPath.Replace("/", "\\")); }

    private static string HierarchyPath(Transform transform)
    {
        var names = new List<string>();
        var t = transform;
        while (t != null) { names.Add(t.name); t = t.parent; }
        names.Reverse();
        return string.Join("/", names.ToArray());
    }

    private static object ReadField(object obj, string name)
    {
        if (obj == null) return null;
        var f = obj.GetType().GetField(name, BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance);
        return f != null ? f.GetValue(obj) : null;
    }

    private static object ReadProperty(object obj, string name)
    {
        if (obj == null) return null;
        var p = obj.GetType().GetProperty(name, BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance);
        return p != null ? p.GetValue(obj, null) : null;
    }

    private static object ReadPropertyOrField(object obj, string name)
    {
        var p = ReadProperty(obj, name);
        return p ?? ReadField(obj, name);
    }

    private static string ReadStringField(object obj, string name)
    {
        var value = ReadField(obj, name);
        return value != null ? value.ToString() : "";
    }

    private static string ReadStringPropertyOrField(object obj, string name)
    {
        var value = ReadPropertyOrField(obj, name);
        return value != null ? value.ToString() : "";
    }

    private static bool ReadBoolField(object obj, string name)
    {
        var value = ReadField(obj, name);
        return value is bool && (bool)value;
    }

    private static void InvokeIfExists(object obj, string name, Type[] types, object[] args)
    {
        if (obj == null) return;
        var method = obj.GetType().GetMethod(name, types);
        if (method != null) method.Invoke(obj, args);
    }

    private static int CountCollection(object value)
    {
        var c = value as ICollection;
        if (c != null) return c.Count;
        int count = 0;
        foreach (var _ in EnumerateCollection(value)) count++;
        return count;
    }

    private static IEnumerable<object> EnumerateCollection(object value)
    {
        var enumerable = value as IEnumerable;
        if (enumerable == null) yield break;
        foreach (var item in enumerable) yield return item;
    }

    private static string ObjectName(object obj)
    {
        var o = obj as UnityEngine.Object;
        return o != null ? o.name : "";
    }

    private static Exception Unwrap(Exception ex)
    {
        var tie = ex as TargetInvocationException;
        return tie != null && tie.InnerException != null ? tie.InnerException : ex;
    }

    private static string Short(Exception ex)
    {
        if (ex == null) return "";
        var message = ex.GetType().Name + ": " + ex.Message;
        return message.Length > 260 ? message.Substring(0, 260) : message;
    }

    private sealed class ActorTarget
    {
        public string side;
        public int wave;
        public int slot;
        public string heroDid;
        public string modelId;
        public string expectedAnimation;
        public List<string> animationCandidates;
        public string bundle;
        public string prefabAsset;
        public Vector3 position;
        public float scale;
        public int sortingOrder;
        public ActorTarget(string side, int wave, int slot, string heroDid, string modelId, string expectedAnimation, string[] animationCandidates, string bundle, string prefabAsset, Vector3 position, float scale, int sortingOrder)
        {
            this.side = side;
            this.wave = wave;
            this.slot = slot;
            this.heroDid = heroDid;
            this.modelId = modelId;
            this.expectedAnimation = expectedAnimation;
            this.animationCandidates = new List<string>(animationCandidates);
            this.bundle = bundle;
            this.prefabAsset = prefabAsset;
            this.position = position;
            this.scale = scale;
            this.sortingOrder = sortingOrder;
        }
    }

    private sealed class ActorRuntime
    {
        public ActorTarget target;
        public string absoluteBundlePath = "";
        public bool bundleFileExists;
        public bool bundleLoaded;
        public bool prefabInstantiated;
        public string usedPrefabAsset = "";
        public string instanceHierarchyPath = "";
        public string failReason = "";
        public GameObject instance;
        public Component skeletonAnimation;
        public int missingScriptCount;
        public int skeletonAnimationComponentCount;
        public string serializedAnimationName = "";
        public bool afterInitializeValid;
        public string skeletonDataAssetName = "";
        public bool skeletonDataNull;
        public int boneCount;
        public int slotCount;
        public int animationCount;
        public List<string> animationNames = new List<string>();
        public bool animationStateNonNull;
        public bool animationStateSetSucceeded;
        public string animationStateUsedName = "";
        public int shaderRebindAppliedCount;
        public int shaderRebindFailedCount;
        public int renderOrderAppliedCount;
        public string runtimeException = "";
        public List<string> materialRows = new List<string>();
        public int meshFilterCount;
        public int meshFilterWithMeshCount;
        public int meshVertexCount;
        public int meshTriangleIndexCount;
        public int rendererCount;
        public int enabledRendererCount;
        public int materialSlotCount;
        public int materialNullCount;
        public int unsupportedShaderMaterialCount;
        public string bounds = "";
        public string boundsSize = "";
        public Bounds lastBounds;
        public string meshHash = "";
    }

    private sealed class ShaderBundleInfo
    {
        public string bundle = "";
        public string absolutePath = "";
        public bool fileExists;
        public bool loaded;
        public int shaderCount;
        public string status = "";
    }

    private sealed class Summary
    {
        public string prefix = "";
        public string baseScene = "";
        public string outputScene = "";
        public bool baseSceneOpened;
        public bool sceneSaved;
        public bool runtimeRehydrateUsed;
        public bool sourceBackedPersistentImportUsed;
        public bool fakeMeshUsed;
        public bool fakeHandlerUsed;
        public bool isFinalRestoredBattleScreen;
        public string patchDecision = "";
        public int actorRows;
        public int bundleLoadedActorRows;
        public int prefabInstantiatedRows;
        public int meshReadyRows;
        public int materialReadyRows;
        public int skeletonAnimationRows;
        public int animationStateSetRows;
        public int boundsNonZeroRows;
        public int pixelDiffRows;
        public int totalDiffPixels;
        public int disabledHollowShellCount;
        public bool shaderBundleLoaded;
        public int shaderBundleShaderCount;
        public string captureCameraName = "";
        public string captureCameraPixelRect = "";
        public bool captureCameraOrthographic;
        public float captureCameraOrthographicSize;
        public int captureCameraCullingMask;
        public bool captureCameraCreated;
        public string capture = "";
        public string baselineCapture = "";
        public string diffCapture = "";
        public bool captureExists;
        public string nextBlocker = "";
        public string failReason = "";
    }

    private sealed class DiffStats
    {
        public int changedPixels;
    }
}
