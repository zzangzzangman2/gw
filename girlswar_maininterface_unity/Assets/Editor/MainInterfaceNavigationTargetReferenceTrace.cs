using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using TMPro;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.UI;

namespace GirlsWarRestore
{
    public static class MainInterfaceNavigationTargetReferenceTrace
    {
        private const string PrototypeScenePath = "Assets/Scenes/MainInterface_NavigationPrototype.unity";
        private const string OutputJsonPath = "Assets/RestoreData/maininterface_navigation_target_missing_script_sprite_trace.json";
        private const string OutputCsvPath = "Assets/RestoreData/reports/maininterface_navigation_target_missing_script_sprite_trace.csv";
        private const string AfterTraceCaptureDirectory = "Assets/RestoreCaptures/navigation_targets_after_trace_fix";

        [Serializable]
        private sealed class TraceSummary
        {
            public string generatedAt;
            public string scenePath;
            public int targetCount;
            public int totalImageCount;
            public int totalImageNullSpriteCount;
            public int totalWhiteNoSpriteImageCount;
            public int totalMissingScriptComponentCount;
            public int totalMissingScriptObjectCount;
            public int appliedSpriteSliceFixCount;
            public List<TargetTrace> targets;
        }

        [Serializable]
        private sealed class TargetTrace
        {
            public string targetKey;
            public string targetUiForm;
            public string prefabRootName;
            public bool instantiateSuccess;
            public int instantiatedObjectCount;
            public int rectTransformCount;
            public int imageCount;
            public int imageNullSpriteCount;
            public int imageResolvedSpriteCount;
            public int whiteNoSpriteImageCount;
            public int rawImageCount;
            public int rawImageNullTextureCount;
            public int textCount;
            public int tmpTextCount;
            public int buttonCount;
            public int monoBehaviourCount;
            public int missingScriptComponentCount;
            public int missingScriptObjectCount;
            public int appliedSpriteSliceFixCount;
            public string cleanUnityFsBundlePath;
            public string sourcePrefixCandidate;
            public string blocker;
            public List<ImageTrace> topWhiteAreas;
        }

        [Serializable]
        private sealed class ImageTrace
        {
            public string target;
            public string hierarchyPath;
            public long gameObjectLocalId;
            public long imageComponentLocalId;
            public bool activeInHierarchy;
            public int siblingIndex;
            public float anchorMinX;
            public float anchorMinY;
            public float anchorMaxX;
            public float anchorMaxY;
            public float pivotX;
            public float pivotY;
            public float anchoredPosX;
            public float anchoredPosY;
            public float sizeDeltaX;
            public float sizeDeltaY;
            public float localScaleX;
            public float localScaleY;
            public float localScaleZ;
            public float rectWidth;
            public float rectHeight;
            public float rectArea;
            public bool imageExists;
            public bool spriteNull;
            public string spriteName;
            public long spriteLocalId;
            public string spriteReferenceString;
            public string materialName;
            public long materialLocalId;
            public bool raycastTarget;
            public string color;
            public bool whiteNoSprite;
            public string sourceBundleCandidate;
            public string causeClass;
        }

        public static void TraceMissingScriptsAndSpriteReferences()
        {
            if (!File.Exists(PrototypeScenePath))
            {
                MainInterfaceNavigationPrototypeBuilder.BuildNavigationPrototypeScene();
            }

            EditorSceneManager.OpenScene(PrototypeScenePath);
            var loader = UnityEngine.Object.FindAnyObjectByType<RestoreNavigationTargetLoader>();
            if (loader == null)
            {
                throw new Exception("Trace failed: RestoreNavigationTargetLoader not found");
            }

            var results = loader.SmokeTestAllLoadableTargets();
            var targetTraces = new List<TargetTrace>();
            foreach (var result in results)
            {
                if (!result.success)
                {
                    targetTraces.Add(new TargetTrace
                    {
                        targetKey = result.targetKey,
                        targetUiForm = result.targetUiForm,
                        prefabRootName = result.prefabRootName,
                        instantiateSuccess = false,
                        cleanUnityFsBundlePath = result.selectedBundlePath,
                        blocker = result.reason
                    });
                    continue;
                }

                loader.TryShowTargetKey(result.targetKey, out var liveResult);
                var targetRoot = GameObject.Find("NavigationTargetRoot");
                var instantiated = targetRoot != null && targetRoot.transform.childCount > 0
                    ? targetRoot.transform.GetChild(0).gameObject
                    : null;
                targetTraces.Add(TraceTarget(liveResult, instantiated));
            }
            loader.ClearCurrentTarget();

            var summary = new TraceSummary
            {
                generatedAt = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture),
                scenePath = PrototypeScenePath,
                targetCount = targetTraces.Count,
                totalImageCount = targetTraces.Sum(t => t.imageCount),
                totalImageNullSpriteCount = targetTraces.Sum(t => t.imageNullSpriteCount),
                totalWhiteNoSpriteImageCount = targetTraces.Sum(t => t.whiteNoSpriteImageCount),
                totalMissingScriptComponentCount = targetTraces.Sum(t => t.missingScriptComponentCount),
                totalMissingScriptObjectCount = targetTraces.Sum(t => t.missingScriptObjectCount),
                appliedSpriteSliceFixCount = targetTraces.Sum(t => t.appliedSpriteSliceFixCount),
                targets = targetTraces
            };

            WriteOutputs(summary);
            MainInterfaceNavigationTargetCapture.CaptureNavigationTargetLayoutsTo(
                AfterTraceCaptureDirectory,
                OutputJsonPath.Replace(".json", "_capture.json"),
                OutputCsvPath.Replace(".csv", "_capture.csv"));
            Debug.Log("[GirlsWarRestore] MainInterface navigation missing script/sprite trace: targets="
                + summary.targetCount + " nullSprites=" + summary.totalImageNullSpriteCount
                + " missingScriptComponents=" + summary.totalMissingScriptComponentCount
                + " -> " + OutputJsonPath);
        }

        private static TargetTrace TraceTarget(RestoreNavigationTargetLoader.InstantiationResult result, GameObject instantiated)
        {
            var trace = new TargetTrace
            {
                targetKey = result.targetKey,
                targetUiForm = result.targetUiForm,
                prefabRootName = result.prefabRootName,
                instantiateSuccess = instantiated != null,
                cleanUnityFsBundlePath = result.selectedBundlePath,
                sourcePrefixCandidate = PrefixFromBundle(result.prefabBundle),
                appliedSpriteSliceFixCount = 0
            };

            if (instantiated == null)
            {
                trace.blocker = "instantiated_root_missing";
                return trace;
            }

            trace.instantiatedObjectCount = CountObjects(instantiated.transform);
            trace.rectTransformCount = instantiated.GetComponentsInChildren<RectTransform>(true).Length;
            trace.rawImageCount = instantiated.GetComponentsInChildren<RawImage>(true).Length;
            trace.rawImageNullTextureCount = instantiated.GetComponentsInChildren<RawImage>(true).Count(i => i.texture == null);
            trace.textCount = instantiated.GetComponentsInChildren<Text>(true).Length;
            trace.tmpTextCount = instantiated.GetComponentsInChildren<TMP_Text>(true).Length;
            trace.buttonCount = instantiated.GetComponentsInChildren<Button>(true).Length;
            trace.monoBehaviourCount = instantiated.GetComponentsInChildren<MonoBehaviour>(true).Count(m => m != null);

            var imageTraces = new List<ImageTrace>();
            foreach (var image in instantiated.GetComponentsInChildren<Image>(true))
            {
                imageTraces.Add(TraceImage(trace.prefabRootName, image, instantiated.transform));
            }
            trace.imageCount = imageTraces.Count;
            trace.imageNullSpriteCount = imageTraces.Count(i => i.spriteNull);
            trace.imageResolvedSpriteCount = imageTraces.Count(i => !i.spriteNull);
            trace.whiteNoSpriteImageCount = imageTraces.Count(i => i.whiteNoSprite);

            var transforms = instantiated.GetComponentsInChildren<Transform>(true);
            foreach (var transform in transforms)
            {
                var missing = GameObjectUtility.GetMonoBehavioursWithMissingScriptCount(transform.gameObject);
                if (missing > 0)
                {
                    trace.missingScriptObjectCount++;
                    trace.missingScriptComponentCount += missing;
                }
            }

            trace.topWhiteAreas = imageTraces
                .Where(i => i.whiteNoSprite)
                .OrderByDescending(i => i.rectArea)
                .ThenBy(i => i.hierarchyPath, StringComparer.OrdinalIgnoreCase)
                .Take(30)
                .ToList();
            trace.blocker = trace.whiteNoSpriteImageCount > 0
                ? "white_no_sprite_images_remain; serialized sprite refs are null/missing and need original script-driven binding or explicit sprite pathID evidence"
                : "";
            return trace;
        }

        private static ImageTrace TraceImage(string targetName, Image image, Transform root)
        {
            var rect = image.GetComponent<RectTransform>();
            var serialized = new SerializedObject(image);
            var spriteProperty = serialized.FindProperty("m_Sprite");
            var materialProperty = serialized.FindProperty("m_Material");
            var sprite = image.sprite;
            var material = image.material;
            var width = rect != null ? Mathf.Abs(rect.rect.width) : 0f;
            var height = rect != null ? Mathf.Abs(rect.rect.height) : 0f;
            var whiteNoSprite = sprite == null
                && image.color.a > 0.9f
                && image.color.r > 0.9f
                && image.color.g > 0.9f
                && image.color.b > 0.9f;

            return new ImageTrace
            {
                target = targetName,
                hierarchyPath = BuildPath(root, image.transform),
                gameObjectLocalId = LocalId(image.gameObject),
                imageComponentLocalId = LocalId(image),
                activeInHierarchy = image.gameObject.activeInHierarchy,
                siblingIndex = image.transform.GetSiblingIndex(),
                anchorMinX = rect != null ? rect.anchorMin.x : 0f,
                anchorMinY = rect != null ? rect.anchorMin.y : 0f,
                anchorMaxX = rect != null ? rect.anchorMax.x : 0f,
                anchorMaxY = rect != null ? rect.anchorMax.y : 0f,
                pivotX = rect != null ? rect.pivot.x : 0f,
                pivotY = rect != null ? rect.pivot.y : 0f,
                anchoredPosX = rect != null ? rect.anchoredPosition.x : 0f,
                anchoredPosY = rect != null ? rect.anchoredPosition.y : 0f,
                sizeDeltaX = rect != null ? rect.sizeDelta.x : 0f,
                sizeDeltaY = rect != null ? rect.sizeDelta.y : 0f,
                localScaleX = rect != null ? rect.localScale.x : 0f,
                localScaleY = rect != null ? rect.localScale.y : 0f,
                localScaleZ = rect != null ? rect.localScale.z : 0f,
                rectWidth = width,
                rectHeight = height,
                rectArea = width * height,
                imageExists = true,
                spriteNull = sprite == null,
                spriteName = sprite != null ? sprite.name : "",
                spriteLocalId = sprite != null ? LocalId(sprite) : 0,
                spriteReferenceString = ReferenceInfo(spriteProperty),
                materialName = material != null ? material.name : "",
                materialLocalId = materialProperty != null && materialProperty.objectReferenceValue != null
                    ? LocalId(materialProperty.objectReferenceValue)
                    : 0,
                raycastTarget = image.raycastTarget,
                color = ColorUtility.ToHtmlStringRGBA(image.color),
                whiteNoSprite = whiteNoSprite,
                sourceBundleCandidate = "",
                causeClass = sprite == null
                    ? (string.IsNullOrWhiteSpace(ReferenceInfo(spriteProperty))
                        ? "null_sprite_no_serialized_reference"
                        : "missing_sprite_serialized_reference")
                    : "resolved_sprite"
            };
        }

        private static long LocalId(UnityEngine.Object value)
        {
            return value != null ? Unsupported.GetLocalIdentifierInFile(value.GetInstanceID()) : 0;
        }

        private static string ReferenceInfo(SerializedProperty property)
        {
            if (property == null)
            {
                return "";
            }
            if (property.objectReferenceValue != null)
            {
                return property.objectReferenceValue.name + "#" + property.objectReferenceInstanceIDValue.ToString(CultureInfo.InvariantCulture);
            }
            return property.objectReferenceInstanceIDValue != 0
                ? "missing#" + property.objectReferenceInstanceIDValue.ToString(CultureInfo.InvariantCulture)
                : "";
        }

        private static void WriteOutputs(TraceSummary summary)
        {
            var projectRoot = Directory.GetParent(Application.dataPath).FullName;
            var jsonPath = Path.Combine(projectRoot, OutputJsonPath.Replace('/', Path.DirectorySeparatorChar));
            var csvPath = Path.Combine(projectRoot, OutputCsvPath.Replace('/', Path.DirectorySeparatorChar));
            Directory.CreateDirectory(Path.GetDirectoryName(jsonPath));
            Directory.CreateDirectory(Path.GetDirectoryName(csvPath));
            File.WriteAllText(jsonPath, JsonUtility.ToJson(summary, true), new UTF8Encoding(false));
            WriteCsv(csvPath, summary.targets);
            AssetDatabase.ImportAsset(OutputJsonPath);
            AssetDatabase.ImportAsset(OutputCsvPath);
        }

        private static void WriteCsv(string path, List<TargetTrace> targets)
        {
            var sb = new StringBuilder();
            sb.AppendLine("target,hierarchy_path,game_object_local_id,image_component_local_id,active_in_hierarchy,sibling_index,anchor_min_x,anchor_min_y,anchor_max_x,anchor_max_y,pivot_x,pivot_y,anchored_pos_x,anchored_pos_y,size_delta_x,size_delta_y,local_scale_x,local_scale_y,local_scale_z,rect_width,rect_height,rect_area,sprite_null,sprite_name,sprite_local_id,sprite_reference_string,material_name,material_local_id,raycast_target,color,white_no_sprite,cause_class");
            foreach (var target in targets)
            {
                foreach (var row in target.topWhiteAreas)
                {
                    var values = new[]
                    {
                        row.target,
                        row.hierarchyPath,
                        row.gameObjectLocalId.ToString(CultureInfo.InvariantCulture),
                        row.imageComponentLocalId.ToString(CultureInfo.InvariantCulture),
                        row.activeInHierarchy ? "1" : "0",
                        row.siblingIndex.ToString(CultureInfo.InvariantCulture),
                        Float(row.anchorMinX),
                        Float(row.anchorMinY),
                        Float(row.anchorMaxX),
                        Float(row.anchorMaxY),
                        Float(row.pivotX),
                        Float(row.pivotY),
                        Float(row.anchoredPosX),
                        Float(row.anchoredPosY),
                        Float(row.sizeDeltaX),
                        Float(row.sizeDeltaY),
                        Float(row.localScaleX),
                        Float(row.localScaleY),
                        Float(row.localScaleZ),
                        Float(row.rectWidth),
                        Float(row.rectHeight),
                        Float(row.rectArea),
                        row.spriteNull ? "1" : "0",
                        row.spriteName,
                        row.spriteLocalId.ToString(CultureInfo.InvariantCulture),
                        row.spriteReferenceString,
                        row.materialName,
                        row.materialLocalId.ToString(CultureInfo.InvariantCulture),
                        row.raycastTarget ? "1" : "0",
                        row.color,
                        row.whiteNoSprite ? "1" : "0",
                        row.causeClass
                    };
                    sb.AppendLine(string.Join(",", values.Select(EscapeCsv)));
                }
            }
            File.WriteAllText(path, sb.ToString(), new UTF8Encoding(false));
        }

        private static string BuildPath(Transform root, Transform current)
        {
            var names = new List<string>();
            var walker = current;
            while (walker != null)
            {
                names.Add(walker.name);
                if (walker == root)
                {
                    break;
                }
                walker = walker.parent;
            }
            names.Reverse();
            return string.Join("/", names);
        }

        private static string PrefixFromBundle(string bundle)
        {
            if (string.IsNullOrWhiteSpace(bundle))
            {
                return "";
            }
            var name = Path.GetFileNameWithoutExtension(bundle);
            return name.EndsWith("_ext_prefabs", StringComparison.OrdinalIgnoreCase)
                ? name.Substring(0, name.Length - "_ext_prefabs".Length)
                : name;
        }

        private static int CountObjects(Transform root)
        {
            var count = 1;
            for (var i = 0; i < root.childCount; i++)
            {
                count += CountObjects(root.GetChild(i));
            }
            return count;
        }

        private static string Float(float value)
        {
            return value.ToString("0.###", CultureInfo.InvariantCulture);
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
