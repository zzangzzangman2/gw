# MainInterface 124 Hero1005 Raw Spine TextAssets

## Summary

- Source bundle: `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\extracted\unity\clean_unityfs_slices\download\roleprefabsandres\paintingprefabandres\1005.assetbundle`
- Raw TextAssets: `6`
- Raw output: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\hero1005_spine_source_raw\paintingprefabandres_1005`
- Differing old exports: `6`
- Raw `?` byte count: `28668`
- Old `?` byte count: `256529`

## Why This Matters

UI123 exported the 1005 Spine TextAssets through a text path. The main `.skel.bytes` contains replacement `?` bytes and Unity Spine could create asset wrappers but could not load SkeletonData.
UI124 preserves the original TextAsset bytes and keeps the UI123 folder untouched as evidence.

## Comparison

| asset | raw bytes | old bytes | raw head16 | old head16 | differs |
| --- | ---: | ---: | --- | --- | --- |
| `Painting_1005.atlas` | `4700` | `5019` | `50 61 69 6E 74 69 6E 67 5F 31 30 30 35 2E 70 6E` | `50 61 69 6E 74 69 6E 67 5F 31 30 30 35 2E 70 6E` | `True` |
| `Painting_1005.skel` | `571209` | `573747` | `1D 2D 6B 9B EC 3F FC 75 07 34 2E 30 2E 35 36 C4` | `1D 2D 6B 3F 3F 3F 3F 75 07 34 2E 30 2E 35 36 3F` | `True` |
| `Painting_1005_back.atlas` | `699` | `749` | `50 61 69 6E 74 69 6E 67 5F 31 30 30 35 5F 62 61` | `50 61 69 6E 74 69 6E 67 5F 31 30 30 35 5F 62 61` | `True` |
| `Painting_1005_back.skel` | `100542` | `100757` | `6C 9D 8A A2 9A 11 CE B5 07 34 2E 30 2E 35 36 C4` | `6C 3F 3F 3F 3F 11 CE B5 07 34 2E 30 2E 35 36 3F` | `True` |
| `SP_heroname_1005.atlas` | `156` | `166` | `53 50 5F 68 65 72 6F 6E 61 6D 65 5F 31 30 30 35` | `53 50 5F 68 65 72 6F 6E 61 6D 65 5F 31 30 30 35` | `True` |
| `SP_heroname_1005.skel` | `5074` | `5131` | `54 87 1D 87 8C EB B8 F9 07 34 2E 30 2E 34 37 C3` | `54 3F 1D 3F 3F 3F 3F 3F 07 34 2E 30 2E 34 37 C3` | `True` |

## Outputs

- CSV: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_124_hero1005_spine_raw_textassets.csv`
- JSON: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_124_hero1005_spine_raw_textassets_summary.json`
- Unity raw folder: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\hero1005_spine_source_raw\paintingprefabandres_1005`
- Merged raw folder: `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\extracted\unity\raw_textassets\download_roleprefabsandres_paintingprefabandres_1005`
