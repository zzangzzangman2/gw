using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using Spine.Unity;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.UI;

namespace GirlsWarRestore
{
    public static class MainInterface135Hero1005HomeParaBackFrontCandidate
    {
        private const string OldRootRectId = "2475216337245998118";
        private const string ScenePath = "Assets/Scenes/MainInterface_UI135_Hero1005HomeParaBackFrontCandidate.unity";
        private const string CapturePath = "Assets/RestoreCaptures/maininterface_ui135_hero1005_homepara_backfront_candidate_1680x720.png";
        private const string HeroRoot = "Assets/RestoreData/hero1005_spine_source_raw/paintingprefabandres_1005";
        private const string UiBgSpritePath = "Assets/RestoredSprites/maininterface/runtime_dynamic/runtime_UI_bg_noalphabg_PaintingBG_1005.png";
        private const string ReportDir = "C:/Users/godho/Downloads/girlswar/reports/maininterface";
        private const string TransformCsv = ReportDir + "/MAININTERFACE_135_hero_transform_before_after.csv";
        private const string LayerCsv = ReportDir + "/MAININTERFACE_135_back_front_layer_evidence_probe.csv";
        private const string CandidateJson = "Assets/RestoreData/reports/maininterface_135_hero1005_homepara_backfront_candidate_summary.json";
        private const string ClickCsv = "Assets/RestoreData/reports/maininterface_135_click_validation.csv";
        private const string ClickJson = "Assets/RestoreData/reports/maininterface_135_click_validation_summary.json";
        private const string DefaultGraphicMaterialPath = "Assets/Spine/Runtime/spine-unity/Materials/SkeletonGraphicDefault.mat";
        private const string AdditiveGraphicMaterialPath = "Assets/Spine/Runtime/spine-unity/Materials/SkeletonGraphicAdditive.mat";
        private const string ScreenGraphicMaterialPath = "Assets/Spine/Runtime/spine-unity/Materials/SkeletonGraphicScreen.mat";
        private const float ReferenceWidth = 1680f;
        private const float ReferenceHeight = 720f;

        [MenuItem("GirlsWar/UI135 Hero1005 HomePara Back Front Candidate Capture")]
        public static void BuildCaptureAndValidate()
        {
            Directory.CreateDirectory("Assets/Scenes");
            Directory.CreateDirectory("Assets/RestoreCaptures");
            Directory.CreateDirectory("Assets/RestoreData/reports");
            Directory.CreateDirectory(ReportDir);

            var result = new CandidateResult
            {
                generatedAt = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture),
                restoredClaim = false,
                scenePath = ScenePath,
                capturePath = CapturePath,
                decisions = new List<string>(),
                transformRows = new List<TransformRow>(),
                layerRows = new List<LayerRow>()
            };

            try
            {
                ProbeExistingCandidate(result);
                MainInterfaceSceneBuilder.BuildMainInterfaceSceneForRoot(
                    OldRootRectId,
                    ScenePath,
                    "MainInterface_UI135_Hero1005HomeParaBackFrontCandidate");
                var scene = EditorSceneManager.OpenScene(ScenePath, OpenSceneMode.Single);

                ApplyBg1005(result);
                AttachHero1005Layers(result);
                ForceSpineUpdate();
                EditorSceneManager.SaveScene(scene, ScenePath);
                result.sceneSaved = true;

                var canvas = UnityEngine.Object.FindFirstObjectByType<Canvas>();
                if (canvas == null)
                    throw new Exception("Canvas not found after UI135 candidate build.");
                result.capture = Capture(canvas, CapturePath);
                result.clickSummary = ValidateClicks(canvas, ClickCsv, ClickJson);
                result.status = "ui135_hero1005_homepara_backfront_candidate_capture_generated";
                result.patchDecision = "candidate_patch_homepara_noop_and_back_layer_probe_no_dock_patch";
                result.decisions.Add("Applied decoded UIUtil homePara semantics only to the actual Painting_1005 SkeletonGraphic child: scale=1, local x=0, local y=0, no x flip.");
                result.decisions.Add("Mounted Painting_1005_back only because original Painting_1005_back atlas/skel/png source files exist; no Painting_1005_front source was found, so no front layer was created.");
                result.decisions.Add("Did not modify bottom nav/UI_Dock, node_bottom/toogles, activity slots, btn_discord, UI_bg raycast/interactable, or route/world nodes.");
            }
            catch (Exception ex)
            {
                result.status = "ui135_failed";
                result.error = ex.GetType().Name + ": " + ex.Message;
                WriteOutputs(result);
                Debug.LogException(ex);
                throw;
            }

            WriteOutputs(result);
            AssetDatabase.Refresh(ImportAssetOptions.ForceSynchronousImport);
            Debug.Log("[GirlsWarRestore] UI135 Hero1005 homePara/back-front candidate complete: " + CapturePath);
        }

        private static void ProbeExistingCandidate(CandidateResult result)
        {
            var existing = "Assets/Scenes/MainInterface_UI126_OldRootReferenceCandidate.unity";
            if (!File.Exists(existing))
            {
                result.decisions.Add("No existing UI126/UI128 old-root candidate scene was present to probe before rebuild.");
                return;
            }
            EditorSceneManager.OpenScene(existing, OpenSceneMode.Single);
            foreach (var transform in UnityEngine.Object.FindObjectsByType<Transform>(FindObjectsInactive.Include, FindObjectsSortMode.None))
            {
                if (transform.name.IndexOf("Painting_1005", StringComparison.OrdinalIgnoreCase) < 0 &&
                    transform.name.IndexOf("Restore_Hero1005", StringComparison.OrdinalIgnoreCase) < 0 &&
                    transform.name.IndexOf("UI_heroSpine", StringComparison.OrdinalIgnoreCase) < 0)
                    continue;
                result.transformRows.Add(BuildTransformRow("existing_candidate_before_rebuild", transform, "probe_existing_ui128_candidate"));
            }
        }

        private static void ApplyBg1005(CandidateResult result)
        {
            var background = FindTransformByPrefix("UI_bg__-3280973633984018659") ?? FindTransformByName("UI_bg");
            if (background == null)
                throw new Exception("UI_bg target not found for UI135 old-root candidate.");
            background.gameObject.SetActive(true);
            var image = background.GetComponent<Image>();
            if (image == null)
                image = background.gameObject.AddComponent<Image>();
            var sprite = AssetDatabase.LoadAssetAtPath<Sprite>(UiBgSpritePath);
            if (sprite == null)
                throw new Exception("BG1005 sprite missing: " + UiBgSpritePath);
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
            rect.sizeDelta = new Vector2(ReferenceWidth, ReferenceHeight);
            rect.localScale = Vector3.one;
            background.SetSiblingIndex(0);
            result.backgroundPath = GetHierarchyPath(background);
        }

        private static void AttachHero1005Layers(CandidateResult result)
        {
            var heroParent = FindTransformByPrefix("UI_heroSpine__") ?? FindTransformByName("UI_heroSpine");
            if (heroParent == null)
                throw new Exception("UI_heroSpine not found in UI135 old-root candidate.");
            EnsureActiveInHierarchy(heroParent);

            var previous = heroParent.Find("Restore_Hero1005_SpineRoot_UI135");
            if (previous != null)
                UnityEngine.Object.DestroyImmediate(previous.gameObject);

            var root = new GameObject("Restore_Hero1005_SpineRoot_UI135", typeof(RectTransform));
            var rootRect = root.GetComponent<RectTransform>();
            rootRect.SetParent(heroParent, false);
            rootRect.anchorMin = Vector2.zero;
            rootRect.anchorMax = Vector2.one;
            rootRect.offsetMin = Vector2.zero;
            rootRect.offsetMax = Vector2.zero;
            rootRect.pivot = new Vector2(0.5f, 0.5f);
            rootRect.anchoredPosition = Vector2.zero;
            rootRect.localScale = Vector3.one;
            rootRect.localRotation = Quaternion.identity;
            result.transformRows.Add(BuildTransformRow("after_root_create", rootRect, "pooled paintingGroup root equivalent; local zero per decoded UIUtil"));

            AttachLayerIfSourceBacked(result, rootRect, "Painting_1005_back", "back", true, "source_back_layer_probe");
            var main = AttachLayerIfSourceBacked(result, rootRect, "Painting_1005", "main", true, "source_main_layer_homepara_target");
            ApplyHomePara1005(result, main);
            AttachLayerIfSourceBacked(result, rootRect, "Painting_1005_front", "front", false, "front_source_missing_no_patch");

            result.heroParentPath = GetHierarchyPath(heroParent);
            result.heroRootPath = GetHierarchyPath(rootRect);
        }

        private static SkeletonGraphic AttachLayerIfSourceBacked(CandidateResult result, RectTransform parent, string baseName, string role, bool expectedSource, string decision)
        {
            var source = new LayerSource(baseName);
            var row = new LayerRow
            {
                layer = role,
                baseName = baseName,
                atlasPath = source.AtlasText,
                skeletonPath = source.SkeletonBytes,
                texturePath = source.TexturePng,
                sourceExists = File.Exists(source.AtlasText) && File.Exists(source.SkeletonBytes) && File.Exists(source.TexturePng),
                decision = decision,
                mounted = false
            };
            if (!row.sourceExists)
            {
                row.decision = expectedSource ? "blocked_missing_required_source" : "source_missing_no_front_layer_created";
                row.detail = "No complete atlas/skel/png source triplet exists for " + baseName + "; UIUtil only plays front/back if such children exist.";
                result.layerRows.Add(row);
                return null;
            }

            PrepareTextureImport(source.TexturePng);
            var skeletonDataAsset = EnsureSkeletonAssets(source);
            row.skeletonDataAssetPath = source.SkeletonDataAsset;
            var skeletonData = skeletonDataAsset.GetSkeletonData(true);
            row.bones = skeletonData.Bones.Count;
            row.slots = skeletonData.Slots.Count;
            row.animations = skeletonData.Animations.Count;
            row.hasAnimationA = skeletonData.FindAnimation("A") != null;
            if (!row.hasAnimationA)
            {
                row.decision = "blocked_no_animation_A";
                row.detail = "Source exists, but animation A was not found; no fake/default animation was assigned.";
                result.layerRows.Add(row);
                return null;
            }

            var material = AssetDatabase.LoadAssetAtPath<Material>(source.Material);
            if (material == null)
                throw new Exception("Missing material after EnsureSkeletonAssets: " + source.Material);
            var graphic = SkeletonGraphic.NewSkeletonGraphicGameObject(skeletonDataAsset, parent, material);
            graphic.gameObject.name = baseName;
            graphic.raycastTarget = false;
            graphic.maskable = true;
            graphic.allowMultipleCanvasRenderers = true;
            graphic.startingAnimation = "A";
            graphic.startingLoop = true;
            graphic.additiveMaterial = AssetDatabase.LoadAssetAtPath<Material>(source.AdditiveMaterial);
            graphic.screenMaterial = AssetDatabase.LoadAssetAtPath<Material>(source.ScreenMaterial);

            var rect = graphic.GetComponent<RectTransform>();
            rect.anchorMin = new Vector2(0.5f, 0.5f);
            rect.anchorMax = new Vector2(0.5f, 0.5f);
            rect.pivot = new Vector2(0.5f, 0.5f);
            rect.anchoredPosition = Vector2.zero;
            rect.sizeDelta = new Vector2(100f, 100f);
            rect.localRotation = Quaternion.identity;
            rect.localScale = Vector3.one;

            graphic.Initialize(true);
            graphic.AnimationState.SetAnimation(0, "A", true);
            graphic.Update(0f);
            graphic.UpdateMesh(true);
            graphic.MatchRectTransformWithBounds();
            graphic.UpdateMesh(true);

            row.mounted = true;
            row.scenePath = GetHierarchyPath(graphic.transform);
            row.rectSize = Vec2(rect.sizeDelta);
            row.localPosition = Vec3(rect.localPosition);
            row.localScale = Vec3(rect.localScale);
            row.detail = role == "main"
                ? "Main Painting_1005 child mounted as the decoded UIUtil homePara target; whole PNG Image was not used."
                : "Back layer mounted as source-backed SkeletonGraphic probe. No coordinate-only offset was applied.";
            result.layerRows.Add(row);
            result.transformRows.Add(BuildTransformRow("after_layer_mount_" + role, rect, row.detail));
            return graphic;
        }

        private static void ApplyHomePara1005(CandidateResult result, SkeletonGraphic main)
        {
            if (main == null)
            {
                result.decisions.Add("Painting_1005 main layer was not available, so homePara could not be applied.");
                return;
            }
            var rect = main.GetComponent<RectTransform>();
            result.transformRows.Add(BuildTransformRow("before_homepara_apply", rect, "decoded homePara target before applying [1,0,0]"));
            rect.anchoredPosition = Vector2.zero;
            rect.localPosition = new Vector3(0f, 0f, rect.localPosition.z);
            rect.localScale = Vector3.one;
            result.transformRows.Add(BuildTransformRow("after_homepara_apply", rect, "homePara [1,0,0] applied to Painting_1005 child: scale 1, local x 0, local y 0, no flip"));
        }

        private static SkeletonDataAsset EnsureSkeletonAssets(LayerSource source)
        {
            var existing = AssetDatabase.LoadAssetAtPath<SkeletonDataAsset>(source.SkeletonDataAsset);
            if (existing != null && existing.GetSkeletonData(true) != null)
                return existing;

            DeleteAssetIfExists(source.SkeletonDataAsset);
            DeleteAssetIfExists(source.AtlasAsset);
            DeleteAssetIfExists(source.Material);
            DeleteAssetIfExists(source.AdditiveMaterial);
            DeleteAssetIfExists(source.ScreenMaterial);

            AssetDatabase.ImportAsset(source.TexturePng, ImportAssetOptions.ForceUpdate);
            AssetDatabase.ImportAsset(source.AtlasText, ImportAssetOptions.ForceUpdate);
            AssetDatabase.ImportAsset(source.SkeletonBytes, ImportAssetOptions.ForceUpdate);
            var atlasText = AssetDatabase.LoadAssetAtPath<TextAsset>(source.AtlasText);
            var skeletonText = AssetDatabase.LoadAssetAtPath<TextAsset>(source.SkeletonBytes);
            var texture = AssetDatabase.LoadAssetAtPath<Texture2D>(source.TexturePng);
            if (atlasText == null || skeletonText == null || texture == null)
                throw new Exception("Failed to load source files for " + source.BaseName);

            var material = CreateMaterial(source.Material, DefaultGraphicMaterialPath, texture, source.BaseName + "_Material");
            CreateMaterial(source.AdditiveMaterial, AdditiveGraphicMaterialPath, texture, source.BaseName + "_Material-Additive");
            CreateMaterial(source.ScreenMaterial, ScreenGraphicMaterialPath, texture, source.BaseName + "_Material-Screen");
            var atlasAsset = SpineAtlasAsset.CreateRuntimeInstance(atlasText, new[] { material }, true);
            atlasAsset.name = source.BaseName + "_Atlas";
            AssetDatabase.CreateAsset(atlasAsset, source.AtlasAsset);
            var skeletonDataAsset = SkeletonDataAsset.CreateRuntimeInstance(skeletonText, atlasAsset, true, 0.01f);
            skeletonDataAsset.name = source.BaseName + "_SkeletonData";
            AssetDatabase.CreateAsset(skeletonDataAsset, source.SkeletonDataAsset);
            AssetDatabase.SaveAssets();
            AssetDatabase.Refresh(ImportAssetOptions.ForceSynchronousImport);
            return AssetDatabase.LoadAssetAtPath<SkeletonDataAsset>(source.SkeletonDataAsset);
        }

        private static Material CreateMaterial(string path, string templatePath, Texture2D texture, string name)
        {
            var template = AssetDatabase.LoadAssetAtPath<Material>(templatePath);
            if (template == null)
                throw new Exception("Missing Spine material template: " + templatePath);
            var material = new Material(template)
            {
                name = name,
                mainTexture = texture
            };
            AssetDatabase.CreateAsset(material, path);
            return material;
        }

        private static void PrepareTextureImport(string path)
        {
            var importer = AssetImporter.GetAtPath(path) as TextureImporter;
            if (importer == null)
                return;
            var changed = false;
            if (importer.textureType != TextureImporterType.Default)
            {
                importer.textureType = TextureImporterType.Default;
                changed = true;
            }
            if (!importer.alphaIsTransparency)
            {
                importer.alphaIsTransparency = true;
                changed = true;
            }
            if (changed)
                importer.SaveAndReimport();
        }

        private static void DeleteAssetIfExists(string path)
        {
            if (AssetDatabase.LoadAssetAtPath<UnityEngine.Object>(path) != null)
                AssetDatabase.DeleteAsset(path);
        }

        private static CaptureMetrics Capture(Canvas canvas, string capturePath)
        {
            canvas.renderMode = RenderMode.ScreenSpaceCamera;
            var cameraGo = new GameObject("UI135_CaptureCamera", typeof(Camera));
            var camera = cameraGo.GetComponent<Camera>();
            camera.clearFlags = CameraClearFlags.SolidColor;
            camera.backgroundColor = new Color(0f, 0f, 0f, 0f);
            camera.orthographic = true;
            camera.orthographicSize = ReferenceHeight * 0.5f;
            camera.transform.position = new Vector3(0f, 0f, -1000f);
            canvas.worldCamera = camera;
            canvas.planeDistance = 100f;
            canvas.sortingOrder = 0;

            Canvas.ForceUpdateCanvases();
            var texture = new Texture2D((int)ReferenceWidth, (int)ReferenceHeight, TextureFormat.RGBA32, false);
            var rt = new RenderTexture((int)ReferenceWidth, (int)ReferenceHeight, 24, RenderTextureFormat.ARGB32);
            camera.targetTexture = rt;
            RenderTexture.active = rt;
            GL.Clear(true, true, camera.backgroundColor);
            camera.Render();
            texture.ReadPixels(new Rect(0, 0, ReferenceWidth, ReferenceHeight), 0, 0);
            texture.Apply();
            File.WriteAllBytes(capturePath, texture.EncodeToPNG());

            RenderTexture.active = null;
            camera.targetTexture = null;
            UnityEngine.Object.DestroyImmediate(rt);
            UnityEngine.Object.DestroyImmediate(texture);
            UnityEngine.Object.DestroyImmediate(cameraGo);
            return AnalyzeCapture(capturePath);
        }

        private static CaptureMetrics AnalyzeCapture(string path)
        {
            var bytes = File.ReadAllBytes(path);
            var texture = new Texture2D(2, 2, TextureFormat.RGBA32, false);
            texture.LoadImage(bytes);
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
            var bounds = visible > 0 ? minX + "," + minY + " - " + maxX + "," + maxY : "none";
            UnityEngine.Object.DestroyImmediate(texture);
            return new CaptureMetrics
            {
                exists = File.Exists(path),
                path = Path.GetFullPath(path),
                width = (int)ReferenceWidth,
                height = (int)ReferenceHeight,
                visiblePixelCount = visible,
                uniqueColorCount = unique.Count,
                bounds = bounds
            };
        }

        private static ClickSummary ValidateClicks(Canvas canvas, string clickCsv, string clickJson)
        {
            Canvas.ForceUpdateCanvases();
            var graphics = UnityEngine.Object.FindObjectsByType<Graphic>(FindObjectsInactive.Include, FindObjectsSortMode.None)
                .Where(g => g != null && g.rectTransform != null && g.gameObject.activeInHierarchy && g.enabled && g.raycastTarget && g.transform.IsChildOf(canvas.transform))
                .ToList();
            var rows = new List<ClickRow>();
            foreach (var button in UnityEngine.Object.FindObjectsByType<Button>(FindObjectsInactive.Include, FindObjectsSortMode.None))
                rows.Add(ValidateButton(button, graphics));
            WriteClickCsv(rows, clickCsv);
            var summary = new ClickSummary
            {
                generatedAt = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture),
                csv = Path.GetFullPath(clickCsv),
                json = Path.GetFullPath(clickJson),
                totalButtons = rows.Count,
                activeButtons = rows.Count(r => r.activeInHierarchy),
                activeInteractableButtons = rows.Count(r => r.activeInHierarchy && r.interactable),
                raycastClickableButtons = rows.Count(r => r.raycastClickable),
                raycastBlockedButtons = rows.Count(r => r.activeInHierarchy && r.interactable && !r.raycastClickable)
            };
            File.WriteAllText(clickJson, JsonUtility.ToJson(summary, true), Encoding.UTF8);
            return summary;
        }

        private static ClickRow ValidateButton(Button button, List<Graphic> raycastGraphics)
        {
            var rt = button.GetComponent<RectTransform>();
            var centerWorld = Vector3.zero;
            if (rt != null)
            {
                var corners = new Vector3[4];
                rt.GetWorldCorners(corners);
                centerWorld = (corners[0] + corners[2]) * 0.5f;
            }
            var hits = new List<GraphicHit>();
            foreach (var candidate in raycastGraphics)
            {
                if (candidate == null || candidate.rectTransform == null)
                    continue;
                if (!ContainsWorldPoint(candidate.rectTransform, centerWorld))
                    continue;
                hits.Add(new GraphicHit { graphic = candidate, depth = candidate.depth });
            }
            hits.Sort((a, b) =>
            {
                var depth = b.depth.CompareTo(a.depth);
                return depth != 0 ? depth : string.CompareOrdinal(GetHierarchyPath(a.graphic.transform), GetHierarchyPath(b.graphic.transform));
            });
            var top = hits.Count > 0 ? hits[0].graphic.gameObject : null;
            var topWithinButton = top != null && top.transform.IsChildOf(button.transform);
            var targetGraphicReady = button.targetGraphic != null && button.targetGraphic.enabled && button.targetGraphic.raycastTarget;
            return new ClickRow
            {
                buttonName = button.gameObject.name,
                hierarchyPath = GetHierarchyPath(button.transform),
                activeInHierarchy = button.gameObject.activeInHierarchy,
                interactable = button.interactable && button.enabled,
                targetGraphicReady = targetGraphicReady,
                raycastHitCount = hits.Count,
                raycastTopDepth = hits.Count > 0 ? hits[0].depth : 0,
                raycastTopWithinButton = topWithinButton,
                raycastClickable = button.gameObject.activeInHierarchy && button.interactable && button.enabled && targetGraphicReady && topWithinButton,
                raycastTopObject = top != null ? GetHierarchyPath(top.transform) : ""
            };
        }

        private static bool ContainsWorldPoint(RectTransform rectTransform, Vector3 worldPoint)
        {
            var local = rectTransform.InverseTransformPoint(worldPoint);
            return rectTransform.rect.Contains(local);
        }

        private static void ForceSpineUpdate()
        {
            Canvas.ForceUpdateCanvases();
            foreach (var skeleton in UnityEngine.Object.FindObjectsByType<SkeletonGraphic>(FindObjectsInactive.Include, FindObjectsSortMode.None))
            {
                skeleton.Initialize(false);
                skeleton.Update(0f);
                skeleton.LateUpdate();
                skeleton.UpdateMesh(true);
            }
            Canvas.ForceUpdateCanvases();
        }

        private static Transform FindTransformByPrefix(string prefix)
        {
            foreach (var transform in UnityEngine.Object.FindObjectsByType<Transform>(FindObjectsInactive.Include, FindObjectsSortMode.None))
                if (transform.name.StartsWith(prefix, StringComparison.Ordinal))
                    return transform;
            return null;
        }

        private static Transform FindTransformByName(string name)
        {
            foreach (var transform in UnityEngine.Object.FindObjectsByType<Transform>(FindObjectsInactive.Include, FindObjectsSortMode.None))
                if (transform.name == name)
                    return transform;
            return null;
        }

        private static void EnsureActiveInHierarchy(Transform transform)
        {
            var stack = new Stack<Transform>();
            for (var current = transform; current != null; current = current.parent)
                stack.Push(current);
            while (stack.Count > 0)
                stack.Pop().gameObject.SetActive(true);
        }

        private static TransformRow BuildTransformRow(string phase, Transform transform, string decision)
        {
            var rect = transform as RectTransform;
            var sg = transform.GetComponent<SkeletonGraphic>();
            return new TransformRow
            {
                phase = phase,
                name = transform.name,
                path = GetHierarchyPath(transform),
                activeInHierarchy = transform.gameObject.activeInHierarchy,
                siblingIndex = transform.GetSiblingIndex(),
                componentTypes = string.Join("|", transform.GetComponents<Component>().Where(c => c != null).Select(c => c.GetType().Name).Distinct().OrderBy(s => s, StringComparer.Ordinal)),
                anchoredPosition = rect != null ? Vec2(rect.anchoredPosition) : "",
                sizeDelta = rect != null ? Vec2(rect.sizeDelta) : "",
                localPosition = Vec3(transform.localPosition),
                localScale = Vec3(transform.localScale),
                raycastTarget = sg != null && sg.raycastTarget,
                startingAnimation = sg != null ? sg.startingAnimation : "",
                startingLoop = sg != null && sg.startingLoop,
                decision = decision
            };
        }

        private static void WriteOutputs(CandidateResult result)
        {
            WriteTransformCsv(result.transformRows);
            WriteLayerCsv(result.layerRows);
            File.WriteAllText(CandidateJson, JsonUtility.ToJson(result, true), Encoding.UTF8);
        }

        private static void WriteTransformCsv(List<TransformRow> rows)
        {
            var sb = new StringBuilder();
            sb.AppendLine("phase,name,path,activeInHierarchy,siblingIndex,componentTypes,anchoredPosition,sizeDelta,localPosition,localScale,raycastTarget,startingAnimation,startingLoop,decision");
            foreach (var r in rows)
            {
                sb.AppendLine(string.Join(",", new[]
                {
                    Csv(r.phase), Csv(r.name), Csv(r.path), r.activeInHierarchy.ToString(), r.siblingIndex.ToString(CultureInfo.InvariantCulture),
                    Csv(r.componentTypes), Csv(r.anchoredPosition), Csv(r.sizeDelta), Csv(r.localPosition), Csv(r.localScale),
                    r.raycastTarget.ToString(), Csv(r.startingAnimation), r.startingLoop.ToString(), Csv(r.decision)
                }));
            }
            File.WriteAllText(TransformCsv, sb.ToString(), new UTF8Encoding(false));
        }

        private static void WriteLayerCsv(List<LayerRow> rows)
        {
            var sb = new StringBuilder();
            sb.AppendLine("layer,baseName,sourceExists,mounted,hasAnimationA,bones,slots,animations,atlasPath,skeletonPath,texturePath,skeletonDataAssetPath,scenePath,rectSize,localPosition,localScale,decision,detail");
            foreach (var r in rows)
            {
                sb.AppendLine(string.Join(",", new[]
                {
                    Csv(r.layer), Csv(r.baseName), r.sourceExists.ToString(), r.mounted.ToString(), r.hasAnimationA.ToString(),
                    r.bones.ToString(CultureInfo.InvariantCulture), r.slots.ToString(CultureInfo.InvariantCulture), r.animations.ToString(CultureInfo.InvariantCulture),
                    Csv(r.atlasPath), Csv(r.skeletonPath), Csv(r.texturePath), Csv(r.skeletonDataAssetPath), Csv(r.scenePath),
                    Csv(r.rectSize), Csv(r.localPosition), Csv(r.localScale), Csv(r.decision), Csv(r.detail)
                }));
            }
            File.WriteAllText(LayerCsv, sb.ToString(), new UTF8Encoding(false));
        }

        private static void WriteClickCsv(List<ClickRow> rows, string clickCsv)
        {
            var sb = new StringBuilder();
            sb.AppendLine("buttonName,hierarchyPath,activeInHierarchy,interactable,targetGraphicReady,raycastHitCount,raycastTopDepth,raycastTopWithinButton,raycastClickable,raycastTopObject");
            foreach (var r in rows)
            {
                sb.AppendLine(string.Join(",", new[]
                {
                    Csv(r.buttonName), Csv(r.hierarchyPath), r.activeInHierarchy.ToString(), r.interactable.ToString(),
                    r.targetGraphicReady.ToString(), r.raycastHitCount.ToString(CultureInfo.InvariantCulture),
                    r.raycastTopDepth.ToString(CultureInfo.InvariantCulture), r.raycastTopWithinButton.ToString(),
                    r.raycastClickable.ToString(), Csv(r.raycastTopObject)
                }));
            }
            File.WriteAllText(clickCsv, sb.ToString(), new UTF8Encoding(false));
        }

        private static string GetHierarchyPath(Transform transform)
        {
            var names = new Stack<string>();
            for (var current = transform; current != null; current = current.parent)
                names.Push(current.name);
            return string.Join("/", names);
        }

        private static string Vec2(Vector2 value)
        {
            return value.x.ToString("0.###", CultureInfo.InvariantCulture) + "," + value.y.ToString("0.###", CultureInfo.InvariantCulture);
        }

        private static string Vec3(Vector3 value)
        {
            return value.x.ToString("0.###", CultureInfo.InvariantCulture) + "," + value.y.ToString("0.###", CultureInfo.InvariantCulture) + "," + value.z.ToString("0.###", CultureInfo.InvariantCulture);
        }

        private static string Csv(string value)
        {
            if (string.IsNullOrEmpty(value))
                return "";
            return "\"" + value.Replace("\"", "\"\"") + "\"";
        }

        private sealed class LayerSource
        {
            public readonly string BaseName;
            public readonly string AtlasText;
            public readonly string SkeletonBytes;
            public readonly string TexturePng;
            public readonly string SkeletonDataAsset;
            public readonly string AtlasAsset;
            public readonly string Material;
            public readonly string AdditiveMaterial;
            public readonly string ScreenMaterial;

            public LayerSource(string baseName)
            {
                BaseName = baseName;
                AtlasText = HeroRoot + "/" + baseName + ".atlas.txt";
                SkeletonBytes = HeroRoot + "/" + baseName + ".skel.bytes";
                TexturePng = HeroRoot + "/" + baseName + ".png";
                SkeletonDataAsset = HeroRoot + "/" + baseName + "_SkeletonData.asset";
                AtlasAsset = HeroRoot + "/" + baseName + "_Atlas.asset";
                Material = HeroRoot + "/" + baseName + "_Material.mat";
                AdditiveMaterial = HeroRoot + "/" + baseName + "_Material-Additive.mat";
                ScreenMaterial = HeroRoot + "/" + baseName + "_Material-Screen.mat";
            }
        }

        [Serializable]
        private sealed class CandidateResult
        {
            public string generatedAt;
            public string status;
            public bool restoredClaim;
            public bool sceneSaved;
            public string scenePath;
            public string capturePath;
            public string backgroundPath;
            public string heroParentPath;
            public string heroRootPath;
            public string patchDecision;
            public string error;
            public List<string> decisions;
            public List<TransformRow> transformRows;
            public List<LayerRow> layerRows;
            public CaptureMetrics capture;
            public ClickSummary clickSummary;
        }

        [Serializable]
        private sealed class TransformRow
        {
            public string phase;
            public string name;
            public string path;
            public bool activeInHierarchy;
            public int siblingIndex;
            public string componentTypes;
            public string anchoredPosition;
            public string sizeDelta;
            public string localPosition;
            public string localScale;
            public bool raycastTarget;
            public string startingAnimation;
            public bool startingLoop;
            public string decision;
        }

        [Serializable]
        private sealed class LayerRow
        {
            public string layer;
            public string baseName;
            public bool sourceExists;
            public bool mounted;
            public bool hasAnimationA;
            public int bones;
            public int slots;
            public int animations;
            public string atlasPath;
            public string skeletonPath;
            public string texturePath;
            public string skeletonDataAssetPath;
            public string scenePath;
            public string rectSize;
            public string localPosition;
            public string localScale;
            public string decision;
            public string detail;
        }

        [Serializable]
        private sealed class CaptureMetrics
        {
            public bool exists;
            public string path;
            public int width;
            public int height;
            public int visiblePixelCount;
            public int uniqueColorCount;
            public string bounds;
        }

        [Serializable]
        private sealed class ClickSummary
        {
            public string generatedAt;
            public string csv;
            public string json;
            public int totalButtons;
            public int activeButtons;
            public int activeInteractableButtons;
            public int raycastClickableButtons;
            public int raycastBlockedButtons;
        }

        private sealed class ClickRow
        {
            public string buttonName;
            public string hierarchyPath;
            public bool activeInHierarchy;
            public bool interactable;
            public bool targetGraphicReady;
            public int raycastHitCount;
            public int raycastTopDepth;
            public bool raycastTopWithinButton;
            public bool raycastClickable;
            public string raycastTopObject;
        }

        private sealed class GraphicHit
        {
            public Graphic graphic;
            public int depth;
        }
    }
}
