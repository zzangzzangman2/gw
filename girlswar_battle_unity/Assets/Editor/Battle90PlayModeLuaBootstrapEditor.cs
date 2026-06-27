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

        private static double startedAt;
        private static bool previousEnterPlayModeOptionsEnabled;
        private static EnterPlayModeOptions previousEnterPlayModeOptions;

        [MenuItem("GirlsWar/Battle/BATTLE90 PlayMode Lua Bootstrap")]
        public static void Verify()
        {
            Directory.CreateDirectory(ProjectPath("Assets/Scenes"));
            Directory.CreateDirectory(RepoPath("reports/battle"));

            EnsureScene();

            previousEnterPlayModeOptionsEnabled = EditorSettings.enterPlayModeOptionsEnabled;
            previousEnterPlayModeOptions = EditorSettings.enterPlayModeOptions;
            EditorSettings.enterPlayModeOptionsEnabled = true;
            EditorSettings.enterPlayModeOptions = EnterPlayModeOptions.DisableDomainReload;

            var resultPath = RepoPath("reports/battle/" + BattlePlayModeBootstrap.DefaultResultFileName);
            if (File.Exists(resultPath)) File.Delete(resultPath);
            BattlePlayModeBootstrap.ConfigureForEditorRun(resultPath, FrameBudget);

            EditorSceneManager.OpenScene(ScenePath, OpenSceneMode.Single);
            startedAt = EditorApplication.timeSinceStartup;

            EditorApplication.update -= OnUpdate;
            EditorApplication.update += OnUpdate;
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
            var path = RepoPath("reports/battle/" + BattlePlayModeBootstrap.DefaultResultFileName);
            Directory.CreateDirectory(Path.GetDirectoryName(path));
            var json =
                "{\n" +
                "  \"generatedAt\": \"" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "\",\n" +
                "  \"status\": \"playmode_bootstrap_timeout\",\n" +
                "  \"playModeEntered\": " + (EditorApplication.isPlaying ? "true" : "false") + ",\n" +
                "  \"frameBudget\": " + FrameBudget + ",\n" +
                "  \"battleEntered\": false,\n" +
                "  \"failedStage\": \"editor_timeout\",\n" +
                "  \"error\": \"BATTLE90 timed out before BattlePlayModeBootstrap.Completed\"\n" +
                "}\n";
            File.WriteAllText(path, json, new UTF8Encoding(false));
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
