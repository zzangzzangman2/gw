# MainInterface 120 Trace Route SkeletonGraphic Original Runtime Mask Stencil Attachment Visibility Result

Generated: 2026-06-25 23:14:36 KST

## Verdict

화면 기준으로 MainInterface는 아직 정상 UI라고 말할 수 없다. UI120은 trace-only이며 흰 route 마름모/판을 좌표, 스케일, 임의 hide, whole-atlas, fake panel로 제거하지 않았다.

No evidence-backed hide/mask patch was found: zhuye_di1, zhuye_bian, and diqiu remain visible with alpha 1 in setup/animation samples, and no Mask/RectMask2D/non-zero stencil material ancestor is present.

## Counts

| metric | value |
| --- | ---: |
| visual fixes applied | `0` |
| targets considered/traced | `1 / 1` |
| attachment sample rows | `24` |
| timeline rows | `12` |
| candidate visible/off rows | `24 / 0` |
| clipping attachment rows | `6` |
| Mask/RectMask2D ancestor rows | `0` |
| non-zero stencil material rows | `0` |

## Target

| key | node | animation | mesh | CanvasRenderer texture | main texture | mask/stencil decision |
| --- | --- | --- | --- | --- | --- | --- |
| `Spine_shijieanniu` | `spine_diqiu` | `A` found=`True` dur=`10.0000` | `63/78 sub=1 bounds=253,253,0` | `` | `Spine_shijieanniu 1024x1024` | `trace_only_no_evidence_to_hide_route_frame_candidates; candidate visible/off=24/0` |

## Candidate Attachment Samples

| sample | time | drawOrder | slot | attachment | type | visible | alpha | color |
| --- | ---: | ---: | --- | --- | --- | --- | ---: | --- |
| `setup_pose` | `-1.0000` | `0` | `zhuye_di1` | `zhuye_di1` | `RegionAttachment` | `True` | `1.0000` | `1,1,1,1` |
| `setup_pose` | `-1.0000` | `1` | `zhuye_bian` | `zhuye_bian` | `RegionAttachment` | `True` | `1.0000` | `1,1,1,1` |
| `setup_pose` | `-1.0000` | `2` | `zong1` | `zong1` | `ClippingAttachment` | `True` | `1.0000` | `1,1,1,1` |
| `setup_pose` | `-1.0000` | `3` | `diqiu` | `diqiu` | `RegionAttachment` | `True` | `1.0000` | `1,1,1,1` |
| `animation_A` | `0.0000` | `0` | `zhuye_di1` | `zhuye_di1` | `RegionAttachment` | `True` | `1.0000` | `1,1,1,1` |
| `animation_A` | `0.0000` | `1` | `zhuye_bian` | `zhuye_bian` | `RegionAttachment` | `True` | `1.0000` | `1,1,1,1` |
| `animation_A` | `0.0000` | `2` | `zong1` | `zong1` | `ClippingAttachment` | `True` | `1.0000` | `1,1,1,1` |
| `animation_A` | `0.0000` | `3` | `diqiu` | `diqiu` | `RegionAttachment` | `True` | `1.0000` | `1,1,1,1` |
| `animation_A` | `1.2500` | `0` | `zhuye_di1` | `zhuye_di1` | `RegionAttachment` | `True` | `1.0000` | `1,1,1,1` |
| `animation_A` | `1.2500` | `1` | `zhuye_bian` | `zhuye_bian` | `RegionAttachment` | `True` | `1.0000` | `1,1,1,1` |
| `animation_A` | `1.2500` | `2` | `zong1` | `zong1` | `ClippingAttachment` | `True` | `1.0000` | `1,1,1,1` |
| `animation_A` | `1.2500` | `3` | `diqiu` | `diqiu` | `RegionAttachment` | `True` | `1.0000` | `1,1,1,1` |
| `animation_A` | `2.5000` | `0` | `zhuye_di1` | `zhuye_di1` | `RegionAttachment` | `True` | `1.0000` | `1,1,1,1` |
| `animation_A` | `2.5000` | `1` | `zhuye_bian` | `zhuye_bian` | `RegionAttachment` | `True` | `1.0000` | `1,1,1,1` |
| `animation_A` | `2.5000` | `2` | `zong1` | `zong1` | `ClippingAttachment` | `True` | `1.0000` | `1,1,1,1` |
| `animation_A` | `2.5000` | `3` | `diqiu` | `diqiu` | `RegionAttachment` | `True` | `1.0000` | `1,1,1,1` |
| `animation_A` | `3.7500` | `0` | `zhuye_di1` | `zhuye_di1` | `RegionAttachment` | `True` | `1.0000` | `1,1,1,1` |
| `animation_A` | `3.7500` | `1` | `zhuye_bian` | `zhuye_bian` | `RegionAttachment` | `True` | `1.0000` | `1,1,1,1` |
| `animation_A` | `3.7500` | `2` | `zong1` | `zong1` | `ClippingAttachment` | `True` | `1.0000` | `1,1,1,1` |
| `animation_A` | `3.7500` | `3` | `diqiu` | `diqiu` | `RegionAttachment` | `True` | `1.0000` | `1,1,1,1` |
| `animation_A` | `5.0000` | `0` | `zhuye_di1` | `zhuye_di1` | `RegionAttachment` | `True` | `1.0000` | `1,1,1,1` |
| `animation_A` | `5.0000` | `1` | `zhuye_bian` | `zhuye_bian` | `RegionAttachment` | `True` | `1.0000` | `1,1,1,1` |
| `animation_A` | `5.0000` | `2` | `zong1` | `zong1` | `ClippingAttachment` | `True` | `1.0000` | `1,1,1,1` |
| `animation_A` | `5.0000` | `3` | `diqiu` | `diqiu` | `RegionAttachment` | `True` | `1.0000` | `1,1,1,1` |

## Timeline Evidence

| type | slot | bone | frames | attachments | classification |
| --- | --- | --- | ---: | --- | --- |
| `DrawOrderTimeline` | `zhuye_di1` | `` | `1` | `` | `draw_order_timeline` |

## Mask And Stencil

| kind/source | path/material | enabled | detail | classification |
| --- | --- | --- | --- | --- |
| `MaskableGraphic` | `Canvas_MainInterface_1280x720/MainInterface_Root_From_RectTransform_CSV/UI_MainInterface__5568884429252053541/right__6922878451781464554/node_middle__9056630568254389742/wanfaWorldNode__-3820167396480157270/worldwanfaBtn__3512211464843089861/spine_diqiu__-1766545527926586392` | `True` | `maskable=True;raycast=False;alpha=0.0000;canvasTexture=` | `skeleton_graphic_maskable_state` |
| `Material:graphic.material` | `SkeletonGraphicDefault` | `` | `shader=Spine/SkeletonGraphic;tex=;stencil=0.0;comp=8.0;read/write=255.0/255.0` | `material_stencil_trace` |
| `Material:materialForRendering` | `SkeletonGraphicDefault` | `` | `shader=Spine/SkeletonGraphic;tex=;stencil=0.0;comp=8.0;read/write=255.0/255.0` | `material_stencil_trace` |
| `Material:canvasRenderer.GetMaterial(0)` | `SkeletonGraphicDefault` | `` | `shader=Spine/SkeletonGraphic;tex=;stencil=0.0;comp=8.0;read/write=255.0/255.0` | `material_stencil_trace` |
| `Material:additiveMaterial` | `SkeletonGraphicAdditive` | `` | `shader=Spine/SkeletonGraphic Additive;tex=;stencil=0.0;comp=8.0;read/write=255.0/255.0` | `material_stencil_trace` |
| `Material:multiplyMaterial` | `SkeletonGraphicMultiply` | `` | `shader=Spine/SkeletonGraphic Multiply;tex=;stencil=0.0;comp=8.0;read/write=255.0/255.0` | `material_stencil_trace` |
| `Material:screenMaterial` | `SkeletonGraphicScreen` | `` | `shader=Spine/SkeletonGraphic Screen;tex=;stencil=0.0;comp=8.0;read/write=255.0/255.0` | `material_stencil_trace` |

## Verification

| check | result |
| --- | --- |
| graphics capture reviewed | `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreCaptures\maininterface_route_spine_runtime_ui_material_bound_1680x720.png` |
| new visual capture generated | `False` |
| click validation generated | `2026-06-25 23:14:33` |
| active/clickable/blocked/invoked | `24 / 24 / 0 / 24` |
| root CMD count | `1` |
| root CMDs | `00_COMMAND_CENTER.cmd` |
| `_restore_tools` direct CMD count | `0` |
| `_restore_tools` direct CMDs | `` |

## Outputs

- JSON: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\maininterface_120_route_skeletongraphic_original_runtime_mask_stencil_attachment_visibility.json`
- CSV: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_120_route_skeletongraphic_original_runtime_mask_stencil_attachment_visibility.csv`
- Tool: `C:\Users\godho\Downloads\girlswar\_restore_tools\cmd_archive\120_TRACE_ROUTE_SKELETONGRAPHIC_ORIGINAL_RUNTIME_MASK_STENCIL_ATTACHMENT_VISIBILITY.cmd`

## Remaining Blocker

Next blocker: `route SkeletonGraphic CanvasRenderer texture handoff and clipping triangulation verification for zong1/zhuye_di1`.
