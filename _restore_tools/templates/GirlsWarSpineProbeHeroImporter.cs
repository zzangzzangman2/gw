using System;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using Spine.Unity;
using Spine.Unity.Editor;

namespace GirlsWarRestore {
	public static class SpineProbeHeroImporter {
		const string HeroRoot = "Assets/RestoreData/hero1001_spine_source_raw/paintingprefabandres_1001";

		static readonly string[] ImportFiles = {
			HeroRoot + "/Painting_1001.png",
			HeroRoot + "/Painting_1001.atlas.txt",
			HeroRoot + "/Painting_1001.skel.bytes",
			HeroRoot + "/Painting_1001_Front.png",
			HeroRoot + "/Painting_1001_Front.atlas.txt",
			HeroRoot + "/Painting_1001_Front.skel.bytes",
			HeroRoot + "/Painting_1001_Back.png",
			HeroRoot + "/Painting_1001_Back.atlas.txt",
			HeroRoot + "/Painting_1001_Back.skel.bytes",
			HeroRoot + "/SP_heroname_1001.png",
			HeroRoot + "/SP_heroname_1001.atlas.txt",
			HeroRoot + "/SP_heroname_1001.skel.bytes",
		};

		static readonly string[] ExpectedSkeletonDataAssets = {
			HeroRoot + "/Painting_1001_SkeletonData.asset",
			HeroRoot + "/Painting_1001_Front_SkeletonData.asset",
			HeroRoot + "/Painting_1001_Back_SkeletonData.asset",
			HeroRoot + "/SP_heroname_1001_SkeletonData.asset",
		};

		public static void ImportHero1001 () {
			Debug.Log("[GirlsWarRestore][SpineProbe] ImportHero1001 start");

			foreach (string path in ImportFiles) {
				if (!System.IO.File.Exists(path)) {
					throw new Exception("[GirlsWarRestore][SpineProbe] Missing source file: " + path);
				}
				AssetDatabase.ImportAsset(path, ImportAssetOptions.ForceUpdate);
			}

			AssetUtility.ImportSpineContent(ImportFiles, new List<string>(), true);
			AssetDatabase.SaveAssets();
			AssetDatabase.Refresh(ImportAssetOptions.ForceSynchronousImport);

			foreach (string assetPath in ExpectedSkeletonDataAssets) {
				ValidateSkeletonDataAsset(assetPath);
			}

			Debug.Log("[GirlsWarRestore][SpineProbe] ImportHero1001 complete");
		}

		static void ValidateSkeletonDataAsset (string assetPath) {
			var skeletonDataAsset = AssetDatabase.LoadAssetAtPath<SkeletonDataAsset>(assetPath);
			if (skeletonDataAsset == null) {
				throw new Exception("[GirlsWarRestore][SpineProbe] Missing SkeletonDataAsset: " + assetPath);
			}

			var skeletonData = skeletonDataAsset.GetSkeletonData(true);
			if (skeletonData == null) {
				throw new Exception("[GirlsWarRestore][SpineProbe] SkeletonData load failed: " + assetPath);
			}

			Debug.Log(string.Format(
				"[GirlsWarRestore][SpineProbe] SkeletonData OK path={0} bones={1} slots={2} skins={3} animations={4}",
				assetPath,
				skeletonData.Bones.Count,
				skeletonData.Slots.Count,
				skeletonData.Skins.Count,
				skeletonData.Animations.Count
			));
		}
	}
}
