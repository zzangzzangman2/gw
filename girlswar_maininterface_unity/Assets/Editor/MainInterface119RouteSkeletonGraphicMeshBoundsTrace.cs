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
    public static class MainInterface119RouteSkeletonGraphicMeshBoundsTrace
    {
        private const string ScenePath = "Assets/Scenes/MainInterface_RouteSpineRuntimeReplay_UIMaterialBound.unity";
        private const string ResultJson = "Assets/RestoreData/maininterface_119_route_skeletongraphic_mesh_bounds_canvasrenderer_submesh_material.json";
        private const string ResultCsv = "Assets/RestoreData/reports/maininterface_119_route_skeletongraphic_mesh_bounds_canvasrenderer_submesh_material.csv";
        private const string RawDecodeCsv = "Assets/RestoreData/reports/maininterface_route_spinegraphic_runtime_replay_raw_skeleton_decode_recovery.csv";
        private const string RouteTraceCsv = "Assets/RestoreData/reports/maininterface_route_renderer_asset_trace.csv";

        private static readonly TargetSpec[] Targets =
        {
            new TargetSpec(
                "Spine_shijieanniu",
                "spine_diqiu",
                "-1766545527926586392",
                "A",
                "Assets/RestoreData/route_spine_raw_decode_recovery/Spine_shijieanniu/Spine_shijieanniu.atlas.txt",
                "Assets/RestoreData/route_spine_raw_decode_recovery/Spine_shijieanniu/Spine_shijieanniu.png"
            ),
            new TargetSpec(
                "8007",
                "spine_xiaoren",
                "3375689855543054311",
                "run",
                "Assets/RestoreData/route_spine_raw_decode_recovery/8007/8007.atlas.txt",
                "Assets/RestoreData/route_spine_raw_decode_recovery/8007/8007.png"
            )
        };

        [MenuItem("GirlsWar/UI119 Trace Route SkeletonGraphic Mesh Bounds CanvasRenderer Submesh Material")]
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
                submeshRows = new List<SubmeshRow>(),
                attachmentRows = new List<AttachmentRow>(),
                atlasRows = new List<AtlasRegionRow>()
            };

            try
            {
                if (!File.Exists(ScenePath))
                    throw new FileNotFoundException("UI118 material-bound scene is missing.", ScenePath);

                EditorSceneManager.OpenScene(ScenePath, OpenSceneMode.Single);
                var rawRows = LoadCsv(RawDecodeCsv);
                var routeRows = LoadCsv(RouteTraceCsv);

                foreach (var target in Targets)
                    TraceTarget(target, rawRows, routeRows, result);

                result.targetsConsidered = result.targetRows.Count;
                result.targetsTraced = result.targetRows.Count(r => r.skeletonGraphicFound);
                result.submeshInstructionCount = result.submeshRows.Count;
                result.attachmentCount = result.attachmentRows.Count;
                result.highWhiteAtlasRegions = result.atlasRows.Count(r => r.whiteishRatio >= 0.35f && r.alphaPixelRatio >= 0.25f);
                result.visualVerdict = "not_normal_trace_only_no_visual_patch";
                result.status = "maininterface_119_route_skeletongraphic_mesh_bounds_trace_complete";
                result.nextBlocker = "route SkeletonGraphic original runtime mask/stencil/attachment visibility state for zhuye_di1 and world route frame";
            }
            catch (Exception ex)
            {
                result.status = "maininterface_119_route_skeletongraphic_mesh_bounds_trace_failed";
                result.visualVerdict = "not_normal_probe_failed";
                result.nextBlocker = ex.GetType().Name + ": " + ex.Message;
                Debug.LogException(ex);
                WriteOutputs(result);
                throw;
            }

            WriteOutputs(result);
            Debug.Log("[GirlsWarRestore] UI119 route SkeletonGraphic mesh bounds trace complete: " + ResultJson);
        }

        private static void TraceTarget(TargetSpec target, List<Dictionary<string, string>> rawRows, List<Dictionary<string, string>> routeRows, TraceResult result)
        {
            var targetRow = new TargetRow
            {
                key = target.key,
                nodeName = target.nodeName,
                expectedAnimation = target.animation,
                atlasPath = target.atlasPath,
                texturePath = target.texturePath
            };
            result.targetRows.Add(targetRow);

            var rt = FindNode(target.nodeName, target.rectPathId);
            targetRow.sceneNodeFound = rt != null;
            if (rt == null)
            {
                targetRow.decision = "blocked_original_node_missing";
                targetRow.reason = "The original route SkeletonGraphic node was not found in the material-bound scene.";
                return;
            }

            targetRow.sceneObjectPath = TransformPath(rt);
            targetRow.parentPath = rt.parent != null ? TransformPath(rt.parent) : "";
            targetRow.siblingIndex = rt.GetSiblingIndex();
            targetRow.anchoredPosition = Format(rt.anchoredPosition);
            targetRow.sizeDelta = Format(rt.sizeDelta);
            targetRow.localScale = Format(rt.localScale);
            targetRow.anchorMin = Format(rt.anchorMin);
            targetRow.anchorMax = Format(rt.anchorMax);
            targetRow.pivot = Format(rt.pivot);
            targetRow.activeInHierarchy = rt.gameObject.activeInHierarchy;
            targetRow.hasMaskAncestor = rt.GetComponentsInParent<Mask>(true).Any(m => m != null && m.enabled);
            targetRow.hasRectMask2DAncestor = rt.GetComponentsInParent<RectMask2D>(true).Any(m => m != null && m.enabled);
            targetRow.canvasGroupAncestorCount = rt.GetComponentsInParent<CanvasGroup>(true).Length;

            var sg = rt.GetComponent<SkeletonGraphic>();
            targetRow.skeletonGraphicFound = sg != null;
            if (sg == null)
            {
                targetRow.decision = "blocked_skeletongraphic_missing";
                targetRow.reason = "The node exists but has no SkeletonGraphic component.";
                return;
            }

            sg.Initialize(true);
            sg.Update(0f);
            sg.UpdateMesh();
            Canvas.ForceUpdateCanvases();

            targetRow.allowMultipleCanvasRenderers = sg.allowMultipleCanvasRenderers;
            targetRow.maskable = sg.maskable;
            targetRow.raycastTarget = sg.raycastTarget;
            targetRow.materialForRendering = MaterialSummary(sg.materialForRendering);
            targetRow.material = MaterialSummary(sg.material);
            targetRow.additiveMaterial = MaterialSummary(sg.additiveMaterial);
            targetRow.multiplyMaterial = MaterialSummary(sg.multiplyMaterial);
            targetRow.screenMaterial = MaterialSummary(sg.screenMaterial);
            targetRow.mainTexture = TextureSummary(sg.mainTexture);
            targetRow.canvasRendererMaterialCount = sg.canvasRenderer.materialCount;
            targetRow.canvasRendererCull = sg.canvasRenderer.cull;
            targetRow.canvasRendererHasPopInstruction = sg.canvasRenderer.hasPopInstruction;
            targetRow.canvasRendererMainMaterial0 = MaterialSummary(sg.canvasRenderer.GetMaterial(0));
            targetRow.canvasRendererTexture = TextureSummary(InvokePublicMethod(sg.canvasRenderer, "GetTexture") as Texture);

            var mesh = sg.GetLastMesh();
            if (mesh != null)
            {
                mesh.RecalculateBounds();
                targetRow.meshVertexCount = mesh.vertexCount;
                targetRow.meshTriangleIndexCount = mesh.triangles != null ? mesh.triangles.Length : 0;
                targetRow.meshBoundsCenter = Format(mesh.bounds.center);
                targetRow.meshBoundsSize = Format(mesh.bounds.size);
                targetRow.meshSubMeshCount = mesh.subMeshCount;
            }

            var original = routeRows.FirstOrDefault(r =>
                EqualsIgnoreCase(Get(r, "game_object_name"), target.nodeName)
                && Get(r, "note").IndexOf("SkeletonGraphic", StringComparison.OrdinalIgnoreCase) >= 0
                && !string.IsNullOrWhiteSpace(Get(r, "material_refs")));
            targetRow.originalMaterialRefs = original != null ? Get(original, "material_refs") : "";

            TraceSubmeshes(target, sg, result);
            TraceDrawOrderAttachments(target, sg, rawRows, result);
            TraceAtlasRegions(target, result);

            targetRow.highWhiteAttachmentCandidateCount = result.atlasRows.Count(r => r.key == target.key && r.whiteishRatio >= 0.35f && r.alphaPixelRatio >= 0.25f);
            targetRow.decision = "trace_only_white_panel_source_narrowed_to_original_attachment_candidates";
            targetRow.reason = target.key == "Spine_shijieanniu"
                ? "The large visible white route shape aligns with original Spine_shijieanniu attachment candidates, especially zhuye_di1/zhuye_bian; removing or hiding them would require original runtime visibility/mask evidence."
                : "The character SkeletonGraphic mesh/material is traced; it is not the main large white panel candidate.";
        }

        private static void TraceSubmeshes(TargetSpec target, SkeletonGraphic sg, TraceResult result)
        {
            var instructions = GetPrivateField(sg, "currentInstructions");
            if (instructions == null)
                return;
            var submeshList = GetPublicField(instructions, "submeshInstructions");
            if (submeshList == null)
                return;
            var count = Convert.ToInt32(GetPublicProperty(submeshList, "Count") ?? 0, CultureInfo.InvariantCulture);
            var items = GetPublicField(submeshList, "Items") as Array;
            for (var i = 0; i < count && items != null && i < items.Length; i++)
            {
                var item = items.GetValue(i);
                if (item == null)
                    continue;
                var material = GetPublicField(item, "material") as Material;
                var startSlot = ToInt(GetPublicField(item, "startSlot"));
                var endSlot = ToInt(GetPublicField(item, "endSlot"));
                var row = new SubmeshRow
                {
                    key = target.key,
                    nodeName = target.nodeName,
                    submeshIndex = i,
                    startSlot = startSlot,
                    endSlot = endSlot,
                    slotCount = endSlot - startSlot,
                    material = MaterialSummary(material),
                    texture = material != null ? TextureSummary(material.mainTexture) : "",
                    rawVertexCount = ToInt(GetPublicField(item, "rawVertexCount")),
                    rawTriangleCount = ToInt(GetPublicField(item, "rawTriangleCount")),
                    rawFirstVertexIndex = ToInt(GetPublicField(item, "rawFirstVertexIndex")),
                    hasClipping = ToBool(GetPublicField(item, "hasClipping")),
                    hasPMAAdditiveSlot = ToBool(GetPublicField(item, "hasPMAAdditiveSlot")),
                    forceSeparate = ToBool(GetPublicField(item, "forceSeparate"))
                };
                result.submeshRows.Add(row);
            }
        }

        private static void TraceDrawOrderAttachments(TargetSpec target, SkeletonGraphic sg, List<Dictionary<string, string>> rawRows, TraceResult result)
        {
            var skeleton = sg.Skeleton;
            if (skeleton == null)
                return;
            var drawOrder = skeleton.DrawOrder;
            for (var i = 0; i < drawOrder.Count; i++)
            {
                var slot = drawOrder.Items[i];
                if (slot == null)
                    continue;
                var attachment = slot.Attachment;
                var name = attachment != null ? attachment.Name : "";
                var raw = rawRows.FirstOrDefault(r =>
                    EqualsIgnoreCase(Get(r, "key"), target.key)
                    && EqualsIgnoreCase(Get(r, "kind"), "spine_attachment_bounds")
                    && EqualsIgnoreCase(Get(r, "objectName"), name));
                var row = new AttachmentRow
                {
                    key = target.key,
                    nodeName = target.nodeName,
                    drawOrder = i,
                    slotName = slot.Data != null ? slot.Data.Name : "",
                    boneName = slot.Bone != null && slot.Bone.Data != null ? slot.Bone.Data.Name : "",
                    attachmentName = name,
                    attachmentType = attachment != null ? attachment.GetType().Name : "",
                    boneActive = slot.Bone != null && slot.Bone.Active,
                    color = slot.R.ToString("0.####", CultureInfo.InvariantCulture) + "," + slot.G.ToString("0.####", CultureInfo.InvariantCulture) + "," + slot.B.ToString("0.####", CultureInfo.InvariantCulture) + "," + slot.A.ToString("0.####", CultureInfo.InvariantCulture),
                    rawBoundsDetail = raw != null ? Get(raw, "detail") : "",
                    classification = "active_draw_order_attachment"
                };
                if (target.key == "Spine_shijieanniu" && (name == "zhuye_di1" || name == "zhuye_bian" || name == "diqiu"))
                    row.classification = "large_route_shape_candidate_from_original_attachment";
                result.attachmentRows.Add(row);
            }
        }

        private static void TraceAtlasRegions(TargetSpec target, TraceResult result)
        {
            if (!File.Exists(target.atlasPath) || !File.Exists(target.texturePath))
                return;
            var regions = ParseAtlasBounds(File.ReadAllLines(target.atlasPath, Encoding.UTF8));
            var texture = new Texture2D(2, 2, TextureFormat.RGBA32, false);
            if (!texture.LoadImage(File.ReadAllBytes(target.texturePath)))
                return;

            foreach (var region in regions.Values)
            {
                var stats = ComputeRegionStats(texture, region);
                var row = new AtlasRegionRow
                {
                    key = target.key,
                    nodeName = target.nodeName,
                    regionName = region.name,
                    bounds = region.x + "," + region.y + "," + region.width + "," + region.height,
                    pixelCount = stats.pixelCount,
                    alphaPixelRatio = stats.alphaRatio,
                    whiteishRatio = stats.whiteishRatio,
                    averageRgba = stats.averageRgba,
                    classification = stats.whiteishRatio >= 0.35f && stats.alphaRatio >= 0.25f
                        ? "high_white_visible_region_candidate"
                        : "texture_region_trace"
                };
                result.atlasRows.Add(row);
            }
            UnityEngine.Object.DestroyImmediate(texture);
        }

        private static Dictionary<string, AtlasRegion> ParseAtlasBounds(string[] lines)
        {
            var result = new Dictionary<string, AtlasRegion>(StringComparer.OrdinalIgnoreCase);
            string current = null;
            for (var i = 0; i < lines.Length; i++)
            {
                var line = lines[i];
                if (string.IsNullOrWhiteSpace(line))
                    continue;
                if (!line.StartsWith(" ", StringComparison.Ordinal) && !line.Contains(":", StringComparison.Ordinal) && !line.EndsWith(".png", StringComparison.OrdinalIgnoreCase))
                {
                    current = line.Trim();
                    if (!result.ContainsKey(current))
                        result[current] = new AtlasRegion { name = current };
                    continue;
                }
                if (current == null)
                    continue;
                var trimmed = line.Trim();
                if (!trimmed.StartsWith("bounds:", StringComparison.OrdinalIgnoreCase))
                    continue;
                var parts = trimmed.Substring("bounds:".Length).Split(',').Select(p => p.Trim()).ToArray();
                if (parts.Length == 4
                    && int.TryParse(parts[0], out var x)
                    && int.TryParse(parts[1], out var y)
                    && int.TryParse(parts[2], out var w)
                    && int.TryParse(parts[3], out var h))
                {
                    var region = result[current];
                    region.x = x;
                    region.y = y;
                    region.width = w;
                    region.height = h;
                    result[current] = region;
                }
            }
            return result.Where(kv => kv.Value.width > 0 && kv.Value.height > 0).ToDictionary(kv => kv.Key, kv => kv.Value, StringComparer.OrdinalIgnoreCase);
        }

        private static RegionStats ComputeRegionStats(Texture2D texture, AtlasRegion region)
        {
            var xMin = Mathf.Clamp(region.x, 0, texture.width - 1);
            var yMinTop = Mathf.Clamp(region.y, 0, texture.height - 1);
            var width = Mathf.Clamp(region.width, 1, texture.width - xMin);
            var height = Mathf.Clamp(region.height, 1, texture.height - yMinTop);
            var yMin = texture.height - yMinTop - height;
            yMin = Mathf.Clamp(yMin, 0, texture.height - 1);

            long r = 0, g = 0, b = 0, a = 0;
            var alpha = 0;
            var white = 0;
            var count = 0;
            for (var y = yMin; y < yMin + height && y < texture.height; y++)
            {
                for (var x = xMin; x < xMin + width && x < texture.width; x++)
                {
                    var p = texture.GetPixel(x, y);
                    count++;
                    var pr = Mathf.RoundToInt(p.r * 255f);
                    var pg = Mathf.RoundToInt(p.g * 255f);
                    var pb = Mathf.RoundToInt(p.b * 255f);
                    var pa = Mathf.RoundToInt(p.a * 255f);
                    r += pr;
                    g += pg;
                    b += pb;
                    a += pa;
                    if (pa > 32)
                        alpha++;
                    if (pa > 128 && pr > 220 && pg > 220 && pb > 220)
                        white++;
                }
            }
            return new RegionStats
            {
                pixelCount = count,
                alphaRatio = count > 0 ? (float)alpha / count : 0f,
                whiteishRatio = count > 0 ? (float)white / count : 0f,
                averageRgba = count > 0
                    ? (r / count) + "," + (g / count) + "," + (b / count) + "," + (a / count)
                    : "0,0,0,0"
            };
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

        private static bool EqualsIgnoreCase(string a, string b)
        {
            return string.Equals(a ?? "", b ?? "", StringComparison.OrdinalIgnoreCase);
        }

        private static object GetPrivateField(object target, string name)
        {
            if (target == null)
                return null;
            var field = target.GetType().GetField(name, BindingFlags.NonPublic | BindingFlags.Instance);
            return field != null ? field.GetValue(target) : null;
        }

        private static object GetPublicField(object target, string name)
        {
            if (target == null)
                return null;
            var field = target.GetType().GetField(name, BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance);
            return field != null ? field.GetValue(target) : null;
        }

        private static object GetPublicProperty(object target, string name)
        {
            if (target == null)
                return null;
            var property = target.GetType().GetProperty(name, BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance);
            return property != null ? property.GetValue(target, null) : null;
        }

        private static object InvokePublicMethod(object target, string name)
        {
            if (target == null)
                return null;
            var method = target.GetType().GetMethod(name, BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance, null, Type.EmptyTypes, null);
            return method != null ? method.Invoke(target, null) : null;
        }

        private static int ToInt(object value)
        {
            try { return Convert.ToInt32(value, CultureInfo.InvariantCulture); }
            catch { return 0; }
        }

        private static bool ToBool(object value)
        {
            try { return Convert.ToBoolean(value, CultureInfo.InvariantCulture); }
            catch { return false; }
        }

        private static string MaterialSummary(Material material)
        {
            if (material == null)
                return "";
            var shaderName = material.shader != null ? material.shader.name : "";
            var texture = material.mainTexture;
            var textureText = texture != null ? texture.name + " " + texture.width + "x" + texture.height : "";
            return material.name + " / " + shaderName + " / " + textureText;
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
                    Csv("mesh=" + row.meshVertexCount + "/" + row.meshTriangleIndexCount + ";bounds=" + row.meshBoundsCenter + "/" + row.meshBoundsSize),
                    Csv("canvasRendererMaterialCount=" + row.canvasRendererMaterialCount + ";materialForRendering=" + row.materialForRendering),
                    Csv("maskable=" + row.maskable + ";maskAncestor=" + row.hasMaskAncestor + ";rectMask2D=" + row.hasRectMask2DAncestor),
                    Csv(row.reason + ";canvasRendererTexture=" + row.canvasRendererTexture)
                }));
            }
            foreach (var row in result.submeshRows)
            {
                sb.AppendLine(string.Join(",", new[]
                {
                    Csv("Submesh"),
                    Csv(row.key),
                    Csv(row.nodeName),
                    Csv(row.submeshIndex.ToString(CultureInfo.InvariantCulture)),
                    Csv(""),
                    Csv("submesh_instruction"),
                    Csv("slots=" + row.startSlot + "-" + row.endSlot + ";slotCount=" + row.slotCount),
                    Csv("rawVertex=" + row.rawVertexCount + ";rawTriangle=" + row.rawTriangleCount + ";firstVertex=" + row.rawFirstVertexIndex),
                    Csv("material=" + row.material + ";texture=" + row.texture),
                    Csv("hasClipping=" + row.hasClipping + ";forceSeparate=" + row.forceSeparate + ";pmaAdditive=" + row.hasPMAAdditiveSlot)
                }));
            }
            foreach (var row in result.attachmentRows)
            {
                sb.AppendLine(string.Join(",", new[]
                {
                    Csv("Attachment"),
                    Csv(row.key),
                    Csv(row.nodeName),
                    Csv(row.attachmentName),
                    Csv(row.slotName),
                    Csv(row.classification),
                    Csv("drawOrder=" + row.drawOrder + ";bone=" + row.boneName + ";type=" + row.attachmentType),
                    Csv("color=" + row.color + ";boneActive=" + row.boneActive),
                    Csv(row.rawBoundsDetail),
                    Csv("")
                }));
            }
            foreach (var row in result.atlasRows)
            {
                sb.AppendLine(string.Join(",", new[]
                {
                    Csv("AtlasRegion"),
                    Csv(row.key),
                    Csv(row.nodeName),
                    Csv(row.regionName),
                    Csv(row.bounds),
                    Csv(row.classification),
                    Csv("alphaRatio=" + row.alphaPixelRatio.ToString("0.######", CultureInfo.InvariantCulture)),
                    Csv("whiteishRatio=" + row.whiteishRatio.ToString("0.######", CultureInfo.InvariantCulture)),
                    Csv("avg=" + row.averageRgba + ";pixels=" + row.pixelCount),
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

        private struct AtlasRegion
        {
            public string name;
            public int x;
            public int y;
            public int width;
            public int height;
        }

        private struct RegionStats
        {
            public int pixelCount;
            public float alphaRatio;
            public float whiteishRatio;
            public string averageRgba;
        }

        private sealed class TargetSpec
        {
            public readonly string key;
            public readonly string nodeName;
            public readonly string rectPathId;
            public readonly string animation;
            public readonly string atlasPath;
            public readonly string texturePath;

            public TargetSpec(string key, string nodeName, string rectPathId, string animation, string atlasPath, string texturePath)
            {
                this.key = key;
                this.nodeName = nodeName;
                this.rectPathId = rectPathId;
                this.animation = animation;
                this.atlasPath = atlasPath;
                this.texturePath = texturePath;
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
            public int submeshInstructionCount;
            public int attachmentCount;
            public int highWhiteAtlasRegions;
            public string nextBlocker;
            public List<TargetRow> targetRows;
            public List<SubmeshRow> submeshRows;
            public List<AttachmentRow> attachmentRows;
            public List<AtlasRegionRow> atlasRows;
        }

        [Serializable]
        private sealed class TargetRow
        {
            public string key;
            public string nodeName;
            public string expectedAnimation;
            public string sceneObjectPath;
            public string parentPath;
            public bool sceneNodeFound;
            public bool skeletonGraphicFound;
            public bool activeInHierarchy;
            public int siblingIndex;
            public string anchoredPosition;
            public string sizeDelta;
            public string localScale;
            public string anchorMin;
            public string anchorMax;
            public string pivot;
            public string atlasPath;
            public string texturePath;
            public bool allowMultipleCanvasRenderers;
            public bool maskable;
            public bool raycastTarget;
            public bool hasMaskAncestor;
            public bool hasRectMask2DAncestor;
            public int canvasGroupAncestorCount;
            public string materialForRendering;
            public string material;
            public string additiveMaterial;
            public string multiplyMaterial;
            public string screenMaterial;
            public string mainTexture;
            public int canvasRendererMaterialCount;
            public bool canvasRendererCull;
            public bool canvasRendererHasPopInstruction;
            public string canvasRendererMainMaterial0;
            public string canvasRendererTexture;
            public int meshVertexCount;
            public int meshTriangleIndexCount;
            public int meshSubMeshCount;
            public string meshBoundsCenter;
            public string meshBoundsSize;
            public string originalMaterialRefs;
            public int highWhiteAttachmentCandidateCount;
            public string decision;
            public string reason;
        }

        [Serializable]
        private sealed class SubmeshRow
        {
            public string key;
            public string nodeName;
            public int submeshIndex;
            public int startSlot;
            public int endSlot;
            public int slotCount;
            public string material;
            public string texture;
            public int rawVertexCount;
            public int rawTriangleCount;
            public int rawFirstVertexIndex;
            public bool hasClipping;
            public bool hasPMAAdditiveSlot;
            public bool forceSeparate;
        }

        [Serializable]
        private sealed class AttachmentRow
        {
            public string key;
            public string nodeName;
            public int drawOrder;
            public string slotName;
            public string boneName;
            public string attachmentName;
            public string attachmentType;
            public bool boneActive;
            public string color;
            public string rawBoundsDetail;
            public string classification;
        }

        [Serializable]
        private sealed class AtlasRegionRow
        {
            public string key;
            public string nodeName;
            public string regionName;
            public string bounds;
            public int pixelCount;
            public float alphaPixelRatio;
            public float whiteishRatio;
            public string averageRgba;
            public string classification;
        }
    }
}
