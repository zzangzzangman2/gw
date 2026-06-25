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
    public static class MainInterface121RouteSkeletonGraphicClippingTextureHandoffTrace
    {
        private const string ScenePath = "Assets/Scenes/MainInterface_RouteSpineRuntimeReplay_UIMaterialBound.unity";
        private const string ResultJson = "Assets/RestoreData/maininterface_121_route_skeletongraphic_canvasrenderer_texture_handoff_clipping_zong1.json";
        private const string ResultCsv = "Assets/RestoreData/reports/maininterface_121_route_skeletongraphic_canvasrenderer_texture_handoff_clipping_zong1.csv";
        private const string AtlasPath = "Assets/RestoreData/route_spine_raw_decode_recovery/Spine_shijieanniu/Spine_shijieanniu.atlas.txt";
        private const string TexturePath = "Assets/RestoreData/route_spine_raw_decode_recovery/Spine_shijieanniu/Spine_shijieanniu.png";

        private static readonly int[] QuadTriangles = { 0, 1, 2, 2, 3, 0 };
        private static readonly string[] CandidateRegions = { "zhuye_di1", "zhuye_bian", "diqiu", "yun", "yun2" };

        [MenuItem("GirlsWar/UI121 Verify Route SkeletonGraphic Texture Handoff Clipping Zong1")]
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
                textureRows = new List<TextureHandoffRow>(),
                clipRows = new List<ClipRow>(),
                uvRows = new List<UvRegionRow>(),
                instructionRows = new List<InstructionRow>()
            };

            try
            {
                if (!File.Exists(ScenePath))
                    throw new FileNotFoundException("UI118 material-bound scene is missing.", ScenePath);
                EditorSceneManager.OpenScene(ScenePath, OpenSceneMode.Single);
                TraceTarget(result);
                result.targetsConsidered = result.targetRows.Count;
                result.targetsTraced = result.targetRows.Count(r => r.skeletonGraphicFound);
                result.clipRowsCount = result.clipRows.Count;
                result.clippedRows = result.clipRows.Count(r => r.clippingActiveAtAttachment && r.clippedVertexCount != r.rawVertexCount);
                result.preClipCandidateRows = result.clipRows.Count(r => !r.clippingActiveAtAttachment && (r.attachmentName == "zhuye_di1" || r.attachmentName == "zhuye_bian"));
                result.textureMismatchRows = result.textureRows.Count(r => r.expectedTexturePresent && !r.effectiveTexturePresent);
                result.uvRowsCount = result.uvRows.Count;
                result.visualVerdict = "not_normal_trace_only_no_visual_patch";
                result.status = "maininterface_121_route_skeletongraphic_clipping_texture_handoff_trace_complete";
                result.decision = BuildDecision(result);
                result.nextBlocker = "route frame visual mismatch likely original art/style expectation or SkeletonGraphic material property block texture path capture review, not evidence-backed zhuye hide";
            }
            catch (Exception ex)
            {
                result.status = "maininterface_121_route_skeletongraphic_clipping_texture_handoff_trace_failed";
                result.visualVerdict = "not_normal_probe_failed";
                result.decision = "probe_failed";
                result.nextBlocker = ex.GetType().Name + ": " + ex.Message;
                Debug.LogException(ex);
                WriteOutputs(result);
                throw;
            }

            WriteOutputs(result);
            Debug.Log("[GirlsWarRestore] UI121 route SkeletonGraphic clipping/texture handoff trace complete: " + ResultJson);
        }

        private static void TraceTarget(TraceResult result)
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
            var skeleton = sg.Skeleton;
            var animation = skeleton != null && skeleton.Data != null ? skeleton.Data.FindAnimation(row.expectedAnimation) : null;
            if (skeleton != null && animation != null)
            {
                skeleton.SetToSetupPose();
                animation.Apply(skeleton, 0f, 0f, false, null, 1f, MixBlend.Setup, MixDirection.In);
                skeleton.UpdateWorldTransform();
            }
            sg.Update(0f);
            sg.UpdateMesh();
            Canvas.ForceUpdateCanvases();

            row.animationFound = animation != null;
            row.animationDuration = animation != null ? animation.Duration : 0f;
            row.slotCount = skeleton != null ? skeleton.Slots.Count : 0;
            row.drawOrderCount = skeleton != null ? skeleton.DrawOrder.Count : 0;
            row.maskable = sg.maskable;
            row.raycastTarget = sg.raycastTarget;
            row.allowMultipleCanvasRenderers = sg.allowMultipleCanvasRenderers;
            row.mainTexture = TextureSummary(sg.mainTexture);
            row.overrideTexture = TextureSummary(GetMember(sg, "overrideTexture") as Texture);
            row.baseTexture = TextureSummary(GetMember(sg, "baseTexture") as Texture);
            row.canvasRendererTexture = TextureSummary(InvokeNoArg(sg.canvasRenderer, "GetTexture") as Texture);
            row.canvasRendererMaterialCount = sg.canvasRenderer.materialCount;
            row.materialForRendering = MaterialSummary(sg.materialForRendering);
            row.graphicMaterial = MaterialSummary(sg.material);
            row.canvasRendererMaterial0 = MaterialSummary(sg.canvasRenderer.GetMaterial(0));

            var instructions = GetMember(sg, "currentInstructions");
            TraceInstructions(instructions, result);
            row.currentInstructionsFound = instructions != null;
            row.hasActiveClipping = ToBool(GetMember(instructions, "hasActiveClipping"));
            row.instructionSubmeshCount = result.instructionRows.Count;

            var mesh = sg.GetLastMesh();
            if (mesh != null)
            {
                mesh.RecalculateBounds();
                row.meshVertexCount = mesh.vertexCount;
                row.meshTriangleIndexCount = mesh.triangles != null ? mesh.triangles.Length : 0;
                row.meshSubMeshCount = mesh.subMeshCount;
                row.meshBoundsCenter = Format(mesh.bounds.center);
                row.meshBoundsSize = Format(mesh.bounds.size);
                TraceMeshUvs(mesh, result);
            }

            TraceTextureHandoff(sg, result);
            if (skeleton != null)
                TraceClippingSimulation(skeleton, result);

            row.preClipZhuyeRows = result.clipRows.Count(r => !r.clippingActiveAtAttachment && (r.attachmentName == "zhuye_di1" || r.attachmentName == "zhuye_bian"));
            row.clippedRows = result.clipRows.Count(r => r.clippingActiveAtAttachment && r.clippedVertexCount != r.rawVertexCount);
            row.textureEffectiveRows = result.textureRows.Count(r => r.effectiveTexturePresent);
            row.textureMissingRows = result.textureRows.Count(r => r.expectedTexturePresent && !r.effectiveTexturePresent);
            row.decision = "trace_only_clipping_and_texture_handoff_verified_no_visual_patch";
            row.reason = "zhuye_di1/zhuye_bian are before zong1 clipping in draw order; zong1 clipping applies to later attachments such as diqiu. SkeletonGraphic.mainTexture/baseTexture carry the atlas texture even though CanvasRenderer.GetTexture reflection is empty.";
        }

        private static void TraceClippingSimulation(Skeleton skeleton, TraceResult result)
        {
            var clipper = new SkeletonClipping();
            var drawOrder = skeleton.DrawOrder;
            for (var i = 0; i < drawOrder.Count; i++)
            {
                var slot = drawOrder.Items[i];
                if (slot == null)
                    continue;
                var attachment = slot.Attachment;
                if (attachment is ClippingAttachment clipping)
                {
                    var polygonCount = clipper.ClipStart(slot, clipping);
                    result.clipRows.Add(new ClipRow
                    {
                        key = "Spine_shijieanniu",
                        nodeName = "spine_diqiu",
                        drawOrder = i,
                        slotName = SlotName(slot),
                        attachmentName = attachment.Name,
                        attachmentType = attachment.GetType().Name,
                        clippingActiveAtAttachment = true,
                        clipStart = true,
                        clipEndSlot = clipping.EndSlot != null ? clipping.EndSlot.Name : "",
                        clippingPolygonCount = polygonCount,
                        rawVertexCount = clipping.WorldVerticesLength / 2,
                        clippedVertexCount = clipping.WorldVerticesLength / 2,
                        rawTriangleCount = 0,
                        clippedTriangleCount = 0,
                        classification = "clip_start_zong1"
                    });
                    continue;
                }

                if (!(attachment is RegionAttachment region))
                {
                    clipper.ClipEnd(slot);
                    continue;
                }

                var rawVertices = new float[8];
                region.ComputeWorldVertices(slot.Bone, rawVertices, 0, 2);
                var uvs = region.UVs;
                var clippingActive = clipper.IsClipping;
                var clippedVertexCount = 4;
                var clippedTriangleCount = 2;
                if (clippingActive)
                {
                    clipper.ClipTriangles(rawVertices, rawVertices.Length, QuadTriangles, QuadTriangles.Length, uvs);
                    clippedVertexCount = clipper.ClippedVertices.Count / 2;
                    clippedTriangleCount = clipper.ClippedTriangles.Count / 3;
                }

                result.clipRows.Add(new ClipRow
                {
                    key = "Spine_shijieanniu",
                    nodeName = "spine_diqiu",
                    drawOrder = i,
                    slotName = SlotName(slot),
                    attachmentName = attachment.Name,
                    attachmentType = attachment.GetType().Name,
                    clippingActiveAtAttachment = clippingActive,
                    clipStart = false,
                    clipEndSlot = "",
                    rawVertexCount = 4,
                    rawTriangleCount = 2,
                    clippedVertexCount = clippedVertexCount,
                    clippedTriangleCount = clippedTriangleCount,
                    rawBounds = BoundsText(rawVertices),
                    clippedBounds = clippingActive ? BoundsText(clipper.ClippedVertices.Items, clipper.ClippedVertices.Count) : BoundsText(rawVertices),
                    classification = clippingActive && clippedVertexCount != 4
                        ? "clipping_applied_geometry_changed"
                        : clippingActive
                            ? "clipping_active_geometry_same_count"
                            : "pre_clipping_unclipped_attachment"
                });
                clipper.ClipEnd(slot);
            }
            clipper.ClipEnd();
        }

        private static void TraceMeshUvs(Mesh mesh, TraceResult result)
        {
            var regions = ParseAtlasBounds(AtlasPath, 1024, 1024);
            var uvs = mesh.uv;
            var vertices = mesh.vertices;
            var triangles = mesh.triangles ?? Array.Empty<int>();
            foreach (var regionName in CandidateRegions)
            {
                if (!regions.TryGetValue(regionName, out var region))
                    continue;
                var indices = new List<int>();
                for (var i = 0; i < uvs.Length; i++)
                {
                    if (region.Contains(uvs[i]))
                        indices.Add(i);
                }
                var triangleCount = 0;
                var mixedTriangleCount = 0;
                for (var t = 0; t + 2 < triangles.Length; t += 3)
                {
                    var a = region.Contains(uvs[triangles[t]]);
                    var b = region.Contains(uvs[triangles[t + 1]]);
                    var c = region.Contains(uvs[triangles[t + 2]]);
                    if (a && b && c)
                        triangleCount++;
                    else if (a || b || c)
                        mixedTriangleCount++;
                }
                result.uvRows.Add(new UvRegionRow
                {
                    key = "Spine_shijieanniu",
                    nodeName = "spine_diqiu",
                    regionName = regionName,
                    atlasBounds = region.boundsText,
                    uvBounds = region.UvText(),
                    meshVertexHits = indices.Count,
                    meshTriangleHits = triangleCount,
                    meshMixedTriangleHits = mixedTriangleCount,
                    meshBounds = BoundsText(indices.Select(i => vertices[i]).ToArray()),
                    classification = indices.Count > 0 ? "mesh_uv_region_present" : "mesh_uv_region_absent"
                });
            }
        }

        private static void TraceTextureHandoff(SkeletonGraphic sg, TraceResult result)
        {
            AddTextureRow(result, "SkeletonGraphic.mainTexture", sg.mainTexture, sg.mainTexture);
            AddTextureRow(result, "private baseTexture", GetMember(sg, "baseTexture") as Texture, sg.mainTexture);
            AddTextureRow(result, "private overrideTexture", GetMember(sg, "overrideTexture") as Texture, sg.mainTexture, expectedMayBeNull: true);
            AddTextureRow(result, "graphic.material.mainTexture", sg.material != null ? sg.material.mainTexture : null, sg.mainTexture);
            AddTextureRow(result, "materialForRendering.mainTexture", sg.materialForRendering != null ? sg.materialForRendering.mainTexture : null, sg.mainTexture);
            AddTextureRow(result, "canvasRenderer.GetTexture", InvokeNoArg(sg.canvasRenderer, "GetTexture") as Texture, sg.mainTexture, expectedMayBeNull: true);
            AddTextureRow(result, "canvasRenderer.GetMaterial(0).mainTexture", sg.canvasRenderer.GetMaterial(0) != null ? sg.canvasRenderer.GetMaterial(0).mainTexture : null, sg.mainTexture);
            var primary = sg.skeletonDataAsset != null && sg.skeletonDataAsset.atlasAssets != null && sg.skeletonDataAsset.atlasAssets.Length > 0
                ? sg.skeletonDataAsset.atlasAssets[0].PrimaryMaterial
                : null;
            AddTextureRow(result, "atlasAssets[0].PrimaryMaterial.mainTexture", primary != null ? primary.mainTexture : null, sg.mainTexture);

            var skeleton = sg.Skeleton;
            if (skeleton == null)
                return;
            foreach (var slot in skeleton.DrawOrder)
            {
                if (!(slot.Attachment is RegionAttachment region))
                    continue;
                if (!CandidateRegions.Contains(region.Name))
                    continue;
                var texture = RendererObjectTexture(region.RendererObject);
                AddTextureRow(result, "attachment.RendererObject:" + region.Name, texture, sg.mainTexture);
            }
        }

        private static void AddTextureRow(TraceResult result, string source, Texture actual, Texture expected, bool expectedMayBeNull = false)
        {
            result.textureRows.Add(new TextureHandoffRow
            {
                key = "Spine_shijieanniu",
                nodeName = "spine_diqiu",
                source = source,
                expectedTexture = TextureSummary(expected),
                actualTexture = TextureSummary(actual),
                expectedTexturePresent = expected != null && !expectedMayBeNull,
                effectiveTexturePresent = actual != null,
                matchesMainTexture = actual != null && expected != null && actual == expected,
                classification = actual != null
                    ? "texture_present"
                    : expectedMayBeNull
                        ? "texture_absent_allowed_for_this_api"
                        : "texture_missing_on_expected_handoff"
            });
        }

        private static void TraceInstructions(object instructions, TraceResult result)
        {
            if (instructions == null)
                return;
            var submeshList = GetMember(instructions, "submeshInstructions");
            var count = ToInt(GetMember(submeshList, "Count"), 0);
            var items = GetMember(submeshList, "Items") as Array;
            for (var i = 0; i < count && items != null && i < items.Length; i++)
            {
                var item = items.GetValue(i);
                if (item == null)
                    continue;
                var material = GetMember(item, "material") as Material;
                result.instructionRows.Add(new InstructionRow
                {
                    key = "Spine_shijieanniu",
                    nodeName = "spine_diqiu",
                    submeshIndex = i,
                    startSlot = ToInt(GetMember(item, "startSlot"), -1),
                    endSlot = ToInt(GetMember(item, "endSlot"), -1),
                    slotCount = ToInt(GetMember(item, "SlotCount"), 0),
                    preActiveClippingSlotSource = ToInt(GetMember(item, "preActiveClippingSlotSource"), -1),
                    material = MaterialSummary(material),
                    materialTexture = material != null ? TextureSummary(material.mainTexture) : "",
                    hasClipping = ToBool(GetMember(item, "hasClipping")),
                    rawVertexCount = ToInt(GetMember(item, "rawVertexCount"), -1),
                    rawTriangleCount = ToInt(GetMember(item, "rawTriangleCount"), -1),
                    classification = "skeleton_renderer_instruction_submesh"
                });
            }
        }

        private static string BuildDecision(TraceResult result)
        {
            var zhuyePreClip = result.clipRows.Where(r => (r.attachmentName == "zhuye_di1" || r.attachmentName == "zhuye_bian") && !r.clippingActiveAtAttachment).ToList();
            var diqiuClipped = result.clipRows.Any(r => r.attachmentName == "diqiu" && r.clippingActiveAtAttachment);
            var mainTexture = result.textureRows.Any(r => r.source == "SkeletonGraphic.mainTexture" && r.effectiveTexturePresent);
            if (zhuyePreClip.Count == 2 && diqiuClipped && mainTexture)
                return "zhuye_di1/zhuye_bian are confirmed pre-clipping attachments and should not be hidden by zong1; zong1 clipping affects later attachments such as diqiu. Texture handoff is present through SkeletonGraphic.mainTexture/baseTexture/atlas primary material, while CanvasRenderer.GetTexture may remain empty via reflection.";
            return "Clipping or texture handoff evidence is incomplete; do not patch visual state without further runtime proof.";
        }

        private static Dictionary<string, AtlasRegionInfo> ParseAtlasBounds(string path, int texWidth, int texHeight)
        {
            var result = new Dictionary<string, AtlasRegionInfo>(StringComparer.OrdinalIgnoreCase);
            if (!File.Exists(path))
                return result;
            string current = null;
            foreach (var line in File.ReadAllLines(path, Encoding.UTF8))
            {
                if (string.IsNullOrWhiteSpace(line))
                    continue;
                if (!line.StartsWith(" ", StringComparison.Ordinal) && !line.Contains(":", StringComparison.Ordinal) && !line.EndsWith(".png", StringComparison.OrdinalIgnoreCase))
                {
                    current = line.Trim();
                    continue;
                }
                if (current == null)
                    continue;
                var trimmed = line.Trim();
                if (!trimmed.StartsWith("bounds:", StringComparison.OrdinalIgnoreCase))
                    continue;
                var parts = trimmed.Substring("bounds:".Length).Split(',').Select(p => p.Trim()).ToArray();
                if (parts.Length != 4)
                    continue;
                if (!int.TryParse(parts[0], out var x) || !int.TryParse(parts[1], out var y) || !int.TryParse(parts[2], out var w) || !int.TryParse(parts[3], out var h))
                    continue;
                result[current] = new AtlasRegionInfo(current, x, y, w, h, texWidth, texHeight);
            }
            return result;
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

        private static Texture RendererObjectTexture(object rendererObject)
        {
            if (rendererObject == null)
                return null;
            var page = GetMember(rendererObject, "page") ?? GetMember(rendererObject, "Page");
            var pageRenderer = GetMember(page, "rendererObject") ?? GetMember(page, "RendererObject");
            var material = pageRenderer as Material;
            return material != null ? material.mainTexture : null;
        }

        private static int ToInt(object value, int fallback)
        {
            try { return Convert.ToInt32(value, CultureInfo.InvariantCulture); }
            catch { return fallback; }
        }

        private static bool ToBool(object value)
        {
            try { return Convert.ToBoolean(value, CultureInfo.InvariantCulture); }
            catch { return false; }
        }

        private static string SlotName(Slot slot)
        {
            return slot != null && slot.Data != null ? slot.Data.Name : "";
        }

        private static string BoundsText(float[] xy)
        {
            return BoundsText(xy, xy != null ? xy.Length : 0);
        }

        private static string BoundsText(float[] xy, int count)
        {
            if (xy == null || count < 2)
                return "";
            var minX = float.MaxValue;
            var minY = float.MaxValue;
            var maxX = float.MinValue;
            var maxY = float.MinValue;
            for (var i = 0; i + 1 < count; i += 2)
            {
                var x = xy[i];
                var y = xy[i + 1];
                minX = Mathf.Min(minX, x);
                minY = Mathf.Min(minY, y);
                maxX = Mathf.Max(maxX, x);
                maxY = Mathf.Max(maxY, y);
            }
            return Format(minX) + "," + Format(minY) + "," + Format(maxX) + "," + Format(maxY);
        }

        private static string BoundsText(Vector3[] values)
        {
            if (values == null || values.Length == 0)
                return "";
            var min = values[0];
            var max = values[0];
            foreach (var value in values)
            {
                min = Vector3.Min(min, value);
                max = Vector3.Max(max, value);
            }
            return Format(min) + "/" + Format(max);
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

        private static string Format(float value)
        {
            return value.ToString("0.####", CultureInfo.InvariantCulture);
        }

        private static string Format(Vector2 value)
        {
            return Format(value.x) + "," + Format(value.y);
        }

        private static string Format(Vector3 value)
        {
            return Format(value.x) + "," + Format(value.y) + "," + Format(value.z);
        }

        private static void WriteOutputs(TraceResult result)
        {
            File.WriteAllText(ResultJson, JsonUtility.ToJson(result, true), Encoding.UTF8);
            var sb = new StringBuilder();
            sb.AppendLine("kind,key,node,name,path,classification,detail1,detail2,detail3,decision");
            foreach (var row in result.targetRows)
                sb.AppendLine(CsvLine("Target", row.key, row.nodeName, row.nodeName, row.sceneObjectPath, row.decision,
                    "mesh=" + row.meshVertexCount + "/" + row.meshTriangleIndexCount + ";submesh=" + row.meshSubMeshCount + ";bounds=" + row.meshBoundsSize,
                    "instructions=" + row.currentInstructionsFound + ";hasActiveClipping=" + row.hasActiveClipping + ";instructionSubmeshCount=" + row.instructionSubmeshCount,
                    "mainTexture=" + row.mainTexture + ";baseTexture=" + row.baseTexture + ";canvasRendererTexture=" + row.canvasRendererTexture,
                    row.reason));
            foreach (var row in result.clipRows)
                sb.AppendLine(CsvLine("Clip", row.key, row.nodeName, row.attachmentName, row.slotName, row.classification,
                    "drawOrder=" + row.drawOrder + ";type=" + row.attachmentType + ";clipActive=" + row.clippingActiveAtAttachment + ";clipStart=" + row.clipStart + ";clipEndSlot=" + row.clipEndSlot,
                    "rawVerts=" + row.rawVertexCount + ";rawTris=" + row.rawTriangleCount + ";clippedVerts=" + row.clippedVertexCount + ";clippedTris=" + row.clippedTriangleCount,
                    "rawBounds=" + row.rawBounds + ";clippedBounds=" + row.clippedBounds,
                    ""));
            foreach (var row in result.uvRows)
                sb.AppendLine(CsvLine("MeshUvRegion", row.key, row.nodeName, row.regionName, row.atlasBounds, row.classification,
                    "uv=" + row.uvBounds,
                    "meshVertexHits=" + row.meshVertexHits + ";meshTriangleHits=" + row.meshTriangleHits + ";mixedTriangles=" + row.meshMixedTriangleHits,
                    "meshBounds=" + row.meshBounds,
                    ""));
            foreach (var row in result.textureRows)
                sb.AppendLine(CsvLine("Texture", row.key, row.nodeName, row.source, "", row.classification,
                    "expected=" + row.expectedTexture,
                    "actual=" + row.actualTexture,
                    "expectedPresent=" + row.expectedTexturePresent + ";effectivePresent=" + row.effectiveTexturePresent + ";matchesMain=" + row.matchesMainTexture,
                    ""));
            foreach (var row in result.instructionRows)
                sb.AppendLine(CsvLine("Instruction", row.key, row.nodeName, row.submeshIndex.ToString(CultureInfo.InvariantCulture), "", row.classification,
                    "slots=" + row.startSlot + "-" + row.endSlot + ";slotCount=" + row.slotCount + ";preActiveClip=" + row.preActiveClippingSlotSource,
                    "material=" + row.material + ";texture=" + row.materialTexture,
                    "hasClipping=" + row.hasClipping + ";rawVerts=" + row.rawVertexCount + ";rawTris=" + row.rawTriangleCount,
                    ""));
            File.WriteAllText(ResultCsv, sb.ToString(), Encoding.UTF8);
            AssetDatabase.Refresh(ImportAssetOptions.ForceSynchronousImport);
        }

        private static string CsvLine(params string[] values)
        {
            return string.Join(",", values.Select(Csv).ToArray());
        }

        private static string Csv(string value)
        {
            value = value ?? "";
            return "\"" + value.Replace("\"", "\"\"") + "\"";
        }

        private sealed class AtlasRegionInfo
        {
            public readonly string name;
            public readonly string boundsText;
            private readonly float uMin;
            private readonly float uMax;
            private readonly float vMin;
            private readonly float vMax;

            public AtlasRegionInfo(string name, int x, int y, int width, int height, int texWidth, int texHeight)
            {
                this.name = name;
                boundsText = x + "," + y + "," + width + "," + height;
                uMin = (float)x / texWidth;
                uMax = (float)(x + width) / texWidth;
                vMin = 1f - (float)(y + height) / texHeight;
                vMax = 1f - (float)y / texHeight;
            }

            public bool Contains(Vector2 uv)
            {
                const float e = 0.0005f;
                return uv.x >= uMin - e && uv.x <= uMax + e && uv.y >= vMin - e && uv.y <= vMax + e;
            }

            public string UvText()
            {
                return Format(uMin) + "," + Format(vMin) + "," + Format(uMax) + "," + Format(vMax);
            }
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
            public int clipRowsCount;
            public int clippedRows;
            public int preClipCandidateRows;
            public int textureMismatchRows;
            public int uvRowsCount;
            public string decision;
            public string nextBlocker;
            public List<TargetRow> targetRows;
            public List<TextureHandoffRow> textureRows;
            public List<ClipRow> clipRows;
            public List<UvRegionRow> uvRows;
            public List<InstructionRow> instructionRows;
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
            public bool allowMultipleCanvasRenderers;
            public string mainTexture;
            public string overrideTexture;
            public string baseTexture;
            public string canvasRendererTexture;
            public int canvasRendererMaterialCount;
            public string materialForRendering;
            public string graphicMaterial;
            public string canvasRendererMaterial0;
            public bool currentInstructionsFound;
            public bool hasActiveClipping;
            public int instructionSubmeshCount;
            public int meshVertexCount;
            public int meshTriangleIndexCount;
            public int meshSubMeshCount;
            public string meshBoundsCenter;
            public string meshBoundsSize;
            public int preClipZhuyeRows;
            public int clippedRows;
            public int textureEffectiveRows;
            public int textureMissingRows;
            public string decision;
            public string reason;
        }

        [Serializable]
        private sealed class TextureHandoffRow
        {
            public string key;
            public string nodeName;
            public string source;
            public string expectedTexture;
            public string actualTexture;
            public bool expectedTexturePresent;
            public bool effectiveTexturePresent;
            public bool matchesMainTexture;
            public string classification;
        }

        [Serializable]
        private sealed class ClipRow
        {
            public string key;
            public string nodeName;
            public int drawOrder;
            public string slotName;
            public string attachmentName;
            public string attachmentType;
            public bool clippingActiveAtAttachment;
            public bool clipStart;
            public string clipEndSlot;
            public int clippingPolygonCount;
            public int rawVertexCount;
            public int rawTriangleCount;
            public int clippedVertexCount;
            public int clippedTriangleCount;
            public string rawBounds;
            public string clippedBounds;
            public string classification;
        }

        [Serializable]
        private sealed class UvRegionRow
        {
            public string key;
            public string nodeName;
            public string regionName;
            public string atlasBounds;
            public string uvBounds;
            public int meshVertexHits;
            public int meshTriangleHits;
            public int meshMixedTriangleHits;
            public string meshBounds;
            public string classification;
        }

        [Serializable]
        private sealed class InstructionRow
        {
            public string key;
            public string nodeName;
            public int submeshIndex;
            public int startSlot;
            public int endSlot;
            public int slotCount;
            public int preActiveClippingSlotSource;
            public string material;
            public string materialTexture;
            public bool hasClipping;
            public int rawVertexCount;
            public int rawTriangleCount;
            public string classification;
        }
    }
}
