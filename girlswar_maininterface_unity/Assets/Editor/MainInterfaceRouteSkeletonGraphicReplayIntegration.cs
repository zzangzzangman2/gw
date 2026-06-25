using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;

namespace GirlsWarRestore
{
    public static class MainInterfaceRouteSkeletonGraphicReplayIntegration
    {
        private const string ScenePath = "Assets/Scenes/MainInterface_Wireframe.unity";
        private const string RendererTraceCsv = "Assets/RestoreData/reports/maininterface_route_renderer_asset_trace.csv";
        private const string RawDecodeJson = "Assets/RestoreData/maininterface_route_spinegraphic_runtime_replay_raw_skeleton_decode_recovery.json";
        private const string ResultJson = "Assets/RestoreData/maininterface_route_skeletongraphic_replay_integration.json";
        private const string ResultCsv = "Assets/RestoreData/reports/maininterface_route_skeletongraphic_replay_integration.csv";

        [MenuItem("GirlsWar/Trace MainInterface Route SkeletonGraphic Replay Integration")]
        public static void TraceRouteSkeletonGraphicReplayIntegration()
        {
            Directory.CreateDirectory("Assets/RestoreData/reports");
            var result = new IntegrationResult
            {
                generatedAt = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
                status = "started",
                visualFixApplied = 0,
                rows = new List<IntegrationRow>(),
                targets = new List<IntegrationTarget>()
            };

            try
            {
                MainInterfaceSceneBuilder.BuildMainInterfaceScene();
                EditorSceneManager.OpenScene(ScenePath, OpenSceneMode.Single);

                var routeRows = LoadCsv(RendererTraceCsv);
                var summaries = LoadRawDecodeSummaries(RawDecodeJson);
                var mainRuntime = ProbeMainProjectSpineRuntime();
                var probeRuntime = ProbeExternalSpineProbeRuntime();

                result.mainProjectSkeletonGraphicTypeAvailable = mainRuntime.skeletonGraphicTypeAvailable;
                result.mainProjectSkeletonDataAssetTypeAvailable = mainRuntime.skeletonDataAssetTypeAvailable;
                result.mainProjectAtlasAssetTypeAvailable = mainRuntime.atlasAssetTypeAvailable;
                result.mainProjectSpineRuntimeAvailable = mainRuntime.IsReady;
                result.probeProjectSkeletonGraphicSourceAvailable = probeRuntime.skeletonGraphicSourceAvailable;
                result.probeProjectSkeletonDataAssetSourceAvailable = probeRuntime.skeletonDataAssetSourceAvailable;
                result.probeProjectRuntimeAvailable = probeRuntime.IsReady;

                TraceTarget("Spine_shijieanniu", "spine_diqiu", summaries, routeRows, mainRuntime, probeRuntime, result);
                TraceTarget("8007", "spine_xiaoren", summaries, routeRows, mainRuntime, probeRuntime, result);

                result.integrableTargets = result.targets.Count(t => t.integrationDecision == "applyable_skeletongraphic_replay_ready");
                result.blockedTargets = result.targets.Count(t => t.integrationDecision.StartsWith("blocked_", StringComparison.Ordinal));
                result.traceOnlyTargets = result.targets.Count(t => t.integrationDecision.StartsWith("trace_only", StringComparison.Ordinal));
                result.status = "route_skeletongraphic_replay_integration_trace_complete";
                result.visualVerdict = result.visualFixApplied > 0
                    ? "visual_changed_requires_manual_review"
                    : "not_normal_trace_only_no_visual_fix";
                result.blocker = result.integrableTargets > 0
                    ? "Integration conditions are met, but this trace tool intentionally did not mutate the scene without a separate minimal replay patch."
                    : "MainInterface project lacks a real Spine.Unity runtime/imported SkeletonDataAsset path, so probe-recovered skeletons cannot yet be replayed as SkeletonGraphic in the MainInterface scene.";
            }
            catch (Exception ex)
            {
                result.status = "route_skeletongraphic_replay_integration_trace_failed";
                result.visualVerdict = "not_normal_trace_failed";
                result.blocker = ex.GetType().Name + ": " + ex.Message;
                Debug.LogException(ex);
                WriteOutputs(result);
                throw;
            }

            WriteOutputs(result);
            Debug.Log("[GirlsWarRestore] UI115 route SkeletonGraphic replay integration trace: " + ResultJson);
        }

        private static void TraceTarget(
            string skeletonKey,
            string nodeName,
            Dictionary<string, RawDecodeSummary> summaries,
            List<Dictionary<string, string>> routeRows,
            RuntimeProbe mainRuntime,
            ExternalProbeRuntime probeRuntime,
            IntegrationResult result)
        {
            var target = new IntegrationTarget
            {
                skeletonKey = skeletonKey,
                originalNode = nodeName,
                visualFixApplied = false
            };
            result.targets.Add(target);

            var skeletonRow = routeRows.FirstOrDefault(r =>
                EqualsIgnoreCase(Get(r, "game_object_name"), nodeName)
                && EqualsIgnoreCase(Get(r, "component_type"), "MonoBehaviour")
                && !string.IsNullOrWhiteSpace(Get(r, "skeleton_name"))
                && Get(r, "note").IndexOf("SkeletonGraphic", StringComparison.OrdinalIgnoreCase) >= 0);
            if (skeletonRow == null)
            {
                target.integrationDecision = "blocked_original_skeletongraphic_row_missing";
                target.blocker = "No SkeletonGraphic-like MonoBehaviour row was found in " + RendererTraceCsv;
                AddTargetRow(result, target, null, "original_renderer_trace", "missing", target.integrationDecision, target.blocker);
                return;
            }

            target.originalHierarchyPath = Get(skeletonRow, "hierarchy_path");
            target.originalComponentPathId = Get(skeletonRow, "component_path_id");
            target.originalScriptId = Get(skeletonRow, "script_id");
            target.originalSkeletonName = Get(skeletonRow, "skeleton_name");
            target.originalSkeletonBundle = Get(skeletonRow, "skeleton_bundle");
            target.originalAnimation = Get(skeletonRow, "starting_animation");
            target.originalLoop = Get(skeletonRow, "starting_loop");
            target.originalRectPathId = Get(skeletonRow, "rect_path_id");
            target.originalAnchoredPosition = Get(skeletonRow, "anchored_pos");
            target.originalSize = Get(skeletonRow, "size");
            target.originalLocalScale = Get(skeletonRow, "local_scale");
            target.originalAtlasTextAssetPath = Get(skeletonRow, "atlas_textasset_path");
            target.originalTexturePath = Get(skeletonRow, "texture_path");
            target.originalMaterialRefs = Get(skeletonRow, "material_refs");

            var sceneNode = FindSceneNodeByPathId(nodeName, target.originalRectPathId);
            if (sceneNode != null)
            {
                target.sceneNodeFound = true;
                target.sceneObjectPath = GetTransformPath(sceneNode);
                target.sceneActiveInHierarchy = sceneNode.gameObject.activeInHierarchy;
                target.sceneSiblingIndex = sceneNode.GetSiblingIndex();
                target.sceneParentPath = sceneNode.parent != null ? GetTransformPath(sceneNode.parent) : "";
                target.sceneAnchoredPosition = FormatVector2(sceneNode.anchoredPosition);
                target.sceneSize = FormatVector2(sceneNode.sizeDelta);
                target.sceneLocalScale = FormatVector3(sceneNode.localScale);
                target.sceneHasImageComponent = sceneNode.GetComponent<UnityEngine.UI.Image>() != null;
                target.sceneHasAnyMonoBehaviour = sceneNode.GetComponents<MonoBehaviour>().Length > 0;
            }

            if (summaries.TryGetValue(skeletonKey, out var summary))
            {
                target.rawDecodeRecovered = summary.decodeRecovered;
                target.rawDecodeBoneCount = summary.boneCount;
                target.rawDecodeSlotCount = summary.slotCount;
                target.rawDecodeAnimationCount = summary.animationCount;
                target.rawDecodeAnimationFound = summary.animationFound;
                target.rawDecodeDecision = summary.decision;
            }
            else
            {
                target.rawDecodeDecision = "missing_raw_decode_summary";
            }

            target.originalEvidenceComplete =
                !string.IsNullOrWhiteSpace(target.originalHierarchyPath)
                && !string.IsNullOrWhiteSpace(target.originalSkeletonName)
                && !string.IsNullOrWhiteSpace(target.originalSkeletonBundle)
                && !string.IsNullOrWhiteSpace(target.originalAnimation)
                && !string.IsNullOrWhiteSpace(target.originalAtlasTextAssetPath)
                && !string.IsNullOrWhiteSpace(target.originalTexturePath)
                && !string.IsNullOrWhiteSpace(target.originalMaterialRefs);
            target.mainProjectRuntimeAvailable = mainRuntime.IsReady;
            target.probeProjectRuntimeAvailable = probeRuntime.IsReady;
            target.rawAssetsImportedInMainProject = HasMainProjectImportedRawAssets(skeletonKey);
            target.canReplayInMainScene =
                target.originalEvidenceComplete
                && target.sceneNodeFound
                && target.rawDecodeRecovered
                && target.rawDecodeAnimationFound
                && target.mainProjectRuntimeAvailable
                && target.rawAssetsImportedInMainProject;

            if (!target.sceneNodeFound)
            {
                target.integrationDecision = "blocked_scene_node_missing";
                target.blocker = "Generated MainInterface scene does not contain the original Spine node by pathID/name.";
            }
            else if (!target.originalEvidenceComplete)
            {
                target.integrationDecision = "blocked_original_skeleton_material_evidence_incomplete";
                target.blocker = "Original SkeletonGraphic row is missing skeleton/material/atlas/texture/animation evidence.";
            }
            else if (!target.rawDecodeRecovered || !target.rawDecodeAnimationFound)
            {
                target.integrationDecision = "blocked_raw_decode_or_animation_missing";
                target.blocker = "UI114 raw decode summary does not prove usable SkeletonData plus requested animation.";
            }
            else if (!mainRuntime.IsReady)
            {
                target.integrationDecision = "blocked_main_project_missing_spine_runtime";
                target.blocker = "Spine.Unity.SkeletonGraphic/SkeletonDataAsset/AtlasAsset types are not available in girlswar_maininterface_unity.";
            }
            else if (!target.rawAssetsImportedInMainProject)
            {
                target.integrationDecision = "blocked_main_project_raw_skeleton_assets_not_imported";
                target.blocker = "Raw SkeletonDataAsset exists only in the Spine probe project; MainInterface has no imported SkeletonDataAsset to assign.";
            }
            else
            {
                target.integrationDecision = "applyable_skeletongraphic_replay_ready";
                target.blocker = "";
            }

            AddTargetRow(result, target, skeletonRow, "original_skeletongraphic", "evidence", target.integrationDecision, target.blocker);
        }

        private static RuntimeProbe ProbeMainProjectSpineRuntime()
        {
            return new RuntimeProbe
            {
                skeletonGraphicTypeAvailable = FindType("Spine.Unity.SkeletonGraphic") != null,
                skeletonDataAssetTypeAvailable = FindType("Spine.Unity.SkeletonDataAsset") != null,
                atlasAssetTypeAvailable = FindType("Spine.Unity.AtlasAsset") != null || FindType("Spine.Unity.SpineAtlasAsset") != null
            };
        }

        private static ExternalProbeRuntime ProbeExternalSpineProbeRuntime()
        {
            var result = new ExternalProbeRuntime();
            var basePath = FindGirlsWarBase();
            var pointer = Path.Combine(basePath, "_restore_tools", "work", "spine40_unity6000_probe_latest.txt");
            result.probePointerPath = pointer;
            if (!File.Exists(pointer))
                return result;

            result.probeProjectPath = File.ReadAllText(pointer, Encoding.UTF8).Trim('\uFEFF').Trim();
            if (string.IsNullOrWhiteSpace(result.probeProjectPath) || !Directory.Exists(result.probeProjectPath))
                return result;

            result.skeletonGraphicSourceAvailable = File.Exists(Path.Combine(result.probeProjectPath, "Assets", "Spine", "Runtime", "spine-unity", "Components", "SkeletonGraphic.cs"));
            result.skeletonDataAssetSourceAvailable = File.Exists(Path.Combine(result.probeProjectPath, "Assets", "Spine", "Runtime", "spine-unity", "Asset Types", "SkeletonDataAsset.cs"));
            result.spineUnityAsmdefAvailable = File.Exists(Path.Combine(result.probeProjectPath, "Assets", "Spine", "Runtime", "spine-unity.asmdef"));
            return result;
        }

        private static bool HasMainProjectImportedRawAssets(string skeletonKey)
        {
            var root = "Assets/RestoreData/route_spine_raw_decode_recovery/" + skeletonKey;
            if (!AssetDatabase.IsValidFolder(root))
                return false;
            var guids = AssetDatabase.FindAssets("t:Object", new[] { root });
            return guids.Any(g =>
            {
                var path = AssetDatabase.GUIDToAssetPath(g);
                return path.EndsWith("_SkeletonData.asset", StringComparison.OrdinalIgnoreCase);
            });
        }

        private static Type FindType(string fullName)
        {
            foreach (var assembly in AppDomain.CurrentDomain.GetAssemblies())
            {
                Type type = null;
                try { type = assembly.GetType(fullName, false); }
                catch { }
                if (type != null)
                    return type;
            }
            return null;
        }

        private static RectTransform FindSceneNodeByPathId(string nodeName, string rectPathId)
        {
            var all = UnityEngine.Object.FindObjectsByType<RectTransform>(FindObjectsInactive.Include, FindObjectsSortMode.None);
            foreach (var rt in all)
            {
                if (rt == null)
                    continue;
                var name = rt.gameObject.name;
                if (name.StartsWith(nodeName + "__", StringComparison.Ordinal)
                    && name.EndsWith("__" + rectPathId, StringComparison.Ordinal))
                    return rt;
            }
            foreach (var rt in all)
            {
                if (rt != null && rt.gameObject.name.StartsWith(nodeName + "__", StringComparison.Ordinal))
                    return rt;
            }
            return null;
        }

        private static Dictionary<string, RawDecodeSummary> LoadRawDecodeSummaries(string path)
        {
            var result = new Dictionary<string, RawDecodeSummary>(StringComparer.OrdinalIgnoreCase);
            if (!File.Exists(path))
                return result;
            var json = File.ReadAllText(path, Encoding.UTF8);
            var parsed = JsonUtility.FromJson<RawDecodeResult>(json);
            if (parsed == null || parsed.summaries == null)
                return result;
            foreach (var summary in parsed.summaries)
            {
                if (summary != null && !string.IsNullOrWhiteSpace(summary.key))
                    result[summary.key] = summary;
            }
            return result;
        }

        private static List<Dictionary<string, string>> LoadCsv(string path)
        {
            var rows = new List<Dictionary<string, string>>();
            if (!File.Exists(path))
                return rows;
            var lines = File.ReadAllLines(path, Encoding.UTF8);
            if (lines.Length == 0)
                return rows;
            var header = SplitCsvLine(lines[0]).ToArray();
            for (var i = 1; i < lines.Length; i++)
            {
                if (string.IsNullOrWhiteSpace(lines[i]))
                    continue;
                var values = SplitCsvLine(lines[i]).ToArray();
                var row = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
                for (var j = 0; j < header.Length; j++)
                    row[header[j]] = j < values.Length ? values[j] : "";
                rows.Add(row);
            }
            return rows;
        }

        private static IEnumerable<string> SplitCsvLine(string line)
        {
            var sb = new StringBuilder();
            var inQuotes = false;
            for (var i = 0; i < line.Length; i++)
            {
                var ch = line[i];
                if (ch == '"')
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
                else if (ch == ',' && !inQuotes)
                {
                    yield return sb.ToString();
                    sb.Length = 0;
                }
                else
                {
                    sb.Append(ch);
                }
            }
            yield return sb.ToString();
        }

        private static void AddTargetRow(
            IntegrationResult result,
            IntegrationTarget target,
            Dictionary<string, string> sourceRow,
            string evidenceKind,
            string rowKind,
            string decision,
            string detail)
        {
            result.rows.Add(new IntegrationRow
            {
                skeletonKey = target.skeletonKey,
                originalNode = target.originalNode,
                evidenceKind = evidenceKind,
                rowKind = rowKind,
                originalHierarchyPath = target.originalHierarchyPath,
                sceneObjectPath = target.sceneObjectPath,
                componentPathId = target.originalComponentPathId,
                scriptId = target.originalScriptId,
                skeletonName = target.originalSkeletonName,
                skeletonBundle = target.originalSkeletonBundle,
                animation = target.originalAnimation,
                originalRect = "pos=" + target.originalAnchoredPosition + ";size=" + target.originalSize + ";scale=" + target.originalLocalScale,
                sceneRect = "pos=" + target.sceneAnchoredPosition + ";size=" + target.sceneSize + ";scale=" + target.sceneLocalScale,
                rawDecode = string.Format(CultureInfo.InvariantCulture, "recovered={0};bones={1};slots={2};animations={3};animationFound={4}",
                    target.rawDecodeRecovered,
                    target.rawDecodeBoneCount,
                    target.rawDecodeSlotCount,
                    target.rawDecodeAnimationCount,
                    target.rawDecodeAnimationFound),
                runtimeAvailability = string.Format(CultureInfo.InvariantCulture, "mainSpineRuntime={0};probeRuntime={1};rawAssetsInMain={2}",
                    target.mainProjectRuntimeAvailable,
                    target.probeProjectRuntimeAvailable,
                    target.rawAssetsImportedInMainProject),
                decision = decision,
                detail = detail
            });
        }

        private static void WriteOutputs(IntegrationResult result)
        {
            File.WriteAllText(ResultJson, JsonUtility.ToJson(result, true), Encoding.UTF8);
            var sb = new StringBuilder();
            sb.AppendLine("skeletonKey,originalNode,evidenceKind,rowKind,originalHierarchyPath,sceneObjectPath,componentPathId,scriptId,skeletonName,skeletonBundle,animation,originalRect,sceneRect,rawDecode,runtimeAvailability,decision,detail");
            foreach (var row in result.rows)
            {
                sb.Append(Csv(row.skeletonKey)).Append(',');
                sb.Append(Csv(row.originalNode)).Append(',');
                sb.Append(Csv(row.evidenceKind)).Append(',');
                sb.Append(Csv(row.rowKind)).Append(',');
                sb.Append(Csv(row.originalHierarchyPath)).Append(',');
                sb.Append(Csv(row.sceneObjectPath)).Append(',');
                sb.Append(Csv(row.componentPathId)).Append(',');
                sb.Append(Csv(row.scriptId)).Append(',');
                sb.Append(Csv(row.skeletonName)).Append(',');
                sb.Append(Csv(row.skeletonBundle)).Append(',');
                sb.Append(Csv(row.animation)).Append(',');
                sb.Append(Csv(row.originalRect)).Append(',');
                sb.Append(Csv(row.sceneRect)).Append(',');
                sb.Append(Csv(row.rawDecode)).Append(',');
                sb.Append(Csv(row.runtimeAvailability)).Append(',');
                sb.Append(Csv(row.decision)).Append(',');
                sb.Append(Csv(row.detail)).AppendLine();
            }
            File.WriteAllText(ResultCsv, sb.ToString(), Encoding.UTF8);
            AssetDatabase.Refresh(ImportAssetOptions.ForceSynchronousImport);
        }

        private static string FindGirlsWarBase()
        {
            var dir = new DirectoryInfo(Application.dataPath);
            for (var i = 0; i < 8 && dir != null; i++, dir = dir.Parent)
            {
                if (File.Exists(Path.Combine(dir.FullName, "00_COMMAND_CENTER.cmd")) && Directory.Exists(Path.Combine(dir.FullName, "_restore_tools")))
                    return dir.FullName;
            }
            throw new Exception("Could not locate girlswar base from " + Application.dataPath);
        }

        private static string GetTransformPath(Transform transform)
        {
            var stack = new Stack<string>();
            var current = transform;
            while (current != null)
            {
                stack.Push(current.name);
                current = current.parent;
            }
            return string.Join("/", stack.ToArray());
        }

        private static string Get(Dictionary<string, string> row, string key)
        {
            return row != null && row.TryGetValue(key, out var value) ? value ?? "" : "";
        }

        private static bool EqualsIgnoreCase(string left, string right)
        {
            return string.Equals(left, right, StringComparison.OrdinalIgnoreCase);
        }

        private static string FormatVector2(Vector2 value)
        {
            return value.x.ToString("0.####", CultureInfo.InvariantCulture) + "," + value.y.ToString("0.####", CultureInfo.InvariantCulture);
        }

        private static string FormatVector3(Vector3 value)
        {
            return value.x.ToString("0.####", CultureInfo.InvariantCulture) + "," + value.y.ToString("0.####", CultureInfo.InvariantCulture) + "," + value.z.ToString("0.####", CultureInfo.InvariantCulture);
        }

        private static string Csv(string value)
        {
            value = value ?? "";
            return "\"" + value.Replace("\"", "\"\"") + "\"";
        }

        private sealed class RuntimeProbe
        {
            public bool skeletonGraphicTypeAvailable;
            public bool skeletonDataAssetTypeAvailable;
            public bool atlasAssetTypeAvailable;
            public bool IsReady => skeletonGraphicTypeAvailable && skeletonDataAssetTypeAvailable && atlasAssetTypeAvailable;
        }

        private sealed class ExternalProbeRuntime
        {
            public string probePointerPath;
            public string probeProjectPath;
            public bool skeletonGraphicSourceAvailable;
            public bool skeletonDataAssetSourceAvailable;
            public bool spineUnityAsmdefAvailable;
            public bool IsReady => skeletonGraphicSourceAvailable && skeletonDataAssetSourceAvailable && spineUnityAsmdefAvailable;
        }

        [Serializable]
        private sealed class RawDecodeResult
        {
            public List<RawDecodeSummary> summaries;
        }

        [Serializable]
        private sealed class RawDecodeSummary
        {
            public string key;
            public bool decodeRecovered;
            public bool animationFound;
            public int boneCount;
            public int slotCount;
            public int animationCount;
            public string decision;
        }

        [Serializable]
        private sealed class IntegrationResult
        {
            public string generatedAt;
            public string status;
            public string visualVerdict;
            public int visualFixApplied;
            public int integrableTargets;
            public int blockedTargets;
            public int traceOnlyTargets;
            public bool mainProjectSkeletonGraphicTypeAvailable;
            public bool mainProjectSkeletonDataAssetTypeAvailable;
            public bool mainProjectAtlasAssetTypeAvailable;
            public bool mainProjectSpineRuntimeAvailable;
            public bool probeProjectSkeletonGraphicSourceAvailable;
            public bool probeProjectSkeletonDataAssetSourceAvailable;
            public bool probeProjectRuntimeAvailable;
            public string blocker;
            public List<IntegrationTarget> targets;
            public List<IntegrationRow> rows;
        }

        [Serializable]
        private sealed class IntegrationTarget
        {
            public string skeletonKey;
            public string originalNode;
            public string originalHierarchyPath;
            public string originalComponentPathId;
            public string originalScriptId;
            public string originalSkeletonName;
            public string originalSkeletonBundle;
            public string originalAnimation;
            public string originalLoop;
            public string originalRectPathId;
            public string originalAnchoredPosition;
            public string originalSize;
            public string originalLocalScale;
            public string originalAtlasTextAssetPath;
            public string originalTexturePath;
            public string originalMaterialRefs;
            public bool originalEvidenceComplete;
            public bool sceneNodeFound;
            public string sceneObjectPath;
            public bool sceneActiveInHierarchy;
            public int sceneSiblingIndex;
            public string sceneParentPath;
            public string sceneAnchoredPosition;
            public string sceneSize;
            public string sceneLocalScale;
            public bool sceneHasImageComponent;
            public bool sceneHasAnyMonoBehaviour;
            public bool rawDecodeRecovered;
            public int rawDecodeBoneCount;
            public int rawDecodeSlotCount;
            public int rawDecodeAnimationCount;
            public bool rawDecodeAnimationFound;
            public string rawDecodeDecision;
            public bool mainProjectRuntimeAvailable;
            public bool probeProjectRuntimeAvailable;
            public bool rawAssetsImportedInMainProject;
            public bool canReplayInMainScene;
            public bool visualFixApplied;
            public string integrationDecision;
            public string blocker;
        }

        [Serializable]
        private sealed class IntegrationRow
        {
            public string skeletonKey;
            public string originalNode;
            public string evidenceKind;
            public string rowKind;
            public string originalHierarchyPath;
            public string sceneObjectPath;
            public string componentPathId;
            public string scriptId;
            public string skeletonName;
            public string skeletonBundle;
            public string animation;
            public string originalRect;
            public string sceneRect;
            public string rawDecode;
            public string runtimeAvailability;
            public string decision;
            public string detail;
        }
    }
}
