using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

namespace GirlsWarRestore
{
    public static class MainInterface117RouteSkeletonGraphicLayoutValidation
    {
        private const string ReplayScenePath = "Assets/Scenes/MainInterface_RouteSpineRuntimeReplay.unity";
        private const string ValidatedScenePath = "Assets/Scenes/MainInterface_RouteSpineRuntimeReplay_Validated.unity";
        private const string ResultJson = "Assets/RestoreData/maininterface_117_route_skeletongraphic_layout_validation.json";
        private const string ResultCsv = "Assets/RestoreData/reports/maininterface_117_route_skeletongraphic_layout_validation.csv";
        private const string CapturePath = "Assets/RestoreCaptures/maininterface_route_spine_runtime_bridge_validated_1680x720.png";
        private const float ReferenceWidth = 1680f;
        private const float ReferenceHeight = 720f;

        private static readonly TargetSpec[] Targets =
        {
            new TargetSpec("Spine_shijieanniu", "spine_diqiu", "-1766545527926586392", "0,-1", "100,100", "1,1,1", 0, "A"),
            new TargetSpec("8007", "spine_xiaoren", "3375689855543054311", "-77.9,-15.4", "100,100", "0.5,0.5,0.5", 1, "run")
        };

        private static readonly string[] InterimFallbackNames =
        {
            "route_fallback_zhuye_di1",
            "route_fallback_diqiu",
            "route_fallback_zhuye_bian"
        };

        [MenuItem("GirlsWar/UI117 Validate Route SkeletonGraphic Layout Against Original Evidence")]
        public static void ValidateAndCapture()
        {
            Directory.CreateDirectory("Assets/RestoreData/reports");
            Directory.CreateDirectory("Assets/RestoreCaptures");

            var result = new ValidationResult
            {
                generatedAt = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture),
                status = "started",
                visualVerdict = "not_normal_trace_started",
                scenePath = ValidatedScenePath,
                capturePath = CapturePath,
                targetRows = new List<TargetRow>(),
                fallbackRows = new List<FallbackRow>(),
                tmpRows = new List<TmpRow>(),
                notes = new List<string>()
            };

            try
            {
                if (!File.Exists(ReplayScenePath))
                {
                    result.notes.Add("UI116 replay scene was missing, so UI116 BuildAndCapture was invoked before UI117 validation.");
                    MainInterface116RouteSpineRuntimeBridgeReplay.BuildAndCapture();
                }

                EditorSceneManager.OpenScene(ReplayScenePath, OpenSceneMode.Single);
                ValidateSkeletonTargets(result);
                ValidateRouteTmpLabels(result);

                var allTargetsUsable = result.targetRows.Count == Targets.Length
                    && result.targetRows.All(r => r.sceneNodeFound && r.skeletonGraphicFound && r.rectMatchesOriginalEvidence && r.animationMatchesEvidence);

                TraceAndMaybeSuppressInterimFallbacks(result, allTargetsUsable);

                result.skeletonTargetsFound = result.targetRows.Count(r => r.sceneNodeFound);
                result.skeletonGraphicAttached = result.targetRows.Count(r => r.skeletonGraphicFound);
                result.skeletonGraphicRectEvidenceMatched = result.targetRows.Count(r => r.rectMatchesOriginalEvidence);
                result.skeletonGraphicAnimationEvidenceMatched = result.targetRows.Count(r => r.animationMatchesEvidence);
                result.tmpRouteRows = result.tmpRows.Count;
                result.tmpRouteVariantOk = result.tmpRows.Count(r => r.fontMaterialVariantOk);
                result.interimFallbackRows = result.fallbackRows.Count;
                result.interimFallbackSuppressed = result.fallbackRows.Count(r => r.suppressed);
                result.visualFixApplied = result.interimFallbackSuppressed;

                EditorSceneManager.SaveScene(SceneManager.GetActiveScene(), ValidatedScenePath);
                CaptureScene(ValidatedScenePath, CapturePath, result);

                result.status = "maininterface_117_route_skeletongraphic_layout_validation_complete";
                result.visualVerdict = result.visualFixApplied > 0
                    ? "not_normal_partial_candidate_interim_fallback_suppressed_requires_visual_review"
                    : "not_normal_trace_only_no_scene_visual_patch";
                result.nextBlocker = "route SkeletonGraphic UI material/shader pass binding validation against original SkeletonGraphic runtime fields";
            }
            catch (Exception ex)
            {
                result.status = "maininterface_117_route_skeletongraphic_layout_validation_failed";
                result.visualVerdict = "not_normal_probe_failed";
                result.nextBlocker = ex.GetType().Name + ": " + ex.Message;
                Debug.LogException(ex);
                WriteOutputs(result);
                throw;
            }

            WriteOutputs(result);
            Debug.Log("[GirlsWarRestore] UI117 route SkeletonGraphic layout validation complete: " + ResultJson);
        }

        private static void ValidateSkeletonTargets(ValidationResult result)
        {
            var skeletonGraphicType = FindType("Spine.Unity.SkeletonGraphic");
            foreach (var target in Targets)
            {
                var row = new TargetRow
                {
                    skeletonKey = target.skeletonKey,
                    nodeName = target.nodeName,
                    expectedAnimation = target.animation,
                    expectedAnchoredPosition = target.anchoredPosition,
                    expectedSizeDelta = target.sizeDelta,
                    expectedLocalScale = target.localScale,
                    expectedSiblingIndex = target.siblingIndex
                };
                result.targetRows.Add(row);

                var rt = FindNode(target.nodeName, target.rectPathId);
                row.sceneNodeFound = rt != null;
                if (rt == null)
                {
                    row.decision = "blocked_original_scene_node_missing";
                    row.reason = "Original node pathID/name could not be found in UI116 replay scene.";
                    continue;
                }

                row.sceneObjectPath = TransformPath(rt);
                row.parentPath = rt.parent != null ? TransformPath(rt.parent) : "";
                row.activeInHierarchy = rt.gameObject.activeInHierarchy;
                row.siblingIndex = rt.GetSiblingIndex();
                row.anchoredPosition = Format(rt.anchoredPosition);
                row.sizeDelta = Format(rt.sizeDelta);
                row.localScale = Format(rt.localScale);
                row.pivot = Format(rt.pivot);
                row.anchorMin = Format(rt.anchorMin);
                row.anchorMax = Format(rt.anchorMax);
                row.rectMatchesOriginalEvidence =
                    Close(row.anchoredPosition, target.anchoredPosition)
                    && Close(row.sizeDelta, target.sizeDelta)
                    && Close(row.localScale, target.localScale)
                    && row.siblingIndex == target.siblingIndex;

                var component = skeletonGraphicType == null
                    ? null
                    : rt.GetComponents<Component>().FirstOrDefault(c => c != null && skeletonGraphicType.IsInstanceOfType(c));
                row.skeletonGraphicFound = component != null;
                if (component != null)
                {
                    row.startingAnimation = Convert.ToString(GetMember(component, "startingAnimation"), CultureInfo.InvariantCulture);
                    row.startingLoop = Convert.ToString(GetMember(component, "startingLoop"), CultureInfo.InvariantCulture);
                    row.animationMatchesEvidence = string.Equals(row.startingAnimation, target.animation, StringComparison.Ordinal);
                    var graphic = component as Graphic;
                    if (graphic != null)
                    {
                        row.raycastTarget = graphic.raycastTarget;
                        row.color = ColorString(graphic.color);
                        var material = graphic.material;
                        if (material != null)
                        {
                            row.materialName = material.name;
                            row.shaderName = material.shader != null ? material.shader.name : "";
                            var texture = material.mainTexture;
                            if (texture != null)
                                row.mainTexture = texture.name + " " + texture.width + "x" + texture.height;
                        }
                    }
                }

                if (!row.skeletonGraphicFound)
                {
                    row.decision = "blocked_skeletongraphic_component_missing";
                    row.reason = "UI116 did not leave a SkeletonGraphic component on the original node.";
                }
                else if (!row.rectMatchesOriginalEvidence)
                {
                    row.decision = "blocked_rect_or_sibling_mismatch";
                    row.reason = "SkeletonGraphic exists, but RectTransform/sibling evidence does not match the original rows.";
                }
                else if (!row.animationMatchesEvidence)
                {
                    row.decision = "blocked_starting_animation_mismatch";
                    row.reason = "SkeletonGraphic exists, but startingAnimation is not the original animation.";
                }
                else
                {
                    row.decision = "evidence_matched_runtime_replay_candidate";
                    row.reason = "SkeletonGraphic is attached on the original node with original RectTransform/sibling and animation evidence.";
                }
            }
        }

        private static void ValidateRouteTmpLabels(ValidationResult result)
        {
            foreach (var component in FindTmpComponents())
            {
                var text = Convert.ToString(GetMember(component, "text"), CultureInfo.InvariantCulture);
                if (text != "모험" && text != "전" && text != "국")
                    continue;

                var rt = (component as Component)?.GetComponent<RectTransform>();
                if (rt == null)
                    continue;

                var font = GetMember(component, "font");
                var material = GetMember(component, "fontSharedMaterial") ?? GetMember(component, "fontMaterial");
                var row = new TmpRow
                {
                    text = text,
                    sceneObjectPath = TransformPath(rt),
                    sizeDelta = Format(rt.sizeDelta),
                    anchoredPosition = Format(rt.anchoredPosition),
                    localScale = Format(rt.localScale),
                    fontAsset = font != null ? font.ToString() : "",
                    material = material != null ? material.ToString() : ""
                };
                row.fontMaterialVariantOk =
                    row.fontAsset.IndexOf("riyu_shenzong_0_2_0_2", StringComparison.OrdinalIgnoreCase) >= 0
                    && row.material.IndexOf("riyu_shenzong_0_2_0_2", StringComparison.OrdinalIgnoreCase) >= 0;
                row.decision = row.fontMaterialVariantOk ? "tmp_variant_material_matches_ui110_evidence" : "tmp_variant_material_mismatch_or_unknown";
                result.tmpRows.Add(row);
            }
        }

        private static void TraceAndMaybeSuppressInterimFallbacks(ValidationResult result, bool allTargetsUsable)
        {
            var fallbackObjects = UnityEngine.Object.FindObjectsByType<RectTransform>(FindObjectsInactive.Include, FindObjectsSortMode.None)
                .Where(rt => rt != null && InterimFallbackNames.Contains(rt.name))
                .OrderBy(rt => rt.name, StringComparer.Ordinal)
                .ToList();

            foreach (var rt in fallbackObjects)
            {
                var row = new FallbackRow
                {
                    name = rt.name,
                    sceneObjectPath = TransformPath(rt),
                    parentPath = rt.parent != null ? TransformPath(rt.parent) : "",
                    wasActiveSelf = rt.gameObject.activeSelf,
                    activeInHierarchyBefore = rt.gameObject.activeInHierarchy,
                    siblingIndex = rt.GetSiblingIndex(),
                    anchoredPosition = Format(rt.anchoredPosition),
                    sizeDelta = Format(rt.sizeDelta),
                    localScale = Format(rt.localScale)
                };
                result.fallbackRows.Add(row);

                var parentIsWorldButton = row.parentPath.IndexOf("worldwanfaBtn__", StringComparison.Ordinal) >= 0;
                if (allTargetsUsable && parentIsWorldButton)
                {
                    rt.gameObject.SetActive(false);
                    row.suppressed = true;
                    row.decision = "suppressed_interim_bitmap_fallback_after_real_skeletongraphic_evidence";
                    row.reason = "UI112 fallback reason explicitly limited these bitmap layers to the period before Spine runtime transforms were restored; UI116/117 proves real SkeletonGraphic exists on original nodes.";
                }
                else
                {
                    row.suppressed = false;
                    row.decision = "kept_trace_only";
                    row.reason = allTargetsUsable
                        ? "Fallback was not under worldwanfaBtn, so it was not touched."
                        : "Real SkeletonGraphic evidence was incomplete, so suppressing fallback would be an unsupported visual change.";
                }
                row.activeInHierarchyAfter = rt.gameObject.activeInHierarchy;
            }
        }

        private static IEnumerable<Component> FindTmpComponents()
        {
            return UnityEngine.Object.FindObjectsByType<Component>(FindObjectsInactive.Include, FindObjectsSortMode.None)
                .Where(c => c != null && c.GetType().FullName == "TMPro.TextMeshProUGUI");
        }

        private static void CaptureScene(string scenePath, string capturePath, ValidationResult result)
        {
            EditorSceneManager.OpenScene(scenePath, OpenSceneMode.Single);
            var canvas = UnityEngine.Object.FindFirstObjectByType<Canvas>();
            if (canvas == null)
                throw new Exception("Capture failed: Canvas not found in " + scenePath);

            var cameraGo = new GameObject("UI117_RouteSpineLayoutCaptureCamera", typeof(Camera));
            var camera = cameraGo.GetComponent<Camera>();
            camera.clearFlags = CameraClearFlags.SolidColor;
            camera.backgroundColor = new Color(0f, 0f, 0f, 0f);
            camera.orthographic = true;
            camera.orthographicSize = ReferenceHeight * 0.5f;
            camera.nearClipPlane = 0.01f;
            camera.farClipPlane = 1000f;
            camera.transform.position = new Vector3(0f, 0f, -100f);
            camera.transform.rotation = Quaternion.identity;

            var canvasRect = canvas.GetComponent<RectTransform>();
            canvasRect.anchorMin = new Vector2(0.5f, 0.5f);
            canvasRect.anchorMax = new Vector2(0.5f, 0.5f);
            canvasRect.pivot = new Vector2(0.5f, 0.5f);
            canvasRect.anchoredPosition = Vector2.zero;
            canvasRect.sizeDelta = new Vector2(ReferenceWidth, ReferenceHeight);
            canvas.transform.position = Vector3.zero;
            canvas.transform.localRotation = Quaternion.identity;
            canvas.transform.localScale = Vector3.one;

            var scaler = canvas.GetComponent<CanvasScaler>();
            if (scaler != null)
            {
                scaler.uiScaleMode = CanvasScaler.ScaleMode.ConstantPixelSize;
                scaler.scaleFactor = 1f;
                scaler.referencePixelsPerUnit = 100f;
            }

            canvas.renderMode = RenderMode.WorldSpace;
            canvas.worldCamera = camera;
            canvas.planeDistance = 0f;

            Canvas.ForceUpdateCanvases();
            foreach (var graphic in UnityEngine.Object.FindObjectsByType<Graphic>(FindObjectsInactive.Include, FindObjectsSortMode.None))
            {
                if (graphic != null)
                    graphic.SetVerticesDirty();
            }
            Canvas.ForceUpdateCanvases();

            var renderTexture = new RenderTexture((int)ReferenceWidth, (int)ReferenceHeight, 24, RenderTextureFormat.ARGB32);
            var previous = RenderTexture.active;
            camera.targetTexture = renderTexture;
            RenderTexture.active = renderTexture;
            GL.Clear(true, true, new Color(0f, 0f, 0f, 0f));
            camera.Render();

            var texture = new Texture2D((int)ReferenceWidth, (int)ReferenceHeight, TextureFormat.RGBA32, false);
            texture.ReadPixels(new Rect(0, 0, ReferenceWidth, ReferenceHeight), 0, 0);
            texture.Apply();
            Directory.CreateDirectory(Path.GetDirectoryName(capturePath));
            File.WriteAllBytes(capturePath, texture.EncodeToPNG());

            var visiblePixels = 0;
            var magentaPixels = 0;
            foreach (var pixel in texture.GetPixels32())
            {
                if (pixel.a > 0 && (pixel.r > 0 || pixel.g > 0 || pixel.b > 0))
                    visiblePixels++;
                if (pixel.r > 180 && pixel.b > 180 && pixel.g < 90)
                    magentaPixels++;
            }

            result.captureExists = File.Exists(capturePath);
            result.captureSize = result.captureExists ? new FileInfo(capturePath).Length : 0;
            result.visiblePixelCount = visiblePixels;
            result.magentaPixelCount = magentaPixels;

            RenderTexture.active = previous;
            camera.targetTexture = null;
            UnityEngine.Object.DestroyImmediate(renderTexture);
            UnityEngine.Object.DestroyImmediate(texture);
            UnityEngine.Object.DestroyImmediate(cameraGo);
            AssetDatabase.Refresh(ImportAssetOptions.ForceSynchronousImport);
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

        private static Type FindType(string fullName)
        {
            foreach (var assembly in AppDomain.CurrentDomain.GetAssemblies())
            {
                Type type = null;
                try { type = assembly.GetType(fullName, false); }
                catch { }
                if (type != null)
                    return type;
            }
            return null;
        }

        private static object GetMember(object target, string name)
        {
            if (target == null)
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

        private static bool Close(string actual, string expected)
        {
            var a = actual.Split(',');
            var e = expected.Split(',');
            if (a.Length != e.Length)
                return false;
            for (var i = 0; i < a.Length; i++)
            {
                if (!float.TryParse(a[i], NumberStyles.Float, CultureInfo.InvariantCulture, out var av))
                    return false;
                if (!float.TryParse(e[i], NumberStyles.Float, CultureInfo.InvariantCulture, out var ev))
                    return false;
                if (Mathf.Abs(av - ev) > 0.05f)
                    return false;
            }
            return true;
        }

        private static string Format(Vector2 value)
        {
            return value.x.ToString("0.####", CultureInfo.InvariantCulture) + "," + value.y.ToString("0.####", CultureInfo.InvariantCulture);
        }

        private static string Format(Vector3 value)
        {
            return value.x.ToString("0.####", CultureInfo.InvariantCulture) + "," + value.y.ToString("0.####", CultureInfo.InvariantCulture) + "," + value.z.ToString("0.####", CultureInfo.InvariantCulture);
        }

        private static string ColorString(Color color)
        {
            return color.r.ToString("0.####", CultureInfo.InvariantCulture) + ","
                + color.g.ToString("0.####", CultureInfo.InvariantCulture) + ","
                + color.b.ToString("0.####", CultureInfo.InvariantCulture) + ","
                + color.a.ToString("0.####", CultureInfo.InvariantCulture);
        }

        private static void WriteOutputs(ValidationResult result)
        {
            File.WriteAllText(ResultJson, JsonUtility.ToJson(result, true), Encoding.UTF8);
            var sb = new StringBuilder();
            sb.AppendLine("kind,name,path,parent,decision,reason,expected,actual,material,shader,texture,active,sibling");
            foreach (var row in result.targetRows)
            {
                sb.AppendLine(string.Join(",", new[]
                {
                    Csv("SkeletonGraphic"),
                    Csv(row.nodeName),
                    Csv(row.sceneObjectPath),
                    Csv(row.parentPath),
                    Csv(row.decision),
                    Csv(row.reason),
                    Csv(row.expectedAnchoredPosition + "|" + row.expectedSizeDelta + "|" + row.expectedLocalScale + "|sibling=" + row.expectedSiblingIndex + "|animation=" + row.expectedAnimation),
                    Csv(row.anchoredPosition + "|" + row.sizeDelta + "|" + row.localScale + "|sibling=" + row.siblingIndex + "|animation=" + row.startingAnimation),
                    Csv(row.materialName),
                    Csv(row.shaderName),
                    Csv(row.mainTexture),
                    Csv(row.activeInHierarchy.ToString()),
                    Csv(row.siblingIndex.ToString(CultureInfo.InvariantCulture))
                }));
            }
            foreach (var row in result.fallbackRows)
            {
                sb.AppendLine(string.Join(",", new[]
                {
                    Csv("InterimFallback"),
                    Csv(row.name),
                    Csv(row.sceneObjectPath),
                    Csv(row.parentPath),
                    Csv(row.decision),
                    Csv(row.reason),
                    Csv("original contains SkeletonGraphic node, fallback was synthetic interim layer"),
                    Csv(row.anchoredPosition + "|" + row.sizeDelta + "|" + row.localScale),
                    Csv(""),
                    Csv(""),
                    Csv(""),
                    Csv(row.activeInHierarchyAfter.ToString()),
                    Csv(row.siblingIndex.ToString(CultureInfo.InvariantCulture))
                }));
            }
            foreach (var row in result.tmpRows)
            {
                sb.AppendLine(string.Join(",", new[]
                {
                    Csv("TMPRouteLabel"),
                    Csv(row.text),
                    Csv(row.sceneObjectPath),
                    Csv(""),
                    Csv(row.decision),
                    Csv(row.fontMaterialVariantOk ? "UI110 route TMP variant evidence matches" : "Font/material variant mismatch or unknown"),
                    Csv("riyu_shenzong_0_2_0_2 font/material"),
                    Csv(row.fontAsset + "|" + row.material + "|" + row.sizeDelta),
                    Csv(row.material),
                    Csv(""),
                    Csv(""),
                    Csv(""),
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

        private sealed class TargetSpec
        {
            public readonly string skeletonKey;
            public readonly string nodeName;
            public readonly string rectPathId;
            public readonly string anchoredPosition;
            public readonly string sizeDelta;
            public readonly string localScale;
            public readonly int siblingIndex;
            public readonly string animation;

            public TargetSpec(string skeletonKey, string nodeName, string rectPathId, string anchoredPosition, string sizeDelta, string localScale, int siblingIndex, string animation)
            {
                this.skeletonKey = skeletonKey;
                this.nodeName = nodeName;
                this.rectPathId = rectPathId;
                this.anchoredPosition = anchoredPosition;
                this.sizeDelta = sizeDelta;
                this.localScale = localScale;
                this.siblingIndex = siblingIndex;
                this.animation = animation;
            }
        }

        [Serializable]
        private sealed class ValidationResult
        {
            public string generatedAt;
            public string status;
            public string visualVerdict;
            public string scenePath;
            public string capturePath;
            public bool captureExists;
            public long captureSize;
            public int visiblePixelCount;
            public int magentaPixelCount;
            public int visualFixApplied;
            public int skeletonTargetsFound;
            public int skeletonGraphicAttached;
            public int skeletonGraphicRectEvidenceMatched;
            public int skeletonGraphicAnimationEvidenceMatched;
            public int tmpRouteRows;
            public int tmpRouteVariantOk;
            public int interimFallbackRows;
            public int interimFallbackSuppressed;
            public string nextBlocker;
            public List<TargetRow> targetRows;
            public List<FallbackRow> fallbackRows;
            public List<TmpRow> tmpRows;
            public List<string> notes;
        }

        [Serializable]
        private sealed class TargetRow
        {
            public string skeletonKey;
            public string nodeName;
            public string sceneObjectPath;
            public string parentPath;
            public bool sceneNodeFound;
            public bool activeInHierarchy;
            public int siblingIndex;
            public string anchoredPosition;
            public string sizeDelta;
            public string localScale;
            public string pivot;
            public string anchorMin;
            public string anchorMax;
            public string expectedAnchoredPosition;
            public string expectedSizeDelta;
            public string expectedLocalScale;
            public int expectedSiblingIndex;
            public string expectedAnimation;
            public bool rectMatchesOriginalEvidence;
            public bool skeletonGraphicFound;
            public bool animationMatchesEvidence;
            public string startingAnimation;
            public string startingLoop;
            public bool raycastTarget;
            public string color;
            public string materialName;
            public string shaderName;
            public string mainTexture;
            public string decision;
            public string reason;
        }

        [Serializable]
        private sealed class FallbackRow
        {
            public string name;
            public string sceneObjectPath;
            public string parentPath;
            public bool wasActiveSelf;
            public bool activeInHierarchyBefore;
            public bool activeInHierarchyAfter;
            public int siblingIndex;
            public string anchoredPosition;
            public string sizeDelta;
            public string localScale;
            public bool suppressed;
            public string decision;
            public string reason;
        }

        [Serializable]
        private sealed class TmpRow
        {
            public string text;
            public string sceneObjectPath;
            public string anchoredPosition;
            public string sizeDelta;
            public string localScale;
            public string fontAsset;
            public string material;
            public bool fontMaterialVariantOk;
            public string decision;
        }
    }
}
