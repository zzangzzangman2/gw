using System;
using System.IO;
using System.Text;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;

namespace GirlsWar
{
    public static class Battle90PlayModeLuaBootstrapEditor
    {
        private const string ScenePath = "Assets/Scenes/Battle90PlayModeLuaBootstrap.unity";
        private const double TimeoutSeconds = 90.0;
        private const int FrameBudget = 240;
        private const int RealAttackProbeFrameBudget = 900;
        private const int RosterExpansionFrameBudget = 360;

        private static double startedAt;
        private static bool previousEnterPlayModeOptionsEnabled;
        private static EnterPlayModeOptions previousEnterPlayModeOptions;
        private static string activeResultFileName = BattlePlayModeBootstrap.DefaultResultFileName;
        private static int activeFrameBudget = FrameBudget;
        private static bool activeUseAttackTaskPreview = true;
        private static bool activeStandingSnapshotOnly;
        private static string activePayloadFileName = BattlePlayModeBootstrap.DefaultPayloadFileName;
        private static readonly int[] RosterExpansionHudCards = { 1005, 1010, 1002, 1003, 1001 };

        [MenuItem("GirlsWar/Battle/BATTLE90 PlayMode Lua Bootstrap")]
        public static void Verify()
        {
            StartRun(BattlePlayModeBootstrap.DefaultResultFileName, FrameBudget, true);
        }

        [MenuItem("GirlsWar/Battle/BATTLE90 Real Attack Task Probe")]
        public static void VerifyRealAttackProbe()
        {
            StartRun(BattlePlayModeBootstrap.RealAttackProbeResultFileName, RealAttackProbeFrameBudget, false);
        }

        [MenuItem("GirlsWar/Battle/BATTLE92 Roster Expansion PlayMode")]
        public static void VerifyRosterExpansionPlayMode()
        {
            StartRun(
                BattlePlayModeBootstrap.RosterExpansionResultFileName,
                RosterExpansionFrameBudget,
                true,
                BattlePlayModeBootstrap.RosterExpansionPayloadFileName,
                RosterExpansionHudCards,
                false);
        }

        [MenuItem("GirlsWar/Battle/BATTLE92 Manual Roster Expansion Play")]
        public static void OpenRosterExpansionManualPlay()
        {
            StartManualPlay(
                BattlePlayModeBootstrap.RosterExpansionResultFileName,
                RosterExpansionFrameBudget,
                true,
                BattlePlayModeBootstrap.RosterExpansionPayloadFileName,
                RosterExpansionHudCards,
                false);
        }

        private static void StartRun(string resultFileName, int frameBudget, bool useAttackTaskPreview)
        {
            StartRun(resultFileName, frameBudget, useAttackTaskPreview, BattlePlayModeBootstrap.DefaultPayloadFileName, null, false);
        }

        private static void StartRun(string resultFileName, int frameBudget, bool useAttackTaskPreview, string payloadFileName, int[] hudCardActorIds)
        {
            StartRun(resultFileName, frameBudget, useAttackTaskPreview, payloadFileName, hudCardActorIds, false);
        }

        private static void StartRun(string resultFileName, int frameBudget, bool useAttackTaskPreview, string payloadFileName, int[] hudCardActorIds, bool standingSnapshotOnly)
        {
            Directory.CreateDirectory(ProjectPath("Assets/Scenes"));
            Directory.CreateDirectory(RepoPath("reports/battle"));

            EnsureScene();

            activeResultFileName = resultFileName;
            activeFrameBudget = frameBudget;
            activeUseAttackTaskPreview = useAttackTaskPreview;
            activeStandingSnapshotOnly = standingSnapshotOnly;
            activePayloadFileName = string.IsNullOrEmpty(payloadFileName) ? BattlePlayModeBootstrap.DefaultPayloadFileName : payloadFileName;

            previousEnterPlayModeOptionsEnabled = EditorSettings.enterPlayModeOptionsEnabled;
            previousEnterPlayModeOptions = EditorSettings.enterPlayModeOptions;
            EditorSettings.enterPlayModeOptionsEnabled = true;
            EditorSettings.enterPlayModeOptions = EnterPlayModeOptions.DisableDomainReload;

            var resultPath = RepoPath("reports/battle/" + activeResultFileName);
            if (File.Exists(resultPath)) File.Delete(resultPath);
            DeleteOldSequenceCaptures(activeResultFileName);
            BattlePlayModeBootstrap.ConfigureForEditorRun(resultPath, activeFrameBudget, activeUseAttackTaskPreview, activePayloadFileName, hudCardActorIds, activeStandingSnapshotOnly);

            EditorSceneManager.OpenScene(ScenePath, OpenSceneMode.Single);
            startedAt = EditorApplication.timeSinceStartup;

            EditorApplication.update -= OnUpdate;
            EditorApplication.update += OnUpdate;
            EditorApplication.EnterPlaymode();
        }

        private static void StartManualPlay(string resultFileName, int frameBudget, bool useAttackTaskPreview, string payloadFileName, int[] hudCardActorIds, bool standingSnapshotOnly)
        {
            Directory.CreateDirectory(ProjectPath("Assets/Scenes"));
            Directory.CreateDirectory(RepoPath("reports/battle"));

            EnsureScene();

            activeResultFileName = resultFileName;
            activeFrameBudget = frameBudget;
            activeUseAttackTaskPreview = useAttackTaskPreview;
            activeStandingSnapshotOnly = standingSnapshotOnly;
            activePayloadFileName = string.IsNullOrEmpty(payloadFileName) ? BattlePlayModeBootstrap.DefaultPayloadFileName : payloadFileName;

            previousEnterPlayModeOptionsEnabled = EditorSettings.enterPlayModeOptionsEnabled;
            previousEnterPlayModeOptions = EditorSettings.enterPlayModeOptions;
            EditorSettings.enterPlayModeOptionsEnabled = true;
            EditorSettings.enterPlayModeOptions = EnterPlayModeOptions.DisableDomainReload;

            var resultPath = RepoPath("reports/battle/" + activeResultFileName);
            BattlePlayModeBootstrap.ConfigureForEditorRun(resultPath, activeFrameBudget, activeUseAttackTaskPreview, activePayloadFileName, hudCardActorIds, activeStandingSnapshotOnly);

            EditorSceneManager.OpenScene(ScenePath, OpenSceneMode.Single);

            EditorApplication.playModeStateChanged -= OnManualPlayModeStateChanged;
            EditorApplication.playModeStateChanged += OnManualPlayModeStateChanged;
            EditorApplication.EnterPlaymode();
        }

        private static void OnUpdate()
        {
            if (EditorApplication.timeSinceStartup - startedAt > TimeoutSeconds)
            {
                WriteTimeout();
                Finish(1);
                return;
            }

            if (!EditorApplication.isPlaying)
                return;

            if (!BattlePlayModeBootstrap.Completed)
                return;

            Finish(BattlePlayModeBootstrap.LastExitCode);
        }

        private static void Finish(int exitCode)
        {
            EditorApplication.update -= OnUpdate;
            RestoreEnterPlayModeSettings();
            if (EditorApplication.isPlaying)
                EditorApplication.ExitPlaymode();
            EditorApplication.Exit(exitCode);
        }

        private static void OnManualPlayModeStateChanged(PlayModeStateChange state)
        {
            if (state != PlayModeStateChange.ExitingPlayMode && state != PlayModeStateChange.EnteredEditMode)
                return;

            EditorApplication.playModeStateChanged -= OnManualPlayModeStateChanged;
            RestoreEnterPlayModeSettings();
        }

        private static void RestoreEnterPlayModeSettings()
        {
            EditorSettings.enterPlayModeOptionsEnabled = previousEnterPlayModeOptionsEnabled;
            EditorSettings.enterPlayModeOptions = previousEnterPlayModeOptions;
        }

        private static void EnsureScene()
        {
            var fullPath = ProjectPath(ScenePath);
            if (File.Exists(fullPath))
            {
                var existing = EditorSceneManager.OpenScene(ScenePath, OpenSceneMode.Single);
                if (UnityEngine.Object.FindAnyObjectByType<BattlePlayModeBootstrap>() == null)
                {
                    var go = new GameObject("Battle90PlayModeLuaBootstrap");
                    go.AddComponent<BattlePlayModeBootstrap>();
                    EditorSceneManager.SaveScene(existing, ScenePath);
                }
                return;
            }

            var scene = EditorSceneManager.NewScene(NewSceneSetup.EmptyScene, NewSceneMode.Single);

            var bootstrap = new GameObject("Battle90PlayModeLuaBootstrap");
            bootstrap.AddComponent<BattlePlayModeBootstrap>();

            var cameraGo = new GameObject("Main Camera");
            cameraGo.tag = "MainCamera";
            var camera = cameraGo.AddComponent<Camera>();
            camera.clearFlags = CameraClearFlags.SolidColor;
            camera.backgroundColor = Color.black;
            camera.orthographic = true;
            camera.orthographicSize = 8f;
            cameraGo.transform.position = new Vector3(0f, 0f, -10f);

            var lightGo = new GameObject("Directional Light");
            var light = lightGo.AddComponent<Light>();
            light.type = LightType.Directional;
            light.intensity = 0.8f;
            lightGo.transform.rotation = Quaternion.Euler(50f, -30f, 0f);

            EditorSceneManager.SaveScene(scene, ScenePath);
            AssetDatabase.Refresh();
        }

        private static void WriteTimeout()
        {
            var path = RepoPath("reports/battle/" + activeResultFileName);
            Directory.CreateDirectory(Path.GetDirectoryName(path));
            var json =
                "{\n" +
                "  \"generatedAt\": \"" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "\",\n" +
                "  \"status\": \"playmode_bootstrap_timeout\",\n" +
                "  \"playModeEntered\": " + (EditorApplication.isPlaying ? "true" : "false") + ",\n" +
                "  \"useAttackTaskPreview\": " + (activeUseAttackTaskPreview ? "true" : "false") + ",\n" +
                "  \"standingSnapshotOnly\": " + (activeStandingSnapshotOnly ? "true" : "false") + ",\n" +
                "  \"frameBudget\": " + activeFrameBudget + ",\n" +
                "  \"payloadFileName\": \"" + activePayloadFileName + "\",\n" +
                "  \"battleEntered\": false,\n" +
                "  \"failedStage\": \"editor_timeout\",\n" +
                "  \"error\": \"BATTLE90 timed out before BattlePlayModeBootstrap.Completed\"\n" +
                "}\n";
            File.WriteAllText(path, json, new UTF8Encoding(false));
        }

        private static void DeleteOldSequenceCaptures(string resultFileName)
        {
            var prefix = SequencePrefixForResult(resultFileName);
            var reportDir = RepoPath("reports/battle");
            if (!Directory.Exists(reportDir))
                return;

            foreach (var path in Directory.GetFiles(reportDir, prefix + "*.png"))
            {
                try { File.Delete(path); } catch { }
            }
        }

        private static string SequencePrefixForResult(string resultFileName)
        {
            if (string.Equals(resultFileName, BattlePlayModeBootstrap.RealAttackProbeResultFileName, StringComparison.OrdinalIgnoreCase))
                return "BATTLE_90_REAL_ATTACK_PROBE_SEQ_";
            if (string.Equals(resultFileName, BattlePlayModeBootstrap.RosterExpansionResultFileName, StringComparison.OrdinalIgnoreCase))
                return "BATTLE_92_ROSTER_EXPANSION_PLAYMODE_SEQ_";
            return "BATTLE_90_PLAYMODE_BOOTSTRAP_SEQ_";
        }

        private static string ProjectPath(string projectRelativePath)
        {
            return Path.GetFullPath(Path.Combine(Application.dataPath, "..", projectRelativePath.Replace("/", "\\")));
        }

        private static string RepoPath(string repoRelativePath)
        {
            return Path.GetFullPath(Path.Combine(Application.dataPath, "..", "..", repoRelativePath.Replace("/", "\\")));
        }
    }
}
