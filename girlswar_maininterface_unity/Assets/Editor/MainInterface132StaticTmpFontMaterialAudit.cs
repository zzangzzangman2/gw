using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using TMPro;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.UI;

namespace GirlsWarRestore
{
    public static class MainInterface132StaticTmpFontMaterialAudit
    {
        private const string ScenePath = "Assets/Scenes/MainInterface_UI126_OldRootReferenceCandidate.unity";
        private const string SharedMaterialsCsv = "Assets/RestoreData/reports/maininterface_tmp_shared_materials.csv";
        private const string ReportDir = "C:/Users/godho/Downloads/girlswar/reports/maininterface";
        private const string AuditCsv = ReportDir + "/MAININTERFACE_132_tmp_text_node_audit.csv";
        private const string EvidenceCsv = ReportDir + "/MAININTERFACE_132_static_tmp_material_binding_evidence.csv";
        private const string ResultJson = ReportDir + "/MAININTERFACE_132_SOURCE_BACKED_STATIC_TMP_FONT_MATERIAL_BINDING_AUDIT_AND_CANDIDATE_PATCH_NO_DYNAMIC_TEXT_RESULT.json";
        private const string ResultMd = ReportDir + "/MAININTERFACE_132_SOURCE_BACKED_STATIC_TMP_FONT_MATERIAL_BINDING_AUDIT_AND_CANDIDATE_PATCH_NO_DYNAMIC_TEXT_RESULT.md";

        private static readonly string[] DynamicPathTokens =
        {
            "node_act_btn", "btn_act_", "txt_act", "faceGift", "btn_face_item", "txt_face", "chat",
            "text_bhll_message", "tmp_bubble", "btn_head", "text_fight_num", "text_level_num",
            "text_vip_num", "text_num", "num__", "coin", "gold", "diamond", "mail", "youjian"
        };

        private static readonly string[] GuardrailPathTokens =
        {
            "btn_discord", "UI_bg", "zhuye_di1", "zhuye_bian", "node_middle", "wanfaWorldNode", "worldwanfaBtn"
        };

        private static readonly string[] StaticNameTokens =
        {
            "lab_renwu_text", "lab_shangdian_text", "text_off", "text_on", "text_beijing", "text_haoyou",
            "text_paihangbang", "text_tujian", "text_fanhui", "text_queren", "text_qianghua", "text_wuyu",
            "text_yincang", "text_big", "text_small", "text_title", "text_title1"
        };

        [MenuItem("GirlsWar/UI132 Audit Static TMP Font Material Binding No Dynamic Text")]
        public static void AuditStaticTmpFontMaterialBinding()
        {
            Directory.CreateDirectory(ReportDir);
            if (!File.Exists(ScenePath))
                throw new FileNotFoundException("UI128 old-root candidate scene is missing. Run UI128 candidate build first.", ScenePath);

            var materials = LoadSharedMaterials(SharedMaterialsCsv);
            EditorSceneManager.OpenScene(ScenePath, OpenSceneMode.Single);
            Canvas.ForceUpdateCanvases();

            var rows = new List<NodeAuditRow>();
            foreach (var tmp in UnityEngine.Object.FindObjectsByType<TMP_Text>(FindObjectsInactive.Include, FindObjectsSortMode.None))
                rows.Add(AuditTmp(tmp, materials));
            foreach (var text in UnityEngine.Object.FindObjectsByType<Text>(FindObjectsInactive.Include, FindObjectsSortMode.None))
                rows.Add(AuditText(text));

            rows = rows.OrderByDescending(r => r.visible).ThenBy(r => r.classification).ThenBy(r => r.hierarchyPath).ToList();
            var evidenceRows = rows
                .Where(r => r.classification == "static_source_identified" && r.componentType.Contains("TextMeshPro"))
                .Select(r => new EvidenceRow
                {
                    hierarchyPath = r.hierarchyPath,
                    gameObjectName = r.gameObjectName,
                    textSample = r.textSample,
                    fontName = r.fontName,
                    currentMaterialName = r.materialName,
                    evidenceMaterialName = r.evidenceMaterialName,
                    evidenceSharedMaterialPathId = r.evidenceSharedMaterialPathId,
                    evidenceBundle = r.evidenceBundle,
                    bindingStatus = r.bindingStatus,
                    decision = r.bindingStatus == "source_backed_material_already_bound"
                        ? "no_patch_needed"
                        : "blocked_no_patch_unmatched_or_ambiguous_static_tmp_binding"
                })
                .ToList();

            WriteNodeAuditCsv(rows);
            WriteEvidenceCsv(evidenceRows);

            var staticTmp = evidenceRows.Count;
            var staticTmpAlreadyBound = evidenceRows.Count(r => r.bindingStatus == "source_backed_material_already_bound");
            var staticTmpUnmatched = evidenceRows.Count(r => r.bindingStatus != "source_backed_material_already_bound");
            var dynamicCount = rows.Count(r => r.classification == "dynamic_runtime_snapshot_required");
            var guardrailCount = rows.Count(r => r.classification == "guardrail_blocked");
            var unknownCount = rows.Count(r => r.classification == "unknown_needs_probe");

            var result = new Result
            {
                generatedAt = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture),
                restoredClaim = false,
                candidatePatchApplied = false,
                scenePatchApplied = false,
                status = staticTmpUnmatched == 0
                    ? "blocked_no_patch_static_tmp_bindings_already_bound_or_no_unambiguous_static_patch_targets"
                    : "blocked_no_patch_unmatched_static_tmp_targets_require_manual_probe",
                scenePath = ScenePath,
                nodeAuditCsv = AuditCsv,
                materialEvidenceCsv = EvidenceCsv,
                totalTextNodes = rows.Count,
                visibleTextNodes = rows.Count(r => r.visible),
                staticSourceIdentified = rows.Count(r => r.classification == "static_source_identified"),
                dynamicRuntimeSnapshotRequired = dynamicCount,
                guardrailBlocked = guardrailCount,
                unknownNeedsProbe = unknownCount,
                staticTmpEvidenceRows = staticTmp,
                staticTmpAlreadyBound = staticTmpAlreadyBound,
                staticTmpUnmatched = staticTmpUnmatched,
                noPatchReason = "No source-backed dynamic text edits are allowed. Static TMP material candidates are already using matched source-backed shared/static-probe materials, so UI132 has no new material patch to apply.",
                commandPolicy = GetCommandPolicy()
            };

            File.WriteAllText(ResultJson, JsonUtility.ToJson(result, true), Encoding.UTF8);
            File.WriteAllText(ResultMd, BuildMarkdown(result), Encoding.UTF8);
            AssetDatabase.Refresh(ImportAssetOptions.ForceSynchronousImport);
            Debug.Log("[GirlsWarRestore] UI132 static TMP/font/material audit complete: " + AuditCsv);
        }

        private static NodeAuditRow AuditTmp(TMP_Text tmp, Dictionary<string, SharedMaterialEvidence> materials)
        {
            var path = GetHierarchyPath(tmp.transform);
            var materialName = NormalizeMaterialName(tmp.fontSharedMaterial != null ? tmp.fontSharedMaterial.name : "");
            materials.TryGetValue(materialName, out var evidence);
            var classification = Classify(path, tmp.gameObject.name, tmp.text, true);
            var bindingStatus = "not_static_tmp_candidate";
            if (classification == "static_source_identified")
                bindingStatus = evidence != null ? "source_backed_material_already_bound" : "missing_or_unmatched_source_material";

            return new NodeAuditRow
            {
                hierarchyPath = path,
                gameObjectName = tmp.gameObject.name,
                componentType = tmp.GetType().Name,
                textSample = OneLine(tmp.text),
                activeInHierarchy = tmp.gameObject.activeInHierarchy,
                enabled = tmp.enabled,
                visible = IsVisible(tmp.transform, tmp.enabled, tmp.color.a, tmp.text),
                classification = classification,
                sourceReason = ReasonFor(classification),
                fontName = tmp.font != null ? tmp.font.name : "",
                materialName = materialName,
                evidenceMaterialName = evidence != null ? evidence.materialName : "",
                evidenceSharedMaterialPathId = evidence != null ? evidence.sharedMaterialPathId : "",
                evidenceBundle = evidence != null ? evidence.bundle : "",
                bindingStatus = bindingStatus,
                fontSize = tmp.fontSize.ToString(CultureInfo.InvariantCulture),
                raycastTarget = tmp.raycastTarget,
                rect = RectText(tmp.rectTransform)
            };
        }

        private static NodeAuditRow AuditText(Text text)
        {
            var path = GetHierarchyPath(text.transform);
            var classification = Classify(path, text.gameObject.name, text.text, false);
            return new NodeAuditRow
            {
                hierarchyPath = path,
                gameObjectName = text.gameObject.name,
                componentType = "UnityEngine.UI.Text",
                textSample = OneLine(text.text),
                activeInHierarchy = text.gameObject.activeInHierarchy,
                enabled = text.enabled,
                visible = IsVisible(text.transform, text.enabled, text.color.a, text.text),
                classification = classification,
                sourceReason = ReasonFor(classification),
                fontName = text.font != null ? text.font.name : "",
                materialName = text.material != null ? NormalizeMaterialName(text.material.name) : "",
                evidenceMaterialName = "",
                evidenceSharedMaterialPathId = "",
                evidenceBundle = "",
                bindingStatus = classification == "static_source_identified"
                    ? "ugui_text_not_tmp_material_patch_target"
                    : "not_static_tmp_candidate",
                fontSize = text.fontSize.ToString(CultureInfo.InvariantCulture),
                raycastTarget = text.raycastTarget,
                rect = RectText(text.rectTransform)
            };
        }

        private static string Classify(string path, string name, string text, bool isTmp)
        {
            var haystack = (path + "/" + name + "/" + text).ToLowerInvariant();
            if (GuardrailPathTokens.Any(t => haystack.Contains(t.ToLowerInvariant())))
                return "guardrail_blocked";
            if (DynamicPathTokens.Any(t => haystack.Contains(t.ToLowerInvariant())))
                return "dynamic_runtime_snapshot_required";
            if (StaticNameTokens.Any(t => haystack.Contains(t.ToLowerInvariant())))
                return isTmp ? "static_source_identified" : "unknown_needs_probe";
            return "unknown_needs_probe";
        }

        private static string ReasonFor(string classification)
        {
            switch (classification)
            {
                case "static_source_identified":
                    return "Static object-name/path token matches source TMP material evidence and is not in a dynamic/runtime or guardrail path.";
                case "dynamic_runtime_snapshot_required":
                    return "Activity, face activity, chat/account/player/currency, or server-driven text path; UI130 snapshot replay is required before value/icon/slot changes.";
                case "guardrail_blocked":
                    return "Path touches btn_discord/UI_bg/zhuye/route-world guardrail area; no static patch from TMP audit.";
                default:
                    return "Insufficient node-level source evidence for automatic static TMP material patch.";
            }
        }

        private static bool IsVisible(Transform transform, bool enabled, float alpha, string text)
        {
            if (!transform.gameObject.activeInHierarchy || !enabled || alpha <= 0.001f)
                return false;
            var rect = transform as RectTransform;
            if (rect == null)
                return !string.IsNullOrEmpty(text);
            return rect.rect.width > 0.01f && rect.rect.height > 0.01f;
        }

        private static Dictionary<string, SharedMaterialEvidence> LoadSharedMaterials(string path)
        {
            var result = new Dictionary<string, SharedMaterialEvidence>(StringComparer.OrdinalIgnoreCase);
            if (!File.Exists(path))
                return result;
            var rows = ParseCsv(File.ReadAllText(path, Encoding.UTF8));
            if (rows.Count < 2)
                return result;
            var header = rows[0];
            for (var i = 1; i < rows.Count; i++)
            {
                var row = rows[i];
                var materialName = GetCell(header, row, "material_name");
                if (string.IsNullOrEmpty(materialName))
                    continue;
                result[NormalizeMaterialName(materialName)] = new SharedMaterialEvidence
                {
                    materialName = materialName,
                    sharedMaterialPathId = GetCell(header, row, "shared_material_path_id"),
                    fontKey = GetCell(header, row, "font_key"),
                    bundle = GetCell(header, row, "bundle"),
                    bundlePath = GetCell(header, row, "bundle_path"),
                    textSamples = GetCell(header, row, "text_samples")
                };
            }
            foreach (var assetPath in AssetDatabase.FindAssets("t:Material", new[] { "Assets/RestoreData/TMP/static_probe" })
                         .Select(AssetDatabase.GUIDToAssetPath))
            {
                var material = AssetDatabase.LoadAssetAtPath<Material>(assetPath);
                if (material == null)
                    continue;
                var normalized = NormalizeMaterialName(material.name);
                if (string.IsNullOrEmpty(normalized))
                    continue;
                if (!result.ContainsKey(normalized))
                {
                    result[normalized] = new SharedMaterialEvidence
                    {
                        materialName = material.name,
                        sharedMaterialPathId = ExtractPathIdFromStaticProbePath(assetPath),
                        fontKey = material.name.Contains("EPM", StringComparison.OrdinalIgnoreCase) ? "EPM" :
                            material.name.Contains("num", StringComparison.OrdinalIgnoreCase) ? "num" : "riyu",
                        bundle = "Assets/RestoreData/TMP/static_probe",
                        bundlePath = assetPath,
                        textSamples = "static_probe_material_asset"
                    };
                }
            }
            return result;
        }

        private static string ExtractPathIdFromStaticProbePath(string assetPath)
        {
            var name = Path.GetFileNameWithoutExtension(assetPath);
            var index = name.LastIndexOf('_');
            if (name.StartsWith("TMPSharedMaterial_", StringComparison.Ordinal) && index >= 0)
                return name.Substring("TMPSharedMaterial_".Length).Replace("m", "-");
            return "";
        }

        private static List<List<string>> ParseCsv(string text)
        {
            var rows = new List<List<string>>();
            var row = new List<string>();
            var cell = new StringBuilder();
            var quoted = false;
            for (var i = 0; i < text.Length; i++)
            {
                var c = text[i];
                if (quoted)
                {
                    if (c == '"')
                    {
                        if (i + 1 < text.Length && text[i + 1] == '"')
                        {
                            cell.Append('"');
                            i++;
                        }
                        else
                        {
                            quoted = false;
                        }
                    }
                    else
                    {
                        cell.Append(c);
                    }
                    continue;
                }

                if (c == '"')
                {
                    quoted = true;
                }
                else if (c == ',')
                {
                    row.Add(cell.ToString());
                    cell.Length = 0;
                }
                else if (c == '\n')
                {
                    row.Add(cell.ToString().TrimEnd('\r'));
                    rows.Add(row);
                    row = new List<string>();
                    cell.Length = 0;
                }
                else
                {
                    cell.Append(c);
                }
            }
            if (cell.Length > 0 || row.Count > 0)
            {
                row.Add(cell.ToString());
                rows.Add(row);
            }
            return rows;
        }

        private static string GetCell(List<string> header, List<string> row, string name)
        {
            var index = header.IndexOf(name);
            return index >= 0 && index < row.Count ? row[index] : "";
        }

        private static void WriteNodeAuditCsv(List<NodeAuditRow> rows)
        {
            var sb = new StringBuilder();
            sb.AppendLine("hierarchyPath,gameObjectName,componentType,textSample,activeInHierarchy,enabled,visible,classification,sourceReason,fontName,materialName,evidenceMaterialName,evidenceSharedMaterialPathId,evidenceBundle,bindingStatus,fontSize,raycastTarget,rect");
            foreach (var r in rows)
            {
                sb.AppendLine(string.Join(",", new[]
                {
                    Csv(r.hierarchyPath), Csv(r.gameObjectName), Csv(r.componentType), Csv(r.textSample),
                    Csv(r.activeInHierarchy), Csv(r.enabled), Csv(r.visible), Csv(r.classification),
                    Csv(r.sourceReason), Csv(r.fontName), Csv(r.materialName), Csv(r.evidenceMaterialName),
                    Csv(r.evidenceSharedMaterialPathId), Csv(r.evidenceBundle), Csv(r.bindingStatus),
                    Csv(r.fontSize), Csv(r.raycastTarget), Csv(r.rect)
                }));
            }
            File.WriteAllText(AuditCsv, sb.ToString(), Encoding.UTF8);
        }

        private static void WriteEvidenceCsv(List<EvidenceRow> rows)
        {
            var sb = new StringBuilder();
            sb.AppendLine("hierarchyPath,gameObjectName,textSample,fontName,currentMaterialName,evidenceMaterialName,evidenceSharedMaterialPathId,evidenceBundle,bindingStatus,decision");
            foreach (var r in rows)
            {
                sb.AppendLine(string.Join(",", new[]
                {
                    Csv(r.hierarchyPath), Csv(r.gameObjectName), Csv(r.textSample), Csv(r.fontName),
                    Csv(r.currentMaterialName), Csv(r.evidenceMaterialName), Csv(r.evidenceSharedMaterialPathId),
                    Csv(r.evidenceBundle), Csv(r.bindingStatus), Csv(r.decision)
                }));
            }
            File.WriteAllText(EvidenceCsv, sb.ToString(), Encoding.UTF8);
        }

        private static string BuildMarkdown(Result result)
        {
            var sb = new StringBuilder();
            sb.AppendLine("# MAININTERFACE_132_SOURCE_BACKED_STATIC_TMP_FONT_MATERIAL_BINDING_AUDIT_AND_CANDIDATE_PATCH_NO_DYNAMIC_TEXT_RESULT");
            sb.AppendLine();
            sb.AppendLine("## Verdict");
            sb.AppendLine();
            sb.AppendLine("- restoredClaim: `false`");
            sb.AppendLine("- candidatePatchApplied: `false`");
            sb.AppendLine("- scenePatchApplied: `false`");
            sb.AppendLine("- status: `" + result.status + "`");
            sb.AppendLine("- noPatchReason: " + result.noPatchReason);
            sb.AppendLine();
            sb.AppendLine("## Audit Counts");
            sb.AppendLine();
            sb.AppendLine("- total text nodes: `" + result.totalTextNodes + "`");
            sb.AppendLine("- visible text nodes: `" + result.visibleTextNodes + "`");
            sb.AppendLine("- static_source_identified: `" + result.staticSourceIdentified + "`");
            sb.AppendLine("- dynamic_runtime_snapshot_required: `" + result.dynamicRuntimeSnapshotRequired + "`");
            sb.AppendLine("- guardrail_blocked: `" + result.guardrailBlocked + "`");
            sb.AppendLine("- unknown_needs_probe: `" + result.unknownNeedsProbe + "`");
            sb.AppendLine("- static TMP evidence rows: `" + result.staticTmpEvidenceRows + "`");
            sb.AppendLine("- static TMP already bound: `" + result.staticTmpAlreadyBound + "`");
            sb.AppendLine("- static TMP unmatched: `" + result.staticTmpUnmatched + "`");
            sb.AppendLine();
            sb.AppendLine("## Guardrails");
            sb.AppendLine();
            sb.AppendLine("- Dynamic activity/face/chat/account/player/currency labels were excluded from patch targets.");
            sb.AppendLine("- `btn_discord` review hide, `UI_bg` raycast-off, `node_act_btn/btn_act_*` hide, route/world/zhuye hides remain forbidden.");
            sb.AppendLine("- No fake text, screenshot paste, whole atlas, or coordinate-only alignment was used.");
            sb.AppendLine();
            sb.AppendLine("## Outputs");
            sb.AppendLine();
            sb.AppendLine("- node audit CSV: `" + AuditCsv + "`");
            sb.AppendLine("- material binding evidence CSV: `" + EvidenceCsv + "`");
            sb.AppendLine("- result JSON: `" + ResultJson + "`");
            sb.AppendLine();
            sb.AppendLine("## Command Policy");
            sb.AppendLine();
            sb.AppendLine("- root `.cmd` count: `" + result.commandPolicy.rootCmdCount + "`");
            sb.AppendLine("- `_restore_tools` direct `.cmd` count: `" + result.commandPolicy.restoreToolsDirectCmdCount + "`");
            return sb.ToString();
        }

        private static CommandPolicy GetCommandPolicy()
        {
            var root = "C:/Users/godho/Downloads/girlswar";
            var directTools = Path.Combine(root, "_restore_tools");
            return new CommandPolicy
            {
                rootCmdCount = Directory.GetFiles(root, "*.cmd", SearchOption.TopDirectoryOnly).Length,
                restoreToolsDirectCmdCount = Directory.Exists(directTools)
                    ? Directory.GetFiles(directTools, "*.cmd", SearchOption.TopDirectoryOnly).Length
                    : 0
            };
        }

        private static string GetHierarchyPath(Transform transform)
        {
            var names = new Stack<string>();
            var current = transform;
            while (current != null)
            {
                names.Push(current.name);
                current = current.parent;
            }
            return string.Join("/", names);
        }

        private static string RectText(RectTransform rect)
        {
            if (rect == null)
                return "";
            return rect.anchoredPosition.x.ToString("0.###", CultureInfo.InvariantCulture) + ":" +
                   rect.anchoredPosition.y.ToString("0.###", CultureInfo.InvariantCulture) + ":" +
                   rect.sizeDelta.x.ToString("0.###", CultureInfo.InvariantCulture) + ":" +
                   rect.sizeDelta.y.ToString("0.###", CultureInfo.InvariantCulture);
        }

        private static string NormalizeMaterialName(string name)
        {
            return (name ?? "").Replace(" (Instance)", "").Trim();
        }

        private static string OneLine(string text)
        {
            if (string.IsNullOrEmpty(text))
                return "";
            var oneLine = text.Replace("\r", " ").Replace("\n", " ").Trim();
            return oneLine.Length > 120 ? oneLine.Substring(0, 119) + "…" : oneLine;
        }

        private static string Csv(object value)
        {
            var text = Convert.ToString(value, CultureInfo.InvariantCulture) ?? "";
            return "\"" + text.Replace("\"", "\"\"") + "\"";
        }

        [Serializable]
        private sealed class Result
        {
            public string generatedAt;
            public bool restoredClaim;
            public bool candidatePatchApplied;
            public bool scenePatchApplied;
            public string status;
            public string scenePath;
            public string nodeAuditCsv;
            public string materialEvidenceCsv;
            public int totalTextNodes;
            public int visibleTextNodes;
            public int staticSourceIdentified;
            public int dynamicRuntimeSnapshotRequired;
            public int guardrailBlocked;
            public int unknownNeedsProbe;
            public int staticTmpEvidenceRows;
            public int staticTmpAlreadyBound;
            public int staticTmpUnmatched;
            public string noPatchReason;
            public CommandPolicy commandPolicy;
        }

        [Serializable]
        private sealed class CommandPolicy
        {
            public int rootCmdCount;
            public int restoreToolsDirectCmdCount;
        }

        private sealed class NodeAuditRow
        {
            public string hierarchyPath;
            public string gameObjectName;
            public string componentType;
            public string textSample;
            public bool activeInHierarchy;
            public bool enabled;
            public bool visible;
            public string classification;
            public string sourceReason;
            public string fontName;
            public string materialName;
            public string evidenceMaterialName;
            public string evidenceSharedMaterialPathId;
            public string evidenceBundle;
            public string bindingStatus;
            public string fontSize;
            public bool raycastTarget;
            public string rect;
        }

        private sealed class EvidenceRow
        {
            public string hierarchyPath;
            public string gameObjectName;
            public string textSample;
            public string fontName;
            public string currentMaterialName;
            public string evidenceMaterialName;
            public string evidenceSharedMaterialPathId;
            public string evidenceBundle;
            public string bindingStatus;
            public string decision;
        }

        private sealed class SharedMaterialEvidence
        {
            public string materialName;
            public string sharedMaterialPathId;
            public string fontKey;
            public string bundle;
            public string bundlePath;
            public string textSamples;
        }
    }
}
