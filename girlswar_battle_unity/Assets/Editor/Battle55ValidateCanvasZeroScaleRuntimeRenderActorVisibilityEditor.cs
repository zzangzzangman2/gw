using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.UI;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Text;

public static class Battle55ValidateCanvasZeroScaleRuntimeRenderActorVisibilityEditor
{
    private const string ScenePath = "Assets/Scenes/Battle51LuaBridgeRaycasterRegistrationCandidate.unity";
    private const string Prefix = "BATTLE_55_VALIDATE_CANVAS_ZERO_SCALE_RUNTIME_RENDER_AND_ACTOR_VISIBILITY_OR_SOURCE_BACKED_PATCH";
    private const string SummaryPath = "Assets/RestoreData/battle/BATTLE_55_VALIDATE_CANVAS_ZERO_SCALE_RUNTIME_RENDER_AND_ACTOR_VISIBILITY_OR_SOURCE_BACKED_PATCH_UNITY_SUMMARY.json";
    private const string ZeroScalePath = "Assets/RestoreData/battle/BATTLE_55_VALIDATE_CANVAS_ZERO_SCALE_RUNTIME_RENDER_AND_ACTOR_VISIBILITY_OR_SOURCE_BACKED_PATCH_ZERO_SCALE_RUNTIME.csv";
    private const string ActorsPath = "Assets/RestoreData/battle/BATTLE_55_VALIDATE_CANVAS_ZERO_SCALE_RUNTIME_RENDER_AND_ACTOR_VISIBILITY_OR_SOURCE_BACKED_PATCH_ACTOR_VISIBILITY.csv";
    private const string CamerasPath = "Assets/RestoreData/battle/BATTLE_55_VALIDATE_CANVAS_ZERO_SCALE_RUNTIME_RENDER_AND_ACTOR_VISIBILITY_OR_SOURCE_BACKED_PATCH_CAMERAS.csv";
    private const string RenderersPath = "Assets/RestoreData/battle/BATTLE_55_VALIDATE_CANVAS_ZERO_SCALE_RUNTIME_RENDER_AND_ACTOR_VISIBILITY_OR_SOURCE_BACKED_PATCH_RENDERERS.csv";
    private static readonly string BasePath = @"C:\Users\godho\Downloads\girlswar";
    private static readonly string B54RoutesCsv = Path.Combine(BasePath, @"reports\battle\BATTLE_54_VALIDATE_ROUTE_ACTIVE_SIBLING_MASK_TMP_SCALE_AUTOSIZE_ACTOR_PAYLOAD_ROUTES.csv");
    private static readonly string B54ActorsCsv = Path.Combine(BasePath, @"reports\battle\BATTLE_54_VALIDATE_ROUTE_ACTIVE_SIBLING_MASK_TMP_SCALE_AUTOSIZE_ACTOR_PAYLOAD_ACTORS.csv");
    private static readonly string CapturePath = Path.Combine(BasePath, @"girlswar_battle_unity\Assets\RestoreCaptures\battle_actor\Battle51LuaBridgeRaycasterRegistrationCandidate_1920x1080.png");

    [MenuItem("GirlsWar/Battle/BATTLE55 Validate Canvas Zero Scale Actor Visibility")]
    public static void Build()
    {
        Directory.CreateDirectory(ProjectPath("Assets/RestoreData/battle"));
        var summary = new Summary();
        summary.prefix = Prefix;
        summary.scene = ScenePath;
        summary.isFinalRestoredBattleScreen = false;
        summary.patchDecision = "blocked_no_patch";
        summary.referenceVideoAvailable = File.Exists(@"C:\Users\godho\Downloads\플레이.mp4");
        summary.auxiliaryReferenceVideoAvailable = File.Exists(@"C:\Users\godho\Downloads\참고.mp4");

        if (!File.Exists(ProjectPath(ScenePath)))
        {
            summary.failReason = "scene_file_not_found";
            WriteSummary(ProjectPath(SummaryPath), summary);
            WriteCsv(ProjectPath(ZeroScalePath), new List<Dictionary<string, string>>(), ZeroHeaders());
            WriteCsv(ProjectPath(ActorsPath), new List<Dictionary<string, string>>(), ActorHeaders());
            WriteCsv(ProjectPath(CamerasPath), new List<Dictionary<string, string>>(), CameraHeaders());
            WriteCsv(ProjectPath(RenderersPath), new List<Dictionary<string, string>>(), RendererHeaders());
            return;
        }

        var scene = EditorSceneManager.OpenScene(ScenePath, OpenSceneMode.Single);
        summary.sceneOpened = scene.IsValid();
        Canvas.ForceUpdateCanvases();
        RenderAllEnabledCamerasOnce();
        Canvas.ForceUpdateCanvases();

        var cameraRows = ProbeCameras();
        var zeroRows = ProbeZeroScaleRoutes();
        var rendererRows = new List<Dictionary<string, string>>();
        var actorRows = ProbeActors(rendererRows);

        summary.zeroScaleRows = zeroRows.Count;
        summary.zeroScaleCanvasRows = CountRows(zeroRows, "isCanvas", "True");
        summary.zeroScaleCanvasWithDepthReadyGraphics = CountTrue(zeroRows, "hasDepthReadyDescendantGraphics");
        summary.zeroScaleRowsWithNonZeroScreenRect = CountTrue(zeroRows, "hasNonZeroScreenRect");
        summary.actorRows = actorRows.Count;
        summary.activeActorRows = CountRows(actorRows, "activeInHierarchy", "True");
        summary.actorRowsWithEnabledRenderer = CountGreater(actorRows, "enabledRendererCount", 0);
        summary.actorRowsWithCameraFrustumCandidate = CountTrue(actorRows, "hasCameraFrustumCandidate");
        summary.actorRowsWithCapturePixelSignal = CountTrue(actorRows, "captureViewportRectHasNonBackgroundSignal");
        summary.cameraRows = cameraRows.Count;
        summary.camerasIncludingActorLayer9 = CountTrue(cameraRows, "cullingIncludesLayer9");
        summary.rendererRows = rendererRows.Count;
        summary.sceneSaved = false;
        summary.failReason = "";
        summary.visual_status = "runtime_probe_complete_no_scene_patch";
        summary.nextBlocker = "USER_DECISION_OR_SOURCE_RUNTIME_REQUIRED_FOR_XLUA_GAMEENTRY_BOOTSTRAP_OR_ACTOR_RENDER_SOURCE_PATCH";

        WriteCsv(ProjectPath(ZeroScalePath), zeroRows, ZeroHeaders());
        WriteCsv(ProjectPath(ActorsPath), actorRows, ActorHeaders());
        WriteCsv(ProjectPath(CamerasPath), cameraRows, CameraHeaders());
        WriteCsv(ProjectPath(RenderersPath), rendererRows, RendererHeaders());
        WriteSummary(ProjectPath(SummaryPath), summary);
        AssetDatabase.Refresh();
        Debug.Log("BATTLE55 probe complete. zeroRows=" + zeroRows.Count + " actorRows=" + actorRows.Count + " cameras=" + cameraRows.Count);
    }

    private static List<Dictionary<string, string>> ProbeZeroScaleRoutes()
    {
        var inputs = LoadCsv(B54RoutesCsv);
        var rows = new List<Dictionary<string, string>>();
        foreach (var input in inputs)
        {
            var warning = Get(input, "warning");
            if (warning.IndexOf("active_route_has_zeroish_local_scale", StringComparison.OrdinalIgnoreCase) < 0)
                continue;
            var path = Get(input, "path");
            var t = FindTransform(path);
            var row = NewRow(ZeroHeaders());
            row["path"] = path;
            row["b54LocalScale"] = Get(input, "localScale");
            row["b54Warning"] = warning;
            row["found"] = Bool(t != null);
            if (t != null)
            {
                row["name"] = t.name;
                row["activeSelf"] = Bool(t.gameObject.activeSelf);
                row["activeInHierarchy"] = Bool(t.gameObject.activeInHierarchy);
                row["layer"] = t.gameObject.layer.ToString(CultureInfo.InvariantCulture);
                row["localScale"] = Vec(t.localScale);
                row["lossyScale"] = Vec(t.lossyScale);
                row["componentTypes"] = ComponentTypes(t.gameObject);
                var canvas = t.GetComponent<Canvas>();
                row["isCanvas"] = Bool(canvas != null);
                if (canvas != null)
                {
                    row["canvasEnabled"] = Bool(canvas.enabled);
                    row["canvasRenderMode"] = canvas.renderMode.ToString();
                    row["canvasSortingLayerID"] = canvas.sortingLayerID.ToString(CultureInfo.InvariantCulture);
                    row["canvasSortingOrder"] = canvas.sortingOrder.ToString(CultureInfo.InvariantCulture);
                    row["canvasScaleFactor"] = canvas.scaleFactor.ToString(CultureInfo.InvariantCulture);
                    row["canvasReferencePixelsPerUnit"] = canvas.referencePixelsPerUnit.ToString(CultureInfo.InvariantCulture);
                    row["canvasPixelRect"] = RectText(canvas.pixelRect);
                    row["worldCamera"] = canvas.worldCamera != null ? HierarchyPath(canvas.worldCamera.transform) : "";
                }
                var rect = t as RectTransform;
                if (rect != null)
                {
                    FillRectScreen(row, rect, canvas != null ? canvas.worldCamera : FindCaptureCamera(), "");
                }
                var graphics = t.GetComponentsInChildren<Graphic>(true);
                int activeGraphics = 0;
                int depthReady = 0;
                int raycastTargets = 0;
                int culled = 0;
                foreach (var g in graphics)
                {
                    if (g == null) continue;
                    if (g.gameObject.activeInHierarchy && g.enabled) activeGraphics++;
                    if (g.depth >= 0) depthReady++;
                    if (g.raycastTarget) raycastTargets++;
                    if (g.canvasRenderer != null && g.canvasRenderer.cull) culled++;
                }
                row["descendantGraphicCount"] = graphics.Length.ToString(CultureInfo.InvariantCulture);
                row["activeEnabledGraphicCount"] = activeGraphics.ToString(CultureInfo.InvariantCulture);
                row["depthReadyGraphicCount"] = depthReady.ToString(CultureInfo.InvariantCulture);
                row["raycastTargetGraphicCount"] = raycastTargets.ToString(CultureInfo.InvariantCulture);
                row["canvasRendererCullCount"] = culled.ToString(CultureInfo.InvariantCulture);
                row["hasDepthReadyDescendantGraphics"] = Bool(depthReady > 0);
                row["descendantButtonCount"] = t.GetComponentsInChildren<Button>(true).Length.ToString(CultureInfo.InvariantCulture);
                row["descendantRendererCount"] = t.GetComponentsInChildren<Renderer>(true).Length.ToString(CultureInfo.InvariantCulture);
                row["runtimeInterpretation"] = InterpretZeroScale(row);
            }
            rows.Add(row);
        }
        return rows;
    }

    private static List<Dictionary<string, string>> ProbeActors(List<Dictionary<string, string>> rendererRows)
    {
        var inputs = LoadCsv(B54ActorsCsv);
        var rows = new List<Dictionary<string, string>>();
        var capture = LoadTexture(CapturePath);
        foreach (var input in inputs)
        {
            if (!StringEquals(Get(input, "sourceKind"), "active_runtime_actor_candidate"))
                continue;
            var path = Get(input, "path");
            var t = FindTransform(path);
            var row = NewRow(ActorHeaders());
            row["path"] = path;
            row["name"] = Get(input, "name");
            row["payloadHeroDid"] = Get(input, "payloadHeroDid");
            row["payloadLocalStatus"] = Get(input, "payloadLocalStatus");
            row["payloadModelId"] = Get(input, "payloadModelId");
            row["payloadActorBundle"] = Get(input, "payloadActorBundle");
            row["found"] = Bool(t != null);
            if (t != null)
            {
                row["activeSelf"] = Bool(t.gameObject.activeSelf);
                row["activeInHierarchy"] = Bool(t.gameObject.activeInHierarchy);
                row["layer"] = t.gameObject.layer.ToString(CultureInfo.InvariantCulture);
                row["localPosition"] = Vec(t.localPosition);
                row["worldPosition"] = Vec(t.position);
                row["localScale"] = Vec(t.localScale);
                row["lossyScale"] = Vec(t.lossyScale);
                row["siblingIndex"] = t.GetSiblingIndex().ToString(CultureInfo.InvariantCulture);
                row["parentPath"] = t.parent != null ? HierarchyPath(t.parent) : "";
                var renderers = t.GetComponentsInChildren<Renderer>(true);
                int enabled = 0;
                int activeEnabled = 0;
                int materialCount = 0;
                int meshCount = 0;
                int shaderMissing = 0;
                string firstShader = "";
                string firstQueue = "";
                Bounds? aggregate = null;
                foreach (var r in renderers)
                {
                    if (r == null) continue;
                    if (r.enabled) enabled++;
                    if (r.enabled && r.gameObject.activeInHierarchy) activeEnabled++;
                    if (aggregate.HasValue) { var b = aggregate.Value; b.Encapsulate(r.bounds); aggregate = b; } else aggregate = r.bounds;
                    var mats = r.sharedMaterials;
                    materialCount += mats != null ? mats.Length : 0;
                    if (mats != null)
                    {
                        foreach (var m in mats)
                        {
                            if (m == null || m.shader == null) { shaderMissing++; continue; }
                            if (firstShader.Length == 0) firstShader = m.shader.name;
                            if (firstQueue.Length == 0) firstQueue = m.renderQueue.ToString(CultureInfo.InvariantCulture);
                        }
                    }
                    var mf = r.GetComponent<MeshFilter>();
                    if (mf != null && mf.sharedMesh != null) meshCount++;
                    rendererRows.Add(RendererRow(path, r));
                }
                row["rendererCount"] = renderers.Length.ToString(CultureInfo.InvariantCulture);
                row["enabledRendererCount"] = enabled.ToString(CultureInfo.InvariantCulture);
                row["activeEnabledRendererCount"] = activeEnabled.ToString(CultureInfo.InvariantCulture);
                row["meshFilterWithMeshCount"] = meshCount.ToString(CultureInfo.InvariantCulture);
                row["materialSlotCount"] = materialCount.ToString(CultureInfo.InvariantCulture);
                row["missingShaderOrMaterialCount"] = shaderMissing.ToString(CultureInfo.InvariantCulture);
                row["firstShader"] = firstShader;
                row["firstRenderQueue"] = firstQueue;
                if (aggregate.HasValue)
                {
                    var b = aggregate.Value;
                    row["boundsCenter"] = Vec(b.center);
                    row["boundsSize"] = Vec(b.size);
                    FillBestCameraForBounds(row, b, capture);
                }
                row["visibilityBlocker"] = InterpretActor(row);
            }
            rows.Add(row);
        }
        if (capture != null) UnityEngine.Object.DestroyImmediate(capture);
        return rows;
    }

    private static Dictionary<string, string> RendererRow(string actorPath, Renderer r)
    {
        var row = NewRow(RendererHeaders());
        row["actorPath"] = actorPath;
        row["rendererPath"] = HierarchyPath(r.transform);
        row["rendererType"] = r.GetType().Name;
        row["activeInHierarchy"] = Bool(r.gameObject.activeInHierarchy);
        row["enabled"] = Bool(r.enabled);
        row["layer"] = r.gameObject.layer.ToString(CultureInfo.InvariantCulture);
        row["sortingLayerID"] = r.sortingLayerID.ToString(CultureInfo.InvariantCulture);
        row["sortingOrder"] = r.sortingOrder.ToString(CultureInfo.InvariantCulture);
        row["boundsCenter"] = Vec(r.bounds.center);
        row["boundsSize"] = Vec(r.bounds.size);
        var mf = r.GetComponent<MeshFilter>();
        row["meshName"] = mf != null && mf.sharedMesh != null ? mf.sharedMesh.name : "";
        row["meshVertexCount"] = mf != null && mf.sharedMesh != null ? mf.sharedMesh.vertexCount.ToString(CultureInfo.InvariantCulture) : "0";
        var mat = r.sharedMaterial;
        row["materialName"] = mat != null ? mat.name : "";
        row["shaderName"] = mat != null && mat.shader != null ? mat.shader.name : "";
        row["renderQueue"] = mat != null ? mat.renderQueue.ToString(CultureInfo.InvariantCulture) : "";
        return row;
    }

    private static List<Dictionary<string, string>> ProbeCameras()
    {
        var rows = new List<Dictionary<string, string>>();
        foreach (var cam in UnityEngine.Object.FindObjectsOfType<Camera>(true))
        {
            if (cam == null) continue;
            var row = NewRow(CameraHeaders());
            row["path"] = HierarchyPath(cam.transform);
            row["name"] = cam.name;
            row["activeInHierarchy"] = Bool(cam.gameObject.activeInHierarchy);
            row["enabled"] = Bool(cam.enabled);
            row["layer"] = cam.gameObject.layer.ToString(CultureInfo.InvariantCulture);
            row["cullingMask"] = cam.cullingMask.ToString(CultureInfo.InvariantCulture);
            row["cullingIncludesLayer9"] = Bool((cam.cullingMask & (1 << 9)) != 0);
            row["cullingIncludesUILayer5"] = Bool((cam.cullingMask & (1 << 5)) != 0);
            row["depth"] = cam.depth.ToString(CultureInfo.InvariantCulture);
            row["targetDisplay"] = cam.targetDisplay.ToString(CultureInfo.InvariantCulture);
            row["pixelRect"] = RectText(cam.pixelRect);
            row["orthographic"] = Bool(cam.orthographic);
            row["orthographicSize"] = cam.orthographicSize.ToString(CultureInfo.InvariantCulture);
            row["fieldOfView"] = cam.fieldOfView.ToString(CultureInfo.InvariantCulture);
            row["nearClipPlane"] = cam.nearClipPlane.ToString(CultureInfo.InvariantCulture);
            row["farClipPlane"] = cam.farClipPlane.ToString(CultureInfo.InvariantCulture);
            row["position"] = Vec(cam.transform.position);
            row["rotationEuler"] = Vec(cam.transform.rotation.eulerAngles);
            row["clearFlags"] = cam.clearFlags.ToString();
            row["targetTexture"] = cam.targetTexture != null ? cam.targetTexture.name : "";
            rows.Add(row);
        }
        return rows;
    }

    private static void FillBestCameraForBounds(Dictionary<string, string> row, Bounds bounds, Texture2D capture)
    {
        Camera best = null;
        Rect bestViewport = new Rect();
        Rect bestCapture = new Rect();
        float bestArea = -1f;
        bool anyLayer = false;
        bool anyFrustum = false;
        foreach (var cam in UnityEngine.Object.FindObjectsOfType<Camera>(true))
        {
            if (cam == null || !cam.enabled || !cam.gameObject.activeInHierarchy) continue;
            if ((cam.cullingMask & (1 << Int(row["layer"]))) == 0) continue;
            anyLayer = true;
            var planes = GeometryUtility.CalculateFrustumPlanes(cam);
            bool intersects = GeometryUtility.TestPlanesAABB(planes, bounds);
            if (intersects) anyFrustum = true;
            var viewport = ViewportRect(cam, bounds);
            float area = Mathf.Max(0, viewport.width) * Mathf.Max(0, viewport.height);
            if (intersects && area > bestArea)
            {
                best = cam;
                bestViewport = viewport;
                bestArea = area;
            }
        }
        row["hasCameraIncludingActorLayer"] = Bool(anyLayer);
        row["hasCameraFrustumCandidate"] = Bool(anyFrustum);
        if (best != null)
        {
            row["bestCamera"] = HierarchyPath(best.transform);
            row["bestCameraPixelRect"] = RectText(best.pixelRect);
            row["viewportRect"] = RectText(bestViewport);
            row["viewportRectIntersectsScreen"] = Bool(bestViewport.xMax >= 0 && bestViewport.yMax >= 0 && bestViewport.xMin <= 1 && bestViewport.yMin <= 1);
            if (capture != null)
            {
                bestCapture = new Rect(
                    bestViewport.xMin * capture.width,
                    bestViewport.yMin * capture.height,
                    bestViewport.width * capture.width,
                    bestViewport.height * capture.height
                );
                row["captureSampleRect"] = RectText(bestCapture);
                float ratio = bestCapture.width > 2f && bestCapture.height > 2f ? NonBackgroundRatio(capture, bestCapture) : 0f;
                row["captureViewportRectNonBackgroundRatio"] = ratio.ToString(CultureInfo.InvariantCulture);
                row["captureViewportRectHasNonBackgroundSignal"] = Bool(ratio > 0.02f);
            }
        }
    }

    private static Rect ViewportRect(Camera cam, Bounds bounds)
    {
        var corners = BoundsCorners(bounds);
        float minX = 999f, minY = 999f, maxX = -999f, maxY = -999f;
        foreach (var c in corners)
        {
            var v = cam.WorldToViewportPoint(c);
            minX = Mathf.Min(minX, v.x);
            minY = Mathf.Min(minY, v.y);
            maxX = Mathf.Max(maxX, v.x);
            maxY = Mathf.Max(maxY, v.y);
        }
        return Rect.MinMaxRect(minX, minY, maxX, maxY);
    }

    private static Vector3[] BoundsCorners(Bounds b)
    {
        var c = b.center;
        var e = b.extents;
        return new[]
        {
            c + new Vector3(-e.x, -e.y, -e.z), c + new Vector3(e.x, -e.y, -e.z),
            c + new Vector3(-e.x, e.y, -e.z), c + new Vector3(e.x, e.y, -e.z),
            c + new Vector3(-e.x, -e.y, e.z), c + new Vector3(e.x, -e.y, e.z),
            c + new Vector3(-e.x, e.y, e.z), c + new Vector3(e.x, e.y, e.z)
        };
    }

    private static void FillRectScreen(Dictionary<string, string> row, RectTransform rect, Camera cam, string prefix)
    {
        var corners = new Vector3[4];
        rect.GetWorldCorners(corners);
        var screen = new Vector3[4];
        for (int i = 0; i < 4; i++) screen[i] = RectTransformUtility.WorldToScreenPoint(cam, corners[i]);
        float minX = Mathf.Min(screen[0].x, screen[1].x, screen[2].x, screen[3].x);
        float maxX = Mathf.Max(screen[0].x, screen[1].x, screen[2].x, screen[3].x);
        float minY = Mathf.Min(screen[0].y, screen[1].y, screen[2].y, screen[3].y);
        float maxY = Mathf.Max(screen[0].y, screen[1].y, screen[2].y, screen[3].y);
        row[prefix + "screenRect"] = RectText(Rect.MinMaxRect(minX, minY, maxX, maxY));
        row[prefix + "hasNonZeroScreenRect"] = Bool((maxX - minX) > 0.01f && (maxY - minY) > 0.01f);
    }

    private static string InterpretZeroScale(Dictionary<string, string> row)
    {
        if (row["found"] != "True") return "route_not_found_in_scene";
        if (row["isCanvas"] == "True" && row["canvasRenderMode"] == "ScreenSpaceCamera" && row["hasDepthReadyDescendantGraphics"] == "True")
            return "zero_local_scale_canvas_but_screen_space_canvas_has_registered_depth_ready_descendant_graphics";
        if (row["hasNonZeroScreenRect"] == "False" && row["descendantGraphicCount"] != "0")
            return "zero_scale_collapses_rect_transform_screen_rect_for_this_route";
        return "zero_scale_runtime_effect_requires_visual_comparison_no_patch";
    }

    private static string InterpretActor(Dictionary<string, string> row)
    {
        if (row["found"] != "True") return "actor_transform_not_found";
        if (row["activeInHierarchy"] != "True") return "actor_inactive";
        if (Int(row["enabledRendererCount"]) == 0) return "no_enabled_renderer";
        if (Int(row["meshFilterWithMeshCount"]) == 0) return "no_mesh_filter_mesh";
        if (Int(row["materialSlotCount"]) == 0) return "no_material_slots";
        if (row["hasCameraIncludingActorLayer"] != "True") return "no_enabled_camera_culls_actor_layer";
        if (row["hasCameraFrustumCandidate"] != "True") return "actor_bounds_outside_all_enabled_camera_frustums";
        if (row["viewportRectIntersectsScreen"] != "True") return "actor_viewport_rect_offscreen";
        return "render_path_candidate_exists_visibility_mismatch_likely_material_shader_depth_or_capture_composition";
    }

    private static void RenderAllEnabledCamerasOnce()
    {
        foreach (var cam in UnityEngine.Object.FindObjectsOfType<Camera>(true))
        {
            if (cam == null || !cam.enabled || !cam.gameObject.activeInHierarchy) continue;
            var rt = new RenderTexture(64, 64, 16, RenderTextureFormat.ARGB32);
            var previous = cam.targetTexture;
            var active = RenderTexture.active;
            cam.targetTexture = rt;
            RenderTexture.active = rt;
            try { cam.Render(); } catch { }
            cam.targetTexture = previous;
            RenderTexture.active = active;
            rt.Release();
            UnityEngine.Object.DestroyImmediate(rt);
        }
    }

    private static Texture2D LoadTexture(string path)
    {
        if (!File.Exists(path)) return null;
        var bytes = File.ReadAllBytes(path);
        var tex = new Texture2D(2, 2, TextureFormat.RGBA32, false);
        return tex.LoadImage(bytes) ? tex : null;
    }

    private static float NonBackgroundRatio(Texture2D tex, Rect rect)
    {
        int minX = Mathf.Clamp(Mathf.FloorToInt(rect.xMin), 0, tex.width - 1);
        int maxX = Mathf.Clamp(Mathf.CeilToInt(rect.xMax), 0, tex.width - 1);
        int minY = Mathf.Clamp(Mathf.FloorToInt(rect.yMin), 0, tex.height - 1);
        int maxY = Mathf.Clamp(Mathf.CeilToInt(rect.yMax), 0, tex.height - 1);
        if (maxX <= minX || maxY <= minY) return 0f;
        int total = 0;
        int signal = 0;
        int stepX = Mathf.Max(1, (maxX - minX) / 64);
        int stepY = Mathf.Max(1, (maxY - minY) / 64);
        for (int y = minY; y <= maxY; y += stepY)
        {
            for (int x = minX; x <= maxX; x += stepX)
            {
                var c = tex.GetPixel(x, y);
                total++;
                if (c.r + c.g + c.b > 0.08f) signal++;
            }
        }
        return total > 0 ? (float)signal / total : 0f;
    }

    private static Camera FindCaptureCamera()
    {
        foreach (var cam in UnityEngine.Object.FindObjectsOfType<Camera>(true))
            if (cam.name.IndexOf("BattleHudSpriteAtlasTextureRuntimeBindingClip05Camera", StringComparison.OrdinalIgnoreCase) >= 0) return cam;
        foreach (var cam in UnityEngine.Object.FindObjectsOfType<Camera>(true))
            if (cam.enabled && cam.gameObject.activeInHierarchy) return cam;
        return null;
    }

    private static Transform FindTransform(string path)
    {
        if (string.IsNullOrEmpty(path)) return null;
        foreach (var t in UnityEngine.Object.FindObjectsOfType<Transform>(true))
            if (HierarchyPath(t) == path) return t;
        return null;
    }

    private static string HierarchyPath(Transform transform)
    {
        if (transform == null) return "";
        var names = new List<string>();
        var t = transform;
        while (t != null)
        {
            names.Add(t.name);
            t = t.parent;
        }
        names.Reverse();
        return string.Join("/", names.ToArray());
    }

    private static List<Dictionary<string, string>> LoadCsv(string path)
    {
        var rows = new List<Dictionary<string, string>>();
        if (!File.Exists(path)) return rows;
        var lines = File.ReadAllLines(path, Encoding.UTF8);
        if (lines.Length == 0) return rows;
        var header = ParseCsvLine(lines[0]);
        for (int i = 1; i < lines.Length; i++)
        {
            if (string.IsNullOrWhiteSpace(lines[i])) continue;
            var cells = ParseCsvLine(lines[i]);
            var row = new Dictionary<string, string>();
            for (int c = 0; c < header.Count; c++)
                row[header[c]] = c < cells.Count ? cells[c] : "";
            rows.Add(row);
        }
        return rows;
    }

    private static List<string> ParseCsvLine(string line)
    {
        var cells = new List<string>();
        var sb = new StringBuilder();
        bool quote = false;
        for (int i = 0; i < line.Length; i++)
        {
            char ch = line[i];
            if (ch == '"')
            {
                if (quote && i + 1 < line.Length && line[i + 1] == '"') { sb.Append('"'); i++; }
                else quote = !quote;
            }
            else if (ch == ',' && !quote)
            {
                cells.Add(sb.ToString());
                sb.Length = 0;
            }
            else sb.Append(ch);
        }
        cells.Add(sb.ToString());
        return cells;
    }

    private static void WriteCsv(string path, List<Dictionary<string, string>> rows, string[] headers)
    {
        Directory.CreateDirectory(Path.GetDirectoryName(path));
        var sb = new StringBuilder();
        sb.AppendLine(string.Join(",", headers));
        foreach (var row in rows)
        {
            for (int i = 0; i < headers.Length; i++)
            {
                if (i > 0) sb.Append(",");
                sb.Append(Csv(Get(row, headers[i])));
            }
            sb.AppendLine();
        }
        File.WriteAllText(path, sb.ToString(), new UTF8Encoding(true));
    }

    private static string Csv(string value)
    {
        value = value ?? "";
        if (value.IndexOfAny(new[] { ',', '"', '\n', '\r' }) >= 0)
            return "\"" + value.Replace("\"", "\"\"") + "\"";
        return value;
    }

    private static void WriteSummary(string path, Summary s)
    {
        Directory.CreateDirectory(Path.GetDirectoryName(path));
        var json = "{\n"
            + Json("prefix", s.prefix) + ",\n"
            + Json("scene", s.scene) + ",\n"
            + Json("sceneOpened", s.sceneOpened) + ",\n"
            + Json("visual_status", s.visual_status) + ",\n"
            + Json("isFinalRestoredBattleScreen", s.isFinalRestoredBattleScreen) + ",\n"
            + Json("patchDecision", s.patchDecision) + ",\n"
            + Json("sceneSaved", s.sceneSaved) + ",\n"
            + Json("zeroScaleRows", s.zeroScaleRows) + ",\n"
            + Json("zeroScaleCanvasRows", s.zeroScaleCanvasRows) + ",\n"
            + Json("zeroScaleCanvasWithDepthReadyGraphics", s.zeroScaleCanvasWithDepthReadyGraphics) + ",\n"
            + Json("zeroScaleRowsWithNonZeroScreenRect", s.zeroScaleRowsWithNonZeroScreenRect) + ",\n"
            + Json("actorRows", s.actorRows) + ",\n"
            + Json("activeActorRows", s.activeActorRows) + ",\n"
            + Json("actorRowsWithEnabledRenderer", s.actorRowsWithEnabledRenderer) + ",\n"
            + Json("actorRowsWithCameraFrustumCandidate", s.actorRowsWithCameraFrustumCandidate) + ",\n"
            + Json("actorRowsWithCapturePixelSignal", s.actorRowsWithCapturePixelSignal) + ",\n"
            + Json("cameraRows", s.cameraRows) + ",\n"
            + Json("camerasIncludingActorLayer9", s.camerasIncludingActorLayer9) + ",\n"
            + Json("rendererRows", s.rendererRows) + ",\n"
            + Json("referenceVideoAvailable", s.referenceVideoAvailable) + ",\n"
            + Json("auxiliaryReferenceVideoAvailable", s.auxiliaryReferenceVideoAvailable) + ",\n"
            + Json("nextBlocker", s.nextBlocker) + ",\n"
            + Json("failReason", s.failReason) + "\n"
            + "}\n";
        File.WriteAllText(path, json, Encoding.UTF8);
    }

    private static string Json(string key, string value) { return "  \"" + key + "\": \"" + Escape(value) + "\""; }
    private static string Json(string key, bool value) { return "  \"" + key + "\": " + (value ? "true" : "false"); }
    private static string Json(string key, int value) { return "  \"" + key + "\": " + value.ToString(CultureInfo.InvariantCulture); }
    private static string Escape(string v) { return (v ?? "").Replace("\\", "\\\\").Replace("\"", "\\\""); }

    private static Dictionary<string, string> NewRow(string[] headers)
    {
        var row = new Dictionary<string, string>();
        foreach (var h in headers) row[h] = "";
        return row;
    }

    private static string Get(Dictionary<string, string> row, string key) { return row != null && row.ContainsKey(key) ? row[key] ?? "" : ""; }
    private static bool StringEquals(string a, string b) { return string.Equals(a, b, StringComparison.OrdinalIgnoreCase); }
    private static string Bool(bool v) { return v ? "True" : "False"; }
    private static int Int(string v) { int x; return int.TryParse(v, NumberStyles.Any, CultureInfo.InvariantCulture, out x) ? x : 0; }
    private static int CountRows(List<Dictionary<string, string>> rows, string key, string value) { int n = 0; foreach (var r in rows) if (Get(r, key) == value) n++; return n; }
    private static int CountTrue(List<Dictionary<string, string>> rows, string key) { return CountRows(rows, key, "True"); }
    private static int CountGreater(List<Dictionary<string, string>> rows, string key, int min) { int n = 0; foreach (var r in rows) if (Int(Get(r, key)) > min) n++; return n; }
    private static string Vec(Vector3 v) { return v.x.ToString(CultureInfo.InvariantCulture) + "/" + v.y.ToString(CultureInfo.InvariantCulture) + "/" + v.z.ToString(CultureInfo.InvariantCulture); }
    private static string RectText(Rect r) { return r.x.ToString(CultureInfo.InvariantCulture) + "/" + r.y.ToString(CultureInfo.InvariantCulture) + "/" + r.width.ToString(CultureInfo.InvariantCulture) + "/" + r.height.ToString(CultureInfo.InvariantCulture); }
    private static string ComponentTypes(GameObject go)
    {
        var comps = go.GetComponents<Component>();
        var names = new List<string>();
        foreach (var c in comps) names.Add(c == null ? "<missing>" : c.GetType().FullName);
        return string.Join("|", names.ToArray());
    }
    private static string ProjectPath(string assetPath) { return Path.Combine(Application.dataPath, "..", assetPath.Replace("/", "\\")); }

    private static string[] ZeroHeaders()
    {
        return new[] { "path", "name", "found", "activeSelf", "activeInHierarchy", "layer", "b54LocalScale", "localScale", "lossyScale", "componentTypes", "b54Warning", "isCanvas", "canvasEnabled", "canvasRenderMode", "canvasSortingLayerID", "canvasSortingOrder", "canvasScaleFactor", "canvasReferencePixelsPerUnit", "canvasPixelRect", "worldCamera", "screenRect", "hasNonZeroScreenRect", "descendantGraphicCount", "activeEnabledGraphicCount", "depthReadyGraphicCount", "raycastTargetGraphicCount", "canvasRendererCullCount", "hasDepthReadyDescendantGraphics", "descendantButtonCount", "descendantRendererCount", "runtimeInterpretation" };
    }

    private static string[] ActorHeaders()
    {
        return new[] { "path", "name", "found", "activeSelf", "activeInHierarchy", "layer", "payloadHeroDid", "payloadLocalStatus", "payloadModelId", "payloadActorBundle", "parentPath", "siblingIndex", "localPosition", "worldPosition", "localScale", "lossyScale", "rendererCount", "enabledRendererCount", "activeEnabledRendererCount", "meshFilterWithMeshCount", "materialSlotCount", "missingShaderOrMaterialCount", "firstShader", "firstRenderQueue", "boundsCenter", "boundsSize", "hasCameraIncludingActorLayer", "hasCameraFrustumCandidate", "bestCamera", "bestCameraPixelRect", "viewportRect", "viewportRectIntersectsScreen", "captureSampleRect", "captureViewportRectNonBackgroundRatio", "captureViewportRectHasNonBackgroundSignal", "visibilityBlocker" };
    }

    private static string[] CameraHeaders()
    {
        return new[] { "path", "name", "activeInHierarchy", "enabled", "layer", "cullingMask", "cullingIncludesLayer9", "cullingIncludesUILayer5", "depth", "targetDisplay", "pixelRect", "orthographic", "orthographicSize", "fieldOfView", "nearClipPlane", "farClipPlane", "position", "rotationEuler", "clearFlags", "targetTexture" };
    }

    private static string[] RendererHeaders()
    {
        return new[] { "actorPath", "rendererPath", "rendererType", "activeInHierarchy", "enabled", "layer", "sortingLayerID", "sortingOrder", "boundsCenter", "boundsSize", "meshName", "meshVertexCount", "materialName", "shaderName", "renderQueue" };
    }

    [Serializable]
    private class Summary
    {
        public string prefix;
        public string scene;
        public bool sceneOpened;
        public string visual_status;
        public bool isFinalRestoredBattleScreen;
        public string patchDecision;
        public bool sceneSaved;
        public int zeroScaleRows;
        public int zeroScaleCanvasRows;
        public int zeroScaleCanvasWithDepthReadyGraphics;
        public int zeroScaleRowsWithNonZeroScreenRect;
        public int actorRows;
        public int activeActorRows;
        public int actorRowsWithEnabledRenderer;
        public int actorRowsWithCameraFrustumCandidate;
        public int actorRowsWithCapturePixelSignal;
        public int cameraRows;
        public int camerasIncludingActorLayer9;
        public int rendererRows;
        public bool referenceVideoAvailable;
        public bool auxiliaryReferenceVideoAvailable;
        public string nextBlocker;
        public string failReason;
    }
}
