using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.SceneManagement;
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Reflection;
using System.Text;

public static class Battle39AttachRuntimeActorsToMap11003HudContextWithEvidenceEditor
{
    private const string ResultJsonPath = "Assets/RestoreData/battle/BATTLE_39_ATTACH_RUNTIME_ACTORS_TO_MAP11003_HUD_CONTEXT_WITH_EVIDENCE_UNITY.json";
    private const string ActorBoundsCsvPath = "Assets/RestoreData/battle/BATTLE_39_ATTACH_RUNTIME_ACTORS_TO_MAP11003_HUD_CONTEXT_WITH_EVIDENCE_ACTOR_BOUNDS.csv";
    private const string ScenePath = "Assets/Scenes/Battle39RuntimeActorsMap11003HudContextCandidate.unity";
    private const string BaseScenePath = "Assets/Scenes/BattleHeroListSkillCardBindClip05.unity";
    private const string CapturePath = "Assets/RestoreCaptures/battle_actor/Battle39RuntimeActorsMap11003HudContext_1920x1080.png";
    private const string SequenceDir = "Assets/RestoreCaptures/battle_actor/battle39_sequence";
    private const string BundleRoot = "C:/Users/godho/Downloads/girlswar/girlswar_merged_extracted/extracted/unity/clean_unityfs_slices";
    private const int CaptureWidth = 1920;
    private const int CaptureHeight = 1080;

    [MenuItem("GirlsWar/Battle/BATTLE39 Attach Runtime Actors To Map11003 HUD Context With Evidence")]
    public static void Build()
    {
        Directory.CreateDirectory(ProjectPath("Assets/RestoreData/battle"));
        Directory.CreateDirectory(ProjectPath("Assets/Scenes"));
        Directory.CreateDirectory(ProjectPath("Assets/RestoreCaptures/battle_actor"));
        Directory.CreateDirectory(ProjectPath(SequenceDir));

        var context = new Battle39ContextEvidence();
        var baseSceneFullPath = ProjectPath(BaseScenePath);
        Scene scene;
        if (File.Exists(baseSceneFullPath))
        {
            scene = EditorSceneManager.OpenScene(BaseScenePath, OpenSceneMode.Single);
            context.baseSceneOpened = true;
        }
        else
        {
            scene = EditorSceneManager.NewScene(NewSceneSetup.EmptyScene, NewSceneMode.Single);
            context.baseSceneOpened = false;
            context.baseSceneFailReason = "BATTLE29 base scene file not found";
        }

        context.disabledExistingBattle27ActorCount = DisableExistingBattle27Actors();
        context.hasBattleMap = GameObject.Find("BattleCorrectMapSceneHudPreviewClip05Root") != null || FindByNameContains("Map_11003") != null;
        context.hasBattleHud = GameObject.Find("BattleHudSpriteAtlasTextureRuntimeBindingClip05Root") != null || FindByNameContains("ui_normalbattle") != null;
        context.hasHeroCards = FindByNameContains("Battle29BoundHeroCard") != null || FindByNameContains("HeroListContainer") != null;

        var camera = FindCaptureCamera();
        context.cameraFound = camera != null;
        if (camera == null) camera = CreateFallbackCamera();

        var root = new GameObject("BATTLE39_RuntimeActors_AttachedTo_BATTLE29_Map11003HudContext");
        root.transform.position = Vector3.zero;

        var targets = new List<Battle39ActorTarget>
        {
            new Battle39ActorTarget("our", 0, 2, "1002", "1002", "ult", new[] { "ult", "stand", "skill1" }, "download/roleprefabsandres/battleprefabandres/1002.assetbundle", "assets/download/roleprefabsandres/battleprefabandres/1002/hero_1002.prefab", new Vector3(-1.65f, -2.35f, -0.2f), 0.70f, 36),
            new Battle39ActorTarget("our", 0, 3, "1034", "1034", "skill1", new[] { "skill1", "stand", "ult" }, "download/roleprefabsandres/battleprefabandres/1034.assetbundle", "assets/download/roleprefabsandres/battleprefabandres/1034/hero_1034.prefab", new Vector3(0f, -2.35f, -0.2f), 0.70f, 36),
            new Battle39ActorTarget("enemy", 1, 1, "1100111", "3001", "attack", new[] { "attack", "attackR", "stand", "run1" }, "download/roleprefabsandres/battleprefabandres/3001.assetbundle", "assets/download/roleprefabsandres/battleprefabandres/3001/hero_3001.prefab", new Vector3(1.05f, 2.35f, -0.2f), 0.62f, 32),
        };

        var opened = new List<AssetBundle>();
        var shaderBundle = LoadShaderBundle(opened);
        var actors = new List<Battle39ActorRuntime>();
        var actorRows = new List<Battle39ActorBoundsRow>();

        foreach (var target in targets)
        {
            actors.Add(LoadActor(target, root.transform, opened));
        }

        for (int i = 0; i < 6; i++)
        {
            foreach (var actor in actors)
            {
                StepActor(actor, 1f / 15f);
                actorRows.Add(CreateBoundsRow(actor, camera, i));
            }
            Capture(camera, ProjectPath(SequenceDir + "/Battle39RuntimeContext_" + i.ToString("00") + "_1920x1080.png"));
        }

        Capture(camera, ProjectPath(CapturePath));
        WriteActorCsv(ProjectPath(ActorBoundsCsvPath), actorRows);
        WriteJson(ProjectPath(ResultJsonPath), context, shaderBundle, actors, actorRows, camera);
        EditorSceneManager.SaveScene(scene, ScenePath);

        foreach (var bundle in opened)
            if (bundle != null) bundle.Unload(false);

        AssetDatabase.Refresh();
        Debug.Log("BATTLE39 runtime actors attached to map/HUD context candidate. actors=" + actors.Count + ", rows=" + actorRows.Count);
    }

    private static int DisableExistingBattle27Actors()
    {
        int count = 0;
        foreach (var transform in UnityEngine.Object.FindObjectsOfType<Transform>(true))
        {
            if (transform == null || transform.gameObject == null) continue;
            if (!transform.name.StartsWith("Battle27RuntimeActor_", StringComparison.Ordinal)) continue;
            if (transform.gameObject.activeSelf)
            {
                transform.gameObject.SetActive(false);
                count++;
            }
        }
        return count;
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
        var cameraObject = new GameObject("BATTLE39_FallbackCaptureCamera");
        var camera = cameraObject.AddComponent<Camera>();
        camera.clearFlags = CameraClearFlags.SolidColor;
        camera.backgroundColor = new Color(0.035f, 0.037f, 0.042f, 1f);
        camera.orthographic = true;
        camera.orthographicSize = 5f;
        cameraObject.transform.position = new Vector3(0f, 0f, -10f);
        return camera;
    }

    private static GameObject FindByNameContains(string text)
    {
        foreach (var transform in UnityEngine.Object.FindObjectsOfType<Transform>(true))
        {
            if (transform != null && transform.name.IndexOf(text, StringComparison.OrdinalIgnoreCase) >= 0)
                return transform.gameObject;
        }
        return null;
    }

    private static Battle39ShaderBundleInfo LoadShaderBundle(List<AssetBundle> opened)
    {
        var info = new Battle39ShaderBundleInfo();
        info.bundle = "download/commonprefabsandres/spinematandshaders.assetbundle";
        info.absolutePath = Path.Combine(BundleRoot, info.bundle.Replace("/", "\\"));
        info.fileExists = File.Exists(info.absolutePath);
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
            var shader = bundle.LoadAsset<Shader>(assetName);
            if (shader != null) info.shaderNames.Add(shader.name + "|supported=" + Bool(shader.isSupported) + "|passCount=" + shader.passCount);
        }
        return info;
    }

    private static Battle39ActorRuntime LoadActor(Battle39ActorTarget target, Transform root, List<AssetBundle> opened)
    {
        var runtime = new Battle39ActorRuntime();
        runtime.target = target;
        runtime.absoluteBundlePath = Path.Combine(BundleRoot, target.bundle.Replace("/", "\\"));
        runtime.fileExists = File.Exists(runtime.absoluteBundlePath);
        if (!runtime.fileExists)
        {
            runtime.failReason = "bundle_file_not_found";
            return runtime;
        }
        var bundle = AssetBundle.LoadFromFile(runtime.absoluteBundlePath);
        if (bundle == null)
        {
            runtime.failReason = "AssetBundle.LoadFromFile_returned_null";
            return runtime;
        }
        opened.Add(bundle);
        runtime.bundleLoaded = true;

        var prefab = bundle.LoadAsset<GameObject>(target.prefabAsset);
        if (prefab == null)
        {
            foreach (var name in bundle.GetAllAssetNames())
            {
                if (name.ToLowerInvariant().EndsWith(".prefab") && name.ToLowerInvariant().Contains("hero_"))
                {
                    target.prefabAsset = name;
                    prefab = bundle.LoadAsset<GameObject>(name);
                    break;
                }
            }
        }
        if (prefab == null)
        {
            runtime.failReason = "prefab_not_found";
            return runtime;
        }

        runtime.instance = (GameObject)GameObject.Instantiate(prefab, target.position, Quaternion.identity, root);
        runtime.instance.name = "BATTLE39_RuntimeActor_" + target.side + "_w" + target.wave + "_s" + target.slot + "_" + target.heroDid + "_model_" + target.modelId;
        runtime.instance.transform.localScale = Vector3.one * target.scale;
        runtime.prefabInstantiated = true;

        ApplyRenderOrder(runtime);
        RebindMaterials(runtime);
        InitializeAndSetAnimation(runtime);
        return runtime;
    }

    private static void ApplyRenderOrder(Battle39ActorRuntime runtime)
    {
        if (runtime.instance == null) return;
        foreach (var renderer in runtime.instance.GetComponentsInChildren<Renderer>(true))
        {
            renderer.sortingOrder = runtime.target.sortingOrder;
            runtime.renderOrderAppliedCount++;
        }
    }

    private static void RebindMaterials(Battle39ActorRuntime runtime)
    {
        if (runtime.instance == null) return;
        foreach (var renderer in runtime.instance.GetComponentsInChildren<Renderer>(true))
        {
            foreach (var material in renderer.sharedMaterials)
            {
                if (material == null || material.shader == null) continue;
                runtime.materialRows.Add(MaterialInfo(material));
                if (material.shader.isSupported) continue;
                var shader = Shader.Find(material.shader.name);
                if (shader != null && shader.isSupported && shader.passCount > 0)
                {
                    material.shader = shader;
                    runtime.shaderRebindAppliedCount++;
                }
                else
                {
                    runtime.shaderRebindFailedCount++;
                }
                runtime.materialRows.Add("after|" + MaterialInfo(material));
            }
        }
    }

    private static void InitializeAndSetAnimation(Battle39ActorRuntime runtime)
    {
        if (runtime.instance == null) return;
        foreach (var component in runtime.instance.GetComponentsInChildren<Component>(true))
        {
            if (component == null)
            {
                runtime.missingScriptCount++;
                continue;
            }
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
                        if (!string.IsNullOrEmpty(candidate) && (runtime.animationNames.Contains(candidate) || !runtime.animationStateSetSucceeded))
                        {
                            try
                            {
                                set.Invoke(state, new object[] { 0, candidate, true });
                                runtime.animationStateSetSucceeded = true;
                                runtime.animationStateUsedName = candidate;
                                break;
                            }
                            catch (Exception ex)
                            {
                                runtime.runtimeException = Short(Unwrap(ex));
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                runtime.runtimeException = Short(Unwrap(ex));
            }
        }
    }

    private static void TraceSkeleton(Component component, Battle39ActorRuntime runtime)
    {
        var sda = ReadField(component, "skeletonDataAsset");
        runtime.skeletonDataAssetName = ObjectName(sda);
        if (sda == null) return;
        try
        {
            var method = sda.GetType().GetMethod("GetSkeletonData", new[] { typeof(bool) });
            var skeletonData = method != null ? method.Invoke(sda, new object[] { false }) : null;
            runtime.skeletonDataNull = skeletonData == null;
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
        catch (Exception ex)
        {
            runtime.runtimeException = Short(Unwrap(ex));
        }
    }

    private static void StepActor(Battle39ActorRuntime runtime, float dt)
    {
        if (runtime.skeletonAnimation == null) return;
        InvokeIfExists(runtime.skeletonAnimation, "Update", new[] { typeof(float) }, new object[] { dt });
        InvokeIfExists(runtime.skeletonAnimation, "LateUpdate", Type.EmptyTypes, new object[0]);
    }

    private static Battle39ActorBoundsRow CreateBoundsRow(Battle39ActorRuntime runtime, Camera camera, int frameIndex)
    {
        var row = new Battle39ActorBoundsRow();
        row.frame = frameIndex;
        row.side = runtime.target.side;
        row.wave = runtime.target.wave;
        row.slot = runtime.target.slot;
        row.heroDid = runtime.target.heroDid;
        row.modelId = runtime.target.modelId;
        row.animationName = runtime.animationStateUsedName;
        row.localScale = runtime.instance != null ? Vec(runtime.instance.transform.localScale) : "";
        row.rootPosition = runtime.instance != null ? Vec(runtime.instance.transform.position) : "";
        row.meshHash = MeshHash(runtime.instance);
        row.worldBounds = CombinedBounds(runtime.instance, out var bounds);
        row.screenRect = bounds.size == Vector3.zero ? "" : ScreenRect(camera, bounds);
        row.screenCenterNorm = bounds.size == Vector3.zero ? "" : ScreenCenterNorm(camera, bounds);
        row.screenAreaRatio = bounds.size == Vector3.zero ? 0f : ScreenAreaRatio(camera, bounds);
        row.rendererCount = runtime.instance != null ? runtime.instance.GetComponentsInChildren<Renderer>(true).Length : 0;
        row.shaderRebindAppliedCount = runtime.shaderRebindAppliedCount;
        return row;
    }

    private static string CombinedBounds(GameObject instance, out Bounds combined)
    {
        combined = new Bounds(Vector3.zero, Vector3.zero);
        if (instance == null) return "";
        bool has = false;
        foreach (var renderer in instance.GetComponentsInChildren<Renderer>(true))
        {
            if (!renderer.enabled) continue;
            if (!has)
            {
                combined = renderer.bounds;
                has = true;
            }
            else
            {
                combined.Encapsulate(renderer.bounds);
            }
        }
        return has ? Vec(combined.center) + "|" + Vec(combined.size) : "";
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
        return min.x.ToString("0.##") + "/" + min.y.ToString("0.##") + "/" + max.x.ToString("0.##") + "/" + max.y.ToString("0.##");
    }

    private static string ScreenCenterNorm(Camera camera, Bounds bounds)
    {
        if (camera == null) return "";
        var sp = camera.WorldToScreenPoint(bounds.center);
        return (sp.x / CaptureWidth).ToString("0.######") + "/" + (1f - sp.y / CaptureHeight).ToString("0.######");
    }

    private static float ScreenAreaRatio(Camera camera, Bounds bounds)
    {
        if (camera == null) return 0f;
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
        var area = Mathf.Max(0f, max.x - min.x) * Mathf.Max(0f, max.y - min.y);
        return area / (CaptureWidth * CaptureHeight);
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

    private static void Capture(Camera camera, string fullPath)
    {
        Directory.CreateDirectory(Path.GetDirectoryName(fullPath));
        var rt = new RenderTexture(CaptureWidth, CaptureHeight, 24, RenderTextureFormat.ARGB32);
        var prevTarget = camera.targetTexture;
        var prevActive = RenderTexture.active;
        camera.targetTexture = rt;
        RenderTexture.active = rt;
        camera.Render();
        var tex = new Texture2D(CaptureWidth, CaptureHeight, TextureFormat.RGB24, false);
        tex.ReadPixels(new Rect(0, 0, CaptureWidth, CaptureHeight), 0, 0);
        tex.Apply();
        File.WriteAllBytes(fullPath, tex.EncodeToPNG());
        camera.targetTexture = prevTarget;
        RenderTexture.active = prevActive;
        UnityEngine.Object.DestroyImmediate(tex);
        UnityEngine.Object.DestroyImmediate(rt);
    }

    private static void WriteActorCsv(string path, List<Battle39ActorBoundsRow> rows)
    {
        var sb = new StringBuilder();
        sb.AppendLine("frame,side,wave,slot,heroDid,modelId,animationName,localScale,rootPosition,worldBounds,screenRect,screenCenterNorm,screenAreaRatio,rendererCount,shaderRebindAppliedCount,meshHash");
        foreach (var row in rows)
        {
            sb.AppendLine(row.frame + "," + Csv(row.side) + "," + row.wave + "," + row.slot + "," + Csv(row.heroDid) + "," + Csv(row.modelId) + "," + Csv(row.animationName) + "," + Csv(row.localScale) + "," + Csv(row.rootPosition) + "," + Csv(row.worldBounds) + "," + Csv(row.screenRect) + "," + Csv(row.screenCenterNorm) + "," + row.screenAreaRatio.ToString("0.########") + "," + row.rendererCount + "," + row.shaderRebindAppliedCount + "," + Csv(row.meshHash));
        }
        File.WriteAllText(path, sb.ToString(), new UTF8Encoding(false));
    }

    private static void WriteJson(string path, Battle39ContextEvidence context, Battle39ShaderBundleInfo shaderBundle, List<Battle39ActorRuntime> actors, List<Battle39ActorBoundsRow> rows, Camera camera)
    {
        var sb = new StringBuilder();
        sb.AppendLine("{");
        sb.AppendLine("  \"verdict\": \"battle39_runtime_actors_attached_to_map11003_hud_context_candidate\",");
        sb.AppendLine("  \"isFinalRestoredBattleScreen\": false,");
        sb.AppendLine("  \"scene\": \"" + Json(ScenePath) + "\",");
        sb.AppendLine("  \"baseScene\": \"" + Json(BaseScenePath) + "\",");
        sb.AppendLine("  \"capture\": \"" + Json(CapturePath) + "\",");
        sb.AppendLine("  \"sequenceDir\": \"" + Json(SequenceDir) + "\",");
        sb.AppendLine("  \"placementEvidenceStatus\": \"runtime_flow_manifest_positions_on_BATTLE29_map11003_context_candidate_not_original_runtime_verified\",");
        sb.AppendLine("  \"camera\": {\"name\":\"" + Json(camera != null ? camera.name : "") + "\",\"orthographic\":" + Bool(camera != null && camera.orthographic) + ",\"orthographicSize\":" + (camera != null ? camera.orthographicSize.ToString("0.###") : "0") + ",\"position\":\"" + Json(camera != null ? Vec(camera.transform.position) : "") + "\",\"background\":\"" + Json(camera != null ? camera.backgroundColor.ToString() : "") + "\"},");
        sb.AppendLine("  \"context\": {");
        sb.AppendLine("    \"baseSceneOpened\": " + Bool(context.baseSceneOpened) + ",");
        sb.AppendLine("    \"baseSceneFailReason\": \"" + Json(context.baseSceneFailReason) + "\",");
        sb.AppendLine("    \"hasBattleMap\": " + Bool(context.hasBattleMap) + ",");
        sb.AppendLine("    \"hasBattleHud\": " + Bool(context.hasBattleHud) + ",");
        sb.AppendLine("    \"hasHeroCards\": " + Bool(context.hasHeroCards) + ",");
        sb.AppendLine("    \"cameraFound\": " + Bool(context.cameraFound) + ",");
        sb.AppendLine("    \"disabledExistingBattle27ActorCount\": " + context.disabledExistingBattle27ActorCount + ",");
        sb.AppendLine("    \"mapContextSource\": \"BATTLE29_map_11003_layers\",");
        sb.AppendLine("    \"hudContextSource\": \"BATTLE29_ui_normalbattle_and_hero_card_context\",");
        sb.AppendLine("    \"actorPlacementSource\": \"BATTLE_RUNTIME_FLOW_MANIFEST_coordinates; mapId_11001_payload_on_clip05_map11003_visual_context\",");
        sb.AppendLine("    \"evidenceWarning\": \"context attach is evidence-bearing but not final: formation/camera placement is not original runtime verified\"");
        sb.AppendLine("  },");
        sb.AppendLine("  \"shaderBundle\": {\"status\":\"" + Json(shaderBundle.status) + "\",\"loaded\":" + Bool(shaderBundle.loaded) + ",\"shaderNames\":" + JsonArray(shaderBundle.shaderNames) + "},");
        sb.AppendLine("  \"summary\": {");
        sb.AppendLine("    \"actorCount\": " + actors.Count + ",");
        sb.AppendLine("    \"boundsRowCount\": " + rows.Count + ",");
        sb.AppendLine("    \"prefabInstantiateSuccess\": " + Count(actors, a => a.prefabInstantiated) + ",");
        sb.AppendLine("    \"shaderRebindAppliedCount\": " + Sum(actors, a => a.shaderRebindAppliedCount) + ",");
        sb.AppendLine("    \"renderOrderAppliedCount\": " + Sum(actors, a => a.renderOrderAppliedCount) + ",");
        sb.AppendLine("    \"animationStateSetSucceededCount\": " + Count(actors, a => a.animationStateSetSucceeded) + ",");
        sb.AppendLine("    \"meshHashChangedActorCount\": " + CountMeshHashChanged(rows));
        sb.AppendLine("  },");
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

    private static string ActorJson(Battle39ActorRuntime a, string indent)
    {
        var sb = new StringBuilder();
        sb.AppendLine(indent + "{");
        Add(sb, indent, "side", a.target.side);
        Add(sb, indent, "wave", a.target.wave);
        Add(sb, indent, "slot", a.target.slot);
        Add(sb, indent, "heroDid", a.target.heroDid);
        Add(sb, indent, "modelId", a.target.modelId);
        Add(sb, indent, "expectedAnimation", a.target.expectedAnimation);
        Add(sb, indent, "animationStateUsedName", a.animationStateUsedName);
        Add(sb, indent, "bundleLoaded", a.bundleLoaded);
        Add(sb, indent, "prefabInstantiated", a.prefabInstantiated);
        Add(sb, indent, "afterInitializeValid", a.afterInitializeValid);
        Add(sb, indent, "skeletonDataAssetName", a.skeletonDataAssetName);
        Add(sb, indent, "boneCount", a.boneCount);
        Add(sb, indent, "slotCount", a.slotCount);
        Add(sb, indent, "animationCount", a.animationCount);
        Add(sb, indent, "animationNames", a.animationNames);
        Add(sb, indent, "shaderRebindAppliedCount", a.shaderRebindAppliedCount);
        Add(sb, indent, "shaderRebindFailedCount", a.shaderRebindFailedCount);
        Add(sb, indent, "renderOrderAppliedCount", a.renderOrderAppliedCount);
        Add(sb, indent, "runtimeException", a.runtimeException);
        sb.AppendLine(indent + "  \"materialRows\": " + JsonArray(a.materialRows));
        sb.Append(indent + "}");
        return sb.ToString();
    }

    private static void Add(StringBuilder sb, string indent, string name, string value) { sb.AppendLine(indent + "  \"" + name + "\": \"" + Json(value) + "\","); }
    private static void Add(StringBuilder sb, string indent, string name, bool value) { sb.AppendLine(indent + "  \"" + name + "\": " + Bool(value) + ","); }
    private static void Add(StringBuilder sb, string indent, string name, int value) { sb.AppendLine(indent + "  \"" + name + "\": " + value + ","); }
    private static void Add(StringBuilder sb, string indent, string name, List<string> values) { sb.AppendLine(indent + "  \"" + name + "\": " + JsonArray(values) + ","); }

    private static int CountMeshHashChanged(List<Battle39ActorBoundsRow> rows)
    {
        var first = new Dictionary<string, string>();
        var changed = new HashSet<string>();
        foreach (var row in rows)
        {
            var key = row.heroDid + "/" + row.modelId;
            if (!first.ContainsKey(key)) first[key] = row.meshHash;
            else if (first[key] != row.meshHash) changed.Add(key);
        }
        return changed.Count;
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
        return material.name + "|shader=" + (shader != null ? shader.name + "|supported=" + Bool(shader.isSupported) + "|passCount=" + shader.passCount : "") + "|mainTex=" + (tex != null ? tex.name + "(" + tex.width + "x" + tex.height + ")" : "");
    }

    private static int Count<T>(List<T> rows, Predicate<T> predicate)
    {
        int count = 0;
        foreach (var row in rows) if (predicate(row)) count++;
        return count;
    }

    private static int Sum(List<Battle39ActorRuntime> rows, Func<Battle39ActorRuntime, int> selector)
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

    private static string ProjectPath(string assetRelativePath)
    {
        return Path.Combine(Application.dataPath, "..", assetRelativePath.Replace("/", "\\"));
    }

    private static string Vec(Vector3 v) { return v.x.ToString("0.###") + "/" + v.y.ToString("0.###") + "/" + v.z.ToString("0.###"); }
    private static string Bool(bool value) { return value ? "true" : "false"; }
    private static string Json(string value) { return (value ?? "").Replace("\\", "\\\\").Replace("\"", "\\\"").Replace("\r", "\\r").Replace("\n", "\\n"); }
    private static string JsonArray(List<string> values)
    {
        var parts = new List<string>();
        foreach (var value in values) parts.Add("\"" + Json(value) + "\"");
        return "[" + string.Join(",", parts.ToArray()) + "]";
    }
    private static string Csv(string value) { return "\"" + (value ?? "").Replace("\"", "\"\"") + "\""; }

    private sealed class Battle39ActorTarget
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
        public Battle39ActorTarget(string side, int wave, int slot, string heroDid, string modelId, string expectedAnimation, string[] animationCandidates, string bundle, string prefabAsset, Vector3 position, float scale, int sortingOrder)
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

    private sealed class Battle39ContextEvidence
    {
        public bool baseSceneOpened;
        public string baseSceneFailReason = "";
        public bool hasBattleMap;
        public bool hasBattleHud;
        public bool hasHeroCards;
        public bool cameraFound;
        public int disabledExistingBattle27ActorCount;
    }

    private sealed class Battle39ShaderBundleInfo
    {
        public string bundle = "";
        public string absolutePath = "";
        public bool fileExists;
        public bool loaded;
        public string status = "";
        public List<string> shaderNames = new List<string>();
    }

    private sealed class Battle39ActorRuntime
    {
        public Battle39ActorTarget target;
        public string absoluteBundlePath = "";
        public bool fileExists;
        public bool bundleLoaded;
        public bool prefabInstantiated;
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
    }

    private sealed class Battle39ActorBoundsRow
    {
        public int frame;
        public string side = "";
        public int wave;
        public int slot;
        public string heroDid = "";
        public string modelId = "";
        public string animationName = "";
        public string localScale = "";
        public string rootPosition = "";
        public string worldBounds = "";
        public string screenRect = "";
        public string screenCenterNorm = "";
        public float screenAreaRatio;
        public int rendererCount;
        public int shaderRebindAppliedCount;
        public string meshHash = "";
    }
}
