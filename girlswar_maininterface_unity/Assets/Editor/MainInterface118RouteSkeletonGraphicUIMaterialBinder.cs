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
    public static class MainInterface118RouteSkeletonGraphicUIMaterialBinder
    {
        private const string SourceScenePath = "Assets/Scenes/MainInterface_RouteSpineRuntimeReplay_Validated.unity";
        private const string BoundScenePath = "Assets/Scenes/MainInterface_RouteSpineRuntimeReplay_UIMaterialBound.unity";
        private const string RendererTraceCsv = "Assets/RestoreData/reports/maininterface_route_renderer_asset_trace.csv";
        private const string ResultJson = "Assets/RestoreData/maininterface_118_route_skeletongraphic_ui_material_shader_pass_binding.json";
        private const string ResultCsv = "Assets/RestoreData/reports/maininterface_118_route_skeletongraphic_ui_material_shader_pass_binding.csv";
        private const string CapturePath = "Assets/RestoreCaptures/maininterface_route_spine_runtime_ui_material_bound_1680x720.png";
        private const string DefaultMaterialPath = "Assets/Spine/Runtime/spine-unity/Materials/SkeletonGraphicDefault.mat";
        private const string AdditiveMaterialPath = "Assets/Spine/Runtime/spine-unity/Materials/SkeletonGraphicAdditive.mat";
        private const string MultiplyMaterialPath = "Assets/Spine/Runtime/spine-unity/Materials/SkeletonGraphicMultiply.mat";
        private const string ScreenMaterialPath = "Assets/Spine/Runtime/spine-unity/Materials/SkeletonGraphicScreen.mat";
        private const string SkeletonGraphicMetaPath = "Assets/Spine/Runtime/spine-unity/Components/SkeletonGraphic.cs.meta";
        private const float ReferenceWidth = 1680f;
        private const float ReferenceHeight = 720f;

        private static readonly TargetSpec[] Targets =
        {
            new TargetSpec("Spine_shijieanniu", "spine_diqiu", "-1766545527926586392", "A"),
            new TargetSpec("8007", "spine_xiaoren", "3375689855543054311", "run")
        };

        [MenuItem("GirlsWar/UI118 Bind Route SkeletonGraphic UI Material Shader Pass")]
        public static void BindAndCapture()
        {
            Directory.CreateDirectory("Assets/RestoreData/reports");
            Directory.CreateDirectory("Assets/RestoreCaptures");

            var result = new BindingResult
            {
                generatedAt = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture),
                status = "started",
                visualVerdict = "not_normal_started",
                sourceScenePath = SourceScenePath,
                boundScenePath = BoundScenePath,
                capturePath = CapturePath,
                shaderRows = new List<ShaderRow>(),
                targetRows = new List<TargetRow>()
            };

            try
            {
                if (!File.Exists(SourceScenePath))
                {
                    result.notes = "UI117 validated scene was missing, so UI117 validation was invoked before UI118 binding.";
                    MainInterface117RouteSkeletonGraphicLayoutValidation.ValidateAndCapture();
                }

                ProbeShaders(result);
                EditorSceneManager.OpenScene(SourceScenePath, OpenSceneMode.Single);
                BindTargets(result);

                result.targetsConsidered = result.targetRows.Count;
                result.targetsBound = result.targetRows.Count(r => r.boundDefaultMaterial);
                result.additiveBound = result.targetRows.Count(r => r.boundAdditiveMaterial);
                result.multiplyBound = result.targetRows.Count(r => r.boundMultiplyMaterial);
                result.screenBound = result.targetRows.Count(r => r.boundScreenMaterial);
                result.originalRefsPresent = result.targetRows.Count(r => r.originalMaterialRefsPresent);
                result.visualFixApplied = result.targetRows.Count(r => r.boundDefaultMaterial);

                EditorSceneManager.SaveScene(SceneManager.GetActiveScene(), BoundScenePath);
                CaptureScene(BoundScenePath, CapturePath, result);

                result.status = "maininterface_118_route_skeletongraphic_ui_material_shader_pass_binding_complete";
                result.visualVerdict = result.visualFixApplied > 0
                    ? "not_normal_partial_candidate_ui_material_shader_bound_requires_visual_review"
                    : "not_normal_trace_only_no_material_patch";
                result.nextBlocker = "route SkeletonGraphic mesh bounds and CanvasRenderer submesh material validation against original runtime fields";
            }
            catch (Exception ex)
            {
                result.status = "maininterface_118_route_skeletongraphic_ui_material_shader_pass_binding_failed";
                result.visualVerdict = "not_normal_probe_failed";
                result.nextBlocker = ex.GetType().Name + ": " + ex.Message;
                Debug.LogException(ex);
                WriteOutputs(result);
                throw;
            }

            WriteOutputs(result);
            Debug.Log("[GirlsWarRestore] UI118 route SkeletonGraphic UI material binding complete: " + ResultJson);
        }

        private static void ProbeShaders(BindingResult result)
        {
            AddShaderProbe(result, "Spine/Skeleton");
            AddShaderProbe(result, "Spine/SkeletonGraphic");
            AddShaderProbe(result, "Spine/SkeletonGraphic Additive");
            AddShaderProbe(result, "Spine/SkeletonGraphic Multiply");
            AddShaderProbe(result, "Spine/SkeletonGraphic Screen");
            AddShaderProbe(result, "Spine/SkeletonGraphic Tint Black");
            AddShaderProbe(result, "UI/Default");

            var meta = File.Exists(SkeletonGraphicMetaPath) ? File.ReadAllText(SkeletonGraphicMetaPath, Encoding.UTF8) : "";
            result.skeletonGraphicMetaDefaultMaterialPath = DefaultMaterialPath;
            result.skeletonGraphicMetaDefaultMaterialEvidence =
                meta.IndexOf("m_Material", StringComparison.OrdinalIgnoreCase) >= 0
                && meta.IndexOf("b66cf7a186d13054989b33a5c90044e4", StringComparison.OrdinalIgnoreCase) >= 0;
        }

        private static void AddShaderProbe(BindingResult result, string name)
        {
            var shader = Shader.Find(name);
            result.shaderRows.Add(new ShaderRow
            {
                shaderName = name,
                found = shader != null,
                supported = shader != null && shader.isSupported,
                passCount = shader != null ? shader.passCount : 0
            });
        }

        private static void BindTargets(BindingResult result)
        {
            var skeletonGraphicType = FindType("Spine.Unity.SkeletonGraphic");
            var defaultMaterial = AssetDatabase.LoadAssetAtPath<Material>(DefaultMaterialPath);
            var additiveMaterial = AssetDatabase.LoadAssetAtPath<Material>(AdditiveMaterialPath);
            var multiplyMaterial = AssetDatabase.LoadAssetAtPath<Material>(MultiplyMaterialPath);
            var screenMaterial = AssetDatabase.LoadAssetAtPath<Material>(ScreenMaterialPath);
            var routeRows = LoadCsv(RendererTraceCsv);

            foreach (var target in Targets)
            {
                var row = new TargetRow
                {
                    skeletonKey = target.skeletonKey,
                    nodeName = target.nodeName,
                    expectedAnimation = target.animation,
                    defaultMaterialPath = DefaultMaterialPath,
                    additiveMaterialPath = AdditiveMaterialPath,
                    multiplyMaterialPath = MultiplyMaterialPath,
                    screenMaterialPath = ScreenMaterialPath,
                    skeletonGraphicTypeAvailable = skeletonGraphicType != null,
                    defaultMaterialLoaded = defaultMaterial != null,
                    additiveMaterialLoaded = additiveMaterial != null,
                    multiplyMaterialLoaded = multiplyMaterial != null,
                    screenMaterialLoaded = screenMaterial != null,
                    skeletonGraphicMetaDefaultMaterialEvidence = result.skeletonGraphicMetaDefaultMaterialEvidence
                };
                result.targetRows.Add(row);

                var rt = FindNode(target.nodeName, target.rectPathId);
                row.sceneNodeFound = rt != null;
                if (rt != null)
                {
                    row.sceneObjectPath = TransformPath(rt);
                    row.parentPath = rt.parent != null ? TransformPath(rt.parent) : "";
                    row.siblingIndex = rt.GetSiblingIndex();
                    row.anchoredPosition = Format(rt.anchoredPosition);
                    row.sizeDelta = Format(rt.sizeDelta);
                    row.localScale = Format(rt.localScale);
                }

                var original = routeRows.FirstOrDefault(r =>
                    EqualsIgnoreCase(Get(r, "game_object_name"), target.nodeName)
                    && Get(r, "note").IndexOf("SkeletonGraphic", StringComparison.OrdinalIgnoreCase) >= 0
                    && !string.IsNullOrWhiteSpace(Get(r, "material_refs")));
                row.originalMaterialRefs = original != null ? Get(original, "material_refs") : "";
                row.originalMaterialRefsPresent =
                    row.originalMaterialRefs.Contains("m_Material=file6:1869315399850166803")
                    && row.originalMaterialRefs.Contains("additiveMaterial=file6:-7852358095173771177")
                    && row.originalMaterialRefs.Contains("multiplyMaterial=file6:-13276894215973044")
                    && row.originalMaterialRefs.Contains("screenMaterial=file6:-5524858707655825726");

                if (skeletonGraphicType == null || rt == null)
                {
                    row.decision = "blocked_skeletongraphic_type_or_node_missing";
                    row.reason = "SkeletonGraphic runtime type or original node is missing.";
                    continue;
                }

                var component = rt.GetComponents<Component>().FirstOrDefault(c => c != null && skeletonGraphicType.IsInstanceOfType(c));
                row.skeletonGraphicFound = component != null;
                if (component == null)
                {
                    row.decision = "blocked_skeletongraphic_component_missing";
                    row.reason = "No SkeletonGraphic component was found on the original node.";
                    continue;
                }

                var graphic = component as Graphic;
                if (graphic != null && graphic.material != null)
                {
                    row.beforeMaterialName = graphic.material.name;
                    row.beforeShaderName = graphic.material.shader != null ? graphic.material.shader.name : "";
                }

                row.beforeAdditiveName = MaterialName(GetMember(component, "additiveMaterial"));
                row.beforeMultiplyName = MaterialName(GetMember(component, "multiplyMaterial"));
                row.beforeScreenName = MaterialName(GetMember(component, "screenMaterial"));

                var evidenceComplete =
                    row.originalMaterialRefsPresent
                    && row.skeletonGraphicMetaDefaultMaterialEvidence
                    && defaultMaterial != null
                    && Shader.Find("Spine/SkeletonGraphic") != null
                    && Shader.Find("Spine/SkeletonGraphic").isSupported;

                if (!evidenceComplete)
                {
                    row.decision = "trace_only_ui_material_evidence_incomplete";
                    row.reason = "Original material refs or SkeletonGraphic default material evidence was incomplete, so no material patch was applied.";
                    continue;
                }

                if (graphic != null)
                {
                    graphic.material = defaultMaterial;
                    graphic.raycastTarget = false;
                    graphic.color = Color.white;
                    row.boundDefaultMaterial = true;
                }

                if (additiveMaterial != null)
                {
                    SetMember(component, "additiveMaterial", additiveMaterial);
                    row.boundAdditiveMaterial = true;
                }
                if (multiplyMaterial != null)
                {
                    SetMember(component, "multiplyMaterial", multiplyMaterial);
                    row.boundMultiplyMaterial = true;
                }
                if (screenMaterial != null)
                {
                    SetMember(component, "screenMaterial", screenMaterial);
                    row.boundScreenMaterial = true;
                }

                try
                {
                    Invoke(component, "Initialize", true);
                    Invoke(component, "Update", 0f);
                    Invoke(component, "SetVerticesDirty");
                    Invoke(component, "SetMaterialDirty");
                    row.initializedAfterBinding = true;
                }
                catch (Exception ex)
                {
                    row.initializedAfterBinding = false;
                    row.initializeException = ex.GetType().Name + ": " + ex.Message;
                }

                if (graphic != null && graphic.material != null)
                {
                    row.afterMaterialName = graphic.material.name;
                    row.afterShaderName = graphic.material.shader != null ? graphic.material.shader.name : "";
                    row.afterMaterialPassCount = graphic.material.passCount;
                }
                row.afterAdditiveName = MaterialName(GetMember(component, "additiveMaterial"));
                row.afterMultiplyName = MaterialName(GetMember(component, "multiplyMaterial"));
                row.afterScreenName = MaterialName(GetMember(component, "screenMaterial"));
                row.decision = row.boundDefaultMaterial
                    ? "applied_evidence_backed_skeletongraphic_ui_material_binding"
                    : "trace_only_no_patch_applied";
                row.reason = "Original component carries common SkeletonGraphic material refs and imported SkeletonGraphic.cs.meta default m_Material points to SkeletonGraphicDefault.";
            }
        }

        private static void CaptureScene(string scenePath, string capturePath, BindingResult result)
        {
            EditorSceneManager.OpenScene(scenePath, OpenSceneMode.Single);
            var canvas = UnityEngine.Object.FindFirstObjectByType<Canvas>();
            if (canvas == null)
                throw new Exception("Capture failed: Canvas not found in " + scenePath);

            var cameraGo = new GameObject("UI118_RouteSpineUIMaterialCaptureCamera", typeof(Camera));
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
            var whiteishPixels = 0;
            foreach (var pixel in texture.GetPixels32())
            {
                if (pixel.a > 0 && (pixel.r > 0 || pixel.g > 0 || pixel.b > 0))
                    visiblePixels++;
                if (pixel.r > 180 && pixel.b > 180 && pixel.g < 90)
                    magentaPixels++;
                if (pixel.a > 220 && pixel.r > 230 && pixel.g > 230 && pixel.b > 230)
                    whiteishPixels++;
            }

            result.captureExists = File.Exists(capturePath);
            result.captureSize = result.captureExists ? new FileInfo(capturePath).Length : 0;
            result.visiblePixelCount = visiblePixels;
            result.magentaPixelCount = magentaPixels;
            result.whiteishPixelCount = whiteishPixels;

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

        private static void SetMember(object target, string name, object value)
        {
            if (target == null)
                return;
            var type = target.GetType();
            var property = type.GetProperty(name, BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance);
            if (property != null && property.CanWrite)
            {
                try
                {
                    property.SetValue(target, value, null);
                    return;
                }
                catch { }
            }
            var field = type.GetField(name, BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance);
            if (field != null)
            {
                try { field.SetValue(target, value); }
                catch { }
            }
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

        private static string MaterialName(object value)
        {
            var material = value as Material;
            if (material == null)
                return "";
            var shaderName = material.shader != null ? material.shader.name : "";
            return material.name + " / " + shaderName;
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

        private static void WriteOutputs(BindingResult result)
        {
            File.WriteAllText(ResultJson, JsonUtility.ToJson(result, true), Encoding.UTF8);
            var sb = new StringBuilder();
            sb.AppendLine("kind,name,path,decision,reason,before,after,originalRefs,evidence");
            foreach (var row in result.shaderRows)
            {
                sb.AppendLine(string.Join(",", new[]
                {
                    Csv("ShaderProbe"),
                    Csv(row.shaderName),
                    Csv(""),
                    Csv(row.found && row.supported ? "supported" : "missing_or_unsupported"),
                    Csv("Shader.Find probe; pass count recorded for UI material binding decision."),
                    Csv(""),
                    Csv("found=" + row.found + ";supported=" + row.supported + ";passCount=" + row.passCount),
                    Csv(""),
                    Csv("")
                }));
            }
            foreach (var row in result.targetRows)
            {
                sb.AppendLine(string.Join(",", new[]
                {
                    Csv("SkeletonGraphic"),
                    Csv(row.nodeName),
                    Csv(row.sceneObjectPath),
                    Csv(row.decision),
                    Csv(row.reason),
                    Csv(row.beforeMaterialName + " / " + row.beforeShaderName + ";add=" + row.beforeAdditiveName + ";mul=" + row.beforeMultiplyName + ";screen=" + row.beforeScreenName),
                    Csv(row.afterMaterialName + " / " + row.afterShaderName + ";add=" + row.afterAdditiveName + ";mul=" + row.afterMultiplyName + ";screen=" + row.afterScreenName + ";pass=" + row.afterMaterialPassCount),
                    Csv(row.originalMaterialRefs),
                    Csv("SkeletonGraphic.cs.meta default material=" + row.skeletonGraphicMetaDefaultMaterialEvidence)
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
            public readonly string animation;

            public TargetSpec(string skeletonKey, string nodeName, string rectPathId, string animation)
            {
                this.skeletonKey = skeletonKey;
                this.nodeName = nodeName;
                this.rectPathId = rectPathId;
                this.animation = animation;
            }
        }

        [Serializable]
        private sealed class BindingResult
        {
            public string generatedAt;
            public string status;
            public string visualVerdict;
            public string sourceScenePath;
            public string boundScenePath;
            public string capturePath;
            public bool captureExists;
            public long captureSize;
            public int visiblePixelCount;
            public int magentaPixelCount;
            public int whiteishPixelCount;
            public int visualFixApplied;
            public int targetsConsidered;
            public int targetsBound;
            public int additiveBound;
            public int multiplyBound;
            public int screenBound;
            public int originalRefsPresent;
            public string skeletonGraphicMetaDefaultMaterialPath;
            public bool skeletonGraphicMetaDefaultMaterialEvidence;
            public string notes;
            public string nextBlocker;
            public List<ShaderRow> shaderRows;
            public List<TargetRow> targetRows;
        }

        [Serializable]
        private sealed class ShaderRow
        {
            public string shaderName;
            public bool found;
            public bool supported;
            public int passCount;
        }

        [Serializable]
        private sealed class TargetRow
        {
            public string skeletonKey;
            public string nodeName;
            public string expectedAnimation;
            public string sceneObjectPath;
            public string parentPath;
            public int siblingIndex;
            public string anchoredPosition;
            public string sizeDelta;
            public string localScale;
            public bool sceneNodeFound;
            public bool skeletonGraphicFound;
            public bool skeletonGraphicTypeAvailable;
            public bool defaultMaterialLoaded;
            public bool additiveMaterialLoaded;
            public bool multiplyMaterialLoaded;
            public bool screenMaterialLoaded;
            public string defaultMaterialPath;
            public string additiveMaterialPath;
            public string multiplyMaterialPath;
            public string screenMaterialPath;
            public string originalMaterialRefs;
            public bool originalMaterialRefsPresent;
            public bool skeletonGraphicMetaDefaultMaterialEvidence;
            public string beforeMaterialName;
            public string beforeShaderName;
            public string beforeAdditiveName;
            public string beforeMultiplyName;
            public string beforeScreenName;
            public bool boundDefaultMaterial;
            public bool boundAdditiveMaterial;
            public bool boundMultiplyMaterial;
            public bool boundScreenMaterial;
            public bool initializedAfterBinding;
            public string initializeException;
            public string afterMaterialName;
            public string afterShaderName;
            public int afterMaterialPassCount;
            public string afterAdditiveName;
            public string afterMultiplyName;
            public string afterScreenName;
            public string decision;
            public string reason;
        }
    }
}
