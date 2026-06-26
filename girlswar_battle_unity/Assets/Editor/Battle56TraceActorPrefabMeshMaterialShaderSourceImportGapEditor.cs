using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Reflection;
using System.Text;

public static class Battle56TraceActorPrefabMeshMaterialShaderSourceImportGapEditor
{
    private const string Prefix = "BATTLE_56_TRACE_ACTOR_PREFAB_MESH_MATERIAL_SHADER_SOURCE_IMPORT_GAP_OR_SOURCE_BACKED_PATCH";
    private const string ScenePath = "Assets/Scenes/Battle51LuaBridgeRaycasterRegistrationCandidate.unity";
    private const string BundleRoot = "C:/Users/godho/Downloads/girlswar/girlswar_merged_extracted/extracted/unity/clean_unityfs_slices";
    private const string SummaryPath = "Assets/RestoreData/battle/BATTLE_56_TRACE_ACTOR_PREFAB_MESH_MATERIAL_SHADER_SOURCE_IMPORT_GAP_OR_SOURCE_BACKED_PATCH_UNITY_SUMMARY.json";
    private const string PrefabCsvPath = "Assets/RestoreData/battle/BATTLE_56_TRACE_ACTOR_PREFAB_MESH_MATERIAL_SHADER_SOURCE_IMPORT_GAP_OR_SOURCE_BACKED_PATCH_ACTOR_PREFAB_AUDIT.csv";
    private const string DependencyCsvPath = "Assets/RestoreData/battle/BATTLE_56_TRACE_ACTOR_PREFAB_MESH_MATERIAL_SHADER_SOURCE_IMPORT_GAP_OR_SOURCE_BACKED_PATCH_RENDERER_MATERIAL_SHADER_DEPENDENCIES.csv";
    private const string SceneCsvPath = "Assets/RestoreData/battle/BATTLE_56_TRACE_ACTOR_PREFAB_MESH_MATERIAL_SHADER_SOURCE_IMPORT_GAP_OR_SOURCE_BACKED_PATCH_CURRENT_SCENE_ACTORS.csv";

    private static readonly ActorTarget[] Targets = new[]
    {
        new ActorTarget("our", "1002", "1002", "download/roleprefabsandres/battleprefabandres/1002.assetbundle", "assets/download/roleprefabsandres/battleprefabandres/1002/hero_1002.prefab", "BATTLE39_RuntimeActors_AttachedTo_BATTLE29_Map11003HudContext/BATTLE39_RuntimeActor_our_w0_s2_1002_model_1002"),
        new ActorTarget("our", "1034", "1034", "download/roleprefabsandres/battleprefabandres/1034.assetbundle", "assets/download/roleprefabsandres/battleprefabandres/1034/hero_1034.prefab", "BATTLE39_RuntimeActors_AttachedTo_BATTLE29_Map11003HudContext/BATTLE39_RuntimeActor_our_w0_s3_1034_model_1034"),
        new ActorTarget("enemy", "1100111", "3001", "download/roleprefabsandres/battleprefabandres/3001.assetbundle", "assets/download/roleprefabsandres/battleprefabandres/3001/hero_3001.prefab", "BATTLE39_RuntimeActors_AttachedTo_BATTLE29_Map11003HudContext/BATTLE39_RuntimeActor_enemy_w1_s1_1100111_model_3001"),
    };

    [MenuItem("GirlsWar/Battle/BATTLE56 Trace Actor Prefab Mesh Material Shader Source Import Gap")]
    public static void Build()
    {
        Directory.CreateDirectory(ProjectPath("Assets/RestoreData/battle"));
        var prefabRows = new List<Dictionary<string, string>>();
        var dependencyRows = new List<Dictionary<string, string>>();
        var sceneRows = new List<Dictionary<string, string>>();
        var summary = new Summary();
        summary.prefix = Prefix;
        summary.scene = ScenePath;
        summary.isFinalRestoredBattleScreen = false;
        summary.patchDecision = "blocked_no_patch";

        AssetBundle.UnloadAllAssetBundles(false);
        var opened = new List<AssetBundle>();
        LoadShaderBundle(opened, dependencyRows);

        foreach (var target in Targets)
        {
            AuditBundleTarget(target, opened, prefabRows, dependencyRows);
        }

        if (File.Exists(ProjectPath(ScenePath)))
        {
            var scene = EditorSceneManager.OpenScene(ScenePath, OpenSceneMode.Single);
            summary.sceneOpened = scene.IsValid();
            foreach (var target in Targets)
                sceneRows.Add(InspectSceneActor(target));
        }
        else
        {
            summary.sceneOpened = false;
            summary.failReason = "battle51_scene_not_found";
        }

        foreach (var bundle in opened)
            if (bundle != null) bundle.Unload(false);

        summary.prefabRows = prefabRows.Count;
        summary.dependencyRows = dependencyRows.Count;
        summary.sceneRows = sceneRows.Count;
        summary.livePrefabMeshReadyRows = CountTrue(prefabRows, "liveMeshReady");
        summary.livePrefabSkeletonRows = CountGreater(prefabRows, "skeletonAnimationComponentCount", 0);
        summary.sceneMeshReadyRows = CountTrue(sceneRows, "sceneMeshReady");
        summary.sceneMaterialReadyRows = CountTrue(sceneRows, "sceneMaterialReady");
        summary.importGapRows = CountRows(sceneRows, "importGap", "assetbundle_runtime_references_not_persisted_in_saved_scene");
        summary.sourceBackedPatchAvailable = false;
        summary.nextBlocker = "SOURCE_BACKED_ACTOR_PREFAB_IMPORT_PIPELINE_REQUIRED_OR_REUSE_BATTLE37_RUNTIME_IN_SCENE_BUILDER";

        WriteCsv(ProjectPath(PrefabCsvPath), prefabRows, PrefabHeaders());
        WriteCsv(ProjectPath(DependencyCsvPath), dependencyRows, DependencyHeaders());
        WriteCsv(ProjectPath(SceneCsvPath), sceneRows, SceneHeaders());
        WriteSummary(ProjectPath(SummaryPath), summary);
        AssetDatabase.Refresh();
        Debug.Log("BATTLE56 actor prefab/source import gap audit complete. prefabRows=" + prefabRows.Count + " sceneRows=" + sceneRows.Count);
    }

    private static void LoadShaderBundle(List<AssetBundle> opened, List<Dictionary<string, string>> dependencyRows)
    {
        string bundle = "download/commonprefabsandres/spinematandshaders.assetbundle";
        string path = Path.Combine(BundleRoot, bundle.Replace("/", "\\"));
        var row = NewRow(DependencyHeaders());
        row["sourceKind"] = "shader_bundle";
        row["bundle"] = bundle;
        row["absolutePath"] = path;
        row["fileExists"] = Bool(File.Exists(path));
        if (!File.Exists(path))
        {
            row["status"] = "file_not_found";
            dependencyRows.Add(row);
            return;
        }
        var ab = AssetBundle.LoadFromFile(path);
        row["bundleLoaded"] = Bool(ab != null);
        if (ab == null)
        {
            row["status"] = "load_from_file_null";
            dependencyRows.Add(row);
            return;
        }
        opened.Add(ab);
        row["status"] = "loaded";
        row["assetCount"] = ab.GetAllAssetNames().Length.ToString(CultureInfo.InvariantCulture);
        dependencyRows.Add(row);
        foreach (var assetName in ab.GetAllAssetNames())
        {
            var shader = ab.LoadAsset<Shader>(assetName);
            if (shader == null) continue;
            var srow = NewRow(DependencyHeaders());
            srow["sourceKind"] = "shader_bundle_shader";
            srow["bundle"] = bundle;
            srow["assetName"] = assetName;
            srow["assetType"] = "UnityEngine.Shader";
            srow["shaderName"] = shader.name;
            srow["shaderSupported"] = Bool(shader.isSupported);
            srow["shaderPassCount"] = shader.passCount.ToString(CultureInfo.InvariantCulture);
            srow["status"] = "loaded";
            dependencyRows.Add(srow);
        }
    }

    private static void AuditBundleTarget(ActorTarget target, List<AssetBundle> opened, List<Dictionary<string, string>> prefabRows, List<Dictionary<string, string>> dependencyRows)
    {
        var row = NewRow(PrefabHeaders());
        FillTarget(row, target);
        string absolute = Path.Combine(BundleRoot, target.bundle.Replace("/", "\\"));
        row["absoluteBundlePath"] = absolute;
        row["bundleFileExists"] = Bool(File.Exists(absolute));
        row["assetDatabasePrefabExists"] = Bool(!string.IsNullOrEmpty(AssetDatabase.AssetPathToGUID(ToProjectAssetPath(target.prefabAsset))));
        if (!File.Exists(absolute))
        {
            row["status"] = "bundle_file_not_found";
            prefabRows.Add(row);
            return;
        }
        var bundle = AssetBundle.LoadFromFile(absolute);
        row["bundleLoaded"] = Bool(bundle != null);
        if (bundle == null)
        {
            row["status"] = "assetbundle_load_from_file_null";
            prefabRows.Add(row);
            return;
        }
        opened.Add(bundle);
        var assetNames = bundle.GetAllAssetNames();
        row["assetNameCount"] = assetNames.Length.ToString(CultureInfo.InvariantCulture);
        row["prefabAssetNames"] = JoinMatching(assetNames, ".prefab");
        row["skeletonLikeAssets"] = JoinSkeletonAssets(assetNames);

        foreach (var assetName in assetNames)
            AuditAsset(target, bundle, assetName, dependencyRows);

        var prefab = bundle.LoadAsset<GameObject>(target.prefabAsset);
        if (prefab == null)
        {
            foreach (var assetName in assetNames)
            {
                var lower = assetName.ToLowerInvariant();
                if (lower.EndsWith(".prefab") && lower.Contains("hero_"))
                {
                    prefab = bundle.LoadAsset<GameObject>(assetName);
                    row["prefabAsset"] = assetName;
                    break;
                }
            }
        }
        row["prefabLoaded"] = Bool(prefab != null);
        if (prefab == null)
        {
            row["status"] = "prefab_not_found_in_bundle";
            prefabRows.Add(row);
            return;
        }
        var instance = (GameObject)GameObject.Instantiate(prefab);
        instance.name = "BATTLE56_Audit_" + target.heroDid + "_model_" + target.modelId;
        try
        {
            FillInstanceAudit(row, instance);
            row["status"] = "live_assetbundle_prefab_has_source_backed_spine_mesh_material_data";
        }
        finally
        {
            GameObject.DestroyImmediate(instance);
        }
        prefabRows.Add(row);
    }

    private static void AuditAsset(ActorTarget target, AssetBundle bundle, string assetName, List<Dictionary<string, string>> rows)
    {
        var obj = bundle.LoadAsset<UnityEngine.Object>(assetName);
        var row = NewRow(DependencyHeaders());
        row["sourceKind"] = "actor_bundle_asset";
        row["side"] = target.side;
        row["heroDid"] = target.heroDid;
        row["modelId"] = target.modelId;
        row["bundle"] = target.bundle;
        row["assetName"] = assetName;
        row["assetType"] = obj != null ? obj.GetType().FullName : "";
        row["objectName"] = obj != null ? obj.name : "";
        row["status"] = obj != null ? "loaded" : "load_null";
        var mat = obj as Material;
        if (mat != null)
        {
            row["materialName"] = mat.name;
            row["shaderName"] = mat.shader != null ? mat.shader.name : "";
            row["shaderSupported"] = mat.shader != null ? Bool(mat.shader.isSupported) : "False";
            row["shaderPassCount"] = mat.shader != null ? mat.shader.passCount.ToString(CultureInfo.InvariantCulture) : "0";
            row["mainTextureName"] = mat.mainTexture != null ? mat.mainTexture.name : "";
            var tex = mat.mainTexture as Texture2D;
            row["mainTextureSize"] = tex != null ? tex.width + "x" + tex.height : "";
            row["renderQueue"] = mat.renderQueue.ToString(CultureInfo.InvariantCulture);
        }
        var tex2 = obj as Texture2D;
        if (tex2 != null)
        {
            row["textureName"] = tex2.name;
            row["textureSize"] = tex2.width + "x" + tex2.height;
        }
        var text = obj as TextAsset;
        if (text != null)
        {
            row["textAssetBytes"] = text.bytes != null ? text.bytes.Length.ToString(CultureInfo.InvariantCulture) : "0";
            row["textFirstLine"] = FirstLine(text.text);
        }
        rows.Add(row);
    }

    private static void FillInstanceAudit(Dictionary<string, string> row, GameObject instance)
    {
        int missing = 0;
        foreach (var c in instance.GetComponentsInChildren<Component>(true))
            if (c == null) missing++;
        row["missingScriptCount"] = missing.ToString(CultureInfo.InvariantCulture);
        row["componentTypes"] = ComponentTypes(instance);
        var renderers = instance.GetComponentsInChildren<Renderer>(true);
        row["rendererCount"] = renderers.Length.ToString(CultureInfo.InvariantCulture);
        int enabledRenderer = 0, materialSlots = 0, materialNull = 0, unsupportedShader = 0;
        var matNames = new List<string>();
        var shaderNames = new List<string>();
        foreach (var r in renderers)
        {
            if (r.enabled) enabledRenderer++;
            foreach (var mat in r.sharedMaterials)
            {
                materialSlots++;
                if (mat == null) { materialNull++; continue; }
                matNames.Add(mat.name);
                if (mat.shader != null)
                {
                    shaderNames.Add(mat.shader.name + "|supported=" + Bool(mat.shader.isSupported) + "|passes=" + mat.shader.passCount);
                    if (!mat.shader.isSupported || mat.shader.passCount == 0) unsupportedShader++;
                }
                else unsupportedShader++;
            }
        }
        row["enabledRendererCount"] = enabledRenderer.ToString(CultureInfo.InvariantCulture);
        row["materialSlotCount"] = materialSlots.ToString(CultureInfo.InvariantCulture);
        row["materialNullCount"] = materialNull.ToString(CultureInfo.InvariantCulture);
        row["unsupportedShaderMaterialCount"] = unsupportedShader.ToString(CultureInfo.InvariantCulture);
        row["rendererMaterialNames"] = string.Join("|", matNames.ToArray());
        row["rendererShaderNames"] = string.Join("|", shaderNames.ToArray());
        int meshFilters = 0, meshReady = 0, vertexCount = 0, triCount = 0;
        foreach (var mf in instance.GetComponentsInChildren<MeshFilter>(true))
        {
            meshFilters++;
            if (mf.sharedMesh != null)
            {
                meshReady++;
                vertexCount += mf.sharedMesh.vertexCount;
                triCount += mf.sharedMesh.triangles != null ? mf.sharedMesh.triangles.Length : 0;
            }
        }
        row["meshFilterCount"] = meshFilters.ToString(CultureInfo.InvariantCulture);
        row["meshFilterWithMeshCount"] = meshReady.ToString(CultureInfo.InvariantCulture);
        row["meshVertexCount"] = vertexCount.ToString(CultureInfo.InvariantCulture);
        row["meshTriangleIndexCount"] = triCount.ToString(CultureInfo.InvariantCulture);
        row["skinnedMeshRendererCount"] = instance.GetComponentsInChildren<SkinnedMeshRenderer>(true).Length.ToString(CultureInfo.InvariantCulture);
        row["spriteRendererCount"] = instance.GetComponentsInChildren<SpriteRenderer>(true).Length.ToString(CultureInfo.InvariantCulture);
        row["particleSystemCount"] = instance.GetComponentsInChildren<ParticleSystem>(true).Length.ToString(CultureInfo.InvariantCulture);
        row["animatorCount"] = instance.GetComponentsInChildren<Animator>(true).Length.ToString(CultureInfo.InvariantCulture);
        int skeletonAnimation = 0;
        int skeletonDataNonNull = 0;
        var skeletonNames = new List<string>();
        foreach (var c in instance.GetComponentsInChildren<Component>(true))
        {
            if (c == null) continue;
            var typeName = c.GetType().FullName ?? c.GetType().Name;
            if (typeName == "Spine.Unity.SkeletonAnimation")
            {
                skeletonAnimation++;
                var sda = ReadField(c, "skeletonDataAsset");
                if (sda != null)
                {
                    skeletonDataNonNull++;
                    skeletonNames.Add(ObjectName(sda));
                }
            }
        }
        row["skeletonAnimationComponentCount"] = skeletonAnimation.ToString(CultureInfo.InvariantCulture);
        row["skeletonDataAssetNonNullCount"] = skeletonDataNonNull.ToString(CultureInfo.InvariantCulture);
        row["skeletonDataAssetNames"] = string.Join("|", skeletonNames.ToArray());
        row["liveMeshReady"] = Bool(meshReady > 0 && vertexCount > 0);
    }

    private static Dictionary<string, string> InspectSceneActor(ActorTarget target)
    {
        var row = NewRow(SceneHeaders());
        FillTarget(row, target);
        row["sceneActorPath"] = target.sceneActorPath;
        var transform = FindTransform(target.sceneActorPath);
        row["found"] = Bool(transform != null);
        if (transform == null)
        {
            row["importGap"] = "scene_actor_missing";
            return row;
        }
        row["activeSelf"] = Bool(transform.gameObject.activeSelf);
        row["activeInHierarchy"] = Bool(transform.gameObject.activeInHierarchy);
        row["componentTypes"] = ComponentTypes(transform.gameObject);
        int missing = 0;
        foreach (var c in transform.GetComponentsInChildren<Component>(true))
            if (c == null) missing++;
        row["missingScriptCount"] = missing.ToString(CultureInfo.InvariantCulture);
        var renderers = transform.GetComponentsInChildren<Renderer>(true);
        row["rendererCount"] = renderers.Length.ToString(CultureInfo.InvariantCulture);
        int enabled = 0, matSlots = 0, nullMats = 0, missingShaders = 0;
        foreach (var r in renderers)
        {
            if (r.enabled) enabled++;
            foreach (var mat in r.sharedMaterials)
            {
                matSlots++;
                if (mat == null) { nullMats++; missingShaders++; }
                else if (mat.shader == null || !mat.shader.isSupported || mat.shader.passCount == 0) missingShaders++;
            }
        }
        row["enabledRendererCount"] = enabled.ToString(CultureInfo.InvariantCulture);
        row["materialSlotCount"] = matSlots.ToString(CultureInfo.InvariantCulture);
        row["materialNullCount"] = nullMats.ToString(CultureInfo.InvariantCulture);
        row["missingShaderOrMaterialCount"] = missingShaders.ToString(CultureInfo.InvariantCulture);
        int meshFilters = 0, meshReady = 0, vertices = 0;
        foreach (var mf in transform.GetComponentsInChildren<MeshFilter>(true))
        {
            meshFilters++;
            if (mf.sharedMesh != null)
            {
                meshReady++;
                vertices += mf.sharedMesh.vertexCount;
            }
        }
        row["meshFilterCount"] = meshFilters.ToString(CultureInfo.InvariantCulture);
        row["meshFilterWithMeshCount"] = meshReady.ToString(CultureInfo.InvariantCulture);
        row["meshVertexCount"] = vertices.ToString(CultureInfo.InvariantCulture);
        row["sceneMeshReady"] = Bool(meshReady > 0 && vertices > 0);
        row["sceneMaterialReady"] = Bool(matSlots > 0 && nullMats == 0 && missingShaders == 0);
        row["boundsSize"] = CombinedBoundsSize(transform.gameObject);
        row["importGap"] = row["sceneMeshReady"] == "True" && row["sceneMaterialReady"] == "True"
            ? "scene_actor_render_refs_ready"
            : "assetbundle_runtime_references_not_persisted_in_saved_scene";
        row["patchDecision"] = "blocked_no_patch_requires_project_asset_import_or_scene_builder_reinstantiate_runtime_prefab";
        return row;
    }

    private static string CombinedBoundsSize(GameObject go)
    {
        bool has = false;
        Bounds b = new Bounds(Vector3.zero, Vector3.zero);
        foreach (var r in go.GetComponentsInChildren<Renderer>(true))
        {
            if (!r.enabled) continue;
            if (!has) { b = r.bounds; has = true; }
            else b.Encapsulate(r.bounds);
        }
        return has ? Vec(b.size) : "";
    }

    private static Transform FindTransform(string path)
    {
        foreach (var t in UnityEngine.Object.FindObjectsOfType<Transform>(true))
            if (HierarchyPath(t) == path) return t;
        return null;
    }

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

    private static string ObjectName(object obj)
    {
        var o = obj as UnityEngine.Object;
        return o != null ? o.name : "";
    }

    private static string ComponentTypes(GameObject go)
    {
        var names = new List<string>();
        foreach (var c in go.GetComponentsInChildren<Component>(true))
            names.Add(c == null ? "<missing>" : c.GetType().FullName);
        return string.Join("|", names.ToArray());
    }

    private static void FillTarget(Dictionary<string, string> row, ActorTarget target)
    {
        row["side"] = target.side;
        row["heroDid"] = target.heroDid;
        row["modelId"] = target.modelId;
        row["bundle"] = target.bundle;
        row["prefabAsset"] = target.prefabAsset;
    }

    private static string JoinMatching(string[] names, string suffix)
    {
        var hits = new List<string>();
        foreach (var name in names)
            if (name.ToLowerInvariant().EndsWith(suffix)) hits.Add(name);
        return string.Join("|", hits.ToArray());
    }

    private static string JoinSkeletonAssets(string[] names)
    {
        var hits = new List<string>();
        foreach (var name in names)
        {
            var lower = name.ToLowerInvariant();
            if (lower.Contains("skeleton") || lower.EndsWith(".skel.bytes") || lower.EndsWith(".atlas.txt") || lower.Contains("_atlas.asset"))
                hits.Add(name);
        }
        return string.Join("|", hits.ToArray());
    }

    private static string ToProjectAssetPath(string assetName)
    {
        if (string.IsNullOrEmpty(assetName)) return "";
        return assetName.StartsWith("assets/", StringComparison.OrdinalIgnoreCase)
            ? "Assets/" + assetName.Substring("assets/".Length)
            : assetName;
    }

    private static string FirstLine(string text)
    {
        if (string.IsNullOrEmpty(text)) return "";
        using (var sr = new StringReader(text))
            return sr.ReadLine() ?? "";
    }

    private static int CountTrue(List<Dictionary<string, string>> rows, string key) { return CountRows(rows, key, "True"); }
    private static int CountRows(List<Dictionary<string, string>> rows, string key, string value)
    {
        int n = 0;
        foreach (var r in rows)
            if (Get(r, key) == value) n++;
        return n;
    }
    private static int CountGreater(List<Dictionary<string, string>> rows, string key, int value)
    {
        int n = 0;
        foreach (var r in rows)
        {
            int parsed;
            if (int.TryParse(Get(r, key), out parsed) && parsed > value) n++;
        }
        return n;
    }

    private static string Get(Dictionary<string, string> row, string key) { return row.ContainsKey(key) ? row[key] : ""; }
    private static string Bool(bool value) { return value ? "True" : "False"; }
    private static string Vec(Vector3 v) { return v.x.ToString(CultureInfo.InvariantCulture) + "/" + v.y.ToString(CultureInfo.InvariantCulture) + "/" + v.z.ToString(CultureInfo.InvariantCulture); }
    private static string ProjectPath(string assetPath) { return Path.Combine(Application.dataPath, "..", assetPath.Replace("/", "\\")); }

    private static Dictionary<string, string> NewRow(string[] headers)
    {
        var row = new Dictionary<string, string>();
        foreach (var h in headers) row[h] = "";
        return row;
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
                sb.Append(Csv(Get(row, headers[i])));
            }
            sb.AppendLine();
        }
        File.WriteAllText(path, sb.ToString(), new UTF8Encoding(true));
    }

    private static string Csv(string value)
    {
        value = value ?? "";
        if (value.IndexOfAny(new[] { ',', '"', '\n', '\r' }) >= 0)
            return "\"" + value.Replace("\"", "\"\"") + "\"";
        return value;
    }

    private static void WriteSummary(string path, Summary s)
    {
        Directory.CreateDirectory(Path.GetDirectoryName(path));
        var json = "{\n"
            + Json("prefix", s.prefix) + ",\n"
            + Json("scene", s.scene) + ",\n"
            + Json("sceneOpened", s.sceneOpened) + ",\n"
            + Json("isFinalRestoredBattleScreen", s.isFinalRestoredBattleScreen) + ",\n"
            + Json("patchDecision", s.patchDecision) + ",\n"
            + Json("prefabRows", s.prefabRows) + ",\n"
            + Json("dependencyRows", s.dependencyRows) + ",\n"
            + Json("sceneRows", s.sceneRows) + ",\n"
            + Json("livePrefabMeshReadyRows", s.livePrefabMeshReadyRows) + ",\n"
            + Json("livePrefabSkeletonRows", s.livePrefabSkeletonRows) + ",\n"
            + Json("sceneMeshReadyRows", s.sceneMeshReadyRows) + ",\n"
            + Json("sceneMaterialReadyRows", s.sceneMaterialReadyRows) + ",\n"
            + Json("importGapRows", s.importGapRows) + ",\n"
            + Json("sourceBackedPatchAvailable", s.sourceBackedPatchAvailable) + ",\n"
            + Json("nextBlocker", s.nextBlocker) + ",\n"
            + Json("failReason", s.failReason) + "\n"
            + "}\n";
        File.WriteAllText(path, json, Encoding.UTF8);
    }

    private static string Json(string key, string value) { return "  \"" + key + "\": \"" + (value ?? "").Replace("\\", "\\\\").Replace("\"", "\\\"") + "\""; }
    private static string Json(string key, bool value) { return "  \"" + key + "\": " + (value ? "true" : "false"); }
    private static string Json(string key, int value) { return "  \"" + key + "\": " + value.ToString(CultureInfo.InvariantCulture); }

    private static string[] PrefabHeaders()
    {
        return new[] { "side", "heroDid", "modelId", "bundle", "absoluteBundlePath", "bundleFileExists", "bundleLoaded", "assetNameCount", "prefabAsset", "prefabAssetNames", "prefabLoaded", "assetDatabasePrefabExists", "skeletonLikeAssets", "componentTypes", "missingScriptCount", "rendererCount", "enabledRendererCount", "meshFilterCount", "meshFilterWithMeshCount", "meshVertexCount", "meshTriangleIndexCount", "skinnedMeshRendererCount", "spriteRendererCount", "particleSystemCount", "animatorCount", "materialSlotCount", "materialNullCount", "unsupportedShaderMaterialCount", "rendererMaterialNames", "rendererShaderNames", "skeletonAnimationComponentCount", "skeletonDataAssetNonNullCount", "skeletonDataAssetNames", "liveMeshReady", "status" };
    }

    private static string[] DependencyHeaders()
    {
        return new[] { "sourceKind", "side", "heroDid", "modelId", "bundle", "absolutePath", "fileExists", "bundleLoaded", "assetCount", "assetName", "assetType", "objectName", "materialName", "shaderName", "shaderSupported", "shaderPassCount", "mainTextureName", "mainTextureSize", "renderQueue", "textureName", "textureSize", "textAssetBytes", "textFirstLine", "status" };
    }

    private static string[] SceneHeaders()
    {
        return new[] { "side", "heroDid", "modelId", "bundle", "prefabAsset", "sceneActorPath", "found", "activeSelf", "activeInHierarchy", "componentTypes", "missingScriptCount", "rendererCount", "enabledRendererCount", "meshFilterCount", "meshFilterWithMeshCount", "meshVertexCount", "materialSlotCount", "materialNullCount", "missingShaderOrMaterialCount", "boundsSize", "sceneMeshReady", "sceneMaterialReady", "importGap", "patchDecision" };
    }

    private class ActorTarget
    {
        public string side;
        public string heroDid;
        public string modelId;
        public string bundle;
        public string prefabAsset;
        public string sceneActorPath;
        public ActorTarget(string side, string heroDid, string modelId, string bundle, string prefabAsset, string sceneActorPath)
        {
            this.side = side;
            this.heroDid = heroDid;
            this.modelId = modelId;
            this.bundle = bundle;
            this.prefabAsset = prefabAsset;
            this.sceneActorPath = sceneActorPath;
        }
    }

    [Serializable]
    private class Summary
    {
        public string prefix;
        public string scene;
        public bool sceneOpened;
        public bool isFinalRestoredBattleScreen;
        public string patchDecision;
        public int prefabRows;
        public int dependencyRows;
        public int sceneRows;
        public int livePrefabMeshReadyRows;
        public int livePrefabSkeletonRows;
        public int sceneMeshReadyRows;
        public int sceneMaterialReadyRows;
        public int importGapRows;
        public bool sourceBackedPatchAvailable;
        public string nextBlocker;
        public string failReason;
    }
}
