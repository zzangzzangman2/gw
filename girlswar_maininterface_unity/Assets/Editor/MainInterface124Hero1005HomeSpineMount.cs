using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using Spine.Unity;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

namespace GirlsWarRestore
{
    public static class MainInterface124Hero1005HomeSpineMount
    {
        private const string SourceScenePath = "Assets/Scenes/MainInterface_Wireframe.unity";
        private const string MountedScenePath = "Assets/Scenes/MainInterface_UI124_Hero1005HomeSpine.unity";
        private const string HeroRoot = "Assets/RestoreData/hero1005_spine_source_raw/paintingprefabandres_1005";
        private const string SkeletonDataPath = HeroRoot + "/Painting_1005_SkeletonData.asset";
        private const string AtlasAssetPath = HeroRoot + "/Painting_1005_Atlas.asset";
        private const string MaterialPath = HeroRoot + "/Painting_1005_Material.mat";
        private const string AdditiveMaterialPath = HeroRoot + "/Painting_1005_Material-Additive.mat";
        private const string ScreenMaterialPath = HeroRoot + "/Painting_1005_Material-Screen.mat";
        private const string DefaultGraphicMaterialPath = "Assets/Spine/Runtime/spine-unity/Materials/SkeletonGraphicDefault.mat";
        private const string AdditiveGraphicMaterialPath = "Assets/Spine/Runtime/spine-unity/Materials/SkeletonGraphicAdditive.mat";
        private const string ScreenGraphicMaterialPath = "Assets/Spine/Runtime/spine-unity/Materials/SkeletonGraphicScreen.mat";
        private const string ReportJson = "Assets/RestoreData/maininterface_124_hero1005_home_spine_mount.json";
        private const string ReportCsv = "Assets/RestoreData/reports/maininterface_124_hero1005_home_spine_mount.csv";
        private const string ClickCsv = "Assets/RestoreData/reports/maininterface_124_click_validation.csv";
        private const string ClickJson = "Assets/RestoreData/reports/maininterface_124_click_validation_summary.json";
        private const string CapturePath = "Assets/RestoreCaptures/maininterface_ui124_hero1005_spine_1680x720.png";
        private const string HeroOnlyCapturePath = "Assets/RestoreCaptures/maininterface_ui124_hero1005_spine_hero_only_1680x720.png";
        private const string ReportMd = "C:/Users/godho/Downloads/girlswar/reports/maininterface/MAININTERFACE_124_MOUNT_HERO1005_HOME_SPINE_SKELETON_GRAPHIC_RESULT.md";
        private const float ReferenceWidth = 1680f;
        private const float ReferenceHeight = 720f;

        [MenuItem("GirlsWar/UI124 Mount Hero1005 Home Spine SkeletonGraphic")]
        public static void MountCaptureAndValidate()
        {
            Directory.CreateDirectory("Assets/RestoreData/reports");
            Directory.CreateDirectory("Assets/RestoreCaptures");
            Directory.CreateDirectory("C:/Users/godho/Downloads/girlswar/reports/maininterface");

            var result = new MountResult
            {
                generatedAt = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
                status = "started",
                restoredClaim = false,
                rows = new List<MountRow>()
            };

            try
            {
                MainInterfaceSceneBuilder.BuildMainInterfaceScene();
                var scene = EditorSceneManager.OpenScene(SourceScenePath, OpenSceneMode.Single);

                AssetDatabase.Refresh(ImportAssetOptions.ForceSynchronousImport);
                PrepareTextureImports(result);
                var skeletonDataAsset = EnsureSkeletonAssets(result);
                var layer = AttachHeroSkeleton(skeletonDataAsset, result);
                result.rows.Add(layer);

                ForceSpineUpdate();
                EditorSceneManager.SaveScene(scene, MountedScenePath);

                var canvas = UnityEngine.Object.FindFirstObjectByType<Canvas>();
                if (canvas == null)
                    throw new Exception("Canvas not found after UI124 mount.");

                result.capture = Capture(canvas, CapturePath, false);
                result.heroOnlyCapture = Capture(canvas, HeroOnlyCapturePath, true);
                result.clickSummary = ValidateClicks(canvas);
                result.status = result.heroOnlyCapture.visiblePixelCount > 0
                    ? "ui124_hero1005_spine_mounted_capture_generated"
                    : "ui124_hero1005_spine_mounted_but_blank";
                result.visualVerdict = "not_restored_claim_false_manual_reference_review_required";
                result.nextBlocker = "Compare UI124 capture against the 1005 reference. Route/world cluster remains active by evidence and may still overlap the hero because right sibling index is above UI_heroSpine.";
            }
            catch (Exception ex)
            {
                result.status = "ui124_failed";
                result.visualVerdict = "not_restored_claim_false_exception";
                result.nextBlocker = ex.GetType().Name + ": " + ex.Message;
                WriteOutputs(result);
                Debug.LogException(ex);
                throw;
            }

            WriteOutputs(result);
            AssetDatabase.Refresh(ImportAssetOptions.ForceSynchronousImport);
            Debug.Log("[GirlsWarRestore] UI124 Hero1005 Spine mount complete: " + result.status + " -> " + CapturePath);
        }

        private static void PrepareTextureImports(MountResult result)
        {
            foreach (var path in new[] { HeroRoot + "/Painting_1005.png", HeroRoot + "/Painting_1005.atlas.txt", HeroRoot + "/Painting_1005.skel.bytes" })
            {
                if (!File.Exists(path))
                    throw new Exception("Missing Hero1005 Spine source file: " + path);
            }

            var importer = AssetImporter.GetAtPath(HeroRoot + "/Painting_1005.png") as TextureImporter;
            if (importer != null)
            {
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

            AssetDatabase.ImportAsset(HeroRoot + "/Painting_1005.png", ImportAssetOptions.ForceUpdate);
            AssetDatabase.ImportAsset(HeroRoot + "/Painting_1005.atlas.txt", ImportAssetOptions.ForceUpdate);
            AssetDatabase.ImportAsset(HeroRoot + "/Painting_1005.skel.bytes", ImportAssetOptions.ForceUpdate);
            result.rows.Add(new MountRow
            {
                key = "source_import",
                decision = "prepared",
                detail = "Imported Painting_1005.png, Painting_1005.atlas.txt, and Painting_1005.skel.bytes as source assets."
            });
            result.rows.Add(new MountRow
            {
                key = "raw_source_evidence",
                assetPath = HeroRoot,
                decision = "use_raw_textasset_export",
                detail = "UI124 uses the raw TextAsset export folder so Spine reads original .skel bytes; UI123 source files remain untouched as evidence."
            });
        }

        private static SkeletonDataAsset EnsureSkeletonAssets(MountResult result)
        {
            var skeletonDataAsset = AssetDatabase.LoadAssetAtPath<SkeletonDataAsset>(SkeletonDataPath);
            if (skeletonDataAsset != null && skeletonDataAsset.GetSkeletonData(true) != null)
            {
                result.rows.Add(new MountRow
                {
                    key = "skeletondata_asset",
                    assetPath = SkeletonDataPath,
                    decision = "reuse_existing",
                    detail = DescribeSkeleton(skeletonDataAsset)
                });
                return skeletonDataAsset;
            }

            DeleteAssetIfExists(SkeletonDataPath);
            DeleteAssetIfExists(AtlasAssetPath);
            DeleteAssetIfExists(MaterialPath);
            DeleteAssetIfExists(AdditiveMaterialPath);
            DeleteAssetIfExists(ScreenMaterialPath);

            var atlasText = AssetDatabase.LoadAssetAtPath<TextAsset>(HeroRoot + "/Painting_1005.atlas.txt");
            var skeletonText = AssetDatabase.LoadAssetAtPath<TextAsset>(HeroRoot + "/Painting_1005.skel.bytes");
            var texture = AssetDatabase.LoadAssetAtPath<Texture2D>(HeroRoot + "/Painting_1005.png");
            if (atlasText == null || skeletonText == null || texture == null)
                throw new Exception("Hero1005 atlas/skeleton/texture import failed before asset creation.");

            var material = CreateMaterial(MaterialPath, DefaultGraphicMaterialPath, texture, "Painting_1005_Material");
            CreateMaterial(AdditiveMaterialPath, AdditiveGraphicMaterialPath, texture, "Painting_1005_Material-Additive");
            CreateMaterial(ScreenMaterialPath, ScreenGraphicMaterialPath, texture, "Painting_1005_Material-Screen");

            var atlasAsset = SpineAtlasAsset.CreateRuntimeInstance(atlasText, new[] { material }, true);
            atlasAsset.name = "Painting_1005_Atlas";
            AssetDatabase.CreateAsset(atlasAsset, AtlasAssetPath);

            skeletonDataAsset = SkeletonDataAsset.CreateRuntimeInstance(skeletonText, atlasAsset, true, 0.01f);
            skeletonDataAsset.name = "Painting_1005_SkeletonData";
            AssetDatabase.CreateAsset(skeletonDataAsset, SkeletonDataPath);
            AssetDatabase.SaveAssets();
            AssetDatabase.Refresh(ImportAssetOptions.ForceSynchronousImport);

            skeletonDataAsset = AssetDatabase.LoadAssetAtPath<SkeletonDataAsset>(SkeletonDataPath);
            if (skeletonDataAsset == null || skeletonDataAsset.GetSkeletonData(true) == null)
                throw new Exception("Created Painting_1005_SkeletonData.asset, but SkeletonData did not load.");

            result.rows.Add(new MountRow
            {
                key = "skeletondata_asset",
                assetPath = SkeletonDataPath,
                decision = "created_spine_runtime_assets",
                detail = DescribeSkeleton(skeletonDataAsset)
            });
            return skeletonDataAsset;
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

        private static void DeleteAssetIfExists(string path)
        {
            if (AssetDatabase.LoadAssetAtPath<UnityEngine.Object>(path) != null)
                AssetDatabase.DeleteAsset(path);
        }

        private static MountRow AttachHeroSkeleton(SkeletonDataAsset skeletonDataAsset, MountResult result)
        {
            var heroParent = FindTransformByPrefix("UI_heroSpine__") ?? FindTransformByName("UI_heroSpine");
            if (heroParent == null)
                throw new Exception("UI_heroSpine not found in MainInterface scene.");
            EnsureActiveInHierarchy(heroParent);

            var previous = heroParent.Find("Restore_Hero1005_SpineRoot");
            if (previous != null)
                UnityEngine.Object.DestroyImmediate(previous.gameObject);

            var root = new GameObject("Restore_Hero1005_SpineRoot", typeof(RectTransform));
            var rootRect = root.GetComponent<RectTransform>();
            rootRect.SetParent(heroParent, false);
            rootRect.anchorMin = Vector2.zero;
            rootRect.anchorMax = Vector2.one;
            rootRect.offsetMin = Vector2.zero;
            rootRect.offsetMax = Vector2.zero;
            rootRect.pivot = new Vector2(0.5f, 0.5f);
            rootRect.anchoredPosition = Vector2.zero;
            rootRect.localRotation = Quaternion.identity;
            rootRect.localScale = Vector3.one;

            var material = AssetDatabase.LoadAssetAtPath<Material>(MaterialPath);
            var graphic = SkeletonGraphic.NewSkeletonGraphicGameObject(skeletonDataAsset, rootRect, material);
            graphic.gameObject.name = "Restore_Hero1005_Painting_1005";
            graphic.raycastTarget = false;
            graphic.maskable = true;
            graphic.allowMultipleCanvasRenderers = true;
            graphic.startingAnimation = "A";
            graphic.startingLoop = true;
            graphic.additiveMaterial = AssetDatabase.LoadAssetAtPath<Material>(AdditiveMaterialPath);
            graphic.screenMaterial = AssetDatabase.LoadAssetAtPath<Material>(ScreenMaterialPath);

            var rect = graphic.GetComponent<RectTransform>();
            rect.anchorMin = new Vector2(0.5f, 0.5f);
            rect.anchorMax = new Vector2(0.5f, 0.5f);
            rect.pivot = new Vector2(0.5f, 0.5f);
            rect.anchoredPosition = Vector2.zero;
            rect.sizeDelta = new Vector2(100f, 100f);
            rect.localRotation = Quaternion.identity;
            rect.localScale = Vector3.one;

            var skeletonData = skeletonDataAsset.GetSkeletonData(true);
            graphic.Initialize(true);
            if (skeletonData.FindAnimation("A") != null)
                graphic.AnimationState.SetAnimation(0, "A", true);
            graphic.Update(0f);
            graphic.UpdateMesh(true);
            var matchedBounds = graphic.MatchRectTransformWithBounds();
            graphic.UpdateMesh(true);

            var right = FindTransformByPrefix("right__");
            var row = new MountRow
            {
                key = "hero_mount",
                assetPath = SkeletonDataPath,
                sceneObjectPath = TransformPath(graphic.transform),
                decision = "attached_skeletongraphic_main_only",
                detail = "Mounted Painting_1005 as SkeletonGraphic under UI_heroSpine using animation A loop=true; whole atlas UI Image was not used.",
                animation = "A",
                loop = true,
                matchedBounds = matchedBounds,
                bones = skeletonData.Bones.Count,
                slots = skeletonData.Slots.Count,
                skins = skeletonData.Skins.Count,
                animations = skeletonData.Animations.Count,
                rectWidth = rect.sizeDelta.x,
                rectHeight = rect.sizeDelta.y,
                heroParentSiblingIndex = heroParent.GetSiblingIndex(),
                rightSiblingIndex = right != null ? right.GetSiblingIndex() : -1,
                routeDrawsAboveHeroBySibling = right != null && right.GetSiblingIndex() > heroParent.GetSiblingIndex(),
                homePara = "[1,0,0]"
            };
            result.heroParentPath = TransformPath(heroParent);
            result.heroParentSiblingIndex = row.heroParentSiblingIndex;
            result.rightSiblingIndex = row.rightSiblingIndex;
            result.routeDrawsAboveHeroBySibling = row.routeDrawsAboveHeroBySibling;
            return row;
        }

        private static CaptureMetrics Capture(Canvas canvas, string capturePath, bool heroOnly)
        {
            var disabled = heroOnly ? DisableNonHeroGraphics() : new List<Graphic>();
            PrepareCanvasForCapture(canvas);
            ForceSpineUpdate();

            var cameraGo = new GameObject("UI124_Hero1005_CaptureCamera_" + (heroOnly ? "hero_only" : "full"), typeof(Camera));
            var camera = cameraGo.GetComponent<Camera>();
            camera.clearFlags = CameraClearFlags.SolidColor;
            camera.backgroundColor = new Color(0f, 0f, 0f, 0f);
            camera.orthographic = true;
            camera.orthographicSize = ReferenceHeight * 0.5f;
            camera.nearClipPlane = 0.01f;
            camera.farClipPlane = 1000f;
            camera.transform.position = new Vector3(0f, 0f, -100f);
            camera.transform.rotation = Quaternion.identity;
            canvas.worldCamera = camera;

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
            var metrics = Measure(texture, capturePath, heroOnly ? "hero_only" : "full");

            RenderTexture.active = previous;
            camera.targetTexture = null;
            UnityEngine.Object.DestroyImmediate(renderTexture);
            UnityEngine.Object.DestroyImmediate(texture);
            UnityEngine.Object.DestroyImmediate(cameraGo);
            foreach (var graphic in disabled)
                if (graphic != null)
                    graphic.enabled = true;
            return metrics;
        }

        private static void PrepareCanvasForCapture(Canvas canvas)
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
            canvas.planeDistance = 0f;
        }

        private static List<Graphic> DisableNonHeroGraphics()
        {
            var root = GameObject.Find("Restore_Hero1005_SpineRoot");
            var disabled = new List<Graphic>();
            foreach (var graphic in UnityEngine.Object.FindObjectsByType<Graphic>(FindObjectsInactive.Include, FindObjectsSortMode.None))
            {
                if (graphic == null || !graphic.enabled)
                    continue;
                if (root != null && graphic.transform.IsChildOf(root.transform))
                    continue;
                graphic.enabled = false;
                disabled.Add(graphic);
            }
            return disabled;
        }

        private static CaptureMetrics Measure(Texture2D texture, string path, string label)
        {
            var pixels = texture.GetPixels32();
            var visible = 0;
            var minX = texture.width;
            var minY = texture.height;
            var maxX = -1;
            var maxY = -1;
            var colors = new HashSet<int>();
            for (var y = 0; y < texture.height; y++)
            {
                for (var x = 0; x < texture.width; x++)
                {
                    var p = pixels[y * texture.width + x];
                    if (p.a == 0 || (p.r == 0 && p.g == 0 && p.b == 0))
                        continue;
                    visible++;
                    colors.Add((p.r << 24) | (p.g << 16) | (p.b << 8) | p.a);
                    minX = Math.Min(minX, x);
                    minY = Math.Min(minY, y);
                    maxX = Math.Max(maxX, x);
                    maxY = Math.Max(maxY, y);
                }
            }
            return new CaptureMetrics
            {
                label = label,
                path = captureFullPath(path),
                width = texture.width,
                height = texture.height,
                visiblePixelCount = visible,
                uniqueColorCount = colors.Count,
                bounds = visible > 0 ? $"{minX},{minY} - {maxX},{maxY}" : "",
                exists = File.Exists(path)
            };
        }

        private static ClickSummary ValidateClicks(Canvas canvas)
        {
            var rows = new List<ClickRow>();
            var graphics = UnityEngine.Object.FindObjectsByType<Graphic>(FindObjectsInactive.Include, FindObjectsSortMode.None)
                .Where(g => g != null && g.canvas != null && g.canvas.rootCanvas == canvas.rootCanvas && g.gameObject.activeInHierarchy && g.enabled && g.raycastTarget)
                .ToList();
            foreach (var button in UnityEngine.Object.FindObjectsByType<Button>(FindObjectsInactive.Include, FindObjectsSortMode.None))
            {
                var logger = button.GetComponent<RestoreClickLogger>();
                if (logger == null || logger.loggerKind != "Button")
                    continue;
                rows.Add(ValidateButton(button, logger, graphics));
            }
            rows.Sort((a, b) => string.Compare(a.componentPathId, b.componentPathId, StringComparison.Ordinal));
            WriteClickCsv(rows);

            var summary = new ClickSummary
            {
                generatedAt = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
                scenePath = MountedScenePath,
                csv = captureFullPath(ClickCsv),
                json = captureFullPath(ClickJson),
                totalButtons = rows.Count,
                activeButtons = rows.Count(r => r.activeInHierarchy),
                raycastClickableButtons = rows.Count(r => r.raycastClickable),
                raycastBlockedButtons = rows.Count(r => r.activeInHierarchy && r.interactable && !r.raycastClickable),
                heroSkeletonRaycastTarget = false
            };
            File.WriteAllText(ClickJson, JsonUtility.ToJson(summary, true), Encoding.UTF8);
            return summary;
        }

        private static ClickRow ValidateButton(Button button, RestoreClickLogger logger, List<Graphic> graphics)
        {
            var rt = button.GetComponent<RectTransform>();
            var center = Vector3.zero;
            if (rt != null)
            {
                var corners = new Vector3[4];
                rt.GetWorldCorners(corners);
                center = (corners[0] + corners[2]) * 0.5f;
            }
            var hits = graphics
                .Where(g => g != null && g.rectTransform != null && ContainsWorldPoint(g.rectTransform, center))
                .OrderByDescending(g => g.depth)
                .ToList();
            var top = hits.Count > 0 ? hits[0] : null;
            var topWithinButton = top != null && top.transform.IsChildOf(button.transform);
            var active = button.gameObject.activeInHierarchy;
            var interactable = button.interactable && button.enabled;
            var targetReady = button.targetGraphic != null && button.targetGraphic.enabled && button.targetGraphic.raycastTarget;
            return new ClickRow
            {
                buttonName = logger.buttonName,
                componentPathId = logger.buttonComponentPathId,
                activeInHierarchy = active,
                interactable = interactable,
                targetGraphicReady = targetReady,
                raycastHitCount = hits.Count,
                raycastTopObject = top != null ? CleanName(top.gameObject.name) : "",
                raycastTopWithinButton = topWithinButton,
                raycastClickable = active && interactable && targetReady && topWithinButton,
                luaModule = logger.luaModule,
                luaHandler = logger.luaHandler
            };
        }

        private static bool ContainsWorldPoint(RectTransform rt, Vector3 world)
        {
            var corners = new Vector3[4];
            rt.GetWorldCorners(corners);
            var minX = Math.Min(corners[0].x, corners[2].x);
            var maxX = Math.Max(corners[0].x, corners[2].x);
            var minY = Math.Min(corners[0].y, corners[2].y);
            var maxY = Math.Max(corners[0].y, corners[2].y);
            return world.x >= minX && world.x <= maxX && world.y >= minY && world.y <= maxY;
        }

        private static void WriteOutputs(MountResult result)
        {
            File.WriteAllText(ReportJson, JsonUtility.ToJson(result, true), Encoding.UTF8);
            WriteRowsCsv(result.rows);
            WriteMarkdown(result);
        }

        private static void WriteRowsCsv(List<MountRow> rows)
        {
            var sb = new StringBuilder();
            sb.AppendLine("key,decision,assetPath,sceneObjectPath,animation,loop,bones,slots,skins,animations,rectWidth,rectHeight,matchedBounds,heroParentSiblingIndex,rightSiblingIndex,routeDrawsAboveHeroBySibling,homePara,detail");
            foreach (var row in rows)
            {
                sb.AppendLine(string.Join(",", new[]
                {
                    Csv(row.key),
                    Csv(row.decision),
                    Csv(row.assetPath),
                    Csv(row.sceneObjectPath),
                    Csv(row.animation),
                    Csv(row.loop ? "true" : "false"),
                    row.bones.ToString(),
                    row.slots.ToString(),
                    row.skins.ToString(),
                    row.animations.ToString(),
                    row.rectWidth.ToString("0.###"),
                    row.rectHeight.ToString("0.###"),
                    Csv(row.matchedBounds ? "true" : "false"),
                    row.heroParentSiblingIndex.ToString(),
                    row.rightSiblingIndex.ToString(),
                    Csv(row.routeDrawsAboveHeroBySibling ? "true" : "false"),
                    Csv(row.homePara),
                    Csv(row.detail)
                }));
            }
            File.WriteAllText(ReportCsv, sb.ToString(), Encoding.UTF8);
        }

        private static void WriteClickCsv(List<ClickRow> rows)
        {
            var sb = new StringBuilder();
            sb.AppendLine("buttonName,componentPathId,activeInHierarchy,interactable,targetGraphicReady,raycastHitCount,raycastTopObject,raycastTopWithinButton,raycastClickable,luaModule,luaHandler");
            foreach (var row in rows)
            {
                sb.AppendLine(string.Join(",", new[]
                {
                    Csv(row.buttonName),
                    Csv(row.componentPathId),
                    Csv(row.activeInHierarchy ? "true" : "false"),
                    Csv(row.interactable ? "true" : "false"),
                    Csv(row.targetGraphicReady ? "true" : "false"),
                    row.raycastHitCount.ToString(),
                    Csv(row.raycastTopObject),
                    Csv(row.raycastTopWithinButton ? "true" : "false"),
                    Csv(row.raycastClickable ? "true" : "false"),
                    Csv(row.luaModule),
                    Csv(row.luaHandler)
                }));
            }
            File.WriteAllText(ClickCsv, sb.ToString(), Encoding.UTF8);
        }

        private static void WriteMarkdown(MountResult result)
        {
            var sb = new StringBuilder();
            sb.AppendLine("# MainInterface 124 Mount Hero1005 Home Spine SkeletonGraphic Result");
            sb.AppendLine();
            sb.AppendLine("Generated: " + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + " KST");
            sb.AppendLine();
            sb.AppendLine("## Verdict");
            sb.AppendLine();
            sb.AppendLine("Restored claim remains `false`. UI124 mounts the 1005 home character through real Spine `SkeletonGraphic` assets and writes a new capture for review; it does not hide the route/world cluster.");
            sb.AppendLine();
            sb.AppendLine("- status: `" + result.status + "`");
            sb.AppendLine("- visual verdict: `" + result.visualVerdict + "`");
            sb.AppendLine("- next blocker: `" + result.nextBlocker + "`");
            sb.AppendLine("- scene: `" + captureFullPath(MountedScenePath) + "`");
            sb.AppendLine();
            sb.AppendLine("## Spine Mount");
            sb.AppendLine();
            sb.AppendLine("| key | decision | animation | bones | slots | rect | route above hero | detail |");
            sb.AppendLine("| --- | --- | --- | ---: | ---: | --- | --- | --- |");
            foreach (var row in result.rows)
                sb.AppendLine($"| `{row.key}` | `{row.decision}` | `{row.animation}` | {row.bones} | {row.slots} | `{row.rectWidth:0.###}x{row.rectHeight:0.###}` | `{row.routeDrawsAboveHeroBySibling}` | `{row.detail}` |");
            sb.AppendLine();
            sb.AppendLine("## Capture");
            sb.AppendLine();
            sb.AppendLine("| capture | exists | visible pixels | unique colors | bounds | path |");
            sb.AppendLine("| --- | ---: | ---: | ---: | --- | --- |");
            AppendCaptureRow(sb, result.capture);
            AppendCaptureRow(sb, result.heroOnlyCapture);
            sb.AppendLine();
            sb.AppendLine("## Click Validation");
            sb.AppendLine();
            if (result.clickSummary != null)
            {
                sb.AppendLine("- total buttons: `" + result.clickSummary.totalButtons + "`");
                sb.AppendLine("- raycast clickable: `" + result.clickSummary.raycastClickableButtons + "`");
                sb.AppendLine("- raycast blocked: `" + result.clickSummary.raycastBlockedButtons + "`");
                sb.AppendLine("- hero SkeletonGraphic raycastTarget: `false`");
            }
            sb.AppendLine();
            sb.AppendLine("## Files");
            sb.AppendLine();
            sb.AppendLine("- JSON: `" + captureFullPath(ReportJson) + "`");
            sb.AppendLine("- CSV: `" + captureFullPath(ReportCsv) + "`");
            sb.AppendLine("- click CSV: `" + captureFullPath(ClickCsv) + "`");
            sb.AppendLine("- click JSON: `" + captureFullPath(ClickJson) + "`");
            sb.AppendLine("- capture: `" + captureFullPath(CapturePath) + "`");
            sb.AppendLine("- hero-only capture: `" + captureFullPath(HeroOnlyCapturePath) + "`");
            File.WriteAllText(ReportMd, sb.ToString(), Encoding.UTF8);
        }

        private static void AppendCaptureRow(StringBuilder sb, CaptureMetrics capture)
        {
            if (capture == null)
                return;
            sb.AppendLine($"| `{capture.label}` | `{capture.exists}` | {capture.visiblePixelCount} | {capture.uniqueColorCount} | `{capture.bounds}` | `{capture.path}` |");
        }

        private static string DescribeSkeleton(SkeletonDataAsset skeletonDataAsset)
        {
            var skeletonData = skeletonDataAsset.GetSkeletonData(true);
            return skeletonData == null
                ? "SkeletonData load failed"
                : $"bones={skeletonData.Bones.Count}; slots={skeletonData.Slots.Count}; skins={skeletonData.Skins.Count}; animations={skeletonData.Animations.Count}";
        }

        private static void ForceSpineUpdate()
        {
            Canvas.ForceUpdateCanvases();
            foreach (var graphic in UnityEngine.Object.FindObjectsByType<SkeletonGraphic>(FindObjectsInactive.Include, FindObjectsSortMode.None))
            {
                if (graphic == null)
                    continue;
                try
                {
                    graphic.Initialize(false);
                    graphic.Update(0f);
                    graphic.UpdateMesh(true);
                    graphic.SetVerticesDirty();
                    graphic.SetMaterialDirty();
                }
                catch { }
            }
            Canvas.ForceUpdateCanvases();
        }

        private static RectTransform FindTransformByPrefix(string prefix)
        {
            foreach (var rt in UnityEngine.Object.FindObjectsByType<RectTransform>(FindObjectsInactive.Include, FindObjectsSortMode.None))
                if (rt != null && rt.gameObject.name.StartsWith(prefix, StringComparison.Ordinal))
                    return rt;
            return null;
        }

        private static RectTransform FindTransformByName(string name)
        {
            foreach (var rt in UnityEngine.Object.FindObjectsByType<RectTransform>(FindObjectsInactive.Include, FindObjectsSortMode.None))
                if (rt != null && rt.gameObject.name == name)
                    return rt;
            return null;
        }

        private static void EnsureActiveInHierarchy(Transform transform)
        {
            var stack = new Stack<Transform>();
            var cur = transform;
            while (cur != null)
            {
                stack.Push(cur);
                cur = cur.parent;
            }
            while (stack.Count > 0)
                stack.Pop().gameObject.SetActive(true);
        }

        private static string TransformPath(Transform transform)
        {
            var parts = new List<string>();
            var cur = transform;
            while (cur != null)
            {
                parts.Add(cur.name);
                cur = cur.parent;
            }
            parts.Reverse();
            return string.Join("/", parts);
        }

        private static string CleanName(string name)
        {
            var idx = name.IndexOf("__", StringComparison.Ordinal);
            return idx >= 0 ? name.Substring(0, idx) : name;
        }

        private static string captureFullPath(string assetPath)
        {
            if (assetPath.StartsWith("C:/", StringComparison.OrdinalIgnoreCase) || assetPath.StartsWith("C:\\", StringComparison.OrdinalIgnoreCase))
                return assetPath.Replace("/", "\\");
            return Path.GetFullPath(assetPath);
        }

        private static string Csv(string value)
        {
            if (value == null)
                value = "";
            return "\"" + value.Replace("\"", "\"\"") + "\"";
        }

        [Serializable]
        public class MountResult
        {
            public string generatedAt;
            public string status;
            public bool restoredClaim;
            public string visualVerdict;
            public string nextBlocker;
            public string heroParentPath;
            public int heroParentSiblingIndex;
            public int rightSiblingIndex;
            public bool routeDrawsAboveHeroBySibling;
            public CaptureMetrics capture;
            public CaptureMetrics heroOnlyCapture;
            public ClickSummary clickSummary;
            public List<MountRow> rows;
        }

        [Serializable]
        public class MountRow
        {
            public string key;
            public string decision;
            public string assetPath;
            public string sceneObjectPath;
            public string detail;
            public string animation;
            public bool loop;
            public int bones;
            public int slots;
            public int skins;
            public int animations;
            public float rectWidth;
            public float rectHeight;
            public bool matchedBounds;
            public int heroParentSiblingIndex;
            public int rightSiblingIndex;
            public bool routeDrawsAboveHeroBySibling;
            public string homePara;
        }

        [Serializable]
        public class CaptureMetrics
        {
            public string label;
            public string path;
            public bool exists;
            public int width;
            public int height;
            public int visiblePixelCount;
            public int uniqueColorCount;
            public string bounds;
        }

        [Serializable]
        public class ClickSummary
        {
            public string generatedAt;
            public string scenePath;
            public string csv;
            public string json;
            public int totalButtons;
            public int activeButtons;
            public int raycastClickableButtons;
            public int raycastBlockedButtons;
            public bool heroSkeletonRaycastTarget;
        }

        private class ClickRow
        {
            public string buttonName;
            public string componentPathId;
            public bool activeInHierarchy;
            public bool interactable;
            public bool targetGraphicReady;
            public int raycastHitCount;
            public string raycastTopObject;
            public bool raycastTopWithinButton;
            public bool raycastClickable;
            public string luaModule;
            public string luaHandler;
        }
    }
}
