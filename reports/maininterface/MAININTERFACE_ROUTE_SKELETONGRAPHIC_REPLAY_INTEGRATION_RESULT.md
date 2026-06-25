# MainInterface Route SkeletonGraphic Replay Integration Result

Generated: 2026-06-25 21:50:02 KST

## Verdict

Visual verdict: MainInterface is still not a normal/restored UI. UI115 applied no visual fix because MainInterface does not yet have a proven in-scene SkeletonGraphic replay path.

No coordinate-only placement, whole atlas placement, crop guessing, fake icon, debug text, or path/evidence overlay was added to the final capture.

## Counts

| metric | value |
| --- | ---: |
| trace status | `route_skeletongraphic_replay_integration_trace_complete` |
| visual fixes applied | 0 |
| integrable targets | 0 |
| blocked targets | 2 |
| trace-only targets | 0 |
| main project SkeletonGraphic type | False |
| main project SkeletonDataAsset type | False |
| main project AtlasAsset type | False |
| main project Spine runtime ready | False |
| probe project Spine runtime ready | True |
| CSV rows | 2 |

## Target Decisions

| skeleton | node | scene node | original evidence | raw decode | animation | main runtime | raw asset in main | decision | blocker |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- | --- |
| `Spine_shijieanniu` | `spine_diqiu` | True | True | True | True | False | False | `blocked_main_project_missing_spine_runtime` | `Spine.Unity.SkeletonGraphic/SkeletonDataAsset/AtlasAsset types are not available in girlswar_maininterface_unity.` |
| `8007` | `spine_xiaoren` | True | True | True | True | False | False | `blocked_main_project_missing_spine_runtime` | `Spine.Unity.SkeletonGraphic/SkeletonDataAsset/AtlasAsset types are not available in girlswar_maininterface_unity.` |

## Decision Counts

| decision | count |
| --- | ---: |
| `blocked_main_project_missing_spine_runtime` | 2 |

## Key Findings

- UI114 proved clean UnityFS raw skeleton decode for `Spine_shijieanniu` and `8007`.
- UI115 confirms the original MainInterface route nodes, RectTransform evidence, SkeletonGraphic-like component rows, material references, atlas paths, texture paths, and starting animations are present in the extracted renderer trace.
- The generated MainInterface scene currently does not have real `Spine.Unity.SkeletonGraphic` / `SkeletonDataAsset` / `AtlasAsset` runtime types available in the main project. The real Spine 4 runtime lives in the separate probe project.
- Because the decoded SkeletonDataAsset is not imported into `girlswar_maininterface_unity` under a real Spine runtime, applying the probe bounds as bitmap/crop placement would violate the restore rules.

## Outputs

- JSON: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\maininterface_route_skeletongraphic_replay_integration.json`
- CSV: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_route_skeletongraphic_replay_integration.csv`
- Tool: `C:\Users\godho\Downloads\girlswar\_restore_tools\cmd_archive\115_ROUTE_SKELETONGRAPHIC_REPLAY_INTEGRATION_IN_MAININTERFACE.cmd`
- Unity trace log: `C:\Users\godho\Downloads\girlswar\reports\maininterface\unity_115_route_skeletongraphic_replay_integration.log`

## Verification

| check | result |
| --- | --- |
| graphics capture | `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreCaptures\maininterface_restored_1680x720.png` |
| capture exists/size/time | `True / 1525113 / 2026-06-25 21:49:53` |
| click validation generated | `2026-06-25 21:50:00` |
| active/clickable/blocked/invoked | `24 / 24 / 0 / 24` |

## Remaining Blocker

Next blocker: `import real Spine 4 runtime into girlswar_maininterface_unity or build MainInterface replay scene inside the Spine probe project`. Without that runtime bridge, the recovered skeletons cannot be attached as actual SkeletonGraphic components in the final MainInterface scene.
