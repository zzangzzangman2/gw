using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Text;
using UnityEditor;
using UnityEditor.Events;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using TMPro;

namespace GirlsWarRestore
{
    public static class MainInterfaceSceneBuilder
    {
        private const string RectCsv = "Assets/RestoreData/maininterface_rects.csv";
        private const string ButtonCsv = "Assets/RestoreData/maininterface_buttons.csv";
        private const string HandlerCsv = "Assets/RestoreData/reports/maininterface_button_lua_handler_join.csv";
        private const string NavigationMapCsv = "Assets/RestoreData/reports/maininterface_button_navigation_map.csv";
        private const string SpriteCsv = "Assets/RestoreData/maininterface_sprite_map.csv";
        private const string TextCsv = "Assets/RestoreData/maininterface_text_components.csv";
        private const string TmpTextDetailsCsv = "Assets/RestoreData/maininterface_text_tmp_details.csv";
        private const string TmpSharedMaterialsCsv = "Assets/RestoreData/reports/maininterface_tmp_shared_materials.csv";
        private const string ActiveTmpVariantFontSummaryCsv = "Assets/RestoreData/reports/maininterface_active_tmp_variant_font_summary.csv";
        private const string ScrollCsv = "Assets/RestoreData/maininterface_scrollrects.csv";
        private const string OverrideCsv = "Assets/RestoreData/maininterface_raycast_overrides.csv";
        private const string VisualOverrideCsv = "Assets/RestoreData/maininterface_visual_overrides.csv";
        private const string RouteRectOverrideCsv = "Assets/RestoreData/maininterface_route_rect_overrides.csv";
        private const string ScenePath = "Assets/Scenes/MainInterface_Wireframe.unity";
        private const string MainPrefabRootRectId = "5568884429252053541";
        private const bool AddDebugLabels = false;
        private const float ReferenceWidth = 1680f;
        private const float ReferenceHeight = 720f;
        private static Dictionary<string, string> sharedMaterialNameByPathId;
        private static Dictionary<string, string> activeVariantStaticAssetByName;

        private sealed class RectRow
        {
            public string pathId;
            public string gameObjectId;
            public string name;
            public bool active;
            public string fatherId;
            public string[] childIds;
            public Vector2 anchorMin;
            public Vector2 anchorMax;
            public Vector2 anchoredPosition;
            public Vector2 sizeDelta;
            public Vector2 pivot;
            public Vector3 localPosition;
            public Vector3 localScale;
        }

        private sealed class ButtonRow
        {
            public string componentPathId;
            public string gameObjectId;
            public string name;
            public bool interactable;
            public string targetGraphic;
            public string transition;
        }

        private sealed class ButtonHandlerRow
        {
            public string componentPathId;
            public string module;
            public string handler;
            public string confidence;
            public string eventName;
        }

        private sealed class ButtonNavigationRow
        {
            public string componentPathId;
            public string handler;
            public string kind;
            public string targetKey;
            public string targetUiForm;
            public string targetPrefabBundle;
            public string confidence;
        }

        private sealed class SpriteRow
        {
            public string componentPathId;
            public string gameObjectId;
            public string name;
            public string assetPath;
            public string status;
            public bool raycastTarget;
            public bool preserveAspect;
            public int imageType;
            public Color color;
        }

        private sealed class TextRow
        {
            public string componentPathId;
            public string gameObjectId;
            public string name;
            public string scriptId;
            public string text;
            public int fontSize;
            public int alignment;
            public bool raycastTarget;
            public Color color;
        }

        private sealed class TmpTextDetailRow
        {
            public string componentPathId;
            public string fontAssetPathId;
            public string fontAssetName;
            public string fontFamily;
            public string fontAssetBundle;
            public string sharedMaterialPathId;
            public float fontSize;
            public float fontSizeMin;
            public float fontSizeMax;
            public int fontWeight;
            public int fontStyle;
            public bool enableAutoSizing;
            public int resolvedAlignment;
            public float characterSpacing;
            public float wordSpacing;
            public float lineSpacing;
            public float paragraphSpacing;
            public bool enableWordWrapping;
            public float wordWrappingRatios;
            public int overflowMode;
            public bool enableKerning;
            public bool enableExtraPadding;
            public bool isRichText;
            public bool parseCtrlCharacters;
            public bool isRightToLeft;
            public Vector4 margin;
            public Color fontColor;
            public bool hasFontColor;
        }

        private sealed class TmpFontSpec
        {
            public string assetName;
            public string sourceFontPath;
            public string fontAssetPath;
            public string staticFontAssetPath;
            public int atlasWidth;
            public int atlasHeight;
            public int expectedStaticGlyphCount;
            public int expectedStaticCharacterCount;
        }

        private sealed class RectOverrideRow
        {
            public string rectPathId;
            public string gameObjectId;
            public string gameObjectName;
            public bool setAnchoredPosition;
            public Vector2 anchoredPosition;
            public bool setSizeDelta;
            public Vector2 sizeDelta;
            public bool setLocalScale;
            public Vector3 localScale;
            public string reason;
        }

        private sealed class ScrollRow
        {
            public string componentPathId;
            public string gameObjectId;
            public string name;
            public string contentRectId;
            public string viewportRectId;
            public bool horizontal;
            public bool vertical;
            public int movementType;
            public float elasticity;
            public bool inertia;
        }

        private sealed class OverrideRow
        {
            public string targetKind;
            public string componentPathId;
            public string gameObjectId;
            public string name;
            public bool hasActive;
            public bool active;
            public bool hasRaycastTarget;
            public bool raycastTarget;
            public bool hasButtonInteractable;
            public bool buttonInteractable;
            public string reason;
        }

        private sealed class VisualOverrideRow
        {
            public string targetKind;
            public string componentPathId;
            public string gameObjectId;
            public string parentGameObjectId;
            public string createChildName;
            public string name;
            public string spriteAssetPath;
            public bool hasColor;
            public Color color;
            public bool hasPreserveAspect;
            public bool preserveAspect;
            public bool hasImageType;
            public int imageType;
            public bool hasRaycastTarget;
            public bool raycastTarget;
            public bool hasAnchoredPosition;
            public Vector2 anchoredPosition;
            public bool hasSizeDelta;
            public Vector2 sizeDelta;
            public bool hasLocalScale;
            public Vector3 localScale;
            public string reason;
        }

        private sealed class OverrideSet
        {
            public readonly List<OverrideRow> rows = new List<OverrideRow>();
            public readonly Dictionary<string, OverrideRow> byComponentPathId = new Dictionary<string, OverrideRow>();
            public readonly Dictionary<string, OverrideRow> byGameObjectId = new Dictionary<string, OverrideRow>();
        }

        [MenuItem("GirlsWar/Build MainInterface Wireframe")]
        public static void BuildMenu()
        {
            BuildMainInterfaceScene();
        }

        public static void BuildMainInterfaceScene()
        {
            var rows = FilterRowsToRoot(LoadRows(RectCsv), MainPrefabRootRectId);
            if (rows.Count == 0)
                throw new Exception("No RectTransform rows loaded from " + RectCsv);
            var overrides = LoadOverrides(OverrideCsv);
            var visualOverrides = LoadVisualOverrides(VisualOverrideCsv);
            var rectOverrides = LoadRectOverrides(RouteRectOverrideCsv);

            Directory.CreateDirectory("Assets/Scenes");
            var scene = EditorSceneManager.NewScene(NewSceneSetup.EmptyScene, NewSceneMode.Single);
            scene.name = "MainInterface_Wireframe";

            var canvasGo = new GameObject("Canvas_MainInterface_1280x720", typeof(RectTransform), typeof(Canvas), typeof(CanvasScaler), typeof(GraphicRaycaster));
            var canvas = canvasGo.GetComponent<Canvas>();
            canvas.renderMode = RenderMode.ScreenSpaceOverlay;
            var scaler = canvasGo.GetComponent<CanvasScaler>();
            scaler.uiScaleMode = CanvasScaler.ScaleMode.ScaleWithScreenSize;
            scaler.referenceResolution = new Vector2(ReferenceWidth, ReferenceHeight);
            scaler.screenMatchMode = CanvasScaler.ScreenMatchMode.MatchWidthOrHeight;
            scaler.matchWidthOrHeight = 0.5f;

            var canvasRect = canvasGo.GetComponent<RectTransform>();
            canvasRect.anchorMin = Vector2.zero;
            canvasRect.anchorMax = Vector2.one;
            canvasRect.sizeDelta = Vector2.zero;

            var root = new GameObject("MainInterface_Root_From_RectTransform_CSV", typeof(RectTransform));
            var rootRect = root.GetComponent<RectTransform>();
            rootRect.SetParent(canvasRect, false);
            rootRect.anchorMin = Vector2.zero;
            rootRect.anchorMax = Vector2.one;
            rootRect.offsetMin = Vector2.zero;
            rootRect.offsetMax = Vector2.zero;

            var eventSystem = new GameObject("EventSystem", typeof(EventSystem), typeof(StandaloneInputModule));
            eventSystem.transform.SetAsLastSibling();

            var byRectId = new Dictionary<string, RectTransform>();
            var byRowId = new Dictionary<string, RectRow>();
            var byGameObjectId = new Dictionary<string, RectTransform>();

            foreach (var row in rows)
            {
                var goName = string.IsNullOrWhiteSpace(row.name) ? "rect_" + row.pathId : row.name + "__" + row.pathId;
                var go = new GameObject(SafeName(goName), typeof(RectTransform));
                go.SetActive(row.active);
                var rt = go.GetComponent<RectTransform>();
                byRectId[row.pathId] = rt;
                byRowId[row.pathId] = row;
                if (!string.IsNullOrWhiteSpace(row.gameObjectId) && !byGameObjectId.ContainsKey(row.gameObjectId))
                    byGameObjectId[row.gameObjectId] = rt;

                ApplyRectRow(rt, row);
            }

            foreach (var row in rows)
            {
                var rt = byRectId[row.pathId];
                RectTransform parent = rootRect;
                if (!string.IsNullOrWhiteSpace(row.fatherId) && byRectId.TryGetValue(row.fatherId, out var foundParent))
                    parent = foundParent;
                rt.SetParent(parent, false);
                ApplyRectRow(rt, row);
            }

            foreach (var row in rows)
            {
                if (!byRectId.TryGetValue(row.pathId, out var parent))
                    continue;
                for (var i = 0; i < row.childIds.Length; i++)
                {
                    if (byRectId.TryGetValue(row.childIds[i], out var child) && child.parent == parent)
                        child.SetSiblingIndex(i);
                }
            }

            var appliedRectOverrides = ApplyRectOverrides(rectOverrides, byRectId, byGameObjectId);
            var sprites = LoadSprites(SpriteCsv);
            PrepareSpriteImports(sprites);
            PrepareVisualOverrideImports(visualOverrides);
            var activeOverrides = ApplyActiveOverrides(overrides, byGameObjectId);
            var appliedSprites = ApplyImagesAndSprites(sprites, byGameObjectId, overrides);
            var appliedVisualOverrides = ApplyVisualOverrides(visualOverrides, byGameObjectId);
            var textRows = LoadTexts(TextCsv);
            var tmpTextDetails = LoadTmpTextDetails(TmpTextDetailsCsv);
            var textApplyStats = ApplyTexts(textRows, byGameObjectId, tmpTextDetails);
            var scrollRows = LoadScrolls(ScrollCsv);
            var appliedScrolls = ApplyScrollRects(scrollRows, byGameObjectId, byRectId);
            if (AddDebugLabels)
                AddLabels(rows, byRectId);
            var buttons = LoadButtons(ButtonCsv);
            var buttonHandlers = LoadButtonHandlers(HandlerCsv);
            var buttonNavigation = LoadButtonNavigation(NavigationMapCsv);
            var appliedButtons = AddButtonLoggers(buttons, buttonHandlers, buttonNavigation, byGameObjectId, overrides);
            var graphicRaycastOverrides = ApplyGraphicRaycastOverrides(sprites, byGameObjectId, overrides);
            var appliedRaycastProbes = AddRaycastProbeLoggers(sprites, buttons, byGameObjectId);

            EditorSceneManager.SaveScene(scene, ScenePath);
            File.WriteAllText("Assets/RestoreData/maininterface_build_result.json", JsonUtility.ToJson(new BuildResult
            {
                scenePath = ScenePath,
                rectTransformCount = rows.Count,
                imageComponentCount = sprites.Count,
                spriteAppliedCount = appliedSprites,
                textComponentCount = textRows.Count,
                textAppliedCount = textApplyStats.total,
                uguiTextAppliedCount = textApplyStats.ugui,
                tmpTextDetailCount = tmpTextDetails.Count,
                tmpTextAppliedCount = textApplyStats.tmp,
                scrollRectCount = scrollRows.Count,
                scrollRectAppliedCount = appliedScrolls,
                buttonLogCount = appliedButtons,
                raycastProbeCount = appliedRaycastProbes,
                activeOverrideCount = activeOverrides,
                graphicRaycastOverrideCount = graphicRaycastOverrides,
                restoreOverrideCount = overrides.rows.Count,
                rectOverrideCount = appliedRectOverrides,
                visualOverrideCount = appliedVisualOverrides,
                generatedAt = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")
            }, true), Encoding.UTF8);
            AssetDatabase.Refresh();
            Debug.Log("[GirlsWarRestore] MainInterface restored scene generated: " + rows.Count
                + " RectTransforms, " + appliedSprites + " sprites, " + textApplyStats.total
                + " texts (" + textApplyStats.tmp + " TMP, " + textApplyStats.ugui + " UGUI), "
                + appliedScrolls + " scroll rects, " + appliedRaycastProbes
                + " raycast probes, " + activeOverrides + " active overrides, "
                + graphicRaycastOverrides + " graphic raycast overrides, "
                + appliedRectOverrides + " rect overrides, "
                + appliedVisualOverrides + " visual overrides -> " + ScenePath);
        }

        [MenuItem("GirlsWar/Capture MainInterface Restored")]
        public static void CaptureMainInterfaceScene()
        {
            if (!File.Exists(ScenePath))
                BuildMainInterfaceScene();

            EditorSceneManager.OpenScene(ScenePath, OpenSceneMode.Single);
            var canvas = UnityEngine.Object.FindFirstObjectByType<Canvas>();
            if (canvas == null)
                throw new Exception("Capture failed: Canvas not found in " + ScenePath);

            Directory.CreateDirectory("Assets/RestoreCaptures");
            var capturePath = "Assets/RestoreCaptures/maininterface_restored_" + (int)ReferenceWidth + "x" + (int)ReferenceHeight + ".png";
            var resultPath = "Assets/RestoreCaptures/maininterface_capture_result.json";

            var cameraGo = new GameObject("MainInterface_CaptureCamera", typeof(Camera));
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

            var renderTexture = new RenderTexture((int)ReferenceWidth, (int)ReferenceHeight, 24, RenderTextureFormat.ARGB32);
            var previous = RenderTexture.active;
            camera.targetTexture = renderTexture;
            RenderTexture.active = renderTexture;
            GL.Clear(true, true, new Color(0f, 0f, 0f, 0f));
            Canvas.ForceUpdateCanvases();
            camera.Render();

            var texture = new Texture2D((int)ReferenceWidth, (int)ReferenceHeight, TextureFormat.RGBA32, false);
            texture.ReadPixels(new Rect(0, 0, ReferenceWidth, ReferenceHeight), 0, 0);
            texture.Apply();
            File.WriteAllBytes(capturePath, texture.EncodeToPNG());

            var visiblePixels = 0;
            foreach (var pixel in texture.GetPixels32())
            {
                if (pixel.a > 0 && (pixel.r > 0 || pixel.g > 0 || pixel.b > 0))
                    visiblePixels++;
            }

            RenderTexture.active = previous;
            camera.targetTexture = null;
            UnityEngine.Object.DestroyImmediate(renderTexture);
            UnityEngine.Object.DestroyImmediate(texture);
            UnityEngine.Object.DestroyImmediate(cameraGo);

            File.WriteAllText(resultPath, JsonUtility.ToJson(new CaptureResult
            {
                capturePath = capturePath,
                width = (int)ReferenceWidth,
                height = (int)ReferenceHeight,
                visiblePixelCount = visiblePixels,
                generatedAt = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")
            }, true), Encoding.UTF8);
            AssetDatabase.Refresh();
            Debug.Log("[GirlsWarRestore] MainInterface capture saved: " + capturePath + " visiblePixels=" + visiblePixels);
        }

        private static void AddLabels(List<RectRow> rows, Dictionary<string, RectTransform> byRectId)
        {
            var font = Resources.GetBuiltinResource<Font>("LegacyRuntime.ttf");
            var labelCount = 0;
            foreach (var row in rows)
            {
                if (labelCount >= 350)
                    break;
                if (string.IsNullOrWhiteSpace(row.name))
                    continue;
                if (Mathf.Abs(row.sizeDelta.x) < 40f || Mathf.Abs(row.sizeDelta.y) < 18f)
                    continue;
                var parent = byRectId[row.pathId];
                var label = new GameObject("label__" + SafeName(row.name), typeof(RectTransform), typeof(Text));
                var rt = label.GetComponent<RectTransform>();
                rt.SetParent(parent, false);
                rt.anchorMin = Vector2.zero;
                rt.anchorMax = Vector2.one;
                rt.offsetMin = Vector2.zero;
                rt.offsetMax = Vector2.zero;
                var text = label.GetComponent<Text>();
                text.text = row.name;
                text.font = font;
                text.fontSize = 10;
                text.color = new Color(0.05f, 0.05f, 0.05f, 0.55f);
                text.alignment = TextAnchor.MiddleCenter;
                text.raycastTarget = false;
                labelCount++;
            }
        }

        private static void ApplyRectRow(RectTransform rt, RectRow row)
        {
            if (row.pathId == MainPrefabRootRectId)
            {
                rt.anchorMin = Vector2.zero;
                rt.anchorMax = Vector2.one;
                rt.pivot = new Vector2(0.5f, 0.5f);
                rt.offsetMin = Vector2.zero;
                rt.offsetMax = Vector2.zero;
                rt.localScale = Vector3.one;
                rt.localRotation = Quaternion.identity;
                var fullRootPosition = rt.localPosition;
                fullRootPosition.z = row.localPosition.z;
                rt.localPosition = fullRootPosition;
                return;
            }

            rt.anchorMin = row.anchorMin;
            rt.anchorMax = row.anchorMax;
            rt.pivot = row.pivot;
            rt.sizeDelta = row.sizeDelta;
            rt.anchoredPosition = row.anchoredPosition;
            rt.localScale = row.localScale == Vector3.zero ? Vector3.one : row.localScale;
            rt.localRotation = Quaternion.identity;
            var lp = rt.localPosition;
            lp.z = row.localPosition.z;
            rt.localPosition = lp;
        }

        private static void PrepareSpriteImports(List<SpriteRow> sprites)
        {
            AssetDatabase.Refresh();
            var seen = new HashSet<string>();
            var changed = 0;
            foreach (var row in sprites)
            {
                if (!string.Equals(row.status, "ready", StringComparison.OrdinalIgnoreCase))
                    continue;
                if (string.IsNullOrWhiteSpace(row.assetPath) || !seen.Add(row.assetPath))
                    continue;
                var importer = AssetImporter.GetAtPath(row.assetPath) as TextureImporter;
                if (importer == null)
                    continue;
                var dirty = false;
                if (importer.textureType != TextureImporterType.Sprite)
                {
                    importer.textureType = TextureImporterType.Sprite;
                    dirty = true;
                }
                if (importer.spriteImportMode != SpriteImportMode.Single)
                {
                    importer.spriteImportMode = SpriteImportMode.Single;
                    dirty = true;
                }
                if (!importer.alphaIsTransparency)
                {
                    importer.alphaIsTransparency = true;
                    dirty = true;
                }
                if (dirty)
                {
                    importer.SaveAndReimport();
                    changed++;
                }
            }
            Debug.Log("[GirlsWarRestore] Prepared sprite imports: " + seen.Count + " assets, changed " + changed);
        }

        private static void PrepareVisualOverrideImports(List<VisualOverrideRow> rows)
        {
            AssetDatabase.Refresh();
            var changed = 0;
            foreach (var row in rows)
            {
                if (string.IsNullOrWhiteSpace(row.spriteAssetPath))
                    continue;
                var importer = AssetImporter.GetAtPath(row.spriteAssetPath) as TextureImporter;
                if (importer == null)
                    continue;
                var dirty = false;
                if (importer.textureType != TextureImporterType.Sprite)
                {
                    importer.textureType = TextureImporterType.Sprite;
                    dirty = true;
                }
                if (importer.spriteImportMode != SpriteImportMode.Single)
                {
                    importer.spriteImportMode = SpriteImportMode.Single;
                    dirty = true;
                }
                if (!importer.alphaIsTransparency)
                {
                    importer.alphaIsTransparency = true;
                    dirty = true;
                }
                if (dirty)
                {
                    importer.SaveAndReimport();
                    changed++;
                }
            }
            Debug.Log("[GirlsWarRestore] Prepared visual override sprite imports: " + rows.Count + " rows, changed " + changed);
        }

        private static int ApplyActiveOverrides(OverrideSet overrides, Dictionary<string, RectTransform> byGameObjectId)
        {
            var applied = 0;
            foreach (var row in overrides.rows)
            {
                if (!row.hasActive || string.IsNullOrWhiteSpace(row.gameObjectId))
                    continue;
                if (!byGameObjectId.TryGetValue(row.gameObjectId, out var rt))
                    continue;
                rt.gameObject.SetActive(row.active);
                applied++;
            }
            Debug.Log("[GirlsWarRestore] Applied active overrides: " + applied + "/" + overrides.rows.Count);
            return applied;
        }

        private static int ApplyImagesAndSprites(
            List<SpriteRow> sprites,
            Dictionary<string, RectTransform> byGameObjectId,
            OverrideSet overrides)
        {
            var applied = 0;
            foreach (var row in sprites)
            {
                if (!byGameObjectId.TryGetValue(row.gameObjectId, out var rt))
                    continue;
                var image = rt.GetComponent<Image>();
                if (image == null)
                    image = rt.gameObject.AddComponent<Image>();

                var raycastTarget = row.raycastTarget;
                if (TryGetOverride(overrides, row.componentPathId, row.gameObjectId, out var overrideRow)
                    && overrideRow.hasRaycastTarget)
                {
                    raycastTarget = overrideRow.raycastTarget;
                }
                image.raycastTarget = raycastTarget;
                image.preserveAspect = row.preserveAspect;
                image.type = ToImageType(row.imageType);
                image.color = Transparent(row.color);

                if (!string.Equals(row.status, "ready", StringComparison.OrdinalIgnoreCase)
                    || string.IsNullOrWhiteSpace(row.assetPath))
                    continue;

                var sprite = AssetDatabase.LoadAssetAtPath<Sprite>(row.assetPath);
                if (sprite == null)
                {
                    Debug.LogWarning("[GirlsWarRestore] Sprite import missing: " + row.assetPath + " for " + row.name);
                    continue;
                }
                image.sprite = sprite;
                image.color = row.color;
                applied++;
            }
            Debug.Log("[GirlsWarRestore] Applied sprites: " + applied + "/" + sprites.Count);
            return applied;
        }

        private static int ApplyVisualOverrides(
            List<VisualOverrideRow> rows,
            Dictionary<string, RectTransform> byGameObjectId)
        {
            var applied = 0;
            foreach (var row in rows)
            {
                RectTransform rt = null;
                if (!string.IsNullOrWhiteSpace(row.gameObjectId))
                    byGameObjectId.TryGetValue(row.gameObjectId, out rt);
                if (rt == null && !string.IsNullOrWhiteSpace(row.parentGameObjectId) && !string.IsNullOrWhiteSpace(row.createChildName))
                {
                    if (!byGameObjectId.TryGetValue(row.parentGameObjectId, out var parent))
                        continue;
                    var child = new GameObject(SafeName(row.createChildName), typeof(RectTransform), typeof(Image));
                    rt = child.GetComponent<RectTransform>();
                    rt.SetParent(parent, false);
                    rt.anchorMin = new Vector2(0.5f, 0.5f);
                    rt.anchorMax = new Vector2(0.5f, 0.5f);
                    rt.pivot = new Vector2(0.5f, 0.5f);
                    rt.anchoredPosition = Vector2.zero;
                    rt.sizeDelta = parent.sizeDelta;
                    rt.localScale = Vector3.one;
                }
                if (rt == null)
                    continue;

                if (row.hasAnchoredPosition)
                    rt.anchoredPosition = row.anchoredPosition;
                if (row.hasSizeDelta)
                    rt.sizeDelta = row.sizeDelta;
                if (row.hasLocalScale)
                    rt.localScale = row.localScale;

                var image = rt.GetComponent<Image>();
                if (image == null)
                    image = rt.gameObject.AddComponent<Image>();

                if (!string.IsNullOrWhiteSpace(row.spriteAssetPath))
                {
                    var sprite = AssetDatabase.LoadAssetAtPath<Sprite>(row.spriteAssetPath);
                    if (sprite == null)
                    {
                        Debug.LogWarning("[GirlsWarRestore] Visual override sprite import missing: " + row.spriteAssetPath + " for " + row.name);
                        continue;
                    }
                    image.sprite = sprite;
                }

                if (row.hasColor)
                    image.color = row.color;
                if (row.hasPreserveAspect)
                    image.preserveAspect = row.preserveAspect;
                if (row.hasImageType)
                    image.type = ToImageType(row.imageType);
                if (row.hasRaycastTarget)
                    image.raycastTarget = row.raycastTarget;
                applied++;
            }
            Debug.Log("[GirlsWarRestore] Applied visual overrides: " + applied + "/" + rows.Count);
            return applied;
        }

        private static int ApplyRectOverrides(
            List<RectOverrideRow> rows,
            Dictionary<string, RectTransform> byRectId,
            Dictionary<string, RectTransform> byGameObjectId)
        {
            var applied = 0;
            foreach (var row in rows)
            {
                RectTransform rt = null;
                if (!string.IsNullOrWhiteSpace(row.rectPathId))
                    byRectId.TryGetValue(row.rectPathId, out rt);
                if (rt == null && !string.IsNullOrWhiteSpace(row.gameObjectId))
                    byGameObjectId.TryGetValue(row.gameObjectId, out rt);
                if (rt == null)
                    continue;

                if (row.setAnchoredPosition)
                    rt.anchoredPosition = row.anchoredPosition;
                if (row.setSizeDelta)
                    rt.sizeDelta = row.sizeDelta;
                if (row.setLocalScale)
                    rt.localScale = row.localScale;
                applied++;
            }
            Debug.Log("[GirlsWarRestore] Applied route rect overrides: " + applied + "/" + rows.Count);
            return applied;
        }

        private struct TextApplyStats
        {
            public int total;
            public int ugui;
            public int tmp;
        }

        private static TextApplyStats ApplyTexts(
            List<TextRow> textRows,
            Dictionary<string, RectTransform> byGameObjectId,
            Dictionary<string, TmpTextDetailRow> tmpTextDetails)
        {
            var stats = new TextApplyStats();
            var font = GetRestoreFont();
            var tmpFontCharacterSets = BuildTmpFontCharacterSets(textRows, tmpTextDetails);
            var tmpFontCache = new Dictionary<string, TMP_FontAsset>();
            foreach (var row in textRows)
            {
                if (!byGameObjectId.TryGetValue(row.gameObjectId, out var rt))
                    continue;

                if (tmpTextDetails.TryGetValue(row.componentPathId, out var tmpDetail))
                {
                    var tmpText = GetOrCreateTmpText(rt, row);
                    tmpText.text = row.text ?? "";
                    var variantTmpFont = GetSharedMaterialVariantTmpFont(tmpDetail);
                    var tmpFontKey = variantTmpFont != null ? "variant:" + tmpDetail.sharedMaterialPathId : GetTmpFontCacheKey(tmpDetail);
                    if (variantTmpFont != null)
                    {
                        tmpFontCache[tmpFontKey] = variantTmpFont;
                    }
                    if (!tmpFontCache.TryGetValue(tmpFontKey, out var tmpFont))
                    {
                        tmpFont = GetRestoreTmpFont(tmpDetail, tmpFontCharacterSets);
                        tmpFontCache[tmpFontKey] = tmpFont;
                    }
                    if (tmpFont != null)
                        tmpText.font = tmpFont;
                    var sharedMaterial = variantTmpFont == null ? GetTmpSharedMaterial(tmpDetail) : null;
                    if (sharedMaterial != null)
                        tmpText.fontSharedMaterial = sharedMaterial;
                    tmpText.fontSize = Mathf.Max(1f, tmpDetail.fontSize > 0f ? tmpDetail.fontSize : row.fontSize);
                    tmpText.fontSizeMin = Mathf.Max(1f, tmpDetail.fontSizeMin);
                    tmpText.fontSizeMax = Mathf.Max(tmpText.fontSize, tmpDetail.fontSizeMax);
                    tmpText.enableAutoSizing = tmpDetail.enableAutoSizing;
                    tmpText.alignment = ToTmpAlignment(tmpDetail.resolvedAlignment, row.alignment);
                    tmpText.fontStyle = (FontStyles)tmpDetail.fontStyle;
                    tmpText.fontWeight = (FontWeight)tmpDetail.fontWeight;
                    tmpText.characterSpacing = tmpDetail.characterSpacing;
                    tmpText.wordSpacing = tmpDetail.wordSpacing;
                    tmpText.lineSpacing = tmpDetail.lineSpacing;
                    tmpText.paragraphSpacing = tmpDetail.paragraphSpacing;
                    tmpText.enableWordWrapping = tmpDetail.enableWordWrapping;
                    tmpText.wordWrappingRatios = tmpDetail.wordWrappingRatios;
                    tmpText.overflowMode = ToTextOverflowMode(tmpDetail.overflowMode);
                    tmpText.enableKerning = tmpDetail.enableKerning;
                    tmpText.extraPadding = tmpDetail.enableExtraPadding;
                    tmpText.richText = tmpDetail.isRichText;
                    tmpText.parseCtrlCharacters = tmpDetail.parseCtrlCharacters;
                    tmpText.isRightToLeftText = tmpDetail.isRightToLeft;
                    tmpText.margin = tmpDetail.margin;
                    tmpText.color = tmpDetail.hasFontColor ? tmpDetail.fontColor : row.color;
                    tmpText.raycastTarget = row.raycastTarget;
                    tmpText.name = tmpText.name + "__font_" + SafeName(tmpDetail.fontAssetName);
                    stats.tmp++;
                    stats.total++;
                    continue;
                }

                var text = rt.GetComponent<Text>();
                if (text == null)
                {
                    if (rt.GetComponent<Graphic>() != null)
                    {
                        var child = new GameObject("text__" + SafeName(row.name) + "__" + row.componentPathId, typeof(RectTransform), typeof(Text));
                        var childRt = child.GetComponent<RectTransform>();
                        childRt.SetParent(rt, false);
                        childRt.anchorMin = Vector2.zero;
                        childRt.anchorMax = Vector2.one;
                        childRt.offsetMin = Vector2.zero;
                        childRt.offsetMax = Vector2.zero;
                        text = child.GetComponent<Text>();
                    }
                    else
                    {
                        text = rt.gameObject.AddComponent<Text>();
                    }
                }
                text.text = row.text ?? "";
                text.font = font;
                text.fontSize = Mathf.Max(1, row.fontSize);
                text.alignment = ToTextAnchor(row.alignment);
                text.color = row.color;
                text.raycastTarget = row.raycastTarget;
                text.supportRichText = true;
                text.horizontalOverflow = HorizontalWrapMode.Overflow;
                text.verticalOverflow = VerticalWrapMode.Overflow;
                stats.ugui++;
                stats.total++;
            }
            Debug.Log("[GirlsWarRestore] Applied texts: " + stats.total + "/" + textRows.Count
                + " (TMP " + stats.tmp + "/" + tmpTextDetails.Count + ", UGUI " + stats.ugui + ")");
            return stats;
        }

        private static string GetTmpFontCacheKey(TmpTextDetailRow detail)
        {
            var spec = GetOriginalTmpFontSpec(detail);
            if (spec != null)
                return spec.assetName;
            return "fallback";
        }

        private static Dictionary<string, string> BuildTmpFontCharacterSets(
            List<TextRow> textRows,
            Dictionary<string, TmpTextDetailRow> tmpTextDetails)
        {
            var builders = new Dictionary<string, StringBuilder>();
            foreach (var row in textRows)
            {
                if (!tmpTextDetails.TryGetValue(row.componentPathId, out var detail))
                    continue;
                var spec = GetOriginalTmpFontSpec(detail);
                if (spec == null)
                    continue;
                if (!builders.TryGetValue(spec.assetName, out var builder))
                {
                    builder = new StringBuilder();
                    builders[spec.assetName] = builder;
                }
                AppendUniqueCharacters(builder, row.text ?? "");
            }

            var result = new Dictionary<string, string>();
            foreach (var pair in builders)
                result[pair.Key] = pair.Value.ToString();
            return result;
        }

        private static void AppendUniqueCharacters(StringBuilder builder, string text)
        {
            for (var i = 0; i < text.Length; i++)
            {
                var c = text[i];
                if (builder.ToString().IndexOf(c) < 0)
                    builder.Append(c);
            }
        }

        private static TextMeshProUGUI GetOrCreateTmpText(RectTransform rt, TextRow row)
        {
            var tmp = rt.GetComponent<TextMeshProUGUI>();
            if (tmp != null)
                return tmp;

            var legacy = rt.GetComponent<Text>();
            if (legacy != null)
                UnityEngine.Object.DestroyImmediate(legacy);

            if (rt.GetComponent<Graphic>() != null)
            {
                var child = new GameObject("tmp__" + SafeName(row.name) + "__" + row.componentPathId, typeof(RectTransform), typeof(TextMeshProUGUI));
                var childRt = child.GetComponent<RectTransform>();
                childRt.SetParent(rt, false);
                childRt.anchorMin = Vector2.zero;
                childRt.anchorMax = Vector2.one;
                childRt.offsetMin = Vector2.zero;
                childRt.offsetMax = Vector2.zero;
                return child.GetComponent<TextMeshProUGUI>();
            }

            return rt.gameObject.AddComponent<TextMeshProUGUI>();
        }

        private static Font GetRestoreFont()
        {
            var font = Font.CreateDynamicFontFromOSFont(new[] {"Malgun Gothic", "Arial"}, 16);
            return font != null ? font : Resources.GetBuiltinResource<Font>("LegacyRuntime.ttf");
        }

        private static TMP_FontAsset GetRestoreTmpFont(
            TmpTextDetailRow detail,
            Dictionary<string, string> tmpFontCharacterSets)
        {
            return GetOriginalTmpFont(detail, tmpFontCharacterSets) ?? GetFallbackTmpFont();
        }

        private static TMP_FontAsset GetSharedMaterialVariantTmpFont(TmpTextDetailRow detail)
        {
            if (string.IsNullOrWhiteSpace(detail.sharedMaterialPathId) || detail.sharedMaterialPathId == "0")
                return null;
            var materialNames = GetSharedMaterialNameByPathId();
            if (!materialNames.TryGetValue(detail.sharedMaterialPathId, out var materialName) || string.IsNullOrWhiteSpace(materialName))
                return null;
            var variants = GetActiveVariantStaticAssetByName();
            if (!variants.TryGetValue(materialName, out var assetPath) || string.IsNullOrWhiteSpace(assetPath))
                return null;
            return AssetDatabase.LoadAssetAtPath<TMP_FontAsset>(assetPath);
        }

        private static Dictionary<string, string> GetSharedMaterialNameByPathId()
        {
            if (sharedMaterialNameByPathId != null)
                return sharedMaterialNameByPathId;
            sharedMaterialNameByPathId = new Dictionary<string, string>();
            foreach (var row in LoadCsv(TmpSharedMaterialsCsv))
            {
                var pathId = Get(row, "shared_material_path_id");
                var name = Get(row, "material_name");
                if (!string.IsNullOrWhiteSpace(pathId) && !string.IsNullOrWhiteSpace(name))
                    sharedMaterialNameByPathId[pathId] = name;
            }
            return sharedMaterialNameByPathId;
        }

        private static Dictionary<string, string> GetActiveVariantStaticAssetByName()
        {
            if (activeVariantStaticAssetByName != null)
                return activeVariantStaticAssetByName;
            activeVariantStaticAssetByName = new Dictionary<string, string>();
            foreach (var row in LoadCsv(ActiveTmpVariantFontSummaryCsv))
            {
                var name = Get(row, "font_key");
                var assetPath = Get(row, "static_asset_path");
                if (!string.IsNullOrWhiteSpace(name) && !string.IsNullOrWhiteSpace(assetPath) && File.Exists(assetPath))
                    activeVariantStaticAssetByName[name] = assetPath;
            }
            return activeVariantStaticAssetByName;
        }

        private static Material GetTmpSharedMaterial(TmpTextDetailRow detail)
        {
            if (string.IsNullOrWhiteSpace(detail.sharedMaterialPathId) || detail.sharedMaterialPathId == "0")
                return null;
            var materialPath = TmpSharedMaterialBuilder.MaterialAssetPath(detail.sharedMaterialPathId);
            if (string.IsNullOrWhiteSpace(materialPath))
                return null;
            var material = AssetDatabase.LoadAssetAtPath<Material>(materialPath);
            if (material != null)
                return material;

            TmpSharedMaterialBuilder.BuildAll();
            return AssetDatabase.LoadAssetAtPath<Material>(materialPath);
        }

        private static TMP_FontAsset GetOriginalTmpFont(
            TmpTextDetailRow detail,
            Dictionary<string, string> tmpFontCharacterSets)
        {
            var spec = GetOriginalTmpFontSpec(detail);
            if (spec == null)
                return null;
            EnsureTmpEssentialResources();
            TMP_Settings.LoadDefaultSettings();
            tmpFontCharacterSets.TryGetValue(spec.assetName, out var preloadCharacters);
            return GetOrCreateTmpFontAsset(spec, preloadCharacters ?? "", false);
        }

        private static TmpFontSpec GetOriginalTmpFontSpec(TmpTextDetailRow detail)
        {
            var name = (detail.fontAssetName ?? "").Trim();
            var pathId = (detail.fontAssetPathId ?? "").Trim();
            if (name.Equals("riyu", StringComparison.OrdinalIgnoreCase) || pathId == "2268522548353052838")
            {
                return new TmpFontSpec
                {
                    assetName = "GirlsWarOriginal_riyu_TMP",
                    sourceFontPath = "Assets/RestoreData/TMP/original_fonts/riyu_source.ttf",
                    fontAssetPath = "Assets/RestoreData/TMP/original_fonts/GirlsWarOriginal_riyu_TMP.asset",
                    staticFontAssetPath = "Assets/RestoreData/TMP/static_probe/GirlsWarStaticProbe_riyu_TMP.asset",
                    atlasWidth = 2048,
                    atlasHeight = 2048,
                    expectedStaticGlyphCount = 383,
                    expectedStaticCharacterCount = 384
                };
            }
            if (name.Equals("EPM", StringComparison.OrdinalIgnoreCase) || pathId == "-724809986894116682")
            {
                return new TmpFontSpec
                {
                    assetName = "GirlsWarOriginal_EPM_TMP",
                    sourceFontPath = "Assets/RestoreData/TMP/original_fonts/EPM_source.ttf",
                    fontAssetPath = "Assets/RestoreData/TMP/original_fonts/GirlsWarOriginal_EPM_TMP.asset",
                    staticFontAssetPath = "Assets/RestoreData/TMP/static_probe/GirlsWarStaticProbe_EPM_TMP.asset",
                    atlasWidth = 1024,
                    atlasHeight = 2048,
                    expectedStaticGlyphCount = 442,
                    expectedStaticCharacterCount = 444
                };
            }
            if (name.Equals("num", StringComparison.OrdinalIgnoreCase) || pathId == "454391846754054610")
            {
                return new TmpFontSpec
                {
                    assetName = "GirlsWarOriginal_num_TMP",
                    sourceFontPath = "Assets/RestoreData/TMP/original_fonts/num_source.ttf",
                    fontAssetPath = "Assets/RestoreData/TMP/original_fonts/GirlsWarOriginal_num_TMP.asset",
                    staticFontAssetPath = "Assets/RestoreData/TMP/static_probe/GirlsWarStaticProbe_num_TMP.asset",
                    atlasWidth = 256,
                    atlasHeight = 256,
                    expectedStaticGlyphCount = 24,
                    expectedStaticCharacterCount = 24
                };
            }
            return null;
        }

        private static TMP_FontAsset GetFallbackTmpFont()
        {
            const string assetPath = "Assets/RestoreData/TMP/GirlsWarRestore_KoreanFallback_TMP.asset";
            const string projectFontPath = "Assets/RestoreData/TMP/malgun.ttf";
            EnsureTmpEssentialResources();
            TMP_Settings.LoadDefaultSettings();

            var existing = AssetDatabase.LoadAssetAtPath<TMP_FontAsset>(assetPath);
            if (existing != null && HasUsableTmpFontAsset(existing))
                return existing;
            if (existing != null)
            {
                Debug.LogWarning("[GirlsWarRestore] Recreating incomplete TMP fallback font asset: " + assetPath);
                AssetDatabase.DeleteAsset(assetPath);
            }

            Directory.CreateDirectory("Assets/RestoreData/TMP");
            if (!File.Exists(projectFontPath))
            {
                var sourceFontPath = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.Windows), "Fonts", "malgun.ttf");
                if (File.Exists(sourceFontPath))
                    File.Copy(sourceFontPath, projectFontPath, true);
            }
            AssetDatabase.ImportAsset(projectFontPath, ImportAssetOptions.ForceSynchronousImport);
            var sourceFont = AssetDatabase.LoadAssetAtPath<Font>(projectFontPath);
            if (sourceFont == null)
                sourceFont = GetRestoreFont();
            if (sourceFont == null)
                return TMP_Settings.defaultFontAsset;

            return CreateAndSaveTmpFontAsset(
                "GirlsWarRestore_KoreanFallback_TMP",
                sourceFont,
                assetPath,
                2048,
                2048,
                "",
                true);
        }

        private static TMP_FontAsset GetOrCreateTmpFontAsset(TmpFontSpec spec, string preloadCharacters, bool fallbackOnFailure)
        {
            var staticFont = AssetDatabase.LoadAssetAtPath<TMP_FontAsset>(spec.staticFontAssetPath);
            if (HasExpectedStaticTmpFontAsset(staticFont, spec))
                return staticFont;

            var existing = AssetDatabase.LoadAssetAtPath<TMP_FontAsset>(spec.fontAssetPath);
            if (existing != null && HasUsableTmpFontAsset(existing))
            {
                PreloadTmpFontCharacters(existing, preloadCharacters);
                return existing;
            }
            if (existing != null)
            {
                Debug.LogWarning("[GirlsWarRestore] Recreating incomplete original TMP font asset: " + spec.fontAssetPath);
                AssetDatabase.DeleteAsset(spec.fontAssetPath);
            }

            if (!File.Exists(spec.sourceFontPath))
            {
                Debug.LogWarning("[GirlsWarRestore] Original TMP source font missing: " + spec.sourceFontPath);
                return fallbackOnFailure ? GetFallbackTmpFont() : null;
            }
            AssetDatabase.ImportAsset(spec.sourceFontPath, ImportAssetOptions.ForceSynchronousImport);
            var sourceFont = AssetDatabase.LoadAssetAtPath<Font>(spec.sourceFontPath);
            if (sourceFont == null)
            {
                Debug.LogWarning("[GirlsWarRestore] Failed to import original TMP source font: " + spec.sourceFontPath);
                return fallbackOnFailure ? GetFallbackTmpFont() : null;
            }

            return CreateAndSaveTmpFontAsset(
                spec.assetName,
                sourceFont,
                spec.fontAssetPath,
                spec.atlasWidth,
                spec.atlasHeight,
                preloadCharacters,
                fallbackOnFailure);
        }

        private static TMP_FontAsset CreateAndSaveTmpFontAsset(
            string assetName,
            Font sourceFont,
            string assetPath,
            int atlasWidth,
            int atlasHeight,
            string preloadCharacters,
            bool fallbackOnFailure)
        {
            if (Shader.Find("TextMeshPro/Mobile/Distance Field") == null)
                Debug.LogWarning("[GirlsWarRestore] TMP mobile SDF shader is still missing after essential resource import.");

            TMP_FontAsset tmpFont = null;
            try
            {
                tmpFont = TMP_FontAsset.CreateFontAsset(
                    sourceFont,
                    40,
                    9,
                    UnityEngine.TextCore.LowLevel.GlyphRenderMode.SDFAA,
                    atlasWidth,
                    atlasHeight,
                    AtlasPopulationMode.Dynamic,
                    true);
            }
            catch (Exception ex)
            {
                Debug.LogWarning("[GirlsWarRestore] Failed to create TMP font asset " + assetName + ": " + ex.Message);
            }
            if (tmpFont == null)
                return fallbackOnFailure ? TMP_Settings.defaultFontAsset : null;
            tmpFont.name = assetName;
            if (tmpFont.atlasTextures != null && tmpFont.atlasTextures.Length > 0 && tmpFont.atlasTextures[0] != null)
                tmpFont.atlasTextures[0].name = tmpFont.name + " Atlas";
            if (tmpFont.material != null)
                tmpFont.material.name = tmpFont.name + " Material";
            Directory.CreateDirectory(Path.GetDirectoryName(assetPath));
            AssetDatabase.CreateAsset(tmpFont, assetPath);
            if (tmpFont.atlasTextures != null && tmpFont.atlasTextures.Length > 0 && tmpFont.atlasTextures[0] != null)
                AssetDatabase.AddObjectToAsset(tmpFont.atlasTextures[0], tmpFont);
            if (tmpFont.material != null)
                AssetDatabase.AddObjectToAsset(tmpFont.material, tmpFont);
            PreloadTmpFontCharacters(tmpFont, preloadCharacters);
            AssetDatabase.SaveAssets();
            AssetDatabase.ImportAsset(assetPath, ImportAssetOptions.ForceSynchronousImport);
            return AssetDatabase.LoadAssetAtPath<TMP_FontAsset>(assetPath);
        }

        private static void PreloadTmpFontCharacters(TMP_FontAsset fontAsset, string preloadCharacters)
        {
            if (fontAsset == null)
                return;

            SetTmpFontClearDynamicData(fontAsset, false);
            if (string.IsNullOrEmpty(preloadCharacters))
            {
                EditorUtility.SetDirty(fontAsset);
                return;
            }

            try
            {
                fontAsset.TryAddCharacters(preloadCharacters, out var missingCharacters, true);
                if (!string.IsNullOrEmpty(missingCharacters))
                    Debug.LogWarning("[GirlsWarRestore] TMP font " + fontAsset.name + " missing characters: " + missingCharacters);
            }
            catch (Exception ex)
            {
                Debug.LogWarning("[GirlsWarRestore] Failed to preload TMP characters for " + fontAsset.name + ": " + ex.Message);
            }
            EditorUtility.SetDirty(fontAsset);
            if (fontAsset.material != null)
                EditorUtility.SetDirty(fontAsset.material);
            if (fontAsset.atlasTextures != null)
            {
                foreach (var texture in fontAsset.atlasTextures)
                {
                    if (texture != null)
                        EditorUtility.SetDirty(texture);
                }
            }
        }

        private static void SetTmpFontClearDynamicData(TMP_FontAsset fontAsset, bool value)
        {
            var serialized = new SerializedObject(fontAsset);
            var property = serialized.FindProperty("m_ClearDynamicDataOnBuild");
            if (property == null)
                return;
            property.boolValue = value;
            serialized.ApplyModifiedPropertiesWithoutUndo();
        }

        private static bool HasUsableTmpFontAsset(TMP_FontAsset fontAsset)
        {
            return fontAsset != null
                && fontAsset.material != null
                && fontAsset.atlasTextures != null
                && fontAsset.atlasTextures.Length > 0
                && fontAsset.atlasTextures[0] != null;
        }

        private static bool HasExpectedStaticTmpFontAsset(TMP_FontAsset fontAsset, TmpFontSpec spec)
        {
            if (!HasUsableTmpFontAsset(fontAsset))
                return false;
            var glyphCount = fontAsset.glyphTable == null ? 0 : fontAsset.glyphTable.Count;
            var characterCount = fontAsset.characterTable == null ? 0 : fontAsset.characterTable.Count;
            var ok = glyphCount >= spec.expectedStaticGlyphCount && characterCount >= spec.expectedStaticCharacterCount;
            if (!ok)
            {
                Debug.LogWarning("[GirlsWarRestore] Static TMP font asset is present but incomplete: "
                    + spec.staticFontAssetPath + " glyphs=" + glyphCount + " chars=" + characterCount);
            }
            return ok;
        }

        private static void EnsureTmpEssentialResources()
        {
            if (HasTmpEssentialResources())
                return;

            var packageCache = Path.GetFullPath("Library/PackageCache");
            if (Directory.Exists(packageCache))
            {
                foreach (var packageDir in Directory.GetDirectories(packageCache, "com.unity.ugui@*"))
                {
                    var packagePath = Path.Combine(packageDir, "Package Resources", "TMP Essential Resources.unitypackage");
                    if (!File.Exists(packagePath))
                        continue;
                    Debug.Log("[GirlsWarRestore] Importing TMP Essential Resources: " + packagePath);
                    AssetDatabase.ImportPackage(packagePath, false);
                    AssetDatabase.Refresh(ImportAssetOptions.ForceSynchronousImport);
                    break;
                }
            }

            if (HasTmpEssentialResources())
                return;

            const string settingsDir = "Assets/TextMesh Pro/Resources";
            const string settingsPath = settingsDir + "/TMP Settings.asset";
            if (File.Exists(settingsPath))
            {
                Debug.LogWarning("[GirlsWarRestore] TMP Settings exists but TMP font/shader resources are incomplete. Run _restore_tools\\75_IMPORT_TMP_ESSENTIAL_RESOURCES.cmd.");
                return;
            }
            Directory.CreateDirectory(settingsDir);
            var settings = ScriptableObject.CreateInstance<TMP_Settings>();
            AssetDatabase.CreateAsset(settings, settingsPath);
            AssetDatabase.SaveAssets();
            AssetDatabase.Refresh(ImportAssetOptions.ForceSynchronousImport);
            TMP_Settings.LoadDefaultSettings();
            Debug.Log("[GirlsWarRestore] Created minimal TMP Settings asset: " + settingsPath);
        }

        private static bool HasTmpEssentialResources()
        {
            var settings = AssetDatabase.LoadAssetAtPath<TMP_Settings>("Assets/TextMesh Pro/Resources/TMP Settings.asset");
            var defaultFont = AssetDatabase.LoadAssetAtPath<TMP_FontAsset>("Assets/TextMesh Pro/Resources/Fonts & Materials/LiberationSans SDF.asset");
            var mobileSdfShader = AssetDatabase.LoadAssetAtPath<Shader>("Assets/TextMesh Pro/Shaders/TMP_SDF-Mobile.shader");
            return settings != null && defaultFont != null && mobileSdfShader != null;
        }

        private static int ApplyScrollRects(
            List<ScrollRow> scrollRows,
            Dictionary<string, RectTransform> byGameObjectId,
            Dictionary<string, RectTransform> byRectId)
        {
            var applied = 0;
            foreach (var row in scrollRows)
            {
                if (!byGameObjectId.TryGetValue(row.gameObjectId, out var rt))
                    continue;
                if (!byRectId.TryGetValue(row.contentRectId, out var content))
                    continue;
                if (!byRectId.TryGetValue(row.viewportRectId, out var viewport))
                    continue;

                var scrollRect = rt.GetComponent<ScrollRect>();
                if (scrollRect == null)
                    scrollRect = rt.gameObject.AddComponent<ScrollRect>();
                scrollRect.content = content;
                scrollRect.viewport = viewport;
                scrollRect.horizontal = row.horizontal;
                scrollRect.vertical = row.vertical;
                scrollRect.movementType = ToMovementType(row.movementType);
                scrollRect.elasticity = row.elasticity;
                scrollRect.inertia = row.inertia;
                scrollRect.horizontalScrollbar = null;
                scrollRect.verticalScrollbar = null;

                if (viewport.GetComponent<RectMask2D>() == null)
                    viewport.gameObject.AddComponent<RectMask2D>();
                applied++;
            }
            Debug.Log("[GirlsWarRestore] Applied scroll rects: " + applied + "/" + scrollRows.Count);
            return applied;
        }

        private static int AddButtonLoggers(
            List<ButtonRow> buttons,
            Dictionary<string, ButtonHandlerRow> buttonHandlers,
            Dictionary<string, ButtonNavigationRow> buttonNavigation,
            Dictionary<string, RectTransform> byGameObjectId,
            OverrideSet overrides)
        {
            var applied = 0;
            foreach (var row in buttons)
            {
                if (!byGameObjectId.TryGetValue(row.gameObjectId, out var rt))
                    continue;
                Graphic targetGraphic;
                var image = rt.GetComponent<Image>();
                if (image == null)
                {
                    targetGraphic = rt.GetComponent<Graphic>();
                    if (targetGraphic == null)
                    {
                        image = rt.gameObject.AddComponent<Image>();
                        image.color = new Color(1f, 1f, 1f, 0f);
                        targetGraphic = image;
                    }
                }
                else
                {
                    targetGraphic = image;
                }
                var buttonInteractable = row.interactable;
                var targetRaycast = true;
                if (TryGetOverride(overrides, row.componentPathId, row.gameObjectId, out var overrideRow))
                {
                    if (overrideRow.hasButtonInteractable)
                        buttonInteractable = overrideRow.buttonInteractable;
                    if (overrideRow.hasRaycastTarget)
                        targetRaycast = overrideRow.raycastTarget;
                }
                targetGraphic.raycastTarget = targetRaycast;
                if (image != null && image.sprite == null)
                {
                    var color = image.color;
                    color.a = 0f;
                    image.color = color;
                }

                var button = rt.GetComponent<Button>();
                if (button == null)
                    button = rt.gameObject.AddComponent<Button>();
                button.interactable = buttonInteractable;
                button.transition = Selectable.Transition.None;
                button.targetGraphic = targetGraphic;
                button.onClick.RemoveAllListeners();

                var logger = rt.GetComponent<RestoreClickLogger>();
                if (logger == null)
                    logger = rt.gameObject.AddComponent<RestoreClickLogger>();
                logger.bundle = "download/ui/uiprefabandres/maininterface.assetbundle";
                logger.loggerKind = "Button";
                logger.buttonName = row.name;
                logger.buttonComponentPathId = row.componentPathId;
                logger.gameObjectPathId = row.gameObjectId;
                if (buttonHandlers.TryGetValue(row.componentPathId, out var handlerRow))
                {
                    logger.luaModule = handlerRow.module;
                    logger.luaHandler = handlerRow.handler;
                    logger.luaHandlerConfidence = handlerRow.confidence;
                    logger.luaHandlerEvent = handlerRow.eventName;
                }
                else
                {
                    logger.luaModule = "";
                    logger.luaHandler = "";
                    logger.luaHandlerConfidence = "missing_report_row";
                    logger.luaHandlerEvent = "";
                }
                if (buttonNavigation.TryGetValue(row.componentPathId, out var navigationRow))
                {
                    logger.navigationKind = navigationRow.kind;
                    logger.navigationTargetKey = navigationRow.targetKey;
                    logger.navigationTargetUiForm = navigationRow.targetUiForm;
                    logger.navigationTargetPrefabBundle = navigationRow.targetPrefabBundle;
                    logger.navigationConfidence = navigationRow.confidence;
                    logger.navigationHarnessConnected = true;
                    if (!string.IsNullOrWhiteSpace(navigationRow.handler))
                        logger.luaHandler = navigationRow.handler;
                }
                else
                {
                    logger.navigationKind = "";
                    logger.navigationTargetKey = "";
                    logger.navigationTargetUiForm = "";
                    logger.navigationTargetPrefabBundle = "";
                    logger.navigationConfidence = "missing_navigation_map";
                    logger.navigationHarnessConnected = false;
                }
                logger.logPointerClicks = false;

                UnityEventTools.AddPersistentListener(button.onClick, logger.LogClick);
                applied++;
            }
            Debug.Log("[GirlsWarRestore] Applied button click loggers: " + applied + "/" + buttons.Count);
            return applied;
        }

        private static int ApplyGraphicRaycastOverrides(
            List<SpriteRow> sprites,
            Dictionary<string, RectTransform> byGameObjectId,
            OverrideSet overrides)
        {
            var applied = 0;
            foreach (var row in sprites)
            {
                if (!TryGetOverride(overrides, row.componentPathId, row.gameObjectId, out var overrideRow)
                    || !overrideRow.hasRaycastTarget)
                    continue;
                if (!byGameObjectId.TryGetValue(row.gameObjectId, out var rt))
                    continue;
                var graphic = rt.GetComponent<Graphic>();
                if (graphic == null)
                    continue;
                graphic.raycastTarget = overrideRow.raycastTarget;
                applied++;
            }
            Debug.Log("[GirlsWarRestore] Applied graphic raycast overrides: " + applied);
            return applied;
        }

        private static int AddRaycastProbeLoggers(
            List<SpriteRow> sprites,
            List<ButtonRow> buttons,
            Dictionary<string, RectTransform> byGameObjectId)
        {
            var buttonGameObjects = new HashSet<string>();
            foreach (var button in buttons)
                buttonGameObjects.Add(button.gameObjectId);

            var applied = 0;
            foreach (var row in sprites)
            {
                if (!row.raycastTarget || buttonGameObjects.Contains(row.gameObjectId))
                    continue;
                if (!byGameObjectId.TryGetValue(row.gameObjectId, out var rt))
                    continue;
                var graphic = rt.GetComponent<Graphic>();
                if (graphic == null || !graphic.raycastTarget)
                    continue;

                var logger = rt.GetComponent<RestoreClickLogger>();
                if (logger == null)
                    logger = rt.gameObject.AddComponent<RestoreClickLogger>();
                logger.bundle = "download/ui/uiprefabandres/maininterface.assetbundle";
                logger.loggerKind = string.Equals(row.status, "ready", StringComparison.OrdinalIgnoreCase)
                    ? "RaycastGraphic"
                    : "RaycastTransparentCandidate";
                logger.buttonName = row.name;
                logger.buttonComponentPathId = row.componentPathId;
                logger.gameObjectPathId = row.gameObjectId;
                logger.logPointerClicks = true;
                applied++;
            }
            Debug.Log("[GirlsWarRestore] Applied raycast probes: " + applied);
            return applied;
        }

        private static List<RectRow> LoadRows(string path)
        {
            var text = File.ReadAllText(path, Encoding.UTF8);
            var table = ParseCsv(text);
            var rows = new List<RectRow>();
            foreach (var record in table)
            {
                rows.Add(new RectRow
                {
                    pathId = Get(record, "path_id"),
                    gameObjectId = Get(record, "game_object_id"),
                    name = Get(record, "game_object_name"),
                    active = !string.Equals(Get(record, "game_object_active"), "False", StringComparison.OrdinalIgnoreCase),
                    fatherId = Get(record, "father_id"),
                    childIds = SplitChildren(Get(record, "child_ids")),
                    anchorMin = new Vector2(F(Get(record, "anchor_min_x")), F(Get(record, "anchor_min_y"))),
                    anchorMax = new Vector2(F(Get(record, "anchor_max_x")), F(Get(record, "anchor_max_y"))),
                    anchoredPosition = new Vector2(F(Get(record, "anchored_pos_x")), F(Get(record, "anchored_pos_y"))),
                    sizeDelta = new Vector2(F(Get(record, "size_delta_x")), F(Get(record, "size_delta_y"))),
                    pivot = new Vector2(F(Get(record, "pivot_x")), F(Get(record, "pivot_y"))),
                    localPosition = new Vector3(F(Get(record, "local_pos_x")), F(Get(record, "local_pos_y")), F(Get(record, "local_pos_z"))),
                    localScale = new Vector3(DefaultOne(Get(record, "local_scale_x")), DefaultOne(Get(record, "local_scale_y")), DefaultOne(Get(record, "local_scale_z")))
                });
            }
            return rows;
        }

        private static List<RectRow> FilterRowsToRoot(List<RectRow> rows, string rootRectId)
        {
            var byRectId = new Dictionary<string, RectRow>();
            foreach (var row in rows)
            {
                if (!string.IsNullOrWhiteSpace(row.pathId) && !byRectId.ContainsKey(row.pathId))
                    byRectId[row.pathId] = row;
            }
            if (!byRectId.ContainsKey(rootRectId))
                throw new Exception("Main prefab root RectTransform not found: " + rootRectId);

            var keep = new HashSet<string>();
            var stack = new Stack<string>();
            stack.Push(rootRectId);
            while (stack.Count > 0)
            {
                var current = stack.Pop();
                if (!keep.Add(current))
                    continue;
                if (!byRectId.TryGetValue(current, out var row))
                    continue;
                foreach (var child in row.childIds)
                {
                    if (byRectId.ContainsKey(child))
                        stack.Push(child);
                }
            }

            var filtered = new List<RectRow>();
            foreach (var row in rows)
            {
                if (keep.Contains(row.pathId))
                    filtered.Add(row);
            }
            return filtered;
        }

        private static List<ButtonRow> LoadButtons(string path)
        {
            var text = File.ReadAllText(path, Encoding.UTF8);
            var table = ParseCsv(text);
            var rows = new List<ButtonRow>();
            foreach (var record in table)
            {
                rows.Add(new ButtonRow
                {
                    componentPathId = Get(record, "component_path_id"),
                    gameObjectId = Get(record, "game_object_id"),
                    name = Get(record, "game_object_name"),
                    interactable = !string.Equals(Get(record, "interactable"), "0", StringComparison.OrdinalIgnoreCase)
                        && !string.Equals(Get(record, "interactable"), "False", StringComparison.OrdinalIgnoreCase),
                    targetGraphic = Get(record, "target_graphic"),
                    transition = Get(record, "transition")
                });
            }
            return rows;
        }

        private static Dictionary<string, ButtonHandlerRow> LoadButtonHandlers(string path)
        {
            var result = new Dictionary<string, ButtonHandlerRow>();
            if (!File.Exists(path))
                return result;
            var text = File.ReadAllText(path, Encoding.UTF8);
            var table = ParseCsv(text);
            foreach (var record in table)
            {
                var componentPathId = Get(record, "button_component_path_id");
                if (string.IsNullOrWhiteSpace(componentPathId))
                    continue;
                result[componentPathId] = new ButtonHandlerRow
                {
                    componentPathId = componentPathId,
                    module = Get(record, "handler_module"),
                    handler = Get(record, "handler"),
                    confidence = Get(record, "handler_confidence"),
                    eventName = Get(record, "handler_event")
                };
            }
            return result;
        }

        private static Dictionary<string, ButtonNavigationRow> LoadButtonNavigation(string path)
        {
            var result = new Dictionary<string, ButtonNavigationRow>();
            if (!File.Exists(path))
                return result;
            var text = File.ReadAllText(path, Encoding.UTF8);
            var table = ParseCsv(text);
            foreach (var record in table)
            {
                var componentPathId = Get(record, "component_path_id");
                if (string.IsNullOrWhiteSpace(componentPathId))
                    continue;
                result[componentPathId] = new ButtonNavigationRow
                {
                    componentPathId = componentPathId,
                    handler = Get(record, "lua_handler_resolved"),
                    kind = Get(record, "navigation_kind"),
                    targetKey = Get(record, "target_key"),
                    targetUiForm = Get(record, "target_ui_form"),
                    targetPrefabBundle = Get(record, "target_prefab_bundle"),
                    confidence = Get(record, "resolved_confidence")
                };
            }
            return result;
        }

        private static List<SpriteRow> LoadSprites(string path)
        {
            if (!File.Exists(path))
                return new List<SpriteRow>();
            var text = File.ReadAllText(path, Encoding.UTF8);
            var table = ParseCsv(text);
            var rows = new List<SpriteRow>();
            foreach (var record in table)
            {
                rows.Add(new SpriteRow
                {
                    componentPathId = Get(record, "component_path_id"),
                    gameObjectId = Get(record, "game_object_id"),
                    name = Get(record, "game_object_name"),
                    assetPath = Get(record, "unity_asset_path"),
                    status = Get(record, "status"),
                    raycastTarget = B(Get(record, "raycast_target")),
                    preserveAspect = B(Get(record, "preserve_aspect")),
                    imageType = (int)F(Get(record, "image_type")),
                    color = new Color(
                        DefaultOne(Get(record, "color_r")),
                        DefaultOne(Get(record, "color_g")),
                        DefaultOne(Get(record, "color_b")),
                        DefaultOne(Get(record, "color_a")))
                });
            }
            return rows;
        }

        private static List<TextRow> LoadTexts(string path)
        {
            if (!File.Exists(path))
                return new List<TextRow>();
            var text = File.ReadAllText(path, Encoding.UTF8);
            var table = ParseCsv(text);
            var rows = new List<TextRow>();
            foreach (var record in table)
            {
                rows.Add(new TextRow
                {
                    componentPathId = Get(record, "component_path_id"),
                    gameObjectId = Get(record, "game_object_id"),
                    name = Get(record, "game_object_name"),
                    scriptId = Get(record, "script_id"),
                    text = Get(record, "text"),
                    fontSize = Mathf.Max(1, Mathf.RoundToInt(F(Get(record, "font_size")))),
                    alignment = Mathf.RoundToInt(F(Get(record, "alignment"))),
                    raycastTarget = B(Get(record, "raycast_target")),
                    color = new Color(
                        DefaultOne(Get(record, "color_r")),
                        DefaultOne(Get(record, "color_g")),
                        DefaultOne(Get(record, "color_b")),
                        DefaultOne(Get(record, "color_a")))
                });
            }
            return rows;
        }

        private static Dictionary<string, TmpTextDetailRow> LoadTmpTextDetails(string path)
        {
            var rows = new Dictionary<string, TmpTextDetailRow>();
            if (!File.Exists(path))
                return rows;
            var text = File.ReadAllText(path, Encoding.UTF8);
            var table = ParseCsv(text);
            foreach (var record in table)
            {
                var componentPathId = Get(record, "component_path_id");
                if (string.IsNullOrWhiteSpace(componentPathId))
                    continue;
                rows[componentPathId] = new TmpTextDetailRow
                {
                    componentPathId = componentPathId,
                    fontAssetPathId = Get(record, "font_asset_path_id"),
                    fontAssetName = Get(record, "font_asset_name"),
                    fontFamily = Get(record, "font_family"),
                    fontAssetBundle = Get(record, "font_asset_bundle"),
                    sharedMaterialPathId = Get(record, "shared_material_path_id"),
                    fontSize = F(Get(record, "font_size")),
                    fontSizeMin = F(Get(record, "font_size_min")),
                    fontSizeMax = F(Get(record, "font_size_max")),
                    fontWeight = Mathf.RoundToInt(F(Get(record, "font_weight"))),
                    fontStyle = Mathf.RoundToInt(F(Get(record, "font_style"))),
                    enableAutoSizing = B(Get(record, "enable_auto_sizing")),
                    resolvedAlignment = Mathf.RoundToInt(F(Get(record, "resolved_alignment"))),
                    characterSpacing = F(Get(record, "character_spacing")),
                    wordSpacing = F(Get(record, "word_spacing")),
                    lineSpacing = F(Get(record, "line_spacing")),
                    paragraphSpacing = F(Get(record, "paragraph_spacing")),
                    enableWordWrapping = B(Get(record, "enable_word_wrapping")),
                    wordWrappingRatios = F(Get(record, "word_wrapping_ratios")),
                    overflowMode = Mathf.RoundToInt(F(Get(record, "overflow_mode"))),
                    enableKerning = B(Get(record, "enable_kerning")),
                    enableExtraPadding = B(Get(record, "enable_extra_padding")),
                    isRichText = B(Get(record, "is_rich_text")),
                    parseCtrlCharacters = B(Get(record, "parse_ctrl_characters")),
                    isRightToLeft = B(Get(record, "is_right_to_left")),
                    margin = new Vector4(
                        F(Get(record, "margin_x")),
                        F(Get(record, "margin_y")),
                        F(Get(record, "margin_z")),
                        F(Get(record, "margin_w"))),
                    fontColor = new Color(
                        DefaultOne(Get(record, "font_color_r")),
                        DefaultOne(Get(record, "font_color_g")),
                        DefaultOne(Get(record, "font_color_b")),
                        DefaultOne(Get(record, "font_color_a"))),
                    hasFontColor = !string.IsNullOrWhiteSpace(Get(record, "font_color_r"))
                };
            }
            return rows;
        }

        private static List<ScrollRow> LoadScrolls(string path)
        {
            if (!File.Exists(path))
                return new List<ScrollRow>();
            var text = File.ReadAllText(path, Encoding.UTF8);
            var table = ParseCsv(text);
            var rows = new List<ScrollRow>();
            foreach (var record in table)
            {
                rows.Add(new ScrollRow
                {
                    componentPathId = Get(record, "component_path_id"),
                    gameObjectId = Get(record, "game_object_id"),
                    name = Get(record, "game_object_name"),
                    contentRectId = Get(record, "content"),
                    viewportRectId = Get(record, "viewport"),
                    horizontal = B(Get(record, "horizontal")),
                    vertical = B(Get(record, "vertical")),
                    movementType = Mathf.RoundToInt(F(Get(record, "movement_type"))),
                    elasticity = F(Get(record, "elasticity")),
                    inertia = B(Get(record, "inertia"))
                });
            }
            return rows;
        }

        private static OverrideSet LoadOverrides(string path)
        {
            var result = new OverrideSet();
            if (!File.Exists(path))
                return result;
            var text = File.ReadAllText(path, Encoding.UTF8);
            var table = ParseCsv(text);
            foreach (var record in table)
            {
                var activeValue = Get(record, "active");
                var raycastValue = Get(record, "raycast_target");
                var interactableValue = Get(record, "button_interactable");
                var row = new OverrideRow
                {
                    targetKind = Get(record, "target_kind"),
                    componentPathId = Get(record, "component_path_id"),
                    gameObjectId = Get(record, "game_object_id"),
                    name = Get(record, "game_object_name"),
                    hasActive = !string.IsNullOrWhiteSpace(activeValue),
                    active = B(activeValue),
                    hasRaycastTarget = !string.IsNullOrWhiteSpace(raycastValue),
                    raycastTarget = B(raycastValue),
                    hasButtonInteractable = !string.IsNullOrWhiteSpace(interactableValue),
                    buttonInteractable = B(interactableValue),
                    reason = Get(record, "reason")
                };
                result.rows.Add(row);
                if (!string.IsNullOrWhiteSpace(row.componentPathId))
                    result.byComponentPathId[row.componentPathId] = row;
                if (!string.IsNullOrWhiteSpace(row.gameObjectId))
                    result.byGameObjectId[row.gameObjectId] = row;
            }
            return result;
        }

        private static List<VisualOverrideRow> LoadVisualOverrides(string path)
        {
            var result = new List<VisualOverrideRow>();
            if (!File.Exists(path))
                return result;
            var text = File.ReadAllText(path, Encoding.UTF8);
            var table = ParseCsv(text);
            foreach (var record in table)
            {
                var colorR = Get(record, "color_r");
                var colorG = Get(record, "color_g");
                var colorB = Get(record, "color_b");
                var colorA = Get(record, "color_a");
                var preserveAspect = Get(record, "preserve_aspect");
                var imageType = Get(record, "image_type");
                var raycastTarget = Get(record, "raycast_target");
                var hasColor = !string.IsNullOrWhiteSpace(colorR)
                    || !string.IsNullOrWhiteSpace(colorG)
                    || !string.IsNullOrWhiteSpace(colorB)
                    || !string.IsNullOrWhiteSpace(colorA);

                result.Add(new VisualOverrideRow
                {
                    targetKind = Get(record, "target_kind"),
                    componentPathId = Get(record, "component_path_id"),
                    gameObjectId = Get(record, "game_object_id"),
                    parentGameObjectId = Get(record, "parent_game_object_id"),
                    createChildName = Get(record, "create_child_name"),
                    name = Get(record, "game_object_name"),
                    spriteAssetPath = Get(record, "sprite_asset_path"),
                    hasColor = hasColor,
                    color = new Color(
                        string.IsNullOrWhiteSpace(colorR) ? 1f : F(colorR),
                        string.IsNullOrWhiteSpace(colorG) ? 1f : F(colorG),
                        string.IsNullOrWhiteSpace(colorB) ? 1f : F(colorB),
                        string.IsNullOrWhiteSpace(colorA) ? 1f : F(colorA)),
                    hasPreserveAspect = !string.IsNullOrWhiteSpace(preserveAspect),
                    preserveAspect = B(preserveAspect),
                    hasImageType = !string.IsNullOrWhiteSpace(imageType),
                    imageType = string.IsNullOrWhiteSpace(imageType) ? 0 : (int)F(imageType),
                    hasRaycastTarget = !string.IsNullOrWhiteSpace(raycastTarget),
                    raycastTarget = B(raycastTarget),
                    hasAnchoredPosition = !string.IsNullOrWhiteSpace(Get(record, "anchored_pos_x"))
                        || !string.IsNullOrWhiteSpace(Get(record, "anchored_pos_y")),
                    anchoredPosition = new Vector2(F(Get(record, "anchored_pos_x")), F(Get(record, "anchored_pos_y"))),
                    hasSizeDelta = !string.IsNullOrWhiteSpace(Get(record, "size_delta_x"))
                        || !string.IsNullOrWhiteSpace(Get(record, "size_delta_y")),
                    sizeDelta = new Vector2(F(Get(record, "size_delta_x")), F(Get(record, "size_delta_y"))),
                    hasLocalScale = !string.IsNullOrWhiteSpace(Get(record, "local_scale_x"))
                        || !string.IsNullOrWhiteSpace(Get(record, "local_scale_y"))
                        || !string.IsNullOrWhiteSpace(Get(record, "local_scale_z")),
                    localScale = new Vector3(
                        string.IsNullOrWhiteSpace(Get(record, "local_scale_x")) ? 1f : F(Get(record, "local_scale_x")),
                        string.IsNullOrWhiteSpace(Get(record, "local_scale_y")) ? 1f : F(Get(record, "local_scale_y")),
                        string.IsNullOrWhiteSpace(Get(record, "local_scale_z")) ? 1f : F(Get(record, "local_scale_z"))),
                    reason = Get(record, "reason")
                });
            }
            return result;
        }

        private static List<RectOverrideRow> LoadRectOverrides(string path)
        {
            var result = new List<RectOverrideRow>();
            if (!File.Exists(path))
                return result;
            var text = File.ReadAllText(path, Encoding.UTF8);
            var table = ParseCsv(text);
            foreach (var record in table)
            {
                result.Add(new RectOverrideRow
                {
                    rectPathId = Get(record, "rect_path_id"),
                    gameObjectId = Get(record, "game_object_id"),
                    gameObjectName = Get(record, "game_object_name"),
                    setAnchoredPosition = B(Get(record, "set_anchored_position")),
                    anchoredPosition = new Vector2(F(Get(record, "anchored_pos_x")), F(Get(record, "anchored_pos_y"))),
                    setSizeDelta = B(Get(record, "set_size_delta")),
                    sizeDelta = new Vector2(F(Get(record, "size_delta_x")), F(Get(record, "size_delta_y"))),
                    setLocalScale = B(Get(record, "set_local_scale")),
                    localScale = new Vector3(F(Get(record, "local_scale_x")), F(Get(record, "local_scale_y")), F(Get(record, "local_scale_z"))),
                    reason = Get(record, "reason")
                });
            }
            return result;
        }

        private static bool TryGetOverride(
            OverrideSet overrides,
            string componentPathId,
            string gameObjectId,
            out OverrideRow row)
        {
            if (!string.IsNullOrWhiteSpace(componentPathId)
                && overrides.byComponentPathId.TryGetValue(componentPathId, out row))
            {
                return true;
            }
            if (!string.IsNullOrWhiteSpace(gameObjectId)
                && overrides.byGameObjectId.TryGetValue(gameObjectId, out row))
            {
                return true;
            }
            row = null;
            return false;
        }

        private static string[] SplitChildren(string value)
        {
            if (string.IsNullOrWhiteSpace(value))
                return Array.Empty<string>();
            return value.Split(new[] {';'}, StringSplitOptions.RemoveEmptyEntries);
        }

        private static float DefaultOne(string value)
        {
            return string.IsNullOrWhiteSpace(value) ? 1f : F(value);
        }

        private static float F(string value)
        {
            if (float.TryParse(value, NumberStyles.Float, CultureInfo.InvariantCulture, out var result))
                return result;
            return 0f;
        }

        private static bool B(string value)
        {
            if (string.IsNullOrWhiteSpace(value))
                return false;
            return value == "1" || value.Equals("true", StringComparison.OrdinalIgnoreCase);
        }

        private static Image.Type ToImageType(int value)
        {
            if (value < 0 || value > 3)
                return Image.Type.Simple;
            return (Image.Type)value;
        }

        private static TextAnchor ToTextAnchor(int value)
        {
            if (value < 0 || value > 8)
                return TextAnchor.MiddleCenter;
            return (TextAnchor)value;
        }

        private static TextAlignmentOptions ToTmpAlignment(int value, int fallbackTextAnchor)
        {
            if (value > 0 && value != 65535)
                return (TextAlignmentOptions)value;

            switch (ToTextAnchor(fallbackTextAnchor))
            {
                case TextAnchor.UpperLeft:
                    return TextAlignmentOptions.TopLeft;
                case TextAnchor.UpperCenter:
                    return TextAlignmentOptions.Top;
                case TextAnchor.UpperRight:
                    return TextAlignmentOptions.TopRight;
                case TextAnchor.MiddleLeft:
                    return TextAlignmentOptions.Left;
                case TextAnchor.MiddleRight:
                    return TextAlignmentOptions.Right;
                case TextAnchor.LowerLeft:
                    return TextAlignmentOptions.BottomLeft;
                case TextAnchor.LowerCenter:
                    return TextAlignmentOptions.Bottom;
                case TextAnchor.LowerRight:
                    return TextAlignmentOptions.BottomRight;
                default:
                    return TextAlignmentOptions.Center;
            }
        }

        private static TextOverflowModes ToTextOverflowMode(int value)
        {
            if (value < 0 || value > 7)
                return TextOverflowModes.Overflow;
            return (TextOverflowModes)value;
        }

        private static ScrollRect.MovementType ToMovementType(int value)
        {
            if (value < 0 || value > 2)
                return ScrollRect.MovementType.Elastic;
            return (ScrollRect.MovementType)value;
        }

        private static Color Transparent(Color color)
        {
            color.a = 0f;
            return color;
        }

        private static string Get(Dictionary<string, string> record, string key)
        {
            return record.TryGetValue(key, out var value) ? value : "";
        }

        private static Color ColorFor(RectRow row)
        {
            var hash = Mathf.Abs((row.name + row.pathId).GetHashCode());
            var h = (hash % 360) / 360f;
            var color = Color.HSVToRGB(h, 0.5f, 0.95f);
            color.a = Mathf.Abs(row.sizeDelta.x) < 4f || Mathf.Abs(row.sizeDelta.y) < 4f ? 0.025f : 0.08f;
            return color;
        }

        private static string SafeName(string value)
        {
            if (string.IsNullOrWhiteSpace(value))
                return "unnamed";
            foreach (var c in Path.GetInvalidFileNameChars())
                value = value.Replace(c, '_');
            return value.Length > 120 ? value.Substring(0, 120) : value;
        }

        private static List<Dictionary<string, string>> ParseCsv(string text)
        {
            var rows = new List<List<string>>();
            var current = new List<string>();
            var field = new StringBuilder();
            var inQuotes = false;

            for (var i = 0; i < text.Length; i++)
            {
                var ch = text[i];
                if (inQuotes)
                {
                    if (ch == '"')
                    {
                        if (i + 1 < text.Length && text[i + 1] == '"')
                        {
                            field.Append('"');
                            i++;
                        }
                        else
                        {
                            inQuotes = false;
                        }
                    }
                    else
                    {
                        field.Append(ch);
                    }
                    continue;
                }

                if (ch == '"')
                {
                    inQuotes = true;
                }
                else if (ch == ',')
                {
                    current.Add(field.ToString());
                    field.Length = 0;
                }
                else if (ch == '\n')
                {
                    current.Add(field.ToString().TrimEnd('\r'));
                    field.Length = 0;
                    rows.Add(current);
                    current = new List<string>();
                }
                else
                {
                    field.Append(ch);
                }
            }
            if (field.Length > 0 || current.Count > 0)
            {
                current.Add(field.ToString());
                rows.Add(current);
            }

            if (rows.Count == 0)
                return new List<Dictionary<string, string>>();

            var headers = rows[0];
            var result = new List<Dictionary<string, string>>();
            for (var r = 1; r < rows.Count; r++)
            {
                if (rows[r].Count == 1 && string.IsNullOrWhiteSpace(rows[r][0]))
                    continue;
                var dict = new Dictionary<string, string>();
                for (var c = 0; c < headers.Count && c < rows[r].Count; c++)
                    dict[headers[c]] = rows[r][c];
                result.Add(dict);
            }
            return result;
        }

        private static List<Dictionary<string, string>> LoadCsv(string path)
        {
            if (!File.Exists(path))
                return new List<Dictionary<string, string>>();
            return ParseCsv(File.ReadAllText(path, Encoding.UTF8));
        }

        [Serializable]
        private sealed class BuildResult
        {
            public string scenePath;
            public int rectTransformCount;
            public int imageComponentCount;
            public int spriteAppliedCount;
            public int textComponentCount;
            public int textAppliedCount;
            public int uguiTextAppliedCount;
            public int tmpTextDetailCount;
            public int tmpTextAppliedCount;
            public int scrollRectCount;
            public int scrollRectAppliedCount;
            public int buttonLogCount;
            public int raycastProbeCount;
            public int activeOverrideCount;
            public int graphicRaycastOverrideCount;
            public int restoreOverrideCount;
            public int rectOverrideCount;
            public int visualOverrideCount;
            public string generatedAt;
        }

        [Serializable]
        private sealed class CaptureResult
        {
            public string capturePath;
            public int width;
            public int height;
            public int visiblePixelCount;
            public string generatedAt;
        }
    }
}
