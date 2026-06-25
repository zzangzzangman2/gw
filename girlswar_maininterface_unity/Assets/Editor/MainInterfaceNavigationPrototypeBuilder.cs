using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace GirlsWarRestore
{
    public static class MainInterfaceNavigationPrototypeBuilder
    {
        private const string WireframeScenePath = "Assets/Scenes/MainInterface_Wireframe.unity";
        private const string PrototypeScenePath = "Assets/Scenes/MainInterface_NavigationPrototype.unity";
        private const string ResultJsonPath = "Assets/RestoreData/maininterface_navigation_target_instantiate_result.json";
        private const string ResultCsvPath = "Assets/RestoreData/reports/maininterface_navigation_target_instantiate_result.csv";

        [Serializable]
        private sealed class InstantiateSummary
        {
            public string generatedAt;
            public string scenePath;
            public string sourceScenePath;
            public int activeClickableRows;
            public int targetPrefabResolvedButtonRows;
            public int uniqueTargetCandidates;
            public int loadableTargetCount;
            public int successCount;
            public int failCount;
            public int logOnlyOrUnknownButtonRows;
            public List<RestoreNavigationTargetLoader.InstantiationResult> targets;
        }

        public static void BuildNavigationPrototypeScene()
        {
            if (!File.Exists(WireframeScenePath))
            {
                MainInterfaceSceneBuilder.BuildMainInterfaceScene();
            }

            var scene = EditorSceneManager.OpenScene(WireframeScenePath, OpenSceneMode.Single);
            var canvas = UnityEngine.Object.FindAnyObjectByType<Canvas>();
            if (canvas == null)
            {
                throw new Exception("Navigation prototype build failed: Canvas not found in " + WireframeScenePath);
            }

            RemoveExisting("NavigationPrototypeRuntime");
            RemoveExisting("NavigationTargetRoot");

            var targetRoot = new GameObject("NavigationTargetRoot", typeof(RectTransform));
            targetRoot.transform.SetParent(canvas.transform, false);
            var targetRect = targetRoot.GetComponent<RectTransform>();
            targetRect.anchorMin = Vector2.zero;
            targetRect.anchorMax = Vector2.one;
            targetRect.offsetMin = Vector2.zero;
            targetRect.offsetMax = Vector2.zero;
            targetRect.pivot = new Vector2(0.5f, 0.5f);
            targetRect.localScale = Vector3.one;
            targetRoot.transform.SetAsLastSibling();

            var runtime = new GameObject("NavigationPrototypeRuntime");
            runtime.transform.SetParent(canvas.transform, false);
            var loader = runtime.AddComponent<RestoreNavigationTargetLoader>();
            loader.targetRoot = targetRoot.transform;
            runtime.transform.SetAsLastSibling();

            Directory.CreateDirectory(Path.GetDirectoryName(PrototypeScenePath));
            EditorSceneManager.SaveScene(scene, PrototypeScenePath);
            AssetDatabase.ImportAsset(PrototypeScenePath);
            Debug.Log("[GirlsWarRestore] MainInterface navigation prototype scene generated: " + PrototypeScenePath);
        }

        public static void SmokeTestNavigationPrototype()
        {
            if (!File.Exists(PrototypeScenePath))
            {
                BuildNavigationPrototypeScene();
            }

            EditorSceneManager.OpenScene(PrototypeScenePath, OpenSceneMode.Single);
            var loader = UnityEngine.Object.FindAnyObjectByType<RestoreNavigationTargetLoader>();
            if (loader == null)
            {
                throw new Exception("Navigation prototype smoke test failed: RestoreNavigationTargetLoader not found");
            }

            var results = loader.SmokeTestAllLoadableTargets();
            var summary = new InstantiateSummary
            {
                generatedAt = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture),
                scenePath = PrototypeScenePath,
                sourceScenePath = WireframeScenePath,
                activeClickableRows = loader.ActiveClickableRows,
                targetPrefabResolvedButtonRows = loader.TargetPrefabResolvedButtonRows,
                uniqueTargetCandidates = loader.UniqueTargetCandidates,
                loadableTargetCount = loader.LoadableTargetCount,
                successCount = results.Count(r => r.success),
                failCount = results.Count(r => !r.success),
                logOnlyOrUnknownButtonRows = loader.LogOnlyOrUnknownButtonRows,
                targets = results
            };

            var projectRoot = Directory.GetParent(Application.dataPath).FullName;
            var jsonPath = Path.Combine(projectRoot, ResultJsonPath.Replace('/', Path.DirectorySeparatorChar));
            var csvPath = Path.Combine(projectRoot, ResultCsvPath.Replace('/', Path.DirectorySeparatorChar));
            Directory.CreateDirectory(Path.GetDirectoryName(jsonPath));
            Directory.CreateDirectory(Path.GetDirectoryName(csvPath));
            File.WriteAllText(jsonPath, JsonUtility.ToJson(summary, true), new UTF8Encoding(false));
            WriteCsv(csvPath, results);
            AssetDatabase.ImportAsset(ResultJsonPath);
            AssetDatabase.ImportAsset(ResultCsvPath);

            Debug.Log("[GirlsWarRestore] MainInterface navigation instantiate smoke test: success="
                + summary.successCount + " failed=" + summary.failCount + " -> " + ResultJsonPath);
        }

        private static void RemoveExisting(string name)
        {
            var existing = GameObject.Find(name);
            if (existing != null)
            {
                UnityEngine.Object.DestroyImmediate(existing);
            }
        }

        private static void WriteCsv(string path, List<RestoreNavigationTargetLoader.InstantiationResult> results)
        {
            var sb = new StringBuilder();
            sb.AppendLine("target_key,target_ui_form,prefab_bundle,prefab_root_name,selected_bundle_path,selected_asset_name,success,instantiated_name,target_root_child_count,instantiated_object_count,reason");
            foreach (var r in results)
            {
                var values = new[]
                {
                    r.targetKey,
                    r.targetUiForm,
                    r.prefabBundle,
                    r.prefabRootName,
                    r.selectedBundlePath,
                    r.selectedAssetName,
                    r.success ? "1" : "0",
                    r.instantiatedName,
                    r.targetRootChildCount.ToString(CultureInfo.InvariantCulture),
                    r.instantiatedObjectCount.ToString(CultureInfo.InvariantCulture),
                    r.reason
                };
                sb.AppendLine(string.Join(",", values.Select(EscapeCsv)));
            }
            File.WriteAllText(path, sb.ToString(), new UTF8Encoding(false));
        }

        private static string EscapeCsv(string value)
        {
            value = value ?? "";
            if (value.Contains(",") || value.Contains("\"") || value.Contains("\n") || value.Contains("\r"))
            {
                return "\"" + value.Replace("\"", "\"\"") + "\"";
            }
            return value;
        }
    }
}
