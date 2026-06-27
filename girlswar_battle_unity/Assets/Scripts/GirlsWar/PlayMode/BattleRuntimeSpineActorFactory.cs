using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Text;
using Spine;
using Spine.Unity;
using UnityEngine;

#if UNITY_EDITOR
using UnityEditor;
#endif

namespace GirlsWar
{
    public sealed class BattleRuntimeActorHandle : MonoBehaviour
    {
        public Transform Transform { get { return transform; } }
        public SkeletonAnimation SkeletonAnimation;
        public MeshRenderer MeshRenderer;
        public int RequestedHeroId;
        public int RequestedHeroDid;
        public int ResolvedActorId;
        public bool IsExactActor;
        public bool IsSpineActor;
        public bool IsOurHero;
        public string AnimationName = "";
        public string FallbackReason = "";

        private Vector3 baseLocalPosition;
        private Vector3 baseLocalScale = Vector3.one;
        private bool hasBasePose;

        public void RememberBasePose()
        {
            baseLocalPosition = transform.localPosition;
            baseLocalScale = transform.localScale;
            hasBasePose = true;
        }

        public IEnumerator PlayPreviewAction(int actionType, int fireHeroId, int skillDid, int delayFrames)
        {
            if (!hasBasePose)
                RememberBasePose();

            for (var i = 0; i < delayFrames; i++)
                yield return null;

            var isAttack = actionType == 1 || actionType == 2;
            if (isAttack)
                PlayFirstExistingAnimation(actionType == 1 ? new[] { "ult", "skill1", "attack", "stand" } : new[] { "attack", "skill1", "stand" });
            else
                PlayFirstExistingAnimation(new[] { "stand", "idle", "Idle" });

            var target = isAttack ? BattleRuntimeSpineActorFactory.FindNearestOpponent(this) : null;
            var direction = IsOurHero ? 1f : -1f;
            var distance = isAttack ? (actionType == 1 ? 0.92f : 0.68f) : 0.08f;
            var frames = isAttack ? 10 : 8;
            for (var frame = 0; frame < frames; frame++)
            {
                var t = (frame + 1f) / frames;
                var wave = Mathf.Sin(t * Mathf.PI);
                transform.localPosition = baseLocalPosition + new Vector3(direction * distance * wave, 0.08f * wave, 0f);
                transform.localScale = baseLocalScale * (1f + 0.08f * wave);
                if (isAttack && frame == frames / 2 && target != null)
                {
                    StartCoroutine(BattleRuntimeSpineActorFactory.PlayHitSlash(target.transform.position, actionType == 1));
                    target.StartCoroutine(target.PlayHitPulse(actionType == 1));
                }
                yield return null;
            }

            transform.localPosition = baseLocalPosition;
            transform.localScale = baseLocalScale;
            PlayFirstExistingAnimation(new[] { "stand", "idle", "Idle" });
            BattleRuntimeSpineActorFactory.NotePreviewCompleted();
        }

        private IEnumerator PlayHitPulse(bool big)
        {
            if (!hasBasePose)
                RememberBasePose();

            var frames = big ? 12 : 8;
            for (var frame = 0; frame < frames; frame++)
            {
                var t = (frame + 1f) / frames;
                var wave = Mathf.Sin(t * Mathf.PI);
                transform.localPosition = baseLocalPosition + new Vector3((IsOurHero ? -1f : 1f) * 0.08f * wave, 0f, 0f);
                transform.localScale = baseLocalScale * (1f + 0.05f * wave);
                yield return null;
            }

            transform.localPosition = baseLocalPosition;
            transform.localScale = baseLocalScale;
        }

        private bool PlayFirstExistingAnimation(string[] names)
        {
            if (SkeletonAnimation == null || SkeletonAnimation.skeletonDataAsset == null)
                return false;
            var data = SkeletonAnimation.skeletonDataAsset.GetSkeletonData(true);
            if (data == null)
                return false;

            foreach (var name in names)
            {
                if (string.IsNullOrEmpty(name) || data.FindAnimation(name) == null) continue;
                SkeletonAnimation.AnimationName = name;
                AnimationName = name;
                return true;
            }

            return false;
        }
    }

    public static class BattleRuntimeSpineActorFactory
    {
        private const string ActorAssetRoot = "Assets/RestoreData/battle/VisualAssets/actors";
        private static readonly HashSet<int> ImportedActorIds = new HashSet<int> { 1002, 1034, 1100111, 3001, 3006 };
        private static readonly string[] MonsterModelTables =
        {
            "DTMonster_KEntityTableData",
            "DTMonster_OEntityTableData",
            "DTMonsterEntityTableData",
        };
        private static readonly Dictionary<string, AssetBundle> LoadedBundles = new Dictionary<string, AssetBundle>(StringComparer.OrdinalIgnoreCase);
        private static readonly Dictionary<string, MonsterTableCache> MonsterTableCaches = new Dictionary<string, MonsterTableCache>(StringComparer.OrdinalIgnoreCase);
        private static readonly Dictionary<int, MonsterModelResolution> MonsterModelCache = new Dictionary<int, MonsterModelResolution>();
        private static readonly Dictionary<int, BattleRuntimeActorHandle> HandlesByHeroId = new Dictionary<int, BattleRuntimeActorHandle>();
        private static int previewCursor;

        public static int AttachCount { get; private set; }
        public static int PrefabCount { get; private set; }
        public static int SpineCount { get; private set; }
        public static int VisualFallbackCount { get; private set; }
        public static int QuadFallbackCount { get; private set; }
        public static int MissingAssetCount { get; private set; }
        public static int MonsterModelResolveCount { get; private set; }
        public static int PreviewActionCount { get; private set; }
        public static int PreviewCompletedCount { get; private set; }
        public static int PreviewMissCount { get; private set; }
        public static string LastSummary { get; private set; } = "";
        public static string MonsterModelResolveSummary { get; private set; } = "";

        public static void ResetDiagnostics()
        {
            AttachCount = 0;
            PrefabCount = 0;
            SpineCount = 0;
            VisualFallbackCount = 0;
            QuadFallbackCount = 0;
            MissingAssetCount = 0;
            MonsterModelResolveCount = 0;
            PreviewActionCount = 0;
            PreviewCompletedCount = 0;
            PreviewMissCount = 0;
            previewCursor = 0;
            HandlesByHeroId.Clear();
            LastSummary = "";
            MonsterModelResolveSummary = "";
        }

        public static BattleRuntimeActorHandle AttachActor(
            int heroId,
            int heroDid,
            Transform parent,
            bool isOurHero,
            bool isMonster,
            object prefabId)
        {
            AttachCount++;

            var requested = heroDid != 0 ? heroDid : heroId;
            var resolved = ResolveActorId(heroId, heroDid, isMonster, out var resolveReason);
            var exact = resolved == requested || (heroDid == 0 && resolved == heroId);

            var go = new GameObject("B90_RuntimeActor_" + requested + "_as_" + resolved);
            if (parent != null)
                go.transform.SetParent(parent, false);
            go.transform.localPosition = Vector3.zero;
            go.transform.localRotation = Quaternion.identity;
            go.transform.localScale = Vector3.one;

            var handle = go.AddComponent<BattleRuntimeActorHandle>();
            handle.RequestedHeroId = heroId;
            handle.RequestedHeroDid = heroDid;
            handle.ResolvedActorId = resolved;
            handle.IsExactActor = exact;
            handle.IsOurHero = isOurHero;
            handle.FallbackReason = exact
                ? ""
                : !string.IsNullOrEmpty(resolveReason)
                    ? resolveReason
                    : "visual_fallback:" + requested + "->" + resolved;

            if (!exact)
                VisualFallbackCount++;
            if (!string.IsNullOrEmpty(resolveReason) && resolveReason.StartsWith("monster_model:", StringComparison.Ordinal))
            {
                MonsterModelResolveCount++;
                MonsterModelResolveSummary = resolveReason;
            }

            var spineFailure = "";
            if (resolved != 0 && TryAttachPrefab(handle, resolved, isOurHero, out spineFailure))
            {
                PrefabCount++;
                SpineCount++;
                handle.IsSpineActor = true;
                RegisterHandle(handle);
                LastSummary = BuildSummary(handle);
                return handle;
            }

            if (resolved != 0 && TryAttachSpine(handle, resolved, isOurHero, out spineFailure))
            {
                SpineCount++;
                handle.IsSpineActor = true;
                RegisterHandle(handle);
                LastSummary = BuildSummary(handle);
                return handle;
            }

            if (!string.IsNullOrEmpty(spineFailure))
                handle.FallbackReason = AppendReason(handle.FallbackReason, spineFailure);

            if (resolved == 0)
            {
                MissingAssetCount++;
                handle.FallbackReason = AppendReason(handle.FallbackReason, "no_imported_actor_asset");
            }

            AttachTexturedQuad(handle, resolved, isOurHero);
            QuadFallbackCount++;
            RegisterHandle(handle);
            LastSummary = BuildSummary(handle);
            return handle;
        }

        public static bool PreviewAction(int heroId, int actionType, int fireHeroId, int skillDid)
        {
            PreviewActionCount++;
            if (!HandlesByHeroId.TryGetValue(heroId, out var handle) || handle == null)
            {
                PreviewMissCount++;
                return false;
            }

            var delay = Math.Min(96, previewCursor);
            previewCursor++;
            handle.StartCoroutine(handle.PlayPreviewAction(actionType, fireHeroId, skillDid, delay));
            return true;
        }

        internal static void NotePreviewCompleted()
        {
            PreviewCompletedCount++;
        }

        internal static BattleRuntimeActorHandle FindNearestOpponent(BattleRuntimeActorHandle source)
        {
            if (source == null)
                return null;

            BattleRuntimeActorHandle best = null;
            var bestDistance = float.MaxValue;
            foreach (var handle in HandlesByHeroId.Values)
            {
                if (handle == null || handle == source || handle.IsOurHero == source.IsOurHero)
                    continue;

                var distance = Vector3.SqrMagnitude(handle.transform.position - source.transform.position);
                if (distance >= bestDistance)
                    continue;

                best = handle;
                bestDistance = distance;
            }
            return best;
        }

        internal static IEnumerator PlayHitSlash(Vector3 worldPosition, bool big)
        {
            var shader = Shader.Find("Sprites/Default");
            if (shader == null)
                shader = Shader.Find("Legacy Shaders/Particles/Alpha Blended");
            if (shader == null)
                yield break;

            var go = new GameObject(big ? "B90_BigHitSlash" : "B90_HitSlash");
            go.transform.position = worldPosition + new Vector3(0f, 0.72f, -0.25f);
            var line = go.AddComponent<LineRenderer>();
            line.useWorldSpace = false;
            line.positionCount = big ? 5 : 4;
            line.widthMultiplier = big ? 0.12f : 0.08f;
            line.sortingOrder = 500;
            line.material = new Material(shader);
            line.material.color = big ? new Color(1f, 0.18f, 0.82f, 0.95f) : new Color(0.45f, 0.9f, 1f, 0.92f);
            line.SetPosition(0, new Vector3(-0.52f, -0.36f, 0f));
            line.SetPosition(1, new Vector3(-0.12f, 0.08f, 0f));
            line.SetPosition(2, new Vector3(0.28f, 0.34f, 0f));
            line.SetPosition(3, new Vector3(0.58f, 0.48f, 0f));
            if (big)
                line.SetPosition(4, new Vector3(0.82f, 0.62f, 0f));

            var frames = big ? 14 : 10;
            for (var frame = 0; frame < frames; frame++)
            {
                var t = (frame + 1f) / frames;
                var alpha = 1f - t;
                go.transform.localScale = Vector3.one * (0.72f + t * (big ? 1.25f : 0.9f));
                var color = line.material.color;
                color.a = alpha;
                line.material.color = color;
                yield return null;
            }

            UnityEngine.Object.Destroy(go);
        }

        private static void RegisterHandle(BattleRuntimeActorHandle handle)
        {
            if (handle == null) return;
            handle.RememberBasePose();
            if (handle.RequestedHeroId != 0)
                HandlesByHeroId[handle.RequestedHeroId] = handle;
            if (handle.RequestedHeroDid != 0)
                HandlesByHeroId[handle.RequestedHeroDid] = handle;
        }

        private static int ResolveActorId(int heroId, int heroDid, bool isMonster, out string resolveReason)
        {
            resolveReason = "";
            var requested = heroDid != 0 ? heroDid : heroId;
            if (isMonster && TryResolveMonsterModelId(requested, out var modelId, out var sourceMonsterId, out var sourceTable))
            {
                if (modelId != 0 && HasImportedActor(modelId))
                {
                    resolveReason = "monster_model:" + requested + "->" + sourceMonsterId + "/" + sourceTable + "/model_" + modelId;
                    return modelId;
                }
            }

            foreach (var candidate in BuildCandidates(heroId, heroDid, isMonster))
            {
                if (candidate != 0 && HasImportedActor(candidate))
                    return candidate;
            }
            return 0;
        }

        private static IEnumerable<int> BuildCandidates(int heroId, int heroDid, bool isMonster)
        {
            if (heroDid != 0) yield return heroDid;
            if (heroId != 0) yield return heroId;

            var requested = heroDid != 0 ? heroDid : heroId;
            if (requested >= 1100000)
            {
                var baseId = requested - (requested % 10);
                yield return baseId + 1;
                yield return baseId;
            }

            if (isMonster)
                yield return 1100111;
            else
            {
                if (requested == 1036) yield return 1034;
                yield return 1034;
                yield return 1002;
            }
        }

        private static bool HasImportedActor(int actorId)
        {
            return ImportedActorIds.Contains(actorId) || HasLocalPrefabBundle(actorId) || HasImportedSpineAsset(actorId);
        }

        private static bool TryResolveMonsterModelId(int monsterId, out int modelId, out int sourceMonsterId, out string sourceTable)
        {
            modelId = 0;
            sourceMonsterId = 0;
            sourceTable = "";
            if (monsterId == 0)
                return false;

            if (MonsterModelCache.TryGetValue(monsterId, out var cached))
            {
                modelId = cached.ModelId;
                sourceMonsterId = cached.SourceMonsterId;
                sourceTable = cached.SourceTable;
                return modelId != 0;
            }

            foreach (var candidate in BuildMonsterRowCandidates(monsterId))
            {
                foreach (var tableName in MonsterModelTables)
                {
                    if (!TryReadMonsterModelId(tableName, candidate, out var candidateModelId)) continue;
                    modelId = candidateModelId;
                    sourceMonsterId = candidate;
                    sourceTable = tableName;
                    MonsterModelCache[monsterId] = new MonsterModelResolution(modelId, sourceMonsterId, sourceTable);
                    return true;
                }
            }

            MonsterModelCache[monsterId] = new MonsterModelResolution(0, 0, "");
            return false;
        }

        private static IEnumerable<int> BuildMonsterRowCandidates(int monsterId)
        {
            yield return monsterId;
            if (monsterId < 1100000)
                yield break;

            var lastDigitBase = monsterId - (monsterId % 10);
            if (lastDigitBase != monsterId)
                yield return lastDigitBase;

            var stageBase = (monsterId / 100) * 100 + 10;
            if (stageBase != monsterId && stageBase != lastDigitBase)
                yield return stageBase;
        }

        private static bool TryReadMonsterModelId(string tableName, int rowId, out int modelId)
        {
            modelId = 0;
            if (!TryGetMonsterTable(tableName, out var table))
                return false;
            if (!table.Rows.TryGetValue(rowId, out var slice))
                return false;
            if (slice.Begin < 0 || slice.Length <= 0 || slice.Begin + slice.Length > table.Data.Length)
                return false;

            var json = Encoding.UTF8.GetString(table.Data, slice.Begin, slice.Length);
            return TryReadJsonInt(json, "\"modelID\":", out modelId);
        }

        private static bool TryGetMonsterTable(string tableName, out MonsterTableCache table)
        {
            if (MonsterTableCaches.TryGetValue(tableName, out table))
                return table != null;

            table = null;
            var root = Path.Combine(MergedRoot(), "extracted", "config_zips", "download", "config", "monster");
            var headerPath = Path.Combine(root, tableName + "Header.bigd");
            var dataPath = Path.Combine(root, tableName + ".bigd");
            if (!File.Exists(headerPath) || !File.Exists(dataPath))
            {
                MonsterTableCaches[tableName] = null;
                return false;
            }

            var loaded = new MonsterTableCache();
            loaded.Data = File.ReadAllBytes(dataPath);
            var header = Encoding.UTF8.GetString(File.ReadAllBytes(headerPath));
            var entries = header.Split(new[] { ';', '\r', '\n' }, StringSplitOptions.RemoveEmptyEntries);
            foreach (var entry in entries)
            {
                var colon = entry.IndexOf(':');
                if (colon <= 0) continue;
                var comma = entry.IndexOf(',', colon + 1);
                if (comma <= colon + 1) continue;
                if (!int.TryParse(entry.Substring(0, colon), out var id)) continue;
                if (!int.TryParse(entry.Substring(colon + 1, comma - colon - 1), out var begin)) continue;
                if (!int.TryParse(entry.Substring(comma + 1), out var length)) continue;
                loaded.Rows[id] = new DataSlice(begin, length);
            }

            MonsterTableCaches[tableName] = loaded;
            table = loaded;
            return true;
        }

        private static bool TryReadJsonInt(string json, string marker, out int value)
        {
            value = 0;
            if (string.IsNullOrEmpty(json)) return false;
            var start = json.IndexOf(marker, StringComparison.Ordinal);
            if (start < 0) return false;
            start += marker.Length;
            while (start < json.Length && char.IsWhiteSpace(json[start]))
                start++;
            var end = start;
            while (end < json.Length && char.IsDigit(json[end]))
                end++;
            return end > start && int.TryParse(json.Substring(start, end - start), out value);
        }

        private static bool HasLocalPrefabBundle(int actorId)
        {
            var bundlePath = PrefabBundlePath(PrefabModelId(actorId));
            var absolutePath = Path.Combine(BundleRoot(), bundlePath.Replace("/", Path.DirectorySeparatorChar.ToString()));
            return File.Exists(absolutePath);
        }

        private static bool HasImportedSpineAsset(int actorId)
        {
#if UNITY_EDITOR
            return AssetDatabase.LoadAssetAtPath<TextAsset>(ActorPath(actorId, ".atlas.txt")) != null &&
                   AssetDatabase.LoadAssetAtPath<TextAsset>(ActorPath(actorId, ".skel.txt")) != null &&
                   AssetDatabase.LoadAssetAtPath<Texture2D>(ActorPath(actorId, "_texture.png")) != null;
#else
            return false;
#endif
        }

        private static bool TryAttachSpine(BattleRuntimeActorHandle handle, int actorId, bool isOurHero, out string failure)
        {
            failure = "";
#if UNITY_EDITOR
            var atlasText = AssetDatabase.LoadAssetAtPath<TextAsset>(ActorPath(actorId, ".atlas.txt"));
            var skeletonText = AssetDatabase.LoadAssetAtPath<TextAsset>(ActorPath(actorId, ".skel.txt"));
            var textureSource = AssetDatabase.LoadAssetAtPath<Texture2D>(ActorPath(actorId, "_texture.png"));
            if (atlasText == null || skeletonText == null || textureSource == null)
            {
                failure = "missing_spine_import:" + actorId;
                return false;
            }

            try
            {
                var shader = Shader.Find("Spine/Skeleton") ?? Shader.Find("Sprites/Default");
                var material = new Material(shader);
                material.name = "B90_RuntimeSpineMaterial_" + actorId;
                material.mainTexture = textureSource;
                var originalTextureName = textureSource.name;
                textureSource.name = actorId.ToString();
                SpineAtlasAsset atlas;
                try
                {
                    atlas = SpineAtlasAsset.CreateRuntimeInstance(atlasText, new[] { material }, true);
                }
                finally
                {
                    textureSource.name = originalTextureName;
                }
                atlas.name = "B90_RuntimeAtlas_" + actorId;
                var skeletonDataAsset = SkeletonDataAsset.CreateRuntimeInstance(skeletonText, atlas, true, 0.01f);
                skeletonDataAsset.name = "B90_RuntimeSkeletonData_" + actorId;
                var skeletonData = skeletonDataAsset.GetSkeletonData(true);
                if (skeletonData == null)
                {
                    failure = "skeleton_data_null:" + actorId;
                    return false;
                }

                var skeletonAnimation = SkeletonAnimation.AddToGameObject(handle.gameObject, skeletonDataAsset, true);
                skeletonAnimation.loop = true;
                skeletonAnimation.Initialize(true, false);
                var animationName = ChooseAnimation(skeletonData);
                if (!string.IsNullOrEmpty(animationName))
                    skeletonAnimation.AnimationName = animationName;
                skeletonAnimation.Update(0f);
                skeletonAnimation.LateUpdate();

                handle.SkeletonAnimation = skeletonAnimation;
                handle.MeshRenderer = handle.GetComponent<MeshRenderer>();
                handle.AnimationName = animationName ?? "";
                ApplyActorPose(handle.transform, isOurHero, true, actorId);
                return handle.MeshRenderer != null;
            }
            catch (Exception e)
            {
                failure = e.GetType().Name + ":" + e.Message;
                return false;
            }
#else
            failure = "editor_assetdatabase_required";
            return false;
#endif
        }

        private static bool TryAttachPrefab(BattleRuntimeActorHandle handle, int actorId, bool isOurHero, out string failure)
        {
            failure = "";
            if (!TryGetPrefabSpec(actorId, out var bundlePath, out var prefabPath))
            {
                failure = "no_prefab_spec:" + actorId;
                return false;
            }

            var absolutePath = Path.Combine(BundleRoot(), bundlePath.Replace("/", Path.DirectorySeparatorChar.ToString()));
            if (!File.Exists(absolutePath))
            {
                failure = "prefab_bundle_missing:" + absolutePath;
                return false;
            }

            var bundle = GetOrLoadBundle(absolutePath, out failure);
            if (bundle == null)
                return false;

            var prefab = bundle.LoadAsset<GameObject>(prefabPath);
            if (prefab == null)
            {
                foreach (var assetName in bundle.GetAllAssetNames())
                {
                    var lower = assetName.ToLowerInvariant();
                    if (!lower.EndsWith(".prefab") || !lower.Contains("hero_")) continue;
                    prefab = bundle.LoadAsset<GameObject>(assetName);
                    prefabPath = assetName;
                    break;
                }
            }

            if (prefab == null)
            {
                failure = "prefab_not_found:" + prefabPath;
                return false;
            }

            var instance = UnityEngine.Object.Instantiate(prefab, handle.transform, false);
            instance.name = "B90_RuntimePrefabActor_" + actorId;
            instance.transform.localPosition = Vector3.zero;
            instance.transform.localRotation = Quaternion.identity;
            instance.transform.localScale = Vector3.one;

            RebindMaterials(instance);

            var skeletonAnimation = instance.GetComponentInChildren<SkeletonAnimation>(true);
            if (skeletonAnimation == null)
            {
                failure = "prefab_skeleton_animation_missing:" + prefabPath;
                return false;
            }

            skeletonAnimation.Initialize(true, true);
            var skeletonData = skeletonAnimation.skeletonDataAsset != null
                ? skeletonAnimation.skeletonDataAsset.GetSkeletonData(true)
                : null;
            var animationName = ChooseAnimation(skeletonData);
            if (!string.IsNullOrEmpty(animationName))
                skeletonAnimation.AnimationName = animationName;
            skeletonAnimation.Update(0f);
            skeletonAnimation.LateUpdate();

            handle.SkeletonAnimation = skeletonAnimation;
            handle.MeshRenderer = skeletonAnimation.GetComponent<MeshRenderer>() ?? instance.GetComponentInChildren<MeshRenderer>(true);
            handle.AnimationName = animationName ?? "";
            ApplyActorPose(handle.transform, isOurHero, true, actorId);
            NormalizeRendererDepth(handle.transform);
            return handle.MeshRenderer != null;
        }

        private static bool TryGetPrefabSpec(int actorId, out string bundlePath, out string prefabPath)
        {
            var modelId = PrefabModelId(actorId);
            bundlePath = PrefabBundlePath(modelId);
            prefabPath = "assets/download/roleprefabsandres/battleprefabandres/" + modelId + "/hero_" + modelId + ".prefab";
            return File.Exists(Path.Combine(BundleRoot(), bundlePath.Replace("/", Path.DirectorySeparatorChar.ToString()))) ||
                   ImportedActorIds.Contains(actorId);
        }

        private static int PrefabModelId(int actorId)
        {
            return actorId == 1100111 ? 3001 : actorId;
        }

        private static string PrefabBundlePath(int modelId)
        {
            return "download/roleprefabsandres/battleprefabandres/" + modelId + ".assetbundle";
        }

        private static string BundleRoot()
        {
            return Path.GetFullPath(Path.Combine(Application.dataPath, "../../girlswar_merged_extracted/extracted/unity/clean_unityfs_slices"));
        }

        private static string MergedRoot()
        {
            return Path.GetFullPath(Path.Combine(Application.dataPath, "../../girlswar_merged_extracted"));
        }

        private static AssetBundle GetOrLoadBundle(string absolutePath, out string failure)
        {
            failure = "";
            if (LoadedBundles.TryGetValue(absolutePath, out var cached) && cached != null)
                return cached;

            var bundle = AssetBundle.LoadFromFile(absolutePath);
            if (bundle == null)
            {
                failure = "AssetBundle.LoadFromFile_returned_null:" + absolutePath;
                return null;
            }

            LoadedBundles[absolutePath] = bundle;
            return bundle;
        }

        private static void RebindMaterials(GameObject instance)
        {
            if (instance == null) return;
            var fallback = Shader.Find("Spine/Skeleton") ?? Shader.Find("Sprites/Default") ?? Shader.Find("Unlit/Texture");
            foreach (var renderer in instance.GetComponentsInChildren<Renderer>(true))
            {
                var materials = renderer.sharedMaterials;
                for (var i = 0; i < materials.Length; i++)
                {
                    var material = materials[i];
                    if (material == null) continue;
                    var shader = material.shader != null ? Shader.Find(material.shader.name) : null;
                    if (shader == null || !shader.isSupported || shader.passCount <= 0)
                        shader = fallback;
                    if (shader != null)
                        material.shader = shader;
                }
                renderer.sharedMaterials = materials;
            }
        }

        private static string ActorPath(int actorId, string suffix)
        {
            return ActorAssetRoot + "/" + actorId + "/" + actorId + suffix;
        }

        private static string ChooseAnimation(SkeletonData skeletonData)
        {
            if (skeletonData == null) return "";
            var candidates = new[] { "stand", "idle", "Idle", "wait", "run1", "attack", "skill1" };
            foreach (var candidate in candidates)
            {
                if (skeletonData.FindAnimation(candidate) != null)
                    return candidate;
            }

            var animations = skeletonData.Animations;
            if (animations != null && animations.Count > 0 && animations.Items[0] != null)
                return animations.Items[0].Name;
            return "";
        }

        private static void AttachTexturedQuad(BattleRuntimeActorHandle handle, int actorId, bool isOurHero)
        {
            var meshFilter = handle.gameObject.AddComponent<MeshFilter>();
            var meshRenderer = handle.gameObject.AddComponent<MeshRenderer>();
            meshFilter.sharedMesh = BuildQuadMesh();
            meshRenderer.sharedMaterial = BuildQuadMaterial(actorId);
            handle.MeshRenderer = meshRenderer;
            ApplyActorPose(handle.transform, isOurHero, false, actorId);
        }

        private static Mesh BuildQuadMesh()
        {
            var mesh = new Mesh();
            mesh.name = "B90_RuntimeActorQuad";
            mesh.vertices = new[]
            {
                new Vector3(-0.45f, -0.65f, 0f),
                new Vector3(0.45f, -0.65f, 0f),
                new Vector3(-0.45f, 0.65f, 0f),
                new Vector3(0.45f, 0.65f, 0f),
            };
            mesh.uv = new[]
            {
                new Vector2(0f, 0f),
                new Vector2(1f, 0f),
                new Vector2(0f, 1f),
                new Vector2(1f, 1f),
            };
            mesh.triangles = new[] { 0, 2, 1, 2, 3, 1 };
            mesh.RecalculateBounds();
            return mesh;
        }

        private static Material BuildQuadMaterial(int actorId)
        {
            var shader = Shader.Find("Sprites/Default") ?? Shader.Find("Unlit/Texture");
            var material = new Material(shader);
#if UNITY_EDITOR
            if (actorId != 0)
            {
                var texture = AssetDatabase.LoadAssetAtPath<Texture2D>(ActorPath(actorId, "_texture.png"));
                if (texture != null)
                    material.mainTexture = texture;
            }
#endif
            if (material.mainTexture == null)
                material.color = new Color(0.9f, 0.75f, 0.35f, 1f);
            return material;
        }

        private static void ApplyActorPose(Transform transform, bool isOurHero, bool isSpine, int actorId)
        {
            transform.localRotation = Quaternion.identity;
            var scale = isSpine ? 0.46f : 0.75f;
            if (isSpine && actorId >= 3000)
                scale = 0.4f;
            transform.localScale = Vector3.one * scale;
            if (!isOurHero)
            {
                var localScale = transform.localScale;
                localScale.x = -Mathf.Abs(localScale.x);
                transform.localScale = localScale;
            }
        }

        private static void NormalizeRendererDepth(Transform root)
        {
            if (root == null) return;
            var renderers = root.GetComponentsInChildren<Renderer>(true);
            var hasBounds = false;
            var combined = new Bounds();
            foreach (var renderer in renderers)
            {
                if (renderer == null) continue;
                if (!hasBounds)
                {
                    combined = renderer.bounds;
                    hasBounds = true;
                }
                else
                {
                    combined.Encapsulate(renderer.bounds);
                }
            }

            if (!hasBounds) return;
            root.position += new Vector3(0f, 0f, -combined.center.z);
        }

        private static string AppendReason(string current, string reason)
        {
            if (string.IsNullOrEmpty(reason)) return current ?? "";
            if (string.IsNullOrEmpty(current)) return reason;
            return current + "|" + reason;
        }

        private static string BuildSummary(BattleRuntimeActorHandle handle)
        {
            if (handle == null) return "";
            return "requested=" + handle.RequestedHeroDid +
                   " resolved=" + handle.ResolvedActorId +
                   " spine=" + handle.IsSpineActor +
                   " anim=" + handle.AnimationName +
                   " reason=" + handle.FallbackReason;
        }

        private struct DataSlice
        {
            public readonly int Begin;
            public readonly int Length;

            public DataSlice(int begin, int length)
            {
                Begin = begin;
                Length = length;
            }
        }

        private sealed class MonsterTableCache
        {
            public readonly Dictionary<int, DataSlice> Rows = new Dictionary<int, DataSlice>();
            public byte[] Data = new byte[0];
        }

        private struct MonsterModelResolution
        {
            public readonly int ModelId;
            public readonly int SourceMonsterId;
            public readonly string SourceTable;

            public MonsterModelResolution(int modelId, int sourceMonsterId, string sourceTable)
            {
                ModelId = modelId;
                SourceMonsterId = sourceMonsterId;
                SourceTable = sourceTable;
            }
        }
    }
}
