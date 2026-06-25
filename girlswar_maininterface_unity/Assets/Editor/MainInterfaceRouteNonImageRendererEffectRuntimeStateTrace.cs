using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using TMPro;
using UnityEditor;
using UnityEngine;
using UnityEngine.UI;

namespace GirlsWarRestore
{
    public static class MainInterfaceRouteNonImageRendererEffectRuntimeStateTrace
    {
        private const string RendererTraceCsv = "Assets/RestoreData/reports/maininterface_route_renderer_asset_trace.csv";
        private const string ParticleCsv = "Assets/RestoreData/reports/maininterface_route_renderer_particles.csv";
        private const string ClusterNodesCsv = "Assets/RestoreData/reports/maininterface_route_cluster_nodes.csv";
        private const string VisualOverrideCsv = "Assets/RestoreData/maininterface_visual_overrides.csv";
        private const string ResultJson = "Assets/RestoreData/maininterface_route_non_image_renderer_effect_runtime_state_trace.json";
        private const string ResultCsv = "Assets/RestoreData/reports/maininterface_route_non_image_renderer_effect_runtime_state_trace.csv";
        private const string ClickSummaryJson = "Assets/RestoreData/reports/maininterface_click_validation_summary.json";
        private const string CaptureAbsolute = @"C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreCaptures\maininterface_restored_1680x720.png";
        private const string ReportMdAbsolute = @"C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_ROUTE_NON_IMAGE_RENDERER_EFFECT_RUNTIME_STATE_TRACE_RESULT.md";

        public static void Run()
        {
            MainInterfaceSceneBuilder.BuildMainInterfaceScene();

            var rendererRows = LoadCsv(RendererTraceCsv);
            var particleRows = LoadCsv(ParticleCsv);
            var nodeRows = LoadCsv(ClusterNodesCsv);
            var visualRows = LoadCsv(VisualOverrideCsv);
            var nodeByPathId = nodeRows
                .Where(r => !string.IsNullOrWhiteSpace(Get(r, "path_id")))
                .GroupBy(r => Get(r, "path_id"))
                .ToDictionary(g => g.Key, g => g.First(), StringComparer.Ordinal);
            var nodeByGameObjectId = nodeRows
                .Where(r => !string.IsNullOrWhiteSpace(Get(r, "game_object_id")))
                .GroupBy(r => Get(r, "game_object_id"))
                .ToDictionary(g => g.Key, g => g.First(), StringComparer.Ordinal);
            var sceneByPathId = BuildSceneTransformMap();
            var visualOverrideNames = new HashSet<string>(
                visualRows.Select(r => Get(r, "create_child_name")).Where(v => !string.IsNullOrWhiteSpace(v)),
                StringComparer.OrdinalIgnoreCase);

            var rows = new List<TraceRow>();
            AddSkeletonRows(rows, rendererRows, nodeByPathId, sceneByPathId, visualOverrideNames);
            AddFallbackRegionRows(rows, visualRows);
            AddParticleRows(rows, particleRows, nodeByGameObjectId, sceneByPathId);
            AddImportantNodeRows(rows, nodeRows, sceneByPathId);

            rows = rows
                .OrderBy(r => SortBucket(r.category))
                .ThenBy(r => r.owner, StringComparer.OrdinalIgnoreCase)
                .ThenBy(r => r.candidate, StringComparer.OrdinalIgnoreCase)
                .ThenBy(r => r.originalPath, StringComparer.OrdinalIgnoreCase)
                .ToList();

            WriteCsv(rows);
            WriteJson(rows);
            WriteReport(rows);
            AssetDatabase.Refresh();
            Debug.Log("[GirlsWarRestore] Route non-Image renderer/effect runtime state trace complete: " + ResultJson);
        }

        private static void AddSkeletonRows(
            List<TraceRow> rows,
            List<Dictionary<string, string>> rendererRows,
            Dictionary<string, Dictionary<string, string>> nodeByPathId,
            Dictionary<string, RectTransform> sceneByPathId,
            HashSet<string> visualOverrideNames)
        {
            var skeletonRows = rendererRows
                .Where(r => !string.IsNullOrWhiteSpace(Get(r, "skeleton_name")))
                .GroupBy(r => Get(r, "hierarchy_path"))
                .Select(g => g.First())
                .ToList();

            foreach (var row in skeletonRows)
            {
                var pathId = Get(row, "rect_path_id");
                nodeByPathId.TryGetValue(pathId, out var nodeRow);
                sceneByPathId.TryGetValue(pathId, out var rt);
                var candidate = Get(row, "game_object_name");
                var helperCount = rendererRows.Count(r => Get(r, "hierarchy_path").StartsWith(Get(row, "hierarchy_path") + "/", StringComparison.Ordinal)
                    && Get(r, "game_object_name").StartsWith("Renderer", StringComparison.OrdinalIgnoreCase)
                    && Get(r, "component_type") == "MonoBehaviour");
                var activeHelperCount = rendererRows.Count(r => Get(r, "hierarchy_path").StartsWith(Get(row, "hierarchy_path") + "/", StringComparison.Ordinal)
                    && Get(r, "game_object_name").StartsWith("Renderer", StringComparison.OrdinalIgnoreCase)
                    && ParseBool(Get(r, "game_object_active")));

                var trace = NewBaseRow("skeleton_graphic", candidate, row, nodeRow, rt);
                trace.bundle = Get(row, "skeleton_bundle");
                trace.skeletonName = Get(row, "skeleton_name");
                trace.atlasTextAsset = Get(row, "atlas_textasset_path");
                trace.texturePath = Get(row, "texture_path");
                trace.materialRefs = Get(row, "material_refs");
                trace.startingAnimation = Get(row, "starting_animation");
                trace.startingLoop = Get(row, "starting_loop");
                trace.rendererChildCount = helperCount.ToString(CultureInfo.InvariantCulture);
                trace.activeRendererChildCount = activeHelperCount.ToString(CultureInfo.InvariantCulture);
                trace.evidence = Get(row, "note");

                if (candidate.Equals("spine_diqiu", StringComparison.OrdinalIgnoreCase))
                {
                    var hasAllThree = visualOverrideNames.Contains("route_fallback_zhuye_di1")
                        && visualOverrideNames.Contains("route_fallback_diqiu")
                        && visualOverrideNames.Contains("route_fallback_zhuye_bian");
                    trace.actionClass = hasAllThree ? "applyable_already_applied" : "applyable_missing_expected_fallback";
                    trace.decision = hasAllThree
                        ? "keep_existing_three_layer_bitmap_fallback"
                        : "fallback_assets_exist_but_visual_override_rows_missing";
                    trace.reason = "SkeletonGraphic evidence points to Spine_shijieanniu; only atlas regions with clear worldwanfaBtn/frame evidence are allowed. zhuye_di1/diqiu/zhuye_bian are already applied.";
                    trace.newFixApplied = false;
                }
                else if (candidate.Equals("spine_xiaoren", StringComparison.OrdinalIgnoreCase))
                {
                    trace.actionClass = "blocked";
                    trace.decision = "blocked_spine_runtime_slot_bone_animation_required";
                    trace.reason = "8007 texture and SkeletonData are known, but the active node uses animation run at localScale 0.5; applying a whole texture or guessed crop would violate sprite/slot evidence gates.";
                    trace.newFixApplied = false;
                }
                else
                {
                    trace.actionClass = "trace-only";
                    trace.decision = "trace_only_skeleton_runtime_state";
                    trace.reason = "SkeletonGraphic evidence exists, but no safe region-level placement is proven for this node.";
                    trace.newFixApplied = false;
                }

                rows.Add(trace);
            }

            var xiaoshouNode = FindNodeByName(rendererRows, "spine_xiaoshou");
            if (xiaoshouNode != null)
            {
                var pathId = ExtractPathId(Get(xiaoshouNode, "hierarchy_path"));
                nodeByPathId.TryGetValue(pathId, out var nodeRow);
                sceneByPathId.TryGetValue(pathId, out var rt);
                var trace = NewBaseRow("skeleton_helper_chain", "spine_xiaoshou", xiaoshouNode, nodeRow, rt);
                trace.rendererChildCount = rendererRows.Count(r => Get(r, "hierarchy_path").Contains("/spine_xiaoshou(", StringComparison.Ordinal)).ToString(CultureInfo.InvariantCulture);
                trace.activeRendererChildCount = rendererRows.Count(r => Get(r, "hierarchy_path").Contains("/spine_xiaoshou(", StringComparison.Ordinal) && ParseBool(Get(r, "game_object_active"))).ToString(CultureInfo.InvariantCulture);
                trace.actionClass = "trace-only";
                trace.decision = "trace_only_inactive_parent_chain";
                trace.reason = "fanhui_guide_shou active_chain is false in original route cluster evidence, so hand/guide renderers must not be forced visible.";
                rows.Add(trace);
            }
        }

        private static void AddFallbackRegionRows(List<TraceRow> rows, List<Dictionary<string, string>> visualRows)
        {
            var appliedByName = visualRows
                .Where(r => Get(r, "target_kind") == "RouteRendererFallbackLayer")
                .GroupBy(r => Get(r, "create_child_name"), StringComparer.OrdinalIgnoreCase)
                .ToDictionary(g => g.Key, g => g.First(), StringComparer.OrdinalIgnoreCase);

            AddRegion(rows, "zhuye_di1", "route_fallback_zhuye_di1", "253x253", "Spine_shijieanniu_zhuye_di1.png", appliedByName, "applyable_already_applied", "keep_existing_region_layer", "Base disk/frame region matches original worldwanfaBtn 253x253 rect.");
            AddRegion(rows, "diqiu", "route_fallback_diqiu", "704x706 normalized into 253x253", "Spine_shijieanniu_diqiu.png", appliedByName, "applyable_already_applied", "keep_existing_region_layer", "Globe attachment is proven under active spine_diqiu; current fallback is intentionally normalized to the original button rect until Spine runtime is restored.");
            AddRegion(rows, "zhuye_bian", "route_fallback_zhuye_bian", "238x238", "Spine_shijieanniu_zhuye_bian.png", appliedByName, "applyable_already_applied", "keep_existing_region_layer", "Border/rim layer is same skeleton atlas and centered under worldwanfaBtn.");
            AddRegion(rows, "yun", "route_fallback_yun", "83x36", "Spine_shijieanniu_yun.png", appliedByName, "trace-only", "trace_only_slot_transform_missing", "Cloud region is cropped, but original Spine slot/bone transform is not decoded; placing it by eye would be coordinate-only.");
            AddRegion(rows, "yun2", "route_fallback_yun2", "108x65", "Spine_shijieanniu_yun2.png", appliedByName, "trace-only", "trace_only_slot_transform_missing", "Cloud region is cropped, but original Spine slot/bone transform is not decoded; placing it by eye would be coordinate-only.");
        }

        private static void AddRegion(
            List<TraceRow> rows,
            string candidate,
            string childName,
            string regionRect,
            string fileName,
            Dictionary<string, Dictionary<string, string>> appliedByName,
            string actionClass,
            string decision,
            string reason)
        {
            appliedByName.TryGetValue(childName, out var visualRow);
            var assetPath = "Assets/RestoreData/route_renderer_fallbacks/" + fileName;
            var trace = new TraceRow
            {
                category = "atlas_region",
                owner = "worldwanfaBtn",
                candidate = candidate,
                originalName = candidate,
                currentPath = Get(visualRow, "game_object_name"),
                originalPath = "Spine_shijieanniu.atlas/" + candidate,
                currentActiveSelf = !string.IsNullOrWhiteSpace(Get(visualRow, "create_child_name")) ? "True" : "",
                currentActiveInHierarchy = !string.IsNullOrWhiteSpace(Get(visualRow, "create_child_name")) ? "True" : "",
                spriteOrTexture = assetPath,
                texturePath = assetPath,
                textureExists = File.Exists(assetPath).ToString(),
                appliedVisualOverride = (!string.IsNullOrWhiteSpace(Get(visualRow, "create_child_name"))).ToString(),
                regionRect = regionRect,
                actionClass = actionClass,
                decision = decision,
                reason = reason,
                evidence = Get(visualRow, "reason"),
                newFixApplied = false
            };
            rows.Add(trace);
        }

        private static void AddParticleRows(
            List<TraceRow> rows,
            List<Dictionary<string, string>> particleRows,
            Dictionary<string, Dictionary<string, string>> nodeByGameObjectId,
            Dictionary<string, RectTransform> sceneByPathId)
        {
            foreach (var group in particleRows.GroupBy(r => Get(r, "owner_game_object_id")).OrderBy(g => g.Key, StringComparer.Ordinal))
            {
                nodeByGameObjectId.TryGetValue(group.Key, out var nodeRow);
                var pathId = Get(nodeRow, "path_id");
                sceneByPathId.TryGetValue(pathId, out var rt);
                var trace = NewBaseRow("particle_style_effect", "un_MainInterface_fire", null, nodeRow, rt);
                trace.owner = Get(nodeRow, "owner");
                trace.particleRefCount = group.Count().ToString(CultureInfo.InvariantCulture);
                trace.materialRefs = string.Join(";", group.Select(r => Get(r, "particle_material")).Where(v => !string.IsNullOrWhiteSpace(v)).Distinct());
                trace.actionClass = "blocked";
                trace.decision = "blocked_particle_runtime_material_binding";
                trace.reason = "Original owner is inactive and/or zero-scale in route cluster evidence, while particle material/renderer fields are empty in current trace. Forcing it visible would violate active-chain and material evidence gates.";
                trace.evidence = "particle component refs: " + string.Join(";", group.Select(r => Get(r, "particle_component_path_id")));
                trace.newFixApplied = false;
                rows.Add(trace);
            }
        }

        private static void AddImportantNodeRows(List<TraceRow> rows, List<Dictionary<string, string>> nodeRows, Dictionary<string, RectTransform> sceneByPathId)
        {
            var names = new HashSet<string>(StringComparer.OrdinalIgnoreCase)
            {
                "wanfaWorldNode",
                "worldwanfaBtn",
                "world_node_red",
                "fanhui_guide_shou",
                "Entry"
            };

            foreach (var node in nodeRows.Where(r => names.Contains(Get(r, "name")) || Get(r, "name").StartsWith("UI_Main_wanfa_item_", StringComparison.OrdinalIgnoreCase)))
            {
                var pathId = Get(node, "path_id");
                sceneByPathId.TryGetValue(pathId, out var rt);
                var trace = NewBaseRow("route_runtime_state_node", Get(node, "name"), null, node, rt);
                trace.actionClass = "trace-only";
                trace.decision = ClassifyNode(node, rt);
                trace.reason = NodeReason(trace.decision);
                trace.newFixApplied = false;
                rows.Add(trace);
            }
        }

        private static TraceRow NewBaseRow(string category, string candidate, Dictionary<string, string> rendererRow, Dictionary<string, string> nodeRow, RectTransform rt)
        {
            var result = new TraceRow
            {
                category = category,
                owner = FirstNonEmpty(Get(nodeRow, "owner"), Get(rendererRow, "game_object_name")),
                candidate = candidate,
                originalName = FirstNonEmpty(Get(nodeRow, "name"), Get(rendererRow, "game_object_name"), candidate),
                originalPathId = FirstNonEmpty(Get(nodeRow, "path_id"), Get(rendererRow, "rect_path_id"), ExtractPathId(Get(rendererRow, "hierarchy_path"))),
                gameObjectId = FirstNonEmpty(Get(nodeRow, "game_object_id"), Get(rendererRow, "game_object_id")),
                originalPath = FirstNonEmpty(Get(nodeRow, "hierarchy_path"), Get(rendererRow, "hierarchy_path")),
                originalActive = FirstNonEmpty(Get(nodeRow, "original_active"), Get(rendererRow, "game_object_active")),
                originalActiveChain = Get(nodeRow, "active_chain"),
                originalSiblingIndex = Get(nodeRow, "sibling_index"),
                originalSiblingCount = Get(nodeRow, "sibling_count"),
                originalAnchorMin = Get(nodeRow, "anchor_min"),
                originalAnchorMax = Get(nodeRow, "anchor_max"),
                originalPivot = Get(nodeRow, "pivot"),
                originalAnchoredPosition = FirstNonEmpty(Get(nodeRow, "anchored_pos"), Get(rendererRow, "anchored_pos")),
                originalSize = FirstNonEmpty(Get(nodeRow, "original_size"), Get(rendererRow, "size")),
                originalLocalScale = FirstNonEmpty(Get(nodeRow, "original_local_scale"), Get(rendererRow, "local_scale")),
                scriptId = Get(rendererRow, "script_id"),
                componentPathId = Get(rendererRow, "component_path_id")
            };

            if (rt != null)
            {
                result.currentPath = GetPath(rt);
                result.currentActiveSelf = rt.gameObject.activeSelf.ToString();
                result.currentActiveInHierarchy = rt.gameObject.activeInHierarchy.ToString();
                result.currentSiblingIndex = rt.GetSiblingIndex().ToString(CultureInfo.InvariantCulture);
                result.currentAnchorMin = FormatVector2(rt.anchorMin);
                result.currentAnchorMax = FormatVector2(rt.anchorMax);
                result.currentPivot = FormatVector2(rt.pivot);
                result.currentAnchoredPosition = FormatVector2(rt.anchoredPosition);
                result.currentSize = FormatVector2(rt.sizeDelta);
                result.currentLocalScale = FormatVector3(rt.localScale);
                result.components = ComponentSummary(rt.gameObject);
                var image = rt.GetComponent<Image>();
                var tmp = rt.GetComponent<TMP_Text>();
                result.spriteOrTexture = image != null && image.sprite != null ? image.sprite.name : "";
                result.tmpText = tmp != null ? tmp.text : "";
            }
            else
            {
                result.currentPath = "not_found_in_generated_scene";
            }

            return result;
        }

        private static string ClassifyNode(Dictionary<string, string> node, RectTransform rt)
        {
            var name = Get(node, "name");
            if (name == "wanfaWorldNode" || name.StartsWith("UI_Main_wanfa_item_", StringComparison.OrdinalIgnoreCase) || name == "worldwanfaBtn")
                return "preserve_original_route_parent_state";
            if (name == "Entry" && Get(node, "original_local_scale") == "0.0,0.0,0.0")
                return "preserve_original_zero_scale_runtime_state";
            if (name == "fanhui_guide_shou" && !ParseBool(Get(node, "active_chain")))
                return "preserve_original_inactive_guide_state";
            if (name == "world_node_red")
                return "trace_only_redpoint_skeleton_child_inactive";
            return rt == null ? "trace_only_missing_scene_node" : "trace_only_preserve_original_state";
        }

        private static string NodeReason(string decision)
        {
            switch (decision)
            {
                case "preserve_original_route_parent_state":
                    return "Parent layout/active/sibling evidence is already preserved; route mismatch should not be fixed by moving this node.";
                case "preserve_original_zero_scale_runtime_state":
                    return "Entry localScale 0,0,0 is explicit original evidence for item 3/4 and must stay preserved.";
                case "preserve_original_inactive_guide_state":
                    return "Guide hand parent is inactive in original active chain, so its SkeletonGraphic helpers must not be shown.";
                case "trace_only_redpoint_skeleton_child_inactive":
                    return "Redpoint uses a SkeletonGraphic child, but child active chain is false; no safe visual override is applied.";
                default:
                    return "Recorded for hierarchy/runtime-state comparison only.";
            }
        }

        private static Dictionary<string, RectTransform> BuildSceneTransformMap()
        {
            var result = new Dictionary<string, RectTransform>(StringComparer.Ordinal);
            foreach (var rt in UnityEngine.Object.FindObjectsByType<RectTransform>(FindObjectsInactive.Include, FindObjectsSortMode.None))
            {
                var id = ExtractScenePathId(rt.name);
                if (!string.IsNullOrWhiteSpace(id) && !result.ContainsKey(id))
                    result[id] = rt;
            }
            return result;
        }

        private static Dictionary<string, string> FindNodeByName(List<Dictionary<string, string>> rows, string name)
        {
            return rows.FirstOrDefault(r => Get(r, "hierarchy_path").Contains("/" + name + "(", StringComparison.Ordinal) || Get(r, "game_object_name").Equals(name, StringComparison.OrdinalIgnoreCase));
        }

        private static void WriteCsv(List<TraceRow> rows)
        {
            Directory.CreateDirectory(Path.GetDirectoryName(ResultCsv));
            var header = new[]
            {
                "category", "action_class", "decision", "new_fix_applied", "owner", "candidate", "original_name",
                "original_path_id", "game_object_id", "component_path_id", "script_id", "original_path", "current_path",
                "original_active", "original_active_chain", "current_active_self", "current_active_in_hierarchy",
                "original_sibling_index", "current_sibling_index", "original_sibling_count", "original_anchor_min",
                "original_anchor_max", "original_pivot", "original_anchored_position", "original_size",
                "original_local_scale", "current_anchor_min", "current_anchor_max", "current_pivot",
                "current_anchored_position", "current_size", "current_local_scale", "components", "tmp_text",
                "sprite_or_texture", "texture_exists", "applied_visual_override", "region_rect", "bundle",
                "skeleton_name", "atlas_textasset", "texture_path", "material_refs", "starting_animation",
                "starting_loop", "renderer_child_count", "active_renderer_child_count", "particle_ref_count",
                "evidence", "reason"
            };
            var sb = new StringBuilder();
            sb.AppendLine(string.Join(",", header.Select(EscapeCsv)));
            foreach (var row in rows)
            {
                sb.AppendLine(string.Join(",", new[]
                {
                    row.category, row.actionClass, row.decision, row.newFixApplied.ToString(), row.owner, row.candidate, row.originalName,
                    row.originalPathId, row.gameObjectId, row.componentPathId, row.scriptId, row.originalPath, row.currentPath,
                    row.originalActive, row.originalActiveChain, row.currentActiveSelf, row.currentActiveInHierarchy,
                    row.originalSiblingIndex, row.currentSiblingIndex, row.originalSiblingCount, row.originalAnchorMin,
                    row.originalAnchorMax, row.originalPivot, row.originalAnchoredPosition, row.originalSize,
                    row.originalLocalScale, row.currentAnchorMin, row.currentAnchorMax, row.currentPivot,
                    row.currentAnchoredPosition, row.currentSize, row.currentLocalScale, row.components, row.tmpText,
                    row.spriteOrTexture, row.textureExists, row.appliedVisualOverride, row.regionRect, row.bundle,
                    row.skeletonName, row.atlasTextAsset, row.texturePath, row.materialRefs, row.startingAnimation,
                    row.startingLoop, row.rendererChildCount, row.activeRendererChildCount, row.particleRefCount,
                    row.evidence, row.reason
                }.Select(EscapeCsv)));
            }
            File.WriteAllText(ResultCsv, sb.ToString(), Encoding.UTF8);
        }

        private static void WriteJson(List<TraceRow> rows)
        {
            Directory.CreateDirectory(Path.GetDirectoryName(ResultJson));
            var actionGroups = rows.GroupBy(r => r.actionClass).OrderBy(g => g.Key).ToList();
            var decisionGroups = rows.GroupBy(r => r.decision).OrderBy(g => g.Key).ToList();
            var click = LoadClickSummary();
            var captureInfo = CaptureInfo();
            var sb = new StringBuilder();
            sb.AppendLine("{");
            sb.AppendLine("  \"generatedAt\": \"" + EscapeJson(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture)) + "\",");
            sb.AppendLine("  \"visualVerdict\": \"not_normal_trace_only\",");
            sb.AppendLine("  \"newVisualFixApplied\": 0,");
            sb.AppendLine("  \"rowCount\": " + rows.Count.ToString(CultureInfo.InvariantCulture) + ",");
            sb.AppendLine("  \"actionClassCounts\": {");
            for (var i = 0; i < actionGroups.Count; i++)
                sb.AppendLine("    \"" + EscapeJson(actionGroups[i].Key) + "\": " + actionGroups[i].Count().ToString(CultureInfo.InvariantCulture) + (i + 1 == actionGroups.Count ? "" : ","));
            sb.AppendLine("  },");
            sb.AppendLine("  \"decisionCounts\": {");
            for (var i = 0; i < decisionGroups.Count; i++)
                sb.AppendLine("    \"" + EscapeJson(decisionGroups[i].Key) + "\": " + decisionGroups[i].Count().ToString(CultureInfo.InvariantCulture) + (i + 1 == decisionGroups.Count ? "" : ","));
            sb.AppendLine("  },");
            sb.AppendLine("  \"clickValidation\": {");
            sb.AppendLine("    \"generatedAt\": \"" + EscapeJson(Get(click, "generatedAt")) + "\",");
            sb.AppendLine("    \"activeClickableBlockedInvoked\": \"" + EscapeJson(ClickTuple(click)) + "\"");
            sb.AppendLine("  },");
            sb.AppendLine("  \"capture\": {");
            sb.AppendLine("    \"path\": \"" + EscapeJson(CaptureAbsolute) + "\",");
            sb.AppendLine("    \"exists\": " + File.Exists(CaptureAbsolute).ToString().ToLowerInvariant() + ",");
            sb.AppendLine("    \"length\": " + captureInfo.length + ",");
            sb.AppendLine("    \"lastWriteTime\": \"" + EscapeJson(captureInfo.lastWriteTime) + "\"");
            sb.AppendLine("  },");
            sb.AppendLine("  \"csv\": \"" + EscapeJson(ResultCsv) + "\",");
            sb.AppendLine("  \"report\": \"" + EscapeJson(ReportMdAbsolute) + "\",");
            sb.AppendLine("  \"rows\": [");
            for (var i = 0; i < rows.Count; i++)
            {
                var r = rows[i];
                sb.AppendLine("    {");
                sb.AppendLine("      \"category\": \"" + EscapeJson(r.category) + "\",");
                sb.AppendLine("      \"actionClass\": \"" + EscapeJson(r.actionClass) + "\",");
                sb.AppendLine("      \"decision\": \"" + EscapeJson(r.decision) + "\",");
                sb.AppendLine("      \"candidate\": \"" + EscapeJson(r.candidate) + "\",");
                sb.AppendLine("      \"owner\": \"" + EscapeJson(r.owner) + "\",");
                sb.AppendLine("      \"originalPath\": \"" + EscapeJson(r.originalPath) + "\",");
                sb.AppendLine("      \"currentPath\": \"" + EscapeJson(r.currentPath) + "\",");
                sb.AppendLine("      \"reason\": \"" + EscapeJson(r.reason) + "\"");
                sb.AppendLine("    }" + (i + 1 == rows.Count ? "" : ","));
            }
            sb.AppendLine("  ]");
            sb.AppendLine("}");
            File.WriteAllText(ResultJson, sb.ToString(), Encoding.UTF8);
        }

        private static void WriteReport(List<TraceRow> rows)
        {
            Directory.CreateDirectory(Path.GetDirectoryName(ReportMdAbsolute));
            var click = LoadClickSummary();
            var captureInfo = CaptureInfo();
            var actionGroups = rows.GroupBy(r => r.actionClass).OrderBy(g => g.Key).ToList();
            var decisionGroups = rows.GroupBy(r => r.decision).OrderBy(g => g.Key).ToList();

            var sb = new StringBuilder();
            sb.AppendLine("# MainInterface Route Non-Image Renderer/Effect Runtime State Trace Result");
            sb.AppendLine();
            sb.AppendLine("Generated: " + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture) + " KST");
            sb.AppendLine();
            sb.AppendLine("## Verdict");
            sb.AppendLine();
            sb.AppendLine("화면 기준으로 MainInterface는 아직 정상 UI가 아니다. 이번 112 단계에서는 새 visual fix를 적용하지 않았다.");
            sb.AppendLine();
            sb.AppendLine("오른쪽 route cluster의 남은 문제는 `text_name` RectTransform이 아니라 `wanfaWorldNode` 주변의 Spine/SkeletonGraphic/particle-style runtime state 쪽으로 좁혀진다. `Spine_shijieanniu`의 `zhuye_di1`, `diqiu`, `zhuye_bian` 3개 레이어는 이미 evidence 기반 fallback으로 적용되어 있고, `yun/yun2`, `spine_xiaoren/8007`, `un_MainInterface_fire`는 현재 증거만으로는 강제 표시하면 좌표/whole-atlas/런타임 추정 복원이 된다.");
            sb.AppendLine();
            sb.AppendLine("## Counts");
            sb.AppendLine();
            sb.AppendLine("| metric | value |");
            sb.AppendLine("| --- | ---: |");
            sb.AppendLine("| trace rows | " + rows.Count.ToString(CultureInfo.InvariantCulture) + " |");
            foreach (var group in actionGroups)
                sb.AppendLine("| " + EscapeMd(group.Key) + " | " + group.Count().ToString(CultureInfo.InvariantCulture) + " |");
            sb.AppendLine("| new visual fixes applied | 0 |");
            sb.AppendLine();
            sb.AppendLine("## Decision Counts");
            sb.AppendLine();
            sb.AppendLine("| decision | count |");
            sb.AppendLine("| --- | ---: |");
            foreach (var group in decisionGroups)
                sb.AppendLine("| `" + EscapeMd(group.Key) + "` | " + group.Count().ToString(CultureInfo.InvariantCulture) + " |");
            sb.AppendLine();
            sb.AppendLine("## Key Renderer/Effect Decisions");
            sb.AppendLine();
            sb.AppendLine("| candidate | class | decision | evidence | reason |");
            sb.AppendLine("| --- | --- | --- | --- | --- |");
            foreach (var row in rows.Where(IsKeyDecisionRow))
                sb.AppendLine("| `" + EscapeMd(row.candidate) + "` | `" + EscapeMd(row.actionClass) + "` | `" + EscapeMd(row.decision) + "` | " + EscapeMd(ShortEvidence(row)) + " | " + EscapeMd(row.reason) + " |");
            sb.AppendLine();
            sb.AppendLine("## Outputs");
            sb.AppendLine();
            sb.AppendLine("- `Assets/RestoreData/maininterface_route_non_image_renderer_effect_runtime_state_trace.json`");
            sb.AppendLine("- `Assets/RestoreData/reports/maininterface_route_non_image_renderer_effect_runtime_state_trace.csv`");
            sb.AppendLine("- `_restore_tools\\112_TRACE_MAININTERFACE_ROUTE_NON_IMAGE_RENDERER_EFFECT_RUNTIME_STATE.cmd`");
            sb.AppendLine();
            sb.AppendLine("## Verification");
            sb.AppendLine();
            sb.AppendLine("| check | result |");
            sb.AppendLine("| --- | --- |");
            sb.AppendLine("| graphics capture | `" + EscapeMd(CaptureAbsolute) + "` |");
            sb.AppendLine("| capture exists/size | `" + File.Exists(CaptureAbsolute).ToString() + " / " + captureInfo.length + "` |");
            sb.AppendLine("| capture generated | `" + EscapeMd(captureInfo.lastWriteTime) + "` |");
            sb.AppendLine("| click validation generated | `" + EscapeMd(Get(click, "generatedAt")) + "` |");
            sb.AppendLine("| active/clickable/blocked/invoked | `" + EscapeMd(ClickTuple(click)) + "` |");
            sb.AppendLine();
            sb.AppendLine("## Remaining Blocker");
            sb.AppendLine();
            sb.AppendLine("다음 blocker는 `spine_xiaoren/8007`와 `Spine_shijieanniu` 보류 region의 Spine runtime slot/bone/animation transform 복원이다. 현재 단계에서 texture만 더 얹는 것은 원본 runtime state 없이 화면을 꾸미는 방향이라 보류했다.");
            File.WriteAllText(ReportMdAbsolute, sb.ToString(), Encoding.UTF8);
        }

        private static bool IsKeyDecisionRow(TraceRow row)
        {
            return row.category == "skeleton_graphic"
                || row.category == "atlas_region"
                || row.category == "particle_style_effect"
                || row.decision.Contains("guide", StringComparison.OrdinalIgnoreCase)
                || row.decision.Contains("zero_scale", StringComparison.OrdinalIgnoreCase);
        }

        private static string ShortEvidence(TraceRow row)
        {
            if (!string.IsNullOrWhiteSpace(row.skeletonName))
                return row.skeletonName + "; " + row.bundle + "; anim=" + row.startingAnimation + "; renderers=" + row.activeRendererChildCount + "/" + row.rendererChildCount;
            if (!string.IsNullOrWhiteSpace(row.regionRect))
                return row.regionRect + "; applied=" + row.appliedVisualOverride + "; " + row.spriteOrTexture;
            if (!string.IsNullOrWhiteSpace(row.particleRefCount))
                return "particleRefs=" + row.particleRefCount + "; activeChain=" + row.originalActiveChain + "; scale=" + row.originalLocalScale;
            return "activeChain=" + row.originalActiveChain + "; scale=" + row.originalLocalScale;
        }

        private static Dictionary<string, string> LoadClickSummary()
        {
            if (!File.Exists(ClickSummaryJson))
                return new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
            var text = File.ReadAllText(ClickSummaryJson, Encoding.UTF8);
            var result = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
            foreach (Match match in Regex.Matches(text, "\"([^\"]+)\"\\s*:\\s*(\"([^\"]*)\"|[-]?\\d+)"))
            {
                var value = match.Groups[3].Success ? match.Groups[3].Value : match.Groups[2].Value;
                result[match.Groups[1].Value] = value.Trim('"');
            }
            return result;
        }

        private static string ClickTuple(Dictionary<string, string> click)
        {
            return FirstNonEmpty(Get(click, "activeButtons"), "?") + " / "
                + FirstNonEmpty(Get(click, "raycastClickableButtons"), "?") + " / "
                + FirstNonEmpty(Get(click, "raycastBlockedButtons"), "?") + " / "
                + FirstNonEmpty(Get(click, "invokedClicks"), "?");
        }

        private static (string length, string lastWriteTime) CaptureInfo()
        {
            if (!File.Exists(CaptureAbsolute))
                return ("0", "");
            var info = new FileInfo(CaptureAbsolute);
            return (info.Length.ToString(CultureInfo.InvariantCulture), info.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture) + " KST");
        }

        private static int SortBucket(string category)
        {
            switch (category)
            {
                case "skeleton_graphic": return 0;
                case "atlas_region": return 1;
                case "particle_style_effect": return 2;
                case "skeleton_helper_chain": return 3;
                default: return 9;
            }
        }

        private static string ComponentSummary(GameObject go)
        {
            return string.Join(";", go.GetComponents<Component>().Select(c => c == null ? "Missing" : c.GetType().Name));
        }

        private static string GetPath(Transform t)
        {
            var parts = new List<string>();
            while (t != null)
            {
                parts.Add(t.name);
                t = t.parent;
            }
            parts.Reverse();
            return string.Join("/", parts);
        }

        private static string ExtractScenePathId(string name)
        {
            var clean = Regex.Replace(name ?? "", @"__font_.*$", "");
            var match = Regex.Match(clean, @"__([-]?\d+)$");
            return match.Success ? match.Groups[1].Value : "";
        }

        private static string ExtractPathId(string path)
        {
            if (string.IsNullOrWhiteSpace(path))
                return "";
            var match = Regex.Match(path, @"\(([-]?\d+)\)(?!.*\([-]?\d+\))");
            return match.Success ? match.Groups[1].Value : "";
        }

        private static string FormatVector2(Vector2 value)
        {
            return FormatFloat(value.x) + "," + FormatFloat(value.y);
        }

        private static string FormatVector3(Vector3 value)
        {
            return FormatFloat(value.x) + "," + FormatFloat(value.y) + "," + FormatFloat(value.z);
        }

        private static string FormatFloat(float value)
        {
            return value.ToString("0.###", CultureInfo.InvariantCulture);
        }

        private static bool ParseBool(string value)
        {
            return value.Equals("True", StringComparison.OrdinalIgnoreCase) || value == "1";
        }

        private static string FirstNonEmpty(params string[] values)
        {
            foreach (var value in values)
            {
                if (!string.IsNullOrWhiteSpace(value))
                    return value;
            }
            return "";
        }

        private static List<Dictionary<string, string>> LoadCsv(string path)
        {
            if (!File.Exists(path))
                return new List<Dictionary<string, string>>();
            return ParseCsv(File.ReadAllText(path, Encoding.UTF8));
        }

        private static List<Dictionary<string, string>> ParseCsv(string text)
        {
            var rows = new List<List<string>>();
            var row = new List<string>();
            var field = new StringBuilder();
            var inQuotes = false;
            for (var i = 0; i < text.Length; i++)
            {
                var c = text[i];
                if (inQuotes)
                {
                    if (c == '"')
                    {
                        if (i + 1 < text.Length && text[i + 1] == '"')
                        {
                            field.Append('"');
                            i++;
                        }
                        else
                        {
                            inQuotes = false;
                        }
                    }
                    else
                    {
                        field.Append(c);
                    }
                }
                else
                {
                    if (c == '"')
                        inQuotes = true;
                    else if (c == ',')
                    {
                        row.Add(field.ToString());
                        field.Clear();
                    }
                    else if (c == '\n')
                    {
                        row.Add(field.ToString().TrimEnd('\r'));
                        rows.Add(row);
                        row = new List<string>();
                        field.Clear();
                    }
                    else
                        field.Append(c);
                }
            }
            if (field.Length > 0 || row.Count > 0)
            {
                row.Add(field.ToString().TrimEnd('\r'));
                rows.Add(row);
            }
            if (rows.Count == 0)
                return new List<Dictionary<string, string>>();
            var headers = rows[0];
            var result = new List<Dictionary<string, string>>();
            for (var r = 1; r < rows.Count; r++)
            {
                var dict = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
                for (var c = 0; c < headers.Count; c++)
                    dict[headers[c]] = c < rows[r].Count ? rows[r][c] : "";
                result.Add(dict);
            }
            return result;
        }

        private static string Get(Dictionary<string, string> row, string key)
        {
            return row != null && row.TryGetValue(key, out var value) ? value : "";
        }

        private static string EscapeCsv(string value)
        {
            value = value ?? "";
            if (value.Contains(",") || value.Contains("\"") || value.Contains("\n") || value.Contains("\r"))
                return "\"" + value.Replace("\"", "\"\"") + "\"";
            return value;
        }

        private static string EscapeJson(string value)
        {
            return (value ?? "").Replace("\\", "\\\\").Replace("\"", "\\\"").Replace("\r", "\\r").Replace("\n", "\\n");
        }

        private static string EscapeMd(string value)
        {
            return (value ?? "").Replace("|", "\\|");
        }

        private sealed class TraceRow
        {
            public string category = "";
            public string actionClass = "";
            public string decision = "";
            public bool newFixApplied;
            public string owner = "";
            public string candidate = "";
            public string originalName = "";
            public string originalPathId = "";
            public string gameObjectId = "";
            public string componentPathId = "";
            public string scriptId = "";
            public string originalPath = "";
            public string currentPath = "";
            public string originalActive = "";
            public string originalActiveChain = "";
            public string currentActiveSelf = "";
            public string currentActiveInHierarchy = "";
            public string originalSiblingIndex = "";
            public string currentSiblingIndex = "";
            public string originalSiblingCount = "";
            public string originalAnchorMin = "";
            public string originalAnchorMax = "";
            public string originalPivot = "";
            public string originalAnchoredPosition = "";
            public string originalSize = "";
            public string originalLocalScale = "";
            public string currentAnchorMin = "";
            public string currentAnchorMax = "";
            public string currentPivot = "";
            public string currentAnchoredPosition = "";
            public string currentSize = "";
            public string currentLocalScale = "";
            public string components = "";
            public string tmpText = "";
            public string spriteOrTexture = "";
            public string textureExists = "";
            public string appliedVisualOverride = "";
            public string regionRect = "";
            public string bundle = "";
            public string skeletonName = "";
            public string atlasTextAsset = "";
            public string texturePath = "";
            public string materialRefs = "";
            public string startingAnimation = "";
            public string startingLoop = "";
            public string rendererChildCount = "";
            public string activeRendererChildCount = "";
            public string particleRefCount = "";
            public string evidence = "";
            public string reason = "";
        }
    }
}
