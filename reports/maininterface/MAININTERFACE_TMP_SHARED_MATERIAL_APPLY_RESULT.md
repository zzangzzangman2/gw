# MainInterface TMP Shared Material Apply Result

Generated: 2026-06-25 15:53:22

## Result

| shared pathID | font | source material | success | asset | message |
| --- | --- | --- | --- | --- | --- |
| `-6541690290105773087` | `riyu` | `riyu_baibian_0.2_0.2_1` | `True` | `Assets/RestoreData/TMP/static_probe/shared_materials/TMPSharedMaterial_m6541690290105773087.mat` | `saved` |
| `3932716197974622303` | `EPM` | `EPM_bai_0.2_0.2` | `True` | `Assets/RestoreData/TMP/static_probe/shared_materials/TMPSharedMaterial_3932716197974622303.mat` | `saved` |
| `4174273018840097604` | `riyu` | `riyu_shenzong_0.2_0.2` | `True` | `Assets/RestoreData/TMP/static_probe/shared_materials/TMPSharedMaterial_4174273018840097604.mat` | `saved` |
| `6871398411308274113` | `riyu` | `riyu_cheng_254_178_18` | `True` | `Assets/RestoreData/TMP/static_probe/shared_materials/TMPSharedMaterial_6871398411308274113.mat` | `saved` |
| `-5910174858419085933` | `riyu` | `riyu_lan_0.1_0.1` | `True` | `Assets/RestoreData/TMP/static_probe/shared_materials/TMPSharedMaterial_m5910174858419085933.mat` | `saved` |
| `-2520251210141778353` | `riyu` | `riyu_222_130_2_shenzong_touying` | `True` | `Assets/RestoreData/TMP/static_probe/shared_materials/TMPSharedMaterial_m2520251210141778353.mat` | `saved` |
| `8649783434632076371` | `EPM` | `EPM_shenzong_0.2_0.2` | `True` | `Assets/RestoreData/TMP/static_probe/shared_materials/TMPSharedMaterial_8649783434632076371.mat` | `saved` |
| `-3548449482811076398` | `EPM` | `EPM_hei_0.1_0.1` | `True` | `Assets/RestoreData/TMP/static_probe/shared_materials/TMPSharedMaterial_m3548449482811076398.mat` | `saved` |
| `477919381716323141` | `EPM` | `EPM_wuxiaoguo_dongtai` | `True` | `Assets/RestoreData/TMP/static_probe/shared_materials/TMPSharedMaterial_477919381716323141.mat` | `saved` |
| `5346313758352445069` | `num` | `num_bai_0.2_0.2` | `True` | `Assets/RestoreData/TMP/static_probe/shared_materials/TMPSharedMaterial_5346313758352445069.mat` | `saved` |
| `8263912359925383730` | `riyu` | `riyu_wubain` | `True` | `Assets/RestoreData/TMP/static_probe/shared_materials/TMPSharedMaterial_8263912359925383730.mat` | `saved` |
| `1733618647902657739` | `riyu` | `riyu_zong_xi` | `True` | `Assets/RestoreData/TMP/static_probe/shared_materials/TMPSharedMaterial_1733618647902657739.mat` | `saved` |
| `-6469808170336859405` | `riyu` | `riyu_pink_shadow` | `True` | `Assets/RestoreData/TMP/static_probe/shared_materials/TMPSharedMaterial_m6469808170336859405.mat` | `saved` |
| `3398605064068647022` | `num` | `num_shenzong` | `True` | `Assets/RestoreData/TMP/static_probe/shared_materials/TMPSharedMaterial_3398605064068647022.mat` | `saved` |
| `-4383744721098263825` | `riyu` | `riyu_touying_209_133_17` | `True` | `Assets/RestoreData/TMP/static_probe/shared_materials/TMPSharedMaterial_m4383744721098263825.mat` | `saved` |
| `5325321661327454409` | `EPM` | `EPM_hei_0.2_0.2` | `True` | `Assets/RestoreData/TMP/static_probe/shared_materials/TMPSharedMaterial_5325321661327454409.mat` | `saved` |
| `-1814576754943834585` | `num` | `num_cheng_242_180_66_0.2_0.2` | `True` | `Assets/RestoreData/TMP/static_probe/shared_materials/TMPSharedMaterial_m1814576754943834585.mat` | `saved` |
| `120833204736823593` | `num` | `num_zong_127_66_11_0.4_0.4` | `True` | `Assets/RestoreData/TMP/static_probe/shared_materials/TMPSharedMaterial_120833204736823593.mat` | `saved` |
| `5944328056072262551` | `riyu` | `riyu_lu_5_167_16_0.2_0.2` | `True` | `Assets/RestoreData/TMP/static_probe/shared_materials/TMPSharedMaterial_5944328056072262551.mat` | `saved` |

## Meaning

원본 TMP shared material preset을 Unity Material asset으로 재구성했다. MainInterface 빌더는 `shared_material_path_id` 기준으로 이 material을 `TextMeshProUGUI.fontSharedMaterial`에 적용할 수 있다.

## MainInterface Verification

| 항목 | 결과 |
|---|---:|
| material assets built | 19 / 19 |
| scene shared material refs | 84 / 84 |
| Unity build compile errors | 0 |
| capture size | 1680x720 |
| visible pixel | 1,201,680 |
| capture generated | 2026-06-25 15:54:18 |
| active button raycast-clickable | 24 / 24 |
| active button blocked | 0 |
| click validation generated | 2026-06-25 15:54:58 |

## Remaining Visual Issue

shared material까지 적용했지만 route 라벨 크기/위치 문제는 남아 있다. `MAININTERFACE_ROUTE_TMP_STATE_AFTER_MATERIAL.md` 기준 active route TMP 21개 중 suspicious active row가 7개이며, zero-height active row 2개와 font-larger-than-rect active row 5개가 다음 보정 대상이다.

## Generated Files

- `Assets/RestoreData/reports/maininterface_tmp_shared_material_build_result.json`
- `Assets/RestoreData/TMP/static_probe/shared_materials`
