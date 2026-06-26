using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.Playables;

public static class Battle62LocalSubsetSourceBackedSkillActivationProbeEditor
{
    private const string Prefix = "BATTLE_62_LOCAL_SUBSET_SOURCE_BACKED_SKILL_ACTIVATION_PROBE_NO_XLUA_NO_ORIGINAL_HANDLER_CLAIM";
    private const string BaseDir = @"C:\Users\godho\Downloads\girlswar";
    private const string ScenePath = "Assets/Scenes/Battle57RuntimeRehydratedAssetBundleActorsCandidate.unity";
    private const int CaptureWidth = 960;
    private const int CaptureHeight = 540;
    private static readonly string ManifestCsv = Path.Combine(BaseDir, @"reports\battle\BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST_SPEEDLINE_RESOLVED.csv");
    private static readonly string CleanSliceRoot = Path.Combine(BaseDir, @"girlswar_merged_extracted\extracted\unity\clean_unityfs_slices");
    private static readonly string RestoreDataDir = Path.Combine(BaseDir, @"girlswar_battle_unity\Assets\RestoreData\battle");
    private static readonly string CaptureDir = Path.Combine(BaseDir, @"girlswar_battle_unity\Assets\RestoreCaptures\battle_actor\BATTLE62");
    private static readonly string OutSkillCsv = Path.Combine(RestoreDataDir, Prefix + "_SKILL_ACTIVATION_PROBE_MATRIX.csv");
    private static readonly string OutActorCsv = Path.Combine(RestoreDataDir, Prefix + "_ACTOR_TARGET_ANCHOR_CONTEXT.csv");
    private static readonly string OutBlockerCsv = Path.Combine(RestoreDataDir, Prefix + "_DEPENDENCY_RUNTIME_COMPONENT_BLOCKERS.csv");
    private static readonly string OutClassCsv = Path.Combine(RestoreDataDir, Prefix + "_CANDIDATE_CLASSIFICATION_NEXT_ACTION.csv");
    private static readonly string OutSummaryJson = Path.Combine(RestoreDataDir, Prefix + "_UNITY_SUMMARY.json");

    public static void Build()
    {
        Directory.CreateDirectory(RestoreDataDir);
        Directory.CreateDirectory(CaptureDir);
        EditorSceneManager.OpenScene(ScenePath, OpenSceneMode.Single);

        var camera = FindCaptureCamera();
        ConfigureCameraForCapture(camera);
        var actors = FindActors(camera);
        var actorRows = BuildActorRows(actors, camera);
        var openedBundles = new List<AssetBundle>();
        var bundles = new Dictionary<string, AssetBundle>(StringComparer.OrdinalIgnoreCase);
        LoadBundle("download/commonprefabsandres/skilleffect/commonskillprefabsandres1.assetbundle", bundles, openedBundles);

        var rows = ReadCsv(ManifestCsv)
            .Where(r => Get(r, "rowType") == "skill")
            .Where(r => Get(r, "localStatus") == "loadable")
            .Where(r => IsMinimalSubsetOwner(Get(r, "ownerHeroDid")))
            .Where(r => !string.IsNullOrWhiteSpace(Get(r, "prefabId")))
            .ToList();

        var root = new GameObject("BATTLE62_SourceBackedSkillActivationProbe_DIAGNOSTIC_ONLY");
        var baseline = Capture(camera);
        var skillRows = new List<Dictionary<string, string>>();
        var blockerRows = new List<Dictionary<string, string>>();
        var classRows = new List<Dictionary<string, string>>();
        var visualCapturePaths = new List<string>();

        foreach (var row in rows)
        {
            var skill = ProbeSkill(row, actors, camera, baseline, root.transform, bundles, openedBundles, visualCapturePaths);
            skillRows.Add(skill.Row);
            blockerRows.Add(skill.BlockerRow);
            classRows.Add(skill.ClassificationRow);
        }

        UnityEngine.Object.DestroyImmediate(root);
        foreach (var bundle in openedBundles)
        {
            if (bundle != null) bundle.Unload(false);
        }

        WriteCsv(OutSkillCsv, skillRows, SkillHeaders());
        WriteCsv(OutActorCsv, actorRows, ActorHeaders());
        WriteCsv(OutBlockerCsv, blockerRows, BlockerHeaders());
        WriteCsv(OutClassCsv, classRows, ClassificationHeaders());

        var loaded = skillRows.Count(r => r["assetLoadSuccess"] == "True");
        var instantiated = skillRows.Count(r => r["instantiateSuccess"] == "True");
        var visual = skillRows.Count(r => r["visualSignalObserved"] == "True");
        var actorsVisible = actorRows.Count(r => r["visibleForProbe"] == "True");
        var feasible = loaded == rows.Count && instantiated == rows.Count;
        WriteSummary(rows.Count, loaded, instantiated, visual, actorsVisible, visualCapturePaths, feasible);

        AssetDatabase.Refresh();
        Debug.Log(Prefix + " complete rows=" + rows.Count + " loaded=" + loaded + " instantiated=" + instantiated + " visual=" + visual);
    }

    private static SkillProbeResult ProbeSkill(
        Dictionary<string, string> manifestRow,
        Dictionary<string, ActorContext> actors,
        Camera camera,
        Texture2D baseline,
        Transform root,
        Dictionary<string, AssetBundle> bundles,
        List<AssetBundle> openedBundles,
        List<string> visualCapturePaths)
    {
        var side = Get(manifestRow, "side");
        var owner = Get(manifestRow, "ownerHeroDid");
        var prefabId = Get(manifestRow, "prefabId");
        var skillDid = Get(manifestRow, "skillDid");
        var skillBundle = NormalizeBundle(Get(manifestRow, "bundle"));
        var bundlePath = ResolveBundlePath(skillBundle);
        var bundleExists = File.Exists(bundlePath);
        var bundleLoadSuccess = false;
        var assetLoadSuccess = false;
        var instantiateSuccess = false;
        var loadError = "";
        var allAssetNames = Array.Empty<string>();
        var matchedAsset = "";
        GameObject instance = null;
        GameObject prefab = null;
        AssetBundle bundle = null;

        try
        {
            if (bundleExists)
            {
                bundle = LoadBundle(skillBundle, bundles, openedBundles);
                bundleLoadSuccess = bundle != null;
                if (bundle != null)
                {
                    allAssetNames = bundle.GetAllAssetNames();
                    matchedAsset = MatchAssetName(allAssetNames, NormalizeAssetPath(Get(manifestRow, "assetPathViaGetSysprefabData")), prefabId);
                    if (!string.IsNullOrEmpty(matchedAsset))
                    {
                        prefab = bundle.LoadAsset<GameObject>(matchedAsset);
                        assetLoadSuccess = prefab != null;
                    }
                }
            }
            var caster = ResolveCaster(owner, actors);
            var target = ResolveTarget(owner, actors);
            if (prefab != null && caster != null)
            {
                var position = SkillProbePosition(caster, target);
                instance = UnityEngine.Object.Instantiate(prefab, position, Quaternion.identity, root);
                instance.name = "BATTLE62_SourceBackedSkill_" + owner + "_" + prefabId;
                instance.SetActive(true);
                instantiateSuccess = true;
                EvaluateRuntimeComponents(instance);
            }
        }
        catch (Exception ex)
        {
            loadError = ex.GetType().Name + ": " + ex.Message;
        }

        var targetObject = instance != null ? instance : prefab;
        var analysis = AnalyzeObject(targetObject);
        var director = targetObject != null ? targetObject.GetComponentInChildren<PlayableDirector>(true) : null;
        var directorAsset = director != null ? director.playableAsset : null;
        var outputCount = directorAsset != null ? directorAsset.outputs.Count() : 0;
        var after = Capture(camera);
        var diff = CountDiffPixels(baseline, after);
        var visualSignal = diff > 80 || analysis.HasRendererSignal;
        var capturePath = "";
        if (visualSignal)
        {
            capturePath = Path.Combine(CaptureDir, "BATTLE62_skill_" + owner + "_" + prefabId + ".png");
            File.WriteAllBytes(capturePath, after.EncodeToPNG());
            visualCapturePaths.Add(ProjectRelative(capturePath));
        }
        UnityEngine.Object.DestroyImmediate(after);

        var casterContext = ResolveCaster(owner, actors);
        var targetContext = ResolveTarget(owner, actors);
        var classification = Classify(bundleLoadSuccess, assetLoadSuccess, instantiateSuccess, visualSignal, director, outputCount, analysis);
        var row = NewRow(SkillHeaders());
        row["side"] = side;
        row["waveNo"] = Get(manifestRow, "waveNo");
        row["ownerHeroDid"] = owner;
        row["skillDid"] = skillDid;
        row["prefabField"] = Get(manifestRow, "prefabField");
        row["prefabId"] = prefabId;
        row["skillBundle"] = skillBundle;
        row["resolvedBundlePath"] = bundlePath;
        row["bundleExists"] = Bool(bundleExists);
        row["bundleLoadSuccess"] = Bool(bundleLoadSuccess);
        row["assetPathViaGetSysprefabData"] = Get(manifestRow, "assetPathViaGetSysprefabData");
        row["matchedAssetName"] = matchedAsset;
        row["assetLoadSuccess"] = Bool(assetLoadSuccess);
        row["instantiateSuccess"] = Bool(instantiateSuccess);
        row["casterActor"] = casterContext != null ? casterContext.Name : "";
        row["targetActor"] = targetContext != null ? targetContext.Name : "";
        row["probePosition"] = instance != null ? Vec(instance.transform.position) : "";
        row["componentCount"] = analysis.ComponentCount.ToString();
        row["missingScriptCount"] = analysis.MissingScriptCount.ToString();
        row["componentTypes"] = analysis.ComponentTypes;
        row["rendererCount"] = analysis.RendererCount.ToString();
        row["enabledRendererCount"] = analysis.EnabledRendererCount.ToString();
        row["particleSystemCount"] = analysis.ParticleSystemCount.ToString();
        row["animatorCount"] = analysis.AnimatorCount.ToString();
        row["audioSourceCount"] = analysis.AudioSourceCount.ToString();
        row["playableDirectorCount"] = analysis.PlayableDirectorCount.ToString();
        row["playableAssetName"] = directorAsset != null ? directorAsset.name : "";
        row["playableOutputCount"] = outputCount.ToString();
        row["timelineEvaluateAttempted"] = Bool(director != null);
        row["boundsSize"] = analysis.BoundsSize;
        row["hasNonZeroBounds"] = Bool(analysis.HasNonZeroBounds);
        row["pixelDiffAgainstBaseline"] = diff.ToString(CultureInfo.InvariantCulture);
        row["visualSignalObserved"] = Bool(visualSignal);
        row["diagnosticCapture"] = capturePath;
        row["classification"] = classification;
        row["loadError"] = loadError;

        var blocker = NewRow(BlockerHeaders());
        blocker["skillDid"] = skillDid;
        blocker["prefabId"] = prefabId;
        blocker["blockerType"] = BlockerType(classification);
        blocker["evidence"] = "director=" + Bool(director != null) + "; outputs=" + outputCount + "; renderers=" + analysis.RendererCount + "; pixelDiff=" + diff;
        blocker["nextAction"] = NextAction(classification);

        var classRow = NewRow(ClassificationHeaders());
        classRow["skillDid"] = skillDid;
        classRow["prefabId"] = prefabId;
        classRow["classification"] = classification;
        classRow["sourceBackedSkillActivationProbe"] = "True";
        classRow["originalHandlerBindingClaim"] = "False";
        classRow["xLuaRuntimeUsed"] = "False";
        classRow["sceneSaved"] = "False";
        classRow["nextAction"] = NextAction(classification);

        if (instance != null) UnityEngine.Object.DestroyImmediate(instance);
        return new SkillProbeResult { Row = row, BlockerRow = blocker, ClassificationRow = classRow };
    }

    private static void EvaluateRuntimeComponents(GameObject instance)
    {
        foreach (var director in instance.GetComponentsInChildren<PlayableDirector>(true))
        {
            try
            {
                director.timeUpdateMode = DirectorUpdateMode.Manual;
                director.initialTime = 0;
                director.time = 0;
                director.Evaluate();
                director.time = 0.25;
                director.Evaluate();
                director.time = 0.5;
                director.Evaluate();
                director.time = 1.0;
                director.Evaluate();
            }
            catch { }
        }
        foreach (var ps in instance.GetComponentsInChildren<ParticleSystem>(true))
        {
            try
            {
                ps.gameObject.SetActive(true);
                ps.Play(true);
                ps.Simulate(1.0f, true, false, true);
            }
            catch { }
        }
        foreach (var animator in instance.GetComponentsInChildren<Animator>(true))
        {
            try { animator.Update(0.5f); } catch { }
        }
        Canvas.ForceUpdateCanvases();
    }

    private static Dictionary<string, ActorContext> FindActors(Camera camera)
    {
        var map = new Dictionary<string, ActorContext>();
        AddActor(map, "1002", "BATTLE57_SourceBackedActor_our_w0_s2_1002_model_1002", camera);
        AddActor(map, "1034", "BATTLE57_SourceBackedActor_our_w0_s3_1034_model_1034", camera);
        AddActor(map, "1100111", "BATTLE57_SourceBackedActor_enemy_w1_s1_1100111_model_3001", camera);
        AddActor(map, "3001", "BATTLE57_SourceBackedActor_enemy_w1_s1_1100111_model_3001", camera);
        return map;
    }

    private static void AddActor(Dictionary<string, ActorContext> map, string key, string name, Camera camera)
    {
        var go = GameObject.Find(name);
        var ctx = new ActorContext { Key = key, Name = name, GameObject = go };
        if (go != null)
        {
            var renderers = go.GetComponentsInChildren<Renderer>(true);
            ctx.RendererCount = renderers.Length;
            ctx.EnabledRendererCount = renderers.Count(r => r != null && r.enabled && r.gameObject.activeInHierarchy);
            ctx.Bounds = CombinedBounds(renderers);
            ctx.BoundsSize = ctx.Bounds.HasValue ? Vec(ctx.Bounds.Value.size) : "0/0/0";
            ctx.VisibleForProbe = go.activeInHierarchy && ctx.EnabledRendererCount > 0 && ctx.Bounds.HasValue && camera != null && GeometryUtility.TestPlanesAABB(GeometryUtility.CalculateFrustumPlanes(camera), ctx.Bounds.Value);
            ctx.Anchor = ctx.Bounds.HasValue ? ctx.Bounds.Value.center : go.transform.position;
        }
        map[key] = ctx;
    }

    private static List<Dictionary<string, string>> BuildActorRows(Dictionary<string, ActorContext> actors, Camera camera)
    {
        var rows = new List<Dictionary<string, string>>();
        foreach (var key in new[] { "1002", "1034", "1100111" })
        {
            var actor = actors.ContainsKey(key) ? actors[key] : null;
            var row = NewRow(ActorHeaders());
            row["actorKey"] = key;
            row["actorObjectName"] = actor != null ? actor.Name : "";
            row["exists"] = Bool(actor != null && actor.GameObject != null);
            row["activeInHierarchy"] = Bool(actor != null && actor.GameObject != null && actor.GameObject.activeInHierarchy);
            row["rendererCount"] = actor != null ? actor.RendererCount.ToString() : "0";
            row["enabledRendererCount"] = actor != null ? actor.EnabledRendererCount.ToString() : "0";
            row["boundsSize"] = actor != null ? actor.BoundsSize : "0/0/0";
            row["anchorPosition"] = actor != null ? Vec(actor.Anchor) : "";
            row["visibleForProbe"] = Bool(actor != null && actor.VisibleForProbe);
            row["cameraName"] = camera != null ? camera.name : "";
            row["cameraPixelRect"] = camera != null ? RectString(camera.pixelRect) : "";
            rows.Add(row);
        }
        return rows;
    }

    private static ActorContext ResolveCaster(string owner, Dictionary<string, ActorContext> actors)
    {
        if (actors.ContainsKey(owner)) return actors[owner];
        return null;
    }

    private static ActorContext ResolveTarget(string owner, Dictionary<string, ActorContext> actors)
    {
        if (owner == "1100111") return actors.ContainsKey("1002") ? actors["1002"] : null;
        return actors.ContainsKey("1100111") ? actors["1100111"] : null;
    }

    private static Vector3 SkillProbePosition(ActorContext caster, ActorContext target)
    {
        if (caster == null) return Vector3.zero;
        if (target == null) return caster.Anchor + new Vector3(0, 0.5f, -0.05f);
        return Vector3.Lerp(caster.Anchor, target.Anchor, 0.45f) + new Vector3(0, 0.3f, -0.05f);
    }

    private static ProbeAnalysis AnalyzeObject(GameObject target)
    {
        var result = new ProbeAnalysis();
        if (target == null) return result;
        var components = target.GetComponentsInChildren<Component>(true);
        result.ComponentCount = components.Length;
        result.MissingScriptCount = components.Count(c => c == null);
        result.ComponentTypes = string.Join("|", components.Where(c => c != null).GroupBy(c => c.GetType().Name).OrderBy(g => g.Key).Select(g => g.Key + ":" + g.Count()));
        result.ParticleSystemCount = components.Count(c => c is ParticleSystem);
        result.AnimatorCount = components.Count(c => c is Animator);
        result.AudioSourceCount = components.Count(c => c is AudioSource);
        result.PlayableDirectorCount = components.Count(c => c is PlayableDirector);
        var renderers = target.GetComponentsInChildren<Renderer>(true);
        result.RendererCount = renderers.Length;
        result.EnabledRendererCount = renderers.Count(r => r != null && r.enabled && r.gameObject.activeInHierarchy);
        var bounds = CombinedBounds(renderers);
        result.BoundsSize = bounds.HasValue ? Vec(bounds.Value.size) : "0/0/0";
        result.HasNonZeroBounds = bounds.HasValue && bounds.Value.size.sqrMagnitude > 0.0001f;
        result.HasRendererSignal = result.EnabledRendererCount > 0 && result.HasNonZeroBounds;
        return result;
    }

    private static string Classify(bool bundleLoaded, bool assetLoaded, bool instantiated, bool visualSignal, PlayableDirector director, int outputCount, ProbeAnalysis analysis)
    {
        if (!bundleLoaded || !assetLoaded || !instantiated) return "blocked_by_missing_runtime_component_or_dependency";
        if (visualSignal) return "skill_asset_activation_feasible";
        if (director != null && outputCount > 0) return "blocked_by_original_battle_manager_required";
        return "skill_asset_load_only_no_visual_signal";
    }

    private static string BlockerType(string classification)
    {
        if (classification == "skill_asset_activation_feasible") return "none_probe_feasible";
        return classification;
    }

    private static string NextAction(string classification)
    {
        if (classification == "skill_asset_activation_feasible") return "Keep as diagnostic-only source-backed skill activation evidence; original handler blocker remains.";
        if (classification == "blocked_by_original_battle_manager_required") return "Trace PlayableDirector bindings/original battle manager runtime objects before claiming activation.";
        if (classification == "blocked_by_missing_runtime_component_or_dependency") return "Resolve source-backed missing component/dependency; do not substitute fake effects.";
        return "Load succeeds but no visual signal in diagnostic camera; treat as asset load evidence only.";
    }

    private static AssetBundle LoadBundle(string bundle, Dictionary<string, AssetBundle> bundles, List<AssetBundle> opened)
    {
        var path = ResolveBundlePath(bundle);
        if (bundles.TryGetValue(path, out var existing)) return existing;
        if (!File.Exists(path)) { bundles[path] = null; return null; }
        var loaded = AssetBundle.LoadFromFile(path);
        bundles[path] = loaded;
        if (loaded != null) opened.Add(loaded);
        return loaded;
    }

    private static string ResolveBundlePath(string bundle)
    {
        return Path.Combine(CleanSliceRoot, bundle.Replace('/', Path.DirectorySeparatorChar).Replace('\\', Path.DirectorySeparatorChar));
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

    private static Texture2D Capture(Camera camera)
    {
        var rt = new RenderTexture(CaptureWidth, CaptureHeight, 24, RenderTextureFormat.ARGB32);
        var oldTarget = camera.targetTexture;
        var oldActive = RenderTexture.active;
        camera.targetTexture = rt;
        RenderTexture.active = rt;
        camera.Render();
        var tex = new Texture2D(CaptureWidth, CaptureHeight, TextureFormat.RGBA32, false);
        tex.ReadPixels(new Rect(0, 0, CaptureWidth, CaptureHeight), 0, 0);
        tex.Apply();
        camera.targetTexture = oldTarget;
        RenderTexture.active = oldActive;
        UnityEngine.Object.DestroyImmediate(rt);
        return tex;
    }

    private static int CountDiffPixels(Texture2D a, Texture2D b)
    {
        if (a == null || b == null || a.width != b.width || a.height != b.height) return 0;
        var pa = a.GetPixels32();
        var pb = b.GetPixels32();
        var changed = 0;
        for (var i = 0; i < pa.Length; i += 4)
        {
            var d = Math.Abs(pa[i].r - pb[i].r) + Math.Abs(pa[i].g - pb[i].g) + Math.Abs(pa[i].b - pb[i].b) + Math.Abs(pa[i].a - pb[i].a);
            if (d > 24) changed++;
        }
        return changed;
    }

    private static Bounds? CombinedBounds(Renderer[] renderers)
    {
        Bounds? bounds = null;
        foreach (var r in renderers)
        {
            if (r == null) continue;
            if (!bounds.HasValue) bounds = r.bounds;
            else
            {
                var b = bounds.Value;
                b.Encapsulate(r.bounds);
                bounds = b;
            }
        }
        return bounds;
    }

    private static string MatchAssetName(string[] assetNames, string expected, string prefabId)
    {
        foreach (var name in assetNames) if (NormalizeAssetPath(name) == expected) return name;
        foreach (var name in assetNames)
        {
            var lower = NormalizeAssetPath(name);
            if (!string.IsNullOrEmpty(prefabId) && lower.EndsWith("/" + prefabId + ".prefab", StringComparison.OrdinalIgnoreCase)) return name;
        }
        foreach (var name in assetNames) if (!string.IsNullOrEmpty(prefabId) && NormalizeAssetPath(name).Contains(prefabId.ToLowerInvariant())) return name;
        return "";
    }

    private static List<Dictionary<string, string>> ReadCsv(string path)
    {
        var rows = new List<Dictionary<string, string>>();
        if (!File.Exists(path)) return rows;
        var lines = File.ReadAllLines(path, new UTF8Encoding(false));
        if (lines.Length == 0) return rows;
        var headers = SplitCsvLine(lines[0]);
        for (var i = 1; i < lines.Length; i++)
        {
            if (string.IsNullOrWhiteSpace(lines[i])) continue;
            var values = SplitCsvLine(lines[i]);
            var row = new Dictionary<string, string>();
            for (var h = 0; h < headers.Count; h++) row[headers[h]] = h < values.Count ? values[h] : "";
            rows.Add(row);
        }
        return rows;
    }

    private static List<string> SplitCsvLine(string line)
    {
        var values = new List<string>();
        var sb = new StringBuilder();
        var inQuotes = false;
        for (var i = 0; i < line.Length; i++)
        {
            var c = line[i];
            if (c == '"')
            {
                if (inQuotes && i + 1 < line.Length && line[i + 1] == '"') { sb.Append('"'); i++; }
                else inQuotes = !inQuotes;
            }
            else if (c == ',' && !inQuotes) { values.Add(sb.ToString()); sb.Length = 0; }
            else sb.Append(c);
        }
        values.Add(sb.ToString());
        return values;
    }

    private static void WriteCsv(string path, List<Dictionary<string, string>> rows, string[] headers)
    {
        var sb = new StringBuilder();
        sb.AppendLine(string.Join(",", headers.Select(Escape)));
        foreach (var row in rows) sb.AppendLine(string.Join(",", headers.Select(h => Escape(row.ContainsKey(h) ? row[h] : ""))));
        File.WriteAllText(path, sb.ToString(), new UTF8Encoding(false));
    }

    private static string[] SkillHeaders()
    {
        return new[] { "side", "waveNo", "ownerHeroDid", "skillDid", "prefabField", "prefabId", "skillBundle", "resolvedBundlePath", "bundleExists", "bundleLoadSuccess", "assetPathViaGetSysprefabData", "matchedAssetName", "assetLoadSuccess", "instantiateSuccess", "casterActor", "targetActor", "probePosition", "componentCount", "missingScriptCount", "componentTypes", "rendererCount", "enabledRendererCount", "particleSystemCount", "animatorCount", "audioSourceCount", "playableDirectorCount", "playableAssetName", "playableOutputCount", "timelineEvaluateAttempted", "boundsSize", "hasNonZeroBounds", "pixelDiffAgainstBaseline", "visualSignalObserved", "diagnosticCapture", "classification", "loadError" };
    }

    private static string[] ActorHeaders()
    {
        return new[] { "actorKey", "actorObjectName", "exists", "activeInHierarchy", "rendererCount", "enabledRendererCount", "boundsSize", "anchorPosition", "visibleForProbe", "cameraName", "cameraPixelRect" };
    }

    private static string[] BlockerHeaders()
    {
        return new[] { "skillDid", "prefabId", "blockerType", "evidence", "nextAction" };
    }

    private static string[] ClassificationHeaders()
    {
        return new[] { "skillDid", "prefabId", "classification", "sourceBackedSkillActivationProbe", "originalHandlerBindingClaim", "xLuaRuntimeUsed", "sceneSaved", "nextAction" };
    }

    private static Dictionary<string, string> NewRow(string[] headers)
    {
        var row = new Dictionary<string, string>();
        foreach (var h in headers) row[h] = "";
        return row;
    }

    private static void WriteSummary(int checkedRows, int loaded, int instantiated, int visual, int actorsVisible, List<string> captures, bool feasible)
    {
        var sb = new StringBuilder();
        sb.AppendLine("{");
        Json(sb, "prefix", Prefix, true);
        Json(sb, "restoredClaim", false, true);
        Json(sb, "playableClaim", false, true);
        Json(sb, "originalHandlerBindingClaim", false, true);
        Json(sb, "sceneSaved", false, true);
        Json(sb, "xLuaRuntimeUsed", false, true);
        Json(sb, "sourceBackedSkillRowsChecked", checkedRows, true);
        Json(sb, "skillPrefabsLoaded", loaded, true);
        Json(sb, "skillPrefabsInstantiated", instantiated, true);
        Json(sb, "skillRowsWithVisualSignal", visual, true);
        Json(sb, "actorsVisibleDuringProbe", actorsVisible, true);
        Json(sb, "diagnosticCaptureProduced", captures.Count > 0, true);
        Json(sb, "diagnosticCaptureCount", captures.Count, true);
        Json(sb, "sourceBackedSkillActivationProbeFeasible", feasible, true);
        Json(sb, "capturePaths", string.Join("|", captures), false);
        sb.AppendLine("}");
        File.WriteAllText(OutSummaryJson, sb.ToString(), new UTF8Encoding(false));
    }

    private static void Json(StringBuilder sb, string key, object value, bool comma)
    {
        sb.Append("  \"").Append(key).Append("\": ");
        if (value is bool b) sb.Append(b ? "true" : "false");
        else if (value is int || value is long) sb.Append(value);
        else sb.Append("\"").Append((value ?? "").ToString().Replace("\\", "\\\\").Replace("\"", "\\\"")).Append("\"");
        if (comma) sb.Append(",");
        sb.AppendLine();
    }

    private static bool IsMinimalSubsetOwner(string ownerHeroDid)
    {
        return ownerHeroDid == "1002" || ownerHeroDid == "1034" || ownerHeroDid == "1100111";
    }

    private static string NormalizeBundle(string bundle) { return (bundle ?? "").Trim().Replace("\\", "/"); }
    private static string NormalizeAssetPath(string path) { return (path ?? "").Trim().Replace("\\", "/").ToLowerInvariant(); }
    private static string Get(Dictionary<string, string> row, string key) { return row.TryGetValue(key, out var value) ? value.Trim() : ""; }
    private static string Bool(bool value) { return value ? "True" : "False"; }
    private static string Escape(string value)
    {
        value = value ?? "";
        if (value.Contains(",") || value.Contains("\"") || value.Contains("\n") || value.Contains("\r")) return "\"" + value.Replace("\"", "\"\"") + "\"";
        return value;
    }
    private static string Vec(Vector3 v) { return v.x.ToString("0.######", CultureInfo.InvariantCulture) + "/" + v.y.ToString("0.######", CultureInfo.InvariantCulture) + "/" + v.z.ToString("0.######", CultureInfo.InvariantCulture); }
    private static string RectString(Rect r) { return r.x.ToString("0.###", CultureInfo.InvariantCulture) + "/" + r.y.ToString("0.###", CultureInfo.InvariantCulture) + "/" + r.width.ToString("0.###", CultureInfo.InvariantCulture) + "/" + r.height.ToString("0.###", CultureInfo.InvariantCulture); }
    private static string ProjectRelative(string absolute) { return absolute.Replace(Path.Combine(BaseDir, "girlswar_battle_unity") + Path.DirectorySeparatorChar, "").Replace("\\", "/"); }

    private class ActorContext
    {
        public string Key = "";
        public string Name = "";
        public GameObject GameObject;
        public int RendererCount;
        public int EnabledRendererCount;
        public Bounds? Bounds;
        public string BoundsSize = "0/0/0";
        public Vector3 Anchor;
        public bool VisibleForProbe;
    }

    private class ProbeAnalysis
    {
        public int ComponentCount;
        public int MissingScriptCount;
        public string ComponentTypes = "";
        public int RendererCount;
        public int EnabledRendererCount;
        public int ParticleSystemCount;
        public int AnimatorCount;
        public int AudioSourceCount;
        public int PlayableDirectorCount;
        public string BoundsSize = "0/0/0";
        public bool HasNonZeroBounds;
        public bool HasRendererSignal;
    }

    private class SkillProbeResult
    {
        public Dictionary<string, string> Row;
        public Dictionary<string, string> BlockerRow;
        public Dictionary<string, string> ClassificationRow;
    }
}
