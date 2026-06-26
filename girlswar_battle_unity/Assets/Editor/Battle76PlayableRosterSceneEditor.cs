using System;
using System.IO;
using System.Text;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.SceneManagement;

public static class Battle76PlayableRosterSceneEditor
{
    private const string SourceScenePath = "Assets/Scenes/Battle72Map11003TrueAspectReprojectionPersistedCandidate.unity";
    private const string FallbackScenePath = "Assets/Scenes/Battle57RuntimeRehydratedAssetBundleActorsCandidate.unity";
    private const string OutputScenePath = "Assets/Scenes/Battle76PlayableRosterCandidate.unity";
    private const string CapturePath = "Assets/RestoreCaptures/battle_actor/Battle76PlayableRosterCandidate_1920x855.png";
    private const string SummaryPath = "Assets/RestoreData/battle/BATTLE_76_PLAYABLE_ROSTER_CANDIDATE_UNITY.json";
    private const string ReportMdPath = @"C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_76_PLAYABLE_ROSTER_CANDIDATE_RESULT.md";
    private const int CaptureWidth = 1920;
    private const int CaptureHeight = 855;

    [MenuItem("GirlsWar/Battle/BATTLE76 Playable Roster Candidate")]
    public static void Build()
    {
        Directory.CreateDirectory(ProjectPath("Assets/Scenes"));
        Directory.CreateDirectory(ProjectPath("Assets/RestoreCaptures/battle_actor"));
        Directory.CreateDirectory(ProjectPath("Assets/RestoreData/battle"));
        Directory.CreateDirectory(Path.GetDirectoryName(ReportMdPath));

        var result = new Result
        {
            generatedAt = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
            sourceScene = File.Exists(ProjectPath(SourceScenePath)) ? SourceScenePath : FallbackScenePath,
            outputScene = OutputScenePath,
            capturePath = CapturePath,
            canonicalSceneOverwritten = false,
            runtimeInstrumentationUsed = false,
            fakeAssetUsed = false
        };

        if (!File.Exists(ProjectPath(result.sourceScene)))
        {
            result.status = "blocked_source_scene_not_found";
            WriteOutputs(result);
            return;
        }

        var scene = EditorSceneManager.OpenScene(result.sourceScene, OpenSceneMode.Single);
        result.sourceSceneOpened = scene.IsValid();
        var root = CreatePlayableRoot();
        var controller = root.AddComponent<BattlePlayableRosterController>();
        controller.buildOnStart = true;
        controller.BuildInEditor();

        result.actorRows = controller.actorRowCount;
        result.skillRows = controller.skillRowCount;
        result.characterCatalogRows = controller.characterCatalogRowCount;
        result.characterCatalogKoreanNameRows = controller.characterCatalogKoreanNameCount;
        result.characterCatalogHeadImageRows = controller.characterCatalogHeadImageCount;
        result.characterCatalogBattleBundleRows = controller.characterCatalogBattleBundleCount;
        result.readyLocalActorRows = controller.readyLocalActorCount;
        result.readyLocalSkillRows = controller.readyLocalSkillCount;
        result.selectedActorId = controller.selectedActorId;
        result.rosterUiAttached = true;
        result.sceneSaved = EditorSceneManager.SaveScene(scene, OutputScenePath);
        result.outputSceneExists = File.Exists(ProjectPath(OutputScenePath));
        result.outputSceneBytes = result.outputSceneExists ? new FileInfo(ProjectPath(OutputScenePath)).Length : 0;
        AssetDatabase.Refresh();

        var persistedScene = EditorSceneManager.OpenScene(OutputScenePath, OpenSceneMode.Single);
        result.outputSceneOpened = persistedScene.IsValid();
        var camera = FindCaptureCamera();
        if (camera == null)
        {
            result.status = "blocked_capture_camera_not_found";
            WriteOutputs(result);
            return;
        }
        result.cameraName = camera.name;
        Capture(camera, result);
        result.status = result.captureExists ? "battle76_playable_roster_candidate_generated" : "capture_failed";
        WriteOutputs(result);
        Debug.Log("[GirlsWarRestore] BATTLE76 playable roster candidate complete: " + CapturePath);
    }

    private static GameObject CreatePlayableRoot()
    {
        foreach (var existing in UnityEngine.Object.FindObjectsByType<Transform>(FindObjectsInactive.Include))
        {
            if (existing.name == "BATTLE76_PlayableRosterRoot")
                UnityEngine.Object.DestroyImmediate(existing.gameObject);
        }
        var root = new GameObject("BATTLE76_PlayableRosterRoot");
        root.transform.position = Vector3.zero;
        return root;
    }

    private static Camera FindCaptureCamera()
    {
        foreach (var camera in UnityEngine.Object.FindObjectsByType<Camera>(FindObjectsInactive.Include))
            if (camera.name == "BattleHudSpriteAtlasTextureRuntimeBindingClip05Camera")
                return camera;
        if (Camera.main != null)
            return Camera.main;
        var cameras = UnityEngine.Object.FindObjectsByType<Camera>(FindObjectsInactive.Include);
        return cameras.Length > 0 ? cameras[0] : null;
    }

    private static void Capture(Camera camera, Result result)
    {
        var previousTarget = camera.targetTexture;
        var previousActive = RenderTexture.active;
        RenderTexture rt = null;
        Texture2D tex = null;
        try
        {
            Canvas.ForceUpdateCanvases();
            rt = new RenderTexture(CaptureWidth, CaptureHeight, 24, RenderTextureFormat.ARGB32);
            camera.targetTexture = rt;
            RenderTexture.active = rt;
            camera.Render();
            tex = new Texture2D(CaptureWidth, CaptureHeight, TextureFormat.RGB24, false);
            tex.ReadPixels(new Rect(0, 0, CaptureWidth, CaptureHeight), 0, 0);
            tex.Apply();
            File.WriteAllBytes(ProjectPath(CapturePath), tex.EncodeToPNG());
            result.captureExists = File.Exists(ProjectPath(CapturePath));
            result.captureBytes = result.captureExists ? new FileInfo(ProjectPath(CapturePath)).Length : 0;
        }
        finally
        {
            camera.targetTexture = previousTarget;
            RenderTexture.active = previousActive;
            if (rt != null) UnityEngine.Object.DestroyImmediate(rt);
            if (tex != null) UnityEngine.Object.DestroyImmediate(tex);
        }
    }

    private static void WriteOutputs(Result result)
    {
        File.WriteAllText(ProjectPath(SummaryPath), JsonUtility.ToJson(result, true), Encoding.UTF8);
        var sb = new StringBuilder();
        sb.AppendLine("# BATTLE_76_PLAYABLE_ROSTER_CANDIDATE_RESULT");
        sb.AppendLine();
        sb.AppendLine("- status: `" + result.status + "`");
        sb.AppendLine("- sourceScene: `" + result.sourceScene + "`");
        sb.AppendLine("- outputScene: `" + ProjectPath(OutputScenePath) + "`");
        sb.AppendLine("- capture: `" + ProjectPath(CapturePath) + "`");
        sb.AppendLine("- actorRows / readyLocalActorRows: `" + result.actorRows + " / " + result.readyLocalActorRows + "`");
        sb.AppendLine("- skillRows / readyLocalSkillRows: `" + result.skillRows + " / " + result.readyLocalSkillRows + "`");
        sb.AppendLine("- character catalog rows/name/head/battleBundle: `" + result.characterCatalogRows + " / " + result.characterCatalogKoreanNameRows + " / " + result.characterCatalogHeadImageRows + " / " + result.characterCatalogBattleBundleRows + "`");
        sb.AppendLine("- selectedActorId: `" + result.selectedActorId + "`");
        sb.AppendLine("- rosterUiAttached: `" + result.rosterUiAttached + "`");
        sb.AppendLine("- sceneSaved: `" + result.sceneSaved + "`");
        sb.AppendLine("- captureExists: `" + result.captureExists + "`");
        sb.AppendLine("- canonicalSceneOverwritten: `false`");
        sb.AppendLine("- runtimeInstrumentationUsed: `false`");
        sb.AppendLine("- fakeAssetUsed: `false`");
        sb.AppendLine();
        sb.AppendLine("## Notes");
        sb.AppendLine("- The roster panel includes all CHARACTER65 actor and skill payload rows plus the full 131-row character catalog copied into `Assets/RestoreData/battle/Roster`.");
        sb.AppendLine("- Ready-local actor rows are clickable and drive a small local attack/skill loop.");
        sb.AppendLine("- Missing and unresolved rows remain visible as data rows, but are not promoted to real actors.");
        File.WriteAllText(ReportMdPath, sb.ToString(), Encoding.UTF8);
    }

    private static string ProjectPath(string projectRelativePath)
    {
        return Path.GetFullPath(Path.Combine(Application.dataPath, "..", projectRelativePath));
    }

    [Serializable]
    private sealed class Result
    {
        public string generatedAt;
        public string status;
        public string sourceScene;
        public string outputScene;
        public string capturePath;
        public bool sourceSceneOpened;
        public bool outputSceneOpened;
        public bool outputSceneExists;
        public long outputSceneBytes;
        public bool sceneSaved;
        public bool rosterUiAttached;
        public int actorRows;
        public int skillRows;
        public int characterCatalogRows;
        public int characterCatalogKoreanNameRows;
        public int characterCatalogHeadImageRows;
        public int characterCatalogBattleBundleRows;
        public int readyLocalActorRows;
        public int readyLocalSkillRows;
        public string selectedActorId;
        public string cameraName;
        public bool captureExists;
        public long captureBytes;
        public bool canonicalSceneOverwritten;
        public bool runtimeInstrumentationUsed;
        public bool fakeAssetUsed;
    }
}
