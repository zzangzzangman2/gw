using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using UnityEngine;

namespace GirlsWarRestore
{
    public sealed class RestoreNavigationTargetLoader : MonoBehaviour
    {
        public string probeJsonAssetPath = "Assets/RestoreData/maininterface_navigation_target_load_probe.json";
        public string spriteJoinJsonAssetPath = "Assets/RestoreData/maininterface_navigation_target_sprite_atlas_slice_join.json";
        public Transform targetRoot;

        private ProbeFile probe;
        private SpriteJoinFile spriteJoin;
        private readonly Dictionary<string, TargetEntry> targetByKey = new Dictionary<string, TargetEntry>();
        private readonly Dictionary<string, SpriteJoinTarget> spriteJoinByTargetKey = new Dictionary<string, SpriteJoinTarget>();
        private readonly Dictionary<string, SpriteJoinTarget> spriteJoinByPrefabRootName = new Dictionary<string, SpriteJoinTarget>();
        private readonly List<AssetBundle> currentBundles = new List<AssetBundle>();
        private GameObject currentTarget;

        [Serializable]
        private sealed class ProbeFile
        {
            public string generatedAt;
            public int activeClickableRows;
            public int targetPrefabResolvedButtonRows;
            public int uniqueTargetCandidates;
            public int loadableUniqueTargets;
            public int failedUniqueTargets;
            public int logOnlyOrUnknownButtonRows;
            public List<TargetEntry> targets;
        }

        [Serializable]
        private sealed class TargetEntry
        {
            public string targetUiForm;
            public string targetKey;
            public string prefabBundle;
            public string prefabRootName;
            public string selectedBundlePath;
            public string selectedAssetName;
            public string loadedPrefabName;
            public string status;
        }

        [Serializable]
        private sealed class SpriteJoinFile
        {
            public string generatedAt;
            public List<SpriteJoinTarget> targets;
        }

        [Serializable]
        private sealed class SpriteJoinTarget
        {
            public string targetKey;
            public string targetUiForm;
            public string prefabRootName;
            public List<string> confirmedDependencyCleanUnityFsBundlePaths;
        }

        [Serializable]
        public sealed class InstantiationResult
        {
            public string targetKey;
            public string targetUiForm;
            public string prefabBundle;
            public string prefabRootName;
            public string selectedBundlePath;
            public string selectedAssetName;
            public bool success;
            public string instantiatedName;
            public int targetRootChildCount;
            public int instantiatedObjectCount;
            public int dependencyBundleCandidateCount;
            public int loadedDependencyBundleCount;
            public List<string> loadedDependencyBundlePaths;
            public string reason;
        }

        public int ActiveClickableRows
        {
            get
            {
                EnsureLoaded();
                return probe != null ? probe.activeClickableRows : 0;
            }
        }

        public int TargetPrefabResolvedButtonRows
        {
            get
            {
                EnsureLoaded();
                return probe != null ? probe.targetPrefabResolvedButtonRows : 0;
            }
        }

        public int UniqueTargetCandidates
        {
            get
            {
                EnsureLoaded();
                return probe != null ? probe.uniqueTargetCandidates : 0;
            }
        }

        public int LogOnlyOrUnknownButtonRows
        {
            get
            {
                EnsureLoaded();
                return probe != null ? probe.logOnlyOrUnknownButtonRows : 0;
            }
        }

        public int LoadableTargetCount
        {
            get
            {
                EnsureLoaded();
                return targetByKey.Count;
            }
        }

        public void TryShowFromLogger(RestoreClickLogger logger)
        {
            if (logger == null)
            {
                return;
            }

            if (TryShowTargetKey(logger.navigationTargetKey, out var result))
            {
                Debug.Log("[GirlsWarRestore][NavigationTarget] loaded key=" + result.targetKey
                    + " uiForm=" + result.targetUiForm
                    + " prefab=" + result.instantiatedName
                    + " objects=" + result.instantiatedObjectCount);
            }
            else
            {
                Debug.Log("[GirlsWarRestore][NavigationTarget] log-only key=" + logger.navigationTargetKey
                    + " kind=" + logger.navigationKind
                    + " uiForm=" + logger.navigationTargetUiForm
                    + " reason=" + result.reason);
            }
        }

        public bool TryShowTargetKey(string targetKey, out InstantiationResult result)
        {
            EnsureLoaded();
            result = new InstantiationResult { targetKey = targetKey ?? "", reason = "target_not_loadable_or_not_resolved" };
            if (string.IsNullOrWhiteSpace(targetKey) || !targetByKey.TryGetValue(targetKey, out var target))
            {
                return false;
            }

            result.targetUiForm = target.targetUiForm;
            result.prefabBundle = target.prefabBundle;
            result.prefabRootName = target.prefabRootName;
            result.selectedBundlePath = target.selectedBundlePath;
            result.selectedAssetName = target.selectedAssetName;

            if (target.status != "loadable")
            {
                result.reason = "probe_status_not_loadable";
                return false;
            }

            if (string.IsNullOrWhiteSpace(target.selectedBundlePath) || !File.Exists(target.selectedBundlePath))
            {
                result.reason = "selected_bundle_missing";
                return false;
            }

            ClearCurrentTarget();

            AssetBundle bundle = null;
            try
            {
                result.loadedDependencyBundlePaths = new List<string>();
                var dependencyPaths = ResolveDependencyBundlePaths(target.selectedBundlePath)
                    .Concat(ResolveSpriteJoinDependencyBundlePaths(target))
                    .Distinct(StringComparer.OrdinalIgnoreCase)
                    .ToList();
                result.dependencyBundleCandidateCount = dependencyPaths.Count;
                foreach (var dependencyPath in dependencyPaths)
                {
                    var dependencyBundle = AssetBundle.LoadFromFile(dependencyPath);
                    if (dependencyBundle == null)
                    {
                        continue;
                    }
                    currentBundles.Add(dependencyBundle);
                    result.loadedDependencyBundlePaths.Add(dependencyPath);
                }
                result.loadedDependencyBundleCount = result.loadedDependencyBundlePaths.Count;

                bundle = AssetBundle.LoadFromFile(target.selectedBundlePath);
                if (bundle == null)
                {
                    result.reason = "AssetBundle.LoadFromFile returned null";
                    return false;
                }

                var prefab = !string.IsNullOrWhiteSpace(target.selectedAssetName)
                    ? bundle.LoadAsset<GameObject>(target.selectedAssetName)
                    : null;
                if (prefab == null && !string.IsNullOrWhiteSpace(target.prefabRootName))
                {
                    prefab = bundle.LoadAsset<GameObject>(target.prefabRootName);
                }

                if (prefab == null)
                {
                    result.reason = "prefab_load_returned_null";
                    return false;
                }

                var parent = ResolveTargetRoot();
                currentTarget = Instantiate(prefab, parent, false);
                currentTarget.name = prefab.name + "_NavigationPrototype";

                result.success = true;
                result.instantiatedName = currentTarget.name;
                result.targetRootChildCount = parent.childCount;
                result.instantiatedObjectCount = CountObjects(currentTarget.transform);
                result.reason = "";
                return true;
            }
            catch (Exception ex)
            {
                result.reason = ex.GetType().Name + ": " + ex.Message;
                return false;
            }
            finally
            {
                if (bundle != null)
                {
                    currentBundles.Add(bundle);
                }
            }
        }

        public List<InstantiationResult> SmokeTestAllLoadableTargets()
        {
            EnsureLoaded();
            var results = new List<InstantiationResult>();
            foreach (var target in targetByKey.Values)
            {
                TryShowTargetKey(target.targetKey, out var result);
                results.Add(result);
            }
            ClearCurrentTarget();
            return results;
        }

        public void ClearCurrentTarget()
        {
            if (currentTarget == null)
            {
                return;
            }

            if (Application.isPlaying)
            {
                Destroy(currentTarget);
            }
            else
            {
                DestroyImmediate(currentTarget);
            }
            currentTarget = null;
            for (var i = currentBundles.Count - 1; i >= 0; i--)
            {
                if (currentBundles[i] != null)
                {
                    currentBundles[i].Unload(false);
                }
            }
            currentBundles.Clear();
        }

        private Transform ResolveTargetRoot()
        {
            if (targetRoot != null)
            {
                return targetRoot;
            }

            var existing = GameObject.Find("NavigationTargetRoot");
            if (existing != null)
            {
                targetRoot = existing.transform;
                return targetRoot;
            }

            var created = new GameObject("NavigationTargetRoot", typeof(RectTransform));
            targetRoot = created.transform;
            return targetRoot;
        }

        private void EnsureLoaded()
        {
            if (probe != null)
            {
                return;
            }

            targetByKey.Clear();
            var path = ResolveProjectPath(probeJsonAssetPath);
            if (!File.Exists(path))
            {
                Debug.LogWarning("[GirlsWarRestore][NavigationTarget] probe JSON missing: " + path);
                probe = new ProbeFile { targets = new List<TargetEntry>() };
                return;
            }

            probe = JsonUtility.FromJson<ProbeFile>(File.ReadAllText(path));
            if (probe == null)
            {
                probe = new ProbeFile { targets = new List<TargetEntry>() };
            }
            if (probe.targets == null)
            {
                probe.targets = new List<TargetEntry>();
            }

            foreach (var target in probe.targets)
            {
                if (target == null || target.status != "loadable" || string.IsNullOrWhiteSpace(target.targetKey))
                {
                    continue;
                }
                targetByKey[target.targetKey] = target;
            }

            LoadSpriteJoinEvidence();
        }

        private void LoadSpriteJoinEvidence()
        {
            spriteJoinByTargetKey.Clear();
            spriteJoinByPrefabRootName.Clear();
            var path = ResolveProjectPath(spriteJoinJsonAssetPath);
            if (!File.Exists(path))
            {
                spriteJoin = new SpriteJoinFile { targets = new List<SpriteJoinTarget>() };
                return;
            }

            spriteJoin = JsonUtility.FromJson<SpriteJoinFile>(File.ReadAllText(path));
            if (spriteJoin == null || spriteJoin.targets == null)
            {
                spriteJoin = new SpriteJoinFile { targets = new List<SpriteJoinTarget>() };
                return;
            }

            foreach (var target in spriteJoin.targets)
            {
                if (target == null)
                {
                    continue;
                }
                if (!string.IsNullOrWhiteSpace(target.targetKey))
                {
                    spriteJoinByTargetKey[target.targetKey] = target;
                }
                if (!string.IsNullOrWhiteSpace(target.prefabRootName))
                {
                    spriteJoinByPrefabRootName[target.prefabRootName] = target;
                }
            }
        }

        private static string ResolveProjectPath(string assetPath)
        {
            if (Path.IsPathRooted(assetPath))
            {
                return assetPath;
            }

            var projectRoot = Directory.GetParent(Application.dataPath).FullName;
            return Path.Combine(projectRoot, assetPath.Replace('/', Path.DirectorySeparatorChar));
        }

        private static IEnumerable<string> ResolveDependencyBundlePaths(string selectedBundlePath)
        {
            if (string.IsNullOrWhiteSpace(selectedBundlePath))
            {
                yield break;
            }

            var directory = Path.GetDirectoryName(selectedBundlePath);
            if (string.IsNullOrWhiteSpace(directory) || !Directory.Exists(directory))
            {
                yield break;
            }

            var selectedFullPath = Path.GetFullPath(selectedBundlePath);
            var selectedName = Path.GetFileName(selectedBundlePath);
            var baseName = selectedName;
            if (baseName.EndsWith("_ext_prefabs.assetbundle", StringComparison.OrdinalIgnoreCase))
            {
                baseName = baseName.Substring(0, baseName.Length - "_ext_prefabs.assetbundle".Length);
            }
            else if (baseName.EndsWith(".assetbundle", StringComparison.OrdinalIgnoreCase))
            {
                baseName = baseName.Substring(0, baseName.Length - ".assetbundle".Length);
            }

            var patterns = new[]
            {
                baseName + ".assetbundle",
                baseName + "_ext_*.assetbundle"
            };
            var yielded = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
            foreach (var pattern in patterns)
            {
                foreach (var candidate in Directory.GetFiles(directory, pattern).OrderBy(p => p, StringComparer.OrdinalIgnoreCase))
                {
                    var fullPath = Path.GetFullPath(candidate);
                    var name = Path.GetFileName(candidate);
                    if (string.Equals(fullPath, selectedFullPath, StringComparison.OrdinalIgnoreCase)
                        || name.EndsWith("_ext_prefabs.assetbundle", StringComparison.OrdinalIgnoreCase)
                        || !yielded.Add(fullPath))
                    {
                        continue;
                    }
                    yield return fullPath;
                }
            }
        }

        private IEnumerable<string> ResolveSpriteJoinDependencyBundlePaths(TargetEntry target)
        {
            EnsureLoaded();
            SpriteJoinTarget joinTarget = null;
            if (!string.IsNullOrWhiteSpace(target.targetKey))
            {
                spriteJoinByTargetKey.TryGetValue(target.targetKey, out joinTarget);
            }
            if (joinTarget == null && !string.IsNullOrWhiteSpace(target.prefabRootName))
            {
                spriteJoinByPrefabRootName.TryGetValue(target.prefabRootName, out joinTarget);
            }
            if (joinTarget == null || joinTarget.confirmedDependencyCleanUnityFsBundlePaths == null)
            {
                yield break;
            }

            foreach (var dependencyPath in joinTarget.confirmedDependencyCleanUnityFsBundlePaths)
            {
                if (string.IsNullOrWhiteSpace(dependencyPath) || !File.Exists(dependencyPath))
                {
                    continue;
                }
                yield return Path.GetFullPath(dependencyPath);
            }
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
    }
}
