# MainInterface Route TMP Variant Material Audit Result

Generated: 2026-06-25 20:38:03 KST

## Verdict

The material texture PPtr reconstruction gate is now clean for audited route TMP rows: non-main texture slots with original value `0` are not filled with the atlas.

This is not a coordinate-only change. The fix preserves original hierarchy/RectTransform/sibling data and corrects TMP material texture reference reconstruction from original material property evidence.

## Counts

| metric | value |
| --- | ---: |
| evidence rows considered | 39 |
| audited scene TMP rows | 65 |
| active evidence-matched rows | 9 |
| route label rows (`모험`/`전`/`국`) | 6 |
| non-main texture slot mismatch rows | 0 |

## Route Label Rows

| text | scene path | font asset | material | size | evidence size | classification |
| --- | --- | --- | --- | --- | --- | --- |
| `모험` | `Canvas_MainInterface_1280x720/MainInterface_Root_From_RectTransform_CSV/UI_MainInterface__5568884429252053541/right__6922878451781464554/node_middle__9056630568254389742/UI_Main_wanfa_item_1__51920382737909704/text_name__-5982825750273040741__font_riyu` | `GirlsWarStaticProbe_riyu_shenzong_0_2_0_2_TMP` | `GirlsWarStaticProbe_riyu_shenzong_0_2_0_2_Material` | `100,35` | `100.0x35.0` | `evidence_path_material_ok` |
| `모험` | `Canvas_MainInterface_1280x720/MainInterface_Root_From_RectTransform_CSV/UI_MainInterface__5568884429252053541/right__6922878451781464554/node_middle__9056630568254389742/UI_Main_wanfa_item_2__-3930377403474185176/text_name__7817983549160651324__font_riyu` | `GirlsWarStaticProbe_riyu_shenzong_0_2_0_2_TMP` | `GirlsWarStaticProbe_riyu_shenzong_0_2_0_2_Material` | `100,35` | `100.0x35.0` | `evidence_path_material_ok` |
| `모험` | `Canvas_MainInterface_1280x720/MainInterface_Root_From_RectTransform_CSV/UI_MainInterface__5568884429252053541/right__6922878451781464554/node_middle__9056630568254389742/UI_Main_wanfa_item_3__1745568030950951925/text_name__-6275118336609310875__font_riyu` | `GirlsWarStaticProbe_riyu_shenzong_0_2_0_2_TMP` | `GirlsWarStaticProbe_riyu_shenzong_0_2_0_2_Material` | `200,35` | `200.0x0.0` | `evidence_path_material_ok` |
| `모험` | `Canvas_MainInterface_1280x720/MainInterface_Root_From_RectTransform_CSV/UI_MainInterface__5568884429252053541/right__6922878451781464554/node_middle__9056630568254389742/UI_Main_wanfa_item_4__7836085562230756963/text_name__-3578904844754949875__font_riyu` | `GirlsWarStaticProbe_riyu_shenzong_0_2_0_2_TMP` | `GirlsWarStaticProbe_riyu_shenzong_0_2_0_2_Material` | `200,35` | `200.0x0.0` | `evidence_path_material_ok` |
| `전` | `Canvas_MainInterface_1280x720/MainInterface_Root_From_RectTransform_CSV/UI_MainInterface__5568884429252053541/right__6922878451781464554/node_middle__9056630568254389742/wanfaWorldNode__-3820167396480157270/text_big__5611221341508507661__font_riyu` | `GirlsWarStaticProbe_riyu_shenzong_0_2_0_2_TMP` | `GirlsWarStaticProbe_riyu_shenzong_0_2_0_2_Material` | `70,60` | `70.0x60.0` | `evidence_path_material_ok` |
| `국` | `Canvas_MainInterface_1280x720/MainInterface_Root_From_RectTransform_CSV/UI_MainInterface__5568884429252053541/right__6922878451781464554/node_middle__9056630568254389742/wanfaWorldNode__-3820167396480157270/text_small__4226973974425312330__font_riyu` | `GirlsWarStaticProbe_riyu_shenzong_0_2_0_2_TMP` | `GirlsWarStaticProbe_riyu_shenzong_0_2_0_2_Material` | `60,50` | `60.0x50.0` | `evidence_path_material_ok` |

## Texture Slot Evidence

- `_MainTex` is the atlas texture and remains assigned.
- `_BumpMap`, `_Cube`, `_FaceTex`, and `_OutlineTex` stay empty when original material property value is `0`.
- No whole-atlas Image fallback, fake panel, debug overlay, or coordinate adjustment was added.

## Outputs

- `Assets/RestoreData/maininterface_route_tmp_variant_material_audit.json`
- `Assets/RestoreData/reports/maininterface_route_tmp_variant_material_audit.csv`
- `Assets/RestoreCaptures/maininterface_restored_1680x720.png` after running tool 110

## Verification

| check | result |
| --- | --- |
| active tool | `_restore_tools\110_FIX_MAININTERFACE_ROUTE_TMP_VARIANT_MATERIAL_TEXTURE_PTRS.cmd` |
| graphics capture | `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreCaptures\maininterface_restored_1680x720.png` |
| capture generated | `2026-06-25 20:36:40 KST` |
| click validation generated | `2026-06-25 20:36:43 KST` |
| active/clickable/blocked/invoked | `24 / 24 / 0 / 24` |
