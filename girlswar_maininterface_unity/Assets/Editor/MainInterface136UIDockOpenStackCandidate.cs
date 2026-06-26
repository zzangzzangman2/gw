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
    public static class MainInterface136UIDockOpenStackCandidate
    {
        private const string OldRootRectId = "2475216337245998118";
        private const string UIDockRootRectId = "7409970622389811116";
        private const string CandidateScenePath = "Assets/Scenes/MainInterface_UI136_UIDockOpenStackCandidate.unity";
        private const string UIDockSourceScenePath = "Assets/Scenes/MainInterface_UI136_UIDockSourceOnly.unity";
        private const string CapturePath = "Assets/RestoreCaptures/maininterface_ui136_uidock_openstack_candidate_1680x720.png";
        private const string HeroRoot = "Assets/RestoreData/hero1005_spine_source_raw/paintingprefabandres_1005";
        private const string SkeletonDataPath = HeroRoot + "/Painting_1005_SkeletonData.asset";
        private const string MaterialPath = HeroRoot + "/Painting_1005_Material.mat";
        private const string BackgroundSpritePath = "Assets/RestoredSprites/maininterface/runtime_dynamic/runtime_UI_bg_noalphabg_PaintingBG_1005.png";
        private const string ReportDir = "C:/Users/godho/Downloads/girlswar/reports/maininterface";
        private const string UnityJson = "Assets/RestoreData/reports/maininterface_136_uidock_openstack_candidate_summary.json";
        private const string SceneProbeCsv = ReportDir + "/MAININTERFACE_136_uidock_candidate_scene_probe.csv";
        private const string ClickCsv = "Assets/RestoreData/reports/maininterface_136_uidock_click_validation.csv";
        private const string ClickJson = "Assets/RestoreData/reports/maininterface_136_uidock_click_validation_summary.json";
        private const float ReferenceWidth = 1680f;
        private const float ReferenceHeight = 720f;

        [MenuItem("GirlsWar/UI136 UIDock Open Stack Candidate Capture")]
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
                productionPatchApplied = false,
                candidatePatchApplied = false,
                dockCandidateApplied = false,
                scenePath = CandidateScenePath,
                dockSourceScenePath = UIDockSourceScenePath,
                capturePath = CapturePath,
                oldRootRectId = OldRootRectId,
                uiDockRootRectId = UIDockRootRectId,
                decisions = new List<string>(),
                dockRows = new List<DockSceneRow>()
            };

            try
            {
                MainInterfaceSceneBuilder.BuildMainInterfaceSceneForRoot(
                    OldRootRectId,
                    CandidateScenePath,
                    "MainInterface_UI136_UIDockOpenStackCandidate");
                var candidateScene = EditorSceneManager.OpenScene(CandidateScenePath, OpenSceneMode.Single);
                ApplyBg1005(result);
                AttachHero1005MainOnly(result);
                ForceSpineUpdate();
                EditorSceneManager.SaveScene(candidateScene, CandidateScenePath);

                MainInterfaceSceneBuilder.BuildMainInterfaceSceneForRoot(
                    UIDockRootRectId,
                    UIDockSourceScenePath,
                    "MainInterface_UI136_UIDockSourceOnly");

                candidateScene = EditorSceneManager.OpenScene(CandidateScenePath, OpenSceneMode.Single);
                var sourceScene = EditorSceneManager.OpenScene(UIDockSourceScenePath, OpenSceneMode.Additive);
                AttachUIDockOpenStackCandidate(candidateScene, sourceScene, result);
                ForceSpineUpdate();
                EditorSceneManager.SaveScene(candidateScene, CandidateScenePath);
                result.sceneSaved = true;
                result.candidatePatchApplied = result.dockCandidateApplied;

                var canvas = UnityEngine.Object.FindFirstObjectByType<Canvas>();
                if (canvas == null)
                    throw new Exception("Canvas not found after UI136 candidate build.");
                result.capture = Capture(canvas, CapturePath);
                result.clickSummary = ValidateClicks(canvas, ClickCsv, ClickJson);
                result.status = "ui136_uidock_openstack_candidate_capture_generated";
                result.patchDecision = result.dockCandidateApplied
                    ? "candidate_uidock_openstack_sibling_form_applied_no_back_layer_no_dock_coordinate_patch"
                    : "blocked_no_patch_uidock_source_root_not_attachable";
            }
            catch (Exception ex)
            {
                result.status = "ui136_failed";
                result.error = ex.GetType().Name + ": " + ex.Message;
                WriteOutputs(result);
                Debug.LogException(ex);
                throw;
            }

            WriteOutputs(result);
            AssetDatabase.Refresh(ImportAssetOptions.ForceSynchronousImport);
            Debug.Log("[GirlsWarRestore] UI136 UIDock candidate complete: " + CapturePath);
        }

        private static void ApplyBg1005(CandidateResult result)
        {
            var background = FindTransformByPrefix("UI_bg__-3280973633984018659") ?? FindTransformByName("UI_bg");
            if (background == null)
                throw new Exception("UI_bg target not found for UI136 old-root candidate.");
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
            result.backgroundPath = GetHierarchyPath(background);
            result.uiBgHadImage = hadImage;
            result.uiBgBaselineRaycastTarget = baselineRaycastTarget;
            result.uiBgFinalRaycastTarget = image.raycastTarget;
            result.uiBgRaycastPreserved = baselineRaycastTarget == image.raycastTarget;
            result.uiBgHadButton = hadButton;
            result.uiBgBaselineInteractable = baselineInteractable;
            result.uiBgFinalInteractable = button != null && button.interactable;
            result.uiBgInteractablePreserved = !hadButton || baselineInteractable == result.uiBgFinalInteractable;
            result.uiBgPreserveNote = hadImage
                ? "Preserved existing UI_bg Image.raycastTarget from the rebuilt UI128-equivalent old-root baseline."
                : "UI_bg had no Image before BG1005 binding; added Image and used Unity Graphic default-equivalent baseline value recorded here.";
            result.dockRows.Add(new DockSceneRow
            {
                category = "ui_bg_guardrail",
                name = background.name,
                hierarchyPath = GetHierarchyPath(background),
                activeSelf = background.gameObject.activeSelf,
                activeInHierarchy = background.gameObject.activeInHierarchy,
                siblingIndex = background.GetSiblingIndex(),
                componentTypes = string.Join("|", background.GetComponents<Component>().Where(c => c != null).Select(c => c.GetType().Name).Distinct().OrderBy(s => s, StringComparer.Ordinal)),
                hasButton = hadButton,
                buttonInteractable = result.uiBgFinalInteractable,
                hasGraphic = true,
                graphicRaycastTarget = result.uiBgFinalRaycastTarget,
                imageSprite = sprite.name,
                anchoredPosition = Vec2(rect.anchoredPosition),
                sizeDelta = Vec2(rect.sizeDelta),
                localScale = Vec3(background.localScale),
                note = "UI_bg_raycast_preserved=" + result.uiBgRaycastPreserved
                    + "; baselineRaycast=" + result.uiBgBaselineRaycastTarget
                    + "; finalRaycast=" + result.uiBgFinalRaycastTarget
                    + "; baselineInteractable=" + result.uiBgBaselineInteractable
                    + "; finalInteractable=" + result.uiBgFinalInteractable
            });
            result.decisions.Add("Preserved UI127/UI128 source-backed BG1005 UI_bg binding while preserving existing UI_bg raycast/interactable values.");
        }

        private static void AttachHero1005MainOnly(CandidateResult result)
        {
            var skeletonDataAsset = AssetDatabase.LoadAssetAtPath<SkeletonDataAsset>(SkeletonDataPath);
            if (skeletonDataAsset == null || skeletonDataAsset.GetSkeletonData(true) == null)
                throw new Exception("Missing Hero1005 SkeletonDataAsset: " + SkeletonDataPath);
            var material = AssetDatabase.LoadAssetAtPath<Material>(MaterialPath);
            if (material == null)
                throw new Exception("Missing Hero1005 material: " + MaterialPath);

            var heroParent = FindTransformByPrefix("UI_heroSpine__") ?? FindTransformByName("UI_heroSpine");
            if (heroParent == null)
                throw new Exception("UI_heroSpine not found in UI136 old-root candidate.");
            EnsureActiveInHierarchy(heroParent);

            var previous = heroParent.Find("Restore_Hero1005_SpineRoot_UI136");
            if (previous != null)
                UnityEngine.Object.DestroyImmediate(previous.gameObject);

            var root = new GameObject("Restore_Hero1005_SpineRoot_UI136", typeof(RectTransform));
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

            result.heroParentPath = GetHierarchyPath(heroParent);
            result.heroPath = GetHierarchyPath(graphic.transform);
            result.decisions.Add("Mounted only the real Hero1005 main SkeletonGraphic child Painting_1005 with decoded homePara [1,0,0]; no Painting_1005_back/front layer was mounted.");
        }

        private static void AttachUIDockOpenStackCandidate(Scene candidateScene, Scene sourceScene, CandidateResult result)
        {
            var dockSourceRoot = FindSceneTransformByPrefix(sourceScene, "UI_Dock__" + UIDockRootRectId)
                ?? FindSceneTransformByName(sourceScene, "UI_Dock");
            if (dockSourceRoot == null)
                throw new Exception("UI_Dock source root not found in " + UIDockSourceScenePath);

            var candidateWrapRoot = FindTransformByName("MainInterface_Root_From_RectTransform_CSV");
            if (candidateWrapRoot == null)
                throw new Exception("Candidate root wrapper not found.");

            var existing = candidateWrapRoot.Find("UI_Dock_OpenStack_UI136");
            if (existing != null)
                UnityEngine.Object.DestroyImmediate(existing.gameObject);

            var copy = UnityEngine.Object.Instantiate(dockSourceRoot.gameObject);
            copy.name = "UI_Dock_OpenStack_UI136";
            SceneManager.MoveGameObjectToScene(copy, candidateScene);
            var copyTransform = copy.GetComponent<RectTransform>();
            copyTransform.SetParent(candidateWrapRoot, false);
            copyTransform.SetAsLastSibling();
            EnsureActiveInHierarchy(copyTransform);

            ApplyDockDefaultMainPageState(copyTransform, result);
            CollectDockRows(copyTransform, result);
            result.dockRootPath = GetHierarchyPath(copyTransform);
            result.dockCandidateApplied = true;
            result.decisions.Add("Attached source-built UI_Dock root as a sibling form above old-root UI_MainInterface_old, matching UI_Dock open-stack evidence rather than importing old node_bottom/toogles.");
            result.decisions.Add("Applied only UI_Dock Lua default MAIN_PAGE on/off state from initTab; no fake dock icons/text or dummy click handlers were created.");
            result.decisions.Add("Did not hide or alter activity stack, face activity, btn_discord, UI_bg raycast/interactable, route/world nodes, or zhuye_di1/zhuye_bian.");

            EditorSceneManager.CloseScene(sourceScene, true);
        }

        private static void ApplyDockDefaultMainPageState(Transform dockRoot, CandidateResult result)
        {
            var groups = new[]
            {
                new DockGroup("MAIN_PAGE", "main_on", "main_off", true, "-5891749526711796232", "-8260082556590129835", "3835362230345717257"),
                new DockGroup("CAMP", "camp_on", "camp_off", false, "4968733986243935381", "5193622481985759590", "4593879884870609137"),
                new DockGroup("BAG", "bag_on", "bag_off", false, "-4554973158640049960", "518680114936329312", "3425111358649296926"),
                new DockGroup("EXPEDITION", "expedition_on", "expedition_off", false, "-1222559236234254205", "7609373578294030332", "-5242930961941176902"),
                new DockGroup("ADVENTURE", "adventureInterface_on", "adventureInterface_off", false, "-5215337679687611488", "-4795627789347214698", "6488046465587119062"),
                new DockGroup("GUILD", "guild_on", "guild_off", false, "-3542802835436383425", "4975218722388425263", "5586381430955413960"),
                new DockGroup("MAIN_CITY", "mainCity_on", "mainCity_off", false, "2411793564342831924", "-214759850272892160", "2275674091209698383")
            };

            foreach (var group in groups)
            {
                var on = FindChildByRectPathId(dockRoot, group.onRectPathId) ?? FindChildByBaseName(dockRoot, group.onName);
                var off = FindChildByRectPathId(dockRoot, group.offRectPathId) ?? FindChildByBaseName(dockRoot, group.offName);
                var onMatched = on != null;
                var offMatched = off != null;
                if (on != null)
                    on.gameObject.SetActive(group.selected);
                if (off != null)
                    off.gameObject.SetActive(!group.selected);
                var onFinal = on != null && on.gameObject.activeSelf;
                var offFinal = off != null && off.gameObject.activeSelf;
                var mismatch = !onMatched || !offMatched || onFinal != group.selected || offFinal != !group.selected;
                if (onMatched && offMatched)
                    result.matchedToggleCount++;
                if (mismatch)
                    result.onOffMismatchCount++;
                result.dockRows.Add(new DockSceneRow
                {
                    category = "lua_initTab_default_state",
                    name = group.name,
                    hierarchyPath = (on != null ? GetHierarchyPath(on) : "") + "|" + (off != null ? GetHierarchyPath(off) : ""),
                    activeInHierarchy = !mismatch,
                    activeSelf = !mismatch,
                    siblingIndex = -1,
                    componentTypes = "UI_Dock.lua lines 67,138-149 + maininterface_lua_com_bindings.csv",
                    anchoredPosition = "",
                    sizeDelta = "",
                    localScale = "",
                    note = (group.selected ? "selected MAIN_PAGE: on active, off inactive" : "unselected dock tab: on inactive, off active")
                        + "; onRectPathId=" + group.onRectPathId
                        + "; offRectPathId=" + group.offRectPathId
                        + "; onFound=" + onMatched
                        + "; offFound=" + offMatched
                        + "; onFinalActiveSelf=" + onFinal
                        + "; offFinalActiveSelf=" + offFinal
                        + "; spineAnimationState=" + ApplyDockSpineAnimation(dockRoot, group)
                });
            }
            result.dockDefaultStateApplied = result.matchedToggleCount > 0 && result.onOffMismatchCount == 0;
        }

        private static string ApplyDockSpineAnimation(Transform dockRoot, DockGroup group)
        {
            var spine = FindChildByRectPathId(dockRoot, group.spineRectPathId);
            if (spine == null)
                return "not_applicable_spine_binding_not_matched";
            var skeleton = spine.GetComponent<SkeletonGraphic>();
            if (skeleton == null)
                return "not_applicable_no_skeleton_component";
            var animationName = group.selected ? "A" : "B";
            skeleton.Initialize(false);
            if (skeleton.SkeletonData == null || skeleton.SkeletonData.FindAnimation(animationName) == null)
                return "not_applicable_missing_animation_" + animationName;
            skeleton.AnimationState.SetAnimation(0, animationName, true);
            skeleton.Update(0f);
            skeleton.LateUpdate();
            skeleton.UpdateMesh(true);
            return "applied_" + animationName;
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

        private static void CollectDockRows(Transform dockRoot, CandidateResult result)
        {
            foreach (var transform in dockRoot.GetComponentsInChildren<Transform>(true))
            {
                var rect = transform as RectTransform;
                var graphic = transform.GetComponent<Graphic>();
                var button = transform.GetComponent<Button>();
                result.dockRows.Add(new DockSceneRow
                {
                    category = transform == dockRoot ? "uidock_root" : "uidock_hierarchy",
                    name = transform.name,
                    hierarchyPath = GetHierarchyPath(transform),
                    activeInHierarchy = transform.gameObject.activeInHierarchy,
                    activeSelf = transform.gameObject.activeSelf,
                    siblingIndex = transform.GetSiblingIndex(),
                    componentTypes = string.Join("|", transform.GetComponents<Component>().Where(c => c != null).Select(c => c.GetType().Name).Distinct().OrderBy(s => s, StringComparer.Ordinal)),
                    hasButton = button != null,
                    buttonInteractable = button != null && button.interactable,
                    hasGraphic = graphic != null,
                    graphicRaycastTarget = graphic != null && graphic.raycastTarget,
                    imageSprite = graphic is Image image && image.sprite != null ? image.sprite.name : "",
                    anchoredPosition = rect != null ? Vec2(rect.anchoredPosition) : "",
                    sizeDelta = rect != null ? Vec2(rect.sizeDelta) : "",
                    localScale = Vec3(transform.localScale),
                    note = "source-built UI_Dock hierarchy row; no coordinate-only patch applied"
                });
            }
        }

        private static CaptureMetrics Capture(Canvas canvas, string capturePath)
        {
            canvas.renderMode = RenderMode.ScreenSpaceCamera;
            var cameraGo = new GameObject("UI136_CaptureCamera", typeof(Camera));
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
            var screenPoint = Vector2.zero;
            if (rt != null)
            {
                var corners = new Vector3[4];
                rt.GetWorldCorners(corners);
                centerWorld = (corners[0] + corners[2]) * 0.5f;
                screenPoint = new Vector2(ReferenceWidth * 0.5f + centerWorld.x, ReferenceHeight * 0.5f + centerWorld.y);
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
            var targetGraphicReady = button.targetGraphic != null && button.targetGraphic.enabled && button.targetGraphic.raycastTarget;
            var topWithinButton = top != null && top.transform.IsChildOf(button.transform);
            return new ClickRow
            {
                buttonName = button.gameObject.name,
                hierarchyPath = GetHierarchyPath(button.transform),
                activeInHierarchy = button.gameObject.activeInHierarchy,
                interactable = button.interactable && button.enabled,
                targetGraphicReady = targetGraphicReady,
                screenX = screenPoint.x,
                screenY = screenPoint.y,
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

        private static void WriteOutputs(CandidateResult result)
        {
            WriteDockRows(result.dockRows);
            File.WriteAllText(UnityJson, JsonUtility.ToJson(result, true), new UTF8Encoding(false));
        }

        private static void WriteDockRows(List<DockSceneRow> rows)
        {
            var sb = new StringBuilder();
            sb.AppendLine("category,name,hierarchyPath,activeSelf,activeInHierarchy,siblingIndex,componentTypes,hasButton,buttonInteractable,hasGraphic,graphicRaycastTarget,imageSprite,anchoredPosition,sizeDelta,localScale,note");
            foreach (var r in rows)
            {
                sb.AppendLine(string.Join(",", new[]
                {
                    Csv(r.category), Csv(r.name), Csv(r.hierarchyPath), r.activeSelf.ToString(), r.activeInHierarchy.ToString(),
                    r.siblingIndex.ToString(CultureInfo.InvariantCulture), Csv(r.componentTypes), r.hasButton.ToString(),
                    r.buttonInteractable.ToString(), r.hasGraphic.ToString(), r.graphicRaycastTarget.ToString(), Csv(r.imageSprite),
                    Csv(r.anchoredPosition), Csv(r.sizeDelta), Csv(r.localScale), Csv(r.note)
                }));
            }
            File.WriteAllText(SceneProbeCsv, sb.ToString(), new UTF8Encoding(false));
        }

        private static void WriteClickCsv(List<ClickRow> rows, string clickCsv)
        {
            var sb = new StringBuilder();
            sb.AppendLine("buttonName,hierarchyPath,activeInHierarchy,interactable,targetGraphicReady,screenX,screenY,raycastHitCount,raycastTopDepth,raycastTopWithinButton,raycastClickable,raycastTopObject");
            foreach (var r in rows)
            {
                sb.AppendLine(string.Join(",", new[]
                {
                    Csv(r.buttonName), Csv(r.hierarchyPath), r.activeInHierarchy.ToString(), r.interactable.ToString(),
                    r.targetGraphicReady.ToString(), r.screenX.ToString("0.###", CultureInfo.InvariantCulture),
                    r.screenY.ToString("0.###", CultureInfo.InvariantCulture), r.raycastHitCount.ToString(CultureInfo.InvariantCulture),
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

        private sealed class DockGroup
        {
            public readonly string name;
            public readonly string onName;
            public readonly string offName;
            public readonly bool selected;
            public readonly string onRectPathId;
            public readonly string offRectPathId;
            public readonly string spineRectPathId;

            public DockGroup(string name, string onName, string offName, bool selected, string onRectPathId, string offRectPathId, string spineRectPathId)
            {
                this.name = name;
                this.onName = onName;
                this.offName = offName;
                this.selected = selected;
                this.onRectPathId = onRectPathId;
                this.offRectPathId = offRectPathId;
                this.spineRectPathId = spineRectPathId;
            }
        }

        [Serializable]
        private sealed class CandidateResult
        {
            public string generatedAt;
            public string status;
            public bool restoredClaim;
            public bool sceneSaved;
            public bool candidatePatchApplied;
            public bool productionPatchApplied;
            public bool dockCandidateApplied;
            public bool dockDefaultStateApplied;
            public int matchedToggleCount;
            public int onOffMismatchCount;
            public string patchDecision;
            public string scenePath;
            public string dockSourceScenePath;
            public string capturePath;
            public string oldRootRectId;
            public string uiDockRootRectId;
            public string backgroundPath;
            public bool uiBgHadImage;
            public bool uiBgBaselineRaycastTarget;
            public bool uiBgFinalRaycastTarget;
            public bool uiBgRaycastPreserved;
            public bool uiBgHadButton;
            public bool uiBgBaselineInteractable;
            public bool uiBgFinalInteractable;
            public bool uiBgInteractablePreserved;
            public string uiBgPreserveNote;
            public string heroParentPath;
            public string heroPath;
            public string dockRootPath;
            public string error;
            public CaptureMetrics capture;
            public ClickSummary clickSummary;
            public List<string> decisions;
            public List<DockSceneRow> dockRows;
        }

        [Serializable]
        private sealed class DockSceneRow
        {
            public string category;
            public string name;
            public string hierarchyPath;
            public bool activeSelf;
            public bool activeInHierarchy;
            public int siblingIndex;
            public string componentTypes;
            public bool hasButton;
            public bool buttonInteractable;
            public bool hasGraphic;
            public bool graphicRaycastTarget;
            public string imageSprite;
            public string anchoredPosition;
            public string sizeDelta;
            public string localScale;
            public string note;
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
            public float screenX;
            public float screenY;
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
