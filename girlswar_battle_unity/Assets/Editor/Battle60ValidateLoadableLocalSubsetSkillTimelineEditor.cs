using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using UnityEditor;
using UnityEngine;

public static class Battle60ValidateLoadableLocalSubsetSkillTimelineEditor
{
    private const string Prefix = "BATTLE_60_VALIDATE_LOADABLE_LOCAL_SUBSET_SKILL_TIMELINE_ASSETBUNDLE_CHAIN_NO_XLUA_NO_HANDLER_PATCH";
    private const string BaseDir = @"C:\Users\godho\Downloads\girlswar";
    private static readonly string ManifestCsv = Path.Combine(BaseDir, @"reports\battle\BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST.csv");
    private static readonly string AssetBundleRoot = Path.Combine(BaseDir, @"girlswar_merged_extracted\merged_content\AssetBundles");
    private static readonly string CleanSliceRoot = Path.Combine(BaseDir, @"girlswar_merged_extracted\extracted\unity\clean_unityfs_slices");
    private static readonly string RestoreDataDir = Path.Combine(BaseDir, @"girlswar_battle_unity\Assets\RestoreData\battle");
    private static readonly string OutTimelineCsv = Path.Combine(RestoreDataDir, Prefix + "_SKILL_TIMELINE_SOURCE_LOAD_VALIDATION.csv");
    private static readonly string OutRefsCsv = Path.Combine(RestoreDataDir, Prefix + "_SKILL_PREFAB_COMPONENT_DEPENDENCY_REFS.csv");
    private static readonly string OutSummaryJson = Path.Combine(RestoreDataDir, Prefix + "_UNITY_SUMMARY.json");

    public static void Build()
    {
        Directory.CreateDirectory(RestoreDataDir);
        var rows = ReadCsv(ManifestCsv)
            .Where(r => Get(r, "rowType") == "skill")
            .Where(r => Get(r, "localStatus") == "loadable" || Get(r, "localStatus") == "loadable_with_unresolved_common_resource_deps")
            .Where(r => IsMinimalSubsetOwner(Get(r, "ownerHeroDid")))
            .ToList();

        var timelineRows = new List<Dictionary<string, string>>();
        var refRows = new List<Dictionary<string, string>>();
        var loadedBundles = new Dictionary<string, AssetBundle>(StringComparer.OrdinalIgnoreCase);

        foreach (var row in rows)
        {
            var bundle = NormalizeBundle(Get(row, "bundle"));
            var resolvedBundlePath = ResolveBundlePath(bundle);
            var bundleExists = File.Exists(resolvedBundlePath);
            AssetBundle ab = null;
            var bundleLoadSuccess = false;
            var bundleLoadError = "";
            var allAssetNames = Array.Empty<string>();

            if (bundleExists)
            {
                try
                {
                    if (!loadedBundles.TryGetValue(resolvedBundlePath, out ab) || ab == null)
                    {
                        ab = AssetBundle.LoadFromFile(resolvedBundlePath);
                        loadedBundles[resolvedBundlePath] = ab;
                    }
                    bundleLoadSuccess = ab != null;
                    if (ab != null)
                    {
                        allAssetNames = ab.GetAllAssetNames();
                    }
                    else
                    {
                        bundleLoadError = "AssetBundle.LoadFromFile returned null";
                    }
                }
                catch (Exception ex)
                {
                    bundleLoadError = ex.GetType().Name + ": " + ex.Message;
                }
            }

            var expectedAssetPath = NormalizeAssetPath(Get(row, "assetPathViaGetSysprefabData"));
            var prefabId = Get(row, "prefabId");
            var matchedAssetName = MatchAssetName(allAssetNames, expectedAssetPath, prefabId);
            GameObject prefab = null;
            var assetLoadSuccess = false;
            var instantiateSuccess = false;
            var instantiateError = "";

            if (ab != null && !string.IsNullOrEmpty(matchedAssetName))
            {
                try
                {
                    prefab = ab.LoadAsset<GameObject>(matchedAssetName);
                    assetLoadSuccess = prefab != null;
                }
                catch (Exception ex)
                {
                    instantiateError = ex.GetType().Name + ": " + ex.Message;
                }
            }

            GameObject instance = null;
            if (prefab != null)
            {
                try
                {
                    instance = UnityEngine.Object.Instantiate(prefab);
                    instance.name = Prefix + "_Probe_" + prefabId;
                    instantiateSuccess = instance != null;
                }
                catch (Exception ex)
                {
                    instantiateError = ex.GetType().Name + ": " + ex.Message;
                }
            }

            var target = instance != null ? instance : prefab;
            var analysis = AnalyzePrefab(target);
            var dependencies = AnalyzeDependencies(target);
            var missingDeps = Get(row, "missingDependencyBundles");
            var resourceComplete = Get(row, "localStatus") == "loadable" && string.IsNullOrWhiteSpace(missingDeps);

            timelineRows.Add(new Dictionary<string, string>
            {
                ["side"] = Get(row, "side"),
                ["waveNo"] = Get(row, "waveNo"),
                ["ownerHeroDid"] = Get(row, "ownerHeroDid"),
                ["skillDid"] = Get(row, "skillDid"),
                ["skillType"] = Get(row, "skillType"),
                ["prefabField"] = Get(row, "prefabField"),
                ["prefabId"] = prefabId,
                ["assetPathViaGetSysprefabData"] = Get(row, "assetPathViaGetSysprefabData"),
                ["skillBundle"] = bundle,
                ["resolvedBundlePath"] = resolvedBundlePath,
                ["bundleExists"] = Bool(bundleExists),
                ["bundleLoadSuccess"] = Bool(bundleLoadSuccess),
                ["bundleAssetCount"] = allAssetNames.Length.ToString(),
                ["matchedAssetName"] = matchedAssetName,
                ["assetLoadSuccess"] = Bool(assetLoadSuccess),
                ["instantiateSuccess"] = Bool(instantiateSuccess),
                ["localStatus"] = Get(row, "localStatus"),
                ["resourceCompleteStrict"] = Bool(resourceComplete),
                ["missingDependencyBundles"] = missingDeps,
                ["missingDependencyCount"] = CountList(missingDeps).ToString(),
                ["loadError"] = FirstNonEmpty(bundleLoadError, instantiateError),
                ["sceneSaved"] = "False",
                ["xLuaRuntimeUsed"] = "False",
                ["handlerBindingApplied"] = "False"
            });

            refRows.Add(new Dictionary<string, string>
            {
                ["skillDid"] = Get(row, "skillDid"),
                ["prefabId"] = prefabId,
                ["matchedAssetName"] = matchedAssetName,
                ["prefabObjectName"] = prefab != null ? prefab.name : "",
                ["rootChildCount"] = target != null ? target.transform.childCount.ToString() : "0",
                ["componentCount"] = analysis.ComponentCount.ToString(),
                ["missingScriptCount"] = analysis.MissingScriptCount.ToString(),
                ["componentTypes"] = analysis.ComponentTypes,
                ["particleSystemCount"] = analysis.ParticleSystemCount.ToString(),
                ["animatorCount"] = analysis.AnimatorCount.ToString(),
                ["animationCount"] = analysis.AnimationCount.ToString(),
                ["playableDirectorCount"] = analysis.PlayableDirectorCount.ToString(),
                ["rendererCount"] = analysis.RendererCount.ToString(),
                ["materialCount"] = dependencies.MaterialCount.ToString(),
                ["shaderNames"] = dependencies.ShaderNames,
                ["textureCount"] = dependencies.TextureCount.ToString(),
                ["meshCount"] = dependencies.MeshCount.ToString(),
                ["animationClipCount"] = dependencies.AnimationClipCount.ToString(),
                ["dependencyTypeCounts"] = dependencies.TypeCounts,
                ["boundsSize"] = analysis.BoundsSize,
                ["hasNonZeroBounds"] = Bool(analysis.HasNonZeroBounds)
            });

            if (instance != null)
            {
                UnityEngine.Object.DestroyImmediate(instance);
            }
        }

        foreach (var pair in loadedBundles)
        {
            if (pair.Value != null)
            {
                pair.Value.Unload(false);
            }
        }

        WriteCsv(OutTimelineCsv, timelineRows, new[]
        {
            "side", "waveNo", "ownerHeroDid", "skillDid", "skillType", "prefabField", "prefabId",
            "assetPathViaGetSysprefabData", "skillBundle", "resolvedBundlePath", "bundleExists",
            "bundleLoadSuccess", "bundleAssetCount", "matchedAssetName", "assetLoadSuccess",
            "instantiateSuccess", "localStatus", "resourceCompleteStrict", "missingDependencyBundles",
            "missingDependencyCount", "loadError", "sceneSaved", "xLuaRuntimeUsed", "handlerBindingApplied"
        });
        WriteCsv(OutRefsCsv, refRows, new[]
        {
            "skillDid", "prefabId", "matchedAssetName", "prefabObjectName", "rootChildCount",
            "componentCount", "missingScriptCount", "componentTypes", "particleSystemCount",
            "animatorCount", "animationCount", "playableDirectorCount", "rendererCount",
            "materialCount", "shaderNames", "textureCount", "meshCount", "animationClipCount",
            "dependencyTypeCounts", "boundsSize", "hasNonZeroBounds"
        });

        var resourceCompleteRows = timelineRows.Where(r => r["resourceCompleteStrict"] == "True").ToList();
        var resourceCompleteVerified = resourceCompleteRows.Count(r =>
            r["bundleLoadSuccess"] == "True" && r["assetLoadSuccess"] == "True" && r["instantiateSuccess"] == "True");
        var summary = new StringBuilder();
        summary.AppendLine("{");
        Json(summary, "prefix", Prefix, true);
        Json(summary, "sourceBackedSkillRowsChecked", timelineRows.Count, true);
        Json(summary, "resourceCompleteSkillRowsChecked", resourceCompleteRows.Count, true);
        Json(summary, "resourceCompleteSkillRowsVerified", resourceCompleteVerified, true);
        Json(summary, "missingCommonDependencyRows", timelineRows.Count(r => r["localStatus"] == "loadable_with_unresolved_common_resource_deps"), true);
        Json(summary, "bundleLoadSuccessRows", timelineRows.Count(r => r["bundleLoadSuccess"] == "True"), true);
        Json(summary, "assetLoadSuccessRows", timelineRows.Count(r => r["assetLoadSuccess"] == "True"), true);
        Json(summary, "instantiateSuccessRows", timelineRows.Count(r => r["instantiateSuccess"] == "True"), true);
        Json(summary, "sceneSaved", false, true);
        Json(summary, "handlerBindingApplied", false, true);
        Json(summary, "xLuaRuntimeUsed", false, true);
        Json(summary, "skillTimelineChainVerifiedForResourceCompleteSubset", resourceCompleteRows.Count == 4 && resourceCompleteVerified == 4, false);
        summary.AppendLine("}");
        File.WriteAllText(OutSummaryJson, summary.ToString(), new UTF8Encoding(false));

        AssetDatabase.Refresh();
        Debug.Log(Prefix + " complete. rows=" + timelineRows.Count + " resourceCompleteVerified=" + resourceCompleteVerified);
    }

    private static bool IsMinimalSubsetOwner(string ownerHeroDid)
    {
        return ownerHeroDid == "1002" || ownerHeroDid == "1034" || ownerHeroDid == "1100111";
    }

    private static string ResolveBundlePath(string bundle)
    {
        var rel = bundle.Replace('/', Path.DirectorySeparatorChar).Replace('\\', Path.DirectorySeparatorChar);
        var cleanUnityFs = Path.Combine(CleanSliceRoot, rel);
        if (File.Exists(cleanUnityFs))
        {
            return cleanUnityFs;
        }
        var primary = Path.Combine(AssetBundleRoot, rel);
        if (File.Exists(primary))
        {
            return primary;
        }
        return primary;
    }

    private static string NormalizeBundle(string bundle)
    {
        return (bundle ?? "").Trim().Replace("\\", "/");
    }

    private static string NormalizeAssetPath(string path)
    {
        return (path ?? "").Trim().Replace("\\", "/").ToLowerInvariant();
    }

    private static string MatchAssetName(string[] assetNames, string expected, string prefabId)
    {
        foreach (var name in assetNames)
        {
            if (NormalizeAssetPath(name) == expected)
            {
                return name;
            }
        }
        foreach (var name in assetNames)
        {
            var lower = NormalizeAssetPath(name);
            if (!string.IsNullOrEmpty(prefabId) && lower.EndsWith("/" + prefabId + ".prefab", StringComparison.OrdinalIgnoreCase))
            {
                return name;
            }
        }
        foreach (var name in assetNames)
        {
            if (!string.IsNullOrEmpty(prefabId) && NormalizeAssetPath(name).Contains(prefabId.ToLowerInvariant()))
            {
                return name;
            }
        }
        return "";
    }

    private static PrefabAnalysis AnalyzePrefab(GameObject target)
    {
        var result = new PrefabAnalysis();
        if (target == null)
        {
            return result;
        }
        var components = target.GetComponentsInChildren<Component>(true);
        result.ComponentCount = components.Length;
        result.MissingScriptCount = components.Count(c => c == null);
        var types = components.Where(c => c != null).Select(c => c.GetType().Name).GroupBy(n => n).OrderBy(g => g.Key).ToList();
        result.ComponentTypes = string.Join("|", types.Select(g => g.Key + ":" + g.Count()));
        result.ParticleSystemCount = components.Count(c => c is ParticleSystem);
        result.AnimatorCount = components.Count(c => c is Animator);
        result.AnimationCount = components.Count(c => c is Animation);
        result.PlayableDirectorCount = components.Count(c => c != null && c.GetType().FullName == "UnityEngine.Playables.PlayableDirector");
        var renderers = target.GetComponentsInChildren<Renderer>(true);
        result.RendererCount = renderers.Length;
        var bounds = new Bounds(target.transform.position, Vector3.zero);
        var hasBounds = false;
        foreach (var renderer in renderers)
        {
            if (renderer == null)
            {
                continue;
            }
            if (!hasBounds)
            {
                bounds = renderer.bounds;
                hasBounds = true;
            }
            else
            {
                bounds.Encapsulate(renderer.bounds);
            }
        }
        result.BoundsSize = hasBounds ? Vec(bounds.size) : "0/0/0";
        result.HasNonZeroBounds = hasBounds && bounds.size.sqrMagnitude > 0.0001f;
        return result;
    }

    private static DependencyAnalysis AnalyzeDependencies(GameObject target)
    {
        var result = new DependencyAnalysis();
        if (target == null)
        {
            return result;
        }
        var dependencies = EditorUtility.CollectDependencies(new UnityEngine.Object[] { target });
        var typeCounts = dependencies
            .Where(o => o != null)
            .GroupBy(o => o.GetType().Name)
            .OrderBy(g => g.Key)
            .ToList();
        result.TypeCounts = string.Join("|", typeCounts.Select(g => g.Key + ":" + g.Count()));
        var materials = dependencies.OfType<Material>().Where(m => m != null).ToList();
        result.MaterialCount = materials.Count;
        result.ShaderNames = string.Join("|", materials.Select(m => m.shader != null ? m.shader.name : "<null>").Distinct().OrderBy(n => n));
        result.TextureCount = dependencies.Count(o => o is Texture);
        result.MeshCount = dependencies.Count(o => o is Mesh);
        result.AnimationClipCount = dependencies.Count(o => o is AnimationClip);
        return result;
    }

    private static List<Dictionary<string, string>> ReadCsv(string path)
    {
        var rows = new List<Dictionary<string, string>>();
        if (!File.Exists(path))
        {
            return rows;
        }
        var lines = File.ReadAllLines(path, new UTF8Encoding(false));
        if (lines.Length == 0)
        {
            return rows;
        }
        var headers = SplitCsvLine(lines[0]);
        for (var i = 1; i < lines.Length; i++)
        {
            if (string.IsNullOrWhiteSpace(lines[i]))
            {
                continue;
            }
            var values = SplitCsvLine(lines[i]);
            var row = new Dictionary<string, string>();
            for (var h = 0; h < headers.Count; h++)
            {
                row[headers[h]] = h < values.Count ? values[h] : "";
            }
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
                if (inQuotes && i + 1 < line.Length && line[i + 1] == '"')
                {
                    sb.Append('"');
                    i++;
                }
                else
                {
                    inQuotes = !inQuotes;
                }
            }
            else if (c == ',' && !inQuotes)
            {
                values.Add(sb.ToString());
                sb.Length = 0;
            }
            else
            {
                sb.Append(c);
            }
        }
        values.Add(sb.ToString());
        return values;
    }

    private static void WriteCsv(string path, List<Dictionary<string, string>> rows, string[] headers)
    {
        var sb = new StringBuilder();
        sb.AppendLine(string.Join(",", headers.Select(Escape)));
        foreach (var row in rows)
        {
            sb.AppendLine(string.Join(",", headers.Select(h => Escape(row.ContainsKey(h) ? row[h] : ""))));
        }
        File.WriteAllText(path, sb.ToString(), new UTF8Encoding(false));
    }

    private static string Escape(string value)
    {
        value = value ?? "";
        if (value.Contains(",") || value.Contains("\"") || value.Contains("\n") || value.Contains("\r"))
        {
            return "\"" + value.Replace("\"", "\"\"") + "\"";
        }
        return value;
    }

    private static string Get(Dictionary<string, string> row, string key)
    {
        return row.TryGetValue(key, out var value) ? value.Trim() : "";
    }

    private static string Bool(bool value)
    {
        return value ? "True" : "False";
    }

    private static int CountList(string value)
    {
        if (string.IsNullOrWhiteSpace(value))
        {
            return 0;
        }
        return value.Split(new[] { ';', '|', ',' }, StringSplitOptions.RemoveEmptyEntries).Length;
    }

    private static string FirstNonEmpty(params string[] values)
    {
        return values.FirstOrDefault(v => !string.IsNullOrWhiteSpace(v)) ?? "";
    }

    private static string Vec(Vector3 v)
    {
        return v.x.ToString("0.######") + "/" + v.y.ToString("0.######") + "/" + v.z.ToString("0.######");
    }

    private static void Json(StringBuilder sb, string key, object value, bool comma)
    {
        sb.Append("  \"").Append(key).Append("\": ");
        if (value is bool b)
        {
            sb.Append(b ? "true" : "false");
        }
        else if (value is int || value is long)
        {
            sb.Append(value);
        }
        else
        {
            sb.Append("\"").Append((value ?? "").ToString().Replace("\\", "\\\\").Replace("\"", "\\\"")).Append("\"");
        }
        if (comma)
        {
            sb.Append(",");
        }
        sb.AppendLine();
    }

    private class PrefabAnalysis
    {
        public int ComponentCount;
        public int MissingScriptCount;
        public string ComponentTypes = "";
        public int ParticleSystemCount;
        public int AnimatorCount;
        public int AnimationCount;
        public int PlayableDirectorCount;
        public int RendererCount;
        public string BoundsSize = "0/0/0";
        public bool HasNonZeroBounds;
    }

    private class DependencyAnalysis
    {
        public int MaterialCount;
        public string ShaderNames = "";
        public int TextureCount;
        public int MeshCount;
        public int AnimationClipCount;
        public string TypeCounts = "";
    }
}
