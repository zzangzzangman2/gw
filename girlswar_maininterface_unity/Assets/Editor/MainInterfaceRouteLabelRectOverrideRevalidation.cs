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
    public static class MainInterfaceRouteLabelRectOverrideRevalidation
    {
        private const string ClusterNodesCsv = "Assets/RestoreData/reports/maininterface_route_cluster_nodes.csv";
        private const string ClusterComponentsCsv = "Assets/RestoreData/reports/maininterface_route_cluster_components.csv";
        private const string RouteTmpCsv = "Assets/RestoreData/reports/maininterface_route_tmp_state_after_material.csv";
        private const string OverrideCsv = "Assets/RestoreData/maininterface_route_rect_overrides.csv";
        private const string ResultJson = "Assets/RestoreData/maininterface_route_label_rect_override_revalidation.json";
        private const string ResultCsv = "Assets/RestoreData/reports/maininterface_route_label_rect_override_revalidation.csv";
        private const string ReportMdAbsolute = @"C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_ROUTE_LABEL_RECT_OVERRIDE_REVALIDATION_RESULT.md";

        private static readonly HashSet<string> RemovedTextOverrideRectIds = new HashSet<string>
        {
            "-3578904844754949875",
            "-6275118336609310875"
        };

        private static readonly HashSet<string> KeptEntryScaleOverrideRectIds = new HashSet<string>
        {
            "-2663983105510939953",
            "-249494615586118723"
        };

        public static void Run()
        {
            MainInterfaceSceneBuilder.BuildMainInterfaceScene();
            var nodeEvidence = LoadEvidenceRows(ClusterNodesCsv, "path_id");
            var tmpEvidence = LoadTmpRows();
            var componentEvidence = LoadComponentRows();
            var overrideIds = new HashSet<string>(LoadCsv(OverrideCsv).Select(r => Get(r, "rect_path_id")));

            var rows = CollectRows(nodeEvidence, tmpEvidence, componentEvidence, overrideIds);
            WriteCsv(rows);
            WriteJson(rows);
            WriteReport(rows);
            AssetDatabase.Refresh();
            Debug.Log("[GirlsWarRestore] Route label rect override revalidation complete: " + ResultJson);
        }

        private static Dictionary<string, Dictionary<string, string>> LoadEvidenceRows(string path, string key)
        {
            var result = new Dictionary<string, Dictionary<string, string>>();
            foreach (var row in LoadCsv(path))
            {
                var id = Get(row, key);
                if (!string.IsNullOrWhiteSpace(id))
                    result[id] = row;
            }
            return result;
        }

        private static Dictionary<string, Dictionary<string, string>> LoadTmpRows()
        {
            var result = new Dictionary<string, Dictionary<string, string>>();
            foreach (var row in LoadCsv(RouteTmpCsv))
            {
                var path = Get(row, "hierarchy_path");
                var id = ExtractPathId(path);
                if (!string.IsNullOrWhiteSpace(id))
                    result[id] = row;
            }
            return result;
        }

        private static Dictionary<string, List<Dictionary<string, string>>> LoadComponentRows()
        {
            var result = new Dictionary<string, List<Dictionary<string, string>>>();
            foreach (var row in LoadCsv(ClusterComponentsCsv))
            {
                var path = Get(row, "hierarchy_path");
                var id = ExtractPathId(path);
                if (string.IsNullOrWhiteSpace(id))
                    continue;
                if (!result.TryGetValue(id, out var list))
                {
                    list = new List<Dictionary<string, string>>();
                    result[id] = list;
                }
                list.Add(row);
            }
            return result;
        }

        private static List<AuditRow> CollectRows(
            Dictionary<string, Dictionary<string, string>> nodeEvidence,
            Dictionary<string, Dictionary<string, string>> tmpEvidence,
            Dictionary<string, List<Dictionary<string, string>>> componentEvidence,
            HashSet<string> overrideIds)
        {
            var result = new List<AuditRow>();
            var transforms = UnityEngine.Object.FindObjectsByType<RectTransform>(FindObjectsInactive.Include, FindObjectsSortMode.None);
            foreach (var rt in transforms)
            {
                var path = GetPath(rt);
                if (!IsRouteClusterPath(path))
                    continue;

                var rectId = ExtractScenePathId(rt.name);
                if (string.IsNullOrWhiteSpace(rectId))
                    continue;

                nodeEvidence.TryGetValue(rectId, out var nodeRow);
                tmpEvidence.TryGetValue(rectId, out var tmpRow);
                componentEvidence.TryGetValue(rectId, out var componentRows);

                var tmp = rt.GetComponent<TMP_Text>();
                var image = rt.GetComponent<Image>();
                var button = rt.GetComponent<Button>();
                var worldCorners = new Vector3[4];
                rt.GetWorldCorners(worldCorners);

                var row = new AuditRow
                {
                    rectPathId = rectId,
                    name = CleanSceneName(rt.name),
                    owner = FindOwner(path),
                    path = path,
                    activeSelf = rt.gameObject.activeSelf,
                    activeInHierarchy = rt.gameObject.activeInHierarchy,
                    siblingIndex = rt.GetSiblingIndex(),
                    anchorMin = FormatVector2(rt.anchorMin),
                    anchorMax = FormatVector2(rt.anchorMax),
                    pivot = FormatVector2(rt.pivot),
                    anchoredPosition = FormatVector2(rt.anchoredPosition),
                    sizeDelta = FormatVector2(rt.sizeDelta),
                    localScale = FormatVector3(rt.localScale),
                    worldBounds = FormatBounds(worldCorners),
                    originalActive = Get(nodeRow, "original_active"),
                    originalActiveChain = Get(nodeRow, "active_chain"),
                    originalAnchoredPosition = Get(nodeRow, "anchored_pos"),
                    originalSize = Get(nodeRow, "original_size"),
                    originalLocalScale = Get(nodeRow, "original_local_scale"),
                    originalSiblingIndex = Get(nodeRow, "sibling_index"),
                    originalPivot = Get(nodeRow, "pivot"),
                    originalAnchorMin = Get(nodeRow, "anchor_min"),
                    originalAnchorMax = Get(nodeRow, "anchor_max"),
                    tmpText = tmp != null ? tmp.text : "",
                    tmpFontSize = tmp != null ? FormatFloat(tmp.fontSize) : "",
                    tmpAlignment = tmp != null ? tmp.alignment.ToString() : "",
                    tmpOverflowMode = tmp != null ? tmp.overflowMode.ToString() : "",
                    tmpWordWrapping = tmp != null ? tmp.enableWordWrapping.ToString() : "",
                    tmpMaterial = tmp != null && tmp.fontSharedMaterial != null ? tmp.fontSharedMaterial.name : "",
                    imageSprite = image != null && image.sprite != null ? image.sprite.name : "",
                    imageRaycastTarget = image != null ? image.raycastTarget.ToString() : "",
                    buttonInteractable = button != null ? button.interactable.ToString() : "",
                    objectLayoutComponents = LayoutComponentSummary(rt.gameObject),
                    parentLayoutComponents = rt.parent != null ? LayoutComponentSummary(rt.parent.gameObject) : "",
                    componentEvidence = SummarizeComponents(componentRows),
                    overridePresent = overrideIds.Contains(rectId),
                    decision = ClassifyDecision(rectId, rt, tmp, nodeRow, overrideIds)
                };
                result.Add(row);
            }

            return result
                .OrderBy(r => OwnerSortKey(r.owner))
                .ThenBy(r => r.siblingIndex)
                .ThenBy(r => r.name, StringComparer.OrdinalIgnoreCase)
                .ToList();
        }

        private static string ClassifyDecision(string rectId, RectTransform rt, TMP_Text tmp, Dictionary<string, string> nodeRow, HashSet<string> overrideIds)
        {
            if (RemovedTextOverrideRectIds.Contains(rectId))
            {
                var originalSize = Get(nodeRow, "original_size");
                var hasLayoutEvidence = HasLayoutComponent(rt.gameObject) || (rt.parent != null && HasLayoutComponent(rt.parent.gameObject));
                var isOriginalZeroHeight = originalSize.EndsWith("x0.0", StringComparison.Ordinal) || originalSize.EndsWith("x0", StringComparison.Ordinal);
                if (isOriginalZeroHeight && !hasLayoutEvidence && tmp != null && tmp.overflowMode == TextOverflowModes.Overflow)
                    return "remove_text_size_override_preserve_original_zero_height";
                return "removed_text_size_override_trace_only";
            }

            if (KeptEntryScaleOverrideRectIds.Contains(rectId))
            {
                var originalScale = Get(nodeRow, "original_local_scale");
                if (originalScale == "0.0,0.0,0.0" && rt.localScale == Vector3.zero && overrideIds.Contains(rectId))
                    return "keep_entry_zero_scale_override_original_evidence";
                return "entry_scale_override_requires_attention";
            }

            if (overrideIds.Contains(rectId))
                return "other_override_present";

            if (IsImmediateRouteOwner(rt.name))
                return "preserve_original_route_owner_transform";
            if (tmp != null && ContainsAny(tmp.text, "모험", "전", "국", "개최 중"))
                return "preserve_original_tmp_rect";
            return "trace_only";
        }

        private static void WriteCsv(List<AuditRow> rows)
        {
            Directory.CreateDirectory(Path.GetDirectoryName(ResultCsv));
            var header = new[]
            {
                "owner", "name", "rect_path_id", "path", "active_self", "active_in_hierarchy", "sibling_index",
                "original_sibling_index", "anchor_min", "anchor_max", "pivot", "anchored_position", "size_delta",
                "local_scale", "world_bounds", "original_active", "original_active_chain", "original_anchor_min",
                "original_anchor_max", "original_pivot", "original_anchored_position", "original_size",
                "original_local_scale", "tmp_text", "tmp_font_size", "tmp_alignment", "tmp_overflow_mode",
                "tmp_word_wrapping", "tmp_material", "image_sprite", "image_raycast_target", "button_interactable",
                "object_layout_components", "parent_layout_components", "component_evidence", "override_present", "decision"
            };
            var sb = new StringBuilder();
            sb.AppendLine(string.Join(",", header.Select(EscapeCsv)));
            foreach (var row in rows)
            {
                sb.AppendLine(string.Join(",", new[]
                {
                    row.owner, row.name, row.rectPathId, row.path, row.activeSelf.ToString(), row.activeInHierarchy.ToString(), row.siblingIndex.ToString(CultureInfo.InvariantCulture),
                    row.originalSiblingIndex, row.anchorMin, row.anchorMax, row.pivot, row.anchoredPosition, row.sizeDelta,
                    row.localScale, row.worldBounds, row.originalActive, row.originalActiveChain, row.originalAnchorMin,
                    row.originalAnchorMax, row.originalPivot, row.originalAnchoredPosition, row.originalSize,
                    row.originalLocalScale, row.tmpText, row.tmpFontSize, row.tmpAlignment, row.tmpOverflowMode,
                    row.tmpWordWrapping, row.tmpMaterial, row.imageSprite, row.imageRaycastTarget, row.buttonInteractable,
                    row.objectLayoutComponents, row.parentLayoutComponents, row.componentEvidence, row.overridePresent.ToString(), row.decision
                }.Select(EscapeCsv)));
            }
            File.WriteAllText(ResultCsv, sb.ToString(), Encoding.UTF8);
        }

        private static void WriteJson(List<AuditRow> rows)
        {
            Directory.CreateDirectory(Path.GetDirectoryName(ResultJson));
            var removedTextRows = rows.Where(r => RemovedTextOverrideRectIds.Contains(r.rectPathId)).ToList();
            var keptEntryRows = rows.Where(r => KeptEntryScaleOverrideRectIds.Contains(r.rectPathId)).ToList();
            var routeLabelRows = rows.Where(r => ContainsAny(r.tmpText, "모험", "전", "국")).ToList();
            var decisions = rows.GroupBy(r => r.decision).OrderBy(g => g.Key).ToList();
            var sb = new StringBuilder();
            sb.AppendLine("{");
            sb.AppendLine("  \"generatedAt\": \"" + EscapeJson(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture)) + "\",");
            sb.AppendLine("  \"visualVerdict\": \"not_normal_after_revalidation\",");
            sb.AppendLine("  \"rowCount\": " + rows.Count.ToString(CultureInfo.InvariantCulture) + ",");
            sb.AppendLine("  \"routeLabelRows\": " + routeLabelRows.Count.ToString(CultureInfo.InvariantCulture) + ",");
            sb.AppendLine("  \"removedTextSizeOverrides\": " + removedTextRows.Count.ToString(CultureInfo.InvariantCulture) + ",");
            sb.AppendLine("  \"keptEntryScaleOverrides\": " + keptEntryRows.Count.ToString(CultureInfo.InvariantCulture) + ",");
            sb.AppendLine("  \"clickValidationExpected\": \"24 / 24 / 0 / 24\",");
            sb.AppendLine("  \"decisions\": {");
            for (var i = 0; i < decisions.Count; i++)
            {
                var suffix = i + 1 == decisions.Count ? "" : ",";
                sb.AppendLine("    \"" + EscapeJson(decisions[i].Key) + "\": " + decisions[i].Count().ToString(CultureInfo.InvariantCulture) + suffix);
            }
            sb.AppendLine("  },");
            sb.AppendLine("  \"csv\": \"" + EscapeJson(ResultCsv) + "\"");
            sb.AppendLine("}");
            File.WriteAllText(ResultJson, sb.ToString(), Encoding.UTF8);
        }

        private static void WriteReport(List<AuditRow> rows)
        {
            Directory.CreateDirectory(Path.GetDirectoryName(ReportMdAbsolute));
            var removedTextRows = rows.Where(r => RemovedTextOverrideRectIds.Contains(r.rectPathId)).ToList();
            var keptEntryRows = rows.Where(r => KeptEntryScaleOverrideRectIds.Contains(r.rectPathId)).ToList();
            var routeLabels = rows.Where(r => ContainsAny(r.tmpText, "모험", "전", "국")).ToList();
            var sb = new StringBuilder();
            sb.AppendLine("# MainInterface Route Label Rect Override Revalidation Result");
            sb.AppendLine();
            sb.AppendLine("Generated: " + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture) + " KST");
            sb.AppendLine();
            sb.AppendLine("## Verdict");
            sb.AppendLine();
            sb.AppendLine("화면 기준으로 MainInterface는 아직 정상 UI가 아니다. 오른쪽 route cluster는 여전히 원본처럼 보인다고 판정할 수 없다.");
            sb.AppendLine();
            sb.AppendLine("이번 변경은 좌표 보정이 아니라 기존 좌표성 보정 제거다. `UI_Main_wanfa_item_3/4/text_name`의 원본 `sizeDelta.y=0`은 active TMP + `Overflow` 조합으로 기록되어 있고, `200x35` override의 근거는 sibling 추정뿐이라 hard gate 기준을 통과하지 못했다. 따라서 두 text size override를 제거하고 원본 `200x0`을 보존한다.");
            sb.AppendLine();
            sb.AppendLine("`Entry` localScale override 2개는 원본 `0,0,0` evidence가 명확하므로 유지한다.");
            sb.AppendLine();
            sb.AppendLine("## Counts");
            sb.AppendLine();
            sb.AppendLine("| metric | value |");
            sb.AppendLine("| --- | ---: |");
            sb.AppendLine("| route audit rows | " + rows.Count.ToString(CultureInfo.InvariantCulture) + " |");
            sb.AppendLine("| route label TMP rows | " + routeLabels.Count.ToString(CultureInfo.InvariantCulture) + " |");
            sb.AppendLine("| removed text size overrides | " + removedTextRows.Count.ToString(CultureInfo.InvariantCulture) + " |");
            sb.AppendLine("| kept Entry zero-scale overrides | " + keptEntryRows.Count.ToString(CultureInfo.InvariantCulture) + " |");
            sb.AppendLine();
            sb.AppendLine("## Override Decisions");
            sb.AppendLine();
            sb.AppendLine("| owner | node | rect pathID | original size/scale | current size/scale | layout evidence | decision |");
            sb.AppendLine("| --- | --- | --- | --- | --- | --- | --- |");
            foreach (var row in removedTextRows.Concat(keptEntryRows))
            {
                sb.AppendLine("| `" + EscapeMd(row.owner) + "` | `" + EscapeMd(row.name) + "` | `" + EscapeMd(row.rectPathId) + "` | `" + EscapeMd(row.originalSize + " / " + row.originalLocalScale) + "` | `" + EscapeMd(row.sizeDelta + " / " + row.localScale) + "` | `" + EscapeMd((row.objectLayoutComponents + " " + row.parentLayoutComponents).Trim()) + "` | `" + EscapeMd(row.decision) + "` |");
            }
            sb.AppendLine();
            sb.AppendLine("## Route Labels");
            sb.AppendLine();
            sb.AppendLine("| owner | text | rect pathID | original size | current size | pivot | overflow | material | decision |");
            sb.AppendLine("| --- | --- | --- | --- | --- | --- | --- | --- | --- |");
            foreach (var row in routeLabels)
            {
                sb.AppendLine("| `" + EscapeMd(row.owner) + "` | `" + EscapeMd(row.tmpText) + "` | `" + EscapeMd(row.rectPathId) + "` | `" + EscapeMd(row.originalSize) + "` | `" + EscapeMd(row.sizeDelta) + "` | `" + EscapeMd(row.pivot) + "` | `" + EscapeMd(row.tmpOverflowMode) + "` | `" + EscapeMd(row.tmpMaterial) + "` | `" + EscapeMd(row.decision) + "` |");
            }
            sb.AppendLine();
            sb.AppendLine("## Outputs");
            sb.AppendLine();
            sb.AppendLine("- `Assets/RestoreData/maininterface_route_label_rect_override_revalidation.json`");
            sb.AppendLine("- `Assets/RestoreData/reports/maininterface_route_label_rect_override_revalidation.csv`");
            sb.AppendLine("- `Assets/RestoreCaptures/maininterface_restored_1680x720.png` after tool 111");
            File.WriteAllText(ReportMdAbsolute, sb.ToString(), Encoding.UTF8);
        }

        private static string LayoutComponentSummary(GameObject gameObject)
        {
            var names = new List<string>();
            if (gameObject.GetComponent<ContentSizeFitter>() != null)
                names.Add("ContentSizeFitter");
            if (gameObject.GetComponent<HorizontalOrVerticalLayoutGroup>() != null)
                names.Add("LayoutGroup");
            if (gameObject.GetComponent<GridLayoutGroup>() != null)
                names.Add("GridLayoutGroup");
            if (gameObject.GetComponent<LayoutElement>() != null)
                names.Add("LayoutElement");
            if (gameObject.GetComponent<Mask>() != null)
                names.Add("Mask");
            if (gameObject.GetComponent<RectMask2D>() != null)
                names.Add("RectMask2D");
            if (gameObject.GetComponent<CanvasGroup>() != null)
                names.Add("CanvasGroup");
            return string.Join(";", names);
        }

        private static bool HasLayoutComponent(GameObject gameObject)
        {
            return !string.IsNullOrWhiteSpace(LayoutComponentSummary(gameObject));
        }

        private static string SummarizeComponents(List<Dictionary<string, string>> rows)
        {
            if (rows == null || rows.Count == 0)
                return "";
            return string.Join(";", rows.Select(r => Get(r, "component") + ":" + Get(r, "sprite_or_text")).Distinct());
        }

        private static bool IsRouteClusterPath(string path)
        {
            return path.Contains("/node_middle__", StringComparison.Ordinal)
                && (path.Contains("/UI_Main_wanfa_item_", StringComparison.Ordinal) || path.Contains("/wanfaWorldNode__", StringComparison.Ordinal));
        }

        private static bool IsImmediateRouteOwner(string name)
        {
            return name.Contains("UI_Main_wanfa_item_", StringComparison.Ordinal) || name.Contains("wanfaWorldNode", StringComparison.Ordinal);
        }

        private static string FindOwner(string path)
        {
            var match = Regex.Match(path, @"(UI_Main_wanfa_item_[1-4]|wanfaWorldNode)__");
            return match.Success ? match.Groups[1].Value : "";
        }

        private static int OwnerSortKey(string owner)
        {
            if (owner == "wanfaWorldNode")
                return 0;
            if (owner.EndsWith("_1", StringComparison.Ordinal))
                return 1;
            if (owner.EndsWith("_2", StringComparison.Ordinal))
                return 2;
            if (owner.EndsWith("_3", StringComparison.Ordinal))
                return 3;
            if (owner.EndsWith("_4", StringComparison.Ordinal))
                return 4;
            return 99;
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
            var clean = Regex.Replace(name, @"__font_.*$", "");
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

        private static string CleanSceneName(string name)
        {
            return Regex.Replace(Regex.Replace(name, @"__font_.*$", ""), @"__[-]?\d+$", "");
        }

        private static string FormatBounds(Vector3[] corners)
        {
            var minX = corners.Min(c => c.x);
            var minY = corners.Min(c => c.y);
            var maxX = corners.Max(c => c.x);
            var maxY = corners.Max(c => c.y);
            return FormatFloat(minX) + "," + FormatFloat(minY) + "," + FormatFloat(maxX) + "," + FormatFloat(maxY);
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

        private static bool ContainsAny(string value, params string[] tokens)
        {
            if (string.IsNullOrEmpty(value))
                return false;
            return tokens.Any(t => value.IndexOf(t, StringComparison.OrdinalIgnoreCase) >= 0);
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

        private sealed class AuditRow
        {
            public string owner;
            public string name;
            public string rectPathId;
            public string path;
            public bool activeSelf;
            public bool activeInHierarchy;
            public int siblingIndex;
            public string anchorMin;
            public string anchorMax;
            public string pivot;
            public string anchoredPosition;
            public string sizeDelta;
            public string localScale;
            public string worldBounds;
            public string originalActive;
            public string originalActiveChain;
            public string originalAnchoredPosition;
            public string originalSize;
            public string originalLocalScale;
            public string originalSiblingIndex;
            public string originalPivot;
            public string originalAnchorMin;
            public string originalAnchorMax;
            public string tmpText;
            public string tmpFontSize;
            public string tmpAlignment;
            public string tmpOverflowMode;
            public string tmpWordWrapping;
            public string tmpMaterial;
            public string imageSprite;
            public string imageRaycastTarget;
            public string buttonInteractable;
            public string objectLayoutComponents;
            public string parentLayoutComponents;
            public string componentEvidence;
            public bool overridePresent;
            public string decision;
        }
    }
}
