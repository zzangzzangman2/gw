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
using UnityEngine.UI;
using UnityEngine.SceneManagement;

namespace GirlsWarRestore
{
    public static class MainInterface116RouteSpineRuntimeBridgeReplay
    {
        private const string SourceScenePath = "Assets/Scenes/MainInterface_Wireframe.unity";
        private const string ReplayScenePath = "Assets/Scenes/MainInterface_RouteSpineRuntimeReplay.unity";
        private const string ResultJson = "Assets/RestoreData/maininterface_116_spine_runtime_bridge_unity_probe.json";
        private const string ResultCsv = "Assets/RestoreData/reports/maininterface_116_spine_runtime_bridge_unity_probe.csv";
        private const string CapturePath = "Assets/RestoreCaptures/maininterface_route_spine_runtime_bridge_1680x720.png";
        private const float ReferenceWidth = 1680f;
        private const float ReferenceHeight = 720f;

        private static readonly TargetSpec[] Targets =
        {
            new TargetSpec(
                "Spine_shijieanniu",
                "spine_diqiu",
                "-1766545527926586392",
                "Assets/RestoreData/route_spine_raw_decode_recovery/Spine_shijieanniu/Spine_shijieanniu_SkeletonData.asset",
                "Assets/RestoreData/route_spine_raw_decode_recovery/Spine_shijieanniu/Spine_shijieanniu_Material.mat",
                "A",
                true
            ),
            new TargetSpec(
                "8007",
                "spine_xiaoren",
                "3375689855543054311",
                "Assets/RestoreData/route_spine_raw_decode_recovery/8007/8007_SkeletonData.asset",
                "Assets/RestoreData/route_spine_raw_decode_recovery/8007/8007_Material.mat",
                "run",
                true
            )
        };

        [MenuItem("GirlsWar/UI116 Build Route Spine Runtime Bridge Replay")]
        public static void BuildAndCapture()
        {
            Directory.CreateDirectory("Assets/RestoreData/reports");
            Directory.CreateDirectory("Assets/RestoreCaptures");
            var result = new ReplayResult
            {
                generatedAt = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
                status = "started",
                sceneGenerated = false,
                visualFixApplied = 0,
                rows = new List<ReplayRow>()
            };

            try
            {
                MainInterfaceSceneBuilder.BuildMainInterfaceScene();
                EditorSceneManager.OpenScene(SourceScenePath, OpenSceneMode.Single);

                var skeletonGraphicType = FindType("Spine.Unity.SkeletonGraphic");
                var skeletonDataAssetType = FindType("Spine.Unity.SkeletonDataAsset");
                var atlasAssetType = FindType("Spine.Unity.AtlasAsset") ?? FindType("Spine.Unity.SpineAtlasAsset");
                var skeletonBinaryType = FindType("Spine.SkeletonBinary");
                var meshGeneratorType = FindType("Spine.Unity.MeshGenerator");

                result.skeletonGraphicTypeAvailable = skeletonGraphicType != null;
                result.skeletonDataAssetTypeAvailable = skeletonDataAssetType != null;
                result.atlasAssetTypeAvailable = atlasAssetType != null;
                result.skeletonBinaryTypeAvailable = skeletonBinaryType != null;
                result.meshGeneratorTypeAvailable = meshGeneratorType != null;
                result.mainProjectSpineRuntimeAvailable =
                    result.skeletonGraphicTypeAvailable
                    && result.skeletonDataAssetTypeAvailable
                    && result.atlasAssetTypeAvailable
                    && result.skeletonBinaryTypeAvailable;

                foreach (var target in Targets)
                    AttachTarget(target, skeletonGraphicType, skeletonDataAssetType, result);

                result.visualFixApplied = result.rows.Count(r => r.componentAttached && r.initialized);
                result.sceneGenerated = result.visualFixApplied > 0;
                if (result.sceneGenerated)
                {
                    EditorSceneManager.SaveScene(SceneManager.GetActiveScene(), ReplayScenePath);
                    CaptureScene(ReplayScenePath, CapturePath, result);
                }
                result.status = "maininterface_116_spine_runtime_bridge_probe_complete";
                result.visualVerdict = result.visualFixApplied > 0
                    ? "partial_runtime_replay_capture_generated_manual_review_required"
                    : "not_normal_trace_only_no_visual_fix";
                result.blocker = result.visualFixApplied > 0
                    ? "Replay scene was generated, but the route cluster still requires visual/layout validation against original evidence."
                    : "Real Spine runtime or stable route SkeletonDataAsset references were not sufficient to attach SkeletonGraphic replay.";
            }
            catch (Exception ex)
            {
                result.status = "maininterface_116_spine_runtime_bridge_probe_failed";
                result.visualVerdict = "not_normal_probe_failed";
                result.blocker = ex.GetType().Name + ": " + ex.Message;
                Debug.LogException(ex);
                WriteOutputs(result);
                throw;
            }

            WriteOutputs(result);
            Debug.Log("[GirlsWarRestore] UI116 route Spine runtime bridge probe complete: " + ResultJson);
        }

        private static void AttachTarget(TargetSpec target, Type skeletonGraphicType, Type skeletonDataAssetType, ReplayResult result)
        {
            var row = new ReplayRow
            {
                target = target.key,
                node = target.nodeName,
                animation = target.animation,
                loop = target.loop,
                skeletonDataAssetPath = target.skeletonDataAssetPath,
                materialPath = target.materialPath,
                skeletonGraphicTypeAvailable = skeletonGraphicType != null,
                decision = "started"
            };
            result.rows.Add(row);

            var node = FindNode(target.nodeName, target.rectPathId);
            row.sceneNodeFound = node != null;
            if (node != null)
            {
                row.sceneObjectPath = TransformPath(node);
                row.parentPath = node.parent != null ? TransformPath(node.parent) : "";
                row.siblingIndex = node.GetSiblingIndex();
                row.anchoredPosition = Format(node.anchoredPosition);
                row.sizeDelta = Format(node.sizeDelta);
                row.localScale = Format(node.localScale);
                row.activeInHierarchy = node.gameObject.activeInHierarchy;
            }

            if (skeletonGraphicType == null || skeletonDataAssetType == null)
            {
                row.decision = "blocked_spine_runtime_type_missing";
                row.detail = "Spine.Unity.SkeletonGraphic or SkeletonDataAsset type is missing.";
                return;
            }
            if (node == null)
            {
                row.decision = "blocked_original_node_missing";
                row.detail = "Original route Spine node was not found in generated MainInterface scene.";
                return;
            }

            var skeletonDataAsset = AssetDatabase.LoadAssetAtPath<UnityEngine.Object>(target.skeletonDataAssetPath);
            row.skeletonDataAssetLoaded = skeletonDataAsset != null && skeletonDataAssetType.IsInstanceOfType(skeletonDataAsset);
            if (!row.skeletonDataAssetLoaded)
            {
                row.decision = "blocked_skeletondataasset_not_loaded";
                row.detail = "Stable SkeletonDataAsset was not loaded from " + target.skeletonDataAssetPath;
                return;
            }

            var material = AssetDatabase.LoadAssetAtPath<Material>(target.materialPath);
            row.materialLoaded = material != null;

            var existing = node.GetComponents<Component>().FirstOrDefault(c => c != null && skeletonGraphicType.IsInstanceOfType(c));
            var component = existing ?? node.gameObject.AddComponent(skeletonGraphicType);
            row.componentAttached = component != null;
            if (component == null)
            {
                row.decision = "blocked_add_skeletongraphic_failed";
                row.detail = "AddComponent returned null.";
                return;
            }

            SetField(component, "skeletonDataAsset", skeletonDataAsset);
            SetField(component, "startingAnimation", target.animation);
            SetField(component, "startingLoop", target.loop);
            SetField(component, "timeScale", 1f);

            var graphic = component as Graphic;
            if (graphic != null)
            {
                if (material != null)
                    graphic.material = material;
                graphic.raycastTarget = false;
                graphic.color = Color.white;
            }

            try
            {
                Invoke(component, "Initialize", true);
                Invoke(component, "Update", 0f);
                Invoke(component, "SetVerticesDirty");
                Invoke(component, "SetMaterialDirty");
                row.initialized = true;
                row.decision = "applied_runtime_skeletongraphic_replay_candidate";
                row.detail = "SkeletonGraphic attached to original node with project SkeletonDataAsset and original starting animation.";
            }
            catch (Exception ex)
            {
                row.initialized = false;
                row.decision = "blocked_initialize_exception";
                row.detail = ex.GetType().Name + ": " + ex.Message;
            }
        }

        private static void CaptureScene(string scenePath, string capturePath, ReplayResult result)
        {
            EditorSceneManager.OpenScene(scenePath, OpenSceneMode.Single);
            var canvas = UnityEngine.Object.FindFirstObjectByType<Canvas>();
            if (canvas == null)
                throw new Exception("Capture failed: Canvas not found in " + scenePath);

            var cameraGo = new GameObject("UI116_RouteSpineReplayCaptureCamera", typeof(Camera));
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

            result.capturePath = capturePath;
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
            foreach (var rt in all)
            {
                if (rt != null && rt.name.StartsWith(nodeName + "__", StringComparison.Ordinal))
                    return rt;
            }
            return null;
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

        private static void SetField(object target, string name, object value)
        {
            var field = target.GetType().GetField(name, BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance);
            if (field != null)
                field.SetValue(target, value);
        }

        private static object Invoke(object target, string name, params object[] args)
        {
            var methods = target.GetType().GetMethods(BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance)
                .Where(m => m.Name == name && m.GetParameters().Length == args.Length);
            foreach (var method in methods)
            {
                try { return method.Invoke(target, args); }
                catch (TargetInvocationException ex)
                {
                    if (ex.InnerException != null)
                        throw ex.InnerException;
                    throw;
                }
                catch (ArgumentException) { }
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

        private static string Format(Vector2 value)
        {
            return value.x.ToString("0.####", CultureInfo.InvariantCulture) + "," + value.y.ToString("0.####", CultureInfo.InvariantCulture);
        }

        private static string Format(Vector3 value)
        {
            return value.x.ToString("0.####", CultureInfo.InvariantCulture) + "," + value.y.ToString("0.####", CultureInfo.InvariantCulture) + "," + value.z.ToString("0.####", CultureInfo.InvariantCulture);
        }

        private static void WriteOutputs(ReplayResult result)
        {
            File.WriteAllText(ResultJson, JsonUtility.ToJson(result, true), Encoding.UTF8);
            var sb = new StringBuilder();
            sb.AppendLine("target,node,sceneNodeFound,skeletonDataAssetLoaded,skeletonGraphicTypeAvailable,componentAttached,initialized,animation,loop,sceneObjectPath,decision,detail");
            foreach (var row in result.rows)
            {
                sb.Append(Csv(row.target)).Append(',');
                sb.Append(Csv(row.node)).Append(',');
                sb.Append(row.sceneNodeFound).Append(',');
                sb.Append(row.skeletonDataAssetLoaded).Append(',');
                sb.Append(row.skeletonGraphicTypeAvailable).Append(',');
                sb.Append(row.componentAttached).Append(',');
                sb.Append(row.initialized).Append(',');
                sb.Append(Csv(row.animation)).Append(',');
                sb.Append(row.loop).Append(',');
                sb.Append(Csv(row.sceneObjectPath)).Append(',');
                sb.Append(Csv(row.decision)).Append(',');
                sb.Append(Csv(row.detail)).AppendLine();
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
            public readonly string key;
            public readonly string nodeName;
            public readonly string rectPathId;
            public readonly string skeletonDataAssetPath;
            public readonly string materialPath;
            public readonly string animation;
            public readonly bool loop;

            public TargetSpec(string key, string nodeName, string rectPathId, string skeletonDataAssetPath, string materialPath, string animation, bool loop)
            {
                this.key = key;
                this.nodeName = nodeName;
                this.rectPathId = rectPathId;
                this.skeletonDataAssetPath = skeletonDataAssetPath;
                this.materialPath = materialPath;
                this.animation = animation;
                this.loop = loop;
            }
        }

        [Serializable]
        private sealed class ReplayResult
        {
            public string generatedAt;
            public string status;
            public string visualVerdict;
            public bool skeletonGraphicTypeAvailable;
            public bool skeletonDataAssetTypeAvailable;
            public bool atlasAssetTypeAvailable;
            public bool skeletonBinaryTypeAvailable;
            public bool meshGeneratorTypeAvailable;
            public bool mainProjectSpineRuntimeAvailable;
            public int visualFixApplied;
            public bool sceneGenerated;
            public string capturePath;
            public bool captureExists;
            public long captureSize;
            public int visiblePixelCount;
            public int magentaPixelCount;
            public string blocker;
            public List<ReplayRow> rows;
        }

        [Serializable]
        private sealed class ReplayRow
        {
            public string target;
            public string node;
            public string animation;
            public bool loop;
            public string skeletonDataAssetPath;
            public string materialPath;
            public bool skeletonGraphicTypeAvailable;
            public bool sceneNodeFound;
            public string sceneObjectPath;
            public string parentPath;
            public int siblingIndex;
            public string anchoredPosition;
            public string sizeDelta;
            public string localScale;
            public bool activeInHierarchy;
            public bool skeletonDataAssetLoaded;
            public bool materialLoaded;
            public bool componentAttached;
            public bool initialized;
            public string decision;
            public string detail;
        }
    }
}
