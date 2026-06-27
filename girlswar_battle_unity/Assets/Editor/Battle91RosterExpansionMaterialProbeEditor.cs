using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using Spine.Unity;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;

namespace GirlsWar
{
    public static class Battle91RosterExpansionMaterialProbeEditor
    {
        private const string ScenePath = "Assets/Scenes/Battle91RosterExpansionMaterialProbe.unity";
        private const string ResultPath = "reports/battle/BATTLE_91_ROSTER_EXPANSION_MATERIAL_PROBE_RESULT.json";
        private const string CapturePath = "reports/battle/BATTLE_91_ROSTER_EXPANSION_MATERIAL_PROBE_CAPTURE.png";
        private static readonly int[] SourceBackedActorIds = { 1025, 1050, 1005, 1029, 1037 };
        private static readonly int[] EnemyMonsterIds = { 1100111, 1100112, 1100113 };

        [MenuItem("GirlsWar/Battle/BATTLE91 Roster Expansion Material Probe")]
        public static void Verify()
        {
            Directory.CreateDirectory(ProjectPath("Assets/Scenes"));
            Directory.CreateDirectory(RepoPath("reports/battle"));

            var scene = EditorSceneManager.NewScene(NewSceneSetup.EmptyScene, NewSceneMode.Single);
            var camera = CreateCamera();
            CreateReferenceGround();

            var root = new GameObject("B91_SourceBackedRosterProbeRoot");
            BattleRuntimeSpineActorFactory.ResetDiagnostics();

            var result = new Result
            {
                generatedAt = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
                scene = ScenePath,
                capturePath = CapturePath,
            };

            for (var i = 0; i < SourceBackedActorIds.Length; i++)
            {
                var slot = new GameObject("B91_OurSlot_" + SourceBackedActorIds[i]);
                slot.transform.SetParent(root.transform, false);
                slot.transform.position = new Vector3(-3.9f + i * 1.05f, -0.82f + (i % 2) * 0.18f, 0f);
                var handle = BattleRuntimeSpineActorFactory.AttachActor(
                    SourceBackedActorIds[i],
                    SourceBackedActorIds[i],
                    slot.transform,
                    true,
                    false,
                    SourceBackedActorIds[i]);
                Stabilize(handle);
                result.actors.Add(DescribeActor(handle, camera));
            }

            for (var i = 0; i < EnemyMonsterIds.Length; i++)
            {
                var slot = new GameObject("B91_EnemySlot_" + EnemyMonsterIds[i]);
                slot.transform.SetParent(root.transform, false);
                slot.transform.position = new Vector3(1.35f + i * 1.05f, -0.72f + (i % 2) * 0.18f, 0f);
                var handle = BattleRuntimeSpineActorFactory.AttachActor(
                    EnemyMonsterIds[i],
                    EnemyMonsterIds[i],
                    slot.transform,
                    false,
                    true,
                    EnemyMonsterIds[i]);
                Stabilize(handle);
                result.actors.Add(DescribeActor(handle, camera));
            }

            result.runtimeActorAttachCount = BattleRuntimeSpineActorFactory.AttachCount;
            result.runtimeActorPrefabCount = BattleRuntimeSpineActorFactory.PrefabCount;
            result.runtimeActorSpineCount = BattleRuntimeSpineActorFactory.SpineCount;
            result.runtimeActorMissingAssetCount = BattleRuntimeSpineActorFactory.MissingAssetCount;
            result.runtimeActorVisualFallbackCount = BattleRuntimeSpineActorFactory.VisualFallbackCount;
            result.runtimeMaterialShaderFallbackCount = BattleRuntimeSpineActorFactory.RuntimeMaterialShaderFallbackCount;
            result.runtimeSpineAtlasMaterialFallbackCount = BattleRuntimeSpineActorFactory.RuntimeSpineAtlasMaterialFallbackCount;
            result.runtimeBlendModeMaterialFallbackCount = BattleRuntimeSpineActorFactory.RuntimeBlendModeMaterialFallbackCount;
            result.runtimeMonsterModelResolveTrace = BattleRuntimeSpineActorFactory.MonsterModelResolveTraceSummary;
            foreach (var actor in result.actors)
            {
                result.actorRendererCount += actor.rendererCount;
                result.errorShaderMaterialCount += actor.errorShaderMaterialCount;
            }

            Capture(camera, RepoPath(CapturePath), result);
            result.status = result.errorShaderMaterialCount == 0 && result.actorRendererCount > 0
                ? "roster_expansion_material_probe_ok"
                : "roster_expansion_material_probe_blocked";

            File.WriteAllText(RepoPath(ResultPath), JsonUtility.ToJson(result, true), new UTF8Encoding(false));
            EditorSceneManager.SaveScene(scene, ScenePath);
            AssetDatabase.Refresh();
            EditorApplication.Exit(result.status == "roster_expansion_material_probe_ok" ? 0 : 1);
        }

        private static Camera CreateCamera()
        {
            var go = new GameObject("B91_VisualCamera");
            go.tag = "MainCamera";
            var camera = go.AddComponent<Camera>();
            camera.clearFlags = CameraClearFlags.SolidColor;
            camera.backgroundColor = new Color(0.12f, 0.10f, 0.09f, 1f);
            camera.orthographic = true;
            camera.orthographicSize = 2.55f;
            camera.transform.position = new Vector3(0f, -0.35f, -10f);
            return camera;
        }

        private static void CreateReferenceGround()
        {
            var ground = GameObject.CreatePrimitive(PrimitiveType.Quad);
            ground.name = "B91_NeutralGround";
            ground.transform.position = new Vector3(0f, -1.35f, 0.75f);
            ground.transform.localScale = new Vector3(7.2f, 1.0f, 1f);
            var material = new Material(Shader.Find("Unlit/Color") ?? Shader.Find("Sprites/Default"));
            material.color = new Color(0.26f, 0.20f, 0.18f, 1f);
            ground.GetComponent<MeshRenderer>().sharedMaterial = material;
        }

        private static void Stabilize(BattleRuntimeActorHandle handle)
        {
            if (handle == null || handle.SkeletonAnimation == null)
                return;
            handle.SkeletonAnimation.Update(0.033f);
            handle.SkeletonAnimation.LateUpdate();
            handle.RememberBasePose();
        }

        private static ActorResult DescribeActor(BattleRuntimeActorHandle handle, Camera camera)
        {
            var row = new ActorResult();
            if (handle == null)
                return row;

            row.requestedHeroId = handle.RequestedHeroId;
            row.requestedHeroDid = handle.RequestedHeroDid;
            row.resolvedActorId = handle.ResolvedActorId;
            row.isExactActor = handle.IsExactActor;
            row.isSpineActor = handle.IsSpineActor;
            row.animationName = handle.AnimationName ?? "";
            row.fallbackReason = handle.FallbackReason ?? "";
            row.worldPosition = Vec(handle.transform.position);

            if (TryCollectBounds(handle.gameObject, out var bounds))
            {
                row.worldBounds = Vec(bounds.center) + "|" + Vec(bounds.size);
                row.screenRect = RectString(ScreenRect(camera, bounds));
            }

            foreach (var renderer in handle.GetComponentsInChildren<Renderer>(true))
            {
                row.rendererCount++;
                if (renderer.enabled)
                    row.enabledRendererCount++;
                foreach (var material in renderer.sharedMaterials)
                {
                    if (material == null)
                        continue;
                    row.materialCount++;
                    var shaderName = material.shader != null ? material.shader.name : "";
                    var textureName = material.mainTexture != null ? material.mainTexture.name : "";
                    if (IsErrorShader(shaderName))
                        row.errorShaderMaterialCount++;
                    AddUnique(row.shaderNames, shaderName);
                    AddUnique(row.textureNames, textureName);
                    AddUnique(row.materialNames, material.name + "|" + shaderName + "|" + textureName);
                }
            }

            foreach (var skeletonAnimation in handle.GetComponentsInChildren<SkeletonAnimation>(true))
            {
                row.skeletonAnimationCount++;
                var sda = skeletonAnimation.skeletonDataAsset;
                if (sda == null || sda.atlasAssets == null)
                    continue;
                foreach (var atlas in sda.atlasAssets)
                {
                    if (atlas == null || atlas.Materials == null)
                        continue;
                    foreach (var material in atlas.Materials)
                    {
                        if (material == null)
                            continue;
                        var shaderName = material.shader != null ? material.shader.name : "";
                        if (IsErrorShader(shaderName))
                            row.errorShaderMaterialCount++;
                        AddUnique(row.atlasMaterialNames, material.name + "|" + shaderName + "|" + (material.mainTexture != null ? material.mainTexture.name : ""));
                    }
                }
            }

            return row;
        }

        private static bool TryCollectBounds(GameObject root, out Bounds bounds)
        {
            var hasBounds = false;
            bounds = new Bounds();
            foreach (var renderer in root.GetComponentsInChildren<Renderer>(true))
            {
                if (renderer == null || !renderer.enabled)
                    continue;
                if (!hasBounds)
                {
                    bounds = renderer.bounds;
                    hasBounds = true;
                }
                else
                {
                    bounds.Encapsulate(renderer.bounds);
                }
            }
            return hasBounds;
        }

        private static Rect ScreenRect(Camera camera, Bounds bounds)
        {
            if (camera == null)
                return new Rect();
            var min = bounds.min;
            var max = bounds.max;
            var points = new[]
            {
                camera.WorldToScreenPoint(new Vector3(min.x, min.y, min.z)),
                camera.WorldToScreenPoint(new Vector3(min.x, min.y, max.z)),
                camera.WorldToScreenPoint(new Vector3(min.x, max.y, min.z)),
                camera.WorldToScreenPoint(new Vector3(min.x, max.y, max.z)),
                camera.WorldToScreenPoint(new Vector3(max.x, min.y, min.z)),
                camera.WorldToScreenPoint(new Vector3(max.x, min.y, max.z)),
                camera.WorldToScreenPoint(new Vector3(max.x, max.y, min.z)),
                camera.WorldToScreenPoint(new Vector3(max.x, max.y, max.z)),
            };
            var xMin = float.MaxValue;
            var yMin = float.MaxValue;
            var xMax = float.MinValue;
            var yMax = float.MinValue;
            foreach (var point in points)
            {
                xMin = Mathf.Min(xMin, point.x);
                yMin = Mathf.Min(yMin, point.y);
                xMax = Mathf.Max(xMax, point.x);
                yMax = Mathf.Max(yMax, point.y);
            }
            return Rect.MinMaxRect(xMin, yMin, xMax, yMax);
        }

        private static void Capture(Camera camera, string fullPath, Result result)
        {
            var rt = new RenderTexture(1280, 570, 24, RenderTextureFormat.ARGB32);
            var previousTarget = camera.targetTexture;
            var previousActive = RenderTexture.active;
            camera.targetTexture = rt;
            RenderTexture.active = rt;
            camera.Render();

            var texture = new Texture2D(1280, 570, TextureFormat.RGB24, false);
            texture.ReadPixels(new Rect(0, 0, 1280, 570), 0, 0);
            texture.Apply();
            var pixels = texture.GetPixels32();
            foreach (var pixel in pixels)
            {
                if (pixel.r > 32 || pixel.g > 32 || pixel.b > 32)
                    result.captureNonDarkSampleCount++;
                if (pixel.r > 190 && pixel.g < 80 && pixel.b > 190)
                    result.captureMagentaSampleCount++;
            }

            File.WriteAllBytes(fullPath, texture.EncodeToPNG());
            result.captureExists = File.Exists(fullPath);
            result.captureBytes = result.captureExists ? (int)new FileInfo(fullPath).Length : 0;

            camera.targetTexture = previousTarget;
            RenderTexture.active = previousActive;
            UnityEngine.Object.DestroyImmediate(texture);
            UnityEngine.Object.DestroyImmediate(rt);
        }

        private static bool IsErrorShader(string shaderName)
        {
            if (string.IsNullOrEmpty(shaderName))
                return true;
            return shaderName.IndexOf("InternalErrorShader", StringComparison.OrdinalIgnoreCase) >= 0 ||
                   shaderName.IndexOf("error", StringComparison.OrdinalIgnoreCase) >= 0;
        }

        private static void AddUnique(List<string> values, string value)
        {
            if (string.IsNullOrEmpty(value) || values.Contains(value))
                return;
            values.Add(value);
        }

        private static string Vec(Vector3 v)
        {
            return v.x.ToString("0.###") + "/" + v.y.ToString("0.###") + "/" + v.z.ToString("0.###");
        }

        private static string RectString(Rect r)
        {
            return r.xMin.ToString("0.#") + "/" + r.yMin.ToString("0.#") + "/" + r.width.ToString("0.#") + "x" + r.height.ToString("0.#");
        }

        private static string ProjectPath(string projectRelativePath)
        {
            return Path.GetFullPath(Path.Combine(Application.dataPath, "..", projectRelativePath.Replace("/", "\\")));
        }

        private static string RepoPath(string repoRelativePath)
        {
            return Path.GetFullPath(Path.Combine(Application.dataPath, "..", "..", repoRelativePath.Replace("/", "\\")));
        }

        [Serializable]
        private sealed class Result
        {
            public string generatedAt;
            public string status;
            public string scene;
            public string capturePath;
            public bool captureExists;
            public int captureBytes;
            public int captureNonDarkSampleCount;
            public int captureMagentaSampleCount;
            public int runtimeActorAttachCount;
            public int runtimeActorPrefabCount;
            public int runtimeActorSpineCount;
            public int runtimeActorMissingAssetCount;
            public int runtimeActorVisualFallbackCount;
            public int runtimeMaterialShaderFallbackCount;
            public int runtimeSpineAtlasMaterialFallbackCount;
            public int runtimeBlendModeMaterialFallbackCount;
            public string runtimeMonsterModelResolveTrace;
            public int actorRendererCount;
            public int errorShaderMaterialCount;
            public List<ActorResult> actors = new List<ActorResult>();
        }

        [Serializable]
        private sealed class ActorResult
        {
            public int requestedHeroId;
            public int requestedHeroDid;
            public int resolvedActorId;
            public bool isExactActor;
            public bool isSpineActor;
            public string animationName = "";
            public string fallbackReason = "";
            public string worldPosition = "";
            public string worldBounds = "";
            public string screenRect = "";
            public int rendererCount;
            public int enabledRendererCount;
            public int skeletonAnimationCount;
            public int materialCount;
            public int errorShaderMaterialCount;
            public List<string> shaderNames = new List<string>();
            public List<string> textureNames = new List<string>();
            public List<string> materialNames = new List<string>();
            public List<string> atlasMaterialNames = new List<string>();
        }
    }
}
