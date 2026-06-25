# Hero 1001 Raw Spine TextAssets

## Summary

- Source bundle: `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\extracted\unity\clean_unityfs_slices\download\roleprefabsandres\paintingprefabandres\1001.assetbundle`
- Raw TextAssets: `8`
- Raw output: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\hero1001_spine_source_raw\paintingprefabandres_1001`
- Differing old exports: `8`
- Raw `?` byte count: `45096`
- Old `?` byte count: `250246`

## Why This Matters

The previous `.skel.bytes` copies were exported through a text path and contain replacement `?` bytes.
Spine 4.0 could import atlas/material files, but failed to read those corrupted skeleton binaries.
This extraction preserves the original TextAsset bytes and keeps the older export as evidence.

## Comparison

| asset | raw bytes | old bytes | raw head16 | old head16 | differs |
| --- | ---: | ---: | --- | --- | --- |
| `Painting_1001.atlas` | `4363` | `4668` | `50 61 69 6E 74 69 6E 67 5F 31 30 30 31 2E 70 6E` | `50 61 69 6E 74 69 6E 67 5F 31 30 30 31 2E 70 6E` | `True` |
| `Painting_1001.skel` | `596531` | `598675` | `8A F0 C5 F2 98 BF 89 25 07 34 2E 30 2E 35 36 C3` | `3F 3F 3F F2 98 BF 89 25 07 34 2E 30 2E 35 36 3F` | `True` |
| `Painting_1001_Back.atlas` | `200` | `213` | `50 61 69 6E 74 69 6E 67 5F 31 30 30 31 5F 42 61` | `50 61 69 6E 74 69 6E 67 5F 31 30 30 31 5F 42 61` | `True` |
| `Painting_1001_Back.skel` | `22756` | `22847` | `D5 8E F9 86 33 8B 35 83 07 34 2E 30 2E 35 36 C4` | `D5 8E 3F 3F 33 3F 35 3F 07 34 2E 30 2E 35 36 3F` | `True` |
| `Painting_1001_Front.atlas` | `199` | `213` | `50 61 69 6E 74 69 6E 67 5F 31 30 30 31 5F 46 72` | `50 61 69 6E 74 69 6E 67 5F 31 30 30 31 5F 46 72` | `True` |
| `Painting_1001_Front.skel` | `24368` | `24512` | `C1 06 12 D6 83 55 A7 FF 07 34 2E 30 2E 35 36 C4` | `3F 06 12 D6 83 55 3F 3F 07 34 2E 30 2E 35 36 3F` | `True` |
| `SP_heroname_1001.atlas` | `156` | `166` | `53 50 5F 68 65 72 6F 6E 61 6D 65 5F 31 30 30 31` | `53 50 5F 68 65 72 6F 6E 61 6D 65 5F 31 30 30 31` | `True` |
| `SP_heroname_1001.skel` | `5109` | `5166` | `61 FC EB A0 0B 91 41 F5 07 34 2E 30 2E 34 37 C3` | `61 3F 3F 3F 0B 3F 41 3F 07 34 2E 30 2E 34 37 C3` | `True` |

## Outputs

- CSV: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_hero1001_spine_raw_textassets.csv`
- JSON: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_hero1001_spine_raw_textassets_summary.json`
- Unity raw folder: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\hero1001_spine_source_raw\paintingprefabandres_1001`
- Merged raw folder: `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\extracted\unity\raw_textassets\download_roleprefabsandres_paintingprefabandres_1001`
