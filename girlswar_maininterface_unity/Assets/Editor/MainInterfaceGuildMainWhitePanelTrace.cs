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
    public static class MainInterfaceGuildMainWhitePanelTrace
    {
        private const string PrototypeScenePath = "Assets/Scenes/MainInterface_NavigationPrototype.unity";
        private const string OutputJsonPath = "Assets/RestoreData/maininterface_guildmain_white_panel_material_shader_runtime_trace.json";
        private const string OutputCsvPath = "Assets/RestoreData/reports/maininterface_guildmain_white_panel_material_shader_runtime_trace.csv";
        private const string CaptureDirectory = "Assets/RestoreCaptures/guildmain_white_panel_trace";
        private const string CapturePath = CaptureDirectory + "/UI_GuildMain_1680x720.png";
        private const float ReferenceWidth = 1680f;
        private const float ReferenceHeight = 720f;

        [Serializable]
        private sealed class TraceSummary
        {
            public string generatedAt;
            public string scenePath;
            public string targetKey;
            public string targetUiForm;
            public string prefabRootName;
            public string capturePath;
            public bool instantiateSuccess;
            public int width;
            public int height;
            public int loadedDependencyBundleCount;
            public int imageCount;
            public int activeImageCount;
            public int noSpriteImageCount;
            public int whiteNoSpriteImageCount;
            public int resolvedSpriteImageCount;
            public int missingScriptObjectCount;
            public int visiblePixelCount;
            public int whiteishPixelCount;
            public float whiteishVisibleRatio;
            public int largeWhiteVisibleImageCount;
            public int largeWhiteVisiblePixelTotal;
            public bool screenLooksNormal;
            public string verdict;
            public List<ImageTraceRow> topWhiteVisibleImages;
        }

        [Serializable]
        private sealed class ImageTraceRow
        {
            public int rank;
            public string hierarchyPath;
            public bool activeInHierarchy;
            public int siblingIndex;
            public string componentType;
            public string monoBehaviourTypes;
            public int missingScriptCountOnObject;
            public int canvasSortingOrder;
            public bool canvasOverrideSorting;
            public string canvasRenderMode;
            public float screenMinX;
            public float screenMinY;
            public float screenMaxX;
            public float screenMaxY;
            public int screenPixelArea;
            public int screenWhiteishPixelCount;
            public float screenWhiteishRatio;
            public string spriteName;
            public long spriteLocalId;
            public string spriteTextureName;
            public int spriteTextureWidth;
            public int spriteTextureHeight;
            public float spriteRectX;
            public float spriteRectY;
            public float spriteRectWidth;
            public float spriteRectHeight;
            public string materialName;
            public long materialLocalId;
            public string shaderName;
            public int renderQueue;
            public string materialForRenderingName;
            public string materialForRenderingShaderName;
            public string color;
            public float alpha;
            public bool raycastTarget;
            public string imageType;
            public bool preserveAspect;
            public bool fillCenter;
            public string fillMethod;
            public float fillAmount;
            public bool fillClockwise;
            public int fillOrigin;
            public float pixelsPerUnitMultiplier;
            public string reasonClass;
        }

        public static void TraceGuildMainWhitePanelMaterialShaderRuntime()
        {
            if (!File.Exists(PrototypeScenePath))
            {
                MainInterfaceNavigationPrototypeBuilder.BuildNavigationPrototypeScene();
            }

            EditorSceneManager.OpenScene(PrototypeScenePath, OpenSceneMode.Single);
            var canvas = UnityEngine.Object.FindAnyObjectByType<Canvas>();
            var loader = UnityEngine.Object.FindAnyObjectByType<RestoreNavigationTargetLoader>();
            if (canvas == null || loader == null)
            {
                throw new Exception("GuildMain white panel trace failed: Canvas or RestoreNavigationTargetLoader missing");
            }

            var cameraGo = CreateCaptureCamera(out var camera);
            PrepareCanvas(canvas, camera);
            Directory.CreateDirectory(CaptureDirectory);

            try
            {
                var success = loader.TryShowTargetKey("jump.OnGameJumpUIGuild", out var instantiateResult);
                var targetRoot = GameObject.Find("NavigationTargetRoot");
                var instantiated = targetRoot != null && targetRoot.transform.childCount > 0
                    ? targetRoot.transform.GetChild(0).gameObject
                    : null;
                Canvas.ForceUpdateCanvases();
                var texture = RenderToTexture(camera);
                File.WriteAllBytes(CapturePath, texture.EncodeToPNG());

                var summary = TraceInstantiatedGuild(success, instantiateResult, instantiated, texture, camera);
                WriteOutputs(summary);
                UnityEngine.Object.DestroyImmediate(texture);
            }
            finally
            {
                loader.ClearCurrentTarget();
                UnityEngine.Object.DestroyImmediate(cameraGo);
            }

            AssetDatabase.Refresh();
            Debug.Log("[GirlsWarRestore] GuildMain white panel material/shader/runtime trace completed -> " + OutputJsonPath);
        }

        private static TraceSummary TraceInstantiatedGuild(
            bool success,
            RestoreNavigationTargetLoader.InstantiationResult result,
            GameObject instantiated,
            Texture2D texture,
            Camera camera)
        {
            var summary = new TraceSummary
            {
                generatedAt = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture),
                scenePath = PrototypeScenePath,
                targetKey = result.targetKey,
                targetUiForm = result.targetUiForm,
                prefabRootName = result.prefabRootName,
                capturePath = CapturePath,
                instantiateSuccess = success,
                width = (int)ReferenceWidth,
                height = (int)ReferenceHeight,
                loadedDependencyBundleCount = result.loadedDependencyBundleCount,
                topWhiteVisibleImages = new List<ImageTraceRow>()
            };

            AnalyzePixels(texture, summary, out var whiteIntegral);
            if (instantiated == null)
            {
                summary.verdict = "not_normal: UI_GuildMain did not instantiate";
                summary.screenLooksNormal = false;
                return summary;
            }

            var images = instantiated.GetComponentsInChildren<Image>(true);
            summary.imageCount = images.Length;
            summary.activeImageCount = images.Count(i => i != null && i.gameObject.activeInHierarchy);
            summary.noSpriteImageCount = images.Count(i => i != null && i.sprite == null);
            summary.whiteNoSpriteImageCount = images.Count(i => IsWhiteNoSprite(i));
            summary.resolvedSpriteImageCount = images.Count(i => i != null && i.sprite != null);
            summary.missingScriptObjectCount = instantiated.GetComponentsInChildren<Transform>(true)
                .Count(t => GameObjectUtility.GetMonoBehavioursWithMissingScriptCount(t.gameObject) > 0);

            var rows = new List<ImageTraceRow>();
            foreach (var image in images)
            {
                if (image == null || !image.gameObject.activeInHierarchy || image.color.a <= 0.01f)
                {
                    continue;
                }
                rows.Add(TraceImage(instantiated.transform, image, camera, whiteIntegral));
            }

            summary.topWhiteVisibleImages = rows
                .OrderByDescending(r => r.screenWhiteishPixelCount)
                .ThenByDescending(r => r.screenPixelArea)
                .Take(50)
                .Select((row, index) =>
                {
                    row.rank = index + 1;
                    return row;
                })
                .ToList();
            summary.largeWhiteVisibleImageCount = summary.topWhiteVisibleImages
                .Count(r => r.screenWhiteishPixelCount >= 5000 && r.screenWhiteishRatio >= 0.5f);
            summary.largeWhiteVisiblePixelTotal = summary.topWhiteVisibleImages
                .Where(r => r.screenWhiteishPixelCount >= 5000 && r.screenWhiteishRatio >= 0.5f)
                .Sum(r => r.screenWhiteishPixelCount);
            summary.screenLooksNormal = summary.whiteishVisibleRatio < 0.35f && summary.largeWhiteVisibleImageCount == 0;
            summary.verdict = summary.screenLooksNormal
                ? "normal_by_white_panel_metric"
                : "not_normal: large white panels remain after sprite join; requires material/runtime/type/active-state evidence";
            return summary;
        }

        private static ImageTraceRow TraceImage(Transform root, Image image, Camera camera, int[,] whiteIntegral)
        {
            var rect = image.GetComponent<RectTransform>();
            var sprite = image.sprite;
            var material = image.material;
            var materialForRendering = image.materialForRendering;
            var canvas = image.GetComponentInParent<Canvas>();
            var bounds = ScreenBounds(rect, camera);
            var x0 = Mathf.Clamp(Mathf.FloorToInt(bounds.xMin), 0, (int)ReferenceWidth);
            var y0 = Mathf.Clamp(Mathf.FloorToInt(bounds.yMin), 0, (int)ReferenceHeight);
            var x1 = Mathf.Clamp(Mathf.CeilToInt(bounds.xMax), 0, (int)ReferenceWidth);
            var y1 = Mathf.Clamp(Mathf.CeilToInt(bounds.yMax), 0, (int)ReferenceHeight);
            var pixelArea = Math.Max(0, x1 - x0) * Math.Max(0, y1 - y0);
            var whitePixels = pixelArea > 0 ? IntegralSum(whiteIntegral, x0, y0, x1, y1) : 0;
            var monoTypes = image.gameObject.GetComponents<MonoBehaviour>()
                .Where(m => m != null)
                .Select(m => m.GetType().FullName)
                .OrderBy(n => n, StringComparer.OrdinalIgnoreCase);

            return new ImageTraceRow
            {
                hierarchyPath = BuildPath(root, image.transform),
                activeInHierarchy = image.gameObject.activeInHierarchy,
                siblingIndex = image.transform.GetSiblingIndex(),
                componentType = image.GetType().FullName,
                monoBehaviourTypes = string.Join(";", monoTypes),
                missingScriptCountOnObject = GameObjectUtility.GetMonoBehavioursWithMissingScriptCount(image.gameObject),
                canvasSortingOrder = canvas != null ? canvas.sortingOrder : 0,
                canvasOverrideSorting = canvas != null && canvas.overrideSorting,
                canvasRenderMode = canvas != null ? canvas.renderMode.ToString() : "",
                screenMinX = bounds.xMin,
                screenMinY = bounds.yMin,
                screenMaxX = bounds.xMax,
                screenMaxY = bounds.yMax,
                screenPixelArea = pixelArea,
                screenWhiteishPixelCount = whitePixels,
                screenWhiteishRatio = pixelArea > 0 ? (float)whitePixels / pixelArea : 0f,
                spriteName = sprite != null ? sprite.name : "",
                spriteLocalId = sprite != null ? Unsupported.GetLocalIdentifierInFile(sprite.GetInstanceID()) : 0,
                spriteTextureName = sprite != null && sprite.texture != null ? sprite.texture.name : "",
                spriteTextureWidth = sprite != null && sprite.texture != null ? sprite.texture.width : 0,
                spriteTextureHeight = sprite != null && sprite.texture != null ? sprite.texture.height : 0,
                spriteRectX = sprite != null ? sprite.rect.x : 0f,
                spriteRectY = sprite != null ? sprite.rect.y : 0f,
                spriteRectWidth = sprite != null ? sprite.rect.width : 0f,
                spriteRectHeight = sprite != null ? sprite.rect.height : 0f,
                materialName = material != null ? material.name : "",
                materialLocalId = material != null ? Unsupported.GetLocalIdentifierInFile(material.GetInstanceID()) : 0,
                shaderName = material != null && material.shader != null ? material.shader.name : "",
                renderQueue = material != null ? material.renderQueue : 0,
                materialForRenderingName = materialForRendering != null ? materialForRendering.name : "",
                materialForRenderingShaderName = materialForRendering != null && materialForRendering.shader != null ? materialForRendering.shader.name : "",
                color = ColorUtility.ToHtmlStringRGBA(image.color),
                alpha = image.color.a,
                raycastTarget = image.raycastTarget,
                imageType = image.type.ToString(),
                preserveAspect = image.preserveAspect,
                fillCenter = image.fillCenter,
                fillMethod = image.fillMethod.ToString(),
                fillAmount = image.fillAmount,
                fillClockwise = image.fillClockwise,
                fillOrigin = image.fillOrigin,
                pixelsPerUnitMultiplier = image.pixelsPerUnitMultiplier,
                reasonClass = Classify(image, material, whitePixels, pixelArea)
            };
        }

        private static string Classify(Image image, Material material, int whitePixels, int pixelArea)
        {
            if (image.sprite == null)
            {
                return IsWhiteNoSprite(image) ? "no_sprite" : "runtime_bound";
            }
            if (material == null || material.shader == null)
            {
                return "missing_material_shader";
            }
            if (image.color.a > 0.95f && image.color.r > 0.95f && image.color.g > 0.95f && image.color.b > 0.95f)
            {
                return pixelArea > 0 && (float)whitePixels / pixelArea > 0.5f
                    ? "resolved_sprite_but_white_render"
                    : "color_tint_white_or_alpha";
            }
            return pixelArea > 0 && (float)whitePixels / pixelArea > 0.5f
                ? "covered_by_white_layer"
                : "unknown";
        }

        private static Rect ScreenBounds(RectTransform rect, Camera camera)
        {
            if (rect == null)
            {
                return new Rect();
            }
            var corners = new Vector3[4];
            rect.GetWorldCorners(corners);
            var minX = float.MaxValue;
            var minY = float.MaxValue;
            var maxX = float.MinValue;
            var maxY = float.MinValue;
            foreach (var corner in corners)
            {
                var screen = camera.WorldToScreenPoint(corner);
                minX = Mathf.Min(minX, screen.x);
                minY = Mathf.Min(minY, screen.y);
                maxX = Mathf.Max(maxX, screen.x);
                maxY = Mathf.Max(maxY, screen.y);
            }
            return Rect.MinMaxRect(minX, minY, maxX, maxY);
        }

        private static bool IsWhiteNoSprite(Image image)
        {
            return image != null
                && image.sprite == null
                && image.color.a > 0.9f
                && image.color.r > 0.9f
                && image.color.g > 0.9f
                && image.color.b > 0.9f;
        }

        private static void AnalyzePixels(Texture2D texture, TraceSummary summary, out int[,] whiteIntegral)
        {
            var width = texture.width;
            var height = texture.height;
            whiteIntegral = new int[width + 1, height + 1];
            var pixels = texture.GetPixels32();
            var visible = 0;
            var whiteish = 0;
            for (var y = 0; y < height; y++)
            {
                var row = 0;
                for (var x = 0; x < width; x++)
                {
                    var pixel = pixels[y * width + x];
                    var isVisible = pixel.a > 0 && !(pixel.r == 0 && pixel.g == 0 && pixel.b == 0);
                    var isWhite = pixel.a > 220 && pixel.r > 235 && pixel.g > 235 && pixel.b > 235;
                    if (isVisible)
                    {
                        visible++;
                    }
                    if (isWhite)
                    {
                        whiteish++;
                        row++;
                    }
                    whiteIntegral[x + 1, y + 1] = whiteIntegral[x + 1, y] + row;
                }
            }
            summary.visiblePixelCount = visible;
            summary.whiteishPixelCount = whiteish;
            summary.whiteishVisibleRatio = visible > 0 ? (float)whiteish / visible : 0f;
        }

        private static int IntegralSum(int[,] integral, int x0, int y0, int x1, int y1)
        {
            return integral[x1, y1] - integral[x0, y1] - integral[x1, y0] + integral[x0, y0];
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

        private static GameObject CreateCaptureCamera(out Camera camera)
        {
            var cameraGo = new GameObject("GuildMainWhitePanelTraceCamera", typeof(Camera));
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

        private static void WriteOutputs(TraceSummary summary)
        {
            var projectRoot = Directory.GetParent(Application.dataPath).FullName;
            var jsonPath = Path.Combine(projectRoot, OutputJsonPath.Replace('/', Path.DirectorySeparatorChar));
            var csvPath = Path.Combine(projectRoot, OutputCsvPath.Replace('/', Path.DirectorySeparatorChar));
            Directory.CreateDirectory(Path.GetDirectoryName(jsonPath));
            Directory.CreateDirectory(Path.GetDirectoryName(csvPath));
            File.WriteAllText(jsonPath, JsonUtility.ToJson(summary, true), new UTF8Encoding(false));
            WriteCsv(csvPath, summary.topWhiteVisibleImages);
            AssetDatabase.ImportAsset(OutputJsonPath);
            AssetDatabase.ImportAsset(OutputCsvPath);
        }

        private static void WriteCsv(string path, List<ImageTraceRow> rows)
        {
            var sb = new StringBuilder();
            sb.AppendLine("rank,hierarchy_path,active_in_hierarchy,sibling_index,component_type,mono_behaviour_types,missing_script_count_on_object,canvas_sorting_order,canvas_override_sorting,canvas_render_mode,screen_min_x,screen_min_y,screen_max_x,screen_max_y,screen_pixel_area,screen_whiteish_pixel_count,screen_whiteish_ratio,sprite_name,sprite_local_id,sprite_texture_name,sprite_texture_width,sprite_texture_height,sprite_rect_x,sprite_rect_y,sprite_rect_width,sprite_rect_height,material_name,material_local_id,shader_name,render_queue,material_for_rendering_name,material_for_rendering_shader_name,color,alpha,raycast_target,image_type,preserve_aspect,fill_center,fill_method,fill_amount,fill_clockwise,fill_origin,pixels_per_unit_multiplier,reason_class");
            foreach (var row in rows)
            {
                var values = new[]
                {
                    row.rank.ToString(CultureInfo.InvariantCulture),
                    row.hierarchyPath,
                    row.activeInHierarchy ? "1" : "0",
                    row.siblingIndex.ToString(CultureInfo.InvariantCulture),
                    row.componentType,
                    row.monoBehaviourTypes,
                    row.missingScriptCountOnObject.ToString(CultureInfo.InvariantCulture),
                    row.canvasSortingOrder.ToString(CultureInfo.InvariantCulture),
                    row.canvasOverrideSorting ? "1" : "0",
                    row.canvasRenderMode,
                    Float(row.screenMinX),
                    Float(row.screenMinY),
                    Float(row.screenMaxX),
                    Float(row.screenMaxY),
                    row.screenPixelArea.ToString(CultureInfo.InvariantCulture),
                    row.screenWhiteishPixelCount.ToString(CultureInfo.InvariantCulture),
                    row.screenWhiteishRatio.ToString("0.0000", CultureInfo.InvariantCulture),
                    row.spriteName,
                    row.spriteLocalId.ToString(CultureInfo.InvariantCulture),
                    row.spriteTextureName,
                    row.spriteTextureWidth.ToString(CultureInfo.InvariantCulture),
                    row.spriteTextureHeight.ToString(CultureInfo.InvariantCulture),
                    Float(row.spriteRectX),
                    Float(row.spriteRectY),
                    Float(row.spriteRectWidth),
                    Float(row.spriteRectHeight),
                    row.materialName,
                    row.materialLocalId.ToString(CultureInfo.InvariantCulture),
                    row.shaderName,
                    row.renderQueue.ToString(CultureInfo.InvariantCulture),
                    row.materialForRenderingName,
                    row.materialForRenderingShaderName,
                    row.color,
                    row.alpha.ToString("0.###", CultureInfo.InvariantCulture),
                    row.raycastTarget ? "1" : "0",
                    row.imageType,
                    row.preserveAspect ? "1" : "0",
                    row.fillCenter ? "1" : "0",
                    row.fillMethod,
                    row.fillAmount.ToString("0.###", CultureInfo.InvariantCulture),
                    row.fillClockwise ? "1" : "0",
                    row.fillOrigin.ToString(CultureInfo.InvariantCulture),
                    row.pixelsPerUnitMultiplier.ToString("0.###", CultureInfo.InvariantCulture),
                    row.reasonClass
                };
                sb.AppendLine(string.Join(",", values.Select(EscapeCsv)));
            }
            File.WriteAllText(path, sb.ToString(), new UTF8Encoding(false));
        }

        private static string BuildPath(Transform root, Transform current)
        {
            var names = new List<string>();
            var walker = current;
            while (walker != null)
            {
                names.Add(walker.name);
                if (walker == root)
                {
                    break;
                }
                walker = walker.parent;
            }
            names.Reverse();
            return string.Join("/", names);
        }

        private static string Float(float value)
        {
            return value.ToString("0.###", CultureInfo.InvariantCulture);
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
