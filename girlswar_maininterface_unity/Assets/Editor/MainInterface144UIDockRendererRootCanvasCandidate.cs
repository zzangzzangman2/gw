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
using UnityEngine.SceneManagement;
using UnityEngine.UI;

namespace GirlsWarRestore
{
    public static class MainInterface144UIDockRendererRootCanvasCandidate
    {
        private const string OldRootRectId = "2475216337245998118";
        private const string UIDockRootRectId = "7409970622389811116";
        private const string CandidateScenePath = "Assets/Scenes/MainInterface_UI144_UIDockRendererRootCanvasCandidate.unity";
        private const string UIDockSourceScenePath = "Assets/Scenes/MainInterface_UI144_UIDockSourceOnly.unity";
        private const string CapturePath = "Assets/RestoreCaptures/maininterface_ui144_uidock_renderer_rootcanvas_candidate_1680x720.png";
        private const string RawDockRoot = "Assets/RestoreData/uidock_spine_source_raw";
        private const string RuntimeDockRoot = "Assets/RestoreData/uidock_spine_runtime";
        private const string HeroRoot = "Assets/RestoreData/hero1005_spine_source_raw/paintingprefabandres_1005";
        private const string HeroSkeletonDataPath = HeroRoot + "/Painting_1005_SkeletonData.asset";
        private const string HeroMaterialPath = HeroRoot + "/Painting_1005_Material.mat";
        private const string BackgroundSpritePath = "Assets/RestoredSprites/maininterface/runtime_dynamic/runtime_UI_bg_noalphabg_PaintingBG_1005.png";
        private const string DefaultGraphicMaterialPath = "Assets/Spine/Runtime/spine-unity/Materials/SkeletonGraphicDefault.mat";
        private const string AdditiveGraphicMaterialPath = "Assets/Spine/Runtime/spine-unity/Materials/SkeletonGraphicAdditive.mat";
        private const string MultiplyGraphicMaterialPath = "Assets/Spine/Runtime/spine-unity/Materials/SkeletonGraphicMultiply.mat";
        private const string ScreenGraphicMaterialPath = "Assets/Spine/Runtime/spine-unity/Materials/SkeletonGraphicScreen.mat";
        private const string ReportDir = "C:/Users/godho/Downloads/girlswar/reports/maininterface";
        private const string ResultJson = ReportDir + "/MAININTERFACE_144_SOURCE_BACKED_UIDOCK_RENDERER_AND_ROOT_CANVAS_DEPTH_CANDIDATE_VALIDATION_RESULT.json";
        private const string PatchCsv = ReportDir + "/MAININTERFACE_144_source_backed_candidate_patch_action_matrix.csv";
        private const string ValidationCsv = ReportDir + "/MAININTERFACE_144_unity_compile_import_capture_validation_matrix.csv";
        private const string VisibilityCsv = ReportDir + "/MAININTERFACE_144_uidock_sp_renderer_runtime_candidate_visibility_matrix.csv";
        private const string UnitySummaryJson = "Assets/RestoreData/reports/maininterface_144_uidock_renderer_rootcanvas_candidate_summary.json";
        private const float ReferenceWidth = 1680f;
        private const float ReferenceHeight = 720f;

        private static readonly DockSpineSpec[] DockSpines =
        {
            new DockSpineSpec("MAIN_PAGE", "sp_mainpage", "SP_Dock_1", "3835362230345717257", "A", true, "default", true, 0, 0, 1, 0, 0, 1, 0, false),
            new DockSpineSpec("CAMP", "sp_camp", "SP_Dock_2", "4593879884870609137", "A", true, "default", true, 0, 0, 1, 0, 0, 1, 0, false),
            new DockSpineSpec("BAG", "sp_bag", "SP_Dock_3", "3425111358649296926", "A", true, "default", true, 0, 0, 1, 0, 0, 1, 0, false),
            new DockSpineSpec("EXPEDITION", "sp_expedition", "SP_Dock_4", "-5242930961941176902", "A", true, "default", true, 0, 0, 1, 0, 0, 1, 0, false),
            new DockSpineSpec("ADVENTURE", "sp_adventureInterface", "SP_Dock_5", "6488046465587119062", "A", true, "default", true, 0, 0, 1, 0, 0, 1, 1, false),
            new DockSpineSpec("GUILD", "sp_guild", "SP_Dock_6", "5586381430955413960", "A", true, "default", true, 0, 0, 1, 0, 0, 1, 0, false),
            new DockSpineSpec("MAIN_CITY", "sp_maincity", "SP_Dock_7", "2275674091209698383", "animation", true, "default", true, 0, 0, 1, 0, 0, 1, 1, false),
            new DockSpineSpec("GUIDE_SALES", "spine_xiaoshou", "spine_xiaoshou", "-4598243874201664563", "B", false, "", false, 0, 0, 1, 0, 0, 1, 1, false),
        };

        private static readonly DockToggleSpec[] DockToggles =
        {
            new DockToggleSpec("MAIN_PAGE", "toggle1/im_on", "toggle1/im_off", true, "3835362230345717257"),
            new DockToggleSpec("CAMP", "toggle2/im_on", "toggle2/im_off", false, "4593879884870609137"),
            new DockToggleSpec("BAG", "toggle3/im_on", "toggle3/im_off", false, "3425111358649296926"),
            new DockToggleSpec("EXPEDITION", "toggle4/im_on", "toggle4/im_off", false, "-5242930961941176902"),
            new DockToggleSpec("ADVENTURE", "toggle5/im_on", "toggle5/im_off", false, "6488046465587119062"),
            new DockToggleSpec("GUILD", "toggle6/im_on", "toggle6/im_off", false, "5586381430955413960"),
            new DockToggleSpec("MAIN_CITY", "toggle7/im_on", "toggle7/im_off", false, "2275674091209698383"),
        };

        [MenuItem("GirlsWar/UI144 UIDock Renderer RootCanvas Candidate Validation")]
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
                scenePatchApplied = true,
                candidatePatchApplied = true,
                patchDecision = "source_backed_candidate_validation",
                scenePath = CandidateScenePath,
                capturePath = CapturePath,
                sourceRootCanvasSortingApplied = false,
                uiDockRendererDependenciesImported = false,
                guardrailsTouched = new List<string>(),
                changedFiles = new List<string> { CandidateScenePath, UIDockSourceScenePath, CapturePath, UnitySummaryJson },
                patchRows = new List<PatchRow>(),
                validationRows = new List<ValidationRow>(),
                visibilityRows = new List<VisibilityRow>()
            };

            try
            {
                MainInterfaceSceneBuilder.BuildMainInterfaceSceneForRoot(
                    OldRootRectId,
                    CandidateScenePath,
                    "MainInterface_UI144_UIDockRendererRootCanvasCandidate");
                var candidateScene = EditorSceneManager.OpenScene(CandidateScenePath, OpenSceneMode.Single);
                ApplyBg1005(result);
                AttachHero1005MainOnly(result);
                ApplyMainInterfaceRootCanvas(result);
                ForceSpineUpdate();
                EditorSceneManager.SaveScene(candidateScene, CandidateScenePath);

                MainInterfaceSceneBuilder.BuildMainInterfaceSceneForRoot(
                    UIDockRootRectId,
                    UIDockSourceScenePath,
                    "MainInterface_UI144_UIDockSourceOnly");

                candidateScene = EditorSceneManager.OpenScene(CandidateScenePath, OpenSceneMode.Single);
                var sourceScene = EditorSceneManager.OpenScene(UIDockSourceScenePath, OpenSceneMode.Additive);
                AttachUIDock(candidateScene, sourceScene, result);
                ForceSpineUpdate();
                EditorSceneManager.SaveScene(candidateScene, CandidateScenePath);
                result.sceneSaved = true;

                var canvas = UnityEngine.Object.FindFirstObjectByType<Canvas>();
                if (canvas == null)
                    throw new Exception("Canvas not found after UI144 candidate build.");
                result.capture = Capture(canvas, CapturePath);
                result.captureProduced = result.capture.exists;
                result.capturePath = result.capture.path;
                result.unityCompilePassed = true;
                result.status = "ui144_candidate_capture_generated";
            }
            catch (Exception ex)
            {
                result.status = "ui144_failed";
                result.error = ex.GetType().Name + ": " + ex.Message;
                result.unityCompilePassed = false;
                WriteOutputs(result);
                Debug.LogException(ex);
                throw;
            }

            WriteOutputs(result);
            AssetDatabase.Refresh(ImportAssetOptions.ForceSynchronousImport);
            Debug.Log("[GirlsWarRestore] UI144 candidate complete: " + CapturePath);
        }

        private static void ApplyBg1005(CandidateResult result)
        {
            var background = FindTransformByPrefix("UI_bg__-3280973633984018659") ?? FindTransformByName("UI_bg");
            if (background == null)
                throw new Exception("UI_bg target not found for UI144 old-root candidate.");
            background.gameObject.SetActive(true);
            var image = background.GetComponent<Image>();
            var hadImage = image != null;
            var baselineRaycastTarget = hadImage ? image.raycastTarget : true;
            var button = background.GetComponent<Button>();
            var hadButton = button != null;
            var baselineInteractable = hadButton && button.interactable;
            if (image == null)
                image = background.gameObject.AddComponent<Image>();
            var sprite = AssetDatabase.LoadAssetAtPath<Sprite>(BackgroundSpritePath);
            if (sprite == null)
                throw new Exception("BG1005 sprite missing: " + BackgroundSpritePath);
            image.sprite = sprite;
            image.color = Color.white;
            image.type = Image.Type.Simple;
            image.preserveAspect = false;
            image.raycastTarget = baselineRaycastTarget;

            var rect = background.GetComponent<RectTransform>();
            rect.anchorMin = new Vector2(0.5f, 0.5f);
            rect.anchorMax = new Vector2(0.5f, 0.5f);
            rect.pivot = new Vector2(0.5f, 0.5f);
            rect.anchoredPosition = Vector2.zero;
            rect.sizeDelta = new Vector2(ReferenceWidth, ReferenceHeight);
            rect.localScale = Vector3.one;
            background.SetSiblingIndex(0);
            result.uiBgBaselineRaycastTarget = baselineRaycastTarget;
            result.uiBgFinalRaycastTarget = image.raycastTarget;
            result.uiBgRaycastPreserved = baselineRaycastTarget == image.raycastTarget;
            result.uiBgBaselineInteractable = baselineInteractable;
            result.uiBgFinalInteractable = button != null && button.interactable;
            result.uiBgInteractablePreserved = !hadButton || baselineInteractable == result.uiBgFinalInteractable;
            result.patchRows.Add(new PatchRow
            {
                area = "UI_bg",
                action = "preserve_bg1005_binding_and_raycast",
                sourceEvidence = "UI127/UI128 BG1005 candidate plus UI136 guardrail correction",
                targetPath = GetHierarchyPath(background),
                result = "UI_bg_raycast_preserved=" + result.uiBgRaycastPreserved
            });
        }

        private static void ApplyMainInterfaceRootCanvas(CandidateResult result)
        {
            var mainRoot = FindTransformByPrefix("UI_MainInterface_old__" + OldRootRectId)
                ?? FindTransformByName("UI_MainInterface_old");
            if (mainRoot == null)
                throw new Exception("UI_MainInterface_old root not found.");
            EnsureSourceCanvas(mainRoot, 0, "UI_MainInterface_old", result);
        }

        private static void AttachHero1005MainOnly(CandidateResult result)
        {
            var skeletonDataAsset = AssetDatabase.LoadAssetAtPath<SkeletonDataAsset>(HeroSkeletonDataPath);
            if (skeletonDataAsset == null || skeletonDataAsset.GetSkeletonData(true) == null)
                throw new Exception("Missing Hero1005 SkeletonDataAsset: " + HeroSkeletonDataPath);
            var material = AssetDatabase.LoadAssetAtPath<Material>(HeroMaterialPath);
            if (material == null)
                throw new Exception("Missing Hero1005 material: " + HeroMaterialPath);

            var heroParent = FindTransformByPrefix("UI_heroSpine__") ?? FindTransformByName("UI_heroSpine");
            if (heroParent == null)
                throw new Exception("UI_heroSpine not found in UI144 old-root candidate.");
            EnsureActiveInHierarchy(heroParent);

            var previous = heroParent.Find("Restore_Hero1005_SpineRoot_UI144");
            if (previous != null)
                UnityEngine.Object.DestroyImmediate(previous.gameObject);

            var root = new GameObject("Restore_Hero1005_SpineRoot_UI144", typeof(RectTransform));
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

            var graphic = SkeletonGraphic.NewSkeletonGraphicGameObject(skeletonDataAsset, rootRect, material);
            graphic.gameObject.name = "Painting_1005";
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
            rect.localPosition = new Vector3(0f, 0f, rect.localPosition.z);
            rect.sizeDelta = new Vector2(100f, 100f);
            rect.localScale = Vector3.one;
            rect.localRotation = Quaternion.identity;
            graphic.Initialize(true);
            if (skeletonDataAsset.GetSkeletonData(true).FindAnimation("A") != null)
                graphic.AnimationState.SetAnimation(0, "A", true);
            graphic.Update(0f);
            graphic.LateUpdate();
            graphic.MatchRectTransformWithBounds();
            graphic.UpdateMesh(true);

            result.patchRows.Add(new PatchRow
            {
                area = "Hero1005",
                action = "preserve_main_skeletongraphic_only",
                sourceEvidence = "UI124/UI135 source-backed Hero1005 main layer; Painting_1005_back not promoted",
                targetPath = GetHierarchyPath(graphic.transform),
                result = "mounted_main_only"
            });
        }

        private static void AttachUIDock(Scene candidateScene, Scene sourceScene, CandidateResult result)
        {
            var dockSourceRoot = FindSceneTransformByPrefix(sourceScene, "UI_Dock__" + UIDockRootRectId)
                ?? FindSceneTransformByName(sourceScene, "UI_Dock");
            if (dockSourceRoot == null)
                throw new Exception("UI_Dock source root not found in " + UIDockSourceScenePath);

            var candidateWrapRoot = FindTransformByName("MainInterface_Root_From_RectTransform_CSV");
            if (candidateWrapRoot == null)
                throw new Exception("Candidate root wrapper not found.");
            var existing = candidateWrapRoot.Find("UI_Dock_OpenStack_UI144");
            if (existing != null)
                UnityEngine.Object.DestroyImmediate(existing.gameObject);

            var copy = UnityEngine.Object.Instantiate(dockSourceRoot.gameObject);
            copy.name = "UI_Dock_OpenStack_UI144";
            SceneManager.MoveGameObjectToScene(copy, candidateScene);
            var copyTransform = copy.GetComponent<RectTransform>();
            copyTransform.SetParent(candidateWrapRoot, false);
            copyTransform.SetAsLastSibling();
            EnsureActiveInHierarchy(copyTransform);
            EnsureSourceCanvas(copyTransform, 100, "UI_Dock", result);

            var imported = 0;
            foreach (var spec in DockSpines)
            {
                var row = AttachDockSpine(copyTransform, spec);
                result.visibilityRows.Add(row);
                if (row.rendererAttached)
                    imported++;
            }
            result.uiDockRendererDependenciesImported = imported == DockSpines.Length;

            ApplyDockDefaultMainPageState(copyTransform, result);
            result.sourceRootCanvasSortingApplied = true;
            result.patchRows.Add(new PatchRow
            {
                area = "UI_Dock",
                action = "attach_source_root_canvas100_and_real_spine_renderers",
                sourceEvidence = "UI142 renderer dependency closure + UI143 root Canvas sorting UI_Dock=100",
                targetPath = GetHierarchyPath(copyTransform),
                result = "rendererAttached=" + imported + "/" + DockSpines.Length
            });
            EditorSceneManager.CloseScene(sourceScene, true);
        }

        private static void EnsureSourceCanvas(Transform root, int sortingOrder, string sourceRootName, CandidateResult result)
        {
            var canvas = root.GetComponent<Canvas>();
            if (canvas == null)
                canvas = root.gameObject.AddComponent<Canvas>();
            canvas.renderMode = RenderMode.ScreenSpaceCamera;
            canvas.overrideSorting = false;
            canvas.sortingOrder = sortingOrder;
            canvas.planeDistance = 100f;
            var serializedCanvas = new SerializedObject(canvas);
            var serializedSorting = serializedCanvas.FindProperty("m_SortingOrder");
            var serializedOverride = serializedCanvas.FindProperty("m_OverrideSorting");
            if (serializedSorting != null)
                serializedSorting.intValue = sortingOrder;
            if (serializedOverride != null)
                serializedOverride.boolValue = false;
            serializedCanvas.ApplyModifiedPropertiesWithoutUndo();
            if (root.GetComponent<GraphicRaycaster>() == null)
                root.gameObject.AddComponent<GraphicRaycaster>();
            result.patchRows.Add(new PatchRow
            {
                area = sourceRootName + "_root_canvas",
                action = "apply_source_serialized_root_canvas_sorting",
                sourceEvidence = "UI143 native Canvas component row: " + sourceRootName + "=" + sortingOrder,
                targetPath = GetHierarchyPath(root),
                result = "apiSortingOrder=" + canvas.sortingOrder + "; serializedSortingOrder=" + ReadSerializedCanvasSorting(canvas) + "; overrideSorting=" + canvas.overrideSorting
            });
        }

        private static int ReadSerializedCanvasSorting(Canvas canvas)
        {
            var serializedCanvas = new SerializedObject(canvas);
            var serializedSorting = serializedCanvas.FindProperty("m_SortingOrder");
            return serializedSorting != null ? serializedSorting.intValue : canvas.sortingOrder;
        }

        private static VisibilityRow AttachDockSpine(Transform dockRoot, DockSpineSpec spec)
        {
            var target = FindChildByRectPathId(dockRoot, spec.rectPathId) ?? FindChildByBaseName(dockRoot, spec.comName);
            var row = new VisibilityRow
            {
                comName = spec.comName,
                assetName = spec.assetName,
                sourceRectPathId = spec.rectPathId,
                expectedSourceActive = spec.sourceActive,
                expectedStartingAnimation = spec.startingAnimation,
                expectedStartingLoop = spec.startingLoop,
                expectedRaycastTarget = spec.raycastTarget,
                expectedMaskable = spec.maskable,
                expectedAllowMultipleCanvasRenderers = spec.allowMultipleCanvasRenderers
            };
            if (target == null)
            {
                row.status = "target_rect_not_found";
                return row;
            }
            row.hierarchyPath = GetHierarchyPath(target);
            row.activeSelfBefore = target.gameObject.activeSelf;
            row.activeInHierarchyBefore = target.gameObject.activeInHierarchy;
            var skeletonData = EnsureDockSkeletonAsset(spec, row);
            var material = AssetDatabase.LoadAssetAtPath<Material>(RuntimeDockRoot + "/" + spec.assetName + "/" + spec.assetName + "_Material.mat");
            if (skeletonData == null || material == null)
            {
                row.status = "asset_import_failed";
                return row;
            }
            var graphic = target.GetComponent<SkeletonGraphic>();
            if (graphic == null)
                graphic = target.gameObject.AddComponent<SkeletonGraphic>();
            graphic.skeletonDataAsset = skeletonData;
            graphic.material = material;
            graphic.additiveMaterial = AssetDatabase.LoadAssetAtPath<Material>(AdditiveGraphicMaterialPath);
            graphic.multiplyMaterial = AssetDatabase.LoadAssetAtPath<Material>(MultiplyGraphicMaterialPath);
            graphic.screenMaterial = AssetDatabase.LoadAssetAtPath<Material>(ScreenGraphicMaterialPath);
            graphic.initialSkinName = spec.initialSkinName;
            graphic.initialFlipX = spec.initialFlipX;
            graphic.initialFlipY = spec.initialFlipY;
            graphic.startingAnimation = spec.startingAnimation;
            graphic.startingLoop = spec.startingLoop;
            graphic.timeScale = spec.timeScale;
            graphic.freeze = spec.freeze;
            graphic.raycastTarget = spec.raycastTarget;
            graphic.maskable = spec.maskable;
            graphic.color = spec.color;
            graphic.allowMultipleCanvasRenderers = spec.allowMultipleCanvasRenderers;
            graphic.Initialize(true);
            if (skeletonData.GetSkeletonData(true).FindAnimation(spec.startingAnimation) != null)
                graphic.AnimationState.SetAnimation(0, spec.startingAnimation, spec.startingLoop);
            graphic.Update(0f);
            graphic.LateUpdate();
            graphic.UpdateMesh(true);
            row.rendererAttached = true;
            row.finalActiveSelf = target.gameObject.activeSelf;
            row.finalActiveInHierarchy = target.gameObject.activeInHierarchy;
            row.finalAnimation = spec.startingAnimation;
            row.finalLoop = spec.startingLoop;
            row.finalRaycastTarget = graphic.raycastTarget;
            row.finalMaskable = graphic.maskable;
            row.finalAllowMultipleCanvasRenderers = graphic.allowMultipleCanvasRenderers;
            row.rendererVisibleByActiveChain = target.gameObject.activeInHierarchy && graphic.enabled;
            row.status = "source_backed_skeletongraphic_attached";
            return row;
        }

        private static SkeletonDataAsset EnsureDockSkeletonAsset(DockSpineSpec spec, VisibilityRow row)
        {
            var outDir = RuntimeDockRoot + "/" + spec.assetName;
            Directory.CreateDirectory(outDir);
            var skeletonPath = outDir + "/" + spec.assetName + "_SkeletonData.asset";
            var atlasAssetPath = outDir + "/" + spec.assetName + "_Atlas.asset";
            var materialPath = outDir + "/" + spec.assetName + "_Material.mat";
            var existing = AssetDatabase.LoadAssetAtPath<SkeletonDataAsset>(skeletonPath);
            if (existing != null && existing.GetSkeletonData(true) != null)
            {
                row.skeletonDataAssetPath = skeletonPath;
                row.assetImportDecision = "reuse_existing_runtime_asset";
                return existing;
            }
            DeleteAssetIfExists(skeletonPath);
            DeleteAssetIfExists(atlasAssetPath);
            DeleteAssetIfExists(materialPath);
            AssetDatabase.ImportAsset(RawDockRoot + "/" + spec.assetName + "/" + spec.assetName + ".skel.bytes", ImportAssetOptions.ForceSynchronousImport);
            AssetDatabase.ImportAsset(RawDockRoot + "/" + spec.assetName + "/" + spec.assetName + ".atlas.txt", ImportAssetOptions.ForceSynchronousImport);
            AssetDatabase.ImportAsset(RawDockRoot + "/" + spec.assetName + "/" + spec.assetName + ".png", ImportAssetOptions.ForceSynchronousImport);
            var skeletonText = AssetDatabase.LoadAssetAtPath<TextAsset>(RawDockRoot + "/" + spec.assetName + "/" + spec.assetName + ".skel.bytes");
            var atlasText = AssetDatabase.LoadAssetAtPath<TextAsset>(RawDockRoot + "/" + spec.assetName + "/" + spec.assetName + ".atlas.txt");
            var texture = AssetDatabase.LoadAssetAtPath<Texture2D>(RawDockRoot + "/" + spec.assetName + "/" + spec.assetName + ".png");
            if (skeletonText == null || atlasText == null || texture == null)
            {
                row.assetImportDecision = "missing_raw_spine_source_file";
                return null;
            }
            var material = CreateMaterial(materialPath, DefaultGraphicMaterialPath, texture, spec.assetName + "_Material");
            var atlasAsset = SpineAtlasAsset.CreateRuntimeInstance(atlasText, new[] { material }, true);
            atlasAsset.name = spec.assetName + "_Atlas";
            AssetDatabase.CreateAsset(atlasAsset, atlasAssetPath);
            var skeletonData = SkeletonDataAsset.CreateRuntimeInstance(skeletonText, atlasAsset, true, 0.01f);
            skeletonData.name = spec.assetName + "_SkeletonData";
            AssetDatabase.CreateAsset(skeletonData, skeletonPath);
            AssetDatabase.SaveAssets();
            AssetDatabase.Refresh(ImportAssetOptions.ForceSynchronousImport);
            skeletonData = AssetDatabase.LoadAssetAtPath<SkeletonDataAsset>(skeletonPath);
            row.skeletonDataAssetPath = skeletonPath;
            row.assetImportDecision = skeletonData != null && skeletonData.GetSkeletonData(true) != null
                ? "created_source_backed_runtime_asset"
                : "created_asset_but_skeletondata_failed_to_load";
            return skeletonData;
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

        private static void ApplyDockDefaultMainPageState(Transform dockRoot, CandidateResult result)
        {
            foreach (var toggle in DockToggles)
            {
                var on = FindChildByRelativeSuffix(dockRoot, toggle.onSuffix);
                var off = FindChildByRelativeSuffix(dockRoot, toggle.offSuffix);
                if (on != null)
                    on.gameObject.SetActive(toggle.selected);
                if (off != null)
                    off.gameObject.SetActive(!toggle.selected);
                var spine = FindChildByRectPathId(dockRoot, toggle.spineRectPathId);
                var animationState = "not_applicable_spine_binding_not_matched";
                if (spine != null)
                {
                    var skeleton = spine.GetComponent<SkeletonGraphic>();
                    if (skeleton == null)
                        animationState = "not_applicable_no_skeleton_component";
                    else
                    {
                        var animationName = toggle.selected ? "A" : "B";
                        skeleton.Initialize(false);
                        if (skeleton.SkeletonData != null && skeleton.SkeletonData.FindAnimation(animationName) != null)
                        {
                            skeleton.AnimationState.SetAnimation(0, animationName, true);
                            skeleton.Update(0f);
                            skeleton.LateUpdate();
                            skeleton.UpdateMesh(true);
                            animationState = "applied_" + animationName;
                            var row = result.visibilityRows.FirstOrDefault(r => r.sourceRectPathId == toggle.spineRectPathId);
                            if (row != null)
                                row.luaInitTabAnimation = animationName;
                        }
                        else
                        {
                            animationState = "not_applicable_missing_animation_" + animationName;
                        }
                    }
                }
                result.patchRows.Add(new PatchRow
                {
                    area = "UI_Dock.initTab." + toggle.name,
                    action = "apply_source_lua_default_on_off_state",
                    sourceEvidence = "UI_Dock.lua initTab MAIN_PAGE default; UI136 follow-up hierarchy toggle*/im_on/im_off correction",
                    targetPath = (on != null ? GetHierarchyPath(on) : "") + "|" + (off != null ? GetHierarchyPath(off) : ""),
                    result = "selected=" + toggle.selected + "; animationState=" + animationState
                });
            }
        }

        private static CaptureMetrics Capture(Canvas canvas, string capturePath)
        {
            canvas.renderMode = RenderMode.ScreenSpaceCamera;
            var cameraGo = new GameObject("UI144_CaptureCamera", typeof(Camera));
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
            var visible = colors.Count(c => c.a > 0);
            var unique = new HashSet<Color32>(colors).Count;
            UnityEngine.Object.DestroyImmediate(texture);
            return new CaptureMetrics
            {
                exists = File.Exists(path),
                path = Path.GetFullPath(path),
                width = (int)ReferenceWidth,
                height = (int)ReferenceHeight,
                visiblePixelCount = visible,
                uniqueColorCount = unique
            };
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

        private static Transform FindChildByRectPathId(Transform root, string rectPathId)
        {
            var suffix = "__" + rectPathId;
            foreach (var transform in root.GetComponentsInChildren<Transform>(true))
            {
                if (transform == root)
                    continue;
                if (transform.name.EndsWith(suffix, StringComparison.Ordinal))
                    return transform;
            }
            return null;
        }

        private static Transform FindChildByBaseName(Transform root, string baseName)
        {
            foreach (var transform in root.GetComponentsInChildren<Transform>(true))
            {
                if (transform == root)
                    continue;
                if (transform.name == baseName || transform.name.StartsWith(baseName + "__", StringComparison.Ordinal))
                    return transform;
            }
            return null;
        }

        private static Transform FindChildByRelativeSuffix(Transform root, string suffix)
        {
            var normalized = suffix.Replace('\\', '/');
            foreach (var transform in root.GetComponentsInChildren<Transform>(true))
            {
                var path = GetRelativePath(root, transform);
                if (path.EndsWith(normalized, StringComparison.Ordinal)
                    || StripPathIds(path).EndsWith(normalized, StringComparison.Ordinal))
                    return transform;
            }
            return null;
        }

        private static string StripPathIds(string path)
        {
            var parts = path.Split('/');
            for (var i = 0; i < parts.Length; i++)
            {
                var idx = parts[i].IndexOf("__", StringComparison.Ordinal);
                if (idx >= 0)
                    parts[i] = parts[i].Substring(0, idx);
            }
            return string.Join("/", parts);
        }

        private static string GetRelativePath(Transform root, Transform transform)
        {
            var stack = new Stack<string>();
            for (var t = transform; t != null && t != root; t = t.parent)
                stack.Push(t.name);
            return string.Join("/", stack.ToArray());
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

        private static Transform FindSceneTransformByPrefix(Scene scene, string prefix)
        {
            foreach (var root in scene.GetRootGameObjects())
                foreach (var transform in root.GetComponentsInChildren<Transform>(true))
                    if (transform.name.StartsWith(prefix, StringComparison.Ordinal))
                        return transform;
            return null;
        }

        private static Transform FindSceneTransformByName(Scene scene, string name)
        {
            foreach (var root in scene.GetRootGameObjects())
                foreach (var transform in root.GetComponentsInChildren<Transform>(true))
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

        private static void DeleteAssetIfExists(string path)
        {
            if (AssetDatabase.LoadAssetAtPath<UnityEngine.Object>(path) != null)
                AssetDatabase.DeleteAsset(path);
        }

        private static string GetHierarchyPath(Transform transform)
        {
            var stack = new Stack<string>();
            for (var current = transform; current != null; current = current.parent)
                stack.Push(current.name);
            return string.Join("/", stack.ToArray());
        }

        private static void WriteOutputs(CandidateResult result)
        {
            WritePatchCsv(result.patchRows);
            WriteValidationCsv(result);
            WriteVisibilityCsv(result.visibilityRows);
            File.WriteAllText(UnitySummaryJson, JsonUtility.ToJson(result, true), new UTF8Encoding(false));
            File.WriteAllText(ResultJson, JsonUtility.ToJson(result, true), new UTF8Encoding(false));
        }

        private static void WritePatchCsv(List<PatchRow> rows)
        {
            var sb = new StringBuilder();
            sb.AppendLine("area,action,sourceEvidence,targetPath,result");
            foreach (var r in rows)
                sb.AppendLine(string.Join(",", Csv(r.area), Csv(r.action), Csv(r.sourceEvidence), Csv(r.targetPath), Csv(r.result)));
            File.WriteAllText(PatchCsv, sb.ToString(), new UTF8Encoding(false));
        }

        private static void WriteValidationCsv(CandidateResult result)
        {
            var rows = new List<ValidationRow>
            {
                new ValidationRow("unity_compile", result.unityCompilePassed ? "passed" : "failed", result.error),
                new ValidationRow("capture", result.captureProduced ? "produced" : "not_produced", result.capturePath),
                new ValidationRow("ui_bg_raycast", result.uiBgRaycastPreserved ? "preserved" : "changed", "baseline=" + result.uiBgBaselineRaycastTarget + "; final=" + result.uiBgFinalRaycastTarget),
                new ValidationRow("ui_bg_interactable", result.uiBgInteractablePreserved ? "preserved" : "changed", "baseline=" + result.uiBgBaselineInteractable + "; final=" + result.uiBgFinalInteractable),
                new ValidationRow("source_root_canvas_sorting", result.sourceRootCanvasSortingApplied ? "applied" : "not_applied", "UI_MainInterface_old=0; UI_Dock=100"),
                new ValidationRow("uidock_renderer_dependencies", result.uiDockRendererDependenciesImported ? "imported" : "not_imported", "attached=" + result.visibilityRows.Count(r => r.rendererAttached) + "/" + DockSpines.Length),
            };
            var sb = new StringBuilder();
            sb.AppendLine("check,status,detail");
            foreach (var r in rows)
                sb.AppendLine(string.Join(",", Csv(r.check), Csv(r.status), Csv(r.detail)));
            File.WriteAllText(ValidationCsv, sb.ToString(), new UTF8Encoding(false));
        }

        private static void WriteVisibilityCsv(List<VisibilityRow> rows)
        {
            var sb = new StringBuilder();
            sb.AppendLine("comName,assetName,sourceRectPathId,hierarchyPath,expectedSourceActive,activeSelfBefore,activeInHierarchyBefore,finalActiveSelf,finalActiveInHierarchy,rendererAttached,rendererVisibleByActiveChain,expectedStartingAnimation,finalAnimation,luaInitTabAnimation,expectedStartingLoop,finalLoop,expectedRaycastTarget,finalRaycastTarget,expectedMaskable,finalMaskable,expectedAllowMultipleCanvasRenderers,finalAllowMultipleCanvasRenderers,skeletonDataAssetPath,assetImportDecision,status");
            foreach (var r in rows)
            {
                sb.AppendLine(string.Join(",",
                    Csv(r.comName), Csv(r.assetName), Csv(r.sourceRectPathId), Csv(r.hierarchyPath),
                    Csv(r.expectedSourceActive), Csv(r.activeSelfBefore), Csv(r.activeInHierarchyBefore),
                    Csv(r.finalActiveSelf), Csv(r.finalActiveInHierarchy), Csv(r.rendererAttached),
                    Csv(r.rendererVisibleByActiveChain), Csv(r.expectedStartingAnimation), Csv(r.finalAnimation),
                    Csv(r.luaInitTabAnimation), Csv(r.expectedStartingLoop), Csv(r.finalLoop),
                    Csv(r.expectedRaycastTarget), Csv(r.finalRaycastTarget), Csv(r.expectedMaskable),
                    Csv(r.finalMaskable), Csv(r.expectedAllowMultipleCanvasRenderers),
                    Csv(r.finalAllowMultipleCanvasRenderers), Csv(r.skeletonDataAssetPath),
                    Csv(r.assetImportDecision), Csv(r.status)));
            }
            File.WriteAllText(VisibilityCsv, sb.ToString(), new UTF8Encoding(false));
        }

        private static string Csv(object value)
        {
            var s = Convert.ToString(value, CultureInfo.InvariantCulture) ?? "";
            if (s.Contains("\""))
                s = s.Replace("\"", "\"\"");
            return s.Contains(",") || s.Contains("\n") || s.Contains("\r") ? "\"" + s + "\"" : s;
        }

        private readonly struct DockSpineSpec
        {
            public readonly string group;
            public readonly string comName;
            public readonly string assetName;
            public readonly string rectPathId;
            public readonly string startingAnimation;
            public readonly bool startingLoop;
            public readonly string initialSkinName;
            public readonly bool sourceActive;
            public readonly bool initialFlipX;
            public readonly bool initialFlipY;
            public readonly float timeScale;
            public readonly bool freeze;
            public readonly bool raycastTarget;
            public readonly bool maskable;
            public readonly bool allowMultipleCanvasRenderers;
            public readonly Color color;

            public DockSpineSpec(string group, string comName, string assetName, string rectPathId, string startingAnimation,
                bool startingLoop, string initialSkinName, bool sourceActive, int initialFlipX, int initialFlipY,
                float timeScale, int freeze, int raycastTarget, int maskable, int allowMultipleCanvasRenderers, bool unused)
            {
                this.group = group;
                this.comName = comName;
                this.assetName = assetName;
                this.rectPathId = rectPathId;
                this.startingAnimation = startingAnimation;
                this.startingLoop = startingLoop;
                this.initialSkinName = initialSkinName;
                this.sourceActive = sourceActive;
                this.initialFlipX = initialFlipX != 0;
                this.initialFlipY = initialFlipY != 0;
                this.timeScale = timeScale;
                this.freeze = freeze != 0;
                this.raycastTarget = raycastTarget != 0;
                this.maskable = maskable != 0;
                this.allowMultipleCanvasRenderers = allowMultipleCanvasRenderers != 0;
                this.color = Color.white;
            }
        }

        private readonly struct DockToggleSpec
        {
            public readonly string name;
            public readonly string onSuffix;
            public readonly string offSuffix;
            public readonly bool selected;
            public readonly string spineRectPathId;

            public DockToggleSpec(string name, string onSuffix, string offSuffix, bool selected, string spineRectPathId)
            {
                this.name = name;
                this.onSuffix = onSuffix;
                this.offSuffix = offSuffix;
                this.selected = selected;
                this.spineRectPathId = spineRectPathId;
            }
        }

        [Serializable]
        private class CandidateResult
        {
            public string generatedAt;
            public bool restoredClaim;
            public bool scenePatchApplied;
            public bool candidatePatchApplied;
            public string patchDecision;
            public string status;
            public string error;
            public bool sceneSaved;
            public bool sourceRootCanvasSortingApplied;
            public bool uiDockRendererDependenciesImported;
            public bool unityCompilePassed;
            public bool captureProduced;
            public string scenePath;
            public string capturePath;
            public bool uiBgBaselineRaycastTarget;
            public bool uiBgFinalRaycastTarget;
            public bool uiBgRaycastPreserved;
            public bool uiBgBaselineInteractable;
            public bool uiBgFinalInteractable;
            public bool uiBgInteractablePreserved;
            public CaptureMetrics capture;
            public List<string> changedFiles;
            public List<string> guardrailsTouched;
            public List<PatchRow> patchRows;
            public List<ValidationRow> validationRows;
            public List<VisibilityRow> visibilityRows;
        }

        [Serializable]
        private class CaptureMetrics
        {
            public bool exists;
            public string path;
            public int width;
            public int height;
            public int visiblePixelCount;
            public int uniqueColorCount;
        }

        [Serializable]
        private class PatchRow
        {
            public string area;
            public string action;
            public string sourceEvidence;
            public string targetPath;
            public string result;
        }

        [Serializable]
        private class ValidationRow
        {
            public string check;
            public string status;
            public string detail;

            public ValidationRow(string check, string status, string detail)
            {
                this.check = check;
                this.status = status;
                this.detail = detail;
            }
        }

        [Serializable]
        private class VisibilityRow
        {
            public string comName;
            public string assetName;
            public string sourceRectPathId;
            public string hierarchyPath;
            public bool expectedSourceActive;
            public bool activeSelfBefore;
            public bool activeInHierarchyBefore;
            public bool finalActiveSelf;
            public bool finalActiveInHierarchy;
            public bool rendererAttached;
            public bool rendererVisibleByActiveChain;
            public string expectedStartingAnimation;
            public string finalAnimation;
            public string luaInitTabAnimation;
            public bool expectedStartingLoop;
            public bool finalLoop;
            public bool expectedRaycastTarget;
            public bool finalRaycastTarget;
            public bool expectedMaskable;
            public bool finalMaskable;
            public bool expectedAllowMultipleCanvasRenderers;
            public bool finalAllowMultipleCanvasRenderers;
            public string skeletonDataAssetPath;
            public string assetImportDecision;
            public string status;
        }
    }
}
