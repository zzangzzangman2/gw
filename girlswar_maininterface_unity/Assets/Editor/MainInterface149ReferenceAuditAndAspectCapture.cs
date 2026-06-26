using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Text;
using Spine.Unity;
using TMPro;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

namespace GirlsWarRestore
{
    public static class MainInterface149ReferenceAuditAndAspectCapture
    {
        private const string DefaultRootRectId = "5568884429252053541";
        private const string OldRootRectId = "2475216337245998118";
        private const string DefaultScenePath = "Assets/Scenes/MainInterface_UI149_DefaultRootReferenceAudit.unity";
        private const string OldRootScenePath = "Assets/Scenes/MainInterface_UI149_OldRootReferenceAudit.unity";
        private const string DefaultCapturePath = "Assets/RestoreCaptures/maininterface_ui149_default_root_reference_aspect_1180x526.png";
        private const string OldRootCapturePath = "Assets/RestoreCaptures/maininterface_ui149_oldroot_home_reference_aspect_1180x526.png";
        private const string ResultJsonPath = "Assets/RestoreData/maininterface_149_reference_aspect_audit_result.json";
        private const string SharedBuildResultPath = "Assets/RestoreData/maininterface_build_result.json";
        private const string NodeCsvPath = "Assets/RestoreData/reports/maininterface_149_reference_audit_nodes.csv";
        private const string TmpCsvPath = "Assets/RestoreData/reports/maininterface_149_reference_audit_tmp.csv";
        private const string MaskCsvPath = "Assets/RestoreData/reports/maininterface_149_reference_audit_mask_stencil.csv";
        private const string SkeletonCsvPath = "Assets/RestoreData/reports/maininterface_149_reference_audit_skeletongraphic.csv";
        private const string DecisionCsvPath = "Assets/RestoreData/reports/maininterface_149_reference_audit_decision_matrix.csv";
        private const string ReportMdPath = "C:/Users/godho/Downloads/girlswar/reports/maininterface/MAININTERFACE_149_REFERENCE_ASPECT_RUNTIME_STATE_AUDIT_AND_SAFE_CAPTURE_RESULT.md";
        private const string ReferenceImagePath = @"C:\Users\godho\.codex\attachments\e607fc34-b674-4516-b051-8d396cd6df06\image-1.png";
        private const string HeroRoot = "Assets/RestoreData/hero1005_spine_source_raw/paintingprefabandres_1005";
        private const string HeroSkeletonDataPath = HeroRoot + "/Painting_1005_SkeletonData.asset";
        private const string HeroMaterialPath = HeroRoot + "/Painting_1005_Material.mat";
        private const string Background1005Path = "Assets/RestoredSprites/maininterface/runtime_dynamic/runtime_UI_bg_noalphabg_PaintingBG_1005.png";
        private const int ReferenceWidth = 1180;
        private const int ReferenceHeight = 526;

        [MenuItem("GirlsWar/UI149 Main UI Worker Reference Aspect Audit And Safe Capture")]
        public static void Run()
        {
            Directory.CreateDirectory("Assets/Scenes");
            Directory.CreateDirectory("Assets/RestoreCaptures");
            Directory.CreateDirectory("Assets/RestoreData");
            Directory.CreateDirectory("Assets/RestoreData/reports");
            Directory.CreateDirectory("C:/Users/godho/Downloads/girlswar/reports/maininterface");

            var result = new AuditResult
            {
                generatedAt = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
                referenceImagePath = ReferenceImagePath,
                referenceWidth = ReferenceWidth,
                referenceHeight = ReferenceHeight,
                referenceAspect = ReferenceWidth / (float)ReferenceHeight,
                variants = new List<VariantResult>(),
                decisions = BuildDecisionRows()
            };

            var sharedBuildResultSnapshot = SnapshotFile(SharedBuildResultPath);
            try
            {
                result.variants.Add(BuildAndAuditVariant(
                    "default_root_route_state",
                    DefaultRootRectId,
                    DefaultScenePath,
                    "MainInterface_UI149_DefaultRootReferenceAudit",
                    DefaultCapturePath,
                    false));

                result.variants.Add(BuildAndAuditVariant(
                    "oldroot_home_safe_candidate",
                    OldRootRectId,
                    OldRootScenePath,
                    "MainInterface_UI149_OldRootReferenceAudit",
                    OldRootCapturePath,
                    true));

                result.status = "ui149_reference_aspect_audit_complete";
                result.restoredClaim = false;
                result.productionPatchApplied = false;
                result.candidatePatchApplied = true;
                result.summary = "Default root remains a route/world state. Old-root + source-backed Hero1005/BG1005 is the safer home candidate, but runtime UI_Dock/depth/activity/chat/account state is still required before promotion.";
            }
            catch (Exception ex)
            {
                result.status = "ui149_reference_aspect_audit_failed";
                result.error = ex.GetType().Name + ": " + ex.Message;
                RestoreFile(SharedBuildResultPath, sharedBuildResultSnapshot);
                WriteAllOutputs(result);
                Debug.LogException(ex);
                throw;
            }

            RestoreFile(SharedBuildResultPath, sharedBuildResultSnapshot);
            WriteAllOutputs(result);
            AssetDatabase.Refresh(ImportAssetOptions.ForceSynchronousImport);
            Debug.Log("[GirlsWarRestore] UI149 reference aspect audit complete: " + ReportMdPath);
        }

        private static string SnapshotFile(string path)
        {
            return File.Exists(path) ? File.ReadAllText(path, Encoding.UTF8) : null;
        }

        private static void RestoreFile(string path, string snapshot)
        {
            if (snapshot == null)
            {
                if (File.Exists(path))
                    File.Delete(path);
                return;
            }
            File.WriteAllText(path, snapshot, Encoding.UTF8);
        }

        private static VariantResult BuildAndAuditVariant(
            string label,
            string rootRectId,
            string scenePath,
            string sceneName,
            string capturePath,
            bool applySourceBackedHomeState)
        {
            MainInterfaceSceneBuilder.BuildMainInterfaceSceneForRoot(rootRectId, scenePath, sceneName);
            var scene = EditorSceneManager.OpenScene(scenePath, OpenSceneMode.Single);
            var variant = new VariantResult
            {
                label = label,
                rootRectId = rootRectId,
                scenePath = scenePath,
                capturePath = capturePath,
                sourceBackedHomeStateApplied = applySourceBackedHomeState,
                decisions = new List<string>()
            };

            if (applySourceBackedHomeState)
            {
                AttachHero1005(variant);
                ApplyBackground1005(variant);
                variant.decisions.Add("Applied source-backed normal-home lane only: UI_bg=PaintingBG_1005 and real Hero1005 SkeletonGraphic animation A.");
                variant.decisions.Add("Did not patch activity slots, chat text, player/account/currency values, UI_Dock promotion, or route/world guardrail nodes.");
            }
            else
            {
                variant.decisions.Add("No source-backed home runtime lane was applied; this captures the default CSV root route/world active state.");
            }

            ForceSpineUpdate();
            EditorSceneManager.SaveScene(scene, scenePath);

            var canvas = UnityEngine.Object.FindFirstObjectByType<Canvas>();
            if (canvas == null)
                throw new Exception("Canvas not found in " + scenePath);

            variant.canvas = CaptureCanvasState(canvas);
            variant.capture = Capture(canvas, capturePath, ReferenceWidth, ReferenceHeight);
            variant.diff = CompareCaptureToReference(capturePath);
            variant.nodes = CollectNodeRows(label);
            variant.tmpRows = CollectTmpRows(label);
            variant.maskRows = CollectMaskRows(label);
            variant.skeletonRows = CollectSkeletonRows(label);
            variant.routeActiveInterestingCount = CountActiveContains(variant.nodes, "route", "worldwanfa", "wanfaWorld", "spine_diqiu", "zhuye");
            variant.homeInterestingCount = CountActiveContains(variant.nodes, "UI_heroSpine", "UI_touchSpine", "UI_bg", "node_bottom", "btnToggle", "btn_act", "btn_discord");
            variant.tmpAutoSizeRows = CountTmpAutoSize(variant.tmpRows);
            variant.nonZeroStencilRows = CountNonZeroStencil(variant.maskRows);
            variant.skeletonGraphicRows = variant.skeletonRows.Count;
            variant.activeNodeRows = CountActiveNodes(variant.nodes);
            return variant;
        }

        private static void AttachHero1005(VariantResult result)
        {
            var skeletonDataAsset = AssetDatabase.LoadAssetAtPath<SkeletonDataAsset>(HeroSkeletonDataPath);
            if (skeletonDataAsset == null || skeletonDataAsset.GetSkeletonData(true) == null)
                throw new Exception("Missing Hero1005 SkeletonDataAsset: " + HeroSkeletonDataPath);
            var material = AssetDatabase.LoadAssetAtPath<Material>(HeroMaterialPath);
            if (material == null)
                throw new Exception("Missing Hero1005 material: " + HeroMaterialPath);

            var heroParent = FindTransformByPrefix("UI_heroSpine__") ?? FindTransformByName("UI_heroSpine");
            if (heroParent == null)
                throw new Exception("UI_heroSpine not found in " + result.scenePath);
            EnsureActiveInHierarchy(heroParent);

            var previous = heroParent.Find("Restore_Hero1005_SpineRoot_UI149");
            if (previous != null)
                UnityEngine.Object.DestroyImmediate(previous.gameObject);

            var root = new GameObject("Restore_Hero1005_SpineRoot_UI149", typeof(RectTransform));
            var rootRect = root.GetComponent<RectTransform>();
            rootRect.SetParent(heroParent, false);
            rootRect.anchorMin = Vector2.zero;
            rootRect.anchorMax = Vector2.one;
            rootRect.offsetMin = Vector2.zero;
            rootRect.offsetMax = Vector2.zero;
            rootRect.pivot = new Vector2(0.5f, 0.5f);
            rootRect.localScale = Vector3.one;
            rootRect.localRotation = Quaternion.identity;

            var graphic = SkeletonGraphic.NewSkeletonGraphicGameObject(skeletonDataAsset, rootRect, material);
            graphic.gameObject.name = "Restore_Hero1005_Painting_1005_UI149";
            graphic.raycastTarget = false;
            graphic.maskable = true;
            graphic.allowMultipleCanvasRenderers = true;
            graphic.startingAnimation = "A";
            graphic.startingLoop = true;

            var rect = graphic.GetComponent<RectTransform>();
            rect.anchorMin = new Vector2(0.5f, 0.5f);
            rect.anchorMax = new Vector2(0.5f, 0.5f);
            rect.pivot = new Vector2(0.5f, 0.5f);
            rect.anchoredPosition = Vector2.zero;
            rect.sizeDelta = new Vector2(100f, 100f);
            rect.localScale = Vector3.one;
            rect.localRotation = Quaternion.identity;

            graphic.Initialize(true);
            if (skeletonDataAsset.GetSkeletonData(true).FindAnimation("A") != null)
                graphic.AnimationState.SetAnimation(0, "A", true);
            graphic.Update(0f);
            graphic.LateUpdate();

            result.heroPath = GetHierarchyPath(graphic.transform);
        }

        private static void ApplyBackground1005(VariantResult result)
        {
            var background = FindTransformByPrefix("UI_bg__") ?? FindTransformByName("UI_bg");
            if (background == null)
                throw new Exception("UI_bg target not found in " + result.scenePath);
            background.gameObject.SetActive(true);

            var sprite = AssetDatabase.LoadAssetAtPath<Sprite>(Background1005Path);
            if (sprite == null)
                throw new Exception("Background sprite not found: " + Background1005Path);

            var image = background.GetComponent<Image>();
            if (image == null)
                image = background.gameObject.AddComponent<Image>();
            image.sprite = sprite;
            image.color = Color.white;
            image.type = Image.Type.Simple;
            image.preserveAspect = false;
            image.raycastTarget = true;

            var rect = background.GetComponent<RectTransform>();
            rect.anchorMin = new Vector2(0.5f, 0.5f);
            rect.anchorMax = new Vector2(0.5f, 0.5f);
            rect.pivot = new Vector2(0.5f, 0.5f);
            rect.anchoredPosition = Vector2.zero;
            rect.sizeDelta = new Vector2(1680f, 720f);
            rect.localScale = Vector3.one;
            background.SetSiblingIndex(0);

            result.backgroundPath = GetHierarchyPath(background);
            result.backgroundSpritePath = Background1005Path;
        }

        private static CanvasState CaptureCanvasState(Canvas canvas)
        {
            var scaler = canvas.GetComponent<CanvasScaler>();
            return new CanvasState
            {
                renderMode = canvas.renderMode.ToString(),
                sortingOrder = canvas.sortingOrder,
                overrideSorting = canvas.overrideSorting,
                scalerMode = scaler != null ? scaler.uiScaleMode.ToString() : "",
                referenceResolution = scaler != null ? Vec2(scaler.referenceResolution) : "",
                screenMatchMode = scaler != null ? scaler.screenMatchMode.ToString() : "",
                matchWidthOrHeight = scaler != null ? scaler.matchWidthOrHeight : 0f
            };
        }

        private static CaptureInfo Capture(Canvas canvas, string capturePath, int width, int height)
        {
            canvas.renderMode = RenderMode.ScreenSpaceCamera;
            var cameraGo = new GameObject("UI149_ReferenceAspectCaptureCamera", typeof(Camera));
            var camera = cameraGo.GetComponent<Camera>();
            camera.clearFlags = CameraClearFlags.SolidColor;
            camera.backgroundColor = new Color(0f, 0f, 0f, 0f);
            camera.orthographic = true;
            camera.orthographicSize = height * 0.5f;
            camera.transform.position = new Vector3(0f, 0f, -1000f);
            canvas.worldCamera = camera;
            canvas.planeDistance = 100f;
            canvas.sortingOrder = 0;

            Canvas.ForceUpdateCanvases();
            var texture = new Texture2D(width, height, TextureFormat.RGBA32, false);
            var renderTexture = new RenderTexture(width, height, 24, RenderTextureFormat.ARGB32);
            var previous = RenderTexture.active;
            camera.targetTexture = renderTexture;
            RenderTexture.active = renderTexture;
            GL.Clear(true, true, camera.backgroundColor);
            camera.Render();
            texture.ReadPixels(new Rect(0, 0, width, height), 0, 0);
            texture.Apply();
            File.WriteAllBytes(capturePath, texture.EncodeToPNG());

            RenderTexture.active = previous;
            camera.targetTexture = null;
            UnityEngine.Object.DestroyImmediate(renderTexture);
            UnityEngine.Object.DestroyImmediate(texture);
            UnityEngine.Object.DestroyImmediate(cameraGo);

            return AnalyzeCapture(capturePath, width, height);
        }

        private static CaptureInfo AnalyzeCapture(string path, int width, int height)
        {
            var texture = LoadTexture(path);
            var colors = texture.GetPixels32();
            var visible = 0;
            var minX = texture.width;
            var minY = texture.height;
            var maxX = -1;
            var maxY = -1;
            var unique = new HashSet<Color32>();
            for (var y = 0; y < texture.height; y++)
            {
                for (var x = 0; x < texture.width; x++)
                {
                    var color = colors[y * texture.width + x];
                    unique.Add(color);
                    if (color.a == 0)
                        continue;
                    visible++;
                    minX = Math.Min(minX, x);
                    minY = Math.Min(minY, y);
                    maxX = Math.Max(maxX, x);
                    maxY = Math.Max(maxY, y);
                }
            }
            var bounds = visible > 0 ? minX + "," + minY + "-" + maxX + "," + maxY : "none";
            UnityEngine.Object.DestroyImmediate(texture);
            return new CaptureInfo
            {
                exists = File.Exists(path),
                path = Path.GetFullPath(path),
                width = width,
                height = height,
                aspect = width / (float)height,
                visiblePixelCount = visible,
                uniqueColorCount = unique.Count,
                bounds = bounds
            };
        }

        private static DiffMetrics CompareCaptureToReference(string capturePath)
        {
            var metrics = new DiffMetrics
            {
                referencePath = ReferenceImagePath,
                capturePath = Path.GetFullPath(capturePath),
                referenceExists = File.Exists(ReferenceImagePath),
                captureExists = File.Exists(capturePath)
            };
            if (!metrics.referenceExists || !metrics.captureExists)
                return metrics;

            var reference = LoadTexture(ReferenceImagePath);
            var capture = LoadTexture(capturePath);
            metrics.referenceWidth = reference.width;
            metrics.referenceHeight = reference.height;
            metrics.captureWidth = capture.width;
            metrics.captureHeight = capture.height;
            if (reference.width != capture.width || reference.height != capture.height)
            {
                metrics.sizeMismatch = true;
                UnityEngine.Object.DestroyImmediate(reference);
                UnityEngine.Object.DestroyImmediate(capture);
                return metrics;
            }

            var refPixels = reference.GetPixels32();
            var capPixels = capture.GetPixels32();
            var count = refPixels.Length;
            double absSum = 0d;
            double changed30 = 0d;
            double sx = 0d;
            double sy = 0d;
            double sxx = 0d;
            double syy = 0d;
            double sxy = 0d;
            for (var i = 0; i < count; i++)
            {
                var r = refPixels[i];
                var c = capPixels[i];
                var dr = Math.Abs(r.r - c.r);
                var dg = Math.Abs(r.g - c.g);
                var db = Math.Abs(r.b - c.b);
                var mean = (dr + dg + db) / 3d;
                absSum += mean / 255d;
                if (mean >= 30d)
                    changed30++;
                var x = 0.2126d * r.r + 0.7152d * r.g + 0.0722d * r.b;
                var y = 0.2126d * c.r + 0.7152d * c.g + 0.0722d * c.b;
                sx += x;
                sy += y;
                sxx += x * x;
                syy += y * y;
                sxy += x * y;
            }
            metrics.meanAbsDiff = (float)(absSum / count);
            metrics.changed30 = (float)(changed30 / count);
            var numerator = count * sxy - sx * sy;
            var denominator = Math.Sqrt((count * sxx - sx * sx) * (count * syy - sy * sy));
            metrics.correlation = denominator > 0d ? (float)(numerator / denominator) : 0f;
            UnityEngine.Object.DestroyImmediate(reference);
            UnityEngine.Object.DestroyImmediate(capture);
            return metrics;
        }

        private static Texture2D LoadTexture(string path)
        {
            var texture = new Texture2D(2, 2, TextureFormat.RGBA32, false);
            if (!texture.LoadImage(File.ReadAllBytes(path)))
                throw new Exception("Failed to load image: " + path);
            return texture;
        }

        private static List<NodeRow> CollectNodeRows(string variant)
        {
            var rows = new List<NodeRow>();
            var transforms = UnityEngine.Object.FindObjectsByType<RectTransform>(FindObjectsInactive.Include, FindObjectsSortMode.None);
            foreach (var rt in transforms)
            {
                var path = GetHierarchyPath(rt);
                if (!IsInterestingNode(rt.gameObject.name, path))
                    continue;
                var image = rt.GetComponent<Image>();
                var graphic = rt.GetComponent<Graphic>();
                var tmp = rt.GetComponent<TMP_Text>();
                var button = rt.GetComponent<Button>();
                var canvas = rt.GetComponent<Canvas>();
                rows.Add(new NodeRow
                {
                    variant = variant,
                    name = rt.gameObject.name,
                    path = path,
                    parent = rt.parent != null ? rt.parent.name : "",
                    siblingIndex = rt.GetSiblingIndex(),
                    childCount = rt.childCount,
                    activeSelf = rt.gameObject.activeSelf,
                    activeInHierarchy = rt.gameObject.activeInHierarchy,
                    anchoredPosition = Vec2(rt.anchoredPosition),
                    sizeDelta = Vec2(rt.sizeDelta),
                    localScale = Vec3(rt.localScale),
                    anchorMin = Vec2(rt.anchorMin),
                    anchorMax = Vec2(rt.anchorMax),
                    pivot = Vec2(rt.pivot),
                    imageSprite = image != null && image.sprite != null ? image.sprite.name : "",
                    imageColor = image != null ? ColorText(image.color) : "",
                    raycastTarget = graphic != null && graphic.raycastTarget,
                    button = button != null,
                    buttonInteractable = button != null && button.interactable,
                    tmpText = tmp != null ? ShortText(tmp.text, 80) : "",
                    canvasSortingOrder = canvas != null ? canvas.sortingOrder : 0,
                    canvasOverrideSorting = canvas != null && canvas.overrideSorting,
                    components = Components(rt.gameObject)
                });
            }
            rows.Sort((a, b) => string.CompareOrdinal(a.path, b.path));
            return rows;
        }

        private static List<TmpRow> CollectTmpRows(string variant)
        {
            var rows = new List<TmpRow>();
            foreach (var tmp in UnityEngine.Object.FindObjectsByType<TMP_Text>(FindObjectsInactive.Include, FindObjectsSortMode.None))
            {
                if (!IsInterestingNode(tmp.gameObject.name, GetHierarchyPath(tmp.transform)) && !tmp.gameObject.activeInHierarchy)
                    continue;
                var rt = tmp.GetComponent<RectTransform>();
                rows.Add(new TmpRow
                {
                    variant = variant,
                    name = tmp.gameObject.name,
                    path = GetHierarchyPath(tmp.transform),
                    activeInHierarchy = tmp.gameObject.activeInHierarchy,
                    text = ShortText(tmp.text, 100),
                    fontSize = tmp.fontSize,
                    enableAutoSizing = tmp.enableAutoSizing,
                    fontSizeMin = tmp.fontSizeMin,
                    fontSizeMax = tmp.fontSizeMax,
                    font = tmp.font != null ? tmp.font.name : "",
                    material = tmp.fontSharedMaterial != null ? tmp.fontSharedMaterial.name : "",
                    materialShader = tmp.fontSharedMaterial != null && tmp.fontSharedMaterial.shader != null ? tmp.fontSharedMaterial.shader.name : "",
                    color = ColorText(tmp.color),
                    localScale = rt != null ? Vec3(rt.localScale) : "",
                    sizeDelta = rt != null ? Vec2(rt.sizeDelta) : "",
                    raycastTarget = tmp.raycastTarget
                });
            }
            rows.Sort((a, b) => string.CompareOrdinal(a.path, b.path));
            return rows;
        }

        private static List<MaskRow> CollectMaskRows(string variant)
        {
            var rows = new List<MaskRow>();
            foreach (var mask in UnityEngine.Object.FindObjectsByType<Mask>(FindObjectsInactive.Include, FindObjectsSortMode.None))
            {
                rows.Add(new MaskRow
                {
                    variant = variant,
                    kind = "Mask",
                    name = mask.gameObject.name,
                    path = GetHierarchyPath(mask.transform),
                    activeInHierarchy = mask.gameObject.activeInHierarchy,
                    enabled = mask.enabled,
                    showMaskGraphic = mask.showMaskGraphic,
                    raycastTarget = mask.graphic != null && mask.graphic.raycastTarget
                });
            }
            foreach (var mask in UnityEngine.Object.FindObjectsByType<RectMask2D>(FindObjectsInactive.Include, FindObjectsSortMode.None))
            {
                rows.Add(new MaskRow
                {
                    variant = variant,
                    kind = "RectMask2D",
                    name = mask.gameObject.name,
                    path = GetHierarchyPath(mask.transform),
                    activeInHierarchy = mask.gameObject.activeInHierarchy,
                    enabled = mask.enabled
                });
            }
            foreach (var graphic in UnityEngine.Object.FindObjectsByType<Graphic>(FindObjectsInactive.Include, FindObjectsSortMode.None))
            {
                var material = graphic.materialForRendering;
                if (material == null || !material.HasProperty("_Stencil"))
                    continue;
                var stencil = material.GetFloat("_Stencil");
                if (Math.Abs(stencil) < 0.001f)
                    continue;
                rows.Add(new MaskRow
                {
                    variant = variant,
                    kind = "GraphicMaterialStencil",
                    name = graphic.gameObject.name,
                    path = GetHierarchyPath(graphic.transform),
                    activeInHierarchy = graphic.gameObject.activeInHierarchy,
                    enabled = graphic.enabled,
                    raycastTarget = graphic.raycastTarget,
                    material = material.name,
                    shader = material.shader != null ? material.shader.name : "",
                    stencil = stencil,
                    stencilComp = material.HasProperty("_StencilComp") ? material.GetFloat("_StencilComp") : 0f,
                    stencilOp = material.HasProperty("_StencilOp") ? material.GetFloat("_StencilOp") : 0f
                });
            }
            rows.Sort((a, b) => string.CompareOrdinal(a.path + a.kind, b.path + b.kind));
            return rows;
        }

        private static List<SkeletonRow> CollectSkeletonRows(string variant)
        {
            var rows = new List<SkeletonRow>();
            foreach (var sg in UnityEngine.Object.FindObjectsByType<SkeletonGraphic>(FindObjectsInactive.Include, FindObjectsSortMode.None))
            {
                var rt = sg.GetComponent<RectTransform>();
                var material = sg.material != null ? sg.material : sg.materialForRendering;
                rows.Add(new SkeletonRow
                {
                    variant = variant,
                    name = sg.gameObject.name,
                    path = GetHierarchyPath(sg.transform),
                    activeInHierarchy = sg.gameObject.activeInHierarchy,
                    enabled = sg.enabled,
                    skeletonDataAsset = sg.skeletonDataAsset != null ? sg.skeletonDataAsset.name : "",
                    startingAnimation = sg.startingAnimation,
                    startingLoop = sg.startingLoop,
                    raycastTarget = sg.raycastTarget,
                    maskable = sg.maskable,
                    allowMultipleCanvasRenderers = sg.allowMultipleCanvasRenderers,
                    material = material != null ? material.name : "",
                    shader = material != null && material.shader != null ? material.shader.name : "",
                    texture = material != null && material.mainTexture != null ? material.mainTexture.name : "",
                    localScale = rt != null ? Vec3(rt.localScale) : "",
                    sizeDelta = rt != null ? Vec2(rt.sizeDelta) : "",
                    anchoredPosition = rt != null ? Vec2(rt.anchoredPosition) : ""
                });
            }
            rows.Sort((a, b) => string.CompareOrdinal(a.path, b.path));
            return rows;
        }

        private static List<DecisionRow> BuildDecisionRows()
        {
            return new List<DecisionRow>
            {
                new DecisionRow
                {
                    item = "capture_aspect",
                    finding = "Reference image is 1180x526 / 2.243346 while previous captures were 1680x720 / 2.333333.",
                    action = "UI149 captures both variants at 1180x526 for coordinate/framing validation.",
                    productionPatchAllowed = true
                },
                new DecisionRow
                {
                    item = "default_root_route_active_state",
                    finding = "Default root preserves source CSV active state for route/world nodes such as right/node_middle/wanfaWorldNode/worldwanfaBtn/spine_diqiu.",
                    action = "Do not hide guarded route nodes without runtime active/sibling evidence; compare against old-root candidate instead.",
                    productionPatchAllowed = false
                },
                new DecisionRow
                {
                    item = "oldroot_home_candidate",
                    finding = "UI_MainInterface_old is the strongest static prefab/open-stack candidate for the attached home reference.",
                    action = "Build a separate candidate scene with only source-backed BG1005 and Hero1005 SkeletonGraphic applied.",
                    productionPatchAllowed = false
                },
                new DecisionRow
                {
                    item = "ui_dock_bottom_nav",
                    finding = "Source-backed UI_Dock renderer/root-canvas candidates compile, but UI136/UI144 visual metrics trail UI128.",
                    action = "Keep UI_Dock promotion blocked pending runtime parent/depth/mask/open-stack evidence.",
                    productionPatchAllowed = false
                },
                new DecisionRow
                {
                    item = "dynamic_activity_chat_account_currency",
                    finding = "Activity slots, chat text, account/profile, and currencies depend on server/account runtime values.",
                    action = "No fake labels, no forced hides, and no currency/chat value patches without UI130-compatible snapshot.",
                    productionPatchAllowed = false
                },
                new DecisionRow
                {
                    item = "tmp_mask_stencil_skeleton_material",
                    finding = "Static TMP/material lanes are auditable; runtime mask/stencil/effective renderer state still decides final draw order.",
                    action = "Audit actual TMP autosize/material, mask/stencil rows, and SkeletonGraphic bindings in both captures.",
                    productionPatchAllowed = false
                }
            };
        }

        private static int CountActiveContains(List<NodeRow> rows, params string[] needles)
        {
            var count = 0;
            foreach (var row in rows)
            {
                if (!row.activeInHierarchy)
                    continue;
                foreach (var needle in needles)
                {
                    if (row.path.IndexOf(needle, StringComparison.OrdinalIgnoreCase) >= 0)
                    {
                        count++;
                        break;
                    }
                }
            }
            return count;
        }

        private static int CountActiveNodes(List<NodeRow> rows)
        {
            var count = 0;
            foreach (var row in rows)
                if (row.activeInHierarchy)
                    count++;
            return count;
        }

        private static int CountTmpAutoSize(List<TmpRow> rows)
        {
            var count = 0;
            foreach (var row in rows)
                if (row.enableAutoSizing)
                    count++;
            return count;
        }

        private static int CountNonZeroStencil(List<MaskRow> rows)
        {
            var count = 0;
            foreach (var row in rows)
                if (Math.Abs(row.stencil) > 0.001f)
                    count++;
            return count;
        }

        private static bool IsInterestingNode(string name, string path)
        {
            var text = (name + " " + path).ToLowerInvariant();
            string[] needles =
            {
                "ui_bg",
                "ui_herospine",
                "ui_touchspine",
                "right",
                "left",
                "middle",
                "node_middle",
                "wanfaworld",
                "worldwanfa",
                "spine_diqiu",
                "zhuye",
                "route_fallback",
                "node_bottom",
                "toogles",
                "btntoggle",
                "ui_dock",
                "ui_mainpage",
                "btn_discord",
                "node_act",
                "btn_act",
                "chat",
                "mail",
                "friend",
                "rank",
                "renwu",
                "story",
                "currency",
                "coin",
                "diamond",
                "profile",
                "head"
            };
            foreach (var needle in needles)
                if (text.Contains(needle))
                    return true;
            return false;
        }

        private static Transform FindTransformByPrefix(string prefix)
        {
            foreach (var transform in UnityEngine.Object.FindObjectsByType<Transform>(FindObjectsInactive.Include, FindObjectsSortMode.None))
                if (transform.gameObject.name.StartsWith(prefix, StringComparison.Ordinal))
                    return transform;
            return null;
        }

        private static Transform FindTransformByName(string name)
        {
            foreach (var transform in UnityEngine.Object.FindObjectsByType<Transform>(FindObjectsInactive.Include, FindObjectsSortMode.None))
                if (string.Equals(transform.gameObject.name, name, StringComparison.Ordinal))
                    return transform;
            return null;
        }

        private static void EnsureActiveInHierarchy(Transform transform)
        {
            var current = transform;
            while (current != null)
            {
                current.gameObject.SetActive(true);
                current = current.parent;
            }
        }

        private static void ForceSpineUpdate()
        {
            Canvas.ForceUpdateCanvases();
            foreach (var skeleton in UnityEngine.Object.FindObjectsByType<SkeletonGraphic>(FindObjectsInactive.Include, FindObjectsSortMode.None))
            {
                skeleton.Initialize(false);
                skeleton.Update(0f);
                skeleton.LateUpdate();
            }
            Canvas.ForceUpdateCanvases();
        }

        private static string GetHierarchyPath(Component component)
        {
            return component != null ? GetHierarchyPath(component.transform) : "";
        }

        private static string GetHierarchyPath(Transform transform)
        {
            if (transform == null)
                return "";
            var parts = new List<string>();
            var current = transform;
            while (current != null)
            {
                parts.Add(current.gameObject.name);
                current = current.parent;
            }
            parts.Reverse();
            return string.Join("/", parts);
        }

        private static string Components(GameObject go)
        {
            var names = new List<string>();
            foreach (var component in go.GetComponents<Component>())
                names.Add(component != null ? component.GetType().Name : "MissingScript");
            return string.Join("|", names);
        }

        private static string Vec2(Vector2 value)
        {
            return value.x.ToString("0.###", CultureInfo.InvariantCulture) + "," + value.y.ToString("0.###", CultureInfo.InvariantCulture);
        }

        private static string Vec3(Vector3 value)
        {
            return value.x.ToString("0.###", CultureInfo.InvariantCulture) + "," + value.y.ToString("0.###", CultureInfo.InvariantCulture) + "," + value.z.ToString("0.###", CultureInfo.InvariantCulture);
        }

        private static string ColorText(Color color)
        {
            return color.r.ToString("0.###", CultureInfo.InvariantCulture) + ","
                + color.g.ToString("0.###", CultureInfo.InvariantCulture) + ","
                + color.b.ToString("0.###", CultureInfo.InvariantCulture) + ","
                + color.a.ToString("0.###", CultureInfo.InvariantCulture);
        }

        private static string ShortText(string text, int max)
        {
            if (string.IsNullOrEmpty(text))
                return "";
            text = text.Replace("\r", "\\r").Replace("\n", "\\n");
            return text.Length <= max ? text : text.Substring(0, max) + "...";
        }

        private static string Csv(string value)
        {
            if (string.IsNullOrEmpty(value))
                return "";
            return "\"" + value.Replace("\"", "\"\"") + "\"";
        }

        private static void WriteAllOutputs(AuditResult result)
        {
            File.WriteAllText(ResultJsonPath, JsonUtility.ToJson(result, true), Encoding.UTF8);
            WriteNodeCsv(result);
            WriteTmpCsv(result);
            WriteMaskCsv(result);
            WriteSkeletonCsv(result);
            WriteDecisionCsv(result);
            WriteReport(result);
        }

        private static void WriteNodeCsv(AuditResult result)
        {
            var sb = new StringBuilder();
            sb.AppendLine("variant,name,path,parent,siblingIndex,childCount,activeSelf,activeInHierarchy,anchoredPosition,sizeDelta,localScale,anchorMin,anchorMax,pivot,imageSprite,imageColor,raycastTarget,button,buttonInteractable,tmpText,canvasSortingOrder,canvasOverrideSorting,components");
            foreach (var variant in result.variants)
            {
                foreach (var row in variant.nodes)
                {
                    sb.Append(Csv(row.variant)).Append(',').Append(Csv(row.name)).Append(',').Append(Csv(row.path)).Append(',').Append(Csv(row.parent)).Append(',');
                    sb.Append(row.siblingIndex).Append(',').Append(row.childCount).Append(',').Append(row.activeSelf).Append(',').Append(row.activeInHierarchy).Append(',');
                    sb.Append(Csv(row.anchoredPosition)).Append(',').Append(Csv(row.sizeDelta)).Append(',').Append(Csv(row.localScale)).Append(',');
                    sb.Append(Csv(row.anchorMin)).Append(',').Append(Csv(row.anchorMax)).Append(',').Append(Csv(row.pivot)).Append(',');
                    sb.Append(Csv(row.imageSprite)).Append(',').Append(Csv(row.imageColor)).Append(',').Append(row.raycastTarget).Append(',');
                    sb.Append(row.button).Append(',').Append(row.buttonInteractable).Append(',').Append(Csv(row.tmpText)).Append(',');
                    sb.Append(row.canvasSortingOrder).Append(',').Append(row.canvasOverrideSorting).Append(',').AppendLine(Csv(row.components));
                }
            }
            File.WriteAllText(NodeCsvPath, sb.ToString(), Encoding.UTF8);
        }

        private static void WriteTmpCsv(AuditResult result)
        {
            var sb = new StringBuilder();
            sb.AppendLine("variant,name,path,activeInHierarchy,text,fontSize,enableAutoSizing,fontSizeMin,fontSizeMax,font,material,materialShader,color,localScale,sizeDelta,raycastTarget");
            foreach (var variant in result.variants)
            {
                foreach (var row in variant.tmpRows)
                {
                    sb.Append(Csv(row.variant)).Append(',').Append(Csv(row.name)).Append(',').Append(Csv(row.path)).Append(',').Append(row.activeInHierarchy).Append(',');
                    sb.Append(Csv(row.text)).Append(',').Append(row.fontSize.ToString("0.###", CultureInfo.InvariantCulture)).Append(',').Append(row.enableAutoSizing).Append(',');
                    sb.Append(row.fontSizeMin.ToString("0.###", CultureInfo.InvariantCulture)).Append(',').Append(row.fontSizeMax.ToString("0.###", CultureInfo.InvariantCulture)).Append(',');
                    sb.Append(Csv(row.font)).Append(',').Append(Csv(row.material)).Append(',').Append(Csv(row.materialShader)).Append(',');
                    sb.Append(Csv(row.color)).Append(',').Append(Csv(row.localScale)).Append(',').Append(Csv(row.sizeDelta)).Append(',').AppendLine(row.raycastTarget.ToString());
                }
            }
            File.WriteAllText(TmpCsvPath, sb.ToString(), Encoding.UTF8);
        }

        private static void WriteMaskCsv(AuditResult result)
        {
            var sb = new StringBuilder();
            sb.AppendLine("variant,kind,name,path,activeInHierarchy,enabled,showMaskGraphic,raycastTarget,material,shader,stencil,stencilComp,stencilOp");
            foreach (var variant in result.variants)
            {
                foreach (var row in variant.maskRows)
                {
                    sb.Append(Csv(row.variant)).Append(',').Append(Csv(row.kind)).Append(',').Append(Csv(row.name)).Append(',').Append(Csv(row.path)).Append(',');
                    sb.Append(row.activeInHierarchy).Append(',').Append(row.enabled).Append(',').Append(row.showMaskGraphic).Append(',').Append(row.raycastTarget).Append(',');
                    sb.Append(Csv(row.material)).Append(',').Append(Csv(row.shader)).Append(',');
                    sb.Append(row.stencil.ToString("0.###", CultureInfo.InvariantCulture)).Append(',');
                    sb.Append(row.stencilComp.ToString("0.###", CultureInfo.InvariantCulture)).Append(',');
                    sb.AppendLine(row.stencilOp.ToString("0.###", CultureInfo.InvariantCulture));
                }
            }
            File.WriteAllText(MaskCsvPath, sb.ToString(), Encoding.UTF8);
        }

        private static void WriteSkeletonCsv(AuditResult result)
        {
            var sb = new StringBuilder();
            sb.AppendLine("variant,name,path,activeInHierarchy,enabled,skeletonDataAsset,startingAnimation,startingLoop,raycastTarget,maskable,allowMultipleCanvasRenderers,material,shader,texture,anchoredPosition,sizeDelta,localScale");
            foreach (var variant in result.variants)
            {
                foreach (var row in variant.skeletonRows)
                {
                    sb.Append(Csv(row.variant)).Append(',').Append(Csv(row.name)).Append(',').Append(Csv(row.path)).Append(',').Append(row.activeInHierarchy).Append(',');
                    sb.Append(row.enabled).Append(',').Append(Csv(row.skeletonDataAsset)).Append(',').Append(Csv(row.startingAnimation)).Append(',').Append(row.startingLoop).Append(',');
                    sb.Append(row.raycastTarget).Append(',').Append(row.maskable).Append(',').Append(row.allowMultipleCanvasRenderers).Append(',');
                    sb.Append(Csv(row.material)).Append(',').Append(Csv(row.shader)).Append(',').Append(Csv(row.texture)).Append(',');
                    sb.Append(Csv(row.anchoredPosition)).Append(',').Append(Csv(row.sizeDelta)).Append(',').AppendLine(Csv(row.localScale));
                }
            }
            File.WriteAllText(SkeletonCsvPath, sb.ToString(), Encoding.UTF8);
        }

        private static void WriteDecisionCsv(AuditResult result)
        {
            var sb = new StringBuilder();
            sb.AppendLine("item,finding,action,productionPatchAllowed");
            foreach (var row in result.decisions)
            {
                sb.Append(Csv(row.item)).Append(',').Append(Csv(row.finding)).Append(',').Append(Csv(row.action)).Append(',').AppendLine(row.productionPatchAllowed.ToString());
            }
            File.WriteAllText(DecisionCsvPath, sb.ToString(), Encoding.UTF8);
        }

        private static void WriteReport(AuditResult result)
        {
            var sb = new StringBuilder();
            sb.AppendLine("# MAININTERFACE 149 Reference Aspect Runtime State Audit And Safe Capture");
            sb.AppendLine();
            sb.AppendLine("Generated: " + result.generatedAt);
            sb.AppendLine();
            sb.AppendLine("## Verdict");
            sb.AppendLine();
            sb.AppendLine("- restoredClaim: `" + result.restoredClaim + "`");
            sb.AppendLine("- candidatePatchApplied: `" + result.candidatePatchApplied + "`");
            sb.AppendLine("- productionPatchApplied: `" + result.productionPatchApplied + "`");
            sb.AppendLine("- status: `" + result.status + "`");
            if (!string.IsNullOrWhiteSpace(result.error))
                sb.AppendLine("- error: `" + result.error + "`");
            sb.AppendLine();
            sb.AppendLine(result.summary);
            sb.AppendLine();
            sb.AppendLine("## Reference Aspect");
            sb.AppendLine();
            sb.AppendLine("- reference: `" + result.referenceWidth + "x" + result.referenceHeight + "` / `" + result.referenceAspect.ToString("0.######", CultureInfo.InvariantCulture) + "`");
            sb.AppendLine("- previous candidate captures were `1680x720` / `2.333333`; UI149 emits reference-aspect captures at `1180x526`.");
            sb.AppendLine();
            sb.AppendLine("## Variant Metrics");
            sb.AppendLine();
            sb.AppendLine("| variant | capture | corr | meanAbsDiff | changed30 | routeActive | homeActive | TMP autosize | nonzero stencil | SkeletonGraphic |");
            sb.AppendLine("| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |");
            foreach (var variant in result.variants)
            {
                sb.Append("| `").Append(variant.label).Append("` | `").Append(variant.capturePath).Append("` | ");
                sb.Append(variant.diff.correlation.ToString("0.######", CultureInfo.InvariantCulture)).Append(" | ");
                sb.Append(variant.diff.meanAbsDiff.ToString("0.######", CultureInfo.InvariantCulture)).Append(" | ");
                sb.Append(variant.diff.changed30.ToString("0.######", CultureInfo.InvariantCulture)).Append(" | ");
                sb.Append(variant.routeActiveInterestingCount).Append(" | ");
                sb.Append(variant.homeInterestingCount).Append(" | ");
                sb.Append(variant.tmpAutoSizeRows).Append(" | ");
                sb.Append(variant.nonZeroStencilRows).Append(" | ");
                sb.Append(variant.skeletonGraphicRows).AppendLine(" |");
            }
            sb.AppendLine();
            sb.AppendLine("## Root Cause");
            sb.AppendLine();
            sb.AppendLine("- The default scene root is still a source CSV route/world state; active route nodes are preserved by the builder and are not a sibling-order or clipping bug.");
            sb.AppendLine("- The reference is a home/lobby state. `UI_MainInterface_old` plus BG1005/Hero1005 is the best static candidate, but it still lacks runtime UI_Dock parent/depth/mask/open-stack and dynamic activity/chat/account/currency values.");
            sb.AppendLine("- CanvasScaler is now audited separately from the capture aspect: the generated Canvas still uses `ScaleWithScreenSize`, while UI149 only changes the validation render target to the attached reference size.");
            sb.AppendLine("- TMP autosize/material and mask/stencil rows are exported so text scale and clipping can be checked without guessing dynamic labels.");
            sb.AppendLine();
            sb.AppendLine("## Outputs");
            sb.AppendLine();
            sb.AppendLine("- JSON: `" + Path.GetFullPath(ResultJsonPath) + "`");
            sb.AppendLine("- node audit CSV: `" + Path.GetFullPath(NodeCsvPath) + "`");
            sb.AppendLine("- TMP audit CSV: `" + Path.GetFullPath(TmpCsvPath) + "`");
            sb.AppendLine("- mask/stencil CSV: `" + Path.GetFullPath(MaskCsvPath) + "`");
            sb.AppendLine("- SkeletonGraphic CSV: `" + Path.GetFullPath(SkeletonCsvPath) + "`");
            sb.AppendLine("- decision matrix CSV: `" + Path.GetFullPath(DecisionCsvPath) + "`");
            sb.AppendLine();
            sb.AppendLine("## Next Blocker");
            sb.AppendLine();
            sb.AppendLine("Need an approved original-runtime UI snapshot/dump for UI_Dock/UI_MainPage parent/depth/mask/open-stack and UI130-compatible activity/account/chat/currency fields before promoting the old-root candidate as restored.");
            File.WriteAllText(ReportMdPath, sb.ToString(), Encoding.UTF8);
        }

        [Serializable]
        private sealed class AuditResult
        {
            public string generatedAt;
            public string status;
            public string error;
            public bool restoredClaim;
            public bool candidatePatchApplied;
            public bool productionPatchApplied;
            public string summary;
            public string referenceImagePath;
            public int referenceWidth;
            public int referenceHeight;
            public float referenceAspect;
            public List<VariantResult> variants = new List<VariantResult>();
            public List<DecisionRow> decisions = new List<DecisionRow>();
        }

        [Serializable]
        private sealed class VariantResult
        {
            public string label;
            public string rootRectId;
            public string scenePath;
            public string capturePath;
            public bool sourceBackedHomeStateApplied;
            public string heroPath;
            public string backgroundPath;
            public string backgroundSpritePath;
            public CanvasState canvas;
            public CaptureInfo capture;
            public DiffMetrics diff;
            public int routeActiveInterestingCount;
            public int homeInterestingCount;
            public int tmpAutoSizeRows;
            public int nonZeroStencilRows;
            public int skeletonGraphicRows;
            public int activeNodeRows;
            public List<string> decisions = new List<string>();
            public List<NodeRow> nodes = new List<NodeRow>();
            public List<TmpRow> tmpRows = new List<TmpRow>();
            public List<MaskRow> maskRows = new List<MaskRow>();
            public List<SkeletonRow> skeletonRows = new List<SkeletonRow>();
        }

        [Serializable]
        private sealed class CanvasState
        {
            public string renderMode;
            public int sortingOrder;
            public bool overrideSorting;
            public string scalerMode;
            public string referenceResolution;
            public string screenMatchMode;
            public float matchWidthOrHeight;
        }

        [Serializable]
        private sealed class CaptureInfo
        {
            public bool exists;
            public string path;
            public int width;
            public int height;
            public float aspect;
            public int visiblePixelCount;
            public int uniqueColorCount;
            public string bounds;
        }

        [Serializable]
        private sealed class DiffMetrics
        {
            public string referencePath;
            public string capturePath;
            public bool referenceExists;
            public bool captureExists;
            public bool sizeMismatch;
            public int referenceWidth;
            public int referenceHeight;
            public int captureWidth;
            public int captureHeight;
            public float meanAbsDiff;
            public float changed30;
            public float correlation;
        }

        [Serializable]
        private sealed class NodeRow
        {
            public string variant;
            public string name;
            public string path;
            public string parent;
            public int siblingIndex;
            public int childCount;
            public bool activeSelf;
            public bool activeInHierarchy;
            public string anchoredPosition;
            public string sizeDelta;
            public string localScale;
            public string anchorMin;
            public string anchorMax;
            public string pivot;
            public string imageSprite;
            public string imageColor;
            public bool raycastTarget;
            public bool button;
            public bool buttonInteractable;
            public string tmpText;
            public int canvasSortingOrder;
            public bool canvasOverrideSorting;
            public string components;
        }

        [Serializable]
        private sealed class TmpRow
        {
            public string variant;
            public string name;
            public string path;
            public bool activeInHierarchy;
            public string text;
            public float fontSize;
            public bool enableAutoSizing;
            public float fontSizeMin;
            public float fontSizeMax;
            public string font;
            public string material;
            public string materialShader;
            public string color;
            public string localScale;
            public string sizeDelta;
            public bool raycastTarget;
        }

        [Serializable]
        private sealed class MaskRow
        {
            public string variant;
            public string kind;
            public string name;
            public string path;
            public bool activeInHierarchy;
            public bool enabled;
            public bool showMaskGraphic;
            public bool raycastTarget;
            public string material;
            public string shader;
            public float stencil;
            public float stencilComp;
            public float stencilOp;
        }

        [Serializable]
        private sealed class SkeletonRow
        {
            public string variant;
            public string name;
            public string path;
            public bool activeInHierarchy;
            public bool enabled;
            public string skeletonDataAsset;
            public string startingAnimation;
            public bool startingLoop;
            public bool raycastTarget;
            public bool maskable;
            public bool allowMultipleCanvasRenderers;
            public string material;
            public string shader;
            public string texture;
            public string anchoredPosition;
            public string sizeDelta;
            public string localScale;
        }

        [Serializable]
        private sealed class DecisionRow
        {
            public string item;
            public string finding;
            public string action;
            public bool productionPatchAllowed;
        }
    }
}
