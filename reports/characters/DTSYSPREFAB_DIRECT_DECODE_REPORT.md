# DTSysPrefab Direct Decode Report

- Status: `direct_raw_gzip_flatbuffer_decode_ok`
- Bundle: `girlswar_merged_extracted/extracted/unity/clean_unityfs_slices/download/datatable/sys.assetbundle`
- TextAsset pathID: `6885155417360981632`
- Raw serialized object bytes: `225748`
- Gzip stream offset: `20`
- Decompressed FlatBuffer bytes: `1720248`
- Decoded rows: `10302`
- Battle relevant ids: `20`; found `20`

## Note
extracted/unity/bundles/.../6885155417360981632_DTSysPrefab.txt is lossy because UnityPy read().script converted non-UTF bytes to '?'; get_raw_data() preserves the gzip stream.

## Outputs
- JSON: `reports/characters/DTSYSPREFAB_DIRECT_DECODE_REPORT.json`
- Battle relevant CSV: `reports/characters/DTSYSPREFAB_BATTLE_RELEVANT_ROWS.csv`
