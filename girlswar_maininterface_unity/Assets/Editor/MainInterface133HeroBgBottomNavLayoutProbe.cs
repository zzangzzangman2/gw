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
    public static class MainInterface133HeroBgBottomNavLayoutProbe
    {
        private const string ScenePath = "Assets/Scenes/MainInterface_UI126_OldRootReferenceCandidate.unity";
        private const string ReportDir = "C:/Users/godho/Downloads/girlswar/reports/maininterface";
        private const string HeroBgCsv = ReportDir + "/MAININTERFACE_133_hero_bg_probe.csv";
        private const string BottomNavCsv = ReportDir + "/MAININTERFACE_133_bottom_nav_probe.csv";
        private const string ProbeJson = ReportDir + "/MAININTERFACE_133_unity_probe_summary.json";
        private const float ReferenceWidth = 1680f;
        private const float ReferenceHeight = 720f;

        private static readonly string[] HeroBgTokens =
        {
            "UI_MainInterface_old", "UI_bg", "bg_dibu", "UI_heroSpine", "UI_touchSpine",
            "Restore_Hero1005", "Painting_1005", "zhuye_di1", "zhuye_bian"
        };

        private static readonly string[] BottomTokens =
        {
            "node_bottom", "bottom", "toogles", "toggles", "toggle", "btnToggle", "jiarutishi",
            "text_off", "text_on", "sp_home", "sp_guild", "sp_battle", "sp_role"
        };

        [MenuItem("GirlsWar/UI133 Probe Hero BG Bottom Nav Runtime Layout")]
        public static void ProbeHeroBgBottomNavLayout()
        {
            Directory.CreateDirectory(ReportDir);
            if (!File.Exists(ScenePath))
                throw new FileNotFoundException("Old-root candidate scene is missing. Run UI128 candidate build first.", ScenePath);

            EditorSceneManager.OpenScene(ScenePath, OpenSceneMode.Single);
            Canvas.ForceUpdateCanvases();

            var canvases = UnityEngine.Object.FindObjectsByType<Canvas>(FindObjectsInactive.Include, FindObjectsSortMode.None);
            var allTransforms = UnityEngine.Object.FindObjectsByType<Transform>(FindObjectsInactive.Include, FindObjectsSortMode.None)
                .OrderBy(t => GetHierarchyPath(t), StringComparer.Ordinal)
                .ToList();

            var heroRows = allTransforms
                .Where(t => HeroBgTokens.Any(token => ContainsIgnoreCase(GetHierarchyPath(t), token) || ContainsIgnoreCase(t.name, token)))
                .Select(t => BuildRow("hero_bg_target", t, canvases))
                .ToList();

            var bottomRows = new List<ProbeRow>();
            foreach (var transform in allTransforms)
            {
                var path = GetHierarchyPath(transform);
                var hasBottomToken = BottomTokens.Any(token => ContainsIgnoreCase(path, token) || ContainsIgnoreCase(transform.name, token));
                var row = BuildRow(hasBottomToken ? "bottom_token" : "bottom_screen_region", transform, canvases);
                var inBottomRegion = row.screenRectValid && row.screenMinY <= 220f && row.screenMaxY >= -20f;
                var hasUiComponent = transform.GetComponent<Button>() != null ||
                                     transform.GetComponent<Graphic>() != null ||
                                     transform.GetComponent<TMP_Text>() != null ||
                                     transform.GetComponent<Text>() != null ||
                                     transform.GetComponent<CanvasGroup>() != null;
                if (hasBottomToken || (inBottomRegion && hasUiComponent && transform.gameObject.activeInHierarchy))
                    bottomRows.Add(row);
            }

            WriteCsv(HeroBgCsv, heroRows);
            WriteCsv(BottomNavCsv, bottomRows
                .OrderByDescending(r => r.activeInHierarchy)
                .ThenBy(r => r.path, StringComparer.Ordinal)
                .ToList());

            var result = new ProbeSummary
            {
                generatedAt = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture),
                restoredClaim = false,
                scenePatchApplied = false,
                candidatePatchApplied = false,
                scenePath = ScenePath,
                heroBgProbeCsv = HeroBgCsv,
                bottomNavProbeCsv = BottomNavCsv,
                heroBgRows = heroRows.Count,
                bottomNavRows = bottomRows.Count,
                activeBottomNavRows = bottomRows.Count(r => r.activeInHierarchy),
                activeBottomButtons = bottomRows.Count(r => r.activeInHierarchy && r.hasButton && r.buttonInteractable),
                uiBgRaycastTargets = heroRows.Count(r => ContainsIgnoreCase(r.path, "/UI_bg") && r.graphicRaycastTarget),
                uiTouchSpineActiveRows = heroRows.Count(r => ContainsIgnoreCase(r.path, "UI_touchSpine") && r.activeInHierarchy),
                heroSkeletonRows = heroRows.Count(r => ContainsIgnoreCase(r.componentTypes, "SkeletonGraphic")),
                decision = "probe_only_no_coordinate_patch",
                noPatchReason = "UI133 found no new source-backed static transform/layout rule for Hero1005 homePara or bottom navigation. homePara=[1,0,0] and BG1005 loading are source-backed, but UIUtil.GetPlayerBigSpineAll transform semantics and bottom nav runtime/Animator layout state remain probe-only."
            };
            File.WriteAllText(ProbeJson, JsonUtility.ToJson(result, true), Encoding.UTF8);
            AssetDatabase.Refresh(ImportAssetOptions.ForceSynchronousImport);
            Debug.Log("[GirlsWarRestore] UI133 hero/bg/bottom-nav probe complete: " + HeroBgCsv);
        }

        private static ProbeRow BuildRow(string category, Transform transform, Canvas[] canvases)
        {
            var rect = transform as RectTransform;
            var graphic = transform.GetComponent<Graphic>();
            var maskableGraphic = transform.GetComponent<MaskableGraphic>();
            var image = transform.GetComponent<Image>();
            var button = transform.GetComponent<Button>();
            var tmp = transform.GetComponent<TMP_Text>();
            var text = transform.GetComponent<Text>();
            var canvas = transform.GetComponent<Canvas>();
            var canvasGroup = transform.GetComponent<CanvasGroup>();
            var nearestCanvas = transform.GetComponentInParent<Canvas>(true);
            var components = transform.GetComponents<Component>()
                .Where(c => c != null)
                .Select(c => c.GetType().Name)
                .Distinct()
                .OrderBy(c => c, StringComparer.Ordinal)
                .ToArray();

            var row = new ProbeRow
            {
                category = category,
                name = transform.name,
                path = GetHierarchyPath(transform),
                activeSelf = transform.gameObject.activeSelf,
                activeInHierarchy = transform.gameObject.activeInHierarchy,
                siblingIndex = transform.GetSiblingIndex(),
                childCount = transform.childCount,
                componentTypes = string.Join("|", components),
                hasButton = button != null,
                buttonInteractable = button != null && button.interactable,
                hasGraphic = graphic != null,
                graphicEnabled = graphic != null && graphic.enabled,
                graphicRaycastTarget = graphic != null && graphic.raycastTarget,
                graphicMaskable = maskableGraphic != null && maskableGraphic.maskable,
                graphicMaterial = graphic != null && graphic.material != null ? CleanMaterialName(graphic.material.name) : "",
                graphicColor = graphic != null ? ColorText(graphic.color) : "",
                imageSprite = image != null && image.sprite != null ? image.sprite.name : "",
                imageType = image != null ? image.type.ToString() : "",
                imagePreserveAspect = image != null && image.preserveAspect,
                textSample = tmp != null ? OneLine(tmp.text) : text != null ? OneLine(text.text) : "",
                textFont = tmp != null && tmp.font != null ? tmp.font.name : text != null && text.font != null ? text.font.name : "",
                textMaterial = tmp != null && tmp.fontSharedMaterial != null ? CleanMaterialName(tmp.fontSharedMaterial.name) : text != null && text.material != null ? CleanMaterialName(text.material.name) : "",
                canvasOverrideSorting = canvas != null && canvas.overrideSorting,
                canvasSortingOrder = canvas != null ? canvas.sortingOrder : 0,
                canvasRenderMode = canvas != null ? canvas.renderMode.ToString() : "",
                nearestCanvasPath = nearestCanvas != null ? GetHierarchyPath(nearestCanvas.transform) : "",
                nearestCanvasSortingOrder = nearestCanvas != null ? nearestCanvas.sortingOrder : 0,
                canvasGroupAlpha = canvasGroup != null ? canvasGroup.alpha.ToString("0.###", CultureInfo.InvariantCulture) : "",
                maskAncestors = GetMaskAncestors(transform)
            };

            if (rect != null)
            {
                row.anchorMin = Vec2Text(rect.anchorMin);
                row.anchorMax = Vec2Text(rect.anchorMax);
                row.pivot = Vec2Text(rect.pivot);
                row.anchoredPosition = Vec2Text(rect.anchoredPosition);
                row.sizeDelta = Vec2Text(rect.sizeDelta);
                row.rectSize = Vec2Text(rect.rect.size);
                row.localScale = Vec3Text(rect.localScale);
                row.localPosition = Vec3Text(rect.localPosition);
                row.localRotation = Vec3Text(rect.localEulerAngles);
                var screen = GetScreenRect(rect, nearestCanvas);
                row.screenRectValid = screen.valid;
                row.screenMinX = screen.minX;
                row.screenMinY = screen.minY;
                row.screenMaxX = screen.maxX;
                row.screenMaxY = screen.maxY;
                row.screenRect = screen.valid
                    ? string.Format(CultureInfo.InvariantCulture, "{0:0.###},{1:0.###},{2:0.###},{3:0.###}", screen.minX, screen.minY, screen.maxX, screen.maxY)
                    : "";
            }

            row.sourceBackedDecision = ClassifyDecision(row);
            return row;
        }

        private static string ClassifyDecision(ProbeRow row)
        {
            var path = row.path.ToLowerInvariant();
            if (path.Contains("node_act_btn") || path.Contains("btn_act_") || path.Contains("btn_face_item"))
                return "guardrail_no_activity_patch_requires_snapshot";
            if (path.Contains("ui_bg"))
                return "source_backed_bg1005_binding_already_candidate_no_raycast_patch";
            if (path.Contains("ui_herospine") || path.Contains("restore_hero1005") || path.Contains("painting_1005"))
                return "source_backed_hero_mount_probe_only_homepara_transform_unresolved";
            if (path.Contains("node_bottom") || path.Contains("toggle") || path.Contains("toogles") || path.Contains("btntoggle"))
                return "needs_unity_runtime_probe_no_static_layout_patch";
            if (path.Contains("zhuye_di1") || path.Contains("zhuye_bian"))
                return "guardrail_preserve_preclipping_attachment";
            return "audit_row_no_patch";
        }

        private static (bool valid, float minX, float minY, float maxX, float maxY) GetScreenRect(RectTransform rect, Canvas canvas)
        {
            var corners = new Vector3[4];
            rect.GetWorldCorners(corners);
            var camera = canvas != null && canvas.renderMode != RenderMode.ScreenSpaceOverlay ? canvas.worldCamera : null;
            var points = corners.Select(c => RectTransformUtility.WorldToScreenPoint(camera, c)).ToArray();
            if (points.Any(p => float.IsNaN(p.x) || float.IsNaN(p.y)))
                return (false, 0, 0, 0, 0);

            var minX = points.Min(p => p.x);
            var minY = points.Min(p => p.y);
            var maxX = points.Max(p => p.x);
            var maxY = points.Max(p => p.y);

            if (Screen.width > 0 && Math.Abs(Screen.width - ReferenceWidth) > 0.1f)
            {
                var scaleX = ReferenceWidth / Screen.width;
                minX *= scaleX;
                maxX *= scaleX;
            }
            if (Screen.height > 0 && Math.Abs(Screen.height - ReferenceHeight) > 0.1f)
            {
                var scaleY = ReferenceHeight / Screen.height;
                minY *= scaleY;
                maxY *= scaleY;
            }
            return (true, minX, minY, maxX, maxY);
        }

        private static string GetMaskAncestors(Transform transform)
        {
            var parts = new List<string>();
            var current = transform.parent;
            while (current != null)
            {
                if (current.GetComponent<Mask>() != null || current.GetComponent<RectMask2D>() != null)
                    parts.Add(current.name);
                current = current.parent;
            }
            return string.Join("|", parts);
        }

        private static void WriteCsv(string path, List<ProbeRow> rows)
        {
            var sb = new StringBuilder();
            var header = new[]
            {
                "category", "source_backed_decision", "name", "path", "active_self", "active_in_hierarchy",
                "sibling_index", "child_count", "component_types", "has_button", "button_interactable",
                "has_graphic", "graphic_enabled", "graphic_raycast_target", "graphic_maskable",
                "graphic_material", "graphic_color", "image_sprite", "image_type", "image_preserve_aspect",
                "text_sample", "text_font", "text_material", "anchor_min", "anchor_max", "pivot",
                "anchored_position", "size_delta", "rect_size", "local_scale", "local_position",
                "local_rotation", "screen_rect_valid", "screen_rect", "screen_min_x", "screen_min_y",
                "screen_max_x", "screen_max_y", "canvas_override_sorting", "canvas_sorting_order",
                "canvas_render_mode", "nearest_canvas_path", "nearest_canvas_sorting_order",
                "canvas_group_alpha", "mask_ancestors"
            };
            sb.AppendLine(string.Join(",", header.Select(Csv)));
            foreach (var row in rows)
            {
                var values = new[]
                {
                    row.category, row.sourceBackedDecision, row.name, row.path, row.activeSelf.ToString(),
                    row.activeInHierarchy.ToString(), row.siblingIndex.ToString(CultureInfo.InvariantCulture),
                    row.childCount.ToString(CultureInfo.InvariantCulture), row.componentTypes, row.hasButton.ToString(),
                    row.buttonInteractable.ToString(), row.hasGraphic.ToString(), row.graphicEnabled.ToString(),
                    row.graphicRaycastTarget.ToString(), row.graphicMaskable.ToString(), row.graphicMaterial,
                    row.graphicColor, row.imageSprite, row.imageType, row.imagePreserveAspect.ToString(),
                    row.textSample, row.textFont, row.textMaterial, row.anchorMin, row.anchorMax, row.pivot,
                    row.anchoredPosition, row.sizeDelta, row.rectSize, row.localScale, row.localPosition,
                    row.localRotation, row.screenRectValid.ToString(), row.screenRect,
                    row.screenMinX.ToString("0.###", CultureInfo.InvariantCulture),
                    row.screenMinY.ToString("0.###", CultureInfo.InvariantCulture),
                    row.screenMaxX.ToString("0.###", CultureInfo.InvariantCulture),
                    row.screenMaxY.ToString("0.###", CultureInfo.InvariantCulture),
                    row.canvasOverrideSorting.ToString(),
                    row.canvasSortingOrder.ToString(CultureInfo.InvariantCulture), row.canvasRenderMode,
                    row.nearestCanvasPath, row.nearestCanvasSortingOrder.ToString(CultureInfo.InvariantCulture),
                    row.canvasGroupAlpha, row.maskAncestors
                };
                sb.AppendLine(string.Join(",", values.Select(Csv)));
            }
            File.WriteAllText(path, sb.ToString(), new UTF8Encoding(false));
        }

        private static string GetHierarchyPath(Transform transform)
        {
            var stack = new Stack<string>();
            var current = transform;
            while (current != null)
            {
                stack.Push(current.name);
                current = current.parent;
            }
            return string.Join("/", stack);
        }

        private static bool ContainsIgnoreCase(string value, string token)
        {
            return value != null && token != null && value.IndexOf(token, StringComparison.OrdinalIgnoreCase) >= 0;
        }

        private static string Csv(string value)
        {
            value = value ?? "";
            return "\"" + value.Replace("\"", "\"\"") + "\"";
        }

        private static string Vec2Text(Vector2 v)
        {
            return string.Format(CultureInfo.InvariantCulture, "{0:0.###},{1:0.###}", v.x, v.y);
        }

        private static string Vec3Text(Vector3 v)
        {
            return string.Format(CultureInfo.InvariantCulture, "{0:0.###},{1:0.###},{2:0.###}", v.x, v.y, v.z);
        }

        private static string ColorText(Color c)
        {
            return string.Format(CultureInfo.InvariantCulture, "{0:0.###},{1:0.###},{2:0.###},{3:0.###}", c.r, c.g, c.b, c.a);
        }

        private static string CleanMaterialName(string name)
        {
            return (name ?? "").Replace(" (Instance)", "");
        }

        private static string OneLine(string text)
        {
            if (string.IsNullOrEmpty(text))
                return "";
            text = text.Replace("\r", "\\r").Replace("\n", "\\n");
            return text.Length > 120 ? text.Substring(0, 120) : text;
        }

        [Serializable]
        private class ProbeSummary
        {
            public string generatedAt;
            public bool restoredClaim;
            public bool scenePatchApplied;
            public bool candidatePatchApplied;
            public string scenePath;
            public string heroBgProbeCsv;
            public string bottomNavProbeCsv;
            public int heroBgRows;
            public int bottomNavRows;
            public int activeBottomNavRows;
            public int activeBottomButtons;
            public int uiBgRaycastTargets;
            public int uiTouchSpineActiveRows;
            public int heroSkeletonRows;
            public string decision;
            public string noPatchReason;
        }

        private class ProbeRow
        {
            public string category;
            public string sourceBackedDecision;
            public string name;
            public string path;
            public bool activeSelf;
            public bool activeInHierarchy;
            public int siblingIndex;
            public int childCount;
            public string componentTypes;
            public bool hasButton;
            public bool buttonInteractable;
            public bool hasGraphic;
            public bool graphicEnabled;
            public bool graphicRaycastTarget;
            public bool graphicMaskable;
            public string graphicMaterial;
            public string graphicColor;
            public string imageSprite;
            public string imageType;
            public bool imagePreserveAspect;
            public string textSample;
            public string textFont;
            public string textMaterial;
            public string anchorMin;
            public string anchorMax;
            public string pivot;
            public string anchoredPosition;
            public string sizeDelta;
            public string rectSize;
            public string localScale;
            public string localPosition;
            public string localRotation;
            public bool screenRectValid;
            public string screenRect;
            public float screenMinX;
            public float screenMinY;
            public float screenMaxX;
            public float screenMaxY;
            public bool canvasOverrideSorting;
            public int canvasSortingOrder;
            public string canvasRenderMode;
            public string nearestCanvasPath;
            public int nearestCanvasSortingOrder;
            public string canvasGroupAlpha;
            public string maskAncestors;
        }
    }
}
