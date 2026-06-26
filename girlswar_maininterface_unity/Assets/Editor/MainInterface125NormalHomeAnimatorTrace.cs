using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using UnityEditor;
using UnityEditor.Animations;
using UnityEngine;

namespace GirlsWarRestore
{
    public static class MainInterface125NormalHomeAnimatorTrace
    {
        private const string MainBundlePath = "C:/Users/godho/Downloads/girlswar/girlswar_merged_extracted/extracted/unity/clean_unityfs_slices/download/ui/uiprefabandres/maininterface.assetbundle";
        private const string Ext4BundlePath = "C:/Users/godho/Downloads/girlswar/girlswar_merged_extracted/extracted/unity/clean_unityfs_slices/download/ui/uiprefabandres/maininterface_ext_4.assetbundle";
        private const string CsvPath = "Assets/RestoreData/reports/maininterface_125_animator_home_state_bindings.csv";
        private const string JsonPath = "Assets/RestoreData/maininterface_125_animator_home_state_trace.json";
        private const string MdPath = "C:/Users/godho/Downloads/girlswar/reports/maininterface/MAININTERFACE_125_ANIMATOR_HOME_STATE_TRACE.md";

        [MenuItem("GirlsWar/UI125 Trace MainInterface Normal Home Animator")]
        public static void Trace()
        {
            Directory.CreateDirectory("Assets/RestoreData/reports");
            Directory.CreateDirectory("C:/Users/godho/Downloads/girlswar/reports/maininterface");

            var result = new TraceResult
            {
                generatedAt = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
                mainBundlePath = MainBundlePath,
                ext4BundlePath = Ext4BundlePath,
                restoredClaim = false,
                rows = new List<BindingRow>(),
                controllerRows = new List<ControllerRow>(),
                prefabRows = new List<PrefabRow>(),
                conclusions = new List<string>()
            };

            AssetBundle ext4 = null;
            AssetBundle main = null;
            try
            {
                if (!File.Exists(Ext4BundlePath))
                    throw new FileNotFoundException("Missing ext4 assetbundle", Ext4BundlePath);
                if (!File.Exists(MainBundlePath))
                    throw new FileNotFoundException("Missing maininterface assetbundle", MainBundlePath);

                ext4 = AssetBundle.LoadFromFile(Ext4BundlePath);
                if (ext4 == null)
                    throw new Exception("AssetBundle.LoadFromFile returned null for " + Ext4BundlePath);

                TraceControllerAndClips(ext4, result);

                main = AssetBundle.LoadFromFile(MainBundlePath);
                if (main != null)
                {
                    TracePrefabAnimator(main, result);
                    TraceAnimatorPathHashes(main, result);
                }
                else
                    result.conclusions.Add("Unity could not load maininterface.assetbundle directly; UnityPy evidence remains required for prefab component linkage.");

                AddConclusions(result);
                WriteCsv(result.rows);
                WriteJson(result);
                WriteMarkdown(result);
            }
            finally
            {
                if (main != null)
                    main.Unload(false);
                if (ext4 != null)
                    ext4.Unload(false);
                AssetDatabase.Refresh(ImportAssetOptions.ForceSynchronousImport);
            }

            Debug.Log("[GirlsWarRestore] UI125 animator trace complete: " + CsvPath);
        }

        private static void TraceControllerAndClips(AssetBundle ext4, TraceResult result)
        {
            foreach (var controller in ext4.LoadAllAssets<AnimatorController>().OrderBy(c => c.name, StringComparer.Ordinal))
            {
                if (controller.name != "UI_MainInterface")
                    continue;

                foreach (var layer in controller.layers)
                {
                    var defaultStateName = layer.stateMachine.defaultState != null ? layer.stateMachine.defaultState.name : "";
                    result.controllerRows.Add(new ControllerRow
                    {
                        controller = controller.name,
                        layer = layer.name,
                        defaultState = defaultStateName
                    });

                    foreach (var childState in layer.stateMachine.states)
                    {
                        var motionName = childState.state.motion != null ? childState.state.motion.name : "";
                        result.controllerRows.Add(new ControllerRow
                        {
                            controller = controller.name,
                            layer = layer.name,
                            state = childState.state.name,
                            motion = motionName,
                            isDefaultState = childState.state == layer.stateMachine.defaultState
                        });
                    }
                }
            }

            var targetNames = new HashSet<string>(StringComparer.Ordinal)
            {
                "UI_MainInterface_in",
                "UI_MainInterface_idle",
                "UI_MainInterface_out"
            };

            foreach (var clip in ext4.LoadAllAssets<AnimationClip>().Where(c => targetNames.Contains(c.name)).OrderBy(c => c.name, StringComparer.Ordinal))
            {
                foreach (var binding in AnimationUtility.GetCurveBindings(clip))
                {
                    result.rows.Add(new BindingRow
                    {
                        clip = clip.name,
                        path = binding.path,
                        property = binding.propertyName,
                        type = binding.type != null ? binding.type.FullName : "",
                        isObjectReference = false,
                        routeRelated = IsRouteRelated(binding.path)
                    });
                }

                foreach (var binding in AnimationUtility.GetObjectReferenceCurveBindings(clip))
                {
                    result.rows.Add(new BindingRow
                    {
                        clip = clip.name,
                        path = binding.path,
                        property = binding.propertyName,
                        type = binding.type != null ? binding.type.FullName : "",
                        isObjectReference = true,
                        routeRelated = IsRouteRelated(binding.path)
                    });
                }

                if (!result.rows.Any(r => r.clip == clip.name))
                {
                    result.rows.Add(new BindingRow
                    {
                        clip = clip.name,
                        path = "",
                        property = "",
                        type = "",
                        isObjectReference = false,
                        routeRelated = false,
                        note = "clip_has_no_editor_curve_bindings"
                    });
                }
            }
        }

        private static void TracePrefabAnimator(AssetBundle main, TraceResult result)
        {
            foreach (var go in main.LoadAllAssets<GameObject>().Where(g => g.name == "UI_MainInterface"))
            {
                var animator = go.GetComponent<Animator>();
                var canvas = go.GetComponent<Canvas>();
                var group = go.GetComponent<CanvasGroup>();
                result.prefabRows.Add(new PrefabRow
                {
                    gameObject = go.name,
                    activeSelf = go.activeSelf,
                    hasAnimator = animator != null,
                    animatorController = animator != null && animator.runtimeAnimatorController != null ? animator.runtimeAnimatorController.name : "",
                    hasCanvas = canvas != null,
                    canvasOverrideSorting = canvas != null && canvas.overrideSorting,
                    canvasSortingOrder = canvas != null ? canvas.sortingOrder : 0,
                    hasCanvasGroup = group != null,
                    canvasGroupAlpha = group != null ? group.alpha : -1f
                });
            }
        }

        private static void AddConclusions(TraceResult result)
        {
            var routeRows = result.rows.Where(r => r.routeRelated).ToList();
            result.conclusions.Add("UI_MainInterface controller and clips are in maininterface_ext_4.assetbundle.");
            result.conclusions.Add("Lua UI_MainPage OnOpen plays UI_MainInterface_in, then UI_MainInterface_idle on the stopPlayEnterAnim branch; UI hide/show plays out/in.");
            if (routeRows.Count == 0)
            {
                result.conclusions.Add("Unity AnimationUtility did not expose normal curve paths for the assetbundle-loaded compressed/generic clips. UnityPy finds 42 generic bindings, so this is an Editor API limitation rather than proof that the clips are empty.");
            }
            else
            {
                result.conclusions.Add("Route-related animator bindings exist; inspect CSV before applying any active/layer patch.");
            }
            if (result.pathHashRows.Count == 0)
                result.conclusions.Add("Animator.StringToHash comparison found no prefab transform path matching the six generic binding path hashes from UnityPy.");
            else
                result.conclusions.Add("Animator.StringToHash comparison resolved " + result.pathHashRows.Count + " generic binding path hashes to prefab transform paths.");

            var controllerDefault = result.controllerRows.FirstOrDefault(r => !string.IsNullOrEmpty(r.defaultState));
            if (controllerDefault != null)
                result.conclusions.Add("Controller default state is " + controllerDefault.defaultState + "; Lua runtime explicitly plays named in/idle/out clips rather than relying only on prefab default.");

            var prefab = result.prefabRows.FirstOrDefault();
            if (prefab != null)
                result.conclusions.Add("Original prefab UI_MainInterface has Animator=" + prefab.hasAnimator + ", controller=" + prefab.animatorController + ", Canvas.overrideSorting=" + prefab.canvasOverrideSorting + ", Canvas.sortingOrder=" + prefab.canvasSortingOrder + ", CanvasGroup.alpha=" + prefab.canvasGroupAlpha.ToString("0.###") + ".");
        }

        private static bool IsRouteRelated(string path)
        {
            if (string.IsNullOrEmpty(path))
                return false;
            return path.IndexOf("right", StringComparison.OrdinalIgnoreCase) >= 0
                || path.IndexOf("node_middle", StringComparison.OrdinalIgnoreCase) >= 0
                || path.IndexOf("wanfaWorldNode", StringComparison.OrdinalIgnoreCase) >= 0
                || path.IndexOf("worldwanfaBtn", StringComparison.OrdinalIgnoreCase) >= 0
                || path.IndexOf("UI_Main_wanfa_item", StringComparison.OrdinalIgnoreCase) >= 0;
        }

        private static void TraceAnimatorPathHashes(AssetBundle main, TraceResult result)
        {
            var targetHashes = new HashSet<int>
            {
                unchecked((int)283520407u),
                unchecked((int)2053629800u),
                unchecked((int)2138030896u),
                unchecked((int)2314173485u),
                unchecked((int)2853304615u),
                unchecked((int)3033167124u)
            };

            foreach (var go in main.LoadAllAssets<GameObject>().Where(g => g.name == "UI_MainInterface"))
                WalkPathHashes(go.transform, "", "UI_MainInterface", targetHashes, result);
        }

        private static void WalkPathHashes(Transform current, string relativePath, string rootedPath, HashSet<int> targetHashes, TraceResult result)
        {
            AddPathHash(relativePath, false, targetHashes, result);
            AddPathHash(rootedPath, true, targetHashes, result);

            for (var i = 0; i < current.childCount; i++)
            {
                var child = current.GetChild(i);
                var childRelativePath = string.IsNullOrEmpty(relativePath) ? child.name : relativePath + "/" + child.name;
                var childRootedPath = rootedPath + "/" + child.name;
                WalkPathHashes(child, childRelativePath, childRootedPath, targetHashes, result);
            }
        }

        private static void AddPathHash(string path, bool includesRoot, HashSet<int> targetHashes, TraceResult result)
        {
            var hash = Animator.StringToHash(path);
            if (!targetHashes.Contains(hash))
                return;
            if (result.pathHashRows.Any(r => r.path == path && r.includesRoot == includesRoot))
                return;
            result.pathHashRows.Add(new PathHashRow
            {
                path = path,
                includesRoot = includesRoot,
                hashSigned = hash,
                hashUnsigned = unchecked((uint)hash),
                routeRelated = IsRouteRelated(path)
            });
        }

        private static void WriteCsv(List<BindingRow> rows)
        {
            var sb = new StringBuilder();
            sb.AppendLine("clip,path,property,type,isObjectReference,routeRelated,note");
            foreach (var row in rows)
            {
                sb.Append(Csv(row.clip)).Append(',');
                sb.Append(Csv(row.path)).Append(',');
                sb.Append(Csv(row.property)).Append(',');
                sb.Append(Csv(row.type)).Append(',');
                sb.Append(row.isObjectReference ? "true" : "false").Append(',');
                sb.Append(row.routeRelated ? "true" : "false").Append(',');
                sb.AppendLine(Csv(row.note));
            }
            File.WriteAllText(CsvPath, sb.ToString(), Encoding.UTF8);
        }

        private static void WriteJson(TraceResult result)
        {
            var sb = new StringBuilder();
            sb.AppendLine("{");
            JsonProp(sb, "generatedAt", result.generatedAt, true, 1);
            JsonProp(sb, "restoredClaim", result.restoredClaim ? "true" : "false", true, 1, false);
            JsonProp(sb, "mainBundlePath", result.mainBundlePath, true, 1);
            JsonProp(sb, "ext4BundlePath", result.ext4BundlePath, true, 1);
            sb.AppendLine("  \"conclusions\": [");
            for (var i = 0; i < result.conclusions.Count; i++)
            {
                sb.Append("    \"").Append(Json(result.conclusions[i])).Append("\"");
                sb.AppendLine(i + 1 == result.conclusions.Count ? "" : ",");
            }
            sb.AppendLine("  ],");
            sb.AppendLine("  \"controllerRows\": [");
            for (var i = 0; i < result.controllerRows.Count; i++)
            {
                var row = result.controllerRows[i];
                sb.Append("    {");
                sb.Append("\"controller\":\"").Append(Json(row.controller)).Append("\",");
                sb.Append("\"layer\":\"").Append(Json(row.layer)).Append("\",");
                sb.Append("\"defaultState\":\"").Append(Json(row.defaultState)).Append("\",");
                sb.Append("\"state\":\"").Append(Json(row.state)).Append("\",");
                sb.Append("\"motion\":\"").Append(Json(row.motion)).Append("\",");
                sb.Append("\"isDefaultState\":").Append(row.isDefaultState ? "true" : "false");
                sb.Append("}");
                sb.AppendLine(i + 1 == result.controllerRows.Count ? "" : ",");
            }
            sb.AppendLine("  ],");
            sb.AppendLine("  \"prefabRows\": [");
            for (var i = 0; i < result.prefabRows.Count; i++)
            {
                var row = result.prefabRows[i];
                sb.Append("    {");
                sb.Append("\"gameObject\":\"").Append(Json(row.gameObject)).Append("\",");
                sb.Append("\"activeSelf\":").Append(row.activeSelf ? "true" : "false").Append(',');
                sb.Append("\"hasAnimator\":").Append(row.hasAnimator ? "true" : "false").Append(',');
                sb.Append("\"animatorController\":\"").Append(Json(row.animatorController)).Append("\",");
                sb.Append("\"hasCanvas\":").Append(row.hasCanvas ? "true" : "false").Append(',');
                sb.Append("\"canvasOverrideSorting\":").Append(row.canvasOverrideSorting ? "true" : "false").Append(',');
                sb.Append("\"canvasSortingOrder\":").Append(row.canvasSortingOrder).Append(',');
                sb.Append("\"hasCanvasGroup\":").Append(row.hasCanvasGroup ? "true" : "false").Append(',');
                sb.Append("\"canvasGroupAlpha\":").Append(row.canvasGroupAlpha.ToString(System.Globalization.CultureInfo.InvariantCulture));
                sb.Append("}");
                sb.AppendLine(i + 1 == result.prefabRows.Count ? "" : ",");
            }
            sb.AppendLine("  ],");
            sb.AppendLine("  \"pathHashRows\": [");
            for (var i = 0; i < result.pathHashRows.Count; i++)
            {
                var row = result.pathHashRows[i];
                sb.Append("    {");
                sb.Append("\"path\":\"").Append(Json(row.path)).Append("\",");
                sb.Append("\"includesRoot\":").Append(row.includesRoot ? "true" : "false").Append(',');
                sb.Append("\"hashSigned\":").Append(row.hashSigned).Append(',');
                sb.Append("\"hashUnsigned\":").Append(row.hashUnsigned).Append(',');
                sb.Append("\"routeRelated\":").Append(row.routeRelated ? "true" : "false");
                sb.Append("}");
                sb.AppendLine(i + 1 == result.pathHashRows.Count ? "" : ",");
            }
            sb.AppendLine("  ],");
            sb.AppendLine("  \"bindingCount\": " + result.rows.Count + ",");
            sb.AppendLine("  \"routeRelatedBindingCount\": " + result.rows.Count(r => r.routeRelated));
            sb.AppendLine("}");
            File.WriteAllText(JsonPath, sb.ToString(), Encoding.UTF8);
        }

        private static void WriteMarkdown(TraceResult result)
        {
            var routeCount = result.rows.Count(r => r.routeRelated);
            var sb = new StringBuilder();
            sb.AppendLine("# MAININTERFACE_125_ANIMATOR_HOME_STATE_TRACE");
            sb.AppendLine();
            sb.AppendLine("- generatedAt: " + result.generatedAt);
            sb.AppendLine("- restoredClaim: false");
            sb.AppendLine("- source main bundle: `" + MainBundlePath + "`");
            sb.AppendLine("- source animator bundle: `" + Ext4BundlePath + "`");
            sb.AppendLine("- binding CSV: `" + CsvPath + "`");
            sb.AppendLine("- json: `" + JsonPath + "`");
            sb.AppendLine("- routeRelatedBindingCount: " + routeCount);
            sb.AppendLine();
            sb.AppendLine("## Conclusions");
            foreach (var conclusion in result.conclusions)
                sb.AppendLine("- " + conclusion);
            sb.AppendLine();
            sb.AppendLine("## Controller Evidence");
            foreach (var row in result.controllerRows)
            {
                if (!string.IsNullOrEmpty(row.defaultState))
                    sb.AppendLine("- controller `" + row.controller + "` layer `" + row.layer + "` defaultState `" + row.defaultState + "`");
                if (!string.IsNullOrEmpty(row.state))
                    sb.AppendLine("- state `" + row.state + "` motion `" + row.motion + "` default=" + row.isDefaultState);
            }
            sb.AppendLine();
            sb.AppendLine("## Prefab Evidence");
            foreach (var row in result.prefabRows)
            {
                sb.AppendLine("- `" + row.gameObject + "` activeSelf=" + row.activeSelf
                    + ", hasAnimator=" + row.hasAnimator
                    + ", animatorController=`" + row.animatorController + "`"
                    + ", Canvas.overrideSorting=" + row.canvasOverrideSorting
                    + ", Canvas.sortingOrder=" + row.canvasSortingOrder
                    + ", CanvasGroup.alpha=" + row.canvasGroupAlpha.ToString("0.###"));
            }
            sb.AppendLine();
            sb.AppendLine("## Route Binding Rows");
            if (routeCount == 0)
            {
                sb.AppendLine("- None found by Unity `AnimationUtility.GetCurveBindings` / `GetObjectReferenceCurveBindings`.");
            }
            else
            {
                foreach (var row in result.rows.Where(r => r.routeRelated))
                    sb.AppendLine("- `" + row.clip + "` path=`" + row.path + "` property=`" + row.property + "` type=`" + row.type + "`");
            }
            sb.AppendLine();
            sb.AppendLine("## Generic Binding Path Hash Resolution");
            if (result.pathHashRows.Count == 0)
            {
                sb.AppendLine("- No `Animator.StringToHash` matches found for UnityPy generic binding path hashes `283520407`, `2053629800`, `2138030896`, `2314173485`, `2853304615`, `3033167124`.");
            }
            else
            {
                foreach (var row in result.pathHashRows.OrderBy(r => r.path, StringComparer.Ordinal))
                    sb.AppendLine("- hashUnsigned=" + row.hashUnsigned + " path=`" + row.path + "` includesRoot=" + row.includesRoot + " routeRelated=" + row.routeRelated);
            }
            sb.AppendLine();
            sb.AppendLine("## Patch Decision");
            sb.AppendLine("- No active/sibling/canvas patch is applied by this trace tool.");
            sb.AppendLine("- Hiding `right`, `node_middle`, `wanfaWorldNode`, or `worldwanfaBtn` remains unsupported unless another authoritative Lua/prefab/DT/runtime source is found.");
            File.WriteAllText(MdPath, sb.ToString(), Encoding.UTF8);
        }

        private static string Csv(string value)
        {
            value = value ?? "";
            if (value.IndexOfAny(new[] { ',', '"', '\n', '\r' }) < 0)
                return value;
            return "\"" + value.Replace("\"", "\"\"") + "\"";
        }

        private static string Json(string value)
        {
            return (value ?? "").Replace("\\", "\\\\").Replace("\"", "\\\"").Replace("\r", "\\r").Replace("\n", "\\n");
        }

        private static void JsonProp(StringBuilder sb, string name, string value, bool comma, int indent, bool quote = true)
        {
            sb.Append(new string(' ', indent * 2));
            sb.Append("\"").Append(name).Append("\": ");
            if (quote)
                sb.Append("\"").Append(Json(value)).Append("\"");
            else
                sb.Append(value);
            if (comma)
                sb.Append(',');
            sb.AppendLine();
        }

        [Serializable]
        private sealed class TraceResult
        {
            public string generatedAt;
            public bool restoredClaim;
            public string mainBundlePath;
            public string ext4BundlePath;
            public List<string> conclusions;
            public List<ControllerRow> controllerRows;
            public List<PrefabRow> prefabRows;
            public List<PathHashRow> pathHashRows = new List<PathHashRow>();
            public List<BindingRow> rows;
        }

        [Serializable]
        private sealed class BindingRow
        {
            public string clip;
            public string path;
            public string property;
            public string type;
            public bool isObjectReference;
            public bool routeRelated;
            public string note;
        }

        [Serializable]
        private sealed class ControllerRow
        {
            public string controller;
            public string layer;
            public string defaultState;
            public string state;
            public string motion;
            public bool isDefaultState;
        }

        [Serializable]
        private sealed class PrefabRow
        {
            public string gameObject;
            public bool activeSelf;
            public bool hasAnimator;
            public string animatorController;
            public bool hasCanvas;
            public bool canvasOverrideSorting;
            public int canvasSortingOrder;
            public bool hasCanvasGroup;
            public float canvasGroupAlpha;
        }

        [Serializable]
        private sealed class PathHashRow
        {
            public string path;
            public bool includesRoot;
            public int hashSigned;
            public uint hashUnsigned;
            public bool routeRelated;
        }
    }
}
