# MainInterface xLua raw TextAsset extraction

## Summary

- Source bundle: `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\extracted\unity\clean_unityfs_slices\download\xlualogic\modules\maininterface.assetbundle`
- Raw TextAssets: `36`
- Prefix counts: `{"A-EV": 32, "K7HT": 4}`
- Surrogate-escaped bytes recovered: `111815`
- Non-latin UTF-8 codepoints recovered: `3219`

## Why This Exists

- Previous TextAsset exports were useful evidence, but `.txt` writing through UTF-8 replacement can turn raw encrypted bytes into `?`.
- This extraction encodes UnityPy `m_Script` with `surrogateescape`, preserving the bytes Unity would expose through `TextAsset.bytes`.
- Source evidence is not deleted or overwritten; raw outputs are stored in a separate folder.

## Outputs

- CSV: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_xlua_textasset_raw.csv`
- JSON: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_xlua_textasset_raw_summary.json`
- Raw directory: `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\extracted\unity\raw_textassets\download_xlualogic_modules_maininterface`
