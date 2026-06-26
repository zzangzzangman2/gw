# MainInterface 124 Reference Diff Result

## Verdict

Restored claim remains `false`. The UI124 capture now has a real Hero1005 SkeletonGraphic, but it still does not match the reference because the route/world cluster remains visible and draws above the hero by sibling-order evidence.

## Metrics

| region | mean abs diff | rms diff | changed pixel ratio >=30 | pixel correlation |
| --- | ---: | ---: | ---: | ---: |
| `full` | `0.265278` | `0.343341` | `0.860502` | `0.188564` |
| `top_bar` | `0.291487` | `0.380424` | `0.875696` | `0.110685` |
| `left_lobby` | `0.270011` | `0.347993` | `0.880997` | `0.162509` |
| `center_hero` | `0.256085` | `0.3327` | `0.853481` | `0.18055` |
| `right_cluster` | `0.266764` | `0.345988` | `0.832856` | `0.149644` |
| `bottom_nav` | `0.281403` | `0.350866` | `0.910804` | `0.061431` |

## Files

- reference: `C:\Users\godho\.codex\attachments\e607fc34-b674-4516-b051-8d396cd6df06\image-1.png`
- UI124 capture: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreCaptures\maininterface_ui124_hero1005_spine_1680x720.png`
- hero-only capture: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreCaptures\maininterface_ui124_hero1005_spine_hero_only_1680x720.png`
- contact sheet: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_124_REFERENCE_DIFF_CONTACT.png`
- JSON: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_124_reference_diff_summary.json`
- CSV: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_124_reference_diff_regions.csv`
