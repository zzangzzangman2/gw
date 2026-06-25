# MainInterface Route Spine Slot/Bone/Animation Transform Result

Generated: 2026-06-25 21:25:06 KST

## Verdict

Visual verdict: MainInterface is still not a normal/restored UI. UI113 attempted to open `Spine_shijieanniu` and `8007` through the existing Spine 4.0 probe, but no evidence-backed visual fix was applied to the MainInterface scene.

This probe did not produce attachment world-bounds rows. `Spine_shijieanniu` creates atlas/material/SkeletonDataAsset files but exposes empty runtime bones/slots/animations, while `8007` fails SkeletonBinary decode. Placing cloud/person bitmaps from this state would still be guessed placement.

## Counts

| metric | value |
| --- | ---: |
| probe status | `spine_runtime_transform_evidence_collected_partial` |
| visual fixes applied | `0` |
| total attachment rows | 0 |
| target route attachment rows | 0 |
| cloud rows (`yun/yun2`) | 0 |
| 8007 run pose rows | 0 |

## Skeleton Runtime Evidence

| skeleton | original node | animation | found | duration | bones | slots | visible rows | target rows | decision |
| --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| `Spine_shijieanniu` | `spine_diqiu` | `A` | False | 0.0 | 0 | 0 | 0 | 0 | `blocked_empty_or_unreadable_runtime_skeleton_data` |
| `8007` | `spine_xiaoren` | `run` | False | 0.0 | 0 | 0 | 0 | 0 | `blocked_8007_skeletonbinary_decode_failed` |

## Decision Counts

| decision | count |
| --- | ---: |

## Key Findings

- `Spine_shijieanniu` imported far enough to create atlas/material/SkeletonDataAsset files, but the runtime SkeletonData exposed `0` usable bones/slots/animations in this probe, so no `yun/yun2` slot transform was applied.
- `spine_xiaoren/8007` preserved original node scale evidence `0.5`, but its `8007.skel.bytes` fails Spine 4.0 SkeletonBinary decode with `IndexOutOfRangeException`. It remains blocked rather than replaced by a whole texture.
- No final-capture debug text, fake icon, whole atlas placement, or guessed cloud/person placement was added.

## Outputs

- JSON: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\maininterface_route_spine_slot_bone_animation_transform.json`
- CSV: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_route_spine_slot_bone_animation_transform.csv`
- Tool: `C:\Users\godho\Downloads\girlswar\_restore_tools\113_RESTORE_MAININTERFACE_ROUTE_SPINE_SLOT_BONE_ANIMATION_TRANSFORM.cmd`
- Probe log: `C:\Users\godho\Downloads\girlswar\reports\maininterface\unity_113_spine_route_cluster_transform_probe.log`

## Verification

| check | result |
| --- | --- |
| graphics capture | `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreCaptures\maininterface_restored_1680x720.png` |
| capture exists/size/time | `True / 1525113 / 2026-06-25 21:25:02` |
| click validation generated | `2026-06-25 21:25:07` |
| active/clickable/blocked/invoked | `24 / 24 / 0 / 24` |

## Remaining Blocker

Next blocker: `route SpineGraphic runtime replay / raw skeleton decode recovery`. The current extracted/imported skeleton data is not enough to place `yun/yun2` or `spine_xiaoren/8007` safely in the final capture.
