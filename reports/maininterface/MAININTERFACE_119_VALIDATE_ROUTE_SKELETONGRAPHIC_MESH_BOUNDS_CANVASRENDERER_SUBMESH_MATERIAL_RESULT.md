# MainInterface 119 Validate Route SkeletonGraphic Mesh Bounds CanvasRenderer Submesh Material Result

Generated: 2026-06-25 22:55:40 KST

## Verdict

화면 기준으로 MainInterface는 아직 정상 UI라고 말할 수 없다. UI119는 trace-only이며 흰 route 마름모/판을 좌표나 임의 hide로 제거하지 않았다.

이번 추적에서 큰 흰 영역은 `Spine_shijieanniu`의 원본 drawOrder attachment 후보(`zhuye_di1`, `zhuye_bian`, `diqiu`)와 연결된다. 특히 `zhuye_di1`는 원본 atlas region과 runtime bounds가 큰 route frame 계층에 해당하므로, 원본 runtime mask/stencil/attachment visibility 증거 없이 제거하면 규칙 위반이다.

## Counts

| metric | value |
| --- | ---: |
| visual fixes applied | `0` |
| targets considered/traced | `2 / 2` |
| submesh instructions | `0` |
| drawOrder attachment rows | `46` |
| high-white atlas regions | `0` |
| large route shape candidates | `3` |

## Target Mesh

| target | node | mesh vertices | mesh bounds | CanvasRenderer materials | CanvasRenderer texture | mask state | decision |
| --- | --- | ---: | --- | ---: | --- | --- | --- |
| `Spine_shijieanniu` | `spine_diqiu` | `63` | `0,0,0 / 253,253,0` | `1` | `` | `maskable=True;Mask=False;RectMask2D=False` | `trace_only_white_panel_source_narrowed_to_original_attachment_candidates` |
| `8007` | `spine_xiaoren` | `737` | `-14.039,79.9131,0 / 144.8493,162.6354,0` | `1` | `` | `maskable=True;Mask=False;RectMask2D=False` | `trace_only_white_panel_source_narrowed_to_original_attachment_candidates` |

## Submesh Materials

| target | submesh | slots | raw vertices | material | texture |
| --- | ---: | --- | ---: | --- | --- |

## Attachment Candidates

| target | drawOrder | slot | attachment | type | classification |
| --- | ---: | --- | --- | --- | --- |
| `Spine_shijieanniu` | `0` | `zhuye_di1` | `zhuye_di1` | `RegionAttachment` | `large_route_shape_candidate_from_original_attachment` |
| `Spine_shijieanniu` | `1` | `zhuye_bian` | `zhuye_bian` | `RegionAttachment` | `large_route_shape_candidate_from_original_attachment` |
| `Spine_shijieanniu` | `3` | `diqiu` | `diqiu` | `RegionAttachment` | `large_route_shape_candidate_from_original_attachment` |

## High-White Atlas Regions

| target | region | bounds | alpha ratio | whiteish ratio | average RGBA |
| --- | --- | --- | ---: | ---: | --- |

## Verification

| check | result |
| --- | --- |
| graphics capture reviewed | `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreCaptures\maininterface_route_spine_runtime_ui_material_bound_1680x720.png` |
| new visual capture generated | `False` |
| click validation generated | `2026-06-25 22:55:08` |
| active/clickable/blocked/invoked | `24 / 24 / 0 / 24` |
| root CMD count | `1` |
| root CMDs | `00_COMMAND_CENTER.cmd` |
| `_restore_tools` direct CMD count | `0` |
| `_restore_tools` direct CMDs | `` |

## Outputs

- JSON: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\maininterface_119_route_skeletongraphic_mesh_bounds_canvasrenderer_submesh_material.json`
- CSV: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_119_route_skeletongraphic_mesh_bounds_canvasrenderer_submesh_material.csv`
- Tool: `C:\Users\godho\Downloads\girlswar\_restore_tools\cmd_archive\119_VALIDATE_ROUTE_SKELETONGRAPHIC_MESH_BOUNDS_CANVASRENDERER_SUBMESH_MATERIAL.cmd`

## Remaining Blocker

Next blocker: `route SkeletonGraphic original runtime mask/stencil/attachment visibility state for zhuye_di1 and world route frame`.
