# MainInterface 117 Validate And Fix Route SkeletonGraphic Layout Against Original Evidence Result

Generated: 2026-06-25 22:25:36 KST

## Verdict

화면 기준으로 MainInterface는 아직 정상 UI라고 말할 수 없다. UI117은 원본 SpineGraphic이 확인된 후보 씬에서 이전 bitmap fallback 이중 렌더 가능성만 제거한 partial 후보이다.

Manual visual review: validated capture still shows a large white route diamond/panel around the world route cluster, so this is partial evidence cleanup, not a normal final MainInterface.

좌표 보정, whole atlas 배치, crop guessing, fake icon, debug/path/evidence overlay는 추가하지 않았다. UI117 패치는 별도 replay 후보 씬에서 원본 SkeletonGraphic runtime evidence가 붙은 경우에만 synthetic fallback 레이어를 비활성화한다.

## Counts

| metric | value |
| --- | ---: |
| visual fixes applied | `3` |
| skeleton targets found | `2` |
| SkeletonGraphic attached | `2` |
| Rect/sibling evidence matched | `2` |
| animation evidence matched | `2` |
| route TMP rows | `6` |
| route TMP variant ok | `6` |
| interim fallback rows | `3` |
| interim fallback suppressed | `3` |
| capture exists/size | `True / 1447439` |
| visible pixels | `1201680` |
| magenta pixels | `223` |

## SkeletonGraphic Evidence

| target | node | rect/sibling | animation | material | decision |
| --- | --- | --- | --- | --- | --- |
| `Spine_shijieanniu` | `spine_diqiu` | `0,-1 / 100,100 / 1,1,1 / sibling 0` | `A / expected A` | `Spine_shijieanniu_Material / Spine/Skeleton` | `evidence_matched_runtime_replay_candidate` |
| `8007` | `spine_xiaoren` | `-77.9,-15.4 / 100,100 / 0.5,0.5,0.5 / sibling 1` | `run / expected run` | `8007_Material / Spine/Skeleton` | `evidence_matched_runtime_replay_candidate` |

## Interim Fallback Decision

| layer | active after | decision | reason |
| --- | ---: | --- | --- |
| `route_fallback_diqiu` | `False` | `suppressed_interim_bitmap_fallback_after_real_skeletongraphic_evidence` | UI112 fallback reason explicitly limited these bitmap layers to the period before Spine runtime transforms were restored; UI116/117 proves real SkeletonGraphic exists on original nodes. |
| `route_fallback_zhuye_bian` | `False` | `suppressed_interim_bitmap_fallback_after_real_skeletongraphic_evidence` | UI112 fallback reason explicitly limited these bitmap layers to the period before Spine runtime transforms were restored; UI116/117 proves real SkeletonGraphic exists on original nodes. |
| `route_fallback_zhuye_di1` | `False` | `suppressed_interim_bitmap_fallback_after_real_skeletongraphic_evidence` | UI112 fallback reason explicitly limited these bitmap layers to the period before Spine runtime transforms were restored; UI116/117 proves real SkeletonGraphic exists on original nodes. |

## Route TMP Check

| text | size | font | material | decision |
| --- | --- | --- | --- | --- |
| `모험` | `200,0` | `GirlsWarStaticProbe_riyu_shenzong_0_2_0_2_TMP (TMPro.TMP_FontAsset)` | `GirlsWarStaticProbe_riyu_shenzong_0_2_0_2_Material (UnityEngine.Material)` | `tmp_variant_material_matches_ui110_evidence` |
| `국` | `60,50` | `GirlsWarStaticProbe_riyu_shenzong_0_2_0_2_TMP (TMPro.TMP_FontAsset)` | `GirlsWarStaticProbe_riyu_shenzong_0_2_0_2_Material (UnityEngine.Material)` | `tmp_variant_material_matches_ui110_evidence` |
| `모험` | `100,35` | `GirlsWarStaticProbe_riyu_shenzong_0_2_0_2_TMP (TMPro.TMP_FontAsset)` | `GirlsWarStaticProbe_riyu_shenzong_0_2_0_2_Material (UnityEngine.Material)` | `tmp_variant_material_matches_ui110_evidence` |
| `모험` | `100,35` | `GirlsWarStaticProbe_riyu_shenzong_0_2_0_2_TMP (TMPro.TMP_FontAsset)` | `GirlsWarStaticProbe_riyu_shenzong_0_2_0_2_Material (UnityEngine.Material)` | `tmp_variant_material_matches_ui110_evidence` |
| `전` | `70,60` | `GirlsWarStaticProbe_riyu_shenzong_0_2_0_2_TMP (TMPro.TMP_FontAsset)` | `GirlsWarStaticProbe_riyu_shenzong_0_2_0_2_Material (UnityEngine.Material)` | `tmp_variant_material_matches_ui110_evidence` |
| `모험` | `200,0` | `GirlsWarStaticProbe_riyu_shenzong_0_2_0_2_TMP (TMPro.TMP_FontAsset)` | `GirlsWarStaticProbe_riyu_shenzong_0_2_0_2_Material (UnityEngine.Material)` | `tmp_variant_material_matches_ui110_evidence` |

## Verification

| check | result |
| --- | --- |
| validated scene | `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\Scenes\MainInterface_RouteSpineRuntimeReplay_Validated.unity` |
| graphics capture | `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreCaptures\maininterface_route_spine_runtime_bridge_validated_1680x720.png` |
| click validation generated | `2026-06-25 22:24:07` |
| active/clickable/blocked/invoked | `24 / 24 / 0 / 24` |
| root CMD count | `1` |
| root CMDs | `00_COMMAND_CENTER.cmd` |
| `_restore_tools` direct CMD count | `0` |
| `_restore_tools` direct CMDs | `` |

## Outputs

- JSON: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\maininterface_117_route_skeletongraphic_layout_validation.json`
- CSV: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_117_route_skeletongraphic_layout_validation.csv`
- Tool: `C:\Users\godho\Downloads\girlswar\_restore_tools\cmd_archive\117_VALIDATE_AND_FIX_ROUTE_SKELETONGRAPHIC_LAYOUT_AGAINST_ORIGINAL_EVIDENCE.cmd`

## Remaining Blocker

Next blocker: `route SkeletonGraphic UI material/shader pass binding validation against original SkeletonGraphic runtime fields`.
