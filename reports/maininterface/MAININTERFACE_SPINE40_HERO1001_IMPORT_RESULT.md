# Spine 4.0 Hero 1001 Import Result

Generated: 2026-06-25 13:50:31

## Verdict

The probe created and loaded the 1001 SkeletonDataAsset files through Spine 4.0.

Next: Attach Painting_1001_SkeletonData.asset to a SkeletonGraphic under UI_heroSpine in the probe and capture graphics output.

## Run

| 항목 | 값 |
| --- | --- |
| status | `hero1001_skeletondata_ready_in_probe` |
| probe project | `C:\Users\godho\Downloads\girlswar\_restore_tools\work\spine40_unity6000_probe_20260625_134314` |
| Unity exit code | `1` |
| Unity log return code | `0` |
| batchmode success marker | `True` |
| hard log issue count | `0` |
| log | `C:\Users\godho\Downloads\girlswar\reports\maininterface\spine40_hero1001_import_latest.log` |

## Expected SkeletonDataAssets

| asset | exists | bytes |
| --- | --- | ---: |
| `Assets/RestoreData/hero1001_spine_source_raw/paintingprefabandres_1001/Painting_1001_SkeletonData.asset` | `True` | 1190 |
| `Assets/RestoreData/hero1001_spine_source_raw/paintingprefabandres_1001/Painting_1001_Front_SkeletonData.asset` | `True` | 1088 |
| `Assets/RestoreData/hero1001_spine_source_raw/paintingprefabandres_1001/Painting_1001_Back_SkeletonData.asset` | `True` | 1086 |
| `Assets/RestoreData/hero1001_spine_source_raw/paintingprefabandres_1001/SP_heroname_1001_SkeletonData.asset` | `True` | 1082 |

## Probe Log Lines

- line 532: `[GirlsWarRestore][SpineProbe] ImportHero1001 start`
- line 896: `[GirlsWarRestore][SpineProbe] SkeletonData OK path=Assets/RestoreData/hero1001_spine_source_raw/paintingprefabandres_1001/Painting_1001_SkeletonData.asset bones=326 slots=146 skins=1 animations=4`
- line 908: `[GirlsWarRestore][SpineProbe] SkeletonData OK path=Assets/RestoreData/hero1001_spine_source_raw/paintingprefabandres_1001/Painting_1001_Front_SkeletonData.asset bones=39 slots=4 skins=1 animations=4`
- line 920: `[GirlsWarRestore][SpineProbe] SkeletonData OK path=Assets/RestoreData/hero1001_spine_source_raw/paintingprefabandres_1001/Painting_1001_Back_SkeletonData.asset bones=32 slots=3 skins=1 animations=4`
- line 932: `[GirlsWarRestore][SpineProbe] SkeletonData OK path=Assets/RestoreData/hero1001_spine_source_raw/paintingprefabandres_1001/SP_heroname_1001_SkeletonData.asset bones=5 slots=6 skins=1 animations=2`
- line 944: `[GirlsWarRestore][SpineProbe] ImportHero1001 complete`

## Hard Issue Lines

- none

## Generated Assets Or Materials

- `Assets/RestoreData/hero1001_spine_source_raw/paintingprefabandres_1001/Painting_1001_Atlas.asset`
- `Assets/RestoreData/hero1001_spine_source_raw/paintingprefabandres_1001/Painting_1001_Back_Atlas.asset`
- `Assets/RestoreData/hero1001_spine_source_raw/paintingprefabandres_1001/Painting_1001_Back_Material-Screen.mat`
- `Assets/RestoreData/hero1001_spine_source_raw/paintingprefabandres_1001/Painting_1001_Back_Material.mat`
- `Assets/RestoreData/hero1001_spine_source_raw/paintingprefabandres_1001/Painting_1001_Back_SkeletonData.asset`
- `Assets/RestoreData/hero1001_spine_source_raw/paintingprefabandres_1001/Painting_1001_Front_Atlas.asset`
- `Assets/RestoreData/hero1001_spine_source_raw/paintingprefabandres_1001/Painting_1001_Front_Material-Additive.mat`
- `Assets/RestoreData/hero1001_spine_source_raw/paintingprefabandres_1001/Painting_1001_Front_Material.mat`
- `Assets/RestoreData/hero1001_spine_source_raw/paintingprefabandres_1001/Painting_1001_Front_SkeletonData.asset`
- `Assets/RestoreData/hero1001_spine_source_raw/paintingprefabandres_1001/Painting_1001_Material-Additive.mat`
- `Assets/RestoreData/hero1001_spine_source_raw/paintingprefabandres_1001/Painting_1001_Material-Screen.mat`
- `Assets/RestoreData/hero1001_spine_source_raw/paintingprefabandres_1001/Painting_1001_Material.mat`
- `Assets/RestoreData/hero1001_spine_source_raw/paintingprefabandres_1001/Painting_1001_SkeletonData.asset`
- `Assets/RestoreData/hero1001_spine_source_raw/paintingprefabandres_1001/SP_heroname_1001_Atlas.asset`
- `Assets/RestoreData/hero1001_spine_source_raw/paintingprefabandres_1001/SP_heroname_1001_Material-Additive.mat`
- `Assets/RestoreData/hero1001_spine_source_raw/paintingprefabandres_1001/SP_heroname_1001_Material.mat`
- `Assets/RestoreData/hero1001_spine_source_raw/paintingprefabandres_1001/SP_heroname_1001_SkeletonData.asset`

## Restore Meaning

- This is still probe-only evidence; the main restore project remains untouched.
- The next visual proof is a `SkeletonGraphic` under `UI_MainInterface/middle/UI_heroSpine`, using `DTmodelEntity.homePara=[1,0,0]`.
- A whole atlas PNG is still forbidden as a final visual substitute.

## Generated Files

- `Assets/RestoreData/reports/maininterface_spine40_hero1001_import_result.json`
- `reports/maininterface/spine40_hero1001_import_latest.log`
