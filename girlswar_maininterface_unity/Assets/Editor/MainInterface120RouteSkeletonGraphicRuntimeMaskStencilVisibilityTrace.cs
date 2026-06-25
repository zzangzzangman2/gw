using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using Spine;
using Spine.Unity;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.UI;

namespace GirlsWarRestore
{
    public static class MainInterface120RouteSkeletonGraphicRuntimeMaskStencilVisibilityTrace
    {
        private const string ScenePath = "Assets/Scenes/MainInterface_RouteSpineRuntimeReplay_UIMaterialBound.unity";
        private const string ResultJson = "Assets/RestoreData/maininterface_120_route_skeletongraphic_original_runtime_mask_stencil_attachment_visibility.json";
        private const string ResultCsv = "Assets/RestoreData/reports/maininterface_120_route_skeletongraphic_original_runtime_mask_stencil_attachment_visibility.csv";
        private const string RouteTraceCsv = "Assets/RestoreData/reports/maininterface_route_renderer_asset_trace.csv";

        private static readonly string[] CandidateSlots = { "zhuye_di1", "zhuye_bian", "diqiu", "zong1" };
        private static readonly string[] CandidateAttachments = { "zhuye_di1", "zhuye_bian", "diqiu", "zong1" };
        private static readonly float[] SampleTimes = { 0f, 1.25f, 2.5f, 3.75f, 5f };

        [MenuItem("GirlsWar/UI120 Trace Route SkeletonGraphic Runtime Mask Stencil Attachment Visibility")]
        public static void Trace()
        {
            Directory.CreateDirectory("Assets/RestoreData/reports");
            var result = new TraceResult
            {
                generatedAt = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture),
                status = "started",
                visualVerdict = "not_normal_trace_started",
                scenePath = ScenePath,
                visualFixApplied = 0,
                targetRows = new List<TargetRow>(),
                attachmentRows = new List<AttachmentSampleRow>(),
                timelineRows = new List<TimelineRow>(),
                maskRows = new List<MaskStencilRow>(),
                materialRows = new List<MaterialStencilRow>()
            };

            try
            {
                if (!File.Exists(ScenePath))
                    throw new FileNotFoundException("UI118 material-bound scene is missing.", ScenePath);

                EditorSceneManager.OpenScene(ScenePath, OpenSceneMode.Single);
                var routeRows = LoadCsv(RouteTraceCsv);
                TraceSpineShijieanniu(routeRows, result);

                result.targetsConsidered = result.targetRows.Count;
                result.targetsTraced = result.targetRows.Count(r => r.skeletonGraphicFound);
                result.sampleRows = result.attachmentRows.Count;
                result.timelineRowsCount = result.timelineRows.Count;
                result.maskStencilRows = result.maskRows.Count;
                result.materialRowsCount = result.materialRows.Count;
                result.visibilityOffEvidenceRows = result.attachmentRows.Count(r => !r.visible || r.alpha <= 0.001f || string.IsNullOrEmpty(r.attachmentName));
                result.clippingAttachmentRows = result.attachmentRows.Count(r => r.attachmentType.IndexOf("Clipping", StringComparison.OrdinalIgnoreCase) >= 0);
                result.maskAncestorRows = result.maskRows.Count(r => r.kind == "Mask" || r.kind == "RectMask2D");
                result.stencilMaterialEvidenceRows = result.materialRows.Count(r => r.hasStencilProperty && Math.Abs(r.stencil - 0f) > 0.001f);
                result.visualVerdict = "not_normal_trace_only_no_visual_patch";
                result.status = "maininterface_120_route_skeletongraphic_runtime_mask_stencil_visibility_trace_complete";
                result.decision = BuildDecision(result);
                result.nextBlocker = "route SkeletonGraphic CanvasRenderer texture handoff and clipping triangulation verification for zong1/zhuye_di1";
            }
            catch (Exception ex)
            {
                result.status = "maininterface_120_route_skeletongraphic_runtime_mask_stencil_visibility_trace_failed";
                result.visualVerdict = "not_normal_probe_failed";
                result.decision = "probe_failed";
                result.nextBlocker = ex.GetType().Name + ": " + ex.Message;
                Debug.LogException(ex);
                WriteOutputs(result);
                throw;
            }

            WriteOutputs(result);
            Debug.Log("[GirlsWarRestore] UI120 route SkeletonGraphic runtime mask/stencil/visibility trace complete: " + ResultJson);
        }

        private static void TraceSpineShijieanniu(List<Dictionary<string, string>> routeRows, TraceResult result)
        {
            var row = new TargetRow
            {
                key = "Spine_shijieanniu",
                nodeName = "spine_diqiu",
                rectPathId = "-1766545527926586392",
                expectedAnimation = "A"
            };
            result.targetRows.Add(row);

            var rt = FindNode(row.nodeName, row.rectPathId);
            row.sceneNodeFound = rt != null;
            if (rt == null)
            {
                row.decision = "blocked_original_node_missing";
                row.reason = "Original spine_diqiu node was not found in UI118 material-bound scene.";
                return;
            }

            row.sceneObjectPath = TransformPath(rt);
            row.parentPath = rt.parent != null ? TransformPath(rt.parent) : "";
            row.siblingIndex = rt.GetSiblingIndex();
            row.anchoredPosition = Format(rt.anchoredPosition);
            row.sizeDelta = Format(rt.sizeDelta);
            row.localScale = Format(rt.localScale);
            row.anchorMin = Format(rt.anchorMin);
            row.anchorMax = Format(rt.anchorMax);
            row.pivot = Format(rt.pivot);
            row.activeInHierarchy = rt.gameObject.activeInHierarchy;

            var sg = rt.GetComponent<SkeletonGraphic>();
            row.skeletonGraphicFound = sg != null;
            if (sg == null)
            {
                row.decision = "blocked_skeletongraphic_missing";
                row.reason = "Node exists but has no SkeletonGraphic component.";
                return;
            }

            sg.Initialize(true);
            sg.Update(0f);
            sg.UpdateMesh();
            Canvas.ForceUpdateCanvases();

            var skeleton = sg.Skeleton;
            var animation = skeleton != null && skeleton.Data != null ? skeleton.Data.FindAnimation(row.expectedAnimation) : null;
            row.animationFound = animation != null;
            row.animationDuration = animation != null ? animation.Duration : 0f;
            row.slotCount = skeleton != null && skeleton.Slots != null ? skeleton.Slots.Count : 0;
            row.drawOrderCount = skeleton != null && skeleton.DrawOrder != null ? skeleton.DrawOrder.Count : 0;
            row.maskable = sg.maskable;
            row.raycastTarget = sg.raycastTarget;
            row.canvasRendererMaterialCount = sg.canvasRenderer.materialCount;
            row.canvasRendererTexture = TextureSummary(InvokeNoArg(sg.canvasRenderer, "GetTexture") as Texture);
            row.mainTexture = TextureSummary(sg.mainTexture);
            row.materialForRendering = MaterialSummary(sg.materialForRendering);

            var mesh = sg.GetLastMesh();
            if (mesh != null)
            {
                mesh.RecalculateBounds();
                row.meshVertexCount = mesh.vertexCount;
                row.meshTriangleIndexCount = mesh.triangles != null ? mesh.triangles.Length : 0;
                row.meshSubMeshCount = mesh.subMeshCount;
                row.meshBoundsCenter = Format(mesh.bounds.center);
                row.meshBoundsSize = Format(mesh.bounds.size);
            }

            var original = routeRows.FirstOrDefault(r =>
                EqualsIgnoreCase(Get(r, "game_object_name"), row.nodeName)
                && Get(r, "note").IndexOf("SkeletonGraphic", StringComparison.OrdinalIgnoreCase) >= 0
                && !string.IsNullOrWhiteSpace(Get(r, "material_refs")));
            row.originalMaterialRefs = original != null ? Get(original, "material_refs") : "";

            TraceMaskChain(rt, sg, result);
            TraceMaterials(sg, result);
            TraceAnimationTimelines(row.key, row.nodeName, animation, skeleton, result);
            TraceAttachmentSamples(row.key, row.nodeName, skeleton, animation, result);

            var candidateRows = result.attachmentRows.Where(r => r.key == row.key && IsCandidate(r.slotName, r.attachmentName)).ToList();
            row.candidateSampleRows = candidateRows.Count;
            row.candidateVisibleRows = candidateRows.Count(r => r.visible && r.alpha > 0.001f);
            row.candidateInvisibleRows = candidateRows.Count - row.candidateVisibleRows;
            row.clippingSlotFound = result.attachmentRows.Any(r => r.key == row.key && r.attachmentType.IndexOf("Clipping", StringComparison.OrdinalIgnoreCase) >= 0);
            row.maskAncestorFound = result.maskRows.Any(r => r.kind == "Mask" || r.kind == "RectMask2D");
            row.nonZeroStencilMaterialFound = result.materialRows.Any(r => r.hasStencilProperty && Math.Abs(r.stencil - 0f) > 0.001f);
            row.decision = row.candidateInvisibleRows == 0 && !row.maskAncestorFound && !row.nonZeroStencilMaterialFound
                ? "trace_only_no_evidence_to_hide_route_frame_candidates"
                : "trace_only_runtime_visibility_or_stencil_evidence_requires_candidate_patch_review";
            row.reason = "Animation samples and original node material/mask state were traced without changing hierarchy, rect, scale, sibling order, or visual state.";
        }

        private static void TraceAnimationTimelines(string key, string nodeName, Spine.Animation animation, Skeleton skeleton, TraceResult result)
        {
            if (animation == null)
                return;
            var timelines = animation.Timelines;
            for (var i = 0; i < timelines.Count; i++)
            {
                var timeline = timelines.Items[i];
                if (timeline == null)
                    continue;
                var typeName = timeline.GetType().Name;
                var isBoneTimeline = typeName.IndexOf("Translate", StringComparison.OrdinalIgnoreCase) >= 0
                    || typeName.IndexOf("Scale", StringComparison.OrdinalIgnoreCase) >= 0
                    || typeName.IndexOf("Rotate", StringComparison.OrdinalIgnoreCase) >= 0;
                var slotIndex = isBoneTimeline ? -1 : ToInt(GetMember(timeline, "SlotIndex") ?? GetMember(timeline, "slotIndex"), -1);
                var boneIndex = isBoneTimeline ? ToInt(GetMember(timeline, "BoneIndex") ?? GetMember(timeline, "boneIndex"), -1) : -1;
                var slotName = SlotName(skeleton, slotIndex);
                var row = new TimelineRow
                {
                    key = key,
                    nodeName = nodeName,
                    timelineIndex = i,
                    timelineType = typeName,
                    slotIndex = slotIndex,
                    slotName = slotName,
                    boneIndex = boneIndex,
                    boneName = BoneName(skeleton, boneIndex),
                    frameCount = ToInt(GetMember(timeline, "FrameCount") ?? GetMember(timeline, "frameCount"), 0),
                    propertyIds = FormatEnumerable(GetMember(timeline, "PropertyIds")),
                    attachmentNames = FormatAttachmentNames(timeline),
                    memberEvidence = SummarizeMembers(timeline)
                };
                if (typeName.IndexOf("Attachment", StringComparison.OrdinalIgnoreCase) >= 0 && IsCandidate(slotName, row.attachmentNames))
                    row.classification = "candidate_attachment_timeline";
                else if (typeName.IndexOf("DrawOrder", StringComparison.OrdinalIgnoreCase) >= 0)
                    row.classification = "draw_order_timeline";
                else if ((typeName.IndexOf("Color", StringComparison.OrdinalIgnoreCase) >= 0 || typeName.IndexOf("RGBA", StringComparison.OrdinalIgnoreCase) >= 0 || typeName.IndexOf("Alpha", StringComparison.OrdinalIgnoreCase) >= 0) && IsCandidate(slotName, ""))
                    row.classification = "candidate_color_or_alpha_timeline";
                else if (isBoneTimeline)
                    row.classification = "bone_transform_timeline";
                else
                    row.classification = "runtime_timeline_trace";
                result.timelineRows.Add(row);
            }
        }

        private static void TraceAttachmentSamples(string key, string nodeName, Skeleton skeleton, Spine.Animation animation, TraceResult result)
        {
            if (skeleton == null)
                return;

            AddAttachmentSnapshot(key, nodeName, "setup_pose", -1f, skeleton, result);
            if (animation == null)
                return;

            var duration = Math.Max(animation.Duration, 0.001f);
            foreach (var requestedTime in SampleTimes)
            {
                var sampleTime = Mathf.Clamp(requestedTime, 0f, duration);
                skeleton.SetToSetupPose();
                animation.Apply(skeleton, 0f, sampleTime, false, null, 1f, MixBlend.Setup, MixDirection.In);
                skeleton.UpdateWorldTransform();
                AddAttachmentSnapshot(key, nodeName, "animation_A", sampleTime, skeleton, result);
            }
        }

        private static void AddAttachmentSnapshot(string key, string nodeName, string sampleKind, float sampleTime, Skeleton skeleton, TraceResult result)
        {
            var drawOrder = skeleton.DrawOrder;
            for (var i = 0; i < drawOrder.Count; i++)
            {
                var slot = drawOrder.Items[i];
                if (slot == null)
                    continue;
                var attachment = slot.Attachment;
                var attachmentName = attachment != null ? attachment.Name : "";
                var slotName = slot.Data != null ? slot.Data.Name : "";
                if (!IsCandidate(slotName, attachmentName))
                    continue;
                var row = new AttachmentSampleRow
                {
                    key = key,
                    nodeName = nodeName,
                    sampleKind = sampleKind,
                    sampleTime = sampleTime,
                    drawOrder = i,
                    slotIndex = slot.Data != null ? slot.Data.Index : -1,
                    slotName = slotName,
                    boneName = slot.Bone != null && slot.Bone.Data != null ? slot.Bone.Data.Name : "",
                    attachmentName = attachmentName,
                    attachmentType = attachment != null ? attachment.GetType().Name : "",
                    visible = attachment != null && slot.A > 0.001f && slot.Bone != null && slot.Bone.Active,
                    alpha = slot.A,
                    color = FormatColor(slot.R, slot.G, slot.B, slot.A),
                    boneActive = slot.Bone != null && slot.Bone.Active,
                    classification = attachment != null && attachment.GetType().Name.IndexOf("Clipping", StringComparison.OrdinalIgnoreCase) >= 0
                        ? "spine_clipping_attachment_present"
                        : "candidate_attachment_visibility_sample"
                };
                result.attachmentRows.Add(row);
            }
        }

        private static void TraceMaskChain(RectTransform rt, SkeletonGraphic sg, TraceResult result)
        {
            var current = rt;
            while (current != null)
            {
                var mask = current.GetComponent<Mask>();
                if (mask != null)
                {
                    result.maskRows.Add(new MaskStencilRow
                    {
                        key = "Spine_shijieanniu",
                        nodeName = "spine_diqiu",
                        kind = "Mask",
                        path = TransformPath(current),
                        enabled = mask.enabled,
                        activeInHierarchy = current.gameObject.activeInHierarchy,
                        showMaskGraphic = mask.showMaskGraphic,
                        graphicName = mask.graphic != null ? mask.graphic.GetType().Name : "",
                        classification = "mask_component_ancestor"
                    });
                }
                var rectMask = current.GetComponent<RectMask2D>();
                if (rectMask != null)
                {
                    result.maskRows.Add(new MaskStencilRow
                    {
                        key = "Spine_shijieanniu",
                        nodeName = "spine_diqiu",
                        kind = "RectMask2D",
                        path = TransformPath(current),
                        enabled = rectMask.enabled,
                        activeInHierarchy = current.gameObject.activeInHierarchy,
                        classification = "rectmask2d_component_ancestor"
                    });
                }
                var group = current.GetComponent<CanvasGroup>();
                if (group != null)
                {
                    result.maskRows.Add(new MaskStencilRow
                    {
                        key = "Spine_shijieanniu",
                        nodeName = "spine_diqiu",
                        kind = "CanvasGroup",
                        path = TransformPath(current),
                        enabled = group.enabled,
                        activeInHierarchy = current.gameObject.activeInHierarchy,
                        alpha = group.alpha,
                        classification = "canvasgroup_ancestor"
                    });
                }
                current = current.parent as RectTransform;
            }

            result.maskRows.Add(new MaskStencilRow
            {
                key = "Spine_shijieanniu",
                nodeName = "spine_diqiu",
                kind = "MaskableGraphic",
                path = TransformPath(rt),
                enabled = sg.enabled,
                activeInHierarchy = rt.gameObject.activeInHierarchy,
                maskable = sg.maskable,
                raycastTarget = sg.raycastTarget,
                canvasRendererTexture = TextureSummary(InvokeNoArg(sg.canvasRenderer, "GetTexture") as Texture),
                classification = "skeleton_graphic_maskable_state"
            });
        }

        private static void TraceMaterials(SkeletonGraphic sg, TraceResult result)
        {
            AddMaterialRow("graphic.material", sg.material, result);
            AddMaterialRow("materialForRendering", sg.materialForRendering, result);
            AddMaterialRow("canvasRenderer.GetMaterial(0)", sg.canvasRenderer.GetMaterial(0), result);
            AddMaterialRow("additiveMaterial", sg.additiveMaterial, result);
            AddMaterialRow("multiplyMaterial", sg.multiplyMaterial, result);
            AddMaterialRow("screenMaterial", sg.screenMaterial, result);
        }

        private static void AddMaterialRow(string source, Material material, TraceResult result)
        {
            var row = new MaterialStencilRow
            {
                key = "Spine_shijieanniu",
                nodeName = "spine_diqiu",
                source = source,
                materialName = material != null ? material.name : "",
                shaderName = material != null && material.shader != null ? material.shader.name : "",
                mainTexture = material != null ? TextureSummary(material.mainTexture) : "",
                renderQueue = material != null ? material.renderQueue : 0,
                passCount = material != null ? material.passCount : 0,
                classification = "material_stencil_trace"
            };
            if (material != null)
            {
                row.hasStencilProperty = material.HasProperty("_Stencil");
                row.stencil = row.hasStencilProperty ? material.GetFloat("_Stencil") : 0f;
                row.stencilComp = material.HasProperty("_StencilComp") ? material.GetFloat("_StencilComp") : 0f;
                row.stencilOp = material.HasProperty("_StencilOp") ? material.GetFloat("_StencilOp") : 0f;
                row.stencilReadMask = material.HasProperty("_StencilReadMask") ? material.GetFloat("_StencilReadMask") : 0f;
                row.stencilWriteMask = material.HasProperty("_StencilWriteMask") ? material.GetFloat("_StencilWriteMask") : 0f;
                row.colorMask = material.HasProperty("_ColorMask") ? material.GetFloat("_ColorMask") : 0f;
                row.useUIAlphaClip = material.HasProperty("_UseUIAlphaClip") ? material.GetFloat("_UseUIAlphaClip") : 0f;
            }
            result.materialRows.Add(row);
        }

        private static string BuildDecision(TraceResult result)
        {
            var candidateRows = result.attachmentRows.Where(r => r.classification == "candidate_attachment_visibility_sample").ToList();
            var invisibleCandidates = candidateRows.Count(r => !r.visible || r.alpha <= 0.001f || string.IsNullOrEmpty(r.attachmentName));
            if (candidateRows.Count > 0 && invisibleCandidates == 0 && result.maskAncestorRows == 0 && result.stencilMaterialEvidenceRows == 0)
                return "No evidence-backed hide/mask patch was found: zhuye_di1, zhuye_bian, and diqiu remain visible with alpha 1 in setup/animation samples, and no Mask/RectMask2D/non-zero stencil material ancestor is present.";
            return "Runtime visibility/mask evidence was found and requires candidate-scene review before any visual patch.";
        }

        private static bool IsCandidate(string slotName, string attachmentName)
        {
            return CandidateSlots.Any(s => EqualsIgnoreCase(s, slotName))
                || CandidateAttachments.Any(s => EqualsIgnoreCase(s, attachmentName))
                || (attachmentName ?? "").IndexOf("zhuye", StringComparison.OrdinalIgnoreCase) >= 0
                || (slotName ?? "").IndexOf("zhuye", StringComparison.OrdinalIgnoreCase) >= 0;
        }

        private static RectTransform FindNode(string nodeName, string rectPathId)
        {
            var all = UnityEngine.Object.FindObjectsByType<RectTransform>(FindObjectsInactive.Include, FindObjectsSortMode.None);
            foreach (var rt in all)
            {
                if (rt == null)
                    continue;
                if (rt.name.StartsWith(nodeName + "__", StringComparison.Ordinal) && rt.name.EndsWith("__" + rectPathId, StringComparison.Ordinal))
                    return rt;
            }
            return all.FirstOrDefault(rt => rt != null && rt.name.StartsWith(nodeName + "__", StringComparison.Ordinal));
        }

        private static string SlotName(Skeleton skeleton, int slotIndex)
        {
            if (skeleton == null || slotIndex < 0 || slotIndex >= skeleton.Slots.Count)
                return "";
            var slot = skeleton.Slots.Items[slotIndex];
            return slot != null && slot.Data != null ? slot.Data.Name : "";
        }

        private static string BoneName(Skeleton skeleton, int boneIndex)
        {
            if (skeleton == null || boneIndex < 0 || boneIndex >= skeleton.Bones.Count)
                return "";
            var bone = skeleton.Bones.Items[boneIndex];
            return bone != null && bone.Data != null ? bone.Data.Name : "";
        }

        private static object GetMember(object target, string name)
        {
            if (target == null || string.IsNullOrEmpty(name))
                return null;
            var type = target.GetType();
            var property = type.GetProperty(name, BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance);
            if (property != null)
            {
                try { return property.GetValue(target, null); }
                catch { }
            }
            var field = type.GetField(name, BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance);
            if (field != null)
            {
                try { return field.GetValue(target); }
                catch { }
            }
            return null;
        }

        private static object InvokeNoArg(object target, string name)
        {
            if (target == null)
                return null;
            var method = target.GetType().GetMethod(name, BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance, null, Type.EmptyTypes, null);
            return method != null ? method.Invoke(target, null) : null;
        }

        private static string FormatAttachmentNames(object timeline)
        {
            var direct = GetMember(timeline, "AttachmentNames") ?? GetMember(timeline, "attachmentNames");
            if (direct == null)
                return "";
            if (direct is string[] strings)
                return string.Join("|", strings.Where(s => !string.IsNullOrEmpty(s)).ToArray());
            if (direct is Array array)
            {
                var values = new List<string>();
                foreach (var item in array)
                    if (item != null)
                        values.Add(item.ToString());
                return string.Join("|", values.ToArray());
            }
            return direct.ToString();
        }

        private static string FormatEnumerable(object value)
        {
            if (value == null)
                return "";
            if (value is System.Collections.IEnumerable enumerable && !(value is string))
            {
                var values = new List<string>();
                foreach (var item in enumerable)
                {
                    if (item != null)
                        values.Add(item.ToString());
                    if (values.Count >= 12)
                        break;
                }
                return string.Join("|", values.ToArray());
            }
            return value.ToString();
        }

        private static string SummarizeMembers(object value)
        {
            if (value == null)
                return "";
            var type = value.GetType();
            var names = type.GetFields(BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance)
                .Select(f => f.Name)
                .Concat(type.GetProperties(BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance).Select(p => p.Name))
                .Distinct()
                .Take(18);
            return string.Join("|", names.ToArray());
        }

        private static List<Dictionary<string, string>> LoadCsv(string path)
        {
            var rows = new List<Dictionary<string, string>>();
            if (!File.Exists(path))
                return rows;
            var lines = File.ReadAllLines(path, Encoding.UTF8);
            if (lines.Length == 0)
                return rows;
            var headers = SplitCsvLine(lines[0]);
            for (var i = 1; i < lines.Length; i++)
            {
                if (string.IsNullOrWhiteSpace(lines[i]))
                    continue;
                var values = SplitCsvLine(lines[i]);
                var row = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
                for (var c = 0; c < headers.Count; c++)
                    row[headers[c]] = c < values.Count ? values[c] : "";
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
                    values.Add(sb.ToString());
                    sb.Length = 0;
                }
                else
                {
                    sb.Append(ch);
                }
            }
            values.Add(sb.ToString());
            return values;
        }

        private static string Get(Dictionary<string, string> row, string key)
        {
            return row != null && row.TryGetValue(key, out var value) ? value ?? "" : "";
        }

        private static int ToInt(object value, int fallback)
        {
            try { return Convert.ToInt32(value, CultureInfo.InvariantCulture); }
            catch { return fallback; }
        }

        private static bool EqualsIgnoreCase(string a, string b)
        {
            return string.Equals(a ?? "", b ?? "", StringComparison.OrdinalIgnoreCase);
        }

        private static string MaterialSummary(Material material)
        {
            if (material == null)
                return "";
            var shaderName = material.shader != null ? material.shader.name : "";
            return material.name + " / " + shaderName + " / " + TextureSummary(material.mainTexture);
        }

        private static string TextureSummary(Texture texture)
        {
            return texture != null ? texture.name + " " + texture.width + "x" + texture.height : "";
        }

        private static string TransformPath(Transform transform)
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

        private static string Format(Vector2 value)
        {
            return value.x.ToString("0.####", CultureInfo.InvariantCulture) + "," + value.y.ToString("0.####", CultureInfo.InvariantCulture);
        }

        private static string Format(Vector3 value)
        {
            return value.x.ToString("0.####", CultureInfo.InvariantCulture) + "," + value.y.ToString("0.####", CultureInfo.InvariantCulture) + "," + value.z.ToString("0.####", CultureInfo.InvariantCulture);
        }

        private static string FormatColor(float r, float g, float b, float a)
        {
            return r.ToString("0.####", CultureInfo.InvariantCulture) + "," + g.ToString("0.####", CultureInfo.InvariantCulture) + "," + b.ToString("0.####", CultureInfo.InvariantCulture) + "," + a.ToString("0.####", CultureInfo.InvariantCulture);
        }

        private static void WriteOutputs(TraceResult result)
        {
            File.WriteAllText(ResultJson, JsonUtility.ToJson(result, true), Encoding.UTF8);
            var sb = new StringBuilder();
            sb.AppendLine("kind,key,node,name,path,classification,detail1,detail2,detail3,decision");
            foreach (var row in result.targetRows)
            {
                sb.AppendLine(string.Join(",", new[]
                {
                    Csv("Target"),
                    Csv(row.key),
                    Csv(row.nodeName),
                    Csv(row.nodeName),
                    Csv(row.sceneObjectPath),
                    Csv(row.decision),
                    Csv("animationFound=" + row.animationFound + ";duration=" + row.animationDuration.ToString("0.####", CultureInfo.InvariantCulture) + ";slots=" + row.slotCount + ";drawOrder=" + row.drawOrderCount),
                    Csv("mesh=" + row.meshVertexCount + "/" + row.meshTriangleIndexCount + ";submesh=" + row.meshSubMeshCount + ";bounds=" + row.meshBoundsCenter + "/" + row.meshBoundsSize),
                    Csv("maskable=" + row.maskable + ";maskAncestor=" + row.maskAncestorFound + ";nonZeroStencil=" + row.nonZeroStencilMaterialFound + ";canvasRendererTexture=" + row.canvasRendererTexture),
                    Csv(row.reason)
                }));
            }
            foreach (var row in result.attachmentRows)
            {
                sb.AppendLine(string.Join(",", new[]
                {
                    Csv("AttachmentSample"),
                    Csv(row.key),
                    Csv(row.nodeName),
                    Csv(row.attachmentName),
                    Csv(row.slotName),
                    Csv(row.classification),
                    Csv("sample=" + row.sampleKind + ";time=" + row.sampleTime.ToString("0.####", CultureInfo.InvariantCulture) + ";drawOrder=" + row.drawOrder + ";slotIndex=" + row.slotIndex),
                    Csv("type=" + row.attachmentType + ";bone=" + row.boneName + ";boneActive=" + row.boneActive),
                    Csv("visible=" + row.visible + ";alpha=" + row.alpha.ToString("0.####", CultureInfo.InvariantCulture) + ";color=" + row.color),
                    Csv("")
                }));
            }
            foreach (var row in result.timelineRows)
            {
                sb.AppendLine(string.Join(",", new[]
                {
                    Csv("Timeline"),
                    Csv(row.key),
                    Csv(row.nodeName),
                    Csv(row.timelineType),
                    Csv(row.slotName),
                    Csv(row.classification),
                    Csv("index=" + row.timelineIndex + ";slotIndex=" + row.slotIndex + ";slot=" + row.slotName + ";boneIndex=" + row.boneIndex + ";bone=" + row.boneName + ";frameCount=" + row.frameCount),
                    Csv("attachments=" + row.attachmentNames),
                    Csv("propertyIds=" + row.propertyIds + ";members=" + row.memberEvidence),
                    Csv("")
                }));
            }
            foreach (var row in result.maskRows)
            {
                sb.AppendLine(string.Join(",", new[]
                {
                    Csv("MaskStencil"),
                    Csv(row.key),
                    Csv(row.nodeName),
                    Csv(row.kind),
                    Csv(row.path),
                    Csv(row.classification),
                    Csv("enabled=" + row.enabled + ";active=" + row.activeInHierarchy),
                    Csv("maskable=" + row.maskable + ";raycastTarget=" + row.raycastTarget + ";showMaskGraphic=" + row.showMaskGraphic),
                    Csv("alpha=" + row.alpha.ToString("0.####", CultureInfo.InvariantCulture) + ";canvasRendererTexture=" + row.canvasRendererTexture + ";graphic=" + row.graphicName),
                    Csv("")
                }));
            }
            foreach (var row in result.materialRows)
            {
                sb.AppendLine(string.Join(",", new[]
                {
                    Csv("Material"),
                    Csv(row.key),
                    Csv(row.nodeName),
                    Csv(row.source),
                    Csv(row.materialName),
                    Csv(row.classification),
                    Csv("shader=" + row.shaderName + ";texture=" + row.mainTexture + ";queue=" + row.renderQueue + ";pass=" + row.passCount),
                    Csv("hasStencil=" + row.hasStencilProperty + ";stencil=" + row.stencil + ";comp=" + row.stencilComp + ";op=" + row.stencilOp),
                    Csv("readMask=" + row.stencilReadMask + ";writeMask=" + row.stencilWriteMask + ";colorMask=" + row.colorMask + ";uiAlphaClip=" + row.useUIAlphaClip),
                    Csv("")
                }));
            }
            File.WriteAllText(ResultCsv, sb.ToString(), Encoding.UTF8);
            AssetDatabase.Refresh(ImportAssetOptions.ForceSynchronousImport);
        }

        private static string Csv(string value)
        {
            value = value ?? "";
            return "\"" + value.Replace("\"", "\"\"") + "\"";
        }

        [Serializable]
        private sealed class TraceResult
        {
            public string generatedAt;
            public string status;
            public string visualVerdict;
            public string scenePath;
            public int visualFixApplied;
            public int targetsConsidered;
            public int targetsTraced;
            public int sampleRows;
            public int timelineRowsCount;
            public int maskStencilRows;
            public int materialRowsCount;
            public int visibilityOffEvidenceRows;
            public int clippingAttachmentRows;
            public int maskAncestorRows;
            public int stencilMaterialEvidenceRows;
            public string decision;
            public string nextBlocker;
            public List<TargetRow> targetRows;
            public List<AttachmentSampleRow> attachmentRows;
            public List<TimelineRow> timelineRows;
            public List<MaskStencilRow> maskRows;
            public List<MaterialStencilRow> materialRows;
        }

        [Serializable]
        private sealed class TargetRow
        {
            public string key;
            public string nodeName;
            public string rectPathId;
            public string expectedAnimation;
            public bool sceneNodeFound;
            public bool skeletonGraphicFound;
            public string sceneObjectPath;
            public string parentPath;
            public int siblingIndex;
            public string anchoredPosition;
            public string sizeDelta;
            public string localScale;
            public string anchorMin;
            public string anchorMax;
            public string pivot;
            public bool activeInHierarchy;
            public bool animationFound;
            public float animationDuration;
            public int slotCount;
            public int drawOrderCount;
            public bool maskable;
            public bool raycastTarget;
            public int canvasRendererMaterialCount;
            public string canvasRendererTexture;
            public string mainTexture;
            public string materialForRendering;
            public int meshVertexCount;
            public int meshTriangleIndexCount;
            public int meshSubMeshCount;
            public string meshBoundsCenter;
            public string meshBoundsSize;
            public string originalMaterialRefs;
            public int candidateSampleRows;
            public int candidateVisibleRows;
            public int candidateInvisibleRows;
            public bool clippingSlotFound;
            public bool maskAncestorFound;
            public bool nonZeroStencilMaterialFound;
            public string decision;
            public string reason;
        }

        [Serializable]
        private sealed class AttachmentSampleRow
        {
            public string key;
            public string nodeName;
            public string sampleKind;
            public float sampleTime;
            public int drawOrder;
            public int slotIndex;
            public string slotName;
            public string boneName;
            public string attachmentName;
            public string attachmentType;
            public bool visible;
            public float alpha;
            public string color;
            public bool boneActive;
            public string classification;
        }

        [Serializable]
        private sealed class TimelineRow
        {
            public string key;
            public string nodeName;
            public int timelineIndex;
            public string timelineType;
            public int slotIndex;
            public string slotName;
            public int boneIndex;
            public string boneName;
            public int frameCount;
            public string propertyIds;
            public string attachmentNames;
            public string memberEvidence;
            public string classification;
        }

        [Serializable]
        private sealed class MaskStencilRow
        {
            public string key;
            public string nodeName;
            public string kind;
            public string path;
            public bool enabled;
            public bool activeInHierarchy;
            public bool showMaskGraphic;
            public string graphicName;
            public float alpha;
            public bool maskable;
            public bool raycastTarget;
            public string canvasRendererTexture;
            public string classification;
        }

        [Serializable]
        private sealed class MaterialStencilRow
        {
            public string key;
            public string nodeName;
            public string source;
            public string materialName;
            public string shaderName;
            public string mainTexture;
            public int renderQueue;
            public int passCount;
            public bool hasStencilProperty;
            public float stencil;
            public float stencilComp;
            public float stencilOp;
            public float stencilReadMask;
            public float stencilWriteMask;
            public float colorMask;
            public float useUIAlphaClip;
            public string classification;
        }
    }
}
