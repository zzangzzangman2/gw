using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using UnityEditor;
using UnityEngine;

namespace GirlsWarRestore
{
    public static class MainInterfaceNavigationTargetLoadProbe
    {
        private const string NavigationMapCsv = "Assets/RestoreData/reports/maininterface_button_navigation_map.csv";
        private const string OutputJson = "Assets/RestoreData/maininterface_navigation_target_load_probe.json";
        private const string OutputCsv = "Assets/RestoreData/reports/maininterface_navigation_target_load_probe.csv";

        private sealed class TargetCandidate
        {
            public string key;
            public string targetUiForm;
            public string targetKey;
            public string prefabBundle;
            public string prefabRootName;
            public string confidence;
            public readonly List<string> buttonComponentPathIds = new List<string>();
            public readonly List<string> buttonNames = new List<string>();
        }

        private sealed class ProbeResult
        {
            public TargetCandidate candidate;
            public readonly List<string> bundleCandidates = new List<string>();
            public string selectedBundlePath;
            public bool bundleFileExists;
            public bool assetBundleLoaded;
            public int assetNameCount;
            public readonly List<string> matchingAssetNames = new List<string>();
            public string selectedAssetName;
            public bool prefabLoaded;
            public string loadedPrefabName;
            public string status;
            public string error;
        }

        public static void ProbeTargetLoads()
        {
            var projectRoot = Directory.GetParent(Application.dataPath).FullName;
            var restoreRoot = Directory.GetParent(projectRoot).FullName;
            var mapPath = Path.Combine(projectRoot, NavigationMapCsv.Replace('/', Path.DirectorySeparatorChar));
            var outJson = Path.Combine(projectRoot, OutputJson.Replace('/', Path.DirectorySeparatorChar));
            var outCsv = Path.Combine(projectRoot, OutputCsv.Replace('/', Path.DirectorySeparatorChar));

            var rows = ReadCsv(mapPath);
            var activeRows = rows.Where(r => Get(r, "click_raycast_clickable") == "1").ToList();
            var resolvedRows = activeRows
                .Where(r => Get(r, "target_prefab_resolved") == "1" && !string.IsNullOrWhiteSpace(Get(r, "target_prefab_bundle")))
                .ToList();

            var targets = new Dictionary<string, TargetCandidate>();
            foreach (var row in resolvedRows)
            {
                var bundle = Get(row, "target_prefab_bundle");
                var rootName = Get(row, "target_prefab_root_name");
                var uiForm = Get(row, "target_ui_form");
                var targetKey = Get(row, "target_key");
                var key = bundle + "|" + rootName + "|" + uiForm;
                if (!targets.TryGetValue(key, out var candidate))
                {
                    candidate = new TargetCandidate
                    {
                        key = key,
                        targetUiForm = uiForm,
                        targetKey = targetKey,
                        prefabBundle = bundle,
                        prefabRootName = rootName,
                        confidence = Get(row, "resolved_confidence")
                    };
                    targets[key] = candidate;
                }
                candidate.buttonComponentPathIds.Add(Get(row, "component_path_id"));
                candidate.buttonNames.Add(Get(row, "button_name"));
            }

            var results = targets.Values
                .OrderBy(t => t.prefabBundle, StringComparer.OrdinalIgnoreCase)
                .ThenBy(t => t.prefabRootName, StringComparer.OrdinalIgnoreCase)
                .Select(t => ProbeOne(restoreRoot, t))
                .ToList();

            Directory.CreateDirectory(Path.GetDirectoryName(outJson));
            Directory.CreateDirectory(Path.GetDirectoryName(outCsv));
            File.WriteAllText(outJson, BuildJson(rows.Count, activeRows.Count, resolvedRows.Count, results), new UTF8Encoding(false));
            WriteCsv(outCsv, results);

            AssetDatabase.ImportAsset(OutputJson);
            AssetDatabase.ImportAsset(OutputCsv);
            Debug.Log("[GirlsWarRestore] MainInterface navigation target load probe: loadable="
                + results.Count(r => r.status == "loadable")
                + " failed=" + results.Count(r => r.status == "failed")
                + " uniqueTargets=" + results.Count
                + " -> " + OutputJson);
        }

        private static ProbeResult ProbeOne(string restoreRoot, TargetCandidate candidate)
        {
            var result = new ProbeResult { candidate = candidate, status = "failed" };
            result.bundleCandidates.AddRange(ResolveBundleCandidates(restoreRoot, candidate.prefabBundle));
            var existingCandidates = result.bundleCandidates.Where(File.Exists).ToList();
            result.selectedBundlePath = existingCandidates.FirstOrDefault() ?? "";
            result.bundleFileExists = existingCandidates.Count > 0;

            if (!result.bundleFileExists)
            {
                result.error = "bundle_file_not_found";
                return result;
            }

            AssetBundle bundle = null;
            var loadErrors = new List<string>();
            try
            {
                foreach (var candidatePath in existingCandidates)
                {
                    result.selectedBundlePath = candidatePath;
                    bundle = AssetBundle.LoadFromFile(candidatePath);
                    if (bundle != null)
                    {
                        break;
                    }
                    loadErrors.Add("LoadFromFile returned null: " + candidatePath);
                }

                result.assetBundleLoaded = bundle != null;
                if (bundle == null)
                {
                    result.error = string.Join(" | ", loadErrors);
                    return result;
                }

                var assetNames = bundle.GetAllAssetNames();
                result.assetNameCount = assetNames.Length;
                var rootLower = (candidate.prefabRootName ?? "").ToLowerInvariant();
                foreach (var assetName in assetNames)
                {
                    var stem = Path.GetFileNameWithoutExtension(assetName).ToLowerInvariant();
                    if (stem == rootLower || assetName.ToLowerInvariant().Contains(rootLower))
                    {
                        result.matchingAssetNames.Add(assetName);
                    }
                }

                result.selectedAssetName = result.matchingAssetNames.FirstOrDefault() ?? "";
                GameObject prefab = null;
                if (!string.IsNullOrEmpty(result.selectedAssetName))
                {
                    prefab = bundle.LoadAsset<GameObject>(result.selectedAssetName);
                }
                if (prefab == null && !string.IsNullOrEmpty(candidate.prefabRootName))
                {
                    prefab = bundle.LoadAsset<GameObject>(candidate.prefabRootName);
                    if (prefab != null && string.IsNullOrEmpty(result.selectedAssetName))
                    {
                        result.selectedAssetName = candidate.prefabRootName;
                    }
                }

                result.prefabLoaded = prefab != null;
                result.loadedPrefabName = prefab != null ? prefab.name : "";
                result.status = result.prefabLoaded ? "loadable" : "failed";
                if (!result.prefabLoaded)
                {
                    result.error = result.matchingAssetNames.Count == 0 ? "prefab_asset_name_not_found" : "prefab_load_returned_null";
                }
            }
            catch (Exception ex)
            {
                result.status = "failed";
                result.error = ex.GetType().Name + ": " + ex.Message;
            }
            finally
            {
                if (bundle != null)
                {
                    bundle.Unload(false);
                }
            }

            return result;
        }

        private static IEnumerable<string> ResolveBundleCandidates(string restoreRoot, string bundle)
        {
            var normalized = (bundle ?? "").Replace('/', Path.DirectorySeparatorChar);
            var roots = new[]
            {
                Path.Combine(restoreRoot, "girlswar_merged_extracted", "extracted", "unity", "clean_unityfs_slices"),
                Path.Combine(restoreRoot, "girlswar_merged_extracted", "merged_content", "AssetBundles"),
                Path.Combine(restoreRoot, "girlswar_merged_extracted", "restore_overlay", "Android", "data", "com.girlwars.kr", "files", "build")
            };
            return roots.Select(root => Path.Combine(root, normalized)).Distinct(StringComparer.OrdinalIgnoreCase);
        }

        private static string BuildJson(int navigationRows, int activeRows, int resolvedButtonRows, List<ProbeResult> results)
        {
            var loadable = results.Count(r => r.status == "loadable");
            var failed = results.Count(r => r.status == "failed");
            var sb = new StringBuilder();
            sb.AppendLine("{");
            AppendJsonProp(sb, "generatedAt", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"), 1, true);
            AppendJsonProp(sb, "navigationMapRows", navigationRows.ToString(), 1, true, false);
            AppendJsonProp(sb, "activeClickableRows", activeRows.ToString(), 1, true, false);
            AppendJsonProp(sb, "targetPrefabResolvedButtonRows", resolvedButtonRows.ToString(), 1, true, false);
            AppendJsonProp(sb, "uniqueTargetCandidates", results.Count.ToString(), 1, true, false);
            AppendJsonProp(sb, "loadableUniqueTargets", loadable.ToString(), 1, true, false);
            AppendJsonProp(sb, "failedUniqueTargets", failed.ToString(), 1, true, false);
            AppendJsonProp(sb, "logOnlyOrUnknownButtonRows", Math.Max(0, activeRows - resolvedButtonRows).ToString(), 1, true, false);
            sb.AppendLine("  \"targets\": [");
            for (var i = 0; i < results.Count; i++)
            {
                var r = results[i];
                sb.AppendLine("    {");
                AppendJsonProp(sb, "targetUiForm", r.candidate.targetUiForm, 3, true);
                AppendJsonProp(sb, "targetKey", r.candidate.targetKey, 3, true);
                AppendJsonProp(sb, "prefabBundle", r.candidate.prefabBundle, 3, true);
                AppendJsonProp(sb, "prefabRootName", r.candidate.prefabRootName, 3, true);
                AppendJsonProp(sb, "confidence", r.candidate.confidence, 3, true);
                AppendJsonArray(sb, "buttonComponentPathIds", r.candidate.buttonComponentPathIds, 3, true);
                AppendJsonArray(sb, "buttonNames", r.candidate.buttonNames, 3, true);
                AppendJsonArray(sb, "bundleCandidates", r.bundleCandidates, 3, true);
                AppendJsonProp(sb, "selectedBundlePath", r.selectedBundlePath, 3, true);
                AppendJsonProp(sb, "bundleFileExists", r.bundleFileExists ? "true" : "false", 3, true, false);
                AppendJsonProp(sb, "assetBundleLoaded", r.assetBundleLoaded ? "true" : "false", 3, true, false);
                AppendJsonProp(sb, "assetNameCount", r.assetNameCount.ToString(), 3, true, false);
                AppendJsonArray(sb, "matchingAssetNames", r.matchingAssetNames, 3, true);
                AppendJsonProp(sb, "selectedAssetName", r.selectedAssetName, 3, true);
                AppendJsonProp(sb, "prefabLoaded", r.prefabLoaded ? "true" : "false", 3, true, false);
                AppendJsonProp(sb, "loadedPrefabName", r.loadedPrefabName, 3, true);
                AppendJsonProp(sb, "status", r.status, 3, true);
                AppendJsonProp(sb, "error", r.error, 3, false);
                sb.Append("    }");
                sb.AppendLine(i + 1 < results.Count ? "," : "");
            }
            sb.AppendLine("  ]");
            sb.AppendLine("}");
            return sb.ToString();
        }

        private static void WriteCsv(string path, List<ProbeResult> results)
        {
            var sb = new StringBuilder();
            sb.AppendLine("target_ui_form,target_key,prefab_bundle,prefab_root_name,button_component_path_ids,button_names,selected_bundle_path,bundle_file_exists,asset_bundle_loaded,asset_name_count,matching_asset_names,selected_asset_name,prefab_loaded,loaded_prefab_name,status,error");
            foreach (var r in results)
            {
                var values = new[]
                {
                    r.candidate.targetUiForm,
                    r.candidate.targetKey,
                    r.candidate.prefabBundle,
                    r.candidate.prefabRootName,
                    string.Join(";", r.candidate.buttonComponentPathIds),
                    string.Join(";", r.candidate.buttonNames),
                    r.selectedBundlePath,
                    r.bundleFileExists ? "1" : "0",
                    r.assetBundleLoaded ? "1" : "0",
                    r.assetNameCount.ToString(CultureInfo.InvariantCulture),
                    string.Join(";", r.matchingAssetNames),
                    r.selectedAssetName,
                    r.prefabLoaded ? "1" : "0",
                    r.loadedPrefabName,
                    r.status,
                    r.error
                };
                sb.AppendLine(string.Join(",", values.Select(EscapeCsv)));
            }
            File.WriteAllText(path, sb.ToString(), new UTF8Encoding(false));
        }

        private static List<Dictionary<string, string>> ReadCsv(string path)
        {
            var result = new List<Dictionary<string, string>>();
            if (!File.Exists(path))
            {
                return result;
            }

            var lines = File.ReadAllLines(path, Encoding.UTF8);
            if (lines.Length == 0)
            {
                return result;
            }

            var headers = ParseCsvLine(lines[0]);
            for (var i = 1; i < lines.Length; i++)
            {
                if (string.IsNullOrWhiteSpace(lines[i]))
                {
                    continue;
                }

                var values = ParseCsvLine(lines[i]);
                var row = new Dictionary<string, string>();
                for (var j = 0; j < headers.Count; j++)
                {
                    row[headers[j]] = j < values.Count ? values[j] : "";
                }
                result.Add(row);
            }
            return result;
        }

        private static List<string> ParseCsvLine(string line)
        {
            var values = new List<string>();
            var current = new StringBuilder();
            var inQuotes = false;
            for (var i = 0; i < line.Length; i++)
            {
                var c = line[i];
                if (c == '"')
                {
                    if (inQuotes && i + 1 < line.Length && line[i + 1] == '"')
                    {
                        current.Append('"');
                        i++;
                    }
                    else
                    {
                        inQuotes = !inQuotes;
                    }
                }
                else if (c == ',' && !inQuotes)
                {
                    values.Add(current.ToString());
                    current.Length = 0;
                }
                else
                {
                    current.Append(c);
                }
            }
            values.Add(current.ToString());
            return values;
        }

        private static string Get(Dictionary<string, string> row, string key)
        {
            return row.TryGetValue(key, out var value) ? value ?? "" : "";
        }

        private static void AppendJsonProp(StringBuilder sb, string name, string value, int indent, bool comma, bool quote = true)
        {
            sb.Append(new string(' ', indent * 2));
            sb.Append('"').Append(EscapeJson(name)).Append("\": ");
            if (quote)
            {
                sb.Append('"').Append(EscapeJson(value ?? "")).Append('"');
            }
            else
            {
                sb.Append(value ?? "");
            }
            sb.AppendLine(comma ? "," : "");
        }

        private static void AppendJsonArray(StringBuilder sb, string name, List<string> values, int indent, bool comma)
        {
            sb.Append(new string(' ', indent * 2));
            sb.Append('"').Append(EscapeJson(name)).Append("\": [");
            for (var i = 0; i < values.Count; i++)
            {
                sb.Append('"').Append(EscapeJson(values[i] ?? "")).Append('"');
                if (i + 1 < values.Count)
                {
                    sb.Append(", ");
                }
            }
            sb.Append(']');
            sb.AppendLine(comma ? "," : "");
        }

        private static string EscapeCsv(string value)
        {
            value = value ?? "";
            if (value.Contains(",") || value.Contains("\"") || value.Contains("\n") || value.Contains("\r"))
            {
                return "\"" + value.Replace("\"", "\"\"") + "\"";
            }
            return value;
        }

        private static string EscapeJson(string value)
        {
            value = value ?? "";
            return value
                .Replace("\\", "\\\\")
                .Replace("\"", "\\\"")
                .Replace("\r", "\\r")
                .Replace("\n", "\\n");
        }
    }
}
