# MainInterface Route SpineGraphic Runtime Replay / Raw Skeleton Decode Recovery Result

Generated: 2026-06-25 21:34:39 KST

## Verdict

Visual verdict: MainInterface is still not a normal/restored UI. UI114 recovered at least one runtime SkeletonData decode in probe, but no MainInterface visual fix was applied without a proven in-scene SkeletonGraphic replay path.

No fake icon, debug/path text, whole atlas placement, guessed crop, or guessed cloud/person placement was added to the final capture.

## Counts

| metric | value |
| --- | ---: |
| probe status | `raw_decode_recovery_trace_complete` |
| visual fixes applied | 0 |
| decode recovered summaries | 2 |
| matching TextAsset candidates | 4 |
| exported raw candidates | 4 |
| CSV rows | 152 |
| matching bundle candidate rows | 4 |
| runtime attachment bounds rows | 140 |
| blocked/exception rows | 0 |

## Skeleton Decode Recovery Summary

| skeleton | node | matching TextAssets | exported raw | import attempted | decode recovered | bones | slots | animations | decision | blocker |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- | --- |
| `Spine_shijieanniu` | `spine_diqiu` | 2 | 2 | True | True | 8 | 9 | 1 | `decode_recovered_trace_only_no_main_visual_fix` | `` |
| `8007` | `spine_xiaoren` | 2 | 2 | True | True | 108 | 37 | 15 | `decode_recovered_trace_only_no_main_visual_fix` | `` |

## Key Findings

- The probe loaded clean UnityFS bundles directly through Unity `AssetBundle.LoadFromFile` and compared bundle `TextAsset.bytes` candidates against the existing extracted `.skel.txt` / `.atlas.txt` files.
- `Spine_shijieanniu` and `8007` are considered decode-recovered only when the clean bundle `TextAsset.bytes` import produces nonzero bones/slots and the requested animation is present.
- Runtime attachment bounds rows are probe evidence only. They were not converted into MainInterface bitmap placement because the final scene still needs an original `SkeletonGraphic` replay path or a proven skeleton-space to UI-space transform.

## Outputs

- JSON: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\maininterface_route_spinegraphic_runtime_replay_raw_skeleton_decode_recovery.json`
- CSV: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_route_spinegraphic_runtime_replay_raw_skeleton_decode_recovery.csv`
- Tool: `C:\Users\godho\Downloads\girlswar\_restore_tools\cmd_archive\114_ROUTE_SPINEGRAPHIC_RUNTIME_REPLAY_RAW_SKELETON_DECODE_RECOVERY.cmd`
- Probe log: `C:\Users\godho\Downloads\girlswar\reports\maininterface\unity_114_route_raw_decode_recovery_probe.log`

## Verification

| check | result |
| --- | --- |
| graphics capture | `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreCaptures\maininterface_restored_1680x720.png` |
| capture exists/size/time | `True / 1525113 / 2026-06-25 21:34:31` |
| click validation generated | `2026-06-25 21:34:37` |
| active/clickable/blocked/invoked | `24 / 24 / 0 / 24` |

## Remaining Blocker

Next blocker: `route SkeletonGraphic replay integration in MainInterface`. The raw decode and runtime bounds can now feed a real SkeletonGraphic/mesh replay, but final visual placement should not be done by guessed bitmap coordinates.
