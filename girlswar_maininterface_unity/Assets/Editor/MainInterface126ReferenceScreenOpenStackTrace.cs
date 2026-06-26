using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using Spine.Unity;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.UI;

namespace GirlsWarRestore
{
    public static class MainInterface126ReferenceScreenOpenStackTrace
    {
        private const string OldRootRectId = "2475216337245998118";
        private const string OldRootScenePath = "Assets/Scenes/MainInterface_UI126_OldRootReferenceCandidate.unity";
        private const string CapturePath = "Assets/RestoreCaptures/maininterface_ui126_oldroot_hero1005_candidate_1680x720.png";
        private const string UI127CapturePath = "Assets/RestoreCaptures/maininterface_ui127_oldroot_bg1005_runtime_candidate_1680x720.png";
        private const string UI128CapturePath = "Assets/RestoreCaptures/maininterface_ui128_oldroot_runtime_activity_text_tmp_click_candidate_1680x720.png";
        private const string ReportJson = "Assets/RestoreData/maininterface_126_oldroot_candidate_capture.json";
        private const string UI127ReportJson = "Assets/RestoreData/maininterface_127_oldroot_bg1005_runtime_candidate_capture.json";
        private const string UI128ReportJson = "Assets/RestoreData/maininterface_128_oldroot_runtime_activity_text_tmp_click_candidate_capture.json";
        private const string ClickCsv = "Assets/RestoreData/reports/maininterface_126_oldroot_click_validation.csv";
        private const string ClickJson = "Assets/RestoreData/reports/maininterface_126_oldroot_click_validation_summary.json";
        private const string UI127ClickCsv = "Assets/RestoreData/reports/maininterface_127_oldroot_bg1005_click_validation.csv";
        private const string UI127ClickJson = "Assets/RestoreData/reports/maininterface_127_oldroot_bg1005_click_validation_summary.json";
        private const string UI128ClickCsv = "Assets/RestoreData/reports/maininterface_128_oldroot_runtime_activity_text_tmp_click_validation.csv";
        private const string UI128ClickJson = "Assets/RestoreData/reports/maininterface_128_oldroot_runtime_activity_text_tmp_click_validation_summary.json";
        private const string ReportMd = "C:/Users/godho/Downloads/girlswar/reports/maininterface/MAININTERFACE_126_OLDROOT_CANDIDATE_CAPTURE.md";
        private const string UI127ReportMd = "C:/Users/godho/Downloads/girlswar/reports/maininterface/MAININTERFACE_127_OLDROOT_BG1005_RUNTIME_CANDIDATE_CAPTURE.md";
        private const string UI128ReportMd = "C:/Users/godho/Downloads/girlswar/reports/maininterface/MAININTERFACE_128_OLDROOT_RUNTIME_ACTIVITY_TEXT_TMP_CLICK_CANDIDATE_CAPTURE.md";
        private const string HeroRoot = "Assets/RestoreData/hero1005_spine_source_raw/paintingprefabandres_1005";
        private const string SkeletonDataPath = HeroRoot + "/Painting_1005_SkeletonData.asset";
        private const string MaterialPath = HeroRoot + "/Painting_1005_Material.mat";
        private const string UI127BackgroundSpritePath = "Assets/RestoredSprites/maininterface/runtime_dynamic/runtime_UI_bg_noalphabg_PaintingBG_1005.png";
        private const float ReferenceWidth = 1680f;
        private const float ReferenceHeight = 720f;

        [MenuItem("GirlsWar/UI126 Build Old Root Reference Candidate Capture")]
        public static void BuildOldRootCandidateCapture()
        {
            Directory.CreateDirectory("Assets/Scenes");
            Directory.CreateDirectory("Assets/RestoreCaptures");
            Directory.CreateDirectory("Assets/RestoreData");
            Directory.CreateDirectory("C:/Users/godho/Downloads/girlswar/reports/maininterface");

            var result = new CandidateCaptureResult
            {
                generatedAt = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
                restoredClaim = false,
                rootRectId = OldRootRectId,
                scenePath = OldRootScenePath,
                capturePath = CapturePath,
                decisions = new List<string>()
            };

            try
            {
                MainInterfaceSceneBuilder.BuildMainInterfaceSceneForRoot(
                    OldRootRectId,
                    OldRootScenePath,
                    "MainInterface_UI126_OldRootReferenceCandidate");
                var scene = EditorSceneManager.OpenScene(OldRootScenePath, OpenSceneMode.Single);
                AttachHero1005(result);
                ForceSpineUpdate();
                EditorSceneManager.SaveScene(scene, OldRootScenePath);

                var canvas = UnityEngine.Object.FindFirstObjectByType<Canvas>();
                if (canvas == null)
                    throw new Exception("Canvas not found after old-root candidate build.");
                result.capture = Capture(canvas, CapturePath);
                result.clickSummary = ValidateClicks(canvas, ClickCsv, ClickJson);
                result.status = "ui126_oldroot_candidate_capture_generated";
                result.decisions.Add("Built old root `UI_MainInterface_old` from source RectTransform root " + OldRootRectId + " as a separate candidate scene.");
                result.decisions.Add("Mounted existing UI124 Hero1005 SkeletonDataAsset under old-root UI_heroSpine; no Painting_1005 whole PNG Image was used.");
                result.decisions.Add("No hide was applied to zhuye_di1/zhuye_bian, right, node_middle, wanfaWorldNode, or worldwanfaBtn.");
                result.decisions.Add("Wrote UI126 old-root candidate click validation to separate files without overwriting the production MainInterface click validation outputs.");
            }
            catch (Exception ex)
            {
                result.status = "ui126_oldroot_candidate_capture_failed";
                result.error = ex.GetType().Name + ": " + ex.Message;
                WriteOutputs(result);
                Debug.LogException(ex);
                throw;
            }

            WriteOutputs(result);
            AssetDatabase.Refresh(ImportAssetOptions.ForceSynchronousImport);
            Debug.Log("[GirlsWarRestore] UI126 old-root candidate capture complete: " + CapturePath);
        }

        [MenuItem("GirlsWar/UI127 Build Old Root BG1005 Runtime Candidate Capture")]
        public static void BuildOldRootBg1005RuntimeCandidateCapture()
        {
            Directory.CreateDirectory("Assets/Scenes");
            Directory.CreateDirectory("Assets/RestoreCaptures");
            Directory.CreateDirectory("Assets/RestoreData");
            Directory.CreateDirectory("Assets/RestoreData/reports");
            Directory.CreateDirectory("C:/Users/godho/Downloads/girlswar/reports/maininterface");

            var result = new CandidateCaptureResult
            {
                generatedAt = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
                restoredClaim = false,
                rootRectId = OldRootRectId,
                scenePath = OldRootScenePath,
                capturePath = UI127CapturePath,
                decisions = new List<string>()
            };

            try
            {
                MainInterfaceSceneBuilder.BuildMainInterfaceSceneForRoot(
                    OldRootRectId,
                    OldRootScenePath,
                    "MainInterface_UI126_OldRootReferenceCandidate");
                var scene = EditorSceneManager.OpenScene(OldRootScenePath, OpenSceneMode.Single);
                AttachHero1005(result);
                ApplyUI127BackgroundRuntimeEvidence(result);
                ForceSpineUpdate();
                EditorSceneManager.SaveScene(scene, OldRootScenePath);

                var canvas = UnityEngine.Object.FindFirstObjectByType<Canvas>();
                if (canvas == null)
                    throw new Exception("Canvas not found after UI127 old-root runtime candidate build.");
                result.capture = Capture(canvas, UI127CapturePath);
                result.clickSummary = ValidateClicks(canvas, UI127ClickCsv, UI127ClickJson);
                result.status = "ui127_oldroot_bg1005_runtime_candidate_capture_generated";
                result.decisions.Add("Built the same old-root candidate scene, preserving the UI124 real Hero1005 SkeletonGraphic mount.");
                result.decisions.Add("Applied only the source-backed normal-home background runtime candidate: UI_MainPage refreshMiddle calls UIUtil.GetPaintingBg(heroId) then GameTools:LoadSpriteWithFullPath(UI_bg,e,true); hero1005 resolves to noalphabg_PaintingBG_1005.");
                result.decisions.Add("Did not hide node_act_btn placeholders because UI_MainPage refreshMainAct depends on ActMgr:GetActInMain runtime/server data that is not reconstructed yet.");
                result.decisions.Add("Did not hide btn_discord: its decoded SetActive(false) evidence is inside the GameTools:IsReview() branch, while the reference still shows normal task/lobby elements such as node_renwu.");
                result.decisions.Add("No hide was applied to zhuye_di1/zhuye_bian, right, node_middle, wanfaWorldNode, or worldwanfaBtn.");
            }
            catch (Exception ex)
            {
                result.status = "ui127_oldroot_bg1005_runtime_candidate_capture_failed";
                result.error = ex.GetType().Name + ": " + ex.Message;
                WriteOutputs(result, UI127ReportJson, UI127ReportMd);
                Debug.LogException(ex);
                throw;
            }

            WriteOutputs(result, UI127ReportJson, UI127ReportMd);
            AssetDatabase.Refresh(ImportAssetOptions.ForceSynchronousImport);
            Debug.Log("[GirlsWarRestore] UI127 old-root BG1005 runtime candidate capture complete: " + UI127CapturePath);
        }

        [MenuItem("GirlsWar/UI128 Build Old Root Runtime Activity Text TMP Click Candidate Capture")]
        public static void BuildOldRootRuntimeActivityTextTmpClickCandidateCapture()
        {
            Directory.CreateDirectory("Assets/Scenes");
            Directory.CreateDirectory("Assets/RestoreCaptures");
            Directory.CreateDirectory("Assets/RestoreData");
            Directory.CreateDirectory("Assets/RestoreData/reports");
            Directory.CreateDirectory("C:/Users/godho/Downloads/girlswar/reports/maininterface");

            var result = new CandidateCaptureResult
            {
                generatedAt = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
                restoredClaim = false,
                rootRectId = OldRootRectId,
                scenePath = OldRootScenePath,
                capturePath = UI128CapturePath,
                decisions = new List<string>()
            };

            try
            {
                MainInterfaceSceneBuilder.BuildMainInterfaceSceneForRoot(
                    OldRootRectId,
                    OldRootScenePath,
                    "MainInterface_UI126_OldRootReferenceCandidate");
                var scene = EditorSceneManager.OpenScene(OldRootScenePath, OpenSceneMode.Single);
                AttachHero1005(result);
                ApplyUI127BackgroundRuntimeEvidence(result);
                ForceSpineUpdate();
                EditorSceneManager.SaveScene(scene, OldRootScenePath);

                var canvas = UnityEngine.Object.FindFirstObjectByType<Canvas>();
                if (canvas == null)
                    throw new Exception("Canvas not found after UI128 old-root runtime candidate build.");
                result.capture = Capture(canvas, UI128CapturePath);
                result.clickSummary = ValidateClicks(canvas, UI128ClickCsv, UI128ClickJson);
                result.status = "ui128_oldroot_runtime_activity_text_tmp_click_candidate_capture_generated";
                result.decisions.Add("Rebuilt the old-root candidate scene with the UI127 source-backed BG1005 runtime state and preserved UI124 real Hero1005 SkeletonGraphic.");
                result.decisions.Add("No additional visual patch was applied for activity icons/text/TMP because ActMgr:GetActInMain and GetActInMainFace depend on server/account runtime activity lists.");
                result.decisions.Add("Did not hide node_act_btn/btn_act_*: decoded UI_MainPage refreshMainAct first disables all p items, then enables only ActMgr:GetActInMain results; those results are not reconstructed.");
                result.decisions.Add("Did not alter UI_bg raycast/interactable state: original old-root UI_bg has an empty Button and no Lua listener, but no source-backed runtime raycast-off evidence was found.");
                result.decisions.Add("Did not hide btn_discord: its SetActive(false) evidence remains limited to GameTools:IsReview(), while the reference keeps normal home/task elements.");
                result.decisions.Add("No hide was applied to zhuye_di1/zhuye_bian, right, node_middle, wanfaWorldNode, or worldwanfaBtn.");
            }
            catch (Exception ex)
            {
                result.status = "ui128_oldroot_runtime_activity_text_tmp_click_candidate_capture_failed";
                result.error = ex.GetType().Name + ": " + ex.Message;
                WriteOutputs(result, UI128ReportJson, UI128ReportMd);
                Debug.LogException(ex);
                throw;
            }

            WriteOutputs(result, UI128ReportJson, UI128ReportMd);
            AssetDatabase.Refresh(ImportAssetOptions.ForceSynchronousImport);
            Debug.Log("[GirlsWarRestore] UI128 old-root runtime activity/text/TMP/click candidate capture complete: " + UI128CapturePath);
        }

        private static void AttachHero1005(CandidateCaptureResult result)
        {
            var skeletonDataAsset = AssetDatabase.LoadAssetAtPath<SkeletonDataAsset>(SkeletonDataPath);
            if (skeletonDataAsset == null || skeletonDataAsset.GetSkeletonData(true) == null)
                throw new Exception("Missing UI124 Hero1005 SkeletonDataAsset: " + SkeletonDataPath);
            var material = AssetDatabase.LoadAssetAtPath<Material>(MaterialPath);
            if (material == null)
                throw new Exception("Missing UI124 Hero1005 material: " + MaterialPath);

            var heroParent = FindTransformByPrefix("UI_heroSpine__") ?? FindTransformByName("UI_heroSpine");
            if (heroParent == null)
                throw new Exception("UI_heroSpine not found in old-root candidate scene.");
            EnsureActiveInHierarchy(heroParent);

            var previous = heroParent.Find("Restore_Hero1005_SpineRoot_UI126");
            if (previous != null)
                UnityEngine.Object.DestroyImmediate(previous.gameObject);

            var root = new GameObject("Restore_Hero1005_SpineRoot_UI126", typeof(RectTransform));
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
            graphic.gameObject.name = "Restore_Hero1005_Painting_1005_UI126";
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

            result.heroParentPath = GetHierarchyPath(heroParent);
            result.heroAnimation = "A";
            result.heroLoop = true;
        }

        private static void ApplyUI127BackgroundRuntimeEvidence(CandidateCaptureResult result)
        {
            var background = FindTransformByPrefix("UI_bg__-3280973633984018659");
            if (background == null)
                throw new Exception("UI127 old-root UI_bg target not found.");
            background.gameObject.SetActive(true);

            var image = background.GetComponent<Image>();
            if (image == null)
                image = background.gameObject.AddComponent<Image>();
            var sprite = AssetDatabase.LoadAssetAtPath<Sprite>(UI127BackgroundSpritePath);
            if (sprite == null)
                throw new Exception("UI127 background sprite not found: " + UI127BackgroundSpritePath);
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
            result.backgroundSpritePath = UI127BackgroundSpritePath;
        }

        private static CaptureMetrics Capture(Canvas canvas, string capturePath)
        {
            canvas.renderMode = RenderMode.ScreenSpaceCamera;
            var cameraGo = new GameObject("UI126_CaptureCamera", typeof(Camera));
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

        private static ClickSummary ValidateClicks(Canvas canvas, string clickCsv, string clickJson)
        {
            Directory.CreateDirectory("Assets/RestoreData/reports");
            Canvas.ForceUpdateCanvases();
            var graphics = FindRaycastGraphics(canvas);
            var buttons = UnityEngine.Object.FindObjectsByType<Button>(FindObjectsInactive.Include, FindObjectsSortMode.None);
            var rows = new List<ClickRow>();
            foreach (var button in buttons)
                rows.Add(ValidateButton(button, graphics));
            WriteClickCsv(rows, clickCsv);

            var summary = new ClickSummary
            {
                generatedAt = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
                scenePath = OldRootScenePath,
                csv = Path.GetFullPath(clickCsv),
                json = Path.GetFullPath(clickJson),
                totalButtons = rows.Count
            };
            foreach (var row in rows)
            {
                if (row.activeInHierarchy)
                    summary.activeButtons++;
                if (row.activeInHierarchy && row.interactable)
                    summary.activeInteractableButtons++;
                if (row.raycastClickable)
                    summary.raycastClickableButtons++;
                if (row.activeInHierarchy && row.interactable && !row.raycastClickable)
                    summary.raycastBlockedButtons++;
            }
            File.WriteAllText(clickJson, JsonUtility.ToJson(summary, true), Encoding.UTF8);
            return summary;
        }

        private static List<Graphic> FindRaycastGraphics(Canvas canvas)
        {
            var result = new List<Graphic>();
            foreach (var graphic in UnityEngine.Object.FindObjectsByType<Graphic>(FindObjectsInactive.Include, FindObjectsSortMode.None))
            {
                if (graphic == null || graphic.rectTransform == null)
                    continue;
                if (!graphic.gameObject.activeInHierarchy || !graphic.enabled || !graphic.raycastTarget)
                    continue;
                if (!graphic.transform.IsChildOf(canvas.transform))
                    continue;
                result.Add(graphic);
            }
            return result;
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
                hits.Add(new GraphicHit
                {
                    graphic = candidate,
                    depth = candidate.depth
                });
            }
            hits.Sort(CompareHitsTopFirst);

            var topObject = hits.Count > 0 ? hits[0].graphic.gameObject : null;
            var targetGraphicReady = button.targetGraphic != null && button.targetGraphic.enabled && button.targetGraphic.raycastTarget;
            var topWithinButton = topObject != null && topObject.transform.IsChildOf(button.transform);
            var active = button.gameObject.activeInHierarchy;
            var interactable = button.interactable && button.enabled;
            return new ClickRow
            {
                buttonName = button.gameObject.name,
                hierarchyPath = GetHierarchyPath(button.transform),
                activeInHierarchy = active,
                interactable = interactable,
                targetGraphicReady = targetGraphicReady,
                screenX = screenPoint.x,
                screenY = screenPoint.y,
                raycastHitCount = hits.Count,
                raycastTopObject = topObject != null ? GetHierarchyPath(topObject.transform) : "",
                raycastTopDepth = hits.Count > 0 ? hits[0].depth : 0,
                raycastTopWithinButton = topWithinButton,
                raycastClickable = active && interactable && targetGraphicReady && topWithinButton
            };
        }

        private static bool ContainsWorldPoint(RectTransform rectTransform, Vector3 worldPoint)
        {
            var local = rectTransform.InverseTransformPoint(worldPoint);
            return rectTransform.rect.Contains(local);
        }

        private static int CompareHitsTopFirst(GraphicHit a, GraphicHit b)
        {
            var depth = b.depth.CompareTo(a.depth);
            if (depth != 0)
                return depth;
            return string.CompareOrdinal(GetHierarchyPath(a.graphic.transform), GetHierarchyPath(b.graphic.transform));
        }

        private static void WriteClickCsv(List<ClickRow> rows, string clickCsv)
        {
            var sb = new StringBuilder();
            sb.AppendLine("buttonName,hierarchyPath,activeInHierarchy,interactable,targetGraphicReady,screenX,screenY,raycastHitCount,raycastTopDepth,raycastTopWithinButton,raycastClickable,raycastTopObject");
            foreach (var row in rows)
            {
                sb.Append(Escape(row.buttonName)).Append(',');
                sb.Append(Escape(row.hierarchyPath)).Append(',');
                sb.Append(row.activeInHierarchy).Append(',');
                sb.Append(row.interactable).Append(',');
                sb.Append(row.targetGraphicReady).Append(',');
                sb.Append(row.screenX.ToString("0.###")).Append(',');
                sb.Append(row.screenY.ToString("0.###")).Append(',');
                sb.Append(row.raycastHitCount).Append(',');
                sb.Append(row.raycastTopDepth).Append(',');
                sb.Append(row.raycastTopWithinButton).Append(',');
                sb.Append(row.raycastClickable).Append(',');
                sb.AppendLine(Escape(row.raycastTopObject));
            }
            File.WriteAllText(clickCsv, sb.ToString(), Encoding.UTF8);
        }

        private static string Escape(string value)
        {
            if (string.IsNullOrEmpty(value))
                return "";
            return "\"" + value.Replace("\"", "\"\"") + "\"";
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

        private static Transform FindTransformByPrefix(string prefix)
        {
            foreach (var transform in UnityEngine.Object.FindObjectsByType<Transform>(FindObjectsInactive.Include, FindObjectsSortMode.None))
            {
                if (transform.name.StartsWith(prefix, StringComparison.Ordinal))
                    return transform;
            }
            return null;
        }

        private static Transform FindTransformByName(string name)
        {
            foreach (var transform in UnityEngine.Object.FindObjectsByType<Transform>(FindObjectsInactive.Include, FindObjectsSortMode.None))
            {
                if (transform.name == name)
                    return transform;
            }
            return null;
        }

        private static void EnsureActiveInHierarchy(Transform transform)
        {
            var stack = new Stack<Transform>();
            var current = transform;
            while (current != null)
            {
                stack.Push(current);
                current = current.parent;
            }
            while (stack.Count > 0)
                stack.Pop().gameObject.SetActive(true);
        }

        private static string GetHierarchyPath(Transform transform)
        {
            var names = new Stack<string>();
            var current = transform;
            while (current != null)
            {
                names.Push(current.name);
                current = current.parent;
            }
            return string.Join("/", names);
        }

        private static void WriteOutputs(CandidateCaptureResult result)
        {
            WriteOutputs(result, ReportJson, ReportMd);
        }

        private static void WriteOutputs(CandidateCaptureResult result, string reportJson, string reportMd)
        {
            File.WriteAllText(reportJson, JsonUtility.ToJson(result, true), Encoding.UTF8);
            var sb = new StringBuilder();
            sb.AppendLine("# " + Path.GetFileNameWithoutExtension(reportMd));
            sb.AppendLine();
            sb.AppendLine("- generatedAt: " + result.generatedAt);
            sb.AppendLine("- status: `" + result.status + "`");
            sb.AppendLine("- restoredClaim: `false`");
            sb.AppendLine("- rootRectId: `" + result.rootRectId + "`");
            sb.AppendLine("- scene: `" + result.scenePath + "`");
            sb.AppendLine("- capture: `" + result.capturePath + "`");
            sb.AppendLine("- heroParentPath: `" + result.heroParentPath + "`");
            if (!string.IsNullOrEmpty(result.backgroundPath))
                sb.AppendLine("- backgroundPath: `" + result.backgroundPath + "`");
            if (!string.IsNullOrEmpty(result.backgroundSpritePath))
                sb.AppendLine("- backgroundSpritePath: `" + result.backgroundSpritePath + "`");
            if (result.capture != null)
                sb.AppendLine("- visiblePixelCount: `" + result.capture.visiblePixelCount + "`, uniqueColorCount: `" + result.capture.uniqueColorCount + "`, bounds: `" + result.capture.bounds + "`");
            if (result.clickSummary != null)
            {
                sb.AppendLine("- click total/active/clickable/blocked: `" + result.clickSummary.totalButtons + " / " + result.clickSummary.activeButtons + " / " + result.clickSummary.raycastClickableButtons + " / " + result.clickSummary.raycastBlockedButtons + "`");
                sb.AppendLine("- click CSV: `" + result.clickSummary.csv + "`");
                sb.AppendLine("- click JSON: `" + result.clickSummary.json + "`");
            }
            if (!string.IsNullOrEmpty(result.error))
                sb.AppendLine("- error: `" + result.error + "`");
            sb.AppendLine();
            sb.AppendLine("## Decisions");
            foreach (var decision in result.decisions)
                sb.AppendLine("- " + decision);
            sb.AppendLine();
            sb.AppendLine("## Verdict");
            sb.AppendLine("- Candidate capture only. This does not mark MainInterface restored.");
            File.WriteAllText(reportMd, sb.ToString(), Encoding.UTF8);
        }

        [Serializable]
        private sealed class CandidateCaptureResult
        {
            public string generatedAt;
            public string status;
            public bool restoredClaim;
            public string rootRectId;
            public string scenePath;
            public string capturePath;
            public string heroParentPath;
            public string heroAnimation;
            public bool heroLoop;
            public string backgroundPath;
            public string backgroundSpritePath;
            public string error;
            public CaptureMetrics capture;
            public ClickSummary clickSummary;
            public List<string> decisions;
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
            public string scenePath;
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
