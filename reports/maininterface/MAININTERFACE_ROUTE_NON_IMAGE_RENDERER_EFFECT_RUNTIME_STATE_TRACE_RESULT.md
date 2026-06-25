# MainInterface Route Non-Image Renderer/Effect Runtime State Trace Result

Generated: 2026-06-25 21:02:00 KST

## Verdict

화면 기준으로 MainInterface는 아직 정상 UI가 아니다. 이번 112 단계에서는 새 visual fix를 적용하지 않았다.

오른쪽 route cluster의 남은 문제는 `text_name` RectTransform이 아니라 `wanfaWorldNode` 주변의 Spine/SkeletonGraphic/particle-style runtime state 쪽으로 좁혀진다. `Spine_shijieanniu`의 `zhuye_di1`, `diqiu`, `zhuye_bian` 3개 레이어는 이미 evidence 기반 fallback으로 적용되어 있고, `yun/yun2`, `spine_xiaoren/8007`, `un_MainInterface_fire`는 현재 증거만으로는 강제 표시하면 좌표/whole-atlas/런타임 추정 복원이 된다.

## Counts

| metric | value |
| --- | ---: |
| trace rows | 24 |
| applyable_already_applied | 4 |
| blocked | 5 |
| trace-only | 15 |
| new visual fixes applied | 0 |

## Decision Counts

| decision | count |
| --- | ---: |
| `blocked_particle_runtime_material_binding` | 4 |
| `blocked_spine_runtime_slot_bone_animation_required` | 1 |
| `keep_existing_region_layer` | 3 |
| `keep_existing_three_layer_bitmap_fallback` | 1 |
| `preserve_original_inactive_guide_state` | 1 |
| `preserve_original_route_parent_state` | 6 |
| `preserve_original_zero_scale_runtime_state` | 2 |
| `trace_only_inactive_parent_chain` | 1 |
| `trace_only_preserve_original_state` | 2 |
| `trace_only_redpoint_skeleton_child_inactive` | 1 |
| `trace_only_slot_transform_missing` | 2 |

## Key Renderer/Effect Decisions

| candidate | class | decision | evidence | reason |
| --- | --- | --- | --- | --- |
| `spine_diqiu` | `applyable_already_applied` | `keep_existing_three_layer_bitmap_fallback` | Spine_shijieanniu_SkeletonData; download/ui/uiprefabandres/maininterface_ext_8.assetbundle; anim=A; renderers=2/15 | SkeletonGraphic evidence points to Spine_shijieanniu; only atlas regions with clear worldwanfaBtn/frame evidence are allowed. zhuye_di1/diqiu/zhuye_bian are already applied. |
| `spine_xiaoren` | `blocked` | `blocked_spine_runtime_slot_bone_animation_required` | 8007_SkeletonData; download/roleprefabsandres/npcprefabandres/8007.assetbundle; anim=run; renderers=2/15 | 8007 texture and SkeletonData are known, but the active node uses animation run at localScale 0.5; applying a whole texture or guessed crop would violate sprite/slot evidence gates. |
| `diqiu` | `applyable_already_applied` | `keep_existing_region_layer` | 704x706 normalized into 253x253; applied=True; Assets/RestoreData/route_renderer_fallbacks/Spine_shijieanniu_diqiu.png | Globe attachment is proven under active spine_diqiu; current fallback is intentionally normalized to the original button rect until Spine runtime is restored. |
| `yun` | `trace-only` | `trace_only_slot_transform_missing` | 83x36; applied=False; Assets/RestoreData/route_renderer_fallbacks/Spine_shijieanniu_yun.png | Cloud region is cropped, but original Spine slot/bone transform is not decoded; placing it by eye would be coordinate-only. |
| `yun2` | `trace-only` | `trace_only_slot_transform_missing` | 108x65; applied=False; Assets/RestoreData/route_renderer_fallbacks/Spine_shijieanniu_yun2.png | Cloud region is cropped, but original Spine slot/bone transform is not decoded; placing it by eye would be coordinate-only. |
| `zhuye_bian` | `applyable_already_applied` | `keep_existing_region_layer` | 238x238; applied=True; Assets/RestoreData/route_renderer_fallbacks/Spine_shijieanniu_zhuye_bian.png | Border/rim layer is same skeleton atlas and centered under worldwanfaBtn. |
| `zhuye_di1` | `applyable_already_applied` | `keep_existing_region_layer` | 253x253; applied=True; Assets/RestoreData/route_renderer_fallbacks/Spine_shijieanniu_zhuye_di1.png | Base disk/frame region matches original worldwanfaBtn 253x253 rect. |
| `un_MainInterface_fire` | `blocked` | `blocked_particle_runtime_material_binding` | particleRefs=3; activeChain=False; scale=0.0,0.0,0.0 | Original owner is inactive and/or zero-scale in route cluster evidence, while particle material/renderer fields are empty in current trace. Forcing it visible would violate active-chain and material evidence gates. |
| `un_MainInterface_fire` | `blocked` | `blocked_particle_runtime_material_binding` | particleRefs=3; activeChain=False; scale=1.0,1.0,1.0 | Original owner is inactive and/or zero-scale in route cluster evidence, while particle material/renderer fields are empty in current trace. Forcing it visible would violate active-chain and material evidence gates. |
| `un_MainInterface_fire` | `blocked` | `blocked_particle_runtime_material_binding` | particleRefs=3; activeChain=False; scale=0.0,0.0,0.0 | Original owner is inactive and/or zero-scale in route cluster evidence, while particle material/renderer fields are empty in current trace. Forcing it visible would violate active-chain and material evidence gates. |
| `un_MainInterface_fire` | `blocked` | `blocked_particle_runtime_material_binding` | particleRefs=3; activeChain=False; scale=1.0,1.0,1.0 | Original owner is inactive and/or zero-scale in route cluster evidence, while particle material/renderer fields are empty in current trace. Forcing it visible would violate active-chain and material evidence gates. |
| `Entry` | `trace-only` | `preserve_original_zero_scale_runtime_state` | activeChain=True; scale=0.0,0.0,0.0 | Entry localScale 0,0,0 is explicit original evidence for item 3/4 and must stay preserved. |
| `Entry` | `trace-only` | `preserve_original_zero_scale_runtime_state` | activeChain=True; scale=0.0,0.0,0.0 | Entry localScale 0,0,0 is explicit original evidence for item 3/4 and must stay preserved. |
| `fanhui_guide_shou` | `trace-only` | `preserve_original_inactive_guide_state` | activeChain=False; scale=1.0,1.0,1.0 | Guide hand parent is inactive in original active chain, so its SkeletonGraphic helpers must not be shown. |

## Outputs

- `Assets/RestoreData/maininterface_route_non_image_renderer_effect_runtime_state_trace.json`
- `Assets/RestoreData/reports/maininterface_route_non_image_renderer_effect_runtime_state_trace.csv`
- `_restore_tools\112_TRACE_MAININTERFACE_ROUTE_NON_IMAGE_RENDERER_EFFECT_RUNTIME_STATE.cmd`

## Verification

| check | result |
| --- | --- |
| graphics capture | `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreCaptures\maininterface_restored_1680x720.png` |
| capture exists/size | `True / 1525113` |
| capture generated | `2026-06-25 21:01:53 KST` |
| click validation generated | `2026-06-25 21:01:57` |
| active/clickable/blocked/invoked | `24 / 24 / 0 / 24` |

## Remaining Blocker

다음 blocker는 `spine_xiaoren/8007`와 `Spine_shijieanniu` 보류 region의 Spine runtime slot/bone/animation transform 복원이다. 현재 단계에서 texture만 더 얹는 것은 원본 runtime state 없이 화면을 꾸미는 방향이라 보류했다.
