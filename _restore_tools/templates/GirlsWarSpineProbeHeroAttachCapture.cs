using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using Spine.Unity;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

namespace GirlsWarRestore {
	public static class SpineProbeHeroAttachCapture {
		const string SourceScenePath = "Assets/Scenes/MainInterface_Wireframe.unity";
		const string ProbeScenePath = "Assets/Scenes/MainInterface_Wireframe_Hero1001SpineProbe.unity";
		const string HeroRoot = "Assets/RestoreData/hero1001_spine_source_raw/paintingprefabandres_1001";
		const string ReportJsonPath = "Assets/RestoreData/reports/maininterface_spine40_hero1001_attach_capture_result.json";
		const string FullCapturePath = "Assets/RestoreCaptures/maininterface_spine_hero1001_probe_1680x720.png";
		const string HeroOnlyCapturePath = "Assets/RestoreCaptures/maininterface_spine_hero1001_probe_hero_only_1680x720.png";
		const float ReferenceWidth = 1680f;
		const float ReferenceHeight = 720f;

		static readonly LayerSpec[] Layers = {
			new LayerSpec("Painting_1001_back", "Painting_1001_Back_SkeletonData.asset", "Painting_1001_Back_Material.mat", null, "Painting_1001_Back_Material-Screen.mat", "A"),
			new LayerSpec("Painting_1001", "Painting_1001_SkeletonData.asset", "Painting_1001_Material.mat", "Painting_1001_Material-Additive.mat", "Painting_1001_Material-Screen.mat", "A"),
			new LayerSpec("Painting_1001_front", "Painting_1001_Front_SkeletonData.asset", "Painting_1001_Front_Material.mat", "Painting_1001_Front_Material-Additive.mat", null, "A"),
			new LayerSpec("SP_heroname_1001", "SP_heroname_1001_SkeletonData.asset", "SP_heroname_1001_Material.mat", "SP_heroname_1001_Material-Additive.mat", null, "A1"),
		};

		static readonly VariantSpec[] Variants = {
			new VariantSpec("main_only", new [] { "Restore_Hero1001_Painting_1001" }),
			new VariantSpec("main_front", new [] { "Restore_Hero1001_Painting_1001", "Restore_Hero1001_Painting_1001_front" }),
			new VariantSpec("main_name", new [] { "Restore_Hero1001_Painting_1001", "Restore_Hero1001_SP_heroname_1001" }),
			new VariantSpec("main_front_name", new [] { "Restore_Hero1001_Painting_1001", "Restore_Hero1001_Painting_1001_front", "Restore_Hero1001_SP_heroname_1001" }),
			new VariantSpec("all_layers_with_back", new [] { "Restore_Hero1001_Painting_1001_back", "Restore_Hero1001_Painting_1001", "Restore_Hero1001_Painting_1001_front", "Restore_Hero1001_SP_heroname_1001" }),
		};

		[MenuItem("GirlsWar/Probe Attach and Capture Hero1001 Spine")]
		public static void AttachAndCaptureHero1001 () {
			Debug.Log("[GirlsWarRestore][SpineProbeCapture] AttachAndCaptureHero1001 start");
			AssetDatabase.Refresh(ImportAssetOptions.ForceSynchronousImport);

			if (!File.Exists(SourceScenePath))
				throw new Exception("[GirlsWarRestore][SpineProbeCapture] Source scene missing: " + SourceScenePath);

			Directory.CreateDirectory("Assets/RestoreData/reports");
			Directory.CreateDirectory("Assets/RestoreCaptures");

			var scene = EditorSceneManager.OpenScene(SourceScenePath, OpenSceneMode.Single);
			var canvas = UnityEngine.Object.FindFirstObjectByType<Canvas>();
			if (canvas == null)
				throw new Exception("[GirlsWarRestore][SpineProbeCapture] Canvas not found in " + SourceScenePath);

			var heroParent = FindTransformByPrefix("UI_heroSpine__");
			if (heroParent == null)
				heroParent = FindTransformByName("UI_heroSpine");
			if (heroParent == null)
				throw new Exception("[GirlsWarRestore][SpineProbeCapture] UI_heroSpine not found in scene");

			EnsureActiveInHierarchy(heroParent);
			var previous = heroParent.Find("Restore_Hero1001_SpineRoot");
			if (previous != null)
				UnityEngine.Object.DestroyImmediate(previous.gameObject);

			var restoreRoot = new GameObject("Restore_Hero1001_SpineRoot", typeof(RectTransform));
			var restoreRect = restoreRoot.GetComponent<RectTransform>();
			restoreRect.SetParent(heroParent, false);
			restoreRect.anchorMin = Vector2.zero;
			restoreRect.anchorMax = Vector2.one;
			restoreRect.offsetMin = Vector2.zero;
			restoreRect.offsetMax = Vector2.zero;
			restoreRect.pivot = new Vector2(0.5f, 0.5f);
			restoreRect.anchoredPosition = Vector2.zero;
			restoreRect.localRotation = Quaternion.identity;
			restoreRect.localScale = Vector3.one;

			var layerResults = new List<LayerResult>();
			foreach (var layer in Layers) {
				layerResults.Add(AttachLayer(layer, restoreRect));
			}

			ForceSpineUpdate(restoreRoot.transform);
			EditorSceneManager.SaveScene(scene, ProbeScenePath);

			PrepareCanvasForCapture(canvas);
			ForceSpineUpdate(restoreRoot.transform);
			var fullMetrics = Capture(canvas, FullCapturePath, "full");
			var variantResults = CaptureVariants(canvas, restoreRoot.transform, keepNonHeroEnabled: true, suffix: "full");

			var disabledGraphics = DisableNonHeroGraphics(restoreRoot.transform);
			ForceSpineUpdate(restoreRoot.transform);
			var heroOnlyMetrics = Capture(canvas, HeroOnlyCapturePath, "hero_only");
			var heroOnlyVariantResults = CaptureVariants(canvas, restoreRoot.transform, keepNonHeroEnabled: false, suffix: "hero_only");
			CaptureIndividualLayers(canvas, restoreRoot.transform, layerResults);
			RestoreGraphics(disabledGraphics);

			var result = new AttachCaptureResult {
				status = heroOnlyMetrics.visiblePixelCount > 0 ? "hero1001_spine_rendered_in_probe" : "hero1001_spine_attached_but_blank",
				generatedAt = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
				sourceScenePath = SourceScenePath,
				probeScenePath = ProbeScenePath,
				heroParentName = heroParent.name,
				restoreRootName = restoreRoot.name,
				homePara = "[1,0,0]",
				layerCount = layerResults.Count,
				layers = layerResults.ToArray(),
				fullCapture = fullMetrics,
				heroOnlyCapture = heroOnlyMetrics,
				variants = MergeVariants(variantResults, heroOnlyVariantResults)
			};
			File.WriteAllText(ReportJsonPath, JsonUtility.ToJson(result, true), Encoding.UTF8);
			AssetDatabase.Refresh(ImportAssetOptions.ForceSynchronousImport);

			Debug.Log("[GirlsWarRestore][SpineProbeCapture] Capture full=" + FullCapturePath + " visiblePixels=" + fullMetrics.visiblePixelCount);
			Debug.Log("[GirlsWarRestore][SpineProbeCapture] Capture heroOnly=" + HeroOnlyCapturePath + " visiblePixels=" + heroOnlyMetrics.visiblePixelCount);
			Debug.Log("[GirlsWarRestore][SpineProbeCapture] AttachAndCaptureHero1001 complete status=" + result.status);
		}

		static LayerResult AttachLayer (LayerSpec layer, RectTransform parent) {
			var skeletonAssetPath = HeroRoot + "/" + layer.skeletonDataAsset;
			var skeletonDataAsset = AssetDatabase.LoadAssetAtPath<SkeletonDataAsset>(skeletonAssetPath);
			if (skeletonDataAsset == null)
				throw new Exception("[GirlsWarRestore][SpineProbeCapture] Missing SkeletonDataAsset: " + skeletonAssetPath);

			var material = LoadMaterial(layer.material);
			var graphic = SkeletonGraphic.NewSkeletonGraphicGameObject(skeletonDataAsset, parent, material);
			graphic.gameObject.name = "Restore_Hero1001_" + layer.name;
			graphic.raycastTarget = false;
			graphic.maskable = true;
			graphic.allowMultipleCanvasRenderers = true;
			graphic.startingAnimation = layer.animation;
			graphic.startingLoop = true;
			graphic.additiveMaterial = LoadMaterial(layer.additiveMaterial);
			graphic.screenMaterial = LoadMaterial(layer.screenMaterial);

			var rect = graphic.GetComponent<RectTransform>();
			rect.anchorMin = new Vector2(0.5f, 0.5f);
			rect.anchorMax = new Vector2(0.5f, 0.5f);
			rect.pivot = new Vector2(0.5f, 0.5f);
			rect.anchoredPosition = Vector2.zero;
			rect.sizeDelta = new Vector2(100f, 100f);
			rect.localRotation = Quaternion.identity;
			rect.localScale = Vector3.one;

			var skeletonData = skeletonDataAsset.GetSkeletonData(true);
			graphic.Initialize(true);
			if (skeletonData.FindAnimation(layer.animation) != null)
				graphic.AnimationState.SetAnimation(0, layer.animation, true);
			graphic.Update(0f);
			graphic.UpdateMesh(true);
			var matchedBounds = graphic.MatchRectTransformWithBounds();
			graphic.UpdateMesh(true);

			var mesh = graphic.GetLastMesh();
			var result = new LayerResult {
				layerName = layer.name,
				gameObjectName = graphic.gameObject.name,
				skeletonDataAsset = skeletonAssetPath,
				animation = layer.animation,
				bones = skeletonData.Bones.Count,
				slots = skeletonData.Slots.Count,
				skins = skeletonData.Skins.Count,
				animations = skeletonData.Animations.Count,
				material = layer.material,
				additiveMaterial = layer.additiveMaterial,
				screenMaterial = layer.screenMaterial,
				matchedBounds = matchedBounds,
				vertexCount = mesh != null ? mesh.vertexCount : 0,
				canvasRendererCount = graphic.canvasRenderers != null ? graphic.canvasRenderers.Count + 1 : 1,
				rectWidth = rect.sizeDelta.x,
				rectHeight = rect.sizeDelta.y,
				pivotX = rect.pivot.x,
				pivotY = rect.pivot.y
			};
			Debug.Log(string.Format(
				"[GirlsWarRestore][SpineProbeCapture] Layer OK name={0} bones={1} slots={2} animations={3} vertices={4} rect={5:0.###}x{6:0.###}",
				result.layerName, result.bones, result.slots, result.animations, result.vertexCount, result.rectWidth, result.rectHeight));
			return result;
		}

		static Material LoadMaterial (string fileName) {
			if (string.IsNullOrEmpty(fileName))
				return null;
			return AssetDatabase.LoadAssetAtPath<Material>(HeroRoot + "/" + fileName);
		}

		static void PrepareCanvasForCapture (Canvas canvas) {
			var cameraGo = GameObject.Find("MainInterface_SpineProbe_CaptureCamera");
			if (cameraGo != null)
				UnityEngine.Object.DestroyImmediate(cameraGo);

			var canvasRect = canvas.GetComponent<RectTransform>();
			canvasRect.anchorMin = new Vector2(0.5f, 0.5f);
			canvasRect.anchorMax = new Vector2(0.5f, 0.5f);
			canvasRect.pivot = new Vector2(0.5f, 0.5f);
			canvasRect.anchoredPosition = Vector2.zero;
			canvasRect.sizeDelta = new Vector2(ReferenceWidth, ReferenceHeight);
			canvas.transform.position = Vector3.zero;
			canvas.transform.localRotation = Quaternion.identity;
			canvas.transform.localScale = Vector3.one;

			var scaler = canvas.GetComponent<CanvasScaler>();
			if (scaler != null) {
				scaler.uiScaleMode = CanvasScaler.ScaleMode.ConstantPixelSize;
				scaler.scaleFactor = 1f;
				scaler.referencePixelsPerUnit = 100f;
			}
			canvas.renderMode = RenderMode.WorldSpace;
			canvas.planeDistance = 0f;
		}

		static CaptureMetrics Capture (Canvas canvas, string capturePath, string label) {
			var cameraGo = new GameObject("MainInterface_SpineProbe_CaptureCamera_" + label, typeof(Camera));
			var camera = cameraGo.GetComponent<Camera>();
			camera.clearFlags = CameraClearFlags.SolidColor;
			camera.backgroundColor = new Color(0f, 0f, 0f, 0f);
			camera.orthographic = true;
			camera.orthographicSize = ReferenceHeight * 0.5f;
			camera.nearClipPlane = 0.01f;
			camera.farClipPlane = 1000f;
			camera.transform.position = new Vector3(0f, 0f, -100f);
			camera.transform.rotation = Quaternion.identity;
			canvas.worldCamera = camera;

			var renderTexture = new RenderTexture((int)ReferenceWidth, (int)ReferenceHeight, 24, RenderTextureFormat.ARGB32);
			var previous = RenderTexture.active;
			camera.targetTexture = renderTexture;
			RenderTexture.active = renderTexture;
			GL.Clear(true, true, new Color(0f, 0f, 0f, 0f));
			Canvas.ForceUpdateCanvases();
			camera.Render();

			var texture = new Texture2D((int)ReferenceWidth, (int)ReferenceHeight, TextureFormat.RGBA32, false);
			texture.ReadPixels(new Rect(0, 0, ReferenceWidth, ReferenceHeight), 0, 0);
			texture.Apply();
			File.WriteAllBytes(capturePath, texture.EncodeToPNG());

			var metrics = Measure(texture, label, capturePath);
			RenderTexture.active = previous;
			camera.targetTexture = null;
			UnityEngine.Object.DestroyImmediate(renderTexture);
			UnityEngine.Object.DestroyImmediate(texture);
			UnityEngine.Object.DestroyImmediate(cameraGo);
			return metrics;
		}

		static void CaptureIndividualLayers (Canvas canvas, Transform root, List<LayerResult> layerResults) {
			var layerObjects = new List<GameObject>();
			foreach (Transform child in root)
				layerObjects.Add(child.gameObject);

			foreach (var result in layerResults) {
				SetOnlyLayerEnabled(layerObjects, result.gameObjectName);
				ForceSpineUpdate(root);
				var safeName = SafeFileName(result.layerName);
				result.layerCapture = Capture(canvas, "Assets/RestoreCaptures/maininterface_spine_hero1001_probe_layer_" + safeName + "_1680x720.png", "layer_" + safeName);
			}

			foreach (var go in layerObjects) {
				go.SetActive(true);
				foreach (var graphic in go.GetComponentsInChildren<Graphic>(true))
					graphic.enabled = true;
			}
			ForceSpineUpdate(root);
		}

		static VariantResult[] CaptureVariants (Canvas canvas, Transform root, bool keepNonHeroEnabled, string suffix) {
			var layerObjects = new List<GameObject>();
			foreach (Transform child in root)
				layerObjects.Add(child.gameObject);

			var results = new List<VariantResult>();
			foreach (var variant in Variants) {
				SetLayerSetEnabled(layerObjects, variant.enabledGameObjectNames);
				ForceSpineUpdate(root);
				var capturePath = "Assets/RestoreCaptures/maininterface_spine_hero1001_probe_variant_" + variant.name + "_" + suffix + "_1680x720.png";
				var metrics = Capture(canvas, capturePath, "variant_" + variant.name + "_" + suffix);
				results.Add(new VariantResult {
					variantName = variant.name,
					suffix = suffix,
					keepsNonHeroEnabled = keepNonHeroEnabled,
					enabledGameObjects = variant.enabledGameObjectNames,
					capture = metrics
				});
			}

			foreach (var go in layerObjects) {
				go.SetActive(true);
				foreach (var graphic in go.GetComponentsInChildren<Graphic>(true))
					graphic.enabled = true;
			}
			ForceSpineUpdate(root);
			return results.ToArray();
		}

		static VariantResult[] MergeVariants (VariantResult[] first, VariantResult[] second) {
			var merged = new List<VariantResult>();
			if (first != null)
				merged.AddRange(first);
			if (second != null)
				merged.AddRange(second);
			return merged.ToArray();
		}

		static CaptureMetrics Measure (Texture2D texture, string label, string path) {
			var width = texture.width;
			var height = texture.height;
			var pixels = texture.GetPixels32();
			var minX = width;
			var minY = height;
			var maxX = -1;
			var maxY = -1;
			var visible = 0;
			var alpha = 0;
			var unique = new HashSet<int>();
			for (var y = 0; y < height; y++) {
				for (var x = 0; x < width; x++) {
					var p = pixels[(y * width) + x];
					if (p.a <= 0)
						continue;
					alpha++;
					if (p.r == 0 && p.g == 0 && p.b == 0)
						continue;
					visible++;
					if (x < minX) minX = x;
					if (y < minY) minY = y;
					if (x > maxX) maxX = x;
					if (y > maxY) maxY = y;
					unique.Add((p.a << 24) | (p.r << 16) | (p.g << 8) | p.b);
				}
			}
			if (visible == 0) {
				minX = minY = maxX = maxY = 0;
			}
			return new CaptureMetrics {
				label = label,
				capturePath = path,
				width = width,
				height = height,
				alphaPixelCount = alpha,
				visiblePixelCount = visible,
				uniqueColorCount = unique.Count,
				boundsMinX = minX,
				boundsMinY = minY,
				boundsMaxX = maxX,
				boundsMaxY = maxY
			};
		}

		static List<Graphic> DisableNonHeroGraphics (Transform heroRoot) {
			var disabled = new List<Graphic>();
			foreach (var graphic in UnityEngine.Object.FindObjectsByType<Graphic>(FindObjectsSortMode.None)) {
				if (graphic == null || !graphic.enabled)
					continue;
				if (graphic.transform == heroRoot || graphic.transform.IsChildOf(heroRoot))
					continue;
				graphic.enabled = false;
				disabled.Add(graphic);
			}
			return disabled;
		}

		static void SetOnlyLayerEnabled (List<GameObject> layerObjects, string enabledName) {
			SetLayerSetEnabled(layerObjects, new [] { enabledName });
		}

		static void SetLayerSetEnabled (List<GameObject> layerObjects, string[] enabledNames) {
			var enabledSet = new HashSet<string>(enabledNames);
			foreach (var go in layerObjects) {
				var enabled = enabledSet.Contains(go.name);
				go.SetActive(enabled);
				foreach (var graphic in go.GetComponentsInChildren<Graphic>(true)) {
					graphic.enabled = enabled;
					if (!enabled)
						graphic.canvasRenderer.Clear();
				}
				if (!enabled) {
					foreach (var canvasRenderer in go.GetComponentsInChildren<CanvasRenderer>(true))
						canvasRenderer.Clear();
				}
			}
			Canvas.ForceUpdateCanvases();
		}

		static string SafeFileName (string value) {
			var chars = value.ToCharArray();
			for (var i = 0; i < chars.Length; i++) {
				var c = chars[i];
				if (!(char.IsLetterOrDigit(c) || c == '_' || c == '-'))
					chars[i] = '_';
			}
			return new string(chars);
		}

		static void RestoreGraphics (List<Graphic> graphics) {
			foreach (var graphic in graphics) {
				if (graphic != null)
					graphic.enabled = true;
			}
		}

		static void ForceSpineUpdate (Transform root) {
			Canvas.ForceUpdateCanvases();
			foreach (var graphic in root.GetComponentsInChildren<SkeletonGraphic>(false)) {
				if (!graphic.isActiveAndEnabled)
					continue;
				graphic.Initialize(true);
				if (!string.IsNullOrEmpty(graphic.startingAnimation) && graphic.SkeletonDataAsset.GetSkeletonData(false).FindAnimation(graphic.startingAnimation) != null)
					graphic.AnimationState.SetAnimation(0, graphic.startingAnimation, graphic.startingLoop);
				graphic.Update(0f);
				graphic.UpdateMesh(true);
			}
			Canvas.ForceUpdateCanvases();
		}

		static Transform FindTransformByPrefix (string prefix) {
			foreach (var transform in UnityEngine.Object.FindObjectsByType<Transform>(FindObjectsSortMode.None)) {
				if (transform.name.StartsWith(prefix, StringComparison.Ordinal))
					return transform;
			}
			return null;
		}

		static Transform FindTransformByName (string name) {
			foreach (var transform in UnityEngine.Object.FindObjectsByType<Transform>(FindObjectsSortMode.None)) {
				if (transform.name == name)
					return transform;
			}
			return null;
		}

		static void EnsureActiveInHierarchy (Transform transform) {
			var cursor = transform;
			while (cursor != null) {
				cursor.gameObject.SetActive(true);
				cursor = cursor.parent;
			}
		}

		sealed class LayerSpec {
			public readonly string name;
			public readonly string skeletonDataAsset;
			public readonly string material;
			public readonly string additiveMaterial;
			public readonly string screenMaterial;
			public readonly string animation;

			public LayerSpec (string name, string skeletonDataAsset, string material, string additiveMaterial, string screenMaterial, string animation) {
				this.name = name;
				this.skeletonDataAsset = skeletonDataAsset;
				this.material = material;
				this.additiveMaterial = additiveMaterial;
				this.screenMaterial = screenMaterial;
				this.animation = animation;
			}
		}

		sealed class VariantSpec {
			public readonly string name;
			public readonly string[] enabledGameObjectNames;

			public VariantSpec (string name, string[] enabledGameObjectNames) {
				this.name = name;
				this.enabledGameObjectNames = enabledGameObjectNames;
			}
		}

		[Serializable]
		public sealed class AttachCaptureResult {
			public string status;
			public string generatedAt;
			public string sourceScenePath;
			public string probeScenePath;
			public string heroParentName;
			public string restoreRootName;
			public string homePara;
			public int layerCount;
			public LayerResult[] layers;
			public CaptureMetrics fullCapture;
			public CaptureMetrics heroOnlyCapture;
			public VariantResult[] variants;
		}

		[Serializable]
		public sealed class LayerResult {
			public string layerName;
			public string gameObjectName;
			public string skeletonDataAsset;
			public string animation;
			public int bones;
			public int slots;
			public int skins;
			public int animations;
			public string material;
			public string additiveMaterial;
			public string screenMaterial;
			public bool matchedBounds;
			public int vertexCount;
			public int canvasRendererCount;
			public float rectWidth;
			public float rectHeight;
			public float pivotX;
			public float pivotY;
			public CaptureMetrics layerCapture;
		}

		[Serializable]
		public sealed class VariantResult {
			public string variantName;
			public string suffix;
			public bool keepsNonHeroEnabled;
			public string[] enabledGameObjects;
			public CaptureMetrics capture;
		}

		[Serializable]
		public sealed class CaptureMetrics {
			public string label;
			public string capturePath;
			public int width;
			public int height;
			public int alphaPixelCount;
			public int visiblePixelCount;
			public int uniqueColorCount;
			public int boundsMinX;
			public int boundsMinY;
			public int boundsMaxX;
			public int boundsMaxY;
		}
	}
}
