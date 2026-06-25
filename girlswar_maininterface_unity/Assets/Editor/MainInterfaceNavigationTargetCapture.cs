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
using UnityEngine.SceneManagement;
using UnityEngine.UI;

namespace GirlsWarRestore
{
    public static class MainInterfaceNavigationTargetCapture
    {
        private const string PrototypeScenePath = "Assets/Scenes/MainInterface_NavigationPrototype.unity";
        private const string InstantiateJsonPath = "Assets/RestoreData/maininterface_navigation_target_instantiate_result.json";
        private const string DefaultResultJsonPath = "Assets/RestoreData/maininterface_navigation_target_visual_capture_result.json";
        private const string DefaultResultCsvPath = "Assets/RestoreData/reports/maininterface_navigation_target_visual_capture_result.csv";
        private const string DefaultCaptureDirectory = "Assets/RestoreCaptures/navigation_targets";
        private static string resultJsonPath = DefaultResultJsonPath;
        private static string resultCsvPath = DefaultResultCsvPath;
        private static string captureDirectory = DefaultCaptureDirectory;
        private const float ReferenceWidth = 1680f;
        private const float ReferenceHeight = 720f;

        [Serializable]
        private sealed class InstantiateSummary
        {
            public List<InstantiateTarget> targets;
        }

        [Serializable]
        private sealed class InstantiateTarget
        {
            public string targetKey;
            public string targetUiForm;
            public string prefabRootName;
            public string instantiatedName;
            public bool success;
        }

        [Serializable]
        private sealed class CaptureSummary
        {
            public string generatedAt;
            public string scenePath;
            public int width;
            public int height;
            public int targetCount;
            public int captureSuccessCount;
            public int blankSuspicionCount;
            public int whitePlaceholderSuspicionCount;
            public List<CaptureRow> targets;
        }

        [Serializable]
        private sealed class CaptureRow
        {
            public string targetKey;
            public string targetUiForm;
            public string prefabRootName;
            public string capturePath;
            public bool pngExists;
            public long fileSize;
            public bool instantiateSuccess;
            public int dependencyBundleCandidateCount;
            public int loadedDependencyBundleCount;
            public bool targetRootActive;
            public int targetRootChildCount;
            public int instantiatedObjectCount;
            public int rectTransformCount;
            public int activeRectTransformCount;
            public int canvasCount;
            public int graphicCount;
            public int imageCount;
            public int missingImageSpriteCount;
            public int rawImageMissingTextureCount;
            public int whiteNoSpriteImageCount;
            public int textCount;
            public int tmpTextCount;
            public int missingScriptObjectCount;
            public int visiblePixelCount;
            public int whiteishPixelCount;
            public float whiteishVisibleRatio;
            public bool blankSuspicion;
            public bool whitePlaceholderSuspicion;
            public string reason;
        }

        public static void CaptureNavigationTargetLayouts()
        {
            CaptureNavigationTargetLayoutsTo(DefaultCaptureDirectory, DefaultResultJsonPath, DefaultResultCsvPath);
        }

        public static void CaptureNavigationTargetLayoutsAfterDependencyFixes()
        {
            CaptureNavigationTargetLayoutsTo(
                "Assets/RestoreCaptures/navigation_targets_after_fix",
                "Assets/RestoreData/maininterface_navigation_target_prefab_dependency_fixes.json",
                "Assets/RestoreData/reports/maininterface_navigation_target_prefab_dependency_fixes.csv");
        }

        public static void CaptureNavigationTargetLayoutsTo(string activeCaptureDirectory, string activeResultJsonPath, string activeResultCsvPath)
        {
            if (!File.Exists(PrototypeScenePath))
            {
                MainInterfaceNavigationPrototypeBuilder.BuildNavigationPrototypeScene();
            }

            captureDirectory = activeCaptureDirectory;
            resultJsonPath = activeResultJsonPath;
            resultCsvPath = activeResultCsvPath;

            var targets = LoadInstantiateTargets();
            if (targets.Count == 0)
            {
                throw new Exception("Navigation target capture failed: no instantiate targets found in " + InstantiateJsonPath);
            }

            EditorSceneManager.OpenScene(PrototypeScenePath, OpenSceneMode.Single);
            var canvas = UnityEngine.Object.FindAnyObjectByType<Canvas>();
            var loader = UnityEngine.Object.FindAnyObjectByType<RestoreNavigationTargetLoader>();
            if (canvas == null || loader == null)
            {
                throw new Exception("Navigation target capture failed: Canvas or RestoreNavigationTargetLoader missing");
            }

            Directory.CreateDirectory(captureDirectory);
            var cameraGo = CreateCaptureCamera(out var camera);
            PrepareCanvas(canvas, camera);
            var rows = new List<CaptureRow>();

            try
            {
                foreach (var target in targets)
                {
                    var row = CaptureOneTarget(loader, canvas, camera, target);
                    rows.Add(row);
                    Debug.Log("[GirlsWarRestore] Navigation target capture: " + target.prefabRootName
                        + " visiblePixels=" + row.visiblePixelCount
                        + " whiteNoSpriteImages=" + row.whiteNoSpriteImageCount
                        + " missingScripts=" + row.missingScriptObjectCount
                        + " -> " + row.capturePath);
                }
            }
            finally
            {
                loader.ClearCurrentTarget();
                UnityEngine.Object.DestroyImmediate(cameraGo);
            }

            WriteResults(rows);
            AssetDatabase.Refresh();
            Debug.Log("[GirlsWarRestore] MainInterface navigation target visual capture completed: "
                + rows.Count + " targets -> " + resultJsonPath);
        }

        private static CaptureRow CaptureOneTarget(
            RestoreNavigationTargetLoader loader,
            Canvas canvas,
            Camera camera,
            InstantiateTarget target)
        {
            var row = new CaptureRow
            {
                targetKey = target.targetKey,
                targetUiForm = target.targetUiForm,
                prefabRootName = target.prefabRootName
            };

            row.instantiateSuccess = loader.TryShowTargetKey(target.targetKey, out var instantiateResult);
            row.reason = instantiateResult.reason ?? "";
            row.dependencyBundleCandidateCount = instantiateResult.dependencyBundleCandidateCount;
            row.loadedDependencyBundleCount = instantiateResult.loadedDependencyBundleCount;
            var targetRoot = GameObject.Find("NavigationTargetRoot");
            row.targetRootActive = targetRoot != null && targetRoot.activeInHierarchy;
            row.targetRootChildCount = targetRoot != null ? targetRoot.transform.childCount : 0;

            var instantiated = targetRoot != null && targetRoot.transform.childCount > 0
                ? targetRoot.transform.GetChild(0).gameObject
                : null;
            if (instantiated != null)
            {
                CollectObjectStats(instantiated, row);
            }

            Canvas.ForceUpdateCanvases();
            var texture = RenderToTexture(camera);
            var capturePath = captureDirectory + "/" + SafeFileName(target.prefabRootName) + "_1680x720.png";
            File.WriteAllBytes(capturePath, texture.EncodeToPNG());
            row.capturePath = capturePath;
            row.pngExists = File.Exists(capturePath);
            row.fileSize = row.pngExists ? new FileInfo(capturePath).Length : 0;
            AnalyzePixels(texture, row);
            row.blankSuspicion = row.visiblePixelCount < 5000;
            row.whitePlaceholderSuspicion = row.whiteNoSpriteImageCount > 0 || row.whiteishVisibleRatio > 0.35f;
            UnityEngine.Object.DestroyImmediate(texture);
            return row;
        }

        private static void CollectObjectStats(GameObject root, CaptureRow row)
        {
            row.instantiatedObjectCount = CountObjects(root.transform);
            row.rectTransformCount = root.GetComponentsInChildren<RectTransform>(true).Length;
            row.activeRectTransformCount = root.GetComponentsInChildren<RectTransform>(false).Length;
            row.canvasCount = root.GetComponentsInChildren<Canvas>(true).Length;
            var graphics = root.GetComponentsInChildren<Graphic>(true);
            row.graphicCount = graphics.Length;
            var images = root.GetComponentsInChildren<Image>(true);
            row.imageCount = images.Length;
            row.missingImageSpriteCount = images.Count(i => i != null && i.sprite == null);
            row.whiteNoSpriteImageCount = images.Count(i =>
                i != null
                && i.sprite == null
                && i.color.a > 0.9f
                && i.color.r > 0.9f
                && i.color.g > 0.9f
                && i.color.b > 0.9f);
            row.rawImageMissingTextureCount = root.GetComponentsInChildren<RawImage>(true).Count(i => i != null && i.texture == null);
            row.textCount = root.GetComponentsInChildren<Text>(true).Length;
            row.tmpTextCount = root.GetComponentsInChildren<TMP_Text>(true).Length;
            row.missingScriptObjectCount = root.GetComponentsInChildren<Transform>(true)
                .Count(t => GameObjectUtility.GetMonoBehavioursWithMissingScriptCount(t.gameObject) > 0);
        }

        private static Texture2D RenderToTexture(Camera camera)
        {
            var renderTexture = new RenderTexture((int)ReferenceWidth, (int)ReferenceHeight, 24, RenderTextureFormat.ARGB32);
            var previous = RenderTexture.active;
            camera.targetTexture = renderTexture;
            RenderTexture.active = renderTexture;
            GL.Clear(true, true, new Color(0f, 0f, 0f, 0f));
            camera.Render();

            var texture = new Texture2D((int)ReferenceWidth, (int)ReferenceHeight, TextureFormat.RGBA32, false);
            texture.ReadPixels(new Rect(0, 0, ReferenceWidth, ReferenceHeight), 0, 0);
            texture.Apply();

            RenderTexture.active = previous;
            camera.targetTexture = null;
            UnityEngine.Object.DestroyImmediate(renderTexture);
            return texture;
        }

        private static void AnalyzePixels(Texture2D texture, CaptureRow row)
        {
            var visible = 0;
            var whiteish = 0;
            foreach (var pixel in texture.GetPixels32())
            {
                if (pixel.a <= 0 || (pixel.r == 0 && pixel.g == 0 && pixel.b == 0))
                {
                    continue;
                }
                visible++;
                if (pixel.a > 220 && pixel.r > 235 && pixel.g > 235 && pixel.b > 235)
                {
                    whiteish++;
                }
            }
            row.visiblePixelCount = visible;
            row.whiteishPixelCount = whiteish;
            row.whiteishVisibleRatio = visible > 0 ? (float)whiteish / visible : 0f;
        }

        private static GameObject CreateCaptureCamera(out Camera camera)
        {
            var cameraGo = new GameObject("NavigationTarget_CaptureCamera", typeof(Camera));
            camera = cameraGo.GetComponent<Camera>();
            camera.clearFlags = CameraClearFlags.SolidColor;
            camera.backgroundColor = new Color(0f, 0f, 0f, 0f);
            camera.orthographic = true;
            camera.orthographicSize = ReferenceHeight * 0.5f;
            camera.nearClipPlane = 0.01f;
            camera.farClipPlane = 1000f;
            camera.transform.position = new Vector3(0f, 0f, -100f);
            camera.transform.rotation = Quaternion.identity;
            return cameraGo;
        }

        private static void PrepareCanvas(Canvas canvas, Camera camera)
        {
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
        }

        private static List<InstantiateTarget> LoadInstantiateTargets()
        {
            var projectRoot = Directory.GetParent(Application.dataPath).FullName;
            var path = Path.Combine(projectRoot, InstantiateJsonPath.Replace('/', Path.DirectorySeparatorChar));
            if (!File.Exists(path))
            {
                return new List<InstantiateTarget>();
            }

            var summary = JsonUtility.FromJson<InstantiateSummary>(File.ReadAllText(path));
            return summary != null && summary.targets != null
                ? summary.targets.Where(t => t != null && t.success).ToList()
                : new List<InstantiateTarget>();
        }

        private static void WriteResults(List<CaptureRow> rows)
        {
            var summary = new CaptureSummary
            {
                generatedAt = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture),
                scenePath = PrototypeScenePath,
                width = (int)ReferenceWidth,
                height = (int)ReferenceHeight,
                targetCount = rows.Count,
                captureSuccessCount = rows.Count(r => r.pngExists && r.visiblePixelCount > 0),
                blankSuspicionCount = rows.Count(r => r.blankSuspicion),
                whitePlaceholderSuspicionCount = rows.Count(r => r.whitePlaceholderSuspicion),
                targets = rows
            };

            var projectRoot = Directory.GetParent(Application.dataPath).FullName;
            var jsonPath = Path.Combine(projectRoot, resultJsonPath.Replace('/', Path.DirectorySeparatorChar));
            var csvPath = Path.Combine(projectRoot, resultCsvPath.Replace('/', Path.DirectorySeparatorChar));
            Directory.CreateDirectory(Path.GetDirectoryName(jsonPath));
            Directory.CreateDirectory(Path.GetDirectoryName(csvPath));
            File.WriteAllText(jsonPath, JsonUtility.ToJson(summary, true), new UTF8Encoding(false));
            WriteCsv(csvPath, rows);
            AssetDatabase.ImportAsset(resultJsonPath);
            AssetDatabase.ImportAsset(resultCsvPath);
        }

        private static void WriteCsv(string path, List<CaptureRow> rows)
        {
            var sb = new StringBuilder();
            sb.AppendLine("target_key,target_ui_form,prefab_root_name,capture_path,png_exists,file_size,instantiate_success,dependency_bundle_candidate_count,loaded_dependency_bundle_count,target_root_active,target_root_child_count,instantiated_object_count,rect_transform_count,active_rect_transform_count,canvas_count,graphic_count,image_count,missing_image_sprite_count,raw_image_missing_texture_count,white_no_sprite_image_count,text_count,tmp_text_count,missing_script_object_count,visible_pixel_count,whiteish_pixel_count,whiteish_visible_ratio,blank_suspicion,white_placeholder_suspicion,reason");
            foreach (var row in rows)
            {
                var values = new[]
                {
                    row.targetKey,
                    row.targetUiForm,
                    row.prefabRootName,
                    row.capturePath,
                    row.pngExists ? "1" : "0",
                    row.fileSize.ToString(CultureInfo.InvariantCulture),
                    row.instantiateSuccess ? "1" : "0",
                    row.dependencyBundleCandidateCount.ToString(CultureInfo.InvariantCulture),
                    row.loadedDependencyBundleCount.ToString(CultureInfo.InvariantCulture),
                    row.targetRootActive ? "1" : "0",
                    row.targetRootChildCount.ToString(CultureInfo.InvariantCulture),
                    row.instantiatedObjectCount.ToString(CultureInfo.InvariantCulture),
                    row.rectTransformCount.ToString(CultureInfo.InvariantCulture),
                    row.activeRectTransformCount.ToString(CultureInfo.InvariantCulture),
                    row.canvasCount.ToString(CultureInfo.InvariantCulture),
                    row.graphicCount.ToString(CultureInfo.InvariantCulture),
                    row.imageCount.ToString(CultureInfo.InvariantCulture),
                    row.missingImageSpriteCount.ToString(CultureInfo.InvariantCulture),
                    row.rawImageMissingTextureCount.ToString(CultureInfo.InvariantCulture),
                    row.whiteNoSpriteImageCount.ToString(CultureInfo.InvariantCulture),
                    row.textCount.ToString(CultureInfo.InvariantCulture),
                    row.tmpTextCount.ToString(CultureInfo.InvariantCulture),
                    row.missingScriptObjectCount.ToString(CultureInfo.InvariantCulture),
                    row.visiblePixelCount.ToString(CultureInfo.InvariantCulture),
                    row.whiteishPixelCount.ToString(CultureInfo.InvariantCulture),
                    row.whiteishVisibleRatio.ToString("0.0000", CultureInfo.InvariantCulture),
                    row.blankSuspicion ? "1" : "0",
                    row.whitePlaceholderSuspicion ? "1" : "0",
                    row.reason
                };
                sb.AppendLine(string.Join(",", values.Select(EscapeCsv)));
            }
            File.WriteAllText(path, sb.ToString(), new UTF8Encoding(false));
        }

        private static int CountObjects(Transform root)
        {
            var count = 1;
            for (var i = 0; i < root.childCount; i++)
            {
                count += CountObjects(root.GetChild(i));
            }
            return count;
        }

        private static string SafeFileName(string value)
        {
            value = string.IsNullOrWhiteSpace(value) ? "target" : value;
            foreach (var c in Path.GetInvalidFileNameChars())
            {
                value = value.Replace(c, '_');
            }
            return value;
        }

        private static string EscapeCsv(string value)
        {
            value = value ?? "";
            if (value.Contains(",") || value.Contains("\"") || value.Contains("\n") || value.Contains("\r"))
            {
                return "\"" + value.Replace("\"", "\"\"") + "\"";
            }
            return value;
        }
    }
}
