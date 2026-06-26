using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;
using Spine.Unity;
using TMPro;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

namespace GirlsWarRestore
{
    public static class MainInterface150PromotedHomeStateAudit
    {
        private const string ScenePath = "Assets/Scenes/MainInterface_Wireframe.unity";
        private const string JsonPath = "Assets/RestoreData/maininterface_150_promoted_home_state_audit.json";
        private const string MarkdownPath = "Assets/RestoreData/reports/maininterface_150_promoted_home_state_audit.md";
        private const string BuildResultPath = "Assets/RestoreData/maininterface_build_result.json";
        private const string CaptureResultPath = "Assets/RestoreCaptures/maininterface_capture_result.json";
        private const string CaptureImagePath = "Assets/RestoreCaptures/maininterface_restored_1680x720.png";
        private const float ReferenceWidth = 1680f;
        private const float ReferenceHeight = 720f;

        [MenuItem("GirlsWar/UI150 Promoted Home State Audit")]
        public static void AuditMenu()
        {
            AuditPromotedHomeState();
        }

        public static void AuditPromotedHomeState()
        {
            if (!File.Exists(ScenePath))
                MainInterfaceSceneBuilder.BuildMainInterfaceScene();

            EditorSceneManager.OpenScene(ScenePath, OpenSceneMode.Single);
            Canvas.ForceUpdateCanvases();

            var result = new AuditResult
            {
                generatedAt = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
                scenePath = ScenePath,
                jsonPath = Path.GetFullPath(JsonPath),
                markdownPath = Path.GetFullPath(MarkdownPath),
                captureImagePath = Path.GetFullPath(CaptureImagePath),
                previousMismatchRootCause = "Default MainInterface root and old-root runtime activity placeholders were being promoted without the original runtime activity payload. The production builder now uses the old home root, attaches BG1005/Hero1005, and hides the unpopulated old-root node_act_btn grid."
            };

            ReadBuildAndCaptureResults(result);
            AuditCanvas(result);
            AuditPromotedHomeNodes(result);
            AuditMasksAndText(result);
            AuditRaycastCoordinates(result);

            result.promotedHomeStateVerified =
                result.promotedHomeRuntimeStateApplied &&
                result.backgroundVerified &&
                result.heroSkeletonVerified &&
                result.runtimeActivityNodeHidden &&
                result.activeNumberedActivitySlots == 0 &&
                result.canvasAndInputVerified &&
                result.captureVerified;
            result.status = result.promotedHomeStateVerified && result.raycastCoordinateVerified
                ? "maininterface150_promoted_home_state_verified"
                : "maininterface150_promoted_home_state_audited_needs_review";

            Directory.CreateDirectory(Path.GetDirectoryName(JsonPath));
            Directory.CreateDirectory(Path.GetDirectoryName(MarkdownPath));
            File.WriteAllText(JsonPath, JsonUtility.ToJson(result, true), Encoding.UTF8);
            File.WriteAllText(MarkdownPath, BuildMarkdown(result), Encoding.UTF8);
            AssetDatabase.Refresh();

            Debug.Log("[GirlsWarRestore] UI150 promoted home audit: " + result.status
                + " hero=" + result.heroSkeletonVerified
                + " bg=" + result.backgroundVerified
                + " activityHidden=" + result.runtimeActivityNodeHidden
                + " raycast=" + result.raycastCoordinateVerified
                + " -> " + JsonPath);
        }

        private static void ReadBuildAndCaptureResults(AuditResult result)
        {
            if (File.Exists(BuildResultPath))
            {
                var json = File.ReadAllText(BuildResultPath, Encoding.UTF8);
                result.buildResultPath = Path.GetFullPath(BuildResultPath);
                result.promotedHomeRuntimeStateApplied = Regex.IsMatch(json, "\"promotedHomeRuntimeStateApplied\"\\s*:\\s*true");
                result.buildGeneratedAt = ExtractString(json, "generatedAt");
            }

            if (File.Exists(CaptureResultPath))
            {
                var json = File.ReadAllText(CaptureResultPath, Encoding.UTF8);
                result.captureResultPath = Path.GetFullPath(CaptureResultPath);
                result.captureWidth = ExtractInt(json, "width");
                result.captureHeight = ExtractInt(json, "height");
                result.captureVisiblePixelCount = ExtractInt(json, "visiblePixelCount");
                result.captureGeneratedAt = ExtractString(json, "generatedAt");
            }

            var captureFile = new FileInfo(CaptureImagePath);
            result.captureExists = captureFile.Exists;
            result.captureBytes = captureFile.Exists ? captureFile.Length : 0L;
            result.captureVerified = result.captureExists &&
                result.captureWidth == (int)ReferenceWidth &&
                result.captureHeight == (int)ReferenceHeight &&
                result.captureVisiblePixelCount > 1000000;
        }

        private static void AuditCanvas(AuditResult result)
        {
            var canvases = UnityEngine.Object.FindObjectsByType<Canvas>(FindObjectsInactive.Include);
            var raycasters = UnityEngine.Object.FindObjectsByType<GraphicRaycaster>(FindObjectsInactive.Include);
            var eventSystems = UnityEngine.Object.FindObjectsByType<EventSystem>(FindObjectsInactive.Include);

            result.canvasCount = canvases.Length;
            result.graphicRaycasterCount = raycasters.Length;
            result.eventSystemCount = eventSystems.Length;

            var canvas = canvases.Length > 0 ? canvases[0] : null;
            if (canvas != null)
            {
                result.canvasRenderMode = canvas.renderMode.ToString();
                result.canvasSortingOrder = canvas.sortingOrder;
                var scaler = canvas.GetComponent<CanvasScaler>();
                if (scaler != null)
                {
                    result.canvasScalerMode = scaler.uiScaleMode.ToString();
                    result.canvasReferenceResolution = Format(scaler.referenceResolution);
                    result.canvasMatchWidthOrHeight = scaler.matchWidthOrHeight;
                }
            }

            result.canvasAndInputVerified = canvas != null &&
                raycasters.Length > 0 &&
                eventSystems.Length > 0 &&
                canvas.renderMode == RenderMode.ScreenSpaceOverlay;
        }

        private static void AuditPromotedHomeNodes(AuditResult result)
        {
            var root = FindTransformByPrefix("UI_MainInterface_old__2475216337245998118");
            var bg = FindTransformByPrefix("UI_bg__-3280973633984018659");
            var heroParent = FindTransformByPrefix("UI_heroSpine__-2739654541028205496");
            var heroRoot = FindTransformByPrefix("Restore_Hero1005_SpineRoot_Main");
            var hero = FindTransformByPrefix("Restore_Hero1005_Painting_1005_Main");
            var right = FindTransformByPrefix("right__-7547578691690053275");
            var activityNode = FindTransformByPrefix("node_act_btn__-2702129779362243929");
            var chat = FindTransformByPrefix("liaotian__1445380050083804015");

            result.nodes.Add(BuildNode("old_root", root));
            result.nodes.Add(BuildNode("bg1005", bg));
            result.nodes.Add(BuildNode("hero_parent", heroParent));
            result.nodes.Add(BuildNode("hero_spine_root", heroRoot));
            result.nodes.Add(BuildNode("hero1005", hero));
            result.nodes.Add(BuildNode("right_cluster", right));
            result.nodes.Add(BuildNode("runtime_activity_node", activityNode));
            result.nodes.Add(BuildNode("ui_chat", chat));

            var bgRect = bg != null ? bg.GetComponent<RectTransform>() : null;
            var bgImage = bg != null ? bg.GetComponent<Image>() : null;
            result.backgroundVerified = bg != null &&
                bg.gameObject.activeInHierarchy &&
                bgRect != null &&
                Nearly(bgRect.sizeDelta.x, ReferenceWidth, 0.5f) &&
                Nearly(bgRect.sizeDelta.y, ReferenceHeight, 0.5f) &&
                bgImage != null &&
                bgImage.sprite != null &&
                bgImage.sprite.name.Contains("PaintingBG_1005") &&
                bg.GetSiblingIndex() == 0;

            var heroGraphic = hero != null ? hero.GetComponent<SkeletonGraphic>() : null;
            result.heroSkeletonGraphicCount = UnityEngine.Object.FindObjectsByType<SkeletonGraphic>(FindObjectsInactive.Include).Length;
            result.heroStartingAnimation = heroGraphic != null ? heroGraphic.startingAnimation : "";
            result.heroStartingLoop = heroGraphic != null && heroGraphic.startingLoop;
            result.heroSkeletonDataAsset = heroGraphic != null && heroGraphic.skeletonDataAsset != null ? heroGraphic.skeletonDataAsset.name : "";
            result.heroMaterial = heroGraphic != null && heroGraphic.material != null ? heroGraphic.material.name : "";
            result.heroSkeletonVerified = heroGraphic != null &&
                heroGraphic.gameObject.activeInHierarchy &&
                heroGraphic.enabled &&
                heroGraphic.skeletonDataAsset != null &&
                heroGraphic.material != null &&
                string.Equals(heroGraphic.startingAnimation, "A", StringComparison.Ordinal) &&
                heroGraphic.startingLoop &&
                !heroGraphic.raycastTarget &&
                heroGraphic.maskable;

            result.runtimeActivityNodeExists = activityNode != null;
            result.runtimeActivityNodeHidden = activityNode != null && !activityNode.gameObject.activeSelf && !activityNode.gameObject.activeInHierarchy;
            foreach (var transform in UnityEngine.Object.FindObjectsByType<Transform>(FindObjectsInactive.Include))
            {
                if (!IsNumberedActivitySlot(transform.name))
                    continue;
                result.numberedActivitySlotCount++;
                if (transform.gameObject.activeSelf)
                    result.activeSelfNumberedActivitySlots++;
                if (transform.gameObject.activeInHierarchy)
                    result.activeNumberedActivitySlots++;
            }

            result.rootSiblingOrderVerified = bg != null && heroParent != null && right != null &&
                bg.GetSiblingIndex() < heroParent.GetSiblingIndex() &&
                heroParent.GetSiblingIndex() < right.GetSiblingIndex();
        }

        private static void AuditMasksAndText(AuditResult result)
        {
            var masks = UnityEngine.Object.FindObjectsByType<Mask>(FindObjectsInactive.Include);
            foreach (var mask in masks)
            {
                result.maskCount++;
                if (mask.gameObject.activeInHierarchy)
                    result.activeMaskCount++;
                if (!mask.showMaskGraphic)
                    result.hiddenMaskGraphicCount++;
            }

            var rectMasks = UnityEngine.Object.FindObjectsByType<RectMask2D>(FindObjectsInactive.Include);
            result.rectMask2DCount = rectMasks.Length;
            foreach (var rectMask in rectMasks)
                if (rectMask.gameObject.activeInHierarchy)
                    result.activeRectMask2DCount++;

            var tmps = UnityEngine.Object.FindObjectsByType<TMP_Text>(FindObjectsInactive.Include);
            result.tmpTextCount = tmps.Length;
            foreach (var tmp in tmps)
            {
                if (tmp.gameObject.activeInHierarchy)
                    result.activeTmpTextCount++;
                if (tmp.enableAutoSizing)
                    result.tmpAutoSizeCount++;
                if (tmp.textWrappingMode != TextWrappingModes.NoWrap)
                    result.tmpWordWrapCount++;
            }

            var uguiTexts = UnityEngine.Object.FindObjectsByType<Text>(FindObjectsInactive.Include);
            result.uguiTextCount = uguiTexts.Length;
            foreach (var text in uguiTexts)
                if (text.gameObject.activeInHierarchy)
                    result.activeUguiTextCount++;
        }

        private static void AuditRaycastCoordinates(AuditResult result)
        {
            var canvas = UnityEngine.Object.FindAnyObjectByType<Canvas>();
            if (canvas == null)
                return;

            var graphics = FindRaycastGraphics(canvas);
            AddRaycastProbe(result, graphics, "mail", "btn_youjian__-1189460423525129158");
            AddRaycastProbe(result, graphics, "friend", "btn_haoyou__-675339169157432991");
            AddRaycastProbe(result, graphics, "shop", "btn_shangdian__-2638148383004042968");

            result.raycastProbeCount = result.raycastProbes.Count;
            result.raycastCoordinateVerified = result.raycastProbeCount > 0;
            foreach (var probe in result.raycastProbes)
                result.raycastCoordinateVerified &= probe.topWithinButton && probe.containsButton && probe.targetGraphicReady;
        }

        private static void AddRaycastProbe(AuditResult result, List<Graphic> graphics, string key, string buttonPrefix)
        {
            var transform = FindTransformByPrefix(buttonPrefix);
            var button = transform != null ? transform.GetComponent<Button>() : null;
            var row = new RaycastProbe
            {
                key = key,
                targetPrefix = buttonPrefix,
                buttonFound = button != null
            };

            if (button == null)
            {
                result.raycastProbes.Add(row);
                return;
            }

            var rt = button.GetComponent<RectTransform>();
            var centerWorld = Vector3.zero;
            if (rt != null)
            {
                var corners = new Vector3[4];
                rt.GetWorldCorners(corners);
                centerWorld = (corners[0] + corners[2]) * 0.5f;
                row.screenX = ReferenceWidth * 0.5f + centerWorld.x;
                row.screenY = ReferenceHeight * 0.5f + centerWorld.y;
            }

            var hits = new List<GraphicHit>();
            foreach (var graphic in graphics)
            {
                if (graphic == null || graphic.rectTransform == null)
                    continue;
                if (!ContainsWorldPoint(graphic.rectTransform, centerWorld))
                    continue;
                hits.Add(new GraphicHit { graphic = graphic, depth = graphic.depth });
            }
            hits.Sort((a, b) => b.depth.CompareTo(a.depth));

            row.buttonName = button.gameObject.name;
            row.activeInHierarchy = button.gameObject.activeInHierarchy;
            row.interactable = button.interactable && button.enabled;
            row.targetGraphicReady = button.targetGraphic != null && button.targetGraphic.enabled && button.targetGraphic.raycastTarget;
            row.hitCount = hits.Count;
            if (hits.Count > 0)
            {
                row.topHit = hits[0].graphic.gameObject.name;
                row.topWithinButton = hits[0].graphic.transform.IsChildOf(button.transform);
            }
            foreach (var hit in hits)
            {
                if (hit.graphic.transform.IsChildOf(button.transform))
                {
                    row.containsButton = true;
                    break;
                }
            }
            result.raycastProbes.Add(row);
        }

        private static List<Graphic> FindRaycastGraphics(Canvas canvas)
        {
            var result = new List<Graphic>();
            foreach (var graphic in UnityEngine.Object.FindObjectsByType<Graphic>(FindObjectsInactive.Include))
            {
                if (graphic == null || graphic.canvas == null)
                    continue;
                if (graphic.canvas.rootCanvas != canvas.rootCanvas)
                    continue;
                if (!graphic.gameObject.activeInHierarchy || !graphic.enabled || !graphic.raycastTarget)
                    continue;
                result.Add(graphic);
            }
            return result;
        }

        private static NodeState BuildNode(string key, Transform transform)
        {
            var row = new NodeState { key = key, exists = transform != null };
            if (transform == null)
                return row;

            row.name = transform.name;
            row.path = GetPath(transform);
            row.activeSelf = transform.gameObject.activeSelf;
            row.activeInHierarchy = transform.gameObject.activeInHierarchy;
            row.siblingIndex = transform.GetSiblingIndex();
            row.childCount = transform.childCount;

            var rect = transform.GetComponent<RectTransform>();
            if (rect != null)
            {
                row.anchoredPosition = Format(rect.anchoredPosition);
                row.sizeDelta = Format(rect.sizeDelta);
                row.localScale = Format(rect.localScale);
            }

            var image = transform.GetComponent<Image>();
            if (image != null)
            {
                row.imageSprite = image.sprite != null ? image.sprite.name : "";
                row.raycastTarget = image.raycastTarget;
            }
            row.button = transform.GetComponent<Button>() != null;
            return row;
        }

        private static Transform FindTransformByPrefix(string prefix)
        {
            foreach (var transform in UnityEngine.Object.FindObjectsByType<Transform>(FindObjectsInactive.Include))
                if (transform.name.StartsWith(prefix, StringComparison.Ordinal))
                    return transform;
            return null;
        }

        private static bool IsNumberedActivitySlot(string name)
        {
            if (!name.StartsWith("btn_act_", StringComparison.Ordinal) ||
                name.StartsWith("btn_act__", StringComparison.Ordinal))
                return false;
            var suffix = name.Substring("btn_act_".Length);
            var end = suffix.IndexOf("__", StringComparison.Ordinal);
            var slotText = end >= 0 ? suffix.Substring(0, end) : suffix;
            return int.TryParse(slotText, out _);
        }

        private static bool ContainsWorldPoint(RectTransform rect, Vector3 worldPoint)
        {
            var corners = new Vector3[4];
            rect.GetWorldCorners(corners);
            var minX = Mathf.Min(corners[0].x, corners[2].x);
            var maxX = Mathf.Max(corners[0].x, corners[2].x);
            var minY = Mathf.Min(corners[0].y, corners[2].y);
            var maxY = Mathf.Max(corners[0].y, corners[2].y);
            return worldPoint.x >= minX && worldPoint.x <= maxX && worldPoint.y >= minY && worldPoint.y <= maxY;
        }

        private static string GetPath(Transform transform)
        {
            var parts = new List<string>();
            var current = transform;
            while (current != null)
            {
                parts.Add(current.name);
                current = current.parent;
            }
            parts.Reverse();
            return string.Join("/", parts);
        }

        private static bool Nearly(float a, float b, float epsilon)
        {
            return Mathf.Abs(a - b) <= epsilon;
        }

        private static int ExtractInt(string json, string key)
        {
            var match = Regex.Match(json, "\"" + Regex.Escape(key) + "\"\\s*:\\s*(\\d+)");
            return match.Success ? int.Parse(match.Groups[1].Value) : 0;
        }

        private static string ExtractString(string json, string key)
        {
            var match = Regex.Match(json, "\"" + Regex.Escape(key) + "\"\\s*:\\s*\"([^\"]*)\"");
            return match.Success ? match.Groups[1].Value : "";
        }

        private static string Format(Vector2 value)
        {
            return value.x.ToString("0.###") + "," + value.y.ToString("0.###");
        }

        private static string Format(Vector3 value)
        {
            return value.x.ToString("0.###") + "," + value.y.ToString("0.###") + "," + value.z.ToString("0.###");
        }

        private static string BuildMarkdown(AuditResult result)
        {
            var sb = new StringBuilder();
            sb.AppendLine("# MainInterface 150 Promoted Home State Audit");
            sb.AppendLine();
            sb.AppendLine("- Status: `" + result.status + "`");
            sb.AppendLine("- Root cause: " + result.previousMismatchRootCause);
            sb.AppendLine("- Promoted home runtime state applied: `" + result.promotedHomeRuntimeStateApplied + "`");
            sb.AppendLine("- BG1005 verified: `" + result.backgroundVerified + "`");
            sb.AppendLine("- Hero1005 SkeletonGraphic verified: `" + result.heroSkeletonVerified + "` (`" + result.heroSkeletonDataAsset + "`, anim `" + result.heroStartingAnimation + "`)");
            sb.AppendLine("- Runtime activity placeholder grid hidden: `" + result.runtimeActivityNodeHidden + "`");
            sb.AppendLine("- Numbered activity slots active in hierarchy: `" + result.activeNumberedActivitySlots + "/" + result.numberedActivitySlotCount + "`");
            sb.AppendLine("- Sibling order BG < Hero < Right: `" + result.rootSiblingOrderVerified + "`");
            sb.AppendLine("- Canvas/input verified: `" + result.canvasAndInputVerified + "`");
            sb.AppendLine("- Coordinate raycast probes verified: `" + result.raycastCoordinateVerified + "`");
            sb.AppendLine("- Capture verified: `" + result.captureVerified + "` (`" + result.captureWidth + "x" + result.captureHeight + "`, visible pixels `" + result.captureVisiblePixelCount + "`)");
            sb.AppendLine();
            sb.AppendLine("## TMP / Mask");
            sb.AppendLine();
            sb.AppendLine("- TMP active/total: `" + result.activeTmpTextCount + "/" + result.tmpTextCount + "`, autosize `" + result.tmpAutoSizeCount + "`, wrapping `" + result.tmpWordWrapCount + "`");
            sb.AppendLine("- UGUI Text active/total: `" + result.activeUguiTextCount + "/" + result.uguiTextCount + "`");
            sb.AppendLine("- Mask active/total: `" + result.activeMaskCount + "/" + result.maskCount + "`, hidden mask graphic `" + result.hiddenMaskGraphicCount + "`, RectMask2D active/total `" + result.activeRectMask2DCount + "/" + result.rectMask2DCount + "`");
            sb.AppendLine();
            sb.AppendLine("## Raycast Probes");
            sb.AppendLine();
            sb.AppendLine("| key | button | screen | top hit | top within | contains | target graphic |");
            sb.AppendLine("|---|---|---:|---|---:|---:|---:|");
            foreach (var probe in result.raycastProbes)
            {
                sb.Append("| ").Append(probe.key)
                    .Append(" | ").Append(probe.buttonName)
                    .Append(" | ").Append(probe.screenX.ToString("0.0")).Append(",").Append(probe.screenY.ToString("0.0"))
                    .Append(" | ").Append(probe.topHit)
                    .Append(" | ").Append(probe.topWithinButton)
                    .Append(" | ").Append(probe.containsButton)
                    .Append(" | ").Append(probe.targetGraphicReady)
                    .AppendLine(" |");
            }
            return sb.ToString();
        }

        private sealed class GraphicHit
        {
            public Graphic graphic;
            public int depth;
        }

        [Serializable]
        private sealed class AuditResult
        {
            public string generatedAt;
            public string status;
            public string scenePath;
            public string jsonPath;
            public string markdownPath;
            public string buildResultPath;
            public string captureResultPath;
            public string captureImagePath;
            public string previousMismatchRootCause;
            public string buildGeneratedAt;
            public string captureGeneratedAt;
            public bool promotedHomeStateVerified;
            public bool promotedHomeRuntimeStateApplied;
            public bool backgroundVerified;
            public bool heroSkeletonVerified;
            public bool runtimeActivityNodeExists;
            public bool runtimeActivityNodeHidden;
            public bool rootSiblingOrderVerified;
            public bool canvasAndInputVerified;
            public bool captureVerified;
            public bool raycastCoordinateVerified;
            public int canvasCount;
            public int graphicRaycasterCount;
            public int eventSystemCount;
            public string canvasRenderMode;
            public int canvasSortingOrder;
            public string canvasScalerMode;
            public string canvasReferenceResolution;
            public float canvasMatchWidthOrHeight;
            public int heroSkeletonGraphicCount;
            public string heroStartingAnimation;
            public bool heroStartingLoop;
            public string heroSkeletonDataAsset;
            public string heroMaterial;
            public int numberedActivitySlotCount;
            public int activeSelfNumberedActivitySlots;
            public int activeNumberedActivitySlots;
            public int maskCount;
            public int activeMaskCount;
            public int hiddenMaskGraphicCount;
            public int rectMask2DCount;
            public int activeRectMask2DCount;
            public int tmpTextCount;
            public int activeTmpTextCount;
            public int tmpAutoSizeCount;
            public int tmpWordWrapCount;
            public int uguiTextCount;
            public int activeUguiTextCount;
            public bool captureExists;
            public long captureBytes;
            public int captureWidth;
            public int captureHeight;
            public int captureVisiblePixelCount;
            public int raycastProbeCount;
            public List<NodeState> nodes = new List<NodeState>();
            public List<RaycastProbe> raycastProbes = new List<RaycastProbe>();
        }

        [Serializable]
        private sealed class NodeState
        {
            public string key;
            public bool exists;
            public string name;
            public string path;
            public bool activeSelf;
            public bool activeInHierarchy;
            public int siblingIndex;
            public int childCount;
            public string anchoredPosition;
            public string sizeDelta;
            public string localScale;
            public string imageSprite;
            public bool raycastTarget;
            public bool button;
        }

        [Serializable]
        private sealed class RaycastProbe
        {
            public string key;
            public string targetPrefix;
            public bool buttonFound;
            public string buttonName;
            public bool activeInHierarchy;
            public bool interactable;
            public bool targetGraphicReady;
            public float screenX;
            public float screenY;
            public int hitCount;
            public string topHit;
            public bool topWithinButton;
            public bool containsButton;
        }
    }
}
