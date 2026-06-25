# MainInterface TMP Text Details

Generated: 2026-06-25 14:56:43

## Verdict

MainInterface TMP-like text rows now have a dedicated field export. The restore builder should use this CSV to create `TextMeshProUGUI` components and preserve TMP layout fields instead of rendering them as `UnityEngine.UI.Text`.

## Counts

| item | value |
| --- | ---: |
| TMP text rows | 271 |
| matched original TMP FontAsset rows | 271 |
| unmatched TMP FontAsset rows | 0 |

## FontAsset Usage

| font pathID | rows | matched asset | family | bundle |
| --- | ---: | --- | --- | --- |
| `2268522548353052838` | 162 | `riyu` | `DFMincho-SU` | `download/ui/uifont/japanese/tmp/riyu.assetbundle` |
| `-724809986894116682` | 98 | `EPM` | `EPSON ?????S?V?b?N???a` | `download/ui/uifont/japanese/tmp/epm.assetbundle` |
| `454391846754054610` | 11 | `num` | `Impact` | `download/ui/uifont/japanese/tmp/num.assetbundle` |

## Restore Notes

1. `display_text` comes from the already decoded text CSV, because some raw `m_text` values in the Unity tree are mojibake.
2. `resolved_alignment` is derived from `m_HorizontalAlignment | m_VerticalAlignment` when `m_textAlignment` is `65535`.
3. Original TMP FontAsset pathIDs match the uifont TMP inventory, but the Unity project still needs reconstructed/imported TMP FontAsset assets for final font fidelity.
4. This export is the input for the first TMP builder pass.

## Generated Files

- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\maininterface_text_tmp_details.csv`
- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_text_tmp_details_summary.json`
