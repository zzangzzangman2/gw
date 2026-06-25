using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Text;
using Spine;
using Spine.Unity;
using Spine.Unity.Editor;
using UnityEditor;
using UnityEngine;

namespace GirlsWarRestore {
	public static class SpineProbeRouteClusterTransform {
		const string SourceRoot = "Assets/RestoreData/route_spine_source";
		const string ResultJsonPath = "Assets/RestoreData/reports/maininterface_route_spine_slot_bone_animation_transform_probe.json";
		const string ResultCsvPath = "Assets/RestoreData/reports/maininterface_route_spine_slot_bone_animation_transform_probe.csv";

		static readonly SourceSpec[] Sources = {
			new SourceSpec(
				"Spine_shijieanniu",
				"spine_diqiu",
				SourceRoot + "/maininterface_ext_8",
				"Spine_shijieanniu",
				"A",
				1f,
				"download/ui/uiprefabandres/maininterface_ext_8.assetbundle",
				new [] { "diqiu", "zhuye_di1", "zhuye_bian", "yun", "yun2" }
			),
			new SourceSpec(
				"8007",
				"spine_xiaoren",
				SourceRoot + "/npcprefabandres_8007",
				"8007",
				"run",
				0.5f,
				"download/roleprefabsandres/npcprefabandres/8007.assetbundle",
				new string[0]
			)
		};

		public static void TraceRouteCluster () {
			Debug.Log("[GirlsWarRestore][SpineRouteProbe] TraceRouteCluster start");
			Directory.CreateDirectory("Assets/RestoreData/reports");
			var result = new RouteProbeResult {
				generatedAt = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
				status = "started",
				visualFixApplied = 0,
				applicationVerdict = "trace_only_no_main_scene_visual_change",
				summaries = new List<RouteSkeletonSummary>(),
				rows = new List<RouteAttachmentRow>()
			};

			try {
				foreach (var source in Sources) {
					try {
						ImportSource(source);
						AssetDatabase.SaveAssets();
						AssetDatabase.Refresh(ImportAssetOptions.ForceSynchronousImport);
						TraceSource(source, result);
					} catch (Exception sourceEx) {
						AddBlockedSummary(source, sourceEx, result);
						Debug.LogWarning("[GirlsWarRestore][SpineRouteProbe] Source blocked key=" + source.key + " reason=" + sourceEx.GetType().Name + ": " + sourceEx.Message);
					}
				}

				if (result.summaries.Count == 0)
					throw new Exception("No route Spine sources produced traceable SkeletonData.");

				result.status = "spine_runtime_transform_evidence_collected_partial";
				result.blocker = "Main scene has no route Spine runtime replay yet; bitmap placement for yun/yun2 or 8007 remains blocked until skeleton-space to UI-space mapping is applied through real SkeletonGraphic or a proven mesh replay.";
				WriteOutputs(result);
				Debug.Log("[GirlsWarRestore][SpineRouteProbe] TraceRouteCluster complete rows=" + result.rows.Count);
			} catch (Exception ex) {
				result.status = "failed_probe_import_or_trace";
				result.blocker = ex.GetType().Name + ": " + ex.Message;
				WriteOutputs(result);
				Debug.LogException(ex);
				throw;
			}
		}

		static void AddBlockedSummary (SourceSpec source, Exception ex, RouteProbeResult result) {
			result.summaries.Add(new RouteSkeletonSummary {
				key = source.key,
				originalNode = source.originalNode,
				sourceBundle = source.sourceBundle,
				skeletonDataAsset = source.folder + "/" + source.fileStem + "_SkeletonData.asset",
				animation = source.animation,
				animationFound = false,
				animationDuration = 0f,
				originalLocalScale = source.originalLocalScale,
				boneCount = 0,
				slotCount = 0,
				skinCount = 0,
				animationCount = 0,
				animationNames = "",
				targetAttachmentCount = 0,
				visibleAttachmentRows = 0,
				decision = "blocked_" + source.key + "_skeletonbinary_decode_failed",
				blocker = ex.GetType().Name + ": " + ex.Message
			});
		}

		static void ImportSource (SourceSpec source) {
			foreach (var path in source.ImportFiles) {
				if (!File.Exists(path))
					throw new Exception("Missing route Spine source file: " + path);
				AssetDatabase.ImportAsset(path, ImportAssetOptions.ForceUpdate);
			}
			AssetUtility.ImportSpineContent(source.ImportFiles, new List<string>(), true);
		}

		static void TraceSource (SourceSpec source, RouteProbeResult result) {
			var skeletonAsset = FindSkeletonDataAsset(source);
			if (skeletonAsset == null)
				throw new Exception("SkeletonDataAsset not found for " + source.key + " under " + source.folder);
			var skeletonData = skeletonAsset.GetSkeletonData(true);
			if (skeletonData == null)
				throw new Exception("SkeletonData load failed for " + source.key);
			if (skeletonData.Bones.Count == 0 || skeletonData.Slots.Count == 0) {
				result.summaries.Add(new RouteSkeletonSummary {
					key = source.key,
					originalNode = source.originalNode,
					sourceBundle = source.sourceBundle,
					skeletonDataAsset = AssetDatabase.GetAssetPath(skeletonAsset),
					animation = source.animation,
					animationFound = false,
					animationDuration = 0f,
					originalLocalScale = source.originalLocalScale,
					boneCount = skeletonData.Bones.Count,
					slotCount = skeletonData.Slots.Count,
					skinCount = skeletonData.Skins.Count,
					animationCount = skeletonData.Animations.Count,
					animationNames = JoinAnimationNames(skeletonData),
					targetAttachmentCount = 0,
					visibleAttachmentRows = 0,
					decision = "blocked_empty_or_unreadable_runtime_skeleton_data",
					blocker = "SkeletonDataAsset exists but runtime SkeletonData has no usable bones/slots."
				});
				return;
			}

			var animation = skeletonData.FindAnimation(source.animation);
			var animationNames = JoinAnimationNames(skeletonData);
			var sampleTimes = BuildSampleTimes(animation);
			var summary = new RouteSkeletonSummary {
				key = source.key,
				originalNode = source.originalNode,
				sourceBundle = source.sourceBundle,
				skeletonDataAsset = AssetDatabase.GetAssetPath(skeletonAsset),
				animation = source.animation,
				animationFound = animation != null,
				animationDuration = animation != null ? animation.Duration : 0f,
				originalLocalScale = source.originalLocalScale,
				boneCount = skeletonData.Bones.Count,
				slotCount = skeletonData.Slots.Count,
				skinCount = skeletonData.Skins.Count,
				animationCount = skeletonData.Animations.Count,
				animationNames = animationNames,
				targetAttachmentCount = 0,
				visibleAttachmentRows = 0,
				decision = source.key == "8007" ? "trace_only_run_pose_requires_spine_runtime_or_mesh_replay" : "trace_only_slot_bounds_found_but_main_scene_mapping_unproven"
			};

			foreach (var time in sampleTimes) {
				var skeleton = new Skeleton(skeletonData);
				skeleton.SetToSetupPose();
				if (animation != null)
					animation.Apply(skeleton, -1f, time, true, null, 1f, MixBlend.Setup, MixDirection.In);
				skeleton.UpdateWorldTransform();
				TracePose(source, skeleton, time, result.rows, summary);
			}

			result.summaries.Add(summary);
		}

		static SkeletonDataAsset FindSkeletonDataAsset (SourceSpec source) {
			var expected = source.folder + "/" + source.fileStem + "_SkeletonData.asset";
			var skeletonAsset = AssetDatabase.LoadAssetAtPath<SkeletonDataAsset>(expected);
			if (skeletonAsset != null)
				return skeletonAsset;
			var guids = AssetDatabase.FindAssets("t:SkeletonDataAsset", new [] { source.folder });
			foreach (var guid in guids) {
				var path = AssetDatabase.GUIDToAssetPath(guid);
				var asset = AssetDatabase.LoadAssetAtPath<SkeletonDataAsset>(path);
				if (asset != null)
					return asset;
			}
			return null;
		}

		static float[] BuildSampleTimes (Spine.Animation animation) {
			if (animation == null || animation.Duration <= 0f)
				return new [] { 0f };
			return new [] { 0f, animation.Duration * 0.25f, animation.Duration * 0.5f, animation.Duration * 0.75f };
		}

		static void TracePose (SourceSpec source, Skeleton skeleton, float sampleTime, List<RouteAttachmentRow> rows, RouteSkeletonSummary summary) {
			var drawOrder = skeleton.DrawOrder;
			for (var drawIndex = 0; drawIndex < drawOrder.Count; drawIndex++) {
				var slot = drawOrder.Items[drawIndex];
				if (slot == null || slot.Attachment == null)
					continue;

				var target = IsTargetAttachment(source, slot);
				var include = target || source.key == "8007";
				if (!include)
					continue;

				var row = BuildAttachmentRow(source, slot, drawIndex, sampleTime, target);
				rows.Add(row);
				summary.visibleAttachmentRows++;
				if (target)
					summary.targetAttachmentCount++;
			}
		}

		static bool IsTargetAttachment (SourceSpec source, Slot slot) {
			var hay = ((slot.Data != null ? slot.Data.Name : "") + "|" + (slot.Attachment != null ? slot.Attachment.Name : "")).ToLowerInvariant();
			foreach (var name in source.targetAttachmentNames) {
				if (hay.Contains(name.ToLowerInvariant()))
					return true;
			}
			return false;
		}

		static RouteAttachmentRow BuildAttachmentRow (SourceSpec source, Slot slot, int drawIndex, float sampleTime, bool target) {
			var attachment = slot.Attachment;
			var bone = slot.Bone;
			var bounds = ComputeBounds(slot);
			var decision = Classify(source, slot, target, bounds);
			return new RouteAttachmentRow {
				skeletonKey = source.key,
				originalNode = source.originalNode,
				sourceBundle = source.sourceBundle,
				animation = source.animation,
				sampleTime = sampleTime,
				drawOrderIndex = drawIndex,
				slotName = slot.Data != null ? slot.Data.Name : "",
				boneName = bone != null && bone.Data != null ? bone.Data.Name : "",
				attachmentName = attachment != null ? attachment.Name : "",
				attachmentType = attachment != null ? attachment.GetType().Name : "",
				targetRelevance = target ? "target_route_attachment" : "visible_runtime_attachment",
				vertexCount = bounds.vertexCount,
				minX = bounds.minX,
				minY = bounds.minY,
				maxX = bounds.maxX,
				maxY = bounds.maxY,
				width = bounds.maxX - bounds.minX,
				height = bounds.maxY - bounds.minY,
				boneWorldX = bone != null ? bone.WorldX : 0f,
				boneWorldY = bone != null ? bone.WorldY : 0f,
				boneWorldRotationX = bone != null ? bone.WorldRotationX : 0f,
				boneWorldScaleX = bone != null ? bone.WorldScaleX : 0f,
				boneWorldScaleY = bone != null ? bone.WorldScaleY : 0f,
				slotColor = string.Format(CultureInfo.InvariantCulture, "{0:0.###},{1:0.###},{2:0.###},{3:0.###}", slot.R, slot.G, slot.B, slot.A),
				decision = decision
			};
		}

		static BoundsResult ComputeBounds (Slot slot) {
			var attachment = slot.Attachment;
			if (attachment is RegionAttachment) {
				var region = (RegionAttachment)attachment;
				var verts = new float[8];
				region.ComputeWorldVertices(slot.Bone, verts, 0, 2);
				return BoundsFromVertices(verts);
			}
			if (attachment is MeshAttachment) {
				var mesh = (MeshAttachment)attachment;
				var verts = new float[mesh.WorldVerticesLength];
				mesh.ComputeWorldVertices(slot, 0, mesh.WorldVerticesLength, verts, 0, 2);
				return BoundsFromVertices(verts);
			}
			return new BoundsResult { minX = 0f, minY = 0f, maxX = 0f, maxY = 0f, vertexCount = 0 };
		}

		static BoundsResult BoundsFromVertices (float[] verts) {
			if (verts == null || verts.Length < 2)
				return new BoundsResult { minX = 0f, minY = 0f, maxX = 0f, maxY = 0f, vertexCount = 0 };
			var minX = float.MaxValue;
			var minY = float.MaxValue;
			var maxX = float.MinValue;
			var maxY = float.MinValue;
			for (var i = 0; i + 1 < verts.Length; i += 2) {
				var x = verts[i];
				var y = verts[i + 1];
				if (x < minX) minX = x;
				if (y < minY) minY = y;
				if (x > maxX) maxX = x;
				if (y > maxY) maxY = y;
			}
			return new BoundsResult { minX = minX, minY = minY, maxX = maxX, maxY = maxY, vertexCount = verts.Length / 2 };
		}

		static string Classify (SourceSpec source, Slot slot, bool target, BoundsResult bounds) {
			if (bounds.vertexCount == 0)
				return "blocked_attachment_has_no_region_or_mesh_vertices";
			if (source.key == "Spine_shijieanniu") {
				var name = ((slot.Data != null ? slot.Data.Name : "") + "|" + (slot.Attachment != null ? slot.Attachment.Name : "")).ToLowerInvariant();
				if (name.Contains("yun"))
					return "transform_evidence_found_trace_only_cloud_layer_mapping_unproven";
				if (name.Contains("diqiu") || name.Contains("zhuye"))
					return "transform_evidence_found_existing_fallback_not_changed";
			}
			if (source.key == "8007")
				return "run_pose_attachment_bounds_found_trace_only_requires_spine_runtime_or_mesh_replay";
			return target ? "target_transform_evidence_found_trace_only" : "visible_attachment_transform_evidence_found";
		}

		static string JoinAnimationNames (SkeletonData data) {
			var names = new List<string>();
			for (var i = 0; i < data.Animations.Count; i++)
				names.Add(data.Animations.Items[i].Name);
			return string.Join("|", names.ToArray());
		}

		static void WriteOutputs (RouteProbeResult result) {
			File.WriteAllText(ResultJsonPath, JsonUtility.ToJson(result, true), Encoding.UTF8);
			WriteCsv(result.rows);
			AssetDatabase.Refresh(ImportAssetOptions.ForceSynchronousImport);
		}

		static void WriteCsv (List<RouteAttachmentRow> rows) {
			var sb = new StringBuilder();
			sb.AppendLine("skeletonKey,originalNode,sourceBundle,animation,sampleTime,drawOrderIndex,slotName,boneName,attachmentName,attachmentType,targetRelevance,vertexCount,minX,minY,maxX,maxY,width,height,boneWorldX,boneWorldY,boneWorldRotationX,boneWorldScaleX,boneWorldScaleY,slotColor,decision");
			foreach (var row in rows) {
				sb.Append(Csv(row.skeletonKey)).Append(',');
				sb.Append(Csv(row.originalNode)).Append(',');
				sb.Append(Csv(row.sourceBundle)).Append(',');
				sb.Append(Csv(row.animation)).Append(',');
				sb.Append(Num(row.sampleTime)).Append(',');
				sb.Append(row.drawOrderIndex).Append(',');
				sb.Append(Csv(row.slotName)).Append(',');
				sb.Append(Csv(row.boneName)).Append(',');
				sb.Append(Csv(row.attachmentName)).Append(',');
				sb.Append(Csv(row.attachmentType)).Append(',');
				sb.Append(Csv(row.targetRelevance)).Append(',');
				sb.Append(row.vertexCount).Append(',');
				sb.Append(Num(row.minX)).Append(',');
				sb.Append(Num(row.minY)).Append(',');
				sb.Append(Num(row.maxX)).Append(',');
				sb.Append(Num(row.maxY)).Append(',');
				sb.Append(Num(row.width)).Append(',');
				sb.Append(Num(row.height)).Append(',');
				sb.Append(Num(row.boneWorldX)).Append(',');
				sb.Append(Num(row.boneWorldY)).Append(',');
				sb.Append(Num(row.boneWorldRotationX)).Append(',');
				sb.Append(Num(row.boneWorldScaleX)).Append(',');
				sb.Append(Num(row.boneWorldScaleY)).Append(',');
				sb.Append(Csv(row.slotColor)).Append(',');
				sb.Append(Csv(row.decision)).AppendLine();
			}
			File.WriteAllText(ResultCsvPath, sb.ToString(), Encoding.UTF8);
		}

		static string Num (float value) {
			return value.ToString("0.####", CultureInfo.InvariantCulture);
		}

		static string Csv (string value) {
			if (value == null)
				value = "";
			return "\"" + value.Replace("\"", "\"\"") + "\"";
		}

		struct BoundsResult {
			public float minX;
			public float minY;
			public float maxX;
			public float maxY;
			public int vertexCount;
		}

		sealed class SourceSpec {
			public readonly string key;
			public readonly string originalNode;
			public readonly string folder;
			public readonly string fileStem;
			public readonly string animation;
			public readonly float originalLocalScale;
			public readonly string sourceBundle;
			public readonly string[] targetAttachmentNames;
			public readonly string[] ImportFiles;

			public SourceSpec (string key, string originalNode, string folder, string fileStem, string animation, float originalLocalScale, string sourceBundle, string[] targetAttachmentNames) {
				this.key = key;
				this.originalNode = originalNode;
				this.folder = folder;
				this.fileStem = fileStem;
				this.animation = animation;
				this.originalLocalScale = originalLocalScale;
				this.sourceBundle = sourceBundle;
				this.targetAttachmentNames = targetAttachmentNames;
				this.ImportFiles = new [] {
					folder + "/" + fileStem + ".png",
					folder + "/" + fileStem + ".atlas.txt",
					folder + "/" + fileStem + ".skel.bytes"
				};
			}
		}

		[Serializable]
		sealed class RouteProbeResult {
			public string generatedAt;
			public string status;
			public int visualFixApplied;
			public string applicationVerdict;
			public string blocker;
			public List<RouteSkeletonSummary> summaries;
			public List<RouteAttachmentRow> rows;
		}

		[Serializable]
		sealed class RouteSkeletonSummary {
			public string key;
			public string originalNode;
			public string sourceBundle;
			public string skeletonDataAsset;
			public string animation;
			public bool animationFound;
			public float animationDuration;
			public float originalLocalScale;
			public int boneCount;
			public int slotCount;
			public int skinCount;
			public int animationCount;
			public string animationNames;
			public int targetAttachmentCount;
			public int visibleAttachmentRows;
			public string decision;
			public string blocker;
		}

		[Serializable]
		sealed class RouteAttachmentRow {
			public string skeletonKey;
			public string originalNode;
			public string sourceBundle;
			public string animation;
			public float sampleTime;
			public int drawOrderIndex;
			public string slotName;
			public string boneName;
			public string attachmentName;
			public string attachmentType;
			public string targetRelevance;
			public int vertexCount;
			public float minX;
			public float minY;
			public float maxX;
			public float maxY;
			public float width;
			public float height;
			public float boneWorldX;
			public float boneWorldY;
			public float boneWorldRotationX;
			public float boneWorldScaleX;
			public float boneWorldScaleY;
			public string slotColor;
			public string decision;
		}
	}
}
