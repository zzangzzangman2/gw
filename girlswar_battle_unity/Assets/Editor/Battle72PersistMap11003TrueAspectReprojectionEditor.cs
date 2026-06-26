using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.SceneManagement;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text;

public static class Battle72PersistMap11003TrueAspectReprojectionEditor
{
    private const string Prefix = "BATTLE_72_PERSIST_VALIDATED_MAP_11003_TRUE_ASPECT_REPROJECTION_IN_CANDIDATE_BUILDER_AND_RERUN_VALIDATION_NO_CANONICAL_OVERWRITE";
    private const string SourceScenePath = "Assets/Scenes/Battle57RuntimeRehydratedAssetBundleActorsCandidate.unity";
    private const string FallbackScenePath = "Assets/Scenes/Battle51LuaBridgeRaycasterRegistrationCandidate.unity";
    private const string CandidateScenePath = "Assets/Scenes/Battle72Map11003TrueAspectReprojectionPersistedCandidate.unity";
    private const string CapturePath = "Assets/RestoreCaptures/battle_actor/Battle72PersistedMap11003TrueAspectReprojectionCandidate_1920x855.png";
    private const string SummaryPath = "Assets/RestoreData/battle/BATTLE_72_PERSIST_VALIDATED_MAP_11003_TRUE_ASPECT_REPROJECTION_IN_CANDIDATE_BUILDER_AND_RERUN_VALIDATION_NO_CANONICAL_OVERWRITE_UNITY.json";
    private const string TransformCsvPath = "Assets/RestoreData/battle/BATTLE_72_PERSIST_VALIDATED_MAP_11003_TRUE_ASPECT_REPROJECTION_IN_CANDIDATE_BUILDER_AND_RERUN_VALIDATION_NO_CANONICAL_OVERWRITE_PERSISTED_TRANSFORMS_UNITY.csv";
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

    [MenuItem("GirlsWar/Battle/BATTLE72 Persist Map11003 True Aspect Reprojection Candidate")]
    public static void Build()
    {
        Directory.CreateDirectory(ProjectPath("Assets/Scenes"));
        Directory.CreateDirectory(ProjectPath("Assets/RestoreCaptures/battle_actor"));
        Directory.CreateDirectory(ProjectPath("Assets/RestoreData/battle"));

        var result = NewResult();
        string sourceScene = File.Exists(ProjectPath(SourceScenePath)) ? SourceScenePath : FallbackScenePath;
        result.sourceScene = sourceScene;
        result.candidateScenePath = CandidateScenePath;

        var rows = new List<TransformRow>();
        if (!File.Exists(ProjectPath(sourceScene)))
        {
            result.status = "blocked_source_scene_not_found";
            WriteCsv(ProjectPath(TransformCsvPath), TransformHeader(), rows);
            WriteJson(ProjectPath(SummaryPath), result);
            return;
        }

        var scene = EditorSceneManager.OpenScene(sourceScene, OpenSceneMode.Single);
        result.sourceSceneOpened = scene.IsValid();
        result.sourceSceneDirtyBefore = scene.isDirty;

        foreach (var layer in Layers)
        {
            var row = ApplyLayer(layer);
            rows.Add(row);
            if (row.objectFound) result.mapLayersFound++;
            if (row.changed) result.mapLayersPersistedCount++;
        }
        result.candidateBuilderPatched = result.mapLayersPersistedCount > 0;

        Canvas.ForceUpdateCanvases();
        result.sourceSceneDirtyAfterPatch = scene.isDirty;
        bool saved = EditorSceneManager.SaveScene(scene, CandidateScenePath);
        result.candidateSceneSaved = saved;
        result.sceneSaved = saved;
        result.canonicalSceneOverwritten = false;
        result.candidateSceneExists = File.Exists(ProjectPath(CandidateScenePath));
        result.candidateSceneFileBytes = result.candidateSceneExists ? new FileInfo(ProjectPath(CandidateScenePath)).Length : 0;
        AssetDatabase.Refresh();

        var persistedScene = EditorSceneManager.OpenScene(CandidateScenePath, OpenSceneMode.Single);
        result.persistedSceneOpened = persistedScene.IsValid();
        result.persistedSceneDirtyBeforeCapture = persistedScene.isDirty;
        ConfirmPersisted(rows);

        var camera = FindCaptureCamera();
        if (camera == null)
        {
            result.status = "blocked_capture_camera_not_found";
            result.persistedSceneDirtyAfterCapture = persistedScene.isDirty;
            WriteCsv(ProjectPath(TransformCsvPath), TransformHeader(), rows);
            WriteJson(ProjectPath(SummaryPath), result);
            return;
        }

        result.cameraName = camera.name;
        result.cameraPixelRectBefore = RectString(camera.pixelRect);
        result.cameraTargetDisplay = camera.targetDisplay;
        result.cameraOrthographic = camera.orthographic;
        result.cameraOrthographicSize = camera.orthographicSize.ToString("0.######");
        result.cameraEnabled = camera.enabled;

        Capture(camera, result);
        result.cameraPixelRectAfter = RectString(camera.pixelRect);
        result.persistedSceneDirtyAfterCapture = persistedScene.isDirty;
        WriteCsv(ProjectPath(TransformCsvPath), TransformHeader(), rows);
        WriteJson(ProjectPath(SummaryPath), result);
        Debug.Log("BATTLE72 persisted candidate status=" + result.status + " saved=" + saved + " layers=" + result.mapLayersPersistedCount + " canonicalOverwrite=false");
    }

    private static Result NewResult()
    {
        var result = new Result();
        result.prefix = Prefix;
        result.status = "not_started";
        result.capturePath = CapturePath;
        result.captureWidth = CaptureWidth;
        result.captureHeight = CaptureHeight;
        result.captureAspect = ((float)CaptureWidth / CaptureHeight).ToString("0.######");
        result.referenceAspect = "2.2456";
        result.canonicalSceneOverwritten = false;
        result.packageImported = false;
        result.manifestModified = false;
        result.runtimeInstrumentationUsed = false;
        result.hudRoutePatched = false;
        result.cardPayloadPatched = false;
        result.actorPayloadPatched = false;
        result.mapLayerFormulaSourceBacked = true;
        return result;
    }

    private static TransformRow ApplyLayer(LayerSpec layer)
    {
        var row = new TransformRow();
        row.spriteName = layer.spriteName;
        row.role = layer.role;
        row.pixelX = layer.pixelX.ToString("0.######");
        row.pixelY = layer.pixelY.ToString("0.######");
        row.sortingOrder = layer.sortingOrder.ToString();
        row.sourcePath = layer.output;
        row.absolutePath = Path.Combine(MergedExtractedRoot, layer.output.Replace('/', Path.DirectorySeparatorChar));
        row.sourceTextureExists = File.Exists(row.absolutePath);

        var renderer = FindLayerRenderer(layer.spriteName);
        row.objectFound = renderer != null;
        if (renderer == null)
        {
            row.failReason = "layer_renderer_not_found";
            return row;
        }

        var t = renderer.transform;
        row.objectPath = TransformPath(t);
        row.activeSelf = renderer.gameObject.activeSelf;
        row.activeInHierarchy = renderer.gameObject.activeInHierarchy;
        row.rendererEnabled = renderer.enabled;
        row.beforeLocalPosition = Vec3(t.localPosition);
        row.beforeLocalScale = Vec3(t.localScale);
        row.beforeWorldPosition = Vec3(t.position);
        row.beforeSprite = renderer.sprite != null ? renderer.sprite.name : "";
        row.beforeMaterial = renderer.sharedMaterial != null ? renderer.sharedMaterial.name : "";
        row.beforeRendererSortingOrder = renderer.sortingOrder.ToString();

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
        if ((width <= 0 || height <= 0) && renderer.sprite != null && renderer.sprite.texture != null)
        {
            width = renderer.sprite.texture.width;
            height = renderer.sprite.texture.height;
        }

        float baselinePpu = BaselineHeight / (CameraOrthoSize * 2f);
        float truePpu = CaptureHeight / (CameraOrthoSize * 2f);
        float baselineX = ((layer.pixelX + width * 0.5f) - BaselineWidth * 0.5f) / baselinePpu;
        float baselineY = (BaselineHeight * 0.5f - (layer.pixelY + height * 0.5f)) / baselinePpu;
        float trueX = ((layer.pixelX + width * 0.5f) - CaptureWidth * 0.5f) / truePpu;
        float trueY = (CaptureHeight * 0.5f - (layer.pixelY + height * 0.5f)) / truePpu;
        float trueScale = 100f / truePpu;

        row.pixelWidth = width.ToString();
        row.pixelHeight = height.ToString();
        row.baselinePpu = baselinePpu.ToString("0.######");
        row.truePpu = truePpu.ToString("0.######");
        row.baselineFormulaLocalPosition = Vec3(new Vector3(baselineX, baselineY, t.localPosition.z));
        row.trueFormulaLocalPosition = Vec3(new Vector3(trueX, trueY, t.localPosition.z));
        row.trueFormulaLocalScale = Vec3(new Vector3(trueScale, trueScale, t.localScale.z));
        row.formulaSource = "BATTLE27 CreateMapLayerPixel reprojected from 1920x1080 to 1920x855: ppu=CaptureHeight/(5f*2f)";

        t.localPosition = new Vector3(trueX, trueY, t.localPosition.z);
        t.localScale = new Vector3(trueScale, trueScale, t.localScale.z);

        row.afterLocalPosition = Vec3(t.localPosition);
        row.afterLocalScale = Vec3(t.localScale);
        row.afterWorldPosition = Vec3(t.position);
        row.changedPosition = Vector3.Distance(ParseVec3(row.beforeLocalPosition), t.localPosition) > 0.0001f;
        row.changedScale = Math.Abs(ParseVec3(row.beforeLocalScale).x - t.localScale.x) > 0.0001f || Math.Abs(ParseVec3(row.beforeLocalScale).y - t.localScale.y) > 0.0001f;
        row.changed = row.changedPosition || row.changedScale;
        return row;
    }

    private static void ConfirmPersisted(List<TransformRow> rows)
    {
        foreach (var row in rows)
        {
            var renderer = FindLayerRenderer(row.spriteName);
            if (renderer == null)
            {
                row.persistedObjectFound = false;
                row.persistedMatchesAfter = false;
                continue;
            }
            row.persistedObjectFound = true;
            row.persistedLocalPosition = Vec3(renderer.transform.localPosition);
            row.persistedLocalScale = Vec3(renderer.transform.localScale);
            row.persistedMatchesAfter = row.persistedLocalPosition == row.afterLocalPosition && row.persistedLocalScale == row.afterLocalScale;
        }
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
            result.status = "persisted_map_reprojection_candidate_scene_saved_and_captured";
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

    private static string[] TransformHeader()
    {
        return new[] { "spriteName", "role", "sourcePath", "absolutePath", "sourceTextureExists", "objectFound", "objectPath", "activeSelf", "activeInHierarchy", "rendererEnabled", "pixelX", "pixelY", "pixelWidth", "pixelHeight", "sortingOrder", "baselinePpu", "truePpu", "baselineFormulaLocalPosition", "trueFormulaLocalPosition", "trueFormulaLocalScale", "beforeLocalPosition", "afterLocalPosition", "persistedLocalPosition", "beforeLocalScale", "afterLocalScale", "persistedLocalScale", "beforeWorldPosition", "afterWorldPosition", "beforeSprite", "beforeMaterial", "beforeRendererSortingOrder", "changedPosition", "changedScale", "changed", "persistedObjectFound", "persistedMatchesAfter", "formulaSource", "failReason" };
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
        Json(sb, "candidateScenePath", result.candidateScenePath, true);
        Json(sb, "sourceSceneOpened", result.sourceSceneOpened, true);
        Json(sb, "persistedSceneOpened", result.persistedSceneOpened, true);
        Json(sb, "candidateBuilderPatched", result.candidateBuilderPatched, true);
        Json(sb, "canonicalSceneOverwritten", result.canonicalSceneOverwritten, true);
        Json(sb, "candidateSceneSaved", result.candidateSceneSaved, true);
        Json(sb, "sceneSaved", result.sceneSaved, true);
        Json(sb, "sourceSceneDirtyBefore", result.sourceSceneDirtyBefore, true);
        Json(sb, "sourceSceneDirtyAfterPatch", result.sourceSceneDirtyAfterPatch, true);
        Json(sb, "persistedSceneDirtyBeforeCapture", result.persistedSceneDirtyBeforeCapture, true);
        Json(sb, "persistedSceneDirtyAfterCapture", result.persistedSceneDirtyAfterCapture, true);
        Json(sb, "candidateSceneExists", result.candidateSceneExists, true);
        Json(sb, "candidateSceneFileBytes", result.candidateSceneFileBytes, true);
        Json(sb, "packageImported", result.packageImported, true);
        Json(sb, "manifestModified", result.manifestModified, true);
        Json(sb, "runtimeInstrumentationUsed", result.runtimeInstrumentationUsed, true);
        Json(sb, "hudRoutePatched", result.hudRoutePatched, true);
        Json(sb, "cardPayloadPatched", result.cardPayloadPatched, true);
        Json(sb, "actorPayloadPatched", result.actorPayloadPatched, true);
        Json(sb, "mapLayerFormulaSourceBacked", result.mapLayerFormulaSourceBacked, true);
        Json(sb, "mapLayersFound", result.mapLayersFound, true);
        Json(sb, "mapLayersPersistedCount", result.mapLayersPersistedCount, true);
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

    public sealed class TransformRow
    {
        public string spriteName;
        public string role;
        public string sourcePath;
        public string absolutePath;
        public bool sourceTextureExists;
        public bool objectFound;
        public string objectPath;
        public bool activeSelf;
        public bool activeInHierarchy;
        public bool rendererEnabled;
        public string pixelX;
        public string pixelY;
        public string pixelWidth;
        public string pixelHeight;
        public string sortingOrder;
        public string baselinePpu;
        public string truePpu;
        public string baselineFormulaLocalPosition;
        public string trueFormulaLocalPosition;
        public string trueFormulaLocalScale;
        public string beforeLocalPosition;
        public string afterLocalPosition;
        public string persistedLocalPosition;
        public string beforeLocalScale;
        public string afterLocalScale;
        public string persistedLocalScale;
        public string beforeWorldPosition;
        public string afterWorldPosition;
        public string beforeSprite;
        public string beforeMaterial;
        public string beforeRendererSortingOrder;
        public bool changedPosition;
        public bool changedScale;
        public bool changed;
        public bool persistedObjectFound;
        public bool persistedMatchesAfter;
        public string formulaSource;
        public string failReason;
    }

    private sealed class Result
    {
        public string prefix;
        public string status;
        public string sourceScene;
        public string candidateScenePath;
        public bool sourceSceneOpened;
        public bool persistedSceneOpened;
        public bool candidateBuilderPatched;
        public bool canonicalSceneOverwritten;
        public bool candidateSceneSaved;
        public bool sceneSaved;
        public bool sourceSceneDirtyBefore;
        public bool sourceSceneDirtyAfterPatch;
        public bool persistedSceneDirtyBeforeCapture;
        public bool persistedSceneDirtyAfterCapture;
        public bool candidateSceneExists;
        public long candidateSceneFileBytes;
        public bool packageImported;
        public bool manifestModified;
        public bool runtimeInstrumentationUsed;
        public bool hudRoutePatched;
        public bool cardPayloadPatched;
        public bool actorPayloadPatched;
        public bool mapLayerFormulaSourceBacked;
        public int mapLayersFound;
        public int mapLayersPersistedCount;
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
