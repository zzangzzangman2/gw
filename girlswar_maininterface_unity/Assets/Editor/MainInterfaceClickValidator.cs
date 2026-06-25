using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

namespace GirlsWarRestore
{
    public static class MainInterfaceClickValidator
    {
        private const string ScenePath = "Assets/Scenes/MainInterface_Wireframe.unity";
        private const string CsvPath = "Assets/RestoreData/reports/maininterface_click_validation.csv";
        private const string JsonPath = "Assets/RestoreData/reports/maininterface_click_validation_summary.json";
        private const float ReferenceWidth = 1280f;
        private const float ReferenceHeight = 720f;

        [MenuItem("GirlsWar/Validate MainInterface Button Clicks")]
        public static void ValidateMenu()
        {
            ValidateMainInterfaceButtonClicks();
        }

        public static void ValidateMainInterfaceButtonClicks()
        {
            if (!File.Exists(ScenePath))
                MainInterfaceSceneBuilder.BuildMainInterfaceScene();

            EditorSceneManager.OpenScene(ScenePath, OpenSceneMode.Single);

            var canvas = FindFirstSceneObject<Canvas>();
            if (canvas == null)
                throw new Exception("Click validation failed: Canvas not found in " + ScenePath);

            Canvas.ForceUpdateCanvases();
            var raycastGraphics = FindRaycastGraphics(canvas);

            var rows = new List<ClickValidationRow>();
            var buttons = FindRestoreButtons();
            foreach (var button in buttons)
            {
                rows.Add(ValidateButton(button, raycastGraphics));
            }

            WriteCsv(CsvPath, rows);
            var summary = BuildSummary(rows);
            File.WriteAllText(JsonPath, JsonUtility.ToJson(summary, true), Encoding.UTF8);
            WriteMarkdown(summary, rows);
            AssetDatabase.Refresh();

            Debug.Log("[GirlsWarRestore] MainInterface click validation: "
                + summary.raycastClickableButtons + "/" + summary.totalButtons
                + " raycast-clickable, invoked=" + summary.invokedClicks
                + ", blocked=" + summary.raycastBlockedButtons
                + " -> " + CsvPath);
        }

        private static ClickValidationRow ValidateButton(Button button, List<Graphic> raycastGraphics)
        {
            var logger = button.GetComponent<RestoreClickLogger>();
            var rt = button.GetComponent<RectTransform>();
            var graphic = button.targetGraphic;
            var screenPoint = Vector2.zero;
            var centerWorld = Vector3.zero;
            if (rt != null)
            {
                var corners = new Vector3[4];
                rt.GetWorldCorners(corners);
                centerWorld = (corners[0] + corners[2]) * 0.5f;
                screenPoint = new Vector2(ReferenceWidth * 0.5f + centerWorld.x, ReferenceHeight * 0.5f + centerWorld.y);
            }

            var hits = new List<GraphicHit>();
            foreach (var candidate in raycastGraphics)
            {
                if (candidate == null || candidate.rectTransform == null)
                    continue;
                if (!ContainsWorldPoint(candidate.rectTransform, centerWorld))
                    continue;
                hits.Add(new GraphicHit
                {
                    graphic = candidate,
                    logger = candidate.GetComponentInParent<RestoreClickLogger>(),
                    depth = candidate.depth
                });
            }
            hits.Sort(CompareHitsTopFirst);

            var topObject = hits.Count > 0 ? hits[0].graphic.gameObject : null;
            var topLogger = hits.Count > 0 ? hits[0].logger : null;
            var topWithinButton = topObject != null && topObject.transform.IsChildOf(button.transform);
            var containsButton = false;
            foreach (var hit in hits)
            {
                if (hit.graphic != null && hit.graphic.transform.IsChildOf(button.transform))
                {
                    containsButton = true;
                    break;
                }
            }

            var active = button.gameObject.activeInHierarchy;
            var interactable = button.interactable && button.enabled;
            var targetGraphicReady = graphic != null && graphic.enabled && graphic.raycastTarget;
            var raycastClickable = active && interactable && targetGraphicReady && topWithinButton;
            var invoked = false;
            if (raycastClickable)
            {
                button.onClick.Invoke();
                if (logger != null)
                    logger.LogClick();
                invoked = true;
            }

            return new ClickValidationRow
            {
                buttonName = logger != null ? logger.buttonName : button.gameObject.name,
                componentPathId = logger != null ? logger.buttonComponentPathId : "",
                gameObjectPathId = logger != null ? logger.gameObjectPathId : "",
                activeInHierarchy = active,
                interactable = interactable,
                targetGraphicReady = targetGraphicReady,
                screenX = screenPoint.x,
                screenY = screenPoint.y,
                raycastHitCount = hits.Count,
                raycastTopObject = topObject != null ? CleanName(topObject.name) : "",
                raycastTopKind = topLogger != null ? topLogger.loggerKind : "",
                raycastTopComponentPathId = topLogger != null ? topLogger.buttonComponentPathId : "",
                raycastTopWithinButton = topWithinButton,
                raycastContainsButton = containsButton,
                raycastClickable = raycastClickable,
                clickInvoked = invoked,
                luaModule = logger != null ? logger.luaModule : "",
                luaHandler = logger != null ? logger.luaHandler : "",
                luaConfidence = logger != null ? logger.luaHandlerConfidence : "",
                luaEvent = logger != null ? logger.luaHandlerEvent : ""
            };
        }

        private static List<Button> FindRestoreButtons()
        {
            var result = new List<Button>();
            var buttons = UnityEngine.Object.FindObjectsByType<Button>(FindObjectsInactive.Include);
            foreach (var button in buttons)
            {
                var logger = button.GetComponent<RestoreClickLogger>();
                if (logger == null || logger.loggerKind != "Button")
                    continue;
                result.Add(button);
            }
            result.Sort((a, b) =>
            {
                var la = a.GetComponent<RestoreClickLogger>();
                var lb = b.GetComponent<RestoreClickLogger>();
                return string.Compare(la != null ? la.buttonComponentPathId : "", lb != null ? lb.buttonComponentPathId : "", StringComparison.Ordinal);
            });
            return result;
        }

        private static List<Graphic> FindRaycastGraphics(Canvas canvas)
        {
            var result = new List<Graphic>();
            var graphics = UnityEngine.Object.FindObjectsByType<Graphic>(FindObjectsInactive.Include);
            foreach (var graphic in graphics)
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

        private static T FindFirstSceneObject<T>() where T : UnityEngine.Object
        {
            var objects = UnityEngine.Object.FindObjectsByType<T>(FindObjectsInactive.Include);
            return objects.Length > 0 ? objects[0] : null;
        }

        private static ClickValidationSummary BuildSummary(List<ClickValidationRow> rows)
        {
            var summary = new ClickValidationSummary();
            summary.totalButtons = rows.Count;
            foreach (var row in rows)
            {
                if (row.activeInHierarchy)
                    summary.activeButtons++;
                else
                    summary.inactiveButtons++;
                if (row.interactable)
                    summary.interactableButtons++;
                if (row.targetGraphicReady)
                    summary.targetGraphicReadyButtons++;
                if (row.raycastClickable)
                    summary.raycastClickableButtons++;
                else if (row.activeInHierarchy && row.interactable)
                    summary.raycastBlockedButtons++;
                if (row.clickInvoked)
                    summary.invokedClicks++;
                if (row.luaConfidence == "module_and_target")
                    summary.moduleAndTargetMatches++;
                else if (row.luaConfidence == "candidate_module_and_target")
                    summary.candidateModuleAndTargetMatches++;
                else if (row.luaConfidence == "target_name_only")
                    summary.targetNameOnlyMatches++;
                else if (row.luaConfidence == "missing")
                    summary.missingLuaMatches++;
            }
            summary.csv = Path.GetFullPath(CsvPath);
            summary.json = Path.GetFullPath(JsonPath);
            summary.markdown = GetMarkdownPath();
            summary.generatedAt = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
            return summary;
        }

        private static void WriteCsv(string path, List<ClickValidationRow> rows)
        {
            Directory.CreateDirectory(Path.GetDirectoryName(path));
            var sb = new StringBuilder();
            sb.AppendLine("button_name,component_path_id,game_object_path_id,active_in_hierarchy,interactable,target_graphic_ready,screen_x,screen_y,raycast_hit_count,raycast_top_object,raycast_top_kind,raycast_top_component_path_id,raycast_top_within_button,raycast_contains_button,raycast_clickable,click_invoked,lua_module,lua_handler,lua_confidence,lua_event");
            foreach (var row in rows)
            {
                sb.Append(Csv(row.buttonName)).Append(',');
                sb.Append(Csv(row.componentPathId)).Append(',');
                sb.Append(Csv(row.gameObjectPathId)).Append(',');
                sb.Append(row.activeInHierarchy ? "1" : "0").Append(',');
                sb.Append(row.interactable ? "1" : "0").Append(',');
                sb.Append(row.targetGraphicReady ? "1" : "0").Append(',');
                sb.Append(row.screenX.ToString("0.###", System.Globalization.CultureInfo.InvariantCulture)).Append(',');
                sb.Append(row.screenY.ToString("0.###", System.Globalization.CultureInfo.InvariantCulture)).Append(',');
                sb.Append(row.raycastHitCount).Append(',');
                sb.Append(Csv(row.raycastTopObject)).Append(',');
                sb.Append(Csv(row.raycastTopKind)).Append(',');
                sb.Append(Csv(row.raycastTopComponentPathId)).Append(',');
                sb.Append(row.raycastTopWithinButton ? "1" : "0").Append(',');
                sb.Append(row.raycastContainsButton ? "1" : "0").Append(',');
                sb.Append(row.raycastClickable ? "1" : "0").Append(',');
                sb.Append(row.clickInvoked ? "1" : "0").Append(',');
                sb.Append(Csv(row.luaModule)).Append(',');
                sb.Append(Csv(row.luaHandler)).Append(',');
                sb.Append(Csv(row.luaConfidence)).Append(',');
                sb.Append(Csv(row.luaEvent)).AppendLine();
            }
            File.WriteAllText(path, sb.ToString(), new UTF8Encoding(true));
        }

        private static void WriteMarkdown(ClickValidationSummary summary, List<ClickValidationRow> rows)
        {
            var md = new List<string>
            {
                "# MainInterface Click Validation",
                "",
                "## Summary",
                "",
                "- Generated at: `" + summary.generatedAt + "`",
                "- Total Button loggers: `" + summary.totalButtons + "`",
                "- Active buttons: `" + summary.activeButtons + "`",
                "- Interactable buttons: `" + summary.interactableButtons + "`",
                "- Raycast-clickable buttons: `" + summary.raycastClickableButtons + "`",
                "- Raycast-blocked active buttons: `" + summary.raycastBlockedButtons + "`",
                "- Click logs invoked: `" + summary.invokedClicks + "`",
                "- Lua module+target matches: `" + summary.moduleAndTargetMatches + "`",
                "- Lua candidate matches: `" + summary.candidateModuleAndTargetMatches + "`",
                "- Lua target-name-only matches: `" + summary.targetNameOnlyMatches + "`",
                "- Lua missing matches: `" + summary.missingLuaMatches + "`",
                "",
                "## Blocked Or Not Clickable",
                "",
                "| Button | Lua handler | Top raycast object | Top kind | Reason |",
                "|---|---|---|---|---|"
            };

            var blocked = 0;
            foreach (var row in rows)
            {
                if (row.raycastClickable)
                    continue;
                blocked++;
                if (blocked > 60)
                    break;
                md.Add("| `" + row.buttonName + "` | `" + row.luaHandler + "` | `" + row.raycastTopObject + "` | `" + row.raycastTopKind + "` | `" + Reason(row) + "` |");
            }
            if (blocked == 0)
                md.Add("| none |  |  |  |  |");

            md.Add("");
            md.Add("## Exact Lua Handler Buttons");
            md.Add("");
            md.Add("| Button | Lua module | Handler | Clickable |");
            md.Add("|---|---|---|---|");
            var exactRows = 0;
            foreach (var row in rows)
            {
                if (row.luaConfidence != "module_and_target")
                    continue;
                exactRows++;
                if (exactRows > 80)
                    break;
                md.Add("| `" + row.buttonName + "` | `" + row.luaModule + "` | `" + row.luaHandler + "` | `" + (row.raycastClickable ? "yes" : "no") + "` |");
            }

            md.Add("");
            md.Add("## Outputs");
            md.Add("");
            md.Add("- CSV: `" + summary.csv + "`");
            md.Add("- JSON: `" + summary.json + "`");

            File.WriteAllText(GetMarkdownPath(), string.Join("\n", md) + "\n", Encoding.UTF8);
        }

        private static string Reason(ClickValidationRow row)
        {
            if (!row.activeInHierarchy)
                return "inactive";
            if (!row.interactable)
                return "not_interactable";
            if (!row.targetGraphicReady)
                return "target_graphic_not_raycastable";
            if (row.raycastHitCount == 0)
                return "no_raycast_hit";
            if (!row.raycastTopWithinButton && row.raycastContainsButton)
                return "blocked_by_higher_graphic";
            return "button_not_in_raycast_stack";
        }

        private static string GetMarkdownPath()
        {
            var projectRoot = Directory.GetParent(Application.dataPath).FullName;
            var girlswarRoot = Directory.GetParent(projectRoot).FullName;
            return Path.Combine(girlswarRoot, "reports", "maininterface", "MAININTERFACE_CLICK_VALIDATION.md");
        }

        private static string Csv(string value)
        {
            value = value ?? "";
            if (value.IndexOfAny(new[] {',', '"', '\r', '\n'}) < 0)
                return value;
            return "\"" + value.Replace("\"", "\"\"") + "\"";
        }

        private static string CleanName(string value)
        {
            if (string.IsNullOrEmpty(value))
                return "";
            var marker = value.IndexOf("__", StringComparison.Ordinal);
            return marker > 0 ? value.Substring(0, marker) : value;
        }

        private static bool ContainsWorldPoint(RectTransform rectTransform, Vector3 worldPoint)
        {
            var local = rectTransform.InverseTransformPoint(worldPoint);
            return rectTransform.rect.Contains(new Vector2(local.x, local.y));
        }

        private static int CompareHitsTopFirst(GraphicHit a, GraphicHit b)
        {
            var drawOrder = CompareDrawOrder(a.graphic.transform, b.graphic.transform);
            if (drawOrder != 0)
                return -drawOrder;
            return -a.depth.CompareTo(b.depth);
        }

        private static int CompareDrawOrder(Transform a, Transform b)
        {
            var aPath = SiblingPath(a);
            var bPath = SiblingPath(b);
            var min = Mathf.Min(aPath.Count, bPath.Count);
            for (var i = 0; i < min; i++)
            {
                if (aPath[i] != bPath[i])
                    return aPath[i].CompareTo(bPath[i]);
            }
            return aPath.Count.CompareTo(bPath.Count);
        }

        private static List<int> SiblingPath(Transform transform)
        {
            var path = new List<int>();
            var current = transform;
            while (current != null)
            {
                path.Add(current.GetSiblingIndex());
                current = current.parent;
            }
            path.Reverse();
            return path;
        }

        private sealed class GraphicHit
        {
            public Graphic graphic;
            public RestoreClickLogger logger;
            public int depth;
        }

        [Serializable]
        private sealed class ClickValidationRow
        {
            public string buttonName;
            public string componentPathId;
            public string gameObjectPathId;
            public bool activeInHierarchy;
            public bool interactable;
            public bool targetGraphicReady;
            public float screenX;
            public float screenY;
            public int raycastHitCount;
            public string raycastTopObject;
            public string raycastTopKind;
            public string raycastTopComponentPathId;
            public bool raycastTopWithinButton;
            public bool raycastContainsButton;
            public bool raycastClickable;
            public bool clickInvoked;
            public string luaModule;
            public string luaHandler;
            public string luaConfidence;
            public string luaEvent;
        }

        [Serializable]
        private sealed class ClickValidationSummary
        {
            public string generatedAt;
            public int totalButtons;
            public int activeButtons;
            public int inactiveButtons;
            public int interactableButtons;
            public int targetGraphicReadyButtons;
            public int raycastClickableButtons;
            public int raycastBlockedButtons;
            public int invokedClicks;
            public int moduleAndTargetMatches;
            public int candidateModuleAndTargetMatches;
            public int targetNameOnlyMatches;
            public int missingLuaMatches;
            public string csv;
            public string json;
            public string markdown;
        }
    }
}
