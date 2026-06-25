# MainInterface 118 Bind Route SkeletonGraphic UI Material Shader Pass From Original Fields Result

Generated: 2026-06-25 22:38:17 KST

## Verdict

화면 기준으로 MainInterface는 아직 정상 UI라고 말할 수 없다. UI118은 원본 SkeletonGraphic material slot과 Spine runtime 기본 material evidence에 따라 UI용 SkeletonGraphic shader/pass를 바인딩한 partial 후보이다.

Manual visual review: UI118 capture still shows the large white route diamond/panel seen in UI117, so shader/pass binding alone did not resolve the route cluster visual defect.

좌표, scale, RectTransform, sibling order, whole atlas, crop, fake icon, debug/path text는 건드리지 않았다. 최종 캡처는 여전히 수동 시각 검토 대상이다.

## Counts

| metric | value |
| --- | ---: |
| visual fixes applied | `2` |
| targets considered | `2` |
| targets bound | `2` |
| original refs present | `2` |
| additive/multiply/screen bound | `2 / 2 / 2` |
| SkeletonGraphic.cs.meta default material evidence | `True` |
| capture exists/size | `True / 1447439` |
| visible/magenta/whiteish pixels | `1201680 / 223 / 160880` |

## Shader Probes

| shader | found | supported | pass count |
| --- | ---: | ---: | ---: |
| `Spine/Skeleton` | `True` | `True` | `2` |
| `Spine/SkeletonGraphic` | `True` | `True` | `1` |
| `Spine/SkeletonGraphic Additive` | `True` | `True` | `1` |
| `Spine/SkeletonGraphic Multiply` | `True` | `True` | `1` |
| `Spine/SkeletonGraphic Screen` | `True` | `True` | `1` |
| `Spine/SkeletonGraphic Tint Black` | `True` | `True` | `1` |
| `UI/Default` | `True` | `True` | `1` |

## Target Binding

| target | node | before | after | decision |
| --- | --- | --- | --- | --- |
| `Spine_shijieanniu` | `spine_diqiu` | `Spine_shijieanniu_Material / Spine/Skeleton` | `SkeletonGraphicDefault / Spine/SkeletonGraphic / pass 1` | `applied_evidence_backed_skeletongraphic_ui_material_binding` |
| `8007` | `spine_xiaoren` | `8007_Material / Spine/Skeleton` | `SkeletonGraphicDefault / Spine/SkeletonGraphic / pass 1` | `applied_evidence_backed_skeletongraphic_ui_material_binding` |

## Verification

| check | result |
| --- | --- |
| bound scene | `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\Scenes\MainInterface_RouteSpineRuntimeReplay_UIMaterialBound.unity` |
| graphics capture | `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreCaptures\maininterface_route_spine_runtime_ui_material_bound_1680x720.png` |
| click validation generated | `2026-06-25 22:37:21` |
| active/clickable/blocked/invoked | `24 / 24 / 0 / 24` |
| root CMD count | `1` |
| root CMDs | `00_COMMAND_CENTER.cmd` |
| `_restore_tools` direct CMD count | `0` |
| `_restore_tools` direct CMDs | `` |

## Outputs

- JSON: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\maininterface_118_route_skeletongraphic_ui_material_shader_pass_binding.json`
- CSV: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_118_route_skeletongraphic_ui_material_shader_pass_binding.csv`
- Tool: `C:\Users\godho\Downloads\girlswar\_restore_tools\cmd_archive\118_BIND_ROUTE_SKELETONGRAPHIC_UI_MATERIAL_SHADER_PASS_FROM_ORIGINAL_FIELDS.cmd`

## Remaining Blocker

Next blocker: `route SkeletonGraphic mesh bounds and CanvasRenderer submesh material validation against original runtime fields`.
