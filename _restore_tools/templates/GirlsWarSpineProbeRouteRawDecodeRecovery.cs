using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Security.Cryptography;
using System.Text;
using Spine;
using Spine.Unity;
using Spine.Unity.Editor;
using UnityEditor;
using UnityEngine;

namespace GirlsWarRestore {
	public static class SpineProbeRouteRawDecodeRecovery {
		const string ProbeRoot = "Assets/RestoreData/route_spine_raw_decode_recovery";
		const string ResultJsonPath = "Assets/RestoreData/reports/maininterface_route_spinegraphic_runtime_replay_raw_skeleton_decode_recovery_probe.json";
		const string ResultCsvPath = "Assets/RestoreData/reports/maininterface_route_spinegraphic_runtime_replay_raw_skeleton_decode_recovery_probe.csv";

		static readonly SourceSpec[] Sources = {
			new SourceSpec(
				"Spine_shijieanniu",
				"spine_diqiu",
				"Spine_shijieanniu",
				"download/ui/uiprefabandres/maininterface_ext_8.assetbundle",
				@"girlswar_merged_extracted\extracted\unity\clean_unityfs_slices\download\ui\uiprefabandres\maininterface_ext_8.assetbundle",
				@"girlswar_merged_extracted\extracted\unity\bundles\b_35f69f1e4224c83e\textassets\-6625475740475696418_Spine_shijieanniu.skel.txt",
				@"girlswar_merged_extracted\extracted\unity\bundles\b_35f69f1e4224c83e\textassets\4125696125331628132_Spine_shijieanniu.atlas.txt",
				@"girlswar_merged_extracted\extracted\unity\bundles\b_35f69f1e4224c83e\images\T\-1569618029946744867_Spine_shijieanniu.png",
				"A",
				1f
			),
			new SourceSpec(
				"8007",
				"spine_xiaoren",
				"8007",
				"download/roleprefabsandres/npcprefabandres/8007.assetbundle",
				@"girlswar_merged_extracted\extracted\unity\clean_unityfs_slices\download\roleprefabsandres\npcprefabandres\8007.assetbundle",
				@"girlswar_merged_extracted\extracted\unity\bundles\b_df52239564024098\textassets\5717351362711680443_8007.skel.txt",
				@"girlswar_merged_extracted\extracted\unity\bundles\b_df52239564024098\textassets\-5959284149285428779_8007.atlas.txt",
				@"girlswar_merged_extracted\extracted\unity\bundles\b_df52239564024098\images\T\1969165562093376026_8007.png",
				"run",
				0.5f
			)
		};

		public static void TraceRawDecodeRecovery () {
			Directory.CreateDirectory("Assets/RestoreData/reports");
			var result = new RecoveryResult {
				generatedAt = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
				status = "started",
				visualFixApplied = 0,
				rows = new List<RecoveryRow>(),
				summaries = new List<RecoverySummary>()
			};

			try {
				var basePath = FindGirlsWarBase();
				foreach (var source in Sources)
					TraceSource(basePath, source, result);

				result.status = "raw_decode_recovery_trace_complete";
				result.blocker = "No evidence-backed MainInterface visual fix was applied. Raw skeleton decode is still not recovered for route cluster Spine replay.";
				WriteOutputs(result);
			} catch (Exception ex) {
				result.status = "raw_decode_recovery_trace_failed";
				result.blocker = ex.GetType().Name + ": " + ex.Message;
				WriteOutputs(result);
				Debug.LogException(ex);
				throw;
			}
		}

		static string FindGirlsWarBase () {
			var dir = new DirectoryInfo(Application.dataPath);
			for (var i = 0; i < 8 && dir != null; i++, dir = dir.Parent) {
				if (File.Exists(Path.Combine(dir.FullName, "00_COMMAND_CENTER.cmd")) && Directory.Exists(Path.Combine(dir.FullName, "_restore_tools")))
					return dir.FullName;
			}
			throw new Exception("Could not locate girlswar base from " + Application.dataPath);
		}

		static void TraceSource (string basePath, SourceSpec source, RecoveryResult result) {
			var summary = new RecoverySummary {
				key = source.key,
				originalNode = source.originalNode,
				sourceBundle = source.sourceBundle,
				animation = source.animation,
				originalLocalScale = source.originalLocalScale,
				cleanBundlePath = Path.Combine(basePath, source.cleanBundleRelative),
				extractedSkelPath = Path.Combine(basePath, source.extractedSkelRelative),
				bundleTextAssetCount = 0,
				matchingTextAssetCount = 0,
				exportedRawCandidateCount = 0,
				importAttempted = false,
				decodeRecovered = false,
				visualFixApplied = false,
				decision = "started"
			};
			result.summaries.Add(summary);

			AddFileStatsRow(source, "extracted_skel_file", summary.extractedSkelPath, result.rows);
			AddFileStatsRow(source, "extracted_atlas_file", Path.Combine(basePath, source.extractedAtlasRelative), result.rows);

			var rawRoot = ProbeRoot + "/" + source.key;
			var rawRootFs = Path.Combine(Application.dataPath, rawRoot.Substring("Assets/".Length).Replace('/', Path.DirectorySeparatorChar));
			Directory.CreateDirectory(rawRootFs);
			CopyFile(Path.Combine(basePath, source.extractedPngRelative), Path.Combine(rawRootFs, source.fileStem + ".png"));

			var bundlePath = Path.Combine(basePath, source.cleanBundleRelative);
			if (!File.Exists(bundlePath)) {
				summary.decision = "blocked_clean_unityfs_bundle_missing";
				summary.blocker = bundlePath;
				return;
			}

			var bundle = AssetBundle.LoadFromFile(bundlePath);
			if (bundle == null) {
				summary.decision = "blocked_clean_unityfs_bundle_load_failed";
				summary.blocker = bundlePath;
				return;
			}

			try {
				var assetNames = bundle.GetAllAssetNames();
				foreach (var assetName in assetNames) {
					var ta = bundle.LoadAsset<TextAsset>(assetName);
					if (ta == null)
						continue;
					summary.bundleTextAssetCount++;
					var match = IsMatchingTextAsset(source, assetName, ta.name);
					if (match)
						summary.matchingTextAssetCount++;
					AddTextAssetRow(source, assetName, ta, match, result.rows);
					if (!match)
						continue;

					var lower = (assetName + "|" + ta.name).ToLowerInvariant();
					if (lower.Contains("atlas")) {
						WriteBytes(Path.Combine(rawRootFs, source.fileStem + ".atlas.txt"), ta.bytes);
						summary.exportedRawCandidateCount++;
					} else if (lower.Contains("skel") || lower.Contains(source.fileStem.ToLowerInvariant())) {
						WriteBytes(Path.Combine(rawRootFs, source.fileStem + ".skel.bytes"), ta.bytes);
						summary.exportedRawCandidateCount++;
					}
				}
			} finally {
				bundle.Unload(false);
			}

			var fallbackAtlas = Path.Combine(rawRootFs, source.fileStem + ".atlas.txt");
			var fallbackSkel = Path.Combine(rawRootFs, source.fileStem + ".skel.bytes");
			if (!File.Exists(fallbackAtlas))
				CopyFile(Path.Combine(basePath, source.extractedAtlasRelative), fallbackAtlas);
			if (!File.Exists(fallbackSkel))
				CopyFile(Path.Combine(basePath, source.extractedSkelRelative), fallbackSkel);

			AssetDatabase.ImportAsset(rawRoot + "/" + source.fileStem + ".png", ImportAssetOptions.ForceUpdate);
			AssetDatabase.ImportAsset(rawRoot + "/" + source.fileStem + ".atlas.txt", ImportAssetOptions.ForceUpdate);
			AssetDatabase.ImportAsset(rawRoot + "/" + source.fileStem + ".skel.bytes", ImportAssetOptions.ForceUpdate);
			summary.importAttempted = true;
			try {
				AssetUtility.ImportSpineContent(new [] {
					rawRoot + "/" + source.fileStem + ".png",
					rawRoot + "/" + source.fileStem + ".atlas.txt",
					rawRoot + "/" + source.fileStem + ".skel.bytes"
				}, new List<string>(), true);
				AssetDatabase.SaveAssets();
				AssetDatabase.Refresh(ImportAssetOptions.ForceSynchronousImport);
				ValidateSkeletonData(source, rawRoot, summary, result.rows);
			} catch (Exception ex) {
				summary.decision = "blocked_spine_import_decode_exception";
				summary.blocker = ex.GetType().Name + ": " + ex.Message;
				result.rows.Add(MakeRow(source, "spine_import_decode", rawRoot + "/" + source.fileStem + ".skel.bytes", "exception", 0, "", "", "", summary.decision, summary.blocker));
			}
		}

		static void ValidateSkeletonData (SourceSpec source, string rawRoot, RecoverySummary summary, List<RecoveryRow> rows) {
			var skeletonPath = rawRoot + "/" + source.fileStem + "_SkeletonData.asset";
			var sda = AssetDatabase.LoadAssetAtPath<SkeletonDataAsset>(skeletonPath);
			if (sda == null) {
				summary.decision = "blocked_skeletondataasset_not_created";
				summary.blocker = skeletonPath;
				rows.Add(MakeRow(source, "spine_runtime_decode", skeletonPath, "missing_skeletondataasset", 0, "", "", "", summary.decision, summary.blocker));
				return;
			}
			var data = sda.GetSkeletonData(true);
			if (data == null) {
				summary.decision = "blocked_runtime_skeletondata_null";
				summary.blocker = skeletonPath;
				rows.Add(MakeRow(source, "spine_runtime_decode", skeletonPath, "null_skeletondata", 0, "", "", "", summary.decision, summary.blocker));
				return;
			}
			summary.boneCount = data.Bones.Count;
			summary.slotCount = data.Slots.Count;
			summary.animationCount = data.Animations.Count;
			summary.animationFound = data.FindAnimation(source.animation) != null;
			summary.decodeRecovered = data.Bones.Count > 0 && data.Slots.Count > 0;
			summary.decision = summary.decodeRecovered ? "decode_recovered_trace_only_no_main_visual_fix" : "blocked_empty_or_unusable_runtime_skeletondata";
			summary.blocker = summary.decodeRecovered ? "" : "SkeletonDataAsset exists but runtime data has zero usable bones/slots.";
			rows.Add(MakeRow(source, "spine_runtime_decode", skeletonPath, "skeletondata_counts", 0, "", "", "", summary.decision, string.Format(CultureInfo.InvariantCulture, "bones={0};slots={1};animations={2};animationFound={3}", summary.boneCount, summary.slotCount, summary.animationCount, summary.animationFound)));
			if (summary.decodeRecovered)
				TraceAttachmentBounds(source, data, rows);
		}

		static void TraceAttachmentBounds (SourceSpec source, SkeletonData data, List<RecoveryRow> rows) {
			var animation = data.FindAnimation(source.animation);
			var sampleTimes = BuildSampleTimes(animation);
			foreach (var sampleTime in sampleTimes) {
				var skeleton = new Skeleton(data);
				skeleton.SetToSetupPose();
				if (animation != null)
					animation.Apply(skeleton, -1f, sampleTime, true, null, 1f, MixBlend.Setup, MixDirection.In);
				skeleton.UpdateWorldTransform();
				var drawOrder = skeleton.DrawOrder;
				for (var drawIndex = 0; drawIndex < drawOrder.Count; drawIndex++) {
					var slot = drawOrder.Items[drawIndex];
					if (slot == null || slot.Attachment == null)
						continue;
					if (!ShouldRecordAttachment(source, slot))
						continue;
					var bounds = ComputeBounds(slot);
					var detail = string.Format(CultureInfo.InvariantCulture,
						"animation={0};sampleTime={1:0.####};drawOrder={2};slot={3};bone={4};attachment={5};type={6};vertices={7};minX={8:0.####};minY={9:0.####};maxX={10:0.####};maxY={11:0.####};width={12:0.####};height={13:0.####};boneWorldX={14:0.####};boneWorldY={15:0.####};scale={16:0.####}",
						source.animation,
						sampleTime,
						drawIndex,
						slot.Data != null ? slot.Data.Name : "",
						slot.Bone != null && slot.Bone.Data != null ? slot.Bone.Data.Name : "",
						slot.Attachment.Name,
						slot.Attachment.GetType().Name,
						bounds.vertexCount,
						bounds.minX,
						bounds.minY,
						bounds.maxX,
						bounds.maxY,
						bounds.maxX - bounds.minX,
						bounds.maxY - bounds.minY,
						slot.Bone != null ? slot.Bone.WorldX : 0f,
						slot.Bone != null ? slot.Bone.WorldY : 0f,
						source.originalLocalScale
					);
					rows.Add(MakeRow(source, "spine_attachment_bounds", source.animation, slot.Attachment.Name, 0, "", "", "", "runtime_attachment_bounds_recovered_trace_only", detail));
				}
			}
		}

		static float[] BuildSampleTimes (Spine.Animation animation) {
			if (animation == null || animation.Duration <= 0f)
				return new [] { 0f };
			return new [] { 0f, animation.Duration * 0.25f, animation.Duration * 0.5f, animation.Duration * 0.75f };
		}

		static bool ShouldRecordAttachment (SourceSpec source, Slot slot) {
			var hay = ((slot.Data != null ? slot.Data.Name : "") + "|" + (slot.Attachment != null ? slot.Attachment.Name : "")).ToLowerInvariant();
			if (source.key == "Spine_shijieanniu")
				return hay.Contains("yun") || hay.Contains("diqiu") || hay.Contains("zhuye");
			return source.key == "8007";
		}

		static BoundsResult ComputeBounds (Slot slot) {
			if (slot.Attachment is RegionAttachment) {
				var region = (RegionAttachment)slot.Attachment;
				var verts = new float[8];
				region.ComputeWorldVertices(slot.Bone, verts, 0, 2);
				return BoundsFromVertices(verts);
			}
			if (slot.Attachment is MeshAttachment) {
				var mesh = (MeshAttachment)slot.Attachment;
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

		static bool IsMatchingTextAsset (SourceSpec source, string assetName, string objectName) {
			var hay = (assetName + "|" + objectName).ToLowerInvariant();
			if (source.key == "8007")
				return hay.Contains("8007") && (hay.Contains("skel") || hay.Contains("atlas"));
			return hay.Contains(source.fileStem.ToLowerInvariant()) && (hay.Contains("skel") || hay.Contains("atlas"));
		}

		static void AddFileStatsRow (SourceSpec source, string kind, string path, List<RecoveryRow> rows) {
			if (!File.Exists(path)) {
				rows.Add(MakeRow(source, kind, path, "missing", 0, "", "", "", "missing_file", path));
				return;
			}
			var bytes = File.ReadAllBytes(path);
			rows.Add(MakeRow(source, kind, path, "file", bytes.Length, Sha256(bytes), FirstHex(bytes, 24), ByteSignals(bytes), "file_stats", ""));
		}

		static void AddTextAssetRow (SourceSpec source, string assetName, TextAsset ta, bool match, List<RecoveryRow> rows) {
			var bytes = ta.bytes ?? new byte[0];
			rows.Add(MakeRow(source, "bundle_textasset", assetName, ta.name, bytes.Length, Sha256(bytes), FirstHex(bytes, 24), ByteSignals(bytes), match ? "matching_textasset_candidate" : "nonmatching_textasset", ""));
		}

		static RecoveryRow MakeRow (SourceSpec source, string kind, string path, string objectName, int byteLength, string sha256, string firstHex, string byteSignals, string decision, string detail) {
			return new RecoveryRow {
				key = source.key,
				originalNode = source.originalNode,
				sourceBundle = source.sourceBundle,
				kind = kind,
				path = path,
				objectName = objectName,
				byteLength = byteLength,
				sha256 = sha256,
				firstHex = firstHex,
				byteSignals = byteSignals,
				decision = decision,
				detail = detail
			};
		}

		static string ByteSignals (byte[] bytes) {
			var replacements = 0;
			var questionMarks = 0;
			var nulls = 0;
			var spine40 = ContainsAscii(bytes, "4.0.");
			var pngRef = ContainsAscii(bytes, ".png");
			for (var i = 0; i < bytes.Length; i++) {
				if (bytes[i] == 0) nulls++;
				if (bytes[i] == 0x3f) questionMarks++;
				if (i + 2 < bytes.Length && bytes[i] == 0xef && bytes[i + 1] == 0xbf && bytes[i + 2] == 0xbd)
					replacements++;
			}
			return string.Format(CultureInfo.InvariantCulture, "replacementTriplets={0};questionMarks={1};nulls={2};containsSpine40={3};containsPngRef={4}", replacements, questionMarks, nulls, spine40, pngRef);
		}

		static bool ContainsAscii (byte[] bytes, string needle) {
			var needleBytes = Encoding.ASCII.GetBytes(needle);
			for (var i = 0; i <= bytes.Length - needleBytes.Length; i++) {
				var ok = true;
				for (var j = 0; j < needleBytes.Length; j++) {
					if (bytes[i + j] != needleBytes[j]) {
						ok = false;
						break;
					}
				}
				if (ok) return true;
			}
			return false;
		}

		static string FirstHex (byte[] bytes, int count) {
			var sb = new StringBuilder();
			for (var i = 0; i < bytes.Length && i < count; i++) {
				if (i > 0) sb.Append(' ');
				sb.Append(bytes[i].ToString("X2", CultureInfo.InvariantCulture));
			}
			return sb.ToString();
		}

		static string Sha256 (byte[] bytes) {
			using (var sha = SHA256.Create()) {
				var hash = sha.ComputeHash(bytes);
				var sb = new StringBuilder();
				foreach (var b in hash)
					sb.Append(b.ToString("x2", CultureInfo.InvariantCulture));
				return sb.ToString();
			}
		}

		static void CopyFile (string from, string to) {
			if (!File.Exists(from))
				throw new Exception("Missing file: " + from);
			Directory.CreateDirectory(Path.GetDirectoryName(to));
			File.Copy(from, to, true);
		}

		static void WriteBytes (string path, byte[] bytes) {
			Directory.CreateDirectory(Path.GetDirectoryName(path));
			File.WriteAllBytes(path, bytes ?? new byte[0]);
		}

		static void WriteOutputs (RecoveryResult result) {
			File.WriteAllText(ResultJsonPath, JsonUtility.ToJson(result, true), Encoding.UTF8);
			WriteCsv(result.rows);
			AssetDatabase.Refresh(ImportAssetOptions.ForceSynchronousImport);
		}

		static void WriteCsv (List<RecoveryRow> rows) {
			var sb = new StringBuilder();
			sb.AppendLine("key,originalNode,sourceBundle,kind,path,objectName,byteLength,sha256,firstHex,byteSignals,decision,detail");
			foreach (var row in rows) {
				sb.Append(Csv(row.key)).Append(',');
				sb.Append(Csv(row.originalNode)).Append(',');
				sb.Append(Csv(row.sourceBundle)).Append(',');
				sb.Append(Csv(row.kind)).Append(',');
				sb.Append(Csv(row.path)).Append(',');
				sb.Append(Csv(row.objectName)).Append(',');
				sb.Append(row.byteLength).Append(',');
				sb.Append(Csv(row.sha256)).Append(',');
				sb.Append(Csv(row.firstHex)).Append(',');
				sb.Append(Csv(row.byteSignals)).Append(',');
				sb.Append(Csv(row.decision)).Append(',');
				sb.Append(Csv(row.detail)).AppendLine();
			}
			File.WriteAllText(ResultCsvPath, sb.ToString(), Encoding.UTF8);
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
			public readonly string fileStem;
			public readonly string sourceBundle;
			public readonly string cleanBundleRelative;
			public readonly string extractedSkelRelative;
			public readonly string extractedAtlasRelative;
			public readonly string extractedPngRelative;
			public readonly string animation;
			public readonly float originalLocalScale;

			public SourceSpec (string key, string originalNode, string fileStem, string sourceBundle, string cleanBundleRelative, string extractedSkelRelative, string extractedAtlasRelative, string extractedPngRelative, string animation, float originalLocalScale) {
				this.key = key;
				this.originalNode = originalNode;
				this.fileStem = fileStem;
				this.sourceBundle = sourceBundle;
				this.cleanBundleRelative = cleanBundleRelative;
				this.extractedSkelRelative = extractedSkelRelative;
				this.extractedAtlasRelative = extractedAtlasRelative;
				this.extractedPngRelative = extractedPngRelative;
				this.animation = animation;
				this.originalLocalScale = originalLocalScale;
			}
		}

		[Serializable]
		sealed class RecoveryResult {
			public string generatedAt;
			public string status;
			public int visualFixApplied;
			public string blocker;
			public List<RecoverySummary> summaries;
			public List<RecoveryRow> rows;
		}

		[Serializable]
		sealed class RecoverySummary {
			public string key;
			public string originalNode;
			public string sourceBundle;
			public string animation;
			public float originalLocalScale;
			public string cleanBundlePath;
			public string extractedSkelPath;
			public int bundleTextAssetCount;
			public int matchingTextAssetCount;
			public int exportedRawCandidateCount;
			public bool importAttempted;
			public bool decodeRecovered;
			public bool visualFixApplied;
			public bool animationFound;
			public int boneCount;
			public int slotCount;
			public int animationCount;
			public string decision;
			public string blocker;
		}

		[Serializable]
		sealed class RecoveryRow {
			public string key;
			public string originalNode;
			public string sourceBundle;
			public string kind;
			public string path;
			public string objectName;
			public int byteLength;
			public string sha256;
			public string firstHex;
			public string byteSignals;
			public string decision;
			public string detail;
		}
	}
}
