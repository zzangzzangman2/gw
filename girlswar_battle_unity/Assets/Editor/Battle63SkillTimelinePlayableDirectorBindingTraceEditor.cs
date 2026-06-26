using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using UnityEditor;
using UnityEngine;
using UnityEngine.Playables;

public static class Battle63SkillTimelinePlayableDirectorBindingTraceEditor
{
    private const string Prefix = "BATTLE_63_SKILL_TIMELINE_PLAYABLEDIRECTOR_BINDING_REQUIREMENTS_TRACE_NO_XLUA_NO_HANDLER_PATCH";
    private const string BaseDir = @"C:\Users\godho\Downloads\girlswar";
    private static readonly string ManifestCsv = Path.Combine(BaseDir, @"reports\battle\BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST_SPEEDLINE_RESOLVED.csv");
    private static readonly string CleanSliceRoot = Path.Combine(BaseDir, @"girlswar_merged_extracted\extracted\unity\clean_unityfs_slices");
    private static readonly string RestoreDataDir = Path.Combine(BaseDir, @"girlswar_battle_unity\Assets\RestoreData\battle");
    private static readonly string OutDirectorCsv = Path.Combine(RestoreDataDir, Prefix + "_DIRECTOR_TYPE_MISMATCH_MATRIX.csv");
    private static readonly string OutTimelineCsv = Path.Combine(RestoreDataDir, Prefix + "_TIMELINE_TRACKS_EXPOSED_BINDING_REQUIREMENTS.csv");
    private static readonly string OutRestCsv = Path.Combine(RestoreDataDir, Prefix + "_PREFAB_COMPONENT_REST_STATE_VISUAL_CAPABILITY.csv");
    private static readonly string OutClassCsv = Path.Combine(RestoreDataDir, Prefix + "_CLASSIFICATION_NEXT_ACTION.csv");
    private static readonly string OutSummaryJson = Path.Combine(RestoreDataDir, Prefix + "_UNITY_SUMMARY.json");

    private static readonly List<string> CapturedLogs = new List<string>();

    public static void Build()
    {
        Directory.CreateDirectory(RestoreDataDir);
        Application.logMessageReceived += CaptureLog;
        try
        {
            Run();
        }
        finally
        {
            Application.logMessageReceived -= CaptureLog;
        }
    }

    private static void Run()
    {
        var openedBundles = new List<AssetBundle>();
        var bundles = new Dictionary<string, AssetBundle>(StringComparer.OrdinalIgnoreCase);
        LoadBundle("download/commonprefabsandres/skilleffect/commonskillprefabsandres1.assetbundle", bundles, openedBundles);

        var rows = ReadCsv(ManifestCsv)
            .Where(r => Get(r, "rowType") == "skill")
            .Where(r => Get(r, "localStatus") == "loadable")
            .Where(r => IsMinimalSubsetOwner(Get(r, "ownerHeroDid")))
            .Where(r => !string.IsNullOrWhiteSpace(Get(r, "prefabId")))
            .ToList();

        var directorRows = new List<Dictionary<string, string>>();
        var timelineRows = new List<Dictionary<string, string>>();
        var restRows = new List<Dictionary<string, string>>();
        var classRows = new List<Dictionary<string, string>>();

        foreach (var manifestRow in rows)
        {
            ProbeRow(manifestRow, bundles, openedBundles, directorRows, timelineRows, restRows, classRows);
        }

        foreach (var bundle in openedBundles)
        {
            if (bundle != null) bundle.Unload(false);
        }

        WriteCsv(OutDirectorCsv, directorRows, DirectorHeaders());
        WriteCsv(OutTimelineCsv, timelineRows, TimelineHeaders());
        WriteCsv(OutRestCsv, restRows, RestHeaders());
        WriteCsv(OutClassCsv, classRows, ClassHeaders());
        WriteSummary(rows.Count, directorRows, timelineRows, restRows, classRows);
        AssetDatabase.Refresh();
        Debug.Log(Prefix + " complete rows=" + rows.Count + " directors=" + directorRows.Count);
    }

    private static void ProbeRow(
        Dictionary<string, string> manifestRow,
        Dictionary<string, AssetBundle> bundles,
        List<AssetBundle> openedBundles,
        List<Dictionary<string, string>> directorRows,
        List<Dictionary<string, string>> timelineRows,
        List<Dictionary<string, string>> restRows,
        List<Dictionary<string, string>> classRows)
    {
        var skillBundle = NormalizeBundle(Get(manifestRow, "bundle"));
        var bundlePath = ResolveBundlePath(skillBundle);
        var prefabId = Get(manifestRow, "prefabId");
        var assetPath = NormalizeAssetPath(Get(manifestRow, "assetPathViaGetSysprefabData"));
        var bundleExists = File.Exists(bundlePath);
        var bundleLoadSuccess = false;
        var assetLoadSuccess = false;
        var instantiateSuccess = false;
        var matchedAsset = "";
        var loadError = "";
        GameObject prefab = null;
        GameObject instance = null;

        try
        {
            if (bundleExists)
            {
                var bundle = LoadBundle(skillBundle, bundles, openedBundles);
                bundleLoadSuccess = bundle != null;
                if (bundle != null)
                {
                    matchedAsset = MatchAssetName(bundle.GetAllAssetNames(), assetPath, prefabId);
                    if (!string.IsNullOrEmpty(matchedAsset))
                    {
                        prefab = bundle.LoadAsset<GameObject>(matchedAsset);
                        assetLoadSuccess = prefab != null;
                    }
                }
            }
            if (prefab != null)
            {
                instance = UnityEngine.Object.Instantiate(prefab);
                instance.name = "BATTLE63_Diagnostic_" + Get(manifestRow, "ownerHeroDid") + "_" + prefabId;
                instance.SetActive(true);
                instantiateSuccess = true;
            }
        }
        catch (Exception ex)
        {
            loadError = ex.GetType().Name + ": " + ex.Message;
        }

        var target = instance != null ? instance : prefab;
        var rest = AnalyzeRestState(target);
        var rowKey = BaseRow(manifestRow, skillBundle, bundlePath, bundleExists, bundleLoadSuccess, assetPath, matchedAsset, assetLoadSuccess, instantiateSuccess);
        var directors = target != null ? target.GetComponentsInChildren<PlayableDirector>(true) : Array.Empty<PlayableDirector>();
        var timelineSummaries = new List<TimelineSummary>();
        var typeMismatchAny = false;
        var bindingRequiredAny = false;
        var inspectableAny = false;

        if (directors.Length == 0)
        {
            var drow = NewRow(DirectorHeaders());
            CopyBase(rowKey, drow);
            drow["directorPath"] = "";
            drow["playableAssetName"] = "";
            drow["mismatchCategory"] = "no_playable_director_found";
            drow["loadError"] = loadError;
            directorRows.Add(drow);
        }
        else
        {
            foreach (var director in directors)
            {
                var drow = BuildDirectorRow(rowKey, director, loadError);
                directorRows.Add(drow);
                typeMismatchAny = typeMismatchAny || Truth(drow["typeMismatchReproduced"]);

                var timeline = InspectTimeline(rowKey, director, drow);
                timelineRows.Add(timeline.Row);
                timelineSummaries.Add(timeline);
                inspectableAny = inspectableAny || timeline.Inspectable;
                bindingRequiredAny = bindingRequiredAny || timeline.BindingRequired;
            }
        }

        var restRow = NewRow(RestHeaders());
        CopyBase(rowKey, restRow);
        restRow["componentCount"] = rest.ComponentCount.ToString(CultureInfo.InvariantCulture);
        restRow["missingScriptCount"] = rest.MissingScriptCount.ToString(CultureInfo.InvariantCulture);
        restRow["componentTypes"] = rest.ComponentTypes;
        restRow["particleSystemCount"] = rest.ParticleSystemCount.ToString(CultureInfo.InvariantCulture);
        restRow["rendererCount"] = rest.RendererCount.ToString(CultureInfo.InvariantCulture);
        restRow["enabledRendererCount"] = rest.EnabledRendererCount.ToString(CultureInfo.InvariantCulture);
        restRow["animatorCount"] = rest.AnimatorCount.ToString(CultureInfo.InvariantCulture);
        restRow["animationCount"] = rest.AnimationCount.ToString(CultureInfo.InvariantCulture);
        restRow["audioSourceCount"] = rest.AudioSourceCount.ToString(CultureInfo.InvariantCulture);
        restRow["playableDirectorCount"] = rest.PlayableDirectorCount.ToString(CultureInfo.InvariantCulture);
        restRow["monoBehaviourCount"] = rest.MonoBehaviourCount.ToString(CultureInfo.InvariantCulture);
        restRow["activeAtRest"] = Bool(target != null && target.activeInHierarchy);
        restRow["hasRenderableAtRest"] = Bool(rest.HasRenderableAtRest);
        restRow["boundsSize"] = rest.BoundsSize;
        restRow["restStateVisualCapability"] = rest.HasRenderableAtRest ? "renderable_at_rest" : "no_render_components_or_zero_bounds_at_rest";
        restRows.Add(restRow);

        var classification = Classify(bundleExists, bundleLoadSuccess, assetLoadSuccess, instantiateSuccess, directors.Length, typeMismatchAny, inspectableAny, bindingRequiredAny, rest);
        var classRow = NewRow(ClassHeaders());
        CopyBase(rowKey, classRow);
        classRow["classification"] = classification;
        classRow["typeMismatchAny"] = Bool(typeMismatchAny);
        classRow["timelineInspectableAny"] = Bool(inspectableAny);
        classRow["timelineBindingRequiredAny"] = Bool(bindingRequiredAny);
        classRow["renderableAtRest"] = Bool(rest.HasRenderableAtRest);
        classRow["handlerPatchApplied"] = "False";
        classRow["xLuaRuntimeUsed"] = "False";
        classRow["sceneSaved"] = "False";
        classRow["nextAction"] = NextAction(classification);
        classRow["evidence"] = "directors=" + directors.Length + "; typeMismatch=" + Bool(typeMismatchAny) + "; timelineInspectable=" + Bool(inspectableAny) + "; bindingRequired=" + Bool(bindingRequiredAny) + "; renderers=" + rest.RendererCount + "; missingScripts=" + rest.MissingScriptCount;
        classRows.Add(classRow);

        if (instance != null) UnityEngine.Object.DestroyImmediate(instance);
    }

    private static Dictionary<string, string> BuildDirectorRow(Dictionary<string, string> baseRow, PlayableDirector director, string loadError)
    {
        var row = NewRow(DirectorHeaders());
        CopyBase(baseRow, row);
        var info = GetPlayableAssetInfo(director);
        row["directorPath"] = TransformPath(director.transform);
        row["playableAssetName"] = info.Name;
        row["playableAssetType"] = info.TypeName;
        row["playableAssetAssemblyQualifiedType"] = info.AssemblyQualifiedType;
        row["playableAssetIsPlayableAsset"] = Bool(info.IsPlayableAsset);
        row["playableAssetIsScriptableObject"] = Bool(info.IsScriptableObject);
        row["serializedPlayableAssetName"] = info.SerializedName;
        row["serializedPlayableAssetType"] = info.SerializedTypeName;
        row["serializedPlayableAssetIsPlayableAsset"] = Bool(info.SerializedIsPlayableAsset);
        row["dependencyTypeHints"] = info.DependencyTypeHints;
        row["playOnAwake"] = Bool(director.playOnAwake);
        row["timeUpdateMode"] = director.timeUpdateMode.ToString();
        row["duration"] = director.duration.ToString("0.######", CultureInfo.InvariantCulture);
        row["extrapolationMode"] = director.extrapolationMode.ToString();
        row["initialBindingCount"] = info.InitialBindingCount.ToString(CultureInfo.InvariantCulture);
        row["playableOutputCount"] = info.PlayableOutputCount.ToString(CultureInfo.InvariantCulture);
        var eval = EvaluateDirector(director);
        row["evaluateAttempted"] = "True";
        row["evaluateSucceeded"] = Bool(eval.Succeeded);
        row["evaluateException"] = eval.ExceptionText;
        row["evaluateLogMessages"] = eval.LogText;
        var typeMismatch = (!string.IsNullOrEmpty(eval.LogText) && eval.LogText.IndexOf("PlayableAsset type mismatch", StringComparison.OrdinalIgnoreCase) >= 0)
            || (!info.IsPlayableAsset && (!string.IsNullOrEmpty(info.TypeName) || !string.IsNullOrEmpty(info.SerializedTypeName) || info.DependencyTypeHints.IndexOf("TimelineAsset", StringComparison.OrdinalIgnoreCase) >= 0));
        row["typeMismatchReproduced"] = Bool(typeMismatch);
        row["mismatchCategory"] = typeMismatch ? "timeline_asset_type_mismatch_blocks_evaluate" : MismatchCategory(info);
        row["loadError"] = loadError;
        return row;
    }

    private static TimelineSummary InspectTimeline(Dictionary<string, string> baseRow, PlayableDirector director, Dictionary<string, string> directorRow)
    {
        var row = NewRow(TimelineHeaders());
        CopyBase(baseRow, row);
        row["directorPath"] = directorRow["directorPath"];
        row["playableAssetName"] = directorRow["playableAssetName"];
        row["playableAssetType"] = directorRow["playableAssetType"];
        var source = GetSerializedPlayableObject(director) ?? director.playableAsset;
        var timelineInspectable = source != null;
        row["timelineInspectable"] = Bool(timelineInspectable);
        if (source == null)
        {
            row["bindingRequirementSummary"] = "PlayableDirector has no accessible playableAsset object; original TimelineAsset binding/type bridge is required.";
            return new TimelineSummary { Row = row, Inspectable = false, BindingRequired = true };
        }

        var trackObjects = InvokeObjectEnumerable(source, "GetOutputTracks").ToList();
        if (trackObjects.Count == 0) trackObjects = InvokeObjectEnumerable(source, "GetRootTracks").ToList();
        var outputs = EnumeratePlayableOutputs(source).ToList();
        var trackTypes = trackObjects.Select(o => o != null ? o.GetType().Name : "<null>").Where(s => !string.IsNullOrEmpty(s)).ToList();
        var streamNames = outputs.Select(o => o.streamName ?? "").Where(s => !string.IsNullOrEmpty(s)).ToList();
        var bindingTypes = outputs.Select(o => o.outputTargetType != null ? o.outputTargetType.Name : "").Where(s => !string.IsNullOrEmpty(s)).ToList();
        var clipCount = CountClips(trackObjects);
        var exposedKeys = FindSerializedPropertyNames(source, "exposed");
        var bindingCount = CountNonNullBindings(director, outputs);
        var outputCount = outputs.Count;
        var bindingRequired = outputCount > 0 && bindingCount < outputCount;

        row["trackCount"] = trackObjects.Count.ToString(CultureInfo.InvariantCulture);
        row["outputTrackCount"] = outputCount.ToString(CultureInfo.InvariantCulture);
        row["trackTypeNames"] = string.Join("|", trackTypes.Distinct());
        row["outputBindingTypes"] = string.Join("|", bindingTypes.Distinct());
        row["outputStreamNames"] = string.Join("|", streamNames);
        row["exposedReferenceKeysOrProps"] = string.Join("|", exposedKeys);
        row["clipCount"] = clipCount.ToString(CultureInfo.InvariantCulture);
        row["controlTrackCount"] = CountType(trackTypes, "ControlTrack").ToString(CultureInfo.InvariantCulture);
        row["activationTrackCount"] = CountType(trackTypes, "ActivationTrack").ToString(CultureInfo.InvariantCulture);
        row["signalTrackCount"] = CountType(trackTypes, "SignalTrack").ToString(CultureInfo.InvariantCulture);
        row["animationTrackCount"] = CountType(trackTypes, "AnimationTrack").ToString(CultureInfo.InvariantCulture);
        row["audioTrackCount"] = CountType(trackTypes, "AudioTrack").ToString(CultureInfo.InvariantCulture);
        row["initialBindingCount"] = bindingCount.ToString(CultureInfo.InvariantCulture);
        row["missingBindingCount"] = Math.Max(0, outputCount - bindingCount).ToString(CultureInfo.InvariantCulture);
        row["particleOrControlBindingRequirement"] = trackTypes.Any(t => t.IndexOf("Control", StringComparison.OrdinalIgnoreCase) >= 0 || t.IndexOf("Activation", StringComparison.OrdinalIgnoreCase) >= 0)
            ? "control_or_activation_tracks_require_original_bound_scene_objects"
            : "";
        row["bindingRequirementSummary"] = bindingRequired
            ? "Timeline outputs exist without complete PlayableDirector bindings; original battle runtime/exposed references are required."
            : outputCount == 0
                ? "No playable outputs are exposed to this restored Editor runtime; visual signal cannot be driven from rest-state prefab alone."
                : "Timeline outputs have accessible initial bindings.";
        return new TimelineSummary { Row = row, Inspectable = timelineInspectable, BindingRequired = bindingRequired || outputCount == 0 };
    }

    private static PlayableAssetInfo GetPlayableAssetInfo(PlayableDirector director)
    {
        var info = new PlayableAssetInfo();
        UnityEngine.Object raw = null;
        try { raw = director.playableAsset; } catch { raw = null; }
        if (raw != null)
        {
            info.Name = raw.name;
            info.TypeName = raw.GetType().FullName;
            info.AssemblyQualifiedType = raw.GetType().AssemblyQualifiedName;
            info.IsPlayableAsset = raw is PlayableAsset;
            info.IsScriptableObject = raw is ScriptableObject;
        }

        var serialized = GetSerializedPlayableObject(director);
        if (serialized != null)
        {
            info.SerializedName = serialized.name;
            info.SerializedTypeName = serialized.GetType().FullName;
            info.SerializedIsPlayableAsset = serialized is PlayableAsset;
        }

        var deps = EditorUtility.CollectDependencies(new UnityEngine.Object[] { director.gameObject });
        info.DependencyTypeHints = string.Join("|", deps.Where(o => o != null).Select(o => o.GetType().FullName).Where(s => !string.IsNullOrEmpty(s)).Distinct().Take(30));
        var asset = (raw as PlayableAsset) ?? (serialized as PlayableAsset);
        if (asset != null)
        {
            var outputs = asset.outputs.ToList();
            info.PlayableOutputCount = outputs.Count;
            info.InitialBindingCount = CountNonNullBindings(director, outputs);
        }
        return info;
    }

    private static UnityEngine.Object GetSerializedPlayableObject(PlayableDirector director)
    {
        try
        {
            var so = new SerializedObject(director);
            var prop = so.FindProperty("m_PlayableAsset");
            return prop != null ? prop.objectReferenceValue : null;
        }
        catch
        {
            return null;
        }
    }

    private static EvaluateResult EvaluateDirector(PlayableDirector director)
    {
        var start = CapturedLogs.Count;
        var result = new EvaluateResult();
        try
        {
            director.timeUpdateMode = DirectorUpdateMode.Manual;
            director.time = 0;
            director.Evaluate();
            director.time = 0.25;
            director.Evaluate();
            result.Succeeded = true;
        }
        catch (Exception ex)
        {
            result.Succeeded = false;
            result.ExceptionText = ex.GetType().Name + ": " + ex.Message;
        }
        result.LogText = string.Join(" | ", CapturedLogs.Skip(start).Where(s => s.IndexOf(Prefix, StringComparison.OrdinalIgnoreCase) < 0).Take(20));
        return result;
    }

    private static IEnumerable<PlayableBinding> EnumeratePlayableOutputs(UnityEngine.Object source)
    {
        if (source is PlayableAsset playable)
        {
            foreach (var output in playable.outputs) yield return output;
        }
    }

    private static int CountNonNullBindings(PlayableDirector director, IEnumerable<PlayableBinding> outputs)
    {
        var count = 0;
        foreach (var output in outputs)
        {
            try
            {
                if (output.sourceObject != null && director.GetGenericBinding(output.sourceObject) != null) count++;
            }
            catch { }
        }
        return count;
    }

    private static IEnumerable<object> InvokeObjectEnumerable(object source, string methodName)
    {
        if (source == null) yield break;
        MethodInfo method = null;
        try { method = source.GetType().GetMethod(methodName, BindingFlags.Instance | BindingFlags.Public | BindingFlags.NonPublic, null, Type.EmptyTypes, null); } catch { method = null; }
        if (method == null) yield break;
        object value = null;
        try { value = method.Invoke(source, null); } catch { value = null; }
        if (value is System.Collections.IEnumerable enumerable)
        {
            foreach (var item in enumerable) yield return item;
        }
    }

    private static int CountClips(List<object> tracks)
    {
        var count = 0;
        foreach (var track in tracks)
        {
            foreach (var clip in InvokeObjectEnumerable(track, "GetClips")) count++;
        }
        return count;
    }

    private static List<string> FindSerializedPropertyNames(UnityEngine.Object target, string contains)
    {
        var result = new List<string>();
        if (target == null) return result;
        try
        {
            var so = new SerializedObject(target);
            var prop = so.GetIterator();
            var enterChildren = true;
            while (prop.NextVisible(enterChildren))
            {
                enterChildren = false;
                if (prop.name.IndexOf(contains, StringComparison.OrdinalIgnoreCase) >= 0 || prop.propertyPath.IndexOf(contains, StringComparison.OrdinalIgnoreCase) >= 0)
                {
                    result.Add(prop.propertyPath);
                }
            }
        }
        catch { }
        return result.Distinct().Take(40).ToList();
    }

    private static RestState AnalyzeRestState(GameObject target)
    {
        var result = new RestState();
        if (target == null) return result;
        var components = target.GetComponentsInChildren<Component>(true);
        result.ComponentCount = components.Length;
        result.MissingScriptCount = components.Count(c => c == null);
        result.ComponentTypes = string.Join("|", components.Where(c => c != null).GroupBy(c => c.GetType().Name).OrderBy(g => g.Key).Select(g => g.Key + ":" + g.Count()));
        result.ParticleSystemCount = components.Count(c => c is ParticleSystem);
        result.AnimatorCount = components.Count(c => c is Animator);
        result.AnimationCount = components.Count(c => c is Animation);
        result.AudioSourceCount = components.Count(c => c is AudioSource);
        result.PlayableDirectorCount = components.Count(c => c is PlayableDirector);
        result.MonoBehaviourCount = components.Count(c => c is MonoBehaviour);
        var renderers = target.GetComponentsInChildren<Renderer>(true);
        result.RendererCount = renderers.Length;
        result.EnabledRendererCount = renderers.Count(r => r != null && r.enabled && r.gameObject.activeInHierarchy);
        var bounds = CombinedBounds(renderers);
        result.BoundsSize = bounds.HasValue ? Vec(bounds.Value.size) : "0/0/0";
        result.HasRenderableAtRest = result.EnabledRendererCount > 0 && bounds.HasValue && bounds.Value.size.sqrMagnitude > 0.0001f;
        return result;
    }

    private static string Classify(bool bundleExists, bool bundleLoaded, bool assetLoaded, bool instantiated, int directorCount, bool typeMismatchAny, bool inspectableAny, bool bindingRequiredAny, RestState rest)
    {
        if (!bundleExists || !bundleLoaded || !assetLoaded || !instantiated) return "blocked_by_unresolved_dependency";
        if (typeMismatchAny) return "timeline_asset_type_mismatch_blocks_evaluate";
        if (bindingRequiredAny) return "timeline_binding_required_for_visual_signal";
        if (directorCount > 0 && inspectableAny) return "missing_runtime_battle_manager_or_exposed_refs";
        if (rest.HasRenderableAtRest) return "source_backed_visual_activation_candidate";
        return "prefab_loads_but_no_render_components_at_rest";
    }

    private static string NextAction(string classification)
    {
        if (classification == "timeline_asset_type_mismatch_blocks_evaluate") return "Trace original TimelineAsset/PlayableAsset serialization or Unity Timeline runtime compatibility before activation.";
        if (classification == "timeline_binding_required_for_visual_signal") return "Recover original PlayableDirector output/exposed-reference bindings from battle runtime evidence; do not invent values.";
        if (classification == "prefab_loads_but_no_render_components_at_rest") return "Treat prefab as timeline-driven only; activation requires original timeline/runtime binding context.";
        if (classification == "missing_runtime_battle_manager_or_exposed_refs") return "Identify required battle manager/exposed reference objects from original runtime/Lua/IL2CPP evidence.";
        if (classification == "blocked_by_unresolved_dependency") return "Resolve local source-backed dependency chain; do not substitute fake effects.";
        return "Candidate has source-backed rest-state visuals; keep diagnostic-only until original handler/runtime path is restored.";
    }

    private static string MismatchCategory(PlayableAssetInfo info)
    {
        if (string.IsNullOrEmpty(info.Name) && string.IsNullOrEmpty(info.SerializedName)) return "playable_asset_null_or_unresolved";
        if (!info.IsPlayableAsset || !info.SerializedIsPlayableAsset) return "serialized_object_not_assignable_to_playable_asset";
        return "";
    }

    private static Dictionary<string, string> BaseRow(Dictionary<string, string> manifestRow, string skillBundle, string bundlePath, bool bundleExists, bool bundleLoadSuccess, string assetPath, string matchedAsset, bool assetLoadSuccess, bool instantiateSuccess)
    {
        var row = new Dictionary<string, string>();
        row["side"] = Get(manifestRow, "side");
        row["waveNo"] = Get(manifestRow, "waveNo");
        row["ownerHeroDid"] = Get(manifestRow, "ownerHeroDid");
        row["skillDid"] = Get(manifestRow, "skillDid");
        row["prefabField"] = Get(manifestRow, "prefabField");
        row["prefabId"] = Get(manifestRow, "prefabId");
        row["skillBundle"] = skillBundle;
        row["resolvedBundlePath"] = bundlePath;
        row["bundleExists"] = Bool(bundleExists);
        row["bundleLoadSuccess"] = Bool(bundleLoadSuccess);
        row["assetPathViaGetSysprefabData"] = Get(manifestRow, "assetPathViaGetSysprefabData");
        row["matchedAssetName"] = matchedAsset;
        row["assetLoadSuccess"] = Bool(assetLoadSuccess);
        row["instantiateSuccess"] = Bool(instantiateSuccess);
        return row;
    }

    private static void CopyBase(Dictionary<string, string> source, Dictionary<string, string> target)
    {
        foreach (var kv in source)
        {
            if (target.ContainsKey(kv.Key)) target[kv.Key] = kv.Value;
        }
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

    private static string MatchAssetName(string[] assetNames, string expected, string prefabId)
    {
        foreach (var name in assetNames) if (!string.IsNullOrEmpty(expected) && NormalizeAssetPath(name) == expected) return name;
        foreach (var name in assetNames)
        {
            var lower = NormalizeAssetPath(name);
            if (!string.IsNullOrEmpty(prefabId) && lower.EndsWith("/" + prefabId + ".prefab", StringComparison.OrdinalIgnoreCase)) return name;
        }
        foreach (var name in assetNames) if (!string.IsNullOrEmpty(prefabId) && NormalizeAssetPath(name).Contains(prefabId.ToLowerInvariant())) return name;
        return "";
    }

    private static Bounds? CombinedBounds(Renderer[] renderers)
    {
        Bounds? bounds = null;
        foreach (var renderer in renderers)
        {
            if (renderer == null) continue;
            if (!bounds.HasValue) bounds = renderer.bounds;
            else
            {
                var b = bounds.Value;
                b.Encapsulate(renderer.bounds);
                bounds = b;
            }
        }
        return bounds;
    }

    private static int CountType(List<string> types, string name)
    {
        return types.Count(t => t.IndexOf(name, StringComparison.OrdinalIgnoreCase) >= 0);
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

    private static void WriteSummary(int checkedRows, List<Dictionary<string, string>> directorRows, List<Dictionary<string, string>> timelineRows, List<Dictionary<string, string>> restRows, List<Dictionary<string, string>> classRows)
    {
        var classes = classRows.GroupBy(r => r["classification"]).ToDictionary(g => g.Key, g => g.Count());
        var sb = new StringBuilder();
        sb.AppendLine("{");
        Json(sb, "prefix", Prefix, true);
        Json(sb, "restoredClaim", false, true);
        Json(sb, "playableClaim", false, true);
        Json(sb, "handlerPatchApplied", false, true);
        Json(sb, "xLuaRuntimeUsed", false, true);
        Json(sb, "sceneSaved", false, true);
        Json(sb, "sourceBackedSkillRowsChecked", checkedRows, true);
        Json(sb, "playableDirectorsFound", directorRows.Count(r => !string.IsNullOrEmpty(r["directorPath"])), true);
        Json(sb, "timelineAssetsInspectable", timelineRows.Count(r => Truth(r["timelineInspectable"])), true);
        Json(sb, "rowsWithPlayableAssetTypeMismatch", classRows.Count(r => Truth(r["typeMismatchAny"])), true);
        Json(sb, "rowsRequiringTimelineBindings", classRows.Count(r => Truth(r["timelineBindingRequiredAny"])), true);
        Json(sb, "rowsWithRenderableAtRest", restRows.Count(r => Truth(r["hasRenderableAtRest"])), true);
        Json(sb, "rowsWithSourceBackedVisualActivationCandidate", classRows.Count(r => r["classification"] == "source_backed_visual_activation_candidate"), true);
        sb.Append("  \"classificationCounts\": {");
        sb.Append(string.Join(", ", classes.Select(kv => "\"" + EscapeJson(kv.Key) + "\": " + kv.Value)));
        sb.AppendLine("},");
        Json(sb, "nextBlocker", "original_timeline_playabledirector_runtime_binding_or_source_compatible_timeline_asset_bridge_required", false);
        sb.AppendLine("}");
        File.WriteAllText(OutSummaryJson, sb.ToString(), new UTF8Encoding(false));
    }

    private static string[] BaseHeaders()
    {
        return new[] { "side", "waveNo", "ownerHeroDid", "skillDid", "prefabField", "prefabId", "skillBundle", "resolvedBundlePath", "bundleExists", "bundleLoadSuccess", "assetPathViaGetSysprefabData", "matchedAssetName", "assetLoadSuccess", "instantiateSuccess" };
    }

    private static string[] DirectorHeaders()
    {
        return BaseHeaders().Concat(new[] { "directorPath", "playableAssetName", "playableAssetType", "playableAssetAssemblyQualifiedType", "playableAssetIsPlayableAsset", "playableAssetIsScriptableObject", "serializedPlayableAssetName", "serializedPlayableAssetType", "serializedPlayableAssetIsPlayableAsset", "dependencyTypeHints", "playOnAwake", "timeUpdateMode", "duration", "extrapolationMode", "initialBindingCount", "playableOutputCount", "evaluateAttempted", "evaluateSucceeded", "evaluateException", "evaluateLogMessages", "typeMismatchReproduced", "mismatchCategory", "loadError" }).ToArray();
    }

    private static string[] TimelineHeaders()
    {
        return BaseHeaders().Concat(new[] { "directorPath", "playableAssetName", "playableAssetType", "timelineInspectable", "trackCount", "outputTrackCount", "trackTypeNames", "outputBindingTypes", "outputStreamNames", "exposedReferenceKeysOrProps", "clipCount", "controlTrackCount", "activationTrackCount", "signalTrackCount", "animationTrackCount", "audioTrackCount", "initialBindingCount", "missingBindingCount", "particleOrControlBindingRequirement", "bindingRequirementSummary" }).ToArray();
    }

    private static string[] RestHeaders()
    {
        return BaseHeaders().Concat(new[] { "componentCount", "missingScriptCount", "componentTypes", "particleSystemCount", "rendererCount", "enabledRendererCount", "animatorCount", "animationCount", "audioSourceCount", "playableDirectorCount", "monoBehaviourCount", "activeAtRest", "hasRenderableAtRest", "boundsSize", "restStateVisualCapability" }).ToArray();
    }

    private static string[] ClassHeaders()
    {
        return BaseHeaders().Concat(new[] { "classification", "typeMismatchAny", "timelineInspectableAny", "timelineBindingRequiredAny", "renderableAtRest", "handlerPatchApplied", "xLuaRuntimeUsed", "sceneSaved", "nextAction", "evidence" }).ToArray();
    }

    private static Dictionary<string, string> NewRow(string[] headers)
    {
        var row = new Dictionary<string, string>();
        foreach (var h in headers) row[h] = "";
        return row;
    }

    private static void CaptureLog(string condition, string stackTrace, LogType type)
    {
        CapturedLogs.Add(type + ": " + condition);
    }

    private static void Json(StringBuilder sb, string key, object value, bool comma)
    {
        sb.Append("  \"").Append(key).Append("\": ");
        if (value is bool b) sb.Append(b ? "true" : "false");
        else if (value is int || value is long) sb.Append(value);
        else sb.Append("\"").Append(EscapeJson((value ?? "").ToString())).Append("\"");
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
    private static bool Truth(string value) { return (value ?? "").Equals("True", StringComparison.OrdinalIgnoreCase); }
    private static string Escape(string value)
    {
        value = value ?? "";
        if (value.Contains(",") || value.Contains("\"") || value.Contains("\n") || value.Contains("\r")) return "\"" + value.Replace("\"", "\"\"") + "\"";
        return value;
    }
    private static string EscapeJson(string value) { return (value ?? "").Replace("\\", "\\\\").Replace("\"", "\\\""); }
    private static string Vec(Vector3 v) { return v.x.ToString("0.######", CultureInfo.InvariantCulture) + "/" + v.y.ToString("0.######", CultureInfo.InvariantCulture) + "/" + v.z.ToString("0.######", CultureInfo.InvariantCulture); }
    private static string TransformPath(Transform transform)
    {
        var names = new List<string>();
        while (transform != null)
        {
            names.Add(transform.name);
            transform = transform.parent;
        }
        names.Reverse();
        return string.Join("/", names);
    }

    private class PlayableAssetInfo
    {
        public string Name = "";
        public string TypeName = "";
        public string AssemblyQualifiedType = "";
        public bool IsPlayableAsset;
        public bool IsScriptableObject;
        public string SerializedName = "";
        public string SerializedTypeName = "";
        public bool SerializedIsPlayableAsset;
        public string DependencyTypeHints = "";
        public int InitialBindingCount;
        public int PlayableOutputCount;
    }

    private class EvaluateResult
    {
        public bool Succeeded;
        public string ExceptionText = "";
        public string LogText = "";
    }

    private class TimelineSummary
    {
        public Dictionary<string, string> Row;
        public bool Inspectable;
        public bool BindingRequired;
    }

    private class RestState
    {
        public int ComponentCount;
        public int MissingScriptCount;
        public string ComponentTypes = "";
        public int ParticleSystemCount;
        public int RendererCount;
        public int EnabledRendererCount;
        public int AnimatorCount;
        public int AnimationCount;
        public int AudioSourceCount;
        public int PlayableDirectorCount;
        public int MonoBehaviourCount;
        public bool HasRenderableAtRest;
        public string BoundsSize = "0/0/0";
    }
}
