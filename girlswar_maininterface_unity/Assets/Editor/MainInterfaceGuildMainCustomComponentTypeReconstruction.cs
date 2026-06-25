using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.UI;

namespace GirlsWarRestore
{
    public static class MainInterfaceGuildMainCustomComponentTypeReconstruction
    {
        private const string PrototypeScenePath = "Assets/Scenes/MainInterface_NavigationPrototype.unity";
        private const string WhiteTraceJsonPath = "Assets/RestoreData/maininterface_guildmain_white_panel_material_shader_runtime_trace.json";
        private const string WhiteTraceCapturePath = "Assets/RestoreCaptures/guildmain_white_panel_trace/UI_GuildMain_1680x720.png";
        private const string CaptureDirectory = "Assets/RestoreCaptures/guildmain_custom_component_type_reconstruction";
        private const string CapturePath = CaptureDirectory + "/UI_GuildMain_1680x720.png";
        private const string OutputJsonPath = "Assets/RestoreData/maininterface_guildmain_custom_component_type_reconstruction.json";
        private const string OutputCsvPath = "Assets/RestoreData/reports/maininterface_guildmain_custom_component_type_reconstruction.csv";

        [Serializable]
        private sealed class ReconstructionSummary
        {
            public string generatedAt;
            public string verdict;
            public string capturePath;
            public string whiteTraceJsonPath;
            public int stubProxyClassCount;
            public int missingScriptObjectCountAfter;
            public int missingScriptComponentCountAfter;
            public int youYouImageComponentCountAfter;
            public int luaComBinderComponentCountAfter;
            public int loopListViewComponentCountAfter;
            public int imageCountAfter;
            public int activeImageCountAfter;
            public int noSpriteImageCountAfter;
            public int whiteNoSpriteImageCountAfter;
            public List<ComponentCountRow> componentTypeCounts;
            public List<MissingScriptRow> missingScriptRows;
            public List<TopBlockerRow> topBlockerRows;
        }

        [Serializable]
        private sealed class ComponentCountRow
        {
            public string typeName;
            public int count;
        }

        [Serializable]
        private sealed class MissingScriptRow
        {
            public string hierarchyPath;
            public int missingScriptCount;
            public string existingMonoBehaviourTypes;
            public string nearbyComponents;
            public bool isTopWhiteBlockerPath;
        }

        [Serializable]
        private sealed class TopBlockerRow
        {
            public string hierarchyPath;
            public int missingScriptCount;
            public string imageType;
            public string spriteName;
            public string monoBehaviourTypes;
        }

        public static void TraceGuildMainCustomComponentTypeReconstruction()
        {
            MainInterfaceGuildMainWhitePanelTrace.TraceGuildMainWhitePanelMaterialShaderRuntime();
            CopyCapture();

            EditorSceneManager.OpenScene(PrototypeScenePath, OpenSceneMode.Single);
            var loader = UnityEngine.Object.FindAnyObjectByType<RestoreNavigationTargetLoader>();
            if (loader == null)
            {
                throw new Exception("GuildMain custom component reconstruction failed: RestoreNavigationTargetLoader missing");
            }

            var success = loader.TryShowTargetKey("jump.OnGameJumpUIGuild", out var result);
            var targetRoot = GameObject.Find("NavigationTargetRoot");
            var instantiated = targetRoot != null && targetRoot.transform.childCount > 0
                ? targetRoot.transform.GetChild(0).gameObject
                : null;
            if (!success || instantiated == null)
            {
                throw new Exception("GuildMain custom component reconstruction failed: UI_GuildMain did not instantiate: " + result.reason);
            }

            var summary = BuildSummary(instantiated);
            WriteOutputs(summary);
            loader.ClearCurrentTarget();
            AssetDatabase.Refresh();
            Debug.Log("[GirlsWarRestore] GuildMain custom component type reconstruction trace completed -> " + OutputJsonPath);
        }

        private static ReconstructionSummary BuildSummary(GameObject root)
        {
            var transforms = root.GetComponentsInChildren<Transform>(true);
            var images = root.GetComponentsInChildren<Image>(true);
            var topBlockerPaths = LoadTopBlockerPaths();
            var missingRows = new List<MissingScriptRow>();
            var componentCounts = new Dictionary<string, int>(StringComparer.Ordinal);

            foreach (var mono in root.GetComponentsInChildren<MonoBehaviour>(true))
            {
                if (mono == null)
                {
                    continue;
                }
                var typeName = mono.GetType().FullName;
                componentCounts[typeName] = componentCounts.TryGetValue(typeName, out var count) ? count + 1 : 1;
            }

            foreach (var transform in transforms)
            {
                var missing = GameObjectUtility.GetMonoBehavioursWithMissingScriptCount(transform.gameObject);
                if (missing <= 0)
                {
                    continue;
                }

                var path = BuildPath(root.transform, transform);
                var monoTypes = transform.gameObject.GetComponents<MonoBehaviour>()
                    .Where(m => m != null)
                    .Select(m => m.GetType().FullName)
                    .OrderBy(v => v, StringComparer.Ordinal)
                    .ToArray();
                var components = transform.gameObject.GetComponents<Component>()
                    .Where(c => c != null)
                    .Select(c => c.GetType().FullName)
                    .OrderBy(v => v, StringComparer.Ordinal)
                    .ToArray();
                missingRows.Add(new MissingScriptRow
                {
                    hierarchyPath = path,
                    missingScriptCount = missing,
                    existingMonoBehaviourTypes = string.Join(";", monoTypes),
                    nearbyComponents = string.Join(";", components),
                    isTopWhiteBlockerPath = topBlockerPaths.Contains(path)
                });
            }

            var topRows = new List<TopBlockerRow>();
            foreach (var path in topBlockerPaths.OrderBy(p => p, StringComparer.Ordinal))
            {
                var target = transforms.FirstOrDefault(t => BuildPath(root.transform, t) == path);
                if (target == null)
                {
                    continue;
                }
                var image = target.GetComponent<Image>();
                var monoTypes = target.GetComponents<MonoBehaviour>()
                    .Where(m => m != null)
                    .Select(m => m.GetType().FullName)
                    .OrderBy(v => v, StringComparer.Ordinal)
                    .ToArray();
                topRows.Add(new TopBlockerRow
                {
                    hierarchyPath = path,
                    missingScriptCount = GameObjectUtility.GetMonoBehavioursWithMissingScriptCount(target.gameObject),
                    imageType = image != null ? image.GetType().FullName : "",
                    spriteName = image != null && image.sprite != null ? image.sprite.name : "",
                    monoBehaviourTypes = string.Join(";", monoTypes)
                });
            }

            var summary = new ReconstructionSummary
            {
                generatedAt = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture),
                verdict = "not_normal: custom type stubs reduce missing scripts but do not execute GuildMain Lua/runtime initialization",
                capturePath = CapturePath,
                whiteTraceJsonPath = WhiteTraceJsonPath,
                stubProxyClassCount = 20,
                missingScriptObjectCountAfter = transforms.Count(t => GameObjectUtility.GetMonoBehavioursWithMissingScriptCount(t.gameObject) > 0),
                missingScriptComponentCountAfter = transforms.Sum(t => GameObjectUtility.GetMonoBehavioursWithMissingScriptCount(t.gameObject)),
                youYouImageComponentCountAfter = root.GetComponentsInChildren<YouYou.YouYouImage>(true).Length,
                luaComBinderComponentCountAfter = root.GetComponentsInChildren<LuaComponentBinder.LuaComBinder>(true).Length,
                loopListViewComponentCountAfter = root.GetComponentsInChildren<SuperScrollView.LoopListView2>(true).Length
                    + root.GetComponentsInChildren<SuperScrollView.LoopStaggeredGridView>(true).Length,
                imageCountAfter = images.Length,
                activeImageCountAfter = images.Count(i => i != null && i.gameObject.activeInHierarchy),
                noSpriteImageCountAfter = images.Count(i => i != null && i.sprite == null),
                whiteNoSpriteImageCountAfter = images.Count(IsWhiteNoSprite),
                componentTypeCounts = componentCounts
                    .OrderByDescending(kvp => kvp.Value)
                    .ThenBy(kvp => kvp.Key, StringComparer.Ordinal)
                    .Select(kvp => new ComponentCountRow { typeName = kvp.Key, count = kvp.Value })
                    .ToList(),
                missingScriptRows = missingRows
                    .OrderByDescending(r => r.isTopWhiteBlockerPath)
                    .ThenByDescending(r => r.missingScriptCount)
                    .ThenBy(r => r.hierarchyPath, StringComparer.Ordinal)
                    .Take(500)
                    .ToList(),
                topBlockerRows = topRows
            };
            return summary;
        }

        private static void CopyCapture()
        {
            Directory.CreateDirectory(CaptureDirectory);
            if (File.Exists(WhiteTraceCapturePath))
            {
                File.Copy(WhiteTraceCapturePath, CapturePath, true);
            }
        }

        private static HashSet<string> LoadTopBlockerPaths()
        {
            var paths = new HashSet<string>(StringComparer.Ordinal);
            var projectRoot = Directory.GetParent(Application.dataPath).FullName;
            var jsonPath = Path.Combine(projectRoot, WhiteTraceJsonPath.Replace('/', Path.DirectorySeparatorChar));
            if (!File.Exists(jsonPath))
            {
                return paths;
            }

            var json = File.ReadAllText(jsonPath, Encoding.UTF8);
            foreach (var match in System.Text.RegularExpressions.Regex.Matches(json, "\"hierarchyPath\"\\s*:\\s*\"([^\"]+)\"").Cast<System.Text.RegularExpressions.Match>())
            {
                var path = match.Groups[1].Value;
                paths.Add(path);
            }
            return paths;
        }

        private static bool IsWhiteNoSprite(Image image)
        {
            if (image == null || image.sprite != null || image.color.a < 0.01f)
            {
                return false;
            }
            return image.color.r > 0.8f && image.color.g > 0.8f && image.color.b > 0.8f;
        }

        private static string BuildPath(Transform root, Transform target)
        {
            var stack = new Stack<string>();
            var current = target;
            while (current != null)
            {
                stack.Push(current.name);
                if (current == root)
                {
                    break;
                }
                current = current.parent;
            }
            return string.Join("/", stack);
        }

        private static void WriteOutputs(ReconstructionSummary summary)
        {
            var projectRoot = Directory.GetParent(Application.dataPath).FullName;
            var jsonPath = Path.Combine(projectRoot, OutputJsonPath.Replace('/', Path.DirectorySeparatorChar));
            var csvPath = Path.Combine(projectRoot, OutputCsvPath.Replace('/', Path.DirectorySeparatorChar));
            Directory.CreateDirectory(Path.GetDirectoryName(jsonPath));
            Directory.CreateDirectory(Path.GetDirectoryName(csvPath));
            File.WriteAllText(jsonPath, JsonUtility.ToJson(summary, true), new UTF8Encoding(false));
            WriteCsv(csvPath, summary);
            AssetDatabase.ImportAsset(OutputJsonPath);
            AssetDatabase.ImportAsset(OutputCsvPath);
        }

        private static void WriteCsv(string path, ReconstructionSummary summary)
        {
            var sb = new StringBuilder();
            sb.AppendLine("kind,hierarchy_path,type_name,count,missing_script_count,existing_mono_behaviour_types,nearby_components,is_top_white_blocker_path,image_type,sprite_name");
            foreach (var row in summary.componentTypeCounts)
            {
                sb.AppendLine(string.Join(",", new[] { "component_type_count", "", row.typeName, row.count.ToString(CultureInfo.InvariantCulture), "", "", "", "", "", "" }.Select(EscapeCsv)));
            }
            foreach (var row in summary.missingScriptRows)
            {
                sb.AppendLine(string.Join(",", new[]
                {
                    "missing_script",
                    row.hierarchyPath,
                    "",
                    "",
                    row.missingScriptCount.ToString(CultureInfo.InvariantCulture),
                    row.existingMonoBehaviourTypes,
                    row.nearbyComponents,
                    row.isTopWhiteBlockerPath ? "1" : "0",
                    "",
                    ""
                }.Select(EscapeCsv)));
            }
            foreach (var row in summary.topBlockerRows)
            {
                sb.AppendLine(string.Join(",", new[]
                {
                    "top_white_blocker",
                    row.hierarchyPath,
                    "",
                    "",
                    row.missingScriptCount.ToString(CultureInfo.InvariantCulture),
                    row.monoBehaviourTypes,
                    "",
                    "1",
                    row.imageType,
                    row.spriteName
                }.Select(EscapeCsv)));
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
