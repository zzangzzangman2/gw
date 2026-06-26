using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.SceneManagement;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text;

public static class Battle71Map11003TrueAspectReprojectionEditor
{
    private const string Prefix = "BATTLE_71_CANDIDATE_ONLY_MAP_11003_TRUE_ASPECT_REPROJECTION_AND_CAPTURE_VALIDATE_NO_CANONICAL_SCENE_OVERWRITE";
    private const string SourceScenePath = "Assets/Scenes/Battle57RuntimeRehydratedAssetBundleActorsCandidate.unity";
    private const string FallbackScenePath = "Assets/Scenes/Battle51LuaBridgeRaycasterRegistrationCandidate.unity";
    private const string CapturePath = "Assets/RestoreCaptures/battle_actor/Battle71Map11003TrueAspectReprojectionCandidate_1920x855.png";
    private const string SummaryPath = "Assets/RestoreData/battle/BATTLE_71_CANDIDATE_ONLY_MAP_11003_TRUE_ASPECT_REPROJECTION_AND_CAPTURE_VALIDATE_NO_CANONICAL_SCENE_OVERWRITE_UNITY.json";
    private const string LayerCsvPath = "Assets/RestoreData/battle/BATTLE_71_CANDIDATE_ONLY_MAP_11003_TRUE_ASPECT_REPROJECTION_AND_CAPTURE_VALIDATE_NO_CANONICAL_SCENE_OVERWRITE_MAP_LAYER_FORMULA_UNITY.csv";
    private const string TransformCsvPath = "Assets/RestoreData/battle/BATTLE_71_CANDIDATE_ONLY_MAP_11003_TRUE_ASPECT_REPROJECTION_AND_CAPTURE_VALIDATE_NO_CANONICAL_SCENE_OVERWRITE_CHANGED_TRANSFORMS_UNITY.csv";
    private const string MergedExtractedRoot = @"C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted";
    private const int BaselineWidth = 1920;
    private const int BaselineHeight = 1080;
    private const int CaptureWidth = 1920;
    private const int CaptureHeight = 855;
    private const float CameraOrthoSize = 5f;

    private static readonly LayerSpec[] Layers =
    {
        new LayerSpec("Map_11003_11", "pixel_space_sky_mountain_strip_from_video_1920x1080", "extracted/unity/bundles/b_9d48e387e09bd2e7/images/S/5971460981514339809_Map_11003_11.png", 0f, 0f, 0),
        new LayerSpec("Map_11003_5", "pixel_space_background_buildings_from_video_1920x1080", "extracted/unity/bundles/b_9d48e387e09bd2e7/images/S/-7856817432204118800_Map_11003_5.png", 0f, 0f, 1),
        new LayerSpec("Map_11003_4_2", "pixel_space_center_house_from_original_prefab_name_bg4_2", "extracted/unity/bundles/b_180ffe459f8c296a/images/S/-7820322519759755053_Map_11003_4_2.png", 455f, 105f, 2),
        new LayerSpec("Map_11003_4_1", "pixel_space_center_house_curtain_from_original_prefab_name_bg4_1", "extracted/unity/bundles/b_180ffe459f8c296a/images/S/-8270640840813032502_Map_11003_4_1.png", 710f, 260f, 3),
        new LayerSpec("Map_11003_3", "pixel_space_midground_debris_from_video_1920x1080", "extracted/unity/bundles/b_180ffe459f8c296a/images/S/7288649013814339085_Map_11003_3.png", 0f, 335f, 4),
        new LayerSpec("Map_11003_2", "pixel_space_stone_floor_video_best_match", "extracted/unity/bundles/b_180ffe459f8c296a/images/S/-6485743510393844429_Map_11003_2.png", 0f, 430f, 5),
        new LayerSpec("Map_11003_1_3", "pixel_space_bottom_foreground_from_original_prefab_name_bg1_3", "extracted/unity/bundles/b_180ffe459f8c296a/images/S/-2714483910561799702_Map_11003_1_3.png", 700f, 895f, 6),
        new LayerSpec("Map_11003_1_4", "pixel_space_bottom_foreground_from_original_prefab_name_bg1_4", "extracted/unity/bundles/b_180ffe459f8c296a/images/S/-7114534193537288331_Map_11003_1_4.png", 1200f, 905f, 7),
        new LayerSpec("Map_11003_1_1", "pixel_space_bottom_foreground_from_original_prefab_name_bg1_1", "extracted/unity/bundles/b_180ffe459f8c296a/images/S/-8534531834521366686_Map_11003_1_1.png", 1500f, 900f, 8),
    };

    [MenuItem("GirlsWar/Battle/BATTLE71 Candidate Map11003 True Aspect Reprojection Capture")]
    public static void Build()
    {
        Directory.CreateDirectory(ProjectPath("Assets/RestoreCaptures/battle_actor"));
        Directory.CreateDirectory(ProjectPath("Assets/RestoreData/battle"));

        var result = new Result();
        result.prefix = Prefix;
        result.capturePath = CapturePath;
        result.captureWidth = CaptureWidth;
        result.captureHeight = CaptureHeight;
        result.captureAspect = ((float)CaptureWidth / CaptureHeight).ToString("0.######");
        result.referenceAspect = "2.2456";
        result.canonicalSceneOverwritten = false;
        result.candidateSceneSaved = false;
        result.sceneSaved = false;
        result.packageImported = false;
        result.manifestModified = false;
        result.runtimeInstrumentationUsed = false;
        result.hudRoutePatched = false;
        result.cardPayloadPatched = false;
        result.actorPayloadPatched = false;
        result.mapLayerFormulaSourceBacked = true;

        string scenePath = File.Exists(ProjectPath(SourceScenePath)) ? SourceScenePath : FallbackScenePath;
        result.sourceScene = scenePath;
        if (!File.Exists(ProjectPath(scenePath)))
        {
            result.status = "blocked_source_scene_not_found";
            WriteJson(ProjectPath(SummaryPath), result);
            return;
        }

        var formulaRows = new List<FormulaRow>();
        var transformRows = new List<TransformRow>();

        var scene = EditorSceneManager.OpenScene(scenePath, OpenSceneMode.Single);
        result.sceneOpened = scene.IsValid();
        result.sceneDirtyBefore = scene.isDirty;

        var camera = FindCaptureCamera();
        if (camera == null)
        {
            result.status = "blocked_capture_camera_not_found";
            result.sceneDirtyAfter = scene.isDirty;
            WriteCsv(ProjectPath(LayerCsvPath), FormulaHeader(), formulaRows);
            WriteCsv(ProjectPath(TransformCsvPath), TransformHeader(), transformRows);
            WriteJson(ProjectPath(SummaryPath), result);
            return;
        }

        result.cameraName = camera.name;
        result.cameraPixelRectBefore = RectString(camera.pixelRect);
        result.cameraTargetDisplay = camera.targetDisplay;
        result.cameraOrthographic = camera.orthographic;
        result.cameraOrthographicSize = camera.orthographicSize.ToString("0.######");
        result.cameraEnabled = camera.enabled;

        foreach (var layer in Layers)
        {
            var renderer = FindLayerRenderer(layer.spriteName);
            var formula = BuildFormulaRow(layer, renderer);
            formulaRows.Add(formula);

            var trow = new TransformRow();
            trow.spriteName = layer.spriteName;
            trow.role = layer.role;
            trow.pixelX = layer.pixelX.ToString("0.######");
            trow.pixelY = layer.pixelY.ToString("0.######");
            trow.sortingOrder = layer.sortingOrder.ToString();
            trow.objectFound = renderer != null;
            if (renderer != null)
            {
                var t = renderer.transform;
                trow.objectPath = TransformPath(t);
                trow.activeSelf = renderer.gameObject.activeSelf;
                trow.activeInHierarchy = renderer.gameObject.activeInHierarchy;
                trow.rendererEnabled = renderer.enabled;
                trow.beforeLocalPosition = Vec3(t.localPosition);
                trow.beforeLocalScale = Vec3(t.localScale);
                trow.beforeWorldPosition = Vec3(t.position);
                trow.beforeSprite = renderer.sprite != null ? renderer.sprite.name : "";
                trow.beforeMaterial = renderer.sharedMaterial != null ? renderer.sharedMaterial.name : "";
                trow.beforeRendererSortingOrder = renderer.sortingOrder.ToString();

                var afterPosition = new Vector3(formula.trueWorldXValue, formula.trueWorldYValue, t.localPosition.z);
                var afterScale = new Vector3(formula.trueScaleValue, formula.trueScaleValue, t.localScale.z);
                t.localPosition = afterPosition;
                t.localScale = afterScale;

                trow.afterLocalPosition = Vec3(t.localPosition);
                trow.afterLocalScale = Vec3(t.localScale);
                trow.afterWorldPosition = Vec3(t.position);
                trow.changedPosition = Vector3.Distance(ParseVec3(trow.beforeLocalPosition), t.localPosition) > 0.0001f;
                trow.changedScale = Math.Abs(ParseVec3(trow.beforeLocalScale).x - t.localScale.x) > 0.0001f || Math.Abs(ParseVec3(trow.beforeLocalScale).y - t.localScale.y) > 0.0001f;
                trow.changed = trow.changedPosition || trow.changedScale;
                if (trow.changed) result.mapLayersChangedCount++;
            }
            else
            {
                trow.objectPath = "";
                trow.afterLocalPosition = "";
                trow.afterLocalScale = "";
                trow.failReason = "layer_renderer_not_found";
            }
            transformRows.Add(trow);
        }

        result.mapLayersFound = 0;
        foreach (var row in transformRows)
            if (row.objectFound) result.mapLayersFound++;
        result.candidatePatchApplied = result.mapLayersChangedCount > 0;

        Canvas.ForceUpdateCanvases();
        Capture(camera, result);

        result.cameraPixelRectAfter = RectString(camera.pixelRect);
        result.sceneDirtyAfter = scene.isDirty;
        result.sceneSaved = false;
        result.candidateSceneSaved = false;
        result.canonicalSceneOverwritten = false;

        WriteCsv(ProjectPath(LayerCsvPath), FormulaHeader(), formulaRows);
        WriteCsv(ProjectPath(TransformCsvPath), TransformHeader(), transformRows);
        WriteJson(ProjectPath(SummaryPath), result);
        Debug.Log("BATTLE71 map reprojection capture status=" + result.status + " changed=" + result.mapLayersChangedCount + " sceneSaved=false canonicalOverwrite=false");
    }

    private static FormulaRow BuildFormulaRow(LayerSpec layer, SpriteRenderer renderer)
    {
        var row = new FormulaRow();
        row.spriteName = layer.spriteName;
        row.role = layer.role;
        row.sourcePath = layer.output;
        row.absolutePath = Path.Combine(MergedExtractedRoot, layer.output.Replace('/', Path.DirectorySeparatorChar));
        row.sourceTextureExists = File.Exists(row.absolutePath);
        row.pixelX = layer.pixelX.ToString("0.######");
        row.pixelY = layer.pixelY.ToString("0.######");
        row.sortingOrder = layer.sortingOrder.ToString();

        int width = 0;
        int height = 0;
        if (row.sourceTextureExists)
        {
            var texture = new Texture2D(2, 2, TextureFormat.RGBA32, false);
            texture.LoadImage(File.ReadAllBytes(row.absolutePath), false);
            width = texture.width;
            height = texture.height;
            UnityEngine.Object.DestroyImmediate(texture);
        }
        if ((width <= 0 || height <= 0) && renderer != null && renderer.sprite != null && renderer.sprite.texture != null)
        {
            width = renderer.sprite.texture.width;
            height = renderer.sprite.texture.height;
        }

        row.pixelWidth = width.ToString();
        row.pixelHeight = height.ToString();

        float baselinePpu = BaselineHeight / (CameraOrthoSize * 2f);
        float truePpu = CaptureHeight / (CameraOrthoSize * 2f);
        row.baselineCaptureSize = BaselineWidth + "x" + BaselineHeight;
        row.trueCaptureSize = CaptureWidth + "x" + CaptureHeight;
        row.baselinePpu = baselinePpu.ToString("0.######");
        row.truePpu = truePpu.ToString("0.######");

        row.baselineWorldXValue = ((layer.pixelX + width * 0.5f) - BaselineWidth * 0.5f) / baselinePpu;
        row.baselineWorldYValue = (BaselineHeight * 0.5f - (layer.pixelY + height * 0.5f)) / baselinePpu;
        row.trueWorldXValue = ((layer.pixelX + width * 0.5f) - CaptureWidth * 0.5f) / truePpu;
        row.trueWorldYValue = (CaptureHeight * 0.5f - (layer.pixelY + height * 0.5f)) / truePpu;
        row.baselineScaleValue = 100f / baselinePpu;
        row.trueScaleValue = 100f / truePpu;
        row.baselineWorldX = row.baselineWorldXValue.ToString("0.######");
        row.baselineWorldY = row.baselineWorldYValue.ToString("0.######");
        row.trueWorldX = row.trueWorldXValue.ToString("0.######");
        row.trueWorldY = row.trueWorldYValue.ToString("0.######");
        row.baselineScale = row.baselineScaleValue.ToString("0.######");
        row.trueScale = row.trueScaleValue.ToString("0.######");
        row.formulaSource = "BATTLE27 CreateMapLayerPixel: ppu=CaptureHeight/(5f*2f), worldX=((pixelX+w*0.5)-CaptureWidth*0.5)/ppu, worldY=(CaptureHeight*0.5-(pixelY+h*0.5))/ppu";
        return row;
    }

    private static SpriteRenderer FindLayerRenderer(string spriteName)
    {
        SpriteRenderer best = null;
        int bestScore = -1;
        foreach (var renderer in UnityEngine.Object.FindObjectsOfType<SpriteRenderer>(true))
        {
            if (renderer == null || !renderer.name.Contains(spriteName)) continue;
            int score = 0;
            string path = TransformPath(renderer.transform);
            if (renderer.name.StartsWith("Battle27PixelMapLayer_")) score += 100;
            if (path.Contains("BattleCorrectMapSceneHudPreviewClip05Root")) score += 50;
            if (renderer.gameObject.activeInHierarchy) score += 25;
            if (renderer.enabled) score += 10;
            if (best == null || score > bestScore)
            {
                best = renderer;
                bestScore = score;
            }
        }
        return best;
    }

    private static Camera FindCaptureCamera()
    {
        foreach (var camera in UnityEngine.Object.FindObjectsOfType<Camera>(true))
            if (camera.name == "BattleHudSpriteAtlasTextureRuntimeBindingClip05Camera")
                return camera;
        if (Camera.main != null) return Camera.main;
        var all = UnityEngine.Object.FindObjectsOfType<Camera>(true);
        return all.Length > 0 ? all[0] : null;
    }

    private static void Capture(Camera camera, Result result)
    {
        RenderTexture rt = null;
        Texture2D tex = null;
        var previousTarget = camera.targetTexture;
        var previousActive = RenderTexture.active;
        try
        {
            rt = new RenderTexture(CaptureWidth, CaptureHeight, 24, RenderTextureFormat.ARGB32);
            camera.targetTexture = rt;
            camera.Render();
            RenderTexture.active = rt;
            tex = new Texture2D(CaptureWidth, CaptureHeight, TextureFormat.RGB24, false);
            tex.ReadPixels(new Rect(0, 0, CaptureWidth, CaptureHeight), 0, 0);
            tex.Apply(false);
            File.WriteAllBytes(ProjectPath(CapturePath), tex.EncodeToPNG());
            result.status = "candidate_map_reprojection_capture_generated_no_scene_save";
            result.captureExists = File.Exists(ProjectPath(CapturePath));
            result.captureFileBytes = result.captureExists ? new FileInfo(ProjectPath(CapturePath)).Length : 0;
        }
        catch (Exception ex)
        {
            result.status = "capture_failed";
            result.exception = ex.GetType().FullName + ": " + ex.Message;
        }
        finally
        {
            camera.targetTexture = previousTarget;
            RenderTexture.active = previousActive;
            if (rt != null) UnityEngine.Object.DestroyImmediate(rt);
            if (tex != null) UnityEngine.Object.DestroyImmediate(tex);
        }
    }

    private static string[] FormulaHeader()
    {
        return new[] { "spriteName", "role", "sourcePath", "absolutePath", "sourceTextureExists", "pixelX", "pixelY", "pixelWidth", "pixelHeight", "sortingOrder", "baselineCaptureSize", "trueCaptureSize", "baselinePpu", "truePpu", "baselineWorldX", "baselineWorldY", "trueWorldX", "trueWorldY", "baselineScale", "trueScale", "formulaSource" };
    }

    private static string[] TransformHeader()
    {
        return new[] { "spriteName", "role", "objectFound", "objectPath", "activeSelf", "activeInHierarchy", "rendererEnabled", "pixelX", "pixelY", "sortingOrder", "beforeLocalPosition", "afterLocalPosition", "beforeLocalScale", "afterLocalScale", "beforeWorldPosition", "afterWorldPosition", "beforeSprite", "beforeMaterial", "beforeRendererSortingOrder", "changedPosition", "changedScale", "changed", "failReason" };
    }

    private static void WriteCsv<T>(string path, string[] header, List<T> rows)
    {
        var sb = new StringBuilder();
        sb.AppendLine(string.Join(",", header));
        foreach (var row in rows)
        {
            var values = new List<string>();
            var type = row.GetType();
            foreach (var field in header)
            {
                var info = type.GetField(field);
                object value = info != null ? info.GetValue(row) : "";
                values.Add(Csv(value == null ? "" : value.ToString()));
            }
            sb.AppendLine(string.Join(",", values.ToArray()));
        }
        File.WriteAllText(path, sb.ToString(), Encoding.UTF8);
    }

    private static string Csv(string value)
    {
        if (value == null) value = "";
        bool quote = value.Contains(",") || value.Contains("\"") || value.Contains("\n") || value.Contains("\r");
        value = value.Replace("\"", "\"\"");
        return quote ? "\"" + value + "\"" : value;
    }

    private static void WriteJson(string path, Result result)
    {
        var sb = new StringBuilder();
        sb.Append("{\n");
        Json(sb, "prefix", result.prefix, true);
        Json(sb, "status", result.status, true);
        Json(sb, "sourceScene", result.sourceScene, true);
        Json(sb, "sceneOpened", result.sceneOpened, true);
        Json(sb, "candidatePatchApplied", result.candidatePatchApplied, true);
        Json(sb, "canonicalSceneOverwritten", result.canonicalSceneOverwritten, true);
        Json(sb, "candidateSceneSaved", result.candidateSceneSaved, true);
        Json(sb, "sceneSaved", result.sceneSaved, true);
        Json(sb, "sceneDirtyBefore", result.sceneDirtyBefore, true);
        Json(sb, "sceneDirtyAfter", result.sceneDirtyAfter, true);
        Json(sb, "packageImported", result.packageImported, true);
        Json(sb, "manifestModified", result.manifestModified, true);
        Json(sb, "runtimeInstrumentationUsed", result.runtimeInstrumentationUsed, true);
        Json(sb, "hudRoutePatched", result.hudRoutePatched, true);
        Json(sb, "cardPayloadPatched", result.cardPayloadPatched, true);
        Json(sb, "actorPayloadPatched", result.actorPayloadPatched, true);
        Json(sb, "mapLayerFormulaSourceBacked", result.mapLayerFormulaSourceBacked, true);
        Json(sb, "mapLayersFound", result.mapLayersFound, true);
        Json(sb, "mapLayersChangedCount", result.mapLayersChangedCount, true);
        Json(sb, "capturePath", result.capturePath, true);
        Json(sb, "captureExists", result.captureExists, true);
        Json(sb, "captureWidth", result.captureWidth, true);
        Json(sb, "captureHeight", result.captureHeight, true);
        Json(sb, "captureAspect", result.captureAspect, true);
        Json(sb, "referenceAspect", result.referenceAspect, true);
        Json(sb, "captureFileBytes", result.captureFileBytes, true);
        Json(sb, "cameraName", result.cameraName, true);
        Json(sb, "cameraEnabled", result.cameraEnabled, true);
        Json(sb, "cameraTargetDisplay", result.cameraTargetDisplay, true);
        Json(sb, "cameraOrthographic", result.cameraOrthographic, true);
        Json(sb, "cameraOrthographicSize", result.cameraOrthographicSize, true);
        Json(sb, "cameraPixelRectBefore", result.cameraPixelRectBefore, true);
        Json(sb, "cameraPixelRectAfter", result.cameraPixelRectAfter, true);
        Json(sb, "exception", result.exception, false);
        sb.Append("}\n");
        File.WriteAllText(path, sb.ToString(), Encoding.UTF8);
    }

    private static void Json(StringBuilder sb, string key, string value, bool comma)
    {
        sb.Append("  \"").Append(key).Append("\": ");
        if (value == null) sb.Append("null");
        else sb.Append("\"").Append(value.Replace("\\", "\\\\").Replace("\"", "\\\"")).Append("\"");
        if (comma) sb.Append(",");
        sb.Append("\n");
    }

    private static void Json(StringBuilder sb, string key, bool value, bool comma)
    {
        sb.Append("  \"").Append(key).Append("\": ").Append(value ? "true" : "false");
        if (comma) sb.Append(",");
        sb.Append("\n");
    }

    private static void Json(StringBuilder sb, string key, int value, bool comma)
    {
        sb.Append("  \"").Append(key).Append("\": ").Append(value);
        if (comma) sb.Append(",");
        sb.Append("\n");
    }

    private static void Json(StringBuilder sb, string key, long value, bool comma)
    {
        sb.Append("  \"").Append(key).Append("\": ").Append(value);
        if (comma) sb.Append(",");
        sb.Append("\n");
    }

    private static string ProjectPath(string assetPath)
    {
        return Path.GetFullPath(Path.Combine(Application.dataPath, "..", assetPath));
    }

    private static string TransformPath(Transform t)
    {
        if (t == null) return "";
        var parts = new List<string>();
        while (t != null)
        {
            parts.Add(t.name);
            t = t.parent;
        }
        parts.Reverse();
        return string.Join("/", parts.ToArray());
    }

    private static string RectString(Rect rect)
    {
        return rect.x.ToString("0.######") + "/" + rect.y.ToString("0.######") + "/" + rect.width.ToString("0.######") + "/" + rect.height.ToString("0.######");
    }

    private static string Vec3(Vector3 v)
    {
        return v.x.ToString("0.######") + "/" + v.y.ToString("0.######") + "/" + v.z.ToString("0.######");
    }

    private static Vector3 ParseVec3(string text)
    {
        var parts = text.Split('/');
        if (parts.Length != 3) return Vector3.zero;
        float x = 0f, y = 0f, z = 0f;
        float.TryParse(parts[0], out x);
        float.TryParse(parts[1], out y);
        float.TryParse(parts[2], out z);
        return new Vector3(x, y, z);
    }

    private sealed class LayerSpec
    {
        public readonly string spriteName;
        public readonly string role;
        public readonly string output;
        public readonly float pixelX;
        public readonly float pixelY;
        public readonly int sortingOrder;

        public LayerSpec(string spriteName, string role, string output, float pixelX, float pixelY, int sortingOrder)
        {
            this.spriteName = spriteName;
            this.role = role;
            this.output = output;
            this.pixelX = pixelX;
            this.pixelY = pixelY;
            this.sortingOrder = sortingOrder;
        }
    }

    public sealed class FormulaRow
    {
        public string spriteName;
        public string role;
        public string sourcePath;
        public string absolutePath;
        public bool sourceTextureExists;
        public string pixelX;
        public string pixelY;
        public string pixelWidth;
        public string pixelHeight;
        public string sortingOrder;
        public string baselineCaptureSize;
        public string trueCaptureSize;
        public string baselinePpu;
        public string truePpu;
        public string baselineWorldX;
        public string baselineWorldY;
        public string trueWorldX;
        public string trueWorldY;
        public string baselineScale;
        public string trueScale;
        public string formulaSource;
        public float baselineWorldXValue;
        public float baselineWorldYValue;
        public float trueWorldXValue;
        public float trueWorldYValue;
        public float baselineScaleValue;
        public float trueScaleValue;
    }

    public sealed class TransformRow
    {
        public string spriteName;
        public string role;
        public bool objectFound;
        public string objectPath;
        public bool activeSelf;
        public bool activeInHierarchy;
        public bool rendererEnabled;
        public string pixelX;
        public string pixelY;
        public string sortingOrder;
        public string beforeLocalPosition;
        public string afterLocalPosition;
        public string beforeLocalScale;
        public string afterLocalScale;
        public string beforeWorldPosition;
        public string afterWorldPosition;
        public string beforeSprite;
        public string beforeMaterial;
        public string beforeRendererSortingOrder;
        public bool changedPosition;
        public bool changedScale;
        public bool changed;
        public string failReason;
    }

    private sealed class Result
    {
        public string prefix;
        public string status = "not_started";
        public string sourceScene;
        public bool sceneOpened;
        public bool candidatePatchApplied;
        public bool canonicalSceneOverwritten;
        public bool candidateSceneSaved;
        public bool sceneSaved;
        public bool sceneDirtyBefore;
        public bool sceneDirtyAfter;
        public bool packageImported;
        public bool manifestModified;
        public bool runtimeInstrumentationUsed;
        public bool hudRoutePatched;
        public bool cardPayloadPatched;
        public bool actorPayloadPatched;
        public bool mapLayerFormulaSourceBacked;
        public int mapLayersFound;
        public int mapLayersChangedCount;
        public string capturePath;
        public bool captureExists;
        public int captureWidth;
        public int captureHeight;
        public string captureAspect;
        public string referenceAspect;
        public long captureFileBytes;
        public string cameraName;
        public bool cameraEnabled;
        public int cameraTargetDisplay;
        public bool cameraOrthographic;
        public string cameraOrthographicSize;
        public string cameraPixelRectBefore;
        public string cameraPixelRectAfter;
        public string exception;
    }
}
