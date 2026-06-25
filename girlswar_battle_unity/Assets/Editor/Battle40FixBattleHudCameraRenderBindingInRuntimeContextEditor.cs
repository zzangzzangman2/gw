using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using TMPro;
using System;
using System.Collections.Generic;
using System.IO;
using System.Reflection;
using System.Text;

public static class Battle40FixBattleHudCameraRenderBindingInRuntimeContextEditor
{
    private const string BaseScenePath = "Assets/Scenes/Battle39RuntimeActorsMap11003HudContextCandidate.unity";
    private const string ScenePath = "Assets/Scenes/Battle40HudCameraRenderBindingRuntimeContext.unity";
    private const string ResultJsonPath = "Assets/RestoreData/battle/BATTLE_40_FIX_BATTLE_HUD_CAMERA_RENDER_BINDING_IN_RUNTIME_CONTEXT_UNITY.json";
    private const string ComponentsCsvPath = "Assets/RestoreData/battle/BATTLE_40_FIX_BATTLE_HUD_CAMERA_RENDER_BINDING_IN_RUNTIME_CONTEXT_COMPONENTS.csv";
    private const string CanvasCsvPath = "Assets/RestoreData/battle/BATTLE_40_FIX_BATTLE_HUD_CAMERA_RENDER_BINDING_IN_RUNTIME_CONTEXT_CANVAS_DIFF.csv";
    private const string ActorBoundsCsvPath = "Assets/RestoreData/battle/BATTLE_40_FIX_BATTLE_HUD_CAMERA_RENDER_BINDING_IN_RUNTIME_CONTEXT_ACTOR_BOUNDS.csv";
    private const string CapturePath = "Assets/RestoreCaptures/battle_actor/Battle40HudCameraRenderBindingRuntimeContext_1920x1080.png";
    private const string SequenceDir = "Assets/RestoreCaptures/battle_actor/battle40_sequence";
    private const string MergedExtractedRoot = @"C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted";
    private const string SpriteIndexPath = @"C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\indexes\unity_images.csv";
    private const int CaptureWidth = 1920;
    private const int CaptureHeight = 1080;

    [MenuItem("GirlsWar/Battle/BATTLE40 Fix Battle HUD Camera Render Binding In Runtime Context")]
    public static void Build()
    {
        Directory.CreateDirectory(ProjectPath("Assets/RestoreData/battle"));
        Directory.CreateDirectory(ProjectPath("Assets/Scenes"));
        Directory.CreateDirectory(ProjectPath("Assets/RestoreCaptures/battle_actor"));
        Directory.CreateDirectory(ProjectPath(SequenceDir));

        var result = new Battle40Result();
        result.baseScene = BaseScenePath;
        result.scene = ScenePath;
        result.capture = CapturePath;
        result.baseSceneExists = File.Exists(ProjectPath(BaseScenePath));
        Scene scene = result.baseSceneExists
            ? EditorSceneManager.OpenScene(BaseScenePath, OpenSceneMode.Single)
            : EditorSceneManager.NewScene(NewSceneSetup.EmptyScene, NewSceneMode.Single);

        var camera = FindCaptureCamera();
        result.cameraFound = camera != null;
        if (camera == null) camera = CreateFallbackCamera();
        ConfigureCaptureCamera(camera, result);

        var hudRoot = FindByNameContains("BattleHudSpriteAtlasTextureRuntimeBindingClip05Root");
        result.hudRootFound = hudRoot != null;
        var heroContainer = FindByNameContains("HeroListContainer");
        result.heroListContainerFound = heroContainer != null;

        var beforeCanvases = SnapshotCanvases("before", camera);
        var beforeComponents = SnapshotComponents("before");

        result.extractedSpriteBindCount = ApplyExtractedSpriteBindings(hudRoot != null ? hudRoot : null);
        var canvasFixes = ApplyCanvasCameraBindingFix(camera, hudRoot);

        Canvas.ForceUpdateCanvases();
        var afterCanvases = SnapshotCanvases("after", camera);
        var afterComponents = SnapshotComponents("after");

        var actorRows = new List<Battle40ActorBoundsRow>();
        for (int i = 0; i < 6; i++)
        {
            StepRuntimeActors(1f / 15f);
            actorRows.AddRange(SnapshotActorBounds(camera, i));
            Capture(camera, ProjectPath(SequenceDir + "/Battle40RuntimeContext_" + i.ToString("00") + "_1920x1080.png"));
        }
        Capture(camera, ProjectPath(CapturePath));

        result.canvasFixCount = canvasFixes.Count;
        result.canvasFixes = canvasFixes;
        result.beforeCanvasCount = beforeCanvases.Count;
        result.afterCanvasCount = afterCanvases.Count;
        result.beforeGraphicCount = CountGraphics(beforeComponents);
        result.afterGraphicCount = CountGraphics(afterComponents);
        result.beforeImageCount = CountType(beforeComponents, "Image");
        result.afterImageCount = CountType(afterComponents, "Image");
        result.beforeImageWithSpriteCount = Count(beforeComponents, c => c.componentType == "Image" && !string.IsNullOrEmpty(c.spriteName));
        result.afterImageWithSpriteCount = Count(afterComponents, c => c.componentType == "Image" && !string.IsNullOrEmpty(c.spriteName));
        result.beforeImageWithTextureCount = Count(beforeComponents, c => c.componentType == "Image" && !string.IsNullOrEmpty(c.textureName));
        result.afterImageWithTextureCount = Count(afterComponents, c => c.componentType == "Image" && !string.IsNullOrEmpty(c.textureName));
        result.afterActiveGraphicCount = Count(afterComponents, c => c.activeInHierarchy && c.enabled);
        result.captureExists = File.Exists(ProjectPath(CapturePath));

        WriteCanvasCsv(ProjectPath(CanvasCsvPath), beforeCanvases, afterCanvases, canvasFixes);
        WriteComponentsCsv(ProjectPath(ComponentsCsvPath), afterComponents);
        WriteActorBoundsCsv(ProjectPath(ActorBoundsCsvPath), actorRows);
        WriteJson(ProjectPath(ResultJsonPath), result);
        EditorSceneManager.SaveScene(scene, ScenePath);
        AssetDatabase.Refresh();
        Debug.Log("BATTLE40 HUD camera render binding probe complete. canvasFixes=" + canvasFixes.Count + ", spriteBinds=" + result.extractedSpriteBindCount);
    }

    private static Camera FindCaptureCamera()
    {
        var named = GameObject.Find("BattleHudSpriteAtlasTextureRuntimeBindingClip05Camera");
        if (named != null)
        {
            var camera = named.GetComponent<Camera>();
            if (camera != null) return camera;
        }
        if (Camera.main != null) return Camera.main;
        var cameras = UnityEngine.Object.FindObjectsOfType<Camera>(true);
        return cameras != null && cameras.Length > 0 ? cameras[0] : null;
    }

    private static Camera CreateFallbackCamera()
    {
        var go = new GameObject("BATTLE40_FallbackCaptureCamera");
        var camera = go.AddComponent<Camera>();
        return camera;
    }

    private static void ConfigureCaptureCamera(Camera camera, Battle40Result result)
    {
        result.cameraBefore = CameraInfo(camera);
        camera.orthographic = true;
        camera.orthographicSize = 5f;
        camera.clearFlags = CameraClearFlags.SolidColor;
        camera.backgroundColor = Color.black;
        camera.nearClipPlane = 0.01f;
        camera.farClipPlane = 100f;
        camera.cullingMask = ~0;
        camera.depth = 1000f;
        camera.transform.position = new Vector3(0f, 0f, -10f);
        camera.transform.rotation = Quaternion.identity;
        result.cameraAfter = CameraInfo(camera);
    }

    private static List<Battle40CanvasRow> SnapshotCanvases(string phase, Camera camera)
    {
        var rows = new List<Battle40CanvasRow>();
        foreach (var canvas in UnityEngine.Object.FindObjectsOfType<Canvas>(true))
        {
            var row = new Battle40CanvasRow();
            row.phase = phase;
            row.path = HierarchyPath(canvas.transform);
            row.name = canvas.name;
            row.activeSelf = canvas.gameObject.activeSelf;
            row.activeInHierarchy = canvas.gameObject.activeInHierarchy;
            row.enabled = canvas.enabled;
            row.renderMode = canvas.renderMode.ToString();
            row.worldCameraName = canvas.worldCamera != null ? canvas.worldCamera.name : "";
            row.worldCameraMatchesCapture = canvas.worldCamera == camera;
            row.planeDistance = canvas.planeDistance;
            row.sortingLayerName = canvas.sortingLayerName;
            row.sortingOrder = canvas.sortingOrder;
            row.overrideSorting = canvas.overrideSorting;
            row.layer = LayerMask.LayerToName(canvas.gameObject.layer);
            var scaler = canvas.GetComponent<CanvasScaler>();
            if (scaler != null)
            {
                row.canvasScalerUiScaleMode = scaler.uiScaleMode.ToString();
                row.canvasScalerReferenceResolution = Vec2(scaler.referenceResolution);
                row.canvasScalerMatchWidthOrHeight = scaler.matchWidthOrHeight;
                row.canvasScalerScreenMatchMode = scaler.screenMatchMode.ToString();
            }
            var rect = canvas.transform as RectTransform;
            if (rect != null)
            {
                row.rectSize = Vec2(rect.rect.size);
                row.anchorMin = Vec2(rect.anchorMin);
                row.anchorMax = Vec2(rect.anchorMax);
                row.pivot = Vec2(rect.pivot);
                row.localScale = Vec3(rect.localScale);
            }
            rows.Add(row);
        }
        return rows;
    }

    private static List<Battle40ComponentRow> SnapshotComponents(string phase)
    {
        var rows = new List<Battle40ComponentRow>();
        foreach (var graphic in UnityEngine.Object.FindObjectsOfType<Graphic>(true))
        {
            var row = new Battle40ComponentRow();
            row.phase = phase;
            row.path = HierarchyPath(graphic.transform);
            row.name = graphic.name;
            row.componentType = graphic.GetType().Name;
            row.activeSelf = graphic.gameObject.activeSelf;
            row.activeInHierarchy = graphic.gameObject.activeInHierarchy;
            row.enabled = graphic.enabled;
            row.raycastTarget = graphic.raycastTarget;
            row.color = ColorString(graphic.color);
            row.materialName = graphic.material != null ? graphic.material.name : "";
            row.canvasPath = "";
            var canvas = graphic.GetComponentInParent<Canvas>(true);
            if (canvas != null)
            {
                row.canvasPath = HierarchyPath(canvas.transform);
                row.canvasRenderMode = canvas.renderMode.ToString();
                row.canvasWorldCameraName = canvas.worldCamera != null ? canvas.worldCamera.name : "";
                row.canvasSortingOrder = canvas.sortingOrder;
            }
            var image = graphic as Image;
            if (image != null)
            {
                row.spriteName = image.sprite != null ? image.sprite.name : "";
                row.textureName = image.sprite != null && image.sprite.texture != null ? image.sprite.texture.name : "";
                row.textureSize = image.sprite != null && image.sprite.texture != null ? image.sprite.texture.width + "x" + image.sprite.texture.height : "";
                row.imageType = image.type.ToString();
                row.preserveAspect = image.preserveAspect;
                row.fillAmount = image.fillAmount;
            }
            var text = graphic as Text;
            if (text != null)
            {
                row.textLength = text.text != null ? text.text.Length : 0;
                row.fontName = text.font != null ? text.font.name : "";
            }
            var tmp = graphic as TMP_Text;
            if (tmp != null)
            {
                row.textLength = tmp.text != null ? tmp.text.Length : 0;
                row.fontName = tmp.font != null ? tmp.font.name : "";
            }
            var rect = graphic.transform as RectTransform;
            if (rect != null)
            {
                row.rectSize = Vec2(rect.rect.size);
                row.anchoredPosition = Vec2(rect.anchoredPosition);
                row.anchorMin = Vec2(rect.anchorMin);
                row.anchorMax = Vec2(rect.anchorMax);
                row.localScale = Vec3(rect.localScale);
            }
            rows.Add(row);
        }
        return rows;
    }

    private static List<Battle40CanvasFix> ApplyCanvasCameraBindingFix(Camera camera, GameObject hudRoot)
    {
        var fixes = new List<Battle40CanvasFix>();
        if (camera == null) return fixes;
        foreach (var canvas in UnityEngine.Object.FindObjectsOfType<Canvas>(true))
        {
            bool isHudCanvas = hudRoot != null && IsChildOf(canvas.transform, hudRoot.transform);
            if (!isHudCanvas && canvas.name.IndexOf("Battle", StringComparison.OrdinalIgnoreCase) < 0 && canvas.name.IndexOf("ui_normalbattle", StringComparison.OrdinalIgnoreCase) < 0) continue;
            bool needsFix = canvas.renderMode == RenderMode.ScreenSpaceOverlay || canvas.worldCamera == null || canvas.worldCamera != camera;
            if (!needsFix) continue;
            var fix = new Battle40CanvasFix();
            fix.path = HierarchyPath(canvas.transform);
            fix.oldRenderMode = canvas.renderMode.ToString();
            fix.oldWorldCameraName = canvas.worldCamera != null ? canvas.worldCamera.name : "";
            fix.oldPlaneDistance = canvas.planeDistance;
            fix.oldSortingOrder = canvas.sortingOrder;
            fix.reason = "capture_camera_render_binding_fix_for_batchmode_camera_render; original RectTransform/CanvasScaler/sibling order preserved";

            canvas.renderMode = RenderMode.ScreenSpaceCamera;
            canvas.worldCamera = camera;
            if (canvas.planeDistance < 0.01f || canvas.planeDistance > 20f) canvas.planeDistance = 1f;

            fix.newRenderMode = canvas.renderMode.ToString();
            fix.newWorldCameraName = canvas.worldCamera != null ? canvas.worldCamera.name : "";
            fix.newPlaneDistance = canvas.planeDistance;
            fix.newSortingOrder = canvas.sortingOrder;
            fixes.Add(fix);
        }
        return fixes;
    }

    private static int ApplyExtractedSpriteBindings(GameObject root)
    {
        if (root == null) return 0;
        var index = LoadSpritePngIndex();
        if (index.Count == 0) return 0;
        var cache = new Dictionary<string, Texture2D>(StringComparer.OrdinalIgnoreCase);
        int count = 0;
        foreach (var image in root.GetComponentsInChildren<Image>(true))
        {
            string spriteName = image.sprite != null ? image.sprite.name : "";
            if (string.IsNullOrEmpty(spriteName)) continue;
            var entry = ChooseSpritePngEntry(spriteName, image, index);
            if (entry == null) continue;
            var tex = LoadTexture(entry.absolutePath, cache, spriteName);
            if (tex == null) continue;
            var old = image.sprite;
            float ppu = old != null && old.pixelsPerUnit > 0.01f ? old.pixelsPerUnit : 100f;
            Vector4 border = old != null ? old.border : Vector4.zero;
            var sprite = Sprite.Create(tex, new Rect(0f, 0f, tex.width, tex.height), new Vector2(0.5f, 0.5f), ppu, 0, SpriteMeshType.FullRect, border);
            sprite.name = spriteName;
            image.sprite = sprite;
            count++;
        }
        return count;
    }

    private static Dictionary<string, List<Battle40SpritePngEntry>> LoadSpritePngIndex()
    {
        var index = new Dictionary<string, List<Battle40SpritePngEntry>>(StringComparer.Ordinal);
        if (!File.Exists(SpriteIndexPath)) return index;
        var lines = File.ReadAllLines(SpriteIndexPath, Encoding.UTF8);
        for (int i = 1; i < lines.Length; i++)
        {
            var parts = SplitCsvLine(lines[i]);
            if (parts.Length < 7 || string.IsNullOrEmpty(parts[3])) continue;
            var entry = new Battle40SpritePngEntry();
            entry.bundle = parts[0];
            entry.pathId = parts[1];
            entry.assetType = parts[2];
            entry.name = parts[3];
            int.TryParse(parts[4], out entry.width);
            int.TryParse(parts[5], out entry.height);
            entry.output = parts[6];
            entry.absolutePath = Path.Combine(MergedExtractedRoot, entry.output.Replace('/', Path.DirectorySeparatorChar));
            if (!File.Exists(entry.absolutePath)) continue;
            if (!index.ContainsKey(entry.name)) index[entry.name] = new List<Battle40SpritePngEntry>();
            index[entry.name].Add(entry);
        }
        return index;
    }

    private static string[] SplitCsvLine(string line)
    {
        return line.Split(',');
    }

    private static Battle40SpritePngEntry ChooseSpritePngEntry(string spriteName, Image image, Dictionary<string, List<Battle40SpritePngEntry>> index)
    {
        if (!index.ContainsKey(spriteName)) return null;
        Battle40SpritePngEntry best = null;
        int bestScore = int.MinValue;
        foreach (var entry in index[spriteName])
        {
            int score = entry.width * entry.height;
            string bundle = (entry.bundle ?? "").ToLowerInvariant();
            if (bundle.Contains("/uibattle.assetbundle")) score += 200000000;
            if (bundle.Contains("/uicommonother.assetbundle")) score += 120000000;
            if (bundle.Contains("/uiherohead/")) score += 250000000;
            if (bundle.Contains("/uiheroheadbattle.assetbundle")) score += 250000000;
            if (bundle.Contains("/uibutton.assetbundle")) score += 40000000;
            if (spriteName.StartsWith("head", StringComparison.Ordinal) && bundle.Contains("/uiherohead/")) score += 300000000;
            if (image != null && image.sprite != null)
            {
                var rect = image.sprite.rect;
                if (Mathf.Abs(rect.width - entry.width) <= 2f && Mathf.Abs(rect.height - entry.height) <= 2f) score += 5000000;
            }
            if (score > bestScore)
            {
                best = entry;
                bestScore = score;
            }
        }
        return best;
    }

    private static Texture2D LoadTexture(string path, Dictionary<string, Texture2D> cache, string name)
    {
        if (cache.ContainsKey(path)) return cache[path];
        try
        {
            var tex = new Texture2D(2, 2, TextureFormat.RGBA32, false);
            tex.name = name + "_battle40_index_png";
            tex.LoadImage(File.ReadAllBytes(path), false);
            tex.wrapMode = TextureWrapMode.Clamp;
            tex.filterMode = FilterMode.Bilinear;
            cache[path] = tex;
            return tex;
        }
        catch
        {
            return null;
        }
    }

    private static void StepRuntimeActors(float dt)
    {
        foreach (var transform in UnityEngine.Object.FindObjectsOfType<Transform>(true))
        {
            if (transform == null || transform.name.IndexOf("BATTLE39_RuntimeActor_", StringComparison.Ordinal) < 0) continue;
            foreach (var component in transform.GetComponentsInChildren<Component>(true))
            {
                if (component == null) continue;
                if ((component.GetType().FullName ?? component.GetType().Name) != "Spine.Unity.SkeletonAnimation") continue;
                InvokeIfExists(component, "Update", new[] { typeof(float) }, new object[] { dt });
                InvokeIfExists(component, "LateUpdate", Type.EmptyTypes, new object[0]);
            }
        }
    }

    private static List<Battle40ActorBoundsRow> SnapshotActorBounds(Camera camera, int frame)
    {
        var rows = new List<Battle40ActorBoundsRow>();
        foreach (var transform in UnityEngine.Object.FindObjectsOfType<Transform>(true))
        {
            if (transform == null || transform.name.IndexOf("BATTLE39_RuntimeActor_", StringComparison.Ordinal) < 0) continue;
            var row = new Battle40ActorBoundsRow();
            row.frame = frame;
            row.name = transform.name;
            row.path = HierarchyPath(transform);
            row.worldBounds = CombinedBounds(transform.gameObject, out var bounds);
            row.screenRect = bounds.size == Vector3.zero ? "" : ScreenRect(camera, bounds);
            row.screenAreaRatio = bounds.size == Vector3.zero ? 0f : ScreenAreaRatio(camera, bounds);
            row.meshHash = MeshHash(transform.gameObject);
            rows.Add(row);
        }
        return rows;
    }

    private static string CombinedBounds(GameObject instance, out Bounds combined)
    {
        combined = new Bounds(Vector3.zero, Vector3.zero);
        if (instance == null) return "";
        bool has = false;
        foreach (var renderer in instance.GetComponentsInChildren<Renderer>(true))
        {
            if (!renderer.enabled) continue;
            if (!has)
            {
                combined = renderer.bounds;
                has = true;
            }
            else
            {
                combined.Encapsulate(renderer.bounds);
            }
        }
        return has ? Vec3(combined.center) + "|" + Vec3(combined.size) : "";
    }

    private static string ScreenRect(Camera camera, Bounds bounds)
    {
        var min = new Vector2(99999f, 99999f);
        var max = new Vector2(-99999f, -99999f);
        foreach (var p in BoundsCorners(bounds))
        {
            var sp = camera.WorldToScreenPoint(p);
            min.x = Mathf.Min(min.x, sp.x);
            min.y = Mathf.Min(min.y, sp.y);
            max.x = Mathf.Max(max.x, sp.x);
            max.y = Mathf.Max(max.y, sp.y);
        }
        return min.x.ToString("0.##") + "/" + min.y.ToString("0.##") + "/" + max.x.ToString("0.##") + "/" + max.y.ToString("0.##");
    }

    private static float ScreenAreaRatio(Camera camera, Bounds bounds)
    {
        var min = new Vector2(99999f, 99999f);
        var max = new Vector2(-99999f, -99999f);
        foreach (var p in BoundsCorners(bounds))
        {
            var sp = camera.WorldToScreenPoint(p);
            min.x = Mathf.Min(min.x, sp.x);
            min.y = Mathf.Min(min.y, sp.y);
            max.x = Mathf.Max(max.x, sp.x);
            max.y = Mathf.Max(max.y, sp.y);
        }
        var area = Mathf.Max(0f, max.x - min.x) * Mathf.Max(0f, max.y - min.y);
        return area / (CaptureWidth * CaptureHeight);
    }

    private static List<Vector3> BoundsCorners(Bounds b)
    {
        var min = b.min;
        var max = b.max;
        return new List<Vector3>
        {
            new Vector3(min.x, min.y, min.z), new Vector3(max.x, min.y, min.z),
            new Vector3(min.x, max.y, min.z), new Vector3(max.x, max.y, min.z),
            new Vector3(min.x, min.y, max.z), new Vector3(max.x, min.y, max.z),
            new Vector3(min.x, max.y, max.z), new Vector3(max.x, max.y, max.z),
        };
    }

    private static string MeshHash(GameObject instance)
    {
        if (instance == null) return "";
        var sb = new StringBuilder();
        foreach (var mf in instance.GetComponentsInChildren<MeshFilter>(true))
        {
            var mesh = mf.sharedMesh;
            if (mesh == null) continue;
            sb.Append(mf.name).Append("|").Append(mesh.vertexCount).Append("|").Append(Vec3(mesh.bounds.center)).Append("|").Append(Vec3(mesh.bounds.size));
            var verts = mesh.vertices;
            int step = Math.Max(1, verts.Length / 32);
            for (int i = 0; i < verts.Length; i += step) sb.Append("|").Append(Vec3(verts[i]));
        }
        return StableHash(sb.ToString());
    }

    private static void Capture(Camera camera, string fullPath)
    {
        Directory.CreateDirectory(Path.GetDirectoryName(fullPath));
        var rt = new RenderTexture(CaptureWidth, CaptureHeight, 24, RenderTextureFormat.ARGB32);
        var prevTarget = camera.targetTexture;
        var prevActive = RenderTexture.active;
        camera.targetTexture = rt;
        RenderTexture.active = rt;
        Canvas.ForceUpdateCanvases();
        camera.Render();
        var tex = new Texture2D(CaptureWidth, CaptureHeight, TextureFormat.RGB24, false);
        tex.ReadPixels(new Rect(0, 0, CaptureWidth, CaptureHeight), 0, 0);
        tex.Apply();
        File.WriteAllBytes(fullPath, tex.EncodeToPNG());
        camera.targetTexture = prevTarget;
        RenderTexture.active = prevActive;
        UnityEngine.Object.DestroyImmediate(tex);
        UnityEngine.Object.DestroyImmediate(rt);
    }

    private static void WriteCanvasCsv(string path, List<Battle40CanvasRow> before, List<Battle40CanvasRow> after, List<Battle40CanvasFix> fixes)
    {
        var sb = new StringBuilder();
        sb.AppendLine("phase,path,name,activeSelf,activeInHierarchy,enabled,renderMode,worldCameraName,worldCameraMatchesCapture,planeDistance,sortingLayerName,sortingOrder,overrideSorting,layer,canvasScalerUiScaleMode,canvasScalerReferenceResolution,canvasScalerMatchWidthOrHeight,canvasScalerScreenMatchMode,rectSize,anchorMin,anchorMax,pivot,localScale,fixReason,oldRenderMode,newRenderMode,oldWorldCameraName,newWorldCameraName,oldPlaneDistance,newPlaneDistance");
        foreach (var row in before) AppendCanvasRow(sb, row, null);
        foreach (var row in after) AppendCanvasRow(sb, row, FindFix(fixes, row.path));
        File.WriteAllText(path, sb.ToString(), new UTF8Encoding(false));
    }

    private static void AppendCanvasRow(StringBuilder sb, Battle40CanvasRow row, Battle40CanvasFix fix)
    {
        sb.AppendLine(string.Join(",", new[]
        {
            Csv(row.phase), Csv(row.path), Csv(row.name), Bool(row.activeSelf), Bool(row.activeInHierarchy), Bool(row.enabled),
            Csv(row.renderMode), Csv(row.worldCameraName), Bool(row.worldCameraMatchesCapture), Num(row.planeDistance),
            Csv(row.sortingLayerName), row.sortingOrder.ToString(), Bool(row.overrideSorting), Csv(row.layer),
            Csv(row.canvasScalerUiScaleMode), Csv(row.canvasScalerReferenceResolution), Num(row.canvasScalerMatchWidthOrHeight),
            Csv(row.canvasScalerScreenMatchMode), Csv(row.rectSize), Csv(row.anchorMin), Csv(row.anchorMax), Csv(row.pivot), Csv(row.localScale),
            Csv(fix != null ? fix.reason : ""), Csv(fix != null ? fix.oldRenderMode : ""), Csv(fix != null ? fix.newRenderMode : ""),
            Csv(fix != null ? fix.oldWorldCameraName : ""), Csv(fix != null ? fix.newWorldCameraName : ""),
            fix != null ? Num(fix.oldPlaneDistance) : "", fix != null ? Num(fix.newPlaneDistance) : ""
        }));
    }

    private static Battle40CanvasFix FindFix(List<Battle40CanvasFix> fixes, string path)
    {
        foreach (var fix in fixes) if (fix.path == path) return fix;
        return null;
    }

    private static void WriteComponentsCsv(string path, List<Battle40ComponentRow> rows)
    {
        var sb = new StringBuilder();
        sb.AppendLine("phase,path,name,componentType,activeSelf,activeInHierarchy,enabled,raycastTarget,color,materialName,canvasPath,canvasRenderMode,canvasWorldCameraName,canvasSortingOrder,spriteName,textureName,textureSize,imageType,preserveAspect,fillAmount,textLength,fontName,rectSize,anchoredPosition,anchorMin,anchorMax,localScale");
        foreach (var row in rows)
        {
            sb.AppendLine(string.Join(",", new[]
            {
                Csv(row.phase), Csv(row.path), Csv(row.name), Csv(row.componentType), Bool(row.activeSelf), Bool(row.activeInHierarchy), Bool(row.enabled),
                Bool(row.raycastTarget), Csv(row.color), Csv(row.materialName), Csv(row.canvasPath), Csv(row.canvasRenderMode), Csv(row.canvasWorldCameraName), row.canvasSortingOrder.ToString(),
                Csv(row.spriteName), Csv(row.textureName), Csv(row.textureSize), Csv(row.imageType), Bool(row.preserveAspect), Num(row.fillAmount), row.textLength.ToString(), Csv(row.fontName),
                Csv(row.rectSize), Csv(row.anchoredPosition), Csv(row.anchorMin), Csv(row.anchorMax), Csv(row.localScale)
            }));
        }
        File.WriteAllText(path, sb.ToString(), new UTF8Encoding(false));
    }

    private static void WriteActorBoundsCsv(string path, List<Battle40ActorBoundsRow> rows)
    {
        var sb = new StringBuilder();
        sb.AppendLine("frame,name,path,worldBounds,screenRect,screenAreaRatio,meshHash");
        foreach (var row in rows)
            sb.AppendLine(row.frame + "," + Csv(row.name) + "," + Csv(row.path) + "," + Csv(row.worldBounds) + "," + Csv(row.screenRect) + "," + Num(row.screenAreaRatio) + "," + Csv(row.meshHash));
        File.WriteAllText(path, sb.ToString(), new UTF8Encoding(false));
    }

    private static void WriteJson(string path, Battle40Result result)
    {
        var sb = new StringBuilder();
        sb.AppendLine("{");
        Add(sb, "status", "battle40_hud_camera_render_binding_probe");
        Add(sb, "isFinalRestoredBattleScreen", false);
        Add(sb, "baseScene", result.baseScene);
        Add(sb, "scene", result.scene);
        Add(sb, "capture", result.capture);
        Add(sb, "baseSceneExists", result.baseSceneExists);
        Add(sb, "cameraFound", result.cameraFound);
        Add(sb, "hudRootFound", result.hudRootFound);
        Add(sb, "heroListContainerFound", result.heroListContainerFound);
        Add(sb, "cameraBefore", result.cameraBefore);
        Add(sb, "cameraAfter", result.cameraAfter);
        Add(sb, "beforeCanvasCount", result.beforeCanvasCount);
        Add(sb, "afterCanvasCount", result.afterCanvasCount);
        Add(sb, "canvasFixCount", result.canvasFixCount);
        Add(sb, "extractedSpriteBindCount", result.extractedSpriteBindCount);
        Add(sb, "beforeGraphicCount", result.beforeGraphicCount);
        Add(sb, "afterGraphicCount", result.afterGraphicCount);
        Add(sb, "beforeImageCount", result.beforeImageCount);
        Add(sb, "afterImageCount", result.afterImageCount);
        Add(sb, "beforeImageWithSpriteCount", result.beforeImageWithSpriteCount);
        Add(sb, "afterImageWithSpriteCount", result.afterImageWithSpriteCount);
        Add(sb, "beforeImageWithTextureCount", result.beforeImageWithTextureCount);
        Add(sb, "afterImageWithTextureCount", result.afterImageWithTextureCount);
        Add(sb, "afterActiveGraphicCount", result.afterActiveGraphicCount);
        Add(sb, "captureExists", result.captureExists);
        sb.AppendLine("  \"canvasFixes\": [");
        for (int i = 0; i < result.canvasFixes.Count; i++)
        {
            var f = result.canvasFixes[i];
            sb.Append("    {\"path\":\"" + Json(f.path) + "\",\"reason\":\"" + Json(f.reason) + "\",\"oldRenderMode\":\"" + Json(f.oldRenderMode) + "\",\"newRenderMode\":\"" + Json(f.newRenderMode) + "\",\"oldWorldCameraName\":\"" + Json(f.oldWorldCameraName) + "\",\"newWorldCameraName\":\"" + Json(f.newWorldCameraName) + "\",\"oldPlaneDistance\":" + Num(f.oldPlaneDistance) + ",\"newPlaneDistance\":" + Num(f.newPlaneDistance) + ",\"oldSortingOrder\":" + f.oldSortingOrder + ",\"newSortingOrder\":" + f.newSortingOrder + "}");
            sb.AppendLine(i + 1 == result.canvasFixes.Count ? "" : ",");
        }
        sb.AppendLine("  ]");
        sb.AppendLine("}");
        File.WriteAllText(path, sb.ToString(), new UTF8Encoding(false));
    }

    private static void Add(StringBuilder sb, string name, string value) { sb.AppendLine("  \"" + name + "\": \"" + Json(value) + "\","); }
    private static void Add(StringBuilder sb, string name, bool value) { sb.AppendLine("  \"" + name + "\": " + Bool(value) + ","); }
    private static void Add(StringBuilder sb, string name, int value) { sb.AppendLine("  \"" + name + "\": " + value + ","); }

    private static int CountGraphics(List<Battle40ComponentRow> rows) { return rows.Count; }
    private static int CountType(List<Battle40ComponentRow> rows, string type)
    {
        int count = 0;
        foreach (var row in rows) if (row.componentType == type) count++;
        return count;
    }
    private static int Count(List<Battle40ComponentRow> rows, Predicate<Battle40ComponentRow> pred)
    {
        int count = 0;
        foreach (var row in rows) if (pred(row)) count++;
        return count;
    }

    private static GameObject FindByNameContains(string text)
    {
        foreach (var transform in UnityEngine.Object.FindObjectsOfType<Transform>(true))
        {
            if (transform != null && transform.name.IndexOf(text, StringComparison.OrdinalIgnoreCase) >= 0) return transform.gameObject;
        }
        return null;
    }

    private static bool IsChildOf(Transform transform, Transform root)
    {
        var cursor = transform;
        while (cursor != null)
        {
            if (cursor == root) return true;
            cursor = cursor.parent;
        }
        return false;
    }

    private static string HierarchyPath(Transform transform)
    {
        var names = new List<string>();
        var cursor = transform;
        while (cursor != null)
        {
            names.Add(cursor.name);
            cursor = cursor.parent;
        }
        names.Reverse();
        return string.Join("/", names.ToArray());
    }

    private static object ReadField(object obj, string name)
    {
        if (obj == null) return null;
        var type = obj.GetType();
        while (type != null)
        {
            var field = type.GetField(name, BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance);
            if (field != null) return field.GetValue(obj);
            type = type.BaseType;
        }
        return null;
    }

    private static void InvokeIfExists(object obj, string name, Type[] types, object[] args)
    {
        var method = obj.GetType().GetMethod(name, BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance, null, types, null);
        if (method != null) method.Invoke(obj, args);
    }

    private static string StableHash(string value)
    {
        unchecked
        {
            uint hash = 2166136261;
            for (int i = 0; i < value.Length; i++)
            {
                hash ^= value[i];
                hash *= 16777619;
            }
            return hash.ToString("x8");
        }
    }

    private static string ProjectPath(string assetPath) { return Path.Combine(Application.dataPath, "..", assetPath.Replace("/", "\\")); }
    private static string CameraInfo(Camera c) { return c == null ? "" : c.name + "|ortho=" + Bool(c.orthographic) + "|size=" + Num(c.orthographicSize) + "|pos=" + Vec3(c.transform.position) + "|depth=" + Num(c.depth) + "|clear=" + c.clearFlags + "|cull=" + c.cullingMask; }
    private static string ColorString(Color c) { return c.r.ToString("0.###") + "/" + c.g.ToString("0.###") + "/" + c.b.ToString("0.###") + "/" + c.a.ToString("0.###"); }
    private static string Vec2(Vector2 v) { return v.x.ToString("0.###") + "/" + v.y.ToString("0.###"); }
    private static string Vec3(Vector3 v) { return v.x.ToString("0.###") + "/" + v.y.ToString("0.###") + "/" + v.z.ToString("0.###"); }
    private static string Bool(bool value) { return value ? "true" : "false"; }
    private static string Num(float value) { return value.ToString("0.######", System.Globalization.CultureInfo.InvariantCulture); }
    private static string Json(string value) { return (value ?? "").Replace("\\", "\\\\").Replace("\"", "\\\"").Replace("\r", " ").Replace("\n", " "); }
    private static string Csv(string value) { return "\"" + (value ?? "").Replace("\"", "\"\"") + "\""; }

    private sealed class Battle40Result
    {
        public string baseScene = "";
        public string scene = "";
        public string capture = "";
        public bool baseSceneExists;
        public bool cameraFound;
        public bool hudRootFound;
        public bool heroListContainerFound;
        public string cameraBefore = "";
        public string cameraAfter = "";
        public int beforeCanvasCount;
        public int afterCanvasCount;
        public int canvasFixCount;
        public int extractedSpriteBindCount;
        public int beforeGraphicCount;
        public int afterGraphicCount;
        public int beforeImageCount;
        public int afterImageCount;
        public int beforeImageWithSpriteCount;
        public int afterImageWithSpriteCount;
        public int beforeImageWithTextureCount;
        public int afterImageWithTextureCount;
        public int afterActiveGraphicCount;
        public bool captureExists;
        public List<Battle40CanvasFix> canvasFixes = new List<Battle40CanvasFix>();
    }

    private sealed class Battle40CanvasRow
    {
        public string phase = "";
        public string path = "";
        public string name = "";
        public bool activeSelf;
        public bool activeInHierarchy;
        public bool enabled;
        public string renderMode = "";
        public string worldCameraName = "";
        public bool worldCameraMatchesCapture;
        public float planeDistance;
        public string sortingLayerName = "";
        public int sortingOrder;
        public bool overrideSorting;
        public string layer = "";
        public string canvasScalerUiScaleMode = "";
        public string canvasScalerReferenceResolution = "";
        public float canvasScalerMatchWidthOrHeight;
        public string canvasScalerScreenMatchMode = "";
        public string rectSize = "";
        public string anchorMin = "";
        public string anchorMax = "";
        public string pivot = "";
        public string localScale = "";
    }

    private sealed class Battle40CanvasFix
    {
        public string path = "";
        public string reason = "";
        public string oldRenderMode = "";
        public string newRenderMode = "";
        public string oldWorldCameraName = "";
        public string newWorldCameraName = "";
        public float oldPlaneDistance;
        public float newPlaneDistance;
        public int oldSortingOrder;
        public int newSortingOrder;
    }

    private sealed class Battle40ComponentRow
    {
        public string phase = "";
        public string path = "";
        public string name = "";
        public string componentType = "";
        public bool activeSelf;
        public bool activeInHierarchy;
        public bool enabled;
        public bool raycastTarget;
        public string color = "";
        public string materialName = "";
        public string canvasPath = "";
        public string canvasRenderMode = "";
        public string canvasWorldCameraName = "";
        public int canvasSortingOrder;
        public string spriteName = "";
        public string textureName = "";
        public string textureSize = "";
        public string imageType = "";
        public bool preserveAspect;
        public float fillAmount;
        public int textLength;
        public string fontName = "";
        public string rectSize = "";
        public string anchoredPosition = "";
        public string anchorMin = "";
        public string anchorMax = "";
        public string localScale = "";
    }

    private sealed class Battle40SpritePngEntry
    {
        public string bundle = "";
        public string pathId = "";
        public string assetType = "";
        public string name = "";
        public int width;
        public int height;
        public string output = "";
        public string absolutePath = "";
    }

    private sealed class Battle40ActorBoundsRow
    {
        public int frame;
        public string name = "";
        public string path = "";
        public string worldBounds = "";
        public string screenRect = "";
        public float screenAreaRatio;
        public string meshHash = "";
    }
}
