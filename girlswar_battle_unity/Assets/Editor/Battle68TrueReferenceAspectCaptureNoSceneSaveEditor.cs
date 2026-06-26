using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.SceneManagement;
using System;
using System.IO;
using System.Text;

public static class Battle68TrueReferenceAspectCaptureNoSceneSaveEditor
{
    private const string Prefix = "BATTLE_68_TRUE_REFERENCE_ASPECT_CAPTURE_PIPELINE_AND_VIEWRECT_SOURCE_TRACE_NO_SCENE_SAVE";
    private const string SourceScenePath = "Assets/Scenes/Battle57RuntimeRehydratedAssetBundleActorsCandidate.unity";
    private const string FallbackScenePath = "Assets/Scenes/Battle51LuaBridgeRaycasterRegistrationCandidate.unity";
    private const string CapturePath = "Assets/RestoreCaptures/battle_actor/Battle68TrueReferenceAspectNoSceneSave_1920x855.png";
    private const string SummaryPath = "Assets/RestoreData/battle/BATTLE_68_TRUE_REFERENCE_ASPECT_CAPTURE_PIPELINE_AND_VIEWRECT_SOURCE_TRACE_NO_SCENE_SAVE_UNITY.json";
    private const int CaptureWidth = 1920;
    private const int CaptureHeight = 855;

    [MenuItem("GirlsWar/Battle/BATTLE68 True Reference Aspect Capture No Scene Save")]
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
        result.sceneSaved = false;
        result.packageImported = false;
        result.manifestModified = false;
        result.runtimeInstrumentationUsed = false;
        result.analysisOnlyCropUsedAsFinal = false;

        string scenePath = File.Exists(ProjectPath(SourceScenePath)) ? SourceScenePath : FallbackScenePath;
        result.sourceScene = scenePath;
        if (!File.Exists(ProjectPath(scenePath)))
        {
            result.status = "blocked_source_scene_not_found";
            WriteJson(ProjectPath(SummaryPath), result);
            return;
        }

        var scene = EditorSceneManager.OpenScene(scenePath, OpenSceneMode.Single);
        result.sceneOpened = scene.IsValid();
        result.sceneDirtyBefore = scene.isDirty;
        var camera = FindCaptureCamera();
        if (camera == null)
        {
            result.status = "blocked_capture_camera_not_found";
            result.sceneDirtyAfter = scene.isDirty;
            WriteJson(ProjectPath(SummaryPath), result);
            return;
        }

        result.cameraName = camera.name;
        result.cameraPixelRectBefore = RectString(camera.pixelRect);
        result.cameraTargetDisplay = camera.targetDisplay;
        result.cameraOrthographic = camera.orthographic;
        result.cameraOrthographicSize = camera.orthographicSize.ToString("0.######");
        result.cameraEnabled = camera.enabled;

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
            result.status = "true_reference_aspect_capture_generated_no_scene_save";
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

        result.cameraPixelRectAfter = RectString(camera.pixelRect);
        result.sceneDirtyAfter = scene.isDirty;
        result.sceneSaved = false;
        WriteJson(ProjectPath(SummaryPath), result);
        Debug.Log("BATTLE68 true reference aspect capture status=" + result.status + " sceneDirtyBefore=" + result.sceneDirtyBefore + " sceneDirtyAfter=" + result.sceneDirtyAfter);
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

    private static string ProjectPath(string assetPath)
    {
        return Path.GetFullPath(Path.Combine(Application.dataPath, "..", assetPath));
    }

    private static string RectString(Rect rect)
    {
        return rect.x.ToString("0.######") + "/" + rect.y.ToString("0.######") + "/" + rect.width.ToString("0.######") + "/" + rect.height.ToString("0.######");
    }

    private static void WriteJson(string path, Result result)
    {
        var sb = new StringBuilder();
        sb.Append("{\n");
        Json(sb, "prefix", result.prefix, true);
        Json(sb, "status", result.status, true);
        Json(sb, "sourceScene", result.sourceScene, true);
        Json(sb, "sceneOpened", result.sceneOpened, true);
        Json(sb, "sceneSaved", result.sceneSaved, true);
        Json(sb, "sceneDirtyBefore", result.sceneDirtyBefore, true);
        Json(sb, "sceneDirtyAfter", result.sceneDirtyAfter, true);
        Json(sb, "packageImported", result.packageImported, true);
        Json(sb, "manifestModified", result.manifestModified, true);
        Json(sb, "runtimeInstrumentationUsed", result.runtimeInstrumentationUsed, true);
        Json(sb, "analysisOnlyCropUsedAsFinal", result.analysisOnlyCropUsedAsFinal, true);
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

    private sealed class Result
    {
        public string prefix;
        public string status = "not_started";
        public string sourceScene;
        public bool sceneOpened;
        public bool sceneSaved;
        public bool sceneDirtyBefore;
        public bool sceneDirtyAfter;
        public bool packageImported;
        public bool manifestModified;
        public bool runtimeInstrumentationUsed;
        public bool analysisOnlyCropUsedAsFinal;
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
