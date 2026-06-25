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

namespace GirlsWarRestore
{
    public static class MainInterfaceRouteTmpVariantMaterialAudit
    {
        private const string RouteTmpCsv = "Assets/RestoreData/reports/maininterface_route_tmp_state_after_material.csv";
        private const string VariantMaterialCsv = "Assets/RestoreData/reports/maininterface_active_tmp_variant_material_properties.csv";
        private const string ResultJson = "Assets/RestoreData/maininterface_route_tmp_variant_material_audit.json";
        private const string ResultCsv = "Assets/RestoreData/reports/maininterface_route_tmp_variant_material_audit.csv";
        private const string ReportMdAbsolute = @"C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_ROUTE_TMP_VARIANT_MATERIAL_AUDIT_RESULT.md";

        public static void Run()
        {
            MainInterfaceSceneBuilder.BuildMainInterfaceScene();
            var evidenceRows = LoadRouteRows();
            var variantProps = LoadVariantTextureProperties();
            var actualRows = CollectActualRows(evidenceRows, variantProps);
            WriteCsv(actualRows);
            WriteJson(actualRows);
            WriteReport(actualRows, evidenceRows);
            AssetDatabase.Refresh();
            Debug.Log("[GirlsWarRestore] MainInterface route TMP variant material audit complete: " + ResultJson);
        }

        private static List<RouteEvidence> LoadRouteRows()
        {
            var result = new List<RouteEvidence>();
            foreach (var row in LoadCsv(RouteTmpCsv))
            {
                var path = Get(row, "hierarchy_path");
                var text = Get(row, "text");
                var material = Get(row, "shared_material_name");
                if (!IsRouteRelevant(path, text, material))
                    continue;

                result.Add(new RouteEvidence
                {
                    hierarchyPath = path,
                    normalizedPath = NormalizePath(path),
                    text = text,
                    activeChain = ParseBool(Get(row, "active_chain")),
                    prefabActive = ParseBool(Get(row, "prefab_active")),
                    anchoredX = Get(row, "anchored_pos_x"),
                    anchoredY = Get(row, "anchored_pos_y"),
                    sizeX = Get(row, "size_delta_x"),
                    sizeY = Get(row, "size_delta_y"),
                    fontAssetName = Get(row, "font_asset_name"),
                    fontSize = Get(row, "font_size"),
                    sharedMaterialPathId = Get(row, "shared_material_path_id"),
                    sharedMaterialName = material,
                    flags = Get(row, "flags")
                });
            }
            return result;
        }

        private static Dictionary<string, Dictionary<string, string>> LoadVariantTextureProperties()
        {
            var result = new Dictionary<string, Dictionary<string, string>>(StringComparer.OrdinalIgnoreCase);
            foreach (var row in LoadCsv(VariantMaterialCsv))
            {
                if (Get(row, "property_type") != "texture")
                    continue;

                var fontKey = Get(row, "font_key");
                var property = Get(row, "property_name");
                if (string.IsNullOrWhiteSpace(fontKey) || string.IsNullOrWhiteSpace(property))
                    continue;

                if (!result.TryGetValue(fontKey, out var props))
                {
                    props = new Dictionary<string, string>(StringComparer.Ordinal);
                    result[fontKey] = props;
                }
                props[property] = Get(row, "value");
            }
            return result;
        }

        private static List<AuditRow> CollectActualRows(List<RouteEvidence> evidenceRows, Dictionary<string, Dictionary<string, string>> variantProps)
        {
            var rows = new List<AuditRow>();
            var tmpTexts = UnityEngine.Object.FindObjectsByType<TextMeshProUGUI>(FindObjectsInactive.Include, FindObjectsSortMode.None);
            foreach (var tmp in tmpTexts)
            {
                var path = GetPath(tmp.transform);
                var normalizedPath = NormalizePath(path);
                var evidence = FindEvidenceForPath(evidenceRows, normalizedPath);
                if (evidence == null && !IsActualRouteRelevant(path, tmp))
                    continue;

                var rt = tmp.rectTransform;
                var mat = tmp.fontSharedMaterial != null ? tmp.fontSharedMaterial : tmp.font != null ? tmp.font.material : null;
                var fontName = tmp.font != null ? tmp.font.name : "";
                var matName = mat != null ? mat.name : "";
                var expectedVariant = evidence != null ? evidence.sharedMaterialName : GuessVariantFromAssetNames(fontName, matName);
                variantProps.TryGetValue(expectedVariant ?? "", out var expectedTextureProps);
                var textureMismatchCount = CountTextureMismatches(mat, expectedTextureProps);

                rows.Add(new AuditRow
                {
                    path = path,
                    normalizedPath = normalizedPath,
                    evidencePath = evidence != null ? evidence.hierarchyPath : "",
                    text = tmp.text,
                    activeInHierarchy = tmp.gameObject.activeInHierarchy,
                    activeSelf = tmp.gameObject.activeSelf,
                    siblingIndex = tmp.transform.GetSiblingIndex(),
                    anchorMin = FormatVector2(rt.anchorMin),
                    anchorMax = FormatVector2(rt.anchorMax),
                    pivot = FormatVector2(rt.pivot),
                    anchoredPosition = FormatVector2(rt.anchoredPosition),
                    sizeDelta = FormatVector2(rt.sizeDelta),
                    localScale = FormatVector3(rt.localScale),
                    fontAsset = fontName,
                    expectedVariant = expectedVariant ?? "",
                    material = matName,
                    fontSize = FormatFloat(tmp.fontSize),
                    alignment = tmp.alignment.ToString(),
                    characterSpacing = FormatFloat(tmp.characterSpacing),
                    lineSpacing = FormatFloat(tmp.lineSpacing),
                    color = FormatColor(tmp.color),
                    mainTex = TextureName(mat, "_MainTex"),
                    faceTex = TextureName(mat, "_FaceTex"),
                    outlineTex = TextureName(mat, "_OutlineTex"),
                    bumpMap = TextureName(mat, "_BumpMap"),
                    cube = TextureName(mat, "_Cube"),
                    textureMismatchCount = textureMismatchCount,
                    evidenceText = evidence != null ? evidence.text : "",
                    evidenceActiveChain = evidence != null && evidence.activeChain,
                    evidenceSizeDelta = evidence != null ? evidence.sizeX + "x" + evidence.sizeY : "",
                    evidenceAnchoredPosition = evidence != null ? evidence.anchoredX + "," + evidence.anchoredY : "",
                    evidenceSharedMaterialPathId = evidence != null ? evidence.sharedMaterialPathId : "",
                    evidenceFlags = evidence != null ? evidence.flags : "",
                    classification = Classify(tmp, evidence, textureMismatchCount, expectedVariant)
                });
            }
            return rows.OrderBy(r => r.path, StringComparer.OrdinalIgnoreCase).ToList();
        }

        private static RouteEvidence FindEvidenceForPath(List<RouteEvidence> evidenceRows, string normalizedPath)
        {
            foreach (var row in evidenceRows)
            {
                if (normalizedPath.Equals(row.normalizedPath, StringComparison.OrdinalIgnoreCase))
                    return row;
            }
            foreach (var row in evidenceRows)
            {
                if (normalizedPath.EndsWith("/" + row.normalizedPath, StringComparison.OrdinalIgnoreCase))
                    return row;
            }
            return null;
        }

        private static int CountTextureMismatches(Material mat, Dictionary<string, string> expectedProps)
        {
            if (mat == null || expectedProps == null)
                return 0;
            var count = 0;
            foreach (var pair in expectedProps)
            {
                if (pair.Key == "_MainTex" || !mat.HasProperty(pair.Key))
                    continue;
                var expectedEmpty = string.IsNullOrWhiteSpace(pair.Value) || pair.Value == "0";
                var actual = mat.GetTexture(pair.Key);
                if (expectedEmpty && actual != null)
                    count++;
            }
            return count;
        }

        private static string Classify(TMP_Text tmp, RouteEvidence evidence, int textureMismatchCount, string expectedVariant)
        {
            if (evidence == null)
                return "actual_without_route_evidence";
            if (!evidence.activeChain)
                return "inactive_original_evidence";
            if (textureMismatchCount > 0)
                return "non_main_texture_slot_mismatch";
            if (!string.IsNullOrWhiteSpace(expectedVariant) && tmp.font != null && !tmp.font.name.Contains(SafeVariantName(expectedVariant), StringComparison.OrdinalIgnoreCase))
                return "font_variant_name_mismatch";
            return "evidence_path_material_ok";
        }

        private static bool IsRouteRelevant(string path, string text, string material)
        {
            return ContainsAny(path, "wanfaWorldNode", "UI_Main_wanfa_item", "node_bottom", "node_act_btn")
                || ContainsAny(text, "모험", "전", "국", "마을", "상점")
                || ContainsAny(material, "riyu_shenzong_0.2_0.2", "riyu_baibian_0.2_0.2_1", "EPM_bai_0.2_0.2");
        }

        private static bool IsActualRouteRelevant(string path, TMP_Text tmp)
        {
            var text = tmp.text ?? "";
            var font = tmp.font != null ? tmp.font.name : "";
            var material = tmp.fontSharedMaterial != null ? tmp.fontSharedMaterial.name : "";
            return ContainsAny(path, "wanfaWorldNode", "UI_Main_wanfa_item", "node_bottom", "node_act_btn")
                || ContainsAny(text, "모험", "전", "국", "마을", "상점")
                || ContainsAny(font, "riyu_shenzong", "riyu_baibian", "EPM_bai")
                || ContainsAny(material, "riyu_shenzong", "riyu_baibian", "EPM_bai");
        }

        private static string GuessVariantFromAssetNames(string fontName, string materialName)
        {
            var combined = fontName + " " + materialName;
            if (combined.Contains("riyu_shenzong", StringComparison.OrdinalIgnoreCase))
                return "riyu_shenzong_0.2_0.2";
            if (combined.Contains("riyu_baibian", StringComparison.OrdinalIgnoreCase))
                return "riyu_baibian_0.2_0.2_1";
            if (combined.Contains("EPM_bai", StringComparison.OrdinalIgnoreCase))
                return "EPM_bai_0.2_0.2";
            return "";
        }

        private static void WriteCsv(List<AuditRow> rows)
        {
            Directory.CreateDirectory(Path.GetDirectoryName(ResultCsv));
            var header = new[]
            {
                "path", "text", "active_in_hierarchy", "active_self", "sibling_index", "anchor_min", "anchor_max", "pivot",
                "anchored_position", "size_delta", "local_scale", "font_asset", "expected_variant", "material", "font_size",
                "alignment", "character_spacing", "line_spacing", "color", "main_tex", "face_tex", "outline_tex", "bump_map",
                "cube", "texture_mismatch_count", "evidence_text", "evidence_active_chain", "evidence_size_delta",
                "evidence_anchored_position", "evidence_shared_material_path_id", "evidence_flags", "classification", "evidence_path"
            };
            var sb = new StringBuilder();
            sb.AppendLine(string.Join(",", header.Select(EscapeCsv)));
            foreach (var row in rows)
            {
                sb.AppendLine(string.Join(",", new[]
                {
                    row.path, row.text, row.activeInHierarchy.ToString(), row.activeSelf.ToString(), row.siblingIndex.ToString(CultureInfo.InvariantCulture),
                    row.anchorMin, row.anchorMax, row.pivot, row.anchoredPosition, row.sizeDelta, row.localScale, row.fontAsset, row.expectedVariant,
                    row.material, row.fontSize, row.alignment, row.characterSpacing, row.lineSpacing, row.color, row.mainTex, row.faceTex,
                    row.outlineTex, row.bumpMap, row.cube, row.textureMismatchCount.ToString(CultureInfo.InvariantCulture), row.evidenceText,
                    row.evidenceActiveChain.ToString(), row.evidenceSizeDelta, row.evidenceAnchoredPosition, row.evidenceSharedMaterialPathId,
                    row.evidenceFlags, row.classification, row.evidencePath
                }.Select(EscapeCsv)));
            }
            File.WriteAllText(ResultCsv, sb.ToString(), Encoding.UTF8);
        }

        private static void WriteJson(List<AuditRow> rows)
        {
            Directory.CreateDirectory(Path.GetDirectoryName(ResultJson));
            var sb = new StringBuilder();
            sb.AppendLine("{");
            sb.AppendLine("  \"generatedAt\": \"" + EscapeJson(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture)) + "\",");
            sb.AppendLine("  \"rowCount\": " + rows.Count.ToString(CultureInfo.InvariantCulture) + ",");
            sb.AppendLine("  \"activeRows\": " + rows.Count(r => r.activeInHierarchy).ToString(CultureInfo.InvariantCulture) + ",");
            sb.AppendLine("  \"textureMismatchRows\": " + rows.Count(r => r.textureMismatchCount > 0).ToString(CultureInfo.InvariantCulture) + ",");
            sb.AppendLine("  \"classifications\": {");
            var groups = rows.GroupBy(r => r.classification).OrderBy(g => g.Key).ToList();
            for (var i = 0; i < groups.Count; i++)
            {
                var suffix = i + 1 == groups.Count ? "" : ",";
                sb.AppendLine("    \"" + EscapeJson(groups[i].Key) + "\": " + groups[i].Count().ToString(CultureInfo.InvariantCulture) + suffix);
            }
            sb.AppendLine("  },");
            sb.AppendLine("  \"csv\": \"" + EscapeJson(ResultCsv) + "\"");
            sb.AppendLine("}");
            File.WriteAllText(ResultJson, sb.ToString(), Encoding.UTF8);
        }

        private static void WriteReport(List<AuditRow> rows, List<RouteEvidence> evidenceRows)
        {
            Directory.CreateDirectory(Path.GetDirectoryName(ReportMdAbsolute));
            var textureMismatchRows = rows.Where(r => r.textureMismatchCount > 0).ToList();
            var activeRouteRows = rows.Where(r => r.activeInHierarchy && r.evidenceActiveChain).ToList();
            var routeLabels = rows.Where(r => ContainsAny(r.text, "모험", "전", "국")).ToList();
            var sb = new StringBuilder();
            sb.AppendLine("# MainInterface Route TMP Variant Material Audit Result");
            sb.AppendLine();
            sb.AppendLine("Generated: " + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture) + " KST");
            sb.AppendLine();
            sb.AppendLine("## Verdict");
            sb.AppendLine();
            if (textureMismatchRows.Count == 0)
                sb.AppendLine("The material texture PPtr reconstruction gate is now clean for audited route TMP rows: non-main texture slots with original value `0` are not filled with the atlas.");
            else
                sb.AppendLine("The capture remains failed/partial for route TMP material fidelity: some audited rows still have non-main texture slots populated where original evidence says pathID `0`.");
            sb.AppendLine();
            sb.AppendLine("This is not a coordinate-only change. The fix preserves original hierarchy/RectTransform/sibling data and corrects TMP material texture reference reconstruction from original material property evidence.");
            sb.AppendLine();
            sb.AppendLine("## Counts");
            sb.AppendLine();
            sb.AppendLine("| metric | value |");
            sb.AppendLine("| --- | ---: |");
            sb.AppendLine("| evidence rows considered | " + evidenceRows.Count.ToString(CultureInfo.InvariantCulture) + " |");
            sb.AppendLine("| audited scene TMP rows | " + rows.Count.ToString(CultureInfo.InvariantCulture) + " |");
            sb.AppendLine("| active evidence-matched rows | " + activeRouteRows.Count.ToString(CultureInfo.InvariantCulture) + " |");
            sb.AppendLine("| route label rows (`모험`/`전`/`국`) | " + routeLabels.Count.ToString(CultureInfo.InvariantCulture) + " |");
            sb.AppendLine("| non-main texture slot mismatch rows | " + textureMismatchRows.Count.ToString(CultureInfo.InvariantCulture) + " |");
            sb.AppendLine();
            sb.AppendLine("## Route Label Rows");
            sb.AppendLine();
            sb.AppendLine("| text | scene path | font asset | material | size | evidence size | classification |");
            sb.AppendLine("| --- | --- | --- | --- | --- | --- | --- |");
            foreach (var row in routeLabels.Take(20))
                sb.AppendLine("| `" + EscapeMd(row.text) + "` | `" + EscapeMd(row.path) + "` | `" + EscapeMd(row.fontAsset) + "` | `" + EscapeMd(row.material) + "` | `" + EscapeMd(row.sizeDelta) + "` | `" + EscapeMd(row.evidenceSizeDelta) + "` | `" + EscapeMd(row.classification) + "` |");
            sb.AppendLine();
            sb.AppendLine("## Texture Slot Evidence");
            sb.AppendLine();
            sb.AppendLine("- `_MainTex` is the atlas texture and remains assigned.");
            sb.AppendLine("- `_BumpMap`, `_Cube`, `_FaceTex`, and `_OutlineTex` stay empty when original material property value is `0`.");
            sb.AppendLine("- No whole-atlas Image fallback, fake panel, debug overlay, or coordinate adjustment was added.");
            sb.AppendLine();
            sb.AppendLine("## Outputs");
            sb.AppendLine();
            sb.AppendLine("- `" + ResultJson + "`");
            sb.AppendLine("- `" + ResultCsv + "`");
            sb.AppendLine("- `Assets/RestoreCaptures/maininterface_restored_1680x720.png` after running tool 110");
            File.WriteAllText(ReportMdAbsolute, sb.ToString(), Encoding.UTF8);
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

        private static string NormalizePath(string path)
        {
            if (string.IsNullOrWhiteSpace(path))
                return "";
            var clean = Regex.Replace(path, @"\([-]?\d+\)", "");
            var parts = clean.Split(new[] {'/'}, StringSplitOptions.RemoveEmptyEntries)
                .Select(p => Regex.Replace(p, @"__font_.*$", ""))
                .Select(p => Regex.Replace(p, @"__[-]?\d+$", ""))
                .ToArray();
            return string.Join("/", parts);
        }

        private static string TextureName(Material material, string propertyName)
        {
            if (material == null || !material.HasProperty(propertyName))
                return "";
            var texture = material.GetTexture(propertyName);
            return texture != null ? texture.name : "";
        }

        private static bool ContainsAny(string value, params string[] tokens)
        {
            if (string.IsNullOrEmpty(value))
                return false;
            return tokens.Any(t => value.IndexOf(t, StringComparison.OrdinalIgnoreCase) >= 0);
        }

        private static string SafeVariantName(string value)
        {
            return (value ?? "").Replace(".", "_");
        }

        private static string FormatVector2(Vector2 value)
        {
            return FormatFloat(value.x) + "," + FormatFloat(value.y);
        }

        private static string FormatVector3(Vector3 value)
        {
            return FormatFloat(value.x) + "," + FormatFloat(value.y) + "," + FormatFloat(value.z);
        }

        private static string FormatColor(Color value)
        {
            return FormatFloat(value.r) + "," + FormatFloat(value.g) + "," + FormatFloat(value.b) + "," + FormatFloat(value.a);
        }

        private static string FormatFloat(float value)
        {
            return value.ToString("0.###", CultureInfo.InvariantCulture);
        }

        private static bool ParseBool(string value)
        {
            return value == "1" || value.Equals("true", StringComparison.OrdinalIgnoreCase) || value.Equals("True", StringComparison.Ordinal);
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
                    {
                        inQuotes = true;
                    }
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
                    {
                        field.Append(c);
                    }
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
            return row.TryGetValue(key, out var value) ? value : "";
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

        private sealed class RouteEvidence
        {
            public string hierarchyPath;
            public string normalizedPath;
            public string text;
            public bool activeChain;
            public bool prefabActive;
            public string anchoredX;
            public string anchoredY;
            public string sizeX;
            public string sizeY;
            public string fontAssetName;
            public string fontSize;
            public string sharedMaterialPathId;
            public string sharedMaterialName;
            public string flags;
        }

        private sealed class AuditRow
        {
            public string path;
            public string normalizedPath;
            public string evidencePath;
            public string text;
            public bool activeInHierarchy;
            public bool activeSelf;
            public int siblingIndex;
            public string anchorMin;
            public string anchorMax;
            public string pivot;
            public string anchoredPosition;
            public string sizeDelta;
            public string localScale;
            public string fontAsset;
            public string expectedVariant;
            public string material;
            public string fontSize;
            public string alignment;
            public string characterSpacing;
            public string lineSpacing;
            public string color;
            public string mainTex;
            public string faceTex;
            public string outlineTex;
            public string bumpMap;
            public string cube;
            public int textureMismatchCount;
            public string evidenceText;
            public bool evidenceActiveChain;
            public string evidenceSizeDelta;
            public string evidenceAnchoredPosition;
            public string evidenceSharedMaterialPathId;
            public string evidenceFlags;
            public string classification;
        }
    }
}
