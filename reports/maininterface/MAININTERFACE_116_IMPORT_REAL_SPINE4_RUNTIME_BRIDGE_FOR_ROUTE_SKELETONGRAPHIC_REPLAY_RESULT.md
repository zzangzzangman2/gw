# MainInterface 116 Import Real Spine4 Runtime Bridge For Route SkeletonGraphic Replay Result

Generated: 2026-06-25 22:06:35 KST

## Verdict

화면 기준으로 MainInterface는 아직 정상 UI라고 말할 수 없다. 다만 UI116에서 route SkeletonGraphic replay 후보 캡처를 생성했다.

No coordinate-only placement, whole atlas placement, crop guessing, fake icon, debug/path/evidence overlay, or arbitrary route bitmap placement was added.

## A/B Path Decision

| path | chosen | result | reason |
| --- | ---: | --- | --- |
| A: import real Spine 4 runtime into `girlswar_maininterface_unity` | True | `partial_runtime_replay_capture_generated_manual_review_required` | MainInterface scene replay can only be proven inside the MainInterface project. |
| B: build replay scene inside existing Spine probe project | False | `fallback_only` | Lower risk, but it would remain diagnostic and not prove final MainInterface scene integration. |

## Counts

| metric | value |
| --- | ---: |
| Unity exit code | 0 |
| runtime package asset rows | 174 |
| runtime package bytes | 1318977 |
| runtime changed rows | 174 |
| route raw asset copied | 26 |
| main project Spine runtime ready | True |
| visual fixes applied | 2 |
| attached targets | 2 |
| initialized targets | 2 |
| capture exists | True |

## Target Replay Decisions

| target | node | scene node | SkeletonDataAsset | attached | initialized | decision | detail |
| --- | --- | ---: | ---: | ---: | ---: | --- | --- |
| `Spine_shijieanniu` | `spine_diqiu` | True | True | True | True | `applied_runtime_skeletongraphic_replay_candidate` | `SkeletonGraphic attached to original node with project SkeletonDataAsset and original starting animation.` |
| `8007` | `spine_xiaoren` | True | True | True | True | `applied_runtime_skeletongraphic_replay_candidate` | `SkeletonGraphic attached to original node with project SkeletonDataAsset and original starting animation.` |

## Verification

| check | result |
| --- | --- |
| replay capture | `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreCaptures\maininterface_route_spine_runtime_bridge_1680x720.png` |
| capture exists/size | `True / 1509391` |
| click validation generated | `2026-06-25 22:05:48` |
| active/clickable/blocked/invoked | `24 / 24 / 0 / 24` |
| root CMD count | `1` |
| root CMDs | `00_COMMAND_CENTER.cmd` |
| `_restore_tools` direct CMD count | `0` |

## Outputs

- JSON: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\maininterface_116_import_real_spine4_runtime_bridge_for_route_skeletongraphic_replay.json`
- CSV: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_116_import_real_spine4_runtime_bridge_for_route_skeletongraphic_replay.csv`
- Unity probe JSON: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\maininterface_116_spine_runtime_bridge_unity_probe.json`
- Unity probe CSV: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_116_spine_runtime_bridge_unity_probe.csv`
- Tool: `C:\Users\godho\Downloads\girlswar\_restore_tools\cmd_archive\116_IMPORT_REAL_SPINE4_RUNTIME_BRIDGE_FOR_ROUTE_SKELETONGRAPHIC_REPLAY.cmd`

## Remaining Blocker

Next blocker: `route SkeletonGraphic visual/layout validation against original/video evidence`.
