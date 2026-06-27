using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Text;
using Spine;
using Spine.Unity;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.UI;

#if UNITY_EDITOR
using UnityEditor;
#endif

namespace GirlsWar
{
    internal sealed class BattleRuntimeSkillPreviewSpec
    {
        public bool IsAttack;
        public bool Big;
        public bool SourceBacked;
        public bool TimelineBlocked;
        public int SourceFamilyId;
        public int EffectiveSkillDid;
        public int PrefabId;
        public int FastPrefabId;
        public int EffectShape;
        public int MotionFrames;
        public float DashDistance;
        public float DashLift;
        public float ScalePulse;
        public float LineWidth;
        public float StartScale;
        public float EndScale;
        public Color PrimaryColor;
        public Color SecondaryColor;
        public string BundlePath = "";
        public string AssetPath = "";
        public string PlayablePath = "";
        public string Summary = "";
        public string[] AnimationCandidates = new[] { "stand", "idle", "Idle" };
    }

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

            var spec = BattleRuntimeSpineActorFactory.ResolveSkillPreviewSpec(this, actionType, skillDid);
            var isAttack = spec.IsAttack;
            if (isAttack)
                PlayFirstExistingAnimation(spec.AnimationCandidates);
            else
                PlayFirstExistingAnimation(new[] { "stand", "idle", "Idle" });

            var target = isAttack ? BattleRuntimeSpineActorFactory.FindNearestOpponent(this) : null;
            var direction = IsOurHero ? 1f : -1f;
            var distance = isAttack ? spec.DashDistance : 0.05f;
            if (isAttack && target != null)
                distance = Mathf.Min(distance, Mathf.Max(0.12f, Mathf.Abs(target.transform.position.x - transform.position.x) * 0.22f));
            var frames = isAttack ? spec.MotionFrames : 8;
            for (var frame = 0; frame < frames; frame++)
            {
                var t = (frame + 1f) / frames;
                var wave = Mathf.Sin(t * Mathf.PI);
                transform.localPosition = baseLocalPosition + new Vector3(direction * distance * wave, spec.DashLift * wave, 0f);
                transform.localScale = baseLocalScale * (1f + spec.ScalePulse * wave);
                if (isAttack && frame == frames / 2 && target != null)
                {
                    StartCoroutine(BattleRuntimeSpineActorFactory.PlayHitSlash(target.transform.position, spec));
                    target.StartCoroutine(target.PlayHitPulse(spec.Big));
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
                transform.localPosition = baseLocalPosition + new Vector3((IsOurHero ? -1f : 1f) * 0.055f * wave, 0f, 0f);
                transform.localScale = baseLocalScale * (1f + 0.03f * wave);
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
        private static readonly List<string> SkillSpecTrace = new List<string>();
        private static readonly List<string> SourceSkillPrefabTrace = new List<string>();
        private static int previewCursor;

        public static int AttachCount { get; private set; }
        public static int PrefabCount { get; private set; }
        public static int SpineCount { get; private set; }
        public static int VisualFallbackCount { get; private set; }
        public static int QuadFallbackCount { get; private set; }
        public static int MissingAssetCount { get; private set; }
        public static int MonsterModelResolveCount { get; private set; }
        public static int MonsterModelExactResolveCount { get; private set; }
        public static int MonsterModelBaseFallbackResolveCount { get; private set; }
        public static int MonsterModelMissingExactRowCount { get; private set; }
        public static int PreviewActionCount { get; private set; }
        public static int PreviewCompletedCount { get; private set; }
        public static int PreviewMissCount { get; private set; }
        public static int SourceSkillSpecResolveCount { get; private set; }
        public static int SkillTimelineBlockedCount { get; private set; }
        public static int HitEffectCount { get; private set; }
        public static int SourceSkillPrefabAttemptCount { get; private set; }
        public static int SourceSkillPrefabLoadCount { get; private set; }
        public static int SourceSkillPrefabInstantiateCount { get; private set; }
        public static int SourceSkillPrefabRenderableCount { get; private set; }
        public static int SourceSkillPrefabRendererTotalCount { get; private set; }
        public static int SourceSkillPrefabParticlePlayCount { get; private set; }
        public static int SourceSkillPrefabAnimatorPlayCount { get; private set; }
        public static int SourceSkillPrefabDirectorCount { get; private set; }
        public static int SourceSkillPrefabDirectorPlayedCount { get; private set; }
        public static int SourceSkillPrefabDirectorBlockedCount { get; private set; }
        public static int SourceSkillPrefabPlayableLoadCount { get; private set; }
        public static int SourceSkillCommonEffectInstantiateCount { get; private set; }
        public static int SourceSkillPrefabWorldCutinSuppressedCount { get; private set; }
        public static int SourceSkillPrefabFailureCount { get; private set; }
        public static string LastSummary { get; private set; } = "";
        public static string MonsterModelResolveSummary { get; private set; } = "";
        public static string MonsterModelResolveTraceSummary { get; private set; } = "";
        public static string LastSkillSpecSummary { get; private set; } = "";
        public static string SkillSpecTraceSummary { get { return string.Join("|", SkillSpecTrace.ToArray()); } }
        public static string LastSourceSkillPrefabSummary { get; private set; } = "";
        public static string SourceSkillPrefabTraceSummary { get { return string.Join("|", SourceSkillPrefabTrace.ToArray()); } }

        public static void ResetDiagnostics()
        {
            AttachCount = 0;
            PrefabCount = 0;
            SpineCount = 0;
            VisualFallbackCount = 0;
            QuadFallbackCount = 0;
            MissingAssetCount = 0;
            MonsterModelResolveCount = 0;
            MonsterModelExactResolveCount = 0;
            MonsterModelBaseFallbackResolveCount = 0;
            MonsterModelMissingExactRowCount = 0;
            PreviewActionCount = 0;
            PreviewCompletedCount = 0;
            PreviewMissCount = 0;
            SourceSkillSpecResolveCount = 0;
            SkillTimelineBlockedCount = 0;
            HitEffectCount = 0;
            SourceSkillPrefabAttemptCount = 0;
            SourceSkillPrefabLoadCount = 0;
            SourceSkillPrefabInstantiateCount = 0;
            SourceSkillPrefabRenderableCount = 0;
            SourceSkillPrefabRendererTotalCount = 0;
            SourceSkillPrefabParticlePlayCount = 0;
            SourceSkillPrefabAnimatorPlayCount = 0;
            SourceSkillPrefabDirectorCount = 0;
            SourceSkillPrefabDirectorPlayedCount = 0;
            SourceSkillPrefabDirectorBlockedCount = 0;
            SourceSkillPrefabPlayableLoadCount = 0;
            SourceSkillCommonEffectInstantiateCount = 0;
            SourceSkillPrefabWorldCutinSuppressedCount = 0;
            SourceSkillPrefabFailureCount = 0;
            previewCursor = 0;
            HandlesByHeroId.Clear();
            SkillSpecTrace.Clear();
            SourceSkillPrefabTrace.Clear();
            LastSummary = "";
            MonsterModelResolveSummary = "";
            MonsterModelResolveTraceSummary = "";
            LastSkillSpecSummary = "";
            LastSourceSkillPrefabSummary = "";
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
                    : resolved == 0
                        ? "missing_actor_asset:" + requested
                        : "visual_fallback:" + requested + "->" + resolved;

            if (!exact && resolved != 0)
                VisualFallbackCount++;
            if (!string.IsNullOrEmpty(resolveReason) && resolveReason.StartsWith("monster_model_", StringComparison.Ordinal))
            {
                MonsterModelResolveCount++;
                MonsterModelResolveSummary = resolveReason;
                if (!string.IsNullOrEmpty(MonsterModelResolveTraceSummary))
                    MonsterModelResolveTraceSummary += "|";
                MonsterModelResolveTraceSummary += resolveReason;
                if (resolveReason.StartsWith("monster_model_exact:", StringComparison.Ordinal))
                {
                    MonsterModelExactResolveCount++;
                }
                else if (resolveReason.StartsWith("monster_model_base_fallback:", StringComparison.Ordinal))
                {
                    MonsterModelBaseFallbackResolveCount++;
                    MonsterModelMissingExactRowCount++;
                }
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
                RegisterHandle(handle);
                LastSummary = BuildSummary(handle);
                return handle;
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

        internal static BattleRuntimeSkillPreviewSpec ResolveSkillPreviewSpec(BattleRuntimeActorHandle handle, int actionType, int skillDid)
        {
            var spec = BuildSkillPreviewSpec(handle, actionType, skillDid);
            if (spec.SourceBacked)
                SourceSkillSpecResolveCount++;
            if (spec.TimelineBlocked)
                SkillTimelineBlockedCount++;

            LastSkillSpecSummary = spec.Summary;
            if (SkillSpecTrace.Count < 16)
                SkillSpecTrace.Add(spec.Summary);
            return spec;
        }

        internal static IEnumerator PlayHitSlash(Vector3 worldPosition, BattleRuntimeSkillPreviewSpec spec)
        {
            if (spec == null)
                yield break;

            HitEffectCount++;
            var shader = Shader.Find("Sprites/Default");
            if (shader == null)
                shader = Shader.Find("Legacy Shaders/Particles/Alpha Blended");
            if (shader == null)
                yield break;

            var sourcePrefab = TryPlaySourceSkillPrefab(worldPosition, spec);
            var go = new GameObject(spec.Big ? "B90_SourceBackedBigHit_" + spec.EffectiveSkillDid : "B90_SourceBackedHit_" + spec.EffectiveSkillDid);
            go.transform.position = worldPosition + new Vector3(0f, spec.Big ? 0.78f : 0.66f, -0.25f);
            var line = go.AddComponent<LineRenderer>();
            line.useWorldSpace = false;
            var points = SkillEffectPoints(spec);
            line.positionCount = points.Length;
            line.widthMultiplier = spec.LineWidth;
            line.sortingOrder = 500;
            line.material = new Material(shader);
            line.material.color = Color.white;
            line.startColor = spec.PrimaryColor;
            line.endColor = spec.SecondaryColor;
            for (var i = 0; i < points.Length; i++)
                line.SetPosition(i, points[i]);

            var frames = spec.Big ? 14 : 10;
            for (var frame = 0; frame < frames; frame++)
            {
                var t = (frame + 1f) / frames;
                var alpha = 1f - t;
                go.transform.localScale = Vector3.one * Mathf.Lerp(spec.StartScale, spec.EndScale, t);
                var start = spec.PrimaryColor;
                var end = spec.SecondaryColor;
                start.a *= alpha;
                end.a *= alpha;
                line.startColor = start;
                line.endColor = end;
                yield return null;
            }

            UnityEngine.Object.Destroy(go);
            if (sourcePrefab != null)
                UnityEngine.Object.Destroy(sourcePrefab);
        }

        private static GameObject TryPlaySourceSkillPrefab(Vector3 worldPosition, BattleRuntimeSkillPreviewSpec spec)
        {
            SourceSkillPrefabAttemptCount++;
            if (spec == null || !spec.SourceBacked || string.IsNullOrEmpty(spec.BundlePath))
                return null;

            var absolutePath = Path.Combine(BundleRoot(), spec.BundlePath.Replace("/", Path.DirectorySeparatorChar.ToString()));
            if (!File.Exists(absolutePath))
            {
                NoteSourceSkillPrefabFailure("missing_bundle:" + spec.BundlePath);
                return null;
            }

            var bundle = GetOrLoadBundle(absolutePath, out var failure);
            if (bundle == null)
            {
                NoteSourceSkillPrefabFailure(failure);
                return null;
            }

            var assetPath = "";
            var prefabId = 0;
            var prefab = LoadSkillPrefab(bundle, spec, out assetPath, out prefabId);
            if (prefab == null)
            {
                NoteSourceSkillPrefabFailure("missing_prefab:" + spec.AssetPath);
                return null;
            }

            SourceSkillPrefabLoadCount++;
            var root = new GameObject("B90_SourceSkillPrefabRoot_" + prefabId);
            root.transform.position = worldPosition + new Vector3(0f, spec.Big ? 0.72f : 0.58f, -0.32f);
            root.transform.localRotation = Quaternion.identity;
            root.transform.localScale = Vector3.one;

            var instance = UnityEngine.Object.Instantiate(prefab, root.transform, false);
            instance.name = "B90_SourceSkillPrefab_" + prefabId;
            instance.transform.localPosition = Vector3.zero;
            instance.transform.localRotation = Quaternion.identity;
            instance.transform.localScale = Vector3.one;
            SourceSkillPrefabInstantiateCount++;

            ActivateHierarchy(instance);
            RebindMaterials(instance);

            var playableLoaded = AssignPlayableAssets(bundle, instance, spec, prefabId);
            var directorCount = PlayDirectors(instance);
            var animatorCount = PlayAnimators(instance);
            var particleCount = PlayParticles(instance);
            var suppressedCutinCount = SuppressWorldCutinRenderers(instance);
            var rendererCount = PrepareSourceSkillRenderers(instance);
            var commonEffectRendererCount = 0;
            if (rendererCount == 0)
            {
                var commonEffect = TryAttachCommonSourceSkillEffect(root.transform, spec);
                if (commonEffect != null)
                {
                    ActivateHierarchy(commonEffect);
                    RebindMaterials(commonEffect);
                    animatorCount += PlayAnimators(commonEffect);
                    particleCount += PlayParticles(commonEffect);
                    commonEffectRendererCount = PrepareSourceSkillRenderers(commonEffect);
                    rendererCount += commonEffectRendererCount;
                }
            }
            NormalizeSourceSkillEffect(root, root, worldPosition, spec);

            SourceSkillPrefabPlayableLoadCount += playableLoaded;
            SourceSkillPrefabDirectorCount += directorCount.Total;
            SourceSkillPrefabDirectorPlayedCount += directorCount.Played;
            SourceSkillPrefabDirectorBlockedCount += directorCount.Blocked;
            SourceSkillPrefabAnimatorPlayCount += animatorCount;
            SourceSkillPrefabParticlePlayCount += particleCount;
            SourceSkillPrefabWorldCutinSuppressedCount += suppressedCutinCount;
            SourceSkillPrefabRendererTotalCount += rendererCount;
            if (rendererCount > 0)
                SourceSkillPrefabRenderableCount++;

            var summary =
                "skill=" + spec.EffectiveSkillDid +
                " prefab=" + prefabId +
                " asset=" + assetPath +
                " renderers=" + rendererCount +
                " particles=" + particleCount +
                " animators=" + animatorCount +
                " directors=" + directorCount.Total +
                " directorPlayed=" + directorCount.Played +
                " directorBlocked=" + directorCount.Blocked +
                " playableLoaded=" + playableLoaded +
                " commonEffect=" + commonEffectRendererCount +
                " worldCutinSuppressed=" + suppressedCutinCount;
            LastSourceSkillPrefabSummary = summary;
            if (SourceSkillPrefabTrace.Count < 16)
                SourceSkillPrefabTrace.Add(summary);

            return root;
        }

        private static GameObject LoadSkillPrefab(AssetBundle bundle, BattleRuntimeSkillPreviewSpec spec, out string assetPath, out int prefabId)
        {
            assetPath = "";
            prefabId = 0;
            foreach (var candidateId in SkillPrefabCandidates(spec))
            {
                var candidatePath = "assets/download/skillprefabsandres/" + spec.SourceFamilyId + "/" + candidateId + ".prefab";
                var prefab = bundle.LoadAsset<GameObject>(candidatePath);
                if (prefab != null)
                {
                    assetPath = candidatePath;
                    prefabId = candidateId;
                    return prefab;
                }
            }

            foreach (var name in bundle.GetAllAssetNames())
            {
                var lower = name.ToLowerInvariant();
                if (!lower.EndsWith(".prefab")) continue;
                if (!lower.Contains("/" + spec.SourceFamilyId + "/")) continue;
                var prefab = bundle.LoadAsset<GameObject>(name);
                if (prefab == null) continue;
                assetPath = name;
                prefabId = ParseTrailingInt(Path.GetFileNameWithoutExtension(name));
                return prefab;
            }

            return null;
        }

        private static GameObject TryAttachCommonSourceSkillEffect(Transform parent, BattleRuntimeSkillPreviewSpec spec)
        {
            if (parent == null || spec == null)
                return null;

            var absolutePath = Path.Combine(
                BundleRoot(),
                "download/commonprefabsandres/skilleffect/commonskillprefabsandres1.assetbundle".Replace("/", Path.DirectorySeparatorChar.ToString()));
            if (!File.Exists(absolutePath))
                return null;

            var bundle = GetOrLoadBundle(absolutePath, out _);
            if (bundle == null)
                return null;

            var prefab = LoadCommonSourceSkillEffectPrefab(bundle, spec, out var assetPath);
            if (prefab == null)
                return null;

            var instance = UnityEngine.Object.Instantiate(prefab, parent, false);
            instance.name = "B90_CommonSourceSkillEffect_" + spec.SourceFamilyId + "_" + spec.EffectiveSkillDid;
            instance.transform.localPosition = new Vector3(0f, spec.Big ? 0.1f : 0.04f, -0.02f);
            instance.transform.localRotation = Quaternion.identity;
            instance.transform.localScale = Vector3.one * (spec.Big ? 0.68f : 0.52f);
            SourceSkillCommonEffectInstantiateCount++;
            LastSourceSkillPrefabSummary = "common_effect:" + assetPath;
            return instance;
        }

        private static GameObject LoadCommonSourceSkillEffectPrefab(AssetBundle bundle, BattleRuntimeSkillPreviewSpec spec, out string assetPath)
        {
            assetPath = "";
            foreach (var candidate in CommonSourceSkillEffectCandidates(spec))
            {
                var prefab = bundle.LoadAsset<GameObject>(candidate);
                if (prefab == null)
                    continue;
                assetPath = candidate;
                return prefab;
            }

            var familyHint = CommonSourceSkillEffectFamilyName(spec);
            foreach (var name in bundle.GetAllAssetNames())
            {
                var lower = name.ToLowerInvariant();
                if (!lower.EndsWith(".prefab")) continue;
                if (!string.IsNullOrEmpty(familyHint) && !lower.Contains(familyHint)) continue;
                var prefab = bundle.LoadAsset<GameObject>(name);
                if (prefab == null) continue;
                assetPath = name;
                return prefab;
            }

            return null;
        }

        private static IEnumerable<string> CommonSourceSkillEffectCandidates(BattleRuntimeSkillPreviewSpec spec)
        {
            var root = "assets/download/commonprefabsandres/skilleffect/commonskillprefabsandres1/";
            switch (CommonSourceSkillEffectFamilyName(spec))
            {
                case "pinkspeedline":
                    yield return root + "pinkspeedline/pinkspeedline.prefab";
                    break;
                case "yellospeedline":
                    yield return root + "yellospeedline/yellospeedline.prefab";
                    yield return root + "yellospeedline/yellowspeedline.prefab";
                    break;
                case "redspeedline":
                    yield return root + "redspeedline/redspeedline.prefab";
                    yield return root + "redspeedline/bluespeedlines03.prefab";
                    yield return root + "redspeedline/redspeedlines03.prefab";
                    break;
            }
        }

        private static string CommonSourceSkillEffectFamilyName(BattleRuntimeSkillPreviewSpec spec)
        {
            if (spec == null)
                return "";
            if (spec.SourceFamilyId == 1002)
                return "pinkspeedline";
            if (spec.SourceFamilyId == 1012)
                return "redspeedline";
            return "yellospeedline";
        }

        private static IEnumerable<int> SkillPrefabCandidates(BattleRuntimeSkillPreviewSpec spec)
        {
            if (spec.FastPrefabId != 0)
                yield return spec.FastPrefabId;
            if (spec.PrefabId != 0)
                yield return spec.PrefabId;
            if (spec.EffectiveSkillDid != 0 && spec.EffectiveSkillDid != spec.PrefabId)
                yield return spec.EffectiveSkillDid;
        }

        private static int AssignPlayableAssets(AssetBundle bundle, GameObject instance, BattleRuntimeSkillPreviewSpec spec, int prefabId)
        {
            if (bundle == null || instance == null)
                return 0;

            var loaded = 0;
            var playable = LoadSkillPlayable(bundle, spec, prefabId);
            if (playable == null)
                return 0;

            foreach (var director in instance.GetComponentsInChildren<PlayableDirector>(true))
            {
                if (director == null || director.playableAsset != null)
                    continue;
                director.playableAsset = playable;
                loaded++;
            }

            return loaded;
        }

        private static PlayableAsset LoadSkillPlayable(AssetBundle bundle, BattleRuntimeSkillPreviewSpec spec, int prefabId)
        {
            foreach (var candidateId in SkillPlayableCandidates(spec, prefabId))
            {
                var candidatePath = "assets/download/skillprefabsandres/" + spec.SourceFamilyId + "/" + candidateId + ".playable";
                var playable = bundle.LoadAsset<PlayableAsset>(candidatePath);
                if (playable != null)
                    return playable;
            }

            foreach (var name in bundle.GetAllAssetNames())
            {
                var lower = name.ToLowerInvariant();
                if (!lower.EndsWith(".playable")) continue;
                if (!lower.Contains("/" + spec.SourceFamilyId + "/")) continue;
                var playable = bundle.LoadAsset<PlayableAsset>(name);
                if (playable != null)
                    return playable;
            }

            return null;
        }

        private static IEnumerable<int> SkillPlayableCandidates(BattleRuntimeSkillPreviewSpec spec, int prefabId)
        {
            if (prefabId != 0)
                yield return prefabId;
            if (spec.FastPrefabId != 0 && spec.FastPrefabId != prefabId)
                yield return spec.FastPrefabId;
            if (spec.PrefabId != 0 && spec.PrefabId != prefabId)
                yield return spec.PrefabId;
            if (spec.EffectiveSkillDid != 0 && spec.EffectiveSkillDid != prefabId)
                yield return spec.EffectiveSkillDid;
        }

        private static SourceSkillDirectorPlayCount PlayDirectors(GameObject instance)
        {
            var count = new SourceSkillDirectorPlayCount();
            if (instance == null)
                return count;

            foreach (var director in instance.GetComponentsInChildren<PlayableDirector>(true))
            {
                if (director == null) continue;
                count.Total++;
                director.enabled = true;
                director.time = 0;
                if (director.playableAsset == null)
                {
                    count.Blocked++;
                    continue;
                }

                try
                {
                    director.Evaluate();
                    director.Play();
                    director.Evaluate();
                    count.Played++;
                }
                catch
                {
                    count.Blocked++;
                }
            }

            return count;
        }

        private static int PlayAnimators(GameObject instance)
        {
            var count = 0;
            if (instance == null)
                return count;

            foreach (var animator in instance.GetComponentsInChildren<Animator>(true))
            {
                if (animator == null) continue;
                animator.enabled = true;
                animator.speed = 1f;
                try
                {
                    animator.Rebind();
                    animator.Update(0.016f);
                    count++;
                }
                catch
                {
                    // Some restored controllers are intentionally incomplete; keep the prefab visible anyway.
                }
            }

            foreach (var animation in instance.GetComponentsInChildren<UnityEngine.Animation>(true))
            {
                if (animation == null) continue;
                animation.enabled = true;
                try
                {
                    foreach (UnityEngine.AnimationState state in animation)
                    {
                        if (state == null || string.IsNullOrEmpty(state.name)) continue;
                        animation.Play(state.name);
                        count++;
                        break;
                    }
                }
                catch
                {
                }
            }

            return count;
        }

        private static int PlayParticles(GameObject instance)
        {
            var count = 0;
            if (instance == null)
                return count;

            foreach (var particle in instance.GetComponentsInChildren<ParticleSystem>(true))
            {
                if (particle == null) continue;
                try
                {
                    particle.Clear(true);
                    particle.Play(true);
                    particle.Simulate(0.18f, true, false, true);
                    count++;
                }
                catch
                {
                }
            }

            return count;
        }

        private static int PrepareSourceSkillRenderers(GameObject instance)
        {
            var count = 0;
            if (instance == null)
                return count;

            foreach (var renderer in instance.GetComponentsInChildren<Renderer>(true))
            {
                if (renderer == null || !renderer.enabled) continue;
                renderer.enabled = true;
                renderer.sortingOrder = Math.Max(renderer.sortingOrder, 540);
                count++;
            }

            return count;
        }

        private static int SuppressWorldCutinRenderers(GameObject instance)
        {
            var count = 0;
            if (instance == null)
                return count;

            foreach (var canvas in instance.GetComponentsInChildren<Canvas>(true))
            {
                if (canvas == null) continue;
                canvas.enabled = false;
                count++;
            }

            foreach (var graphic in instance.GetComponentsInChildren<Graphic>(true))
            {
                if (graphic == null) continue;
                graphic.enabled = false;
                count++;
            }

            foreach (var renderer in instance.GetComponentsInChildren<SpriteRenderer>(true))
            {
                if (renderer == null || !renderer.enabled) continue;
                if (!LooksLikeWorldCutin(renderer))
                    continue;
                renderer.enabled = false;
                count++;
            }

            return count;
        }

        private static bool LooksLikeWorldCutin(SpriteRenderer renderer)
        {
            if (renderer == null)
                return false;

            var path = HierarchyPath(renderer.transform).ToLowerInvariant();
            if (path.Contains("rolebig") ||
                path.Contains("painting") ||
                path.Contains("bigset") ||
                path.Contains("cutin") ||
                path.Contains("portrait") ||
                path.Contains("head") ||
                path.Contains("live2d") ||
                path.Contains("video"))
                return true;

            var sprite = renderer.sprite;
            var texture = sprite != null ? sprite.texture : null;
            var textureLooksLikePortrait = texture != null && (texture.width >= 512 || texture.height >= 512);
            var bounds = renderer.bounds;
            var boundsLookLikeScreenArt = bounds.size.x >= 2.6f || bounds.size.y >= 2.6f;
            return textureLooksLikePortrait && boundsLookLikeScreenArt;
        }

        private static string HierarchyPath(Transform transform)
        {
            if (transform == null)
                return "";

            var names = new List<string>();
            while (transform != null)
            {
                names.Add(transform.name ?? "");
                transform = transform.parent;
            }

            names.Reverse();
            return string.Join("/", names.ToArray());
        }

        private static void NormalizeSourceSkillEffect(GameObject root, GameObject instance, Vector3 targetWorldPosition, BattleRuntimeSkillPreviewSpec spec)
        {
            if (root == null || instance == null)
                return;

            if (!TryCollectRendererBounds(instance, out var bounds))
                return;

            var maxSize = Mathf.Max(bounds.size.x, bounds.size.y);
            if (maxSize > 0.01f)
            {
                var desired = spec.Big ? 1.65f : 1.18f;
                var factor = Mathf.Clamp(desired / maxSize, 0.08f, 5.5f);
                root.transform.localScale = root.transform.localScale * factor;
            }

            if (TryCollectRendererBounds(instance, out bounds))
            {
                var desiredCenter = targetWorldPosition + new Vector3(0f, spec.Big ? 0.76f : 0.62f, -0.32f);
                root.transform.position += desiredCenter - bounds.center;
            }
        }

        private static bool TryCollectRendererBounds(GameObject instance, out Bounds bounds)
        {
            bounds = new Bounds();
            var has = false;
            if (instance == null)
                return false;

            foreach (var renderer in instance.GetComponentsInChildren<Renderer>(true))
            {
                if (renderer == null || !renderer.enabled) continue;
                if (!has)
                {
                    bounds = renderer.bounds;
                    has = true;
                }
                else
                {
                    bounds.Encapsulate(renderer.bounds);
                }
            }

            return has;
        }

        private static void ActivateHierarchy(GameObject instance)
        {
            if (instance == null)
                return;

            foreach (var transform in instance.GetComponentsInChildren<Transform>(true))
            {
                if (transform == null || transform.gameObject == null) continue;
                transform.gameObject.SetActive(true);
            }
        }

        private static void NoteSourceSkillPrefabFailure(string reason)
        {
            SourceSkillPrefabFailureCount++;
            LastSourceSkillPrefabSummary = reason ?? "";
            if (SourceSkillPrefabTrace.Count < 16)
                SourceSkillPrefabTrace.Add(LastSourceSkillPrefabSummary);
        }

        private static int ParseTrailingInt(string text)
        {
            if (string.IsNullOrEmpty(text))
                return 0;
            var start = 0;
            while (start < text.Length && !char.IsDigit(text[start]))
                start++;
            return start < text.Length && int.TryParse(text.Substring(start), out var value) ? value : 0;
        }

        private static BattleRuntimeSkillPreviewSpec BuildSkillPreviewSpec(BattleRuntimeActorHandle handle, int actionType, int skillDid)
        {
            var isAttack = actionType == 1 || actionType == 2 || actionType == 3 || actionType == 4;
            var big = actionType == 1 || actionType == 3 || SkillTierFromDid(skillDid) == 3;
            var family = ResolveSkillFamily(handle);
            var tier = ResolveSkillTier(skillDid, actionType);
            var effectiveSkillDid = skillDid >= 100000 ? skillDid : family * 1000 + tier * 100 + 1;
            var prefabId = effectiveSkillDid;
            var fastPrefabId = tier == 3 ? family * 1000 + 351 : 0;
            var sourceBacked = family == 1002 || family == 1034 || family == 1036 || family == 1012;
            var spec = new BattleRuntimeSkillPreviewSpec
            {
                IsAttack = isAttack,
                Big = big,
                SourceBacked = sourceBacked,
                TimelineBlocked = sourceBacked,
                SourceFamilyId = family,
                EffectiveSkillDid = effectiveSkillDid,
                PrefabId = prefabId,
                FastPrefabId = fastPrefabId,
                BundlePath = "download/skillprefabsandres/" + family + ".assetbundle",
                AssetPath = "assets/download/skillprefabsandres/" + family + "/" + prefabId + ".prefab",
                PlayablePath = "assets/download/skillprefabsandres/" + family + "/" + prefabId + ".playable",
                MotionFrames = big ? 12 : 9,
                DashDistance = big ? 0.58f : 0.38f,
                DashLift = big ? 0.075f : 0.055f,
                ScalePulse = big ? 0.055f : 0.035f,
                LineWidth = big ? 0.13f : 0.085f,
                StartScale = big ? 0.7f : 0.62f,
                EndScale = big ? 1.95f : 1.25f,
                AnimationCandidates = big
                    ? new[] { "ult", "skill2", "skill1", "attack", "stand" }
                    : new[] { "attack", "skill1", "stand" },
            };

            ApplySkillFamilyStyle(spec, family, big);
            spec.Summary =
                "actor=" + (handle != null ? handle.RequestedHeroDid : 0) +
                " resolved=" + (handle != null ? handle.ResolvedActorId : 0) +
                " action=" + actionType +
                " skillIn=" + skillDid +
                " sourceFamily=" + family +
                " skill=" + effectiveSkillDid +
                " prefab=" + prefabId +
                (fastPrefabId != 0 ? "/fast=" + fastPrefabId : "") +
                " bundle=" + spec.BundlePath +
                " timelineBlocked=" + spec.TimelineBlocked;
            return spec;
        }

        private static void ApplySkillFamilyStyle(BattleRuntimeSkillPreviewSpec spec, int family, bool big)
        {
            switch (family)
            {
                case 1002:
                    spec.EffectShape = 0;
                    spec.PrimaryColor = big ? new Color(0.35f, 0.95f, 1f, 0.96f) : new Color(0.42f, 0.82f, 1f, 0.92f);
                    spec.SecondaryColor = big ? new Color(1f, 1f, 1f, 0.88f) : new Color(0.8f, 1f, 1f, 0.78f);
                    break;
                case 1034:
                    spec.EffectShape = 1;
                    spec.PrimaryColor = big ? new Color(1f, 0.78f, 0.18f, 0.96f) : new Color(1f, 0.92f, 0.45f, 0.9f);
                    spec.SecondaryColor = new Color(1f, 1f, 0.9f, big ? 0.88f : 0.72f);
                    spec.LineWidth *= 1.08f;
                    break;
                case 1036:
                    spec.EffectShape = big ? 2 : 1;
                    spec.PrimaryColor = big ? new Color(1f, 0.18f, 0.62f, 0.96f) : new Color(1f, 0.48f, 0.22f, 0.9f);
                    spec.SecondaryColor = big ? new Color(1f, 0.82f, 0.36f, 0.82f) : new Color(1f, 0.95f, 0.62f, 0.74f);
                    spec.LineWidth *= 1.12f;
                    break;
                case 1012:
                    spec.EffectShape = 2;
                    spec.PrimaryColor = big ? new Color(1f, 0.16f, 0.22f, 0.96f) : new Color(1f, 0.42f, 0.18f, 0.9f);
                    spec.SecondaryColor = big ? new Color(1f, 0.15f, 0.9f, 0.82f) : new Color(1f, 0.74f, 0.35f, 0.72f);
                    spec.DashDistance *= 0.92f;
                    break;
                default:
                    spec.EffectShape = 0;
                    spec.PrimaryColor = big ? new Color(1f, 0.18f, 0.82f, 0.95f) : new Color(0.45f, 0.9f, 1f, 0.92f);
                    spec.SecondaryColor = new Color(1f, 1f, 1f, 0.7f);
                    break;
            }
        }

        private static int ResolveSkillFamily(BattleRuntimeActorHandle handle)
        {
            if (handle == null)
                return 1002;
            var requested = handle.RequestedHeroDid != 0 ? handle.RequestedHeroDid : handle.RequestedHeroId;
            if (!handle.IsOurHero || requested >= 1100000 || handle.ResolvedActorId >= 3000)
                return 1012;
            if (requested == 1036)
                return 1036;
            if (handle.ResolvedActorId == 1034 || requested == 1034 || requested == 1036)
                return 1034;
            return 1002;
        }

        private static int ResolveSkillTier(int skillDid, int actionType)
        {
            var fromDid = SkillTierFromDid(skillDid);
            if (fromDid != 0)
                return fromDid;
            if (actionType == 1 || actionType == 3)
                return 3;
            if (actionType == 4)
                return 2;
            return 1;
        }

        private static int SkillTierFromDid(int skillDid)
        {
            var suffix = Mathf.Abs(skillDid) % 1000;
            if (suffix >= 300)
                return 3;
            if (suffix >= 200)
                return 2;
            if (suffix >= 100)
                return 1;
            if (skillDid == 3)
                return 3;
            if (skillDid == 2)
                return 2;
            if (skillDid == 1)
                return 1;
            return 0;
        }

        private static Vector3[] SkillEffectPoints(BattleRuntimeSkillPreviewSpec spec)
        {
            switch (spec.EffectShape)
            {
                case 1:
                    return spec.Big
                        ? new[] { new Vector3(-0.62f, 0.5f, 0f), new Vector3(-0.2f, 0.16f, 0f), new Vector3(0.08f, -0.1f, 0f), new Vector3(0.32f, -0.42f, 0f), new Vector3(0.54f, -0.68f, 0f) }
                        : new[] { new Vector3(-0.42f, 0.34f, 0f), new Vector3(-0.1f, 0.08f, 0f), new Vector3(0.24f, -0.22f, 0f), new Vector3(0.44f, -0.42f, 0f) };
                case 2:
                    return spec.Big
                        ? new[] { new Vector3(-0.72f, -0.24f, 0f), new Vector3(-0.34f, 0.2f, 0f), new Vector3(0.16f, 0.46f, 0f), new Vector3(0.58f, 0.34f, 0f), new Vector3(0.9f, 0.08f, 0f) }
                        : new[] { new Vector3(-0.5f, -0.18f, 0f), new Vector3(-0.12f, 0.12f, 0f), new Vector3(0.28f, 0.22f, 0f), new Vector3(0.58f, 0.1f, 0f) };
                default:
                    return spec.Big
                        ? new[] { new Vector3(-0.58f, -0.38f, 0f), new Vector3(-0.18f, 0.1f, 0f), new Vector3(0.26f, 0.38f, 0f), new Vector3(0.62f, 0.54f, 0f), new Vector3(0.9f, 0.68f, 0f) }
                        : new[] { new Vector3(-0.52f, -0.34f, 0f), new Vector3(-0.12f, 0.08f, 0f), new Vector3(0.28f, 0.32f, 0f), new Vector3(0.58f, 0.46f, 0f) };
            }
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

        private struct SourceSkillDirectorPlayCount
        {
            public int Total;
            public int Played;
            public int Blocked;
        }

        private static int ResolveActorId(int heroId, int heroDid, bool isMonster, out string resolveReason)
        {
            resolveReason = "";
            var requested = heroDid != 0 ? heroDid : heroId;
            if (isMonster && TryResolveMonsterModelId(requested, out var modelId, out var sourceMonsterId, out var sourceTable))
            {
                if (modelId != 0 && HasImportedActor(modelId))
                {
                    var resolveKind = sourceMonsterId == requested ? "monster_model_exact:" : "monster_model_base_fallback:";
                    resolveReason = resolveKind + requested + "->" + sourceMonsterId + "/" + sourceTable + "/model_" + modelId;
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
            if (isMonster)
                yield break;

            if (requested >= 1100000)
            {
                var baseId = requested - (requested % 10);
                yield return baseId + 1;
                yield return baseId;
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
                NormalizeActorHeight(handle.transform, actorId);
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
            NormalizeActorHeight(handle.transform, actorId);
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
            var scale = ActorVisualScale(actorId, isSpine);
            transform.localScale = Vector3.one * scale;
            if (!isOurHero)
            {
                var localScale = transform.localScale;
                localScale.x = -Mathf.Abs(localScale.x);
                transform.localScale = localScale;
            }
        }

        private static float ActorVisualScale(int actorId, bool isSpine)
        {
            if (!isSpine)
                return actorId == 1036 ? 0.82f : 0.68f;
            switch (actorId)
            {
                case 1002: return 0.58f;
                case 1034: return 0.46f;
                case 3001: return 0.6f;
                case 3006: return 0.52f;
                default: return actorId >= 3000 ? 0.52f : 0.58f;
            }
        }

        private static void NormalizeActorHeight(Transform root, int actorId)
        {
            if (root == null)
                return;
            if (!TryCollectRendererBounds(root.gameObject, out var bounds))
                return;

            var height = bounds.size.y;
            if (height <= 0.01f)
                return;

            var target = TargetActorWorldHeight(actorId);
            var factor = Mathf.Clamp(target / height, 0.55f, 2.85f);
            root.localScale = root.localScale * factor;
            NormalizeRendererDepth(root);
        }

        private static float TargetActorWorldHeight(int actorId)
        {
            switch (actorId)
            {
                case 1036: return 1.62f;
                case 1034: return 1.62f;
                case 1002: return 1.38f;
                case 1025: return 1.38f;
                case 1005: return 1.34f;
                case 1029: return 1.32f;
                case 1037: return 1.38f;
                case 1050: return 1.36f;
                case 3001: return 1.5f;
                case 3006: return 1.36f;
                default: return actorId >= 3000 ? 1.38f : 1.4f;
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
