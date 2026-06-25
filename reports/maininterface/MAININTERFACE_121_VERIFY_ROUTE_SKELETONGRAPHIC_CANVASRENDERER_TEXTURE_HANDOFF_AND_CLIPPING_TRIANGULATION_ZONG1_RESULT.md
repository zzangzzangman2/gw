# MainInterface 121 Verify Route SkeletonGraphic CanvasRenderer Texture Handoff And Clipping Triangulation Zong1 Result

Generated: 2026-06-25 23:28:25 KST

## Verdict

화면 기준으로 MainInterface는 아직 정상 UI라고 말할 수 없다. UI121은 trace-only이며 좌표/스케일/임의 hide/whole-atlas/fake panel 없이 `zong1` clipping과 texture handoff만 검증했다.

zhuye_di1/zhuye_bian are confirmed pre-clipping attachments and should not be hidden by zong1; zong1 clipping affects later attachments such as diqiu. Texture handoff is present through SkeletonGraphic.mainTexture/baseTexture/atlas primary material, while CanvasRenderer.GetTexture may remain empty via reflection.

## Counts

| metric | value |
| --- | ---: |
| visual fixes applied | `0` |
| targets considered/traced | `1 / 1` |
| clip rows / clipped rows | `9 / 6` |
| pre-clip zhuye rows | `2` |
| UV region rows | `5` |
| texture present / expected-missing rows | `11 / 3` |

## Target

| key | mesh | instructions | texture path | decision |
| --- | --- | --- | --- | --- |
| `Spine_shijieanniu` | `63/78 sub=1 bounds=253,253,0` | `found=True;activeClip=True;submesh=1` | `main=Spine_shijieanniu 1024x1024;base=Spine_shijieanniu 1024x1024;canvas=` | `trace_only_clipping_and_texture_handoff_verified_no_visual_patch` |

## Clipping

| drawOrder | slot | attachment | clip active | raw verts/tris | clipped verts/tris | bounds | classification |
| ---: | --- | --- | --- | --- | --- | --- | --- |
| `0` | `zhuye_di1` | `zhuye_di1` | `False` | `4/2` | `4/2` | `-1.265,-1.265,1.265,1.265 -> -1.265,-1.265,1.265,1.265` | `pre_clipping_unclipped_attachment` |
| `1` | `zhuye_bian` | `zhuye_bian` | `False` | `4/2` | `4/2` | `-1.19,-1.19,1.19,1.19 -> -1.19,-1.19,1.19,1.19` | `pre_clipping_unclipped_attachment` |
| `2` | `zong1` | `zong1` | `True` | `13/0` | `13/0` | ` -> ` | `clip_start_zong1` |
| `3` | `diqiu` | `diqiu` | `True` | `4/2` | `15/11` | `-1.6896,-2.9247,1.6896,0.4641 -> -1.207,-1.2058,1.2048,0.4641` | `clipping_applied_geometry_changed` |
| `4` | `yun3` | `yun` | `True` | `4/2` | `7/3` | `-0.0558,0.3893,0.7874,0.9313 -> -0.0558,0.3893,0.726,0.9313` | `clipping_applied_geometry_changed` |
| `5` | `yun2` | `yun2` | `True` | `4/2` | `7/3` | `0.3918,0.2391,1.4759,1.1124 -> 0.3918,0.2391,0.8791,0.786` | `clipping_applied_geometry_changed` |
| `6` | `yun4` | `yun2` | `True` | `4/2` | `6/2` | `-1.4111,0.0834,-0.1788,1.0762 -> -1.1182,0.1056,-0.1788,0.8834` | `clipping_applied_geometry_changed` |
| `7` | `yun` | `yun` | `True` | `4/2` | `7/3` | `-0.6046,0.4839,0.2146,1.0106 -> -0.5453,0.4839,0.2146,0.9429` | `clipping_applied_geometry_changed` |
| `8` | `yun5` | `yun` | `True` | `4/2` | `0/0` | `-1.5638,0.6769,-0.7446,1.2036 -> ` | `clipping_applied_geometry_changed` |

## Mesh UV Regions

| region | atlas bounds | UV bounds | mesh vertices | mesh triangles | mesh bounds | classification |
| --- | --- | --- | ---: | ---: | --- | --- |
| `zhuye_di1` | `2,2,253,253` | `0.002,0.751,0.249,0.998` | `4` | `2` | `-126.5,-126.5,0/126.5,126.5,0` | `mesh_uv_region_present` |
| `zhuye_bian` | `257,17,238,238` | `0.251,0.751,0.4834,0.9834` | `4` | `2` | `-119,-119,0/119,119,0` | `mesh_uv_region_present` |
| `diqiu` | `2,257,704,706` | `0.002,0.0596,0.6895,0.749` | `15` | `11` | `-120.7,-120.58,0/120.48,46.4063,0` | `mesh_uv_region_present` |
| `yun` | `497,152,83,36` | `0.4854,0.8164,0.5664,0.8516` | `14` | `6` | `-54.5339,38.9265,0/72.5964,94.2935,0` | `mesh_uv_region_present` |
| `yun2` | `497,190,108,65` | `0.4854,0.751,0.5908,0.8145` | `13` | `5` | `-111.824,10.5557,0/87.9096,88.3378,0` | `mesh_uv_region_present` |

## Texture Handoff

| source | actual | expected | present | matches main | classification |
| --- | --- | --- | --- | --- | --- |
| `SkeletonGraphic.mainTexture` | `Spine_shijieanniu 1024x1024` | `Spine_shijieanniu 1024x1024` | `True` | `True` | `texture_present` |
| `private baseTexture` | `Spine_shijieanniu 1024x1024` | `Spine_shijieanniu 1024x1024` | `True` | `True` | `texture_present` |
| `private overrideTexture` | `` | `Spine_shijieanniu 1024x1024` | `False` | `False` | `texture_absent_allowed_for_this_api` |
| `graphic.material.mainTexture` | `` | `Spine_shijieanniu 1024x1024` | `False` | `False` | `texture_missing_on_expected_handoff` |
| `materialForRendering.mainTexture` | `` | `Spine_shijieanniu 1024x1024` | `False` | `False` | `texture_missing_on_expected_handoff` |
| `canvasRenderer.GetTexture` | `` | `Spine_shijieanniu 1024x1024` | `False` | `False` | `texture_absent_allowed_for_this_api` |
| `canvasRenderer.GetMaterial(0).mainTexture` | `` | `Spine_shijieanniu 1024x1024` | `False` | `False` | `texture_missing_on_expected_handoff` |
| `atlasAssets[0].PrimaryMaterial.mainTexture` | `Spine_shijieanniu 1024x1024` | `Spine_shijieanniu 1024x1024` | `True` | `True` | `texture_present` |
| `attachment.RendererObject:zhuye_di1` | `Spine_shijieanniu 1024x1024` | `Spine_shijieanniu 1024x1024` | `True` | `True` | `texture_present` |
| `attachment.RendererObject:zhuye_bian` | `Spine_shijieanniu 1024x1024` | `Spine_shijieanniu 1024x1024` | `True` | `True` | `texture_present` |
| `attachment.RendererObject:diqiu` | `Spine_shijieanniu 1024x1024` | `Spine_shijieanniu 1024x1024` | `True` | `True` | `texture_present` |
| `attachment.RendererObject:yun` | `Spine_shijieanniu 1024x1024` | `Spine_shijieanniu 1024x1024` | `True` | `True` | `texture_present` |
| `attachment.RendererObject:yun2` | `Spine_shijieanniu 1024x1024` | `Spine_shijieanniu 1024x1024` | `True` | `True` | `texture_present` |
| `attachment.RendererObject:yun2` | `Spine_shijieanniu 1024x1024` | `Spine_shijieanniu 1024x1024` | `True` | `True` | `texture_present` |
| `attachment.RendererObject:yun` | `Spine_shijieanniu 1024x1024` | `Spine_shijieanniu 1024x1024` | `True` | `True` | `texture_present` |
| `attachment.RendererObject:yun` | `Spine_shijieanniu 1024x1024` | `Spine_shijieanniu 1024x1024` | `True` | `True` | `texture_present` |

## Renderer Instruction

| submesh | slots | preActiveClip | material | texture | raw | classification |
| ---: | --- | ---: | --- | --- | --- | --- |
| `0` | `0-9 count=9` | `-1` | `Spine_shijieanniu_Material / Spine/Skeleton / Spine_shijieanniu 1024x1024` | `Spine_shijieanniu 1024x1024` | `32/48` | `skeleton_renderer_instruction_submesh` |

## Verification

| check | result |
| --- | --- |
| graphics capture reviewed | `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreCaptures\maininterface_route_spine_runtime_ui_material_bound_1680x720.png` |
| new visual capture generated | `False` |
| click validation generated | `2026-06-25 23:22:51` |
| active/clickable/blocked/invoked | `24 / 24 / 0 / 24` |
| root CMD count | `1` |
| root CMDs | `00_COMMAND_CENTER.cmd` |
| `_restore_tools` direct CMD count | `0` |
| `_restore_tools` direct CMDs | `` |

## Outputs

- JSON: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\maininterface_121_route_skeletongraphic_canvasrenderer_texture_handoff_clipping_zong1.json`
- CSV: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_121_route_skeletongraphic_canvasrenderer_texture_handoff_clipping_zong1.csv`
- Tool: `C:\Users\godho\Downloads\girlswar\_restore_tools\cmd_archive\121_VERIFY_ROUTE_SKELETONGRAPHIC_CANVASRENDERER_TEXTURE_HANDOFF_AND_CLIPPING_TRIANGULATION_ZONG1.cmd`

## Remaining Blocker

Next blocker: `route frame visual mismatch likely original art/style expectation or SkeletonGraphic material property block texture path capture review, not evidence-backed zhuye hide`.
