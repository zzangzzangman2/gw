# MainInterface TMP Shared Material Analysis

Generated: 2026-06-25 15:50:50

## Verdict

MainInterface TMP 텍스트는 base FontAsset material만 쓰지 않는다. `shared_material_path_id` 기준으로 색상, outline, underlay, gradient scale이 다른 material preset을 참조한다. 현재 빌더가 static TMP FontAsset의 기본 material만 쓰면 route 라벨 두께/색/스케일이 원본과 달라질 수 있다.

## Counts

| item | value |
| --- | ---: |
| referenced shared materials | 19 |
| found shared materials | 19 |
| missing shared materials | 0 |
| total TMP text refs | 271 |

## Top Found Materials

| shared pathID | refs | font | material | bundle | text samples |
| --- | ---: | --- | --- | --- | --- |
| `-6541690290105773087` | 74 | `riyu` | `riyu_baibian_0.2_0.2_1` | `download/ui/uifont/japanese/font_material_riyu/riyu_baibian_0.2_0.2_1.assetbundle` | `동 맹;무 장;마을;이미지;모 험;동 맹;마 을;전속 비서` |
| `3932716197974622303` | 65 | `EPM` | `EPM_bai_0.2_0.2` | `download/ui/uifont/japanese/font_material_epm/epm_bai_0.2_0.2.assetbundle` | `      d;      dadfadsfadsf;용녀 토벌령
뜨겁게 진행 중!;7
;<color=#599F50>누적 {0}시간</color> 방치 보상! 어서 수령하세요!;동맹원: ;천하 쟁패 열렬히 진행 중!;천하쟁패 진행 중` |
| `4174273018840097604` | 22 | `riyu` | `riyu_shenzong_0.2_0.2` | `download/ui/uifont/japanese/font_material_riyu/riyu_shenzong_0.2_0.2.assetbundle` | `이름;친구;모험;모험;전체 화면;10;모험;도감` |
| `6871398411308274113` | 20 | `riyu` | `riyu_cheng_254_178_18` | `download/ui/uifont/japanese/font_material_riyu/riyu_cheng_254_178_18.assetbundle` | ` 설정;저장;확인;알림 설정;확인;계정 삭제;확인;확인` |
| `-5910174858419085933` | 17 | `riyu` | `riyu_lan_0.1_0.1` | `download/ui/uifont/japanese/font_material_riyu/riyu_lan_0.1_0.1.assetbundle` | `설정;성주 이미지;취소;취소;음악 설정;취소;취소;일반 설정` |
| `-2520251210141778353` | 14 | `riyu` | `riyu_222_130_2_shenzong_touying` | `download/ui/uifont/japanese/font_material_riyu/riyu_222_130_2_shenzong_touying.assetbundle` | `모 험;출 정;대 정;무 장;창 고;동 맹;모 험;출 정` |
| `8649783434632076371` | 12 | `EPM` | `EPM_shenzong_0.2_0.2` | `download/ui/uifont/japanese/font_material_epm/epm_shenzong_0.2_0.2.assetbundle` | `총 6명의 소녀 무장을 배경으로 선택하실 수 있습니다.;000;000;10:10;000` |
| `-3548449482811076398` | 10 | `EPM` | `EPM_hei_0.1_0.1` | `download/ui/uifont/japanese/font_material_epm/epm_hei_0.1_0.1.assetbundle` | `이름;10:10:10;10:10:10;10:10:10;10:10:10;10:10:10;10:10:10;10:10:10` |
| `477919381716323141` | 9 | `EPM` | `EPM_wuxiaoguo_dongtai` | `download/ui/uifont/japanese/font_material_epm/epm_wuxiaoguo_dongtai.assetbundle` | `임무 관련 설명;더 많은 헤드셋을 획득하세요!;성주 이미지;임무 설명;123456789하하하하（ ）;무장 이미지;무장 이미지;임무 설명` |
| `5346313758352445069` | 6 | `num` | `num_bai_0.2_0.2` | `download/ui/uifont/japanese/font_material_num/num_bai_0.2_0.2.assetbundle` | `844,651,695;Lv.199` |
| `8263912359925383730` | 5 | `riyu` | `riyu_wubain` | `download/ui/uifont/japanese/font_material_riyu/riyu_wubain.assetbundle` | `보너스 발동 중;푸쉬 알림;（ 999/999 ）;일반 설정;999/999` |
| `1733618647902657739` | 4 | `riyu` | `riyu_zong_xi` | `download/ui/uifont/japanese/font_material_riyu/riyu_zong_xi.assetbundle` | `주 이미지 ;배;경 선택;성` |
| `-6469808170336859405` | 3 | `riyu` | `riyu_pink_shadow` | `download/ui/uifont/japanese/font_material_riyu/riyu_pink_shadow.assetbundle` | `수령 ;수령 ;수령` |
| `3398605064068647022` | 3 | `num` | `num_shenzong` | `download/ui/uifont/japanese/font_material_num/num_shenzong.assetbundle` | `99;12;99` |
| `-4383744721098263825` | 2 | `riyu` | `riyu_touying_209_133_17` | `download/ui/uifont/japanese/font_material_riyu/riyu_touying_209_133_17.assetbundle` | `2;2` |
| `5325321661327454409` | 2 | `EPM` | `EPM_hei_0.2_0.2` | `download/ui/uifont/japanese/font_material_epm/epm_hei_0.2_0.2.assetbundle` | `0%;0%` |
| `-1814576754943834585` | 1 | `num` | `num_cheng_242_180_66_0.2_0.2` | `download/ui/uifont/japanese/font_material_num/num_cheng_242_180_66_0.2_0.2.assetbundle` | `999` |
| `120833204736823593` | 1 | `num` | `num_zong_127_66_11_0.4_0.4` | `download/ui/uifont/japanese/font_material_num/num_zong_127_66_11_0.4_0.4.assetbundle` | `5099만` |
| `5944328056072262551` | 1 | `riyu` | `riyu_lu_5_167_16_0.2_0.2` | `download/ui/uifont/japanese/font_material_riyu/riyu_lu_5_167_16_0.2_0.2.assetbundle` | `사용 완료` |

## Missing Materials

모든 referenced shared material pathID를 원본 uifont bundle에서 찾았다.

## Next

1. 찾은 shared material property를 Unity Material asset으로 재구성한다.
2. `TmpTextDetailRow.sharedMaterialPathId` 기준으로 `TextMeshProUGUI.fontSharedMaterial`을 지정한다.
3. route 라벨 캡처를 다시 확인하고, 그 다음 active state/sibling 보정을 진행한다.

## Generated Files

- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_tmp_shared_material_summary.json`
- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_tmp_shared_materials.csv`
- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_tmp_shared_material_properties.csv`
- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_tmp_shared_material_missing.csv`
