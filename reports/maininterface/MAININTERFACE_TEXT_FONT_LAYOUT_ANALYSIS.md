# MainInterface Text / Font / Route Layout Analysis

Generated: 2026-06-25 14:42:06

## Verdict

현재 캡처의 글씨 위치와 폰트는 정상 복원으로 보면 안 된다.

- 오른쪽 route 라벨을 포함한 주요 텍스트 다수가 TMP 계열 원본 필드를 가진다.
- 현재 `MainInterfaceSceneBuilder`는 모든 텍스트를 `UnityEngine.UI.Text`로 만들고 OS 폰트 fallback을 넣는다.
- 그래서 원본 `m_fontAsset`, `m_fontMaterial`, `m_textAlignment`, `m_characterSpacing`, `m_lineSpacing`, `m_margin`, word wrapping, SDF material 효과가 사라진다.
- `text_on` / `text_off` 같은 상태 텍스트와 route item 활성 조건은 아직 Lua branch 기준으로 완전히 검증되지 않았다.

## Counts

| item | value |
| --- | ---: |
| total text rows | 495 |
| script ids | 4 |
| TMP-like rows | 271 |
| UGUI Text rows | 218 |
| InputField rows | 6 |
| right route text rows | 70 |
| right route TMP-like rows | 49 |
| active right route TMP-like rows | 23 |
| active parents with both text_on/text_off | 0 |
| UI font assetbundles found | 104 |

## Text Component Types

| script id | count | classification | example object | example text |
| --- | ---: | --- | --- | --- |
| `-5755350681981302373` | 271 | `TMP_like` | `text_off` | `동 맹` |
| `-7978266203517415465` | 210 | `UGUI_Text` | `text_num` | `` |
| `5191574263247149380` | 8 | `UGUI_Text` | `txt_apple_unbind` | `Apple 로그인 삭제` |
| `-6449259990898891853` | 6 | `InputField` | `inputAcc` | `1234` |

## Project Font State

| item | value |
| --- | --- |
| `com.unity.textmeshpro` in manifest | `False` |
| `com.unity.ugui` in manifest | `True` |
| SceneBuilder uses OS font fallback | `True` |
| SceneBuilder creates UGUI Text for rows | `True` |
| SceneBuilder uses TMP namespace | `False` |
| SceneBuilder sets TMP font asset/material | `False` |

## Font Bundle Evidence

- `download/ui/uifont/japanese/font/arialsimple.assetbundle`
- `download/ui/uifont/japanese/font/epm.assetbundle`
- `download/ui/uifont/japanese/font/num.assetbundle`
- `download/ui/uifont/japanese/font/riyu_1.assetbundle`
- `download/ui/uifont/japanese/font_material_epm/epm_bai_0.2_0.2.assetbundle`
- `download/ui/uifont/japanese/font_material_epm/epm_cheng_242_180_66.assetbundle`
- `download/ui/uifont/japanese/font_material_epm/epm_green_0.3_0.3.assetbundle`
- `download/ui/uifont/japanese/font_material_epm/epm_hei_0.1_0.1.assetbundle`
- `download/ui/uifont/japanese/font_material_epm/epm_hei_0.2_0.2.assetbundle`
- `download/ui/uifont/japanese/font_material_epm/epm_hong_0.3__0.3.assetbundle`
- `download/ui/uifont/japanese/font_material_epm/epm_hui_0.2_0.2.assetbundle`
- `download/ui/uifont/japanese/font_material_epm/epm_lan_53_135_220_0.2_0.2.assetbundle`
- `download/ui/uifont/japanese/font_material_epm/epm_lu_65_105_36_0.4_0.4.assetbundle`
- `download/ui/uifont/japanese/font_material_epm/epm_shenzong_0.2_0.2.assetbundle`
- `download/ui/uifont/japanese/font_material_epm/epm_wuxiaoguo_dongtai.assetbundle`
- `download/ui/uifont/japanese/font_material_epm/epm_zi_179_113_213_0.2_0.2.assetbundle`
- `download/ui/uifont/japanese/font_material_epm/epm_zong.assetbundle`
- `download/ui/uifont/japanese/font_material_ksw/ksw_bai_0.2_0.2.assetbundle`
- `download/ui/uifont/japanese/font_material_ksw/ksw_fen_245_105_120_0.4_0.4.assetbundle`
- `download/ui/uifont/japanese/font_material_num/num_bai_0.2_0.2.assetbundle`
- `download/ui/uifont/japanese/font_material_num/num_cheng_242_180_66_0.2_0.2.assetbundle`
- `download/ui/uifont/japanese/font_material_num/num_fen_245_105_120_0.2_0.2.assetbundle`
- `download/ui/uifont/japanese/font_material_num/num_hong_0.2_0.2.assetbundle`
- `download/ui/uifont/japanese/font_material_num/num_hui_0.2_0.2.assetbundle`
- `download/ui/uifont/japanese/font_material_num/num_lan_0.2_0.2.assetbundle`
- `download/ui/uifont/japanese/font_material_num/num_lu_65_105_36_0.4_0.4.assetbundle`
- `download/ui/uifont/japanese/font_material_num/num_shenzong.assetbundle`
- `download/ui/uifont/japanese/font_material_num/num_touying_jianbian.assetbundle`
- `download/ui/uifont/japanese/font_material_num/num_zong_127_66_11_0.4_0.4.assetbundle`
- `download/ui/uifont/japanese/font_material_riyu/riyu_127_66_11__0.4__0.4.assetbundle`
- ... 74 more

## Corrected Direction

1. TMP-like text rows must be restored as `TextMeshProUGUI`, not `UnityEngine.UI.Text`.
2. Import or reconstruct the original TMP font assets/materials from `download/ui/uifont/japanese` and `commonprefabsandres/tmpshaders.assetbundle`.
3. Preserve TMP layout fields: alignment, margin, character spacing, line spacing, word wrapping, overflow, auto sizing, and material presets.
4. For right route buttons, verify Lua-driven current-state filtering for `text_on` / `text_off`, selected/unselected states, and dynamic route item visibility.
5. Only after the TMP/state pass should the Hero Spine `main_only` capture be judged visually.

## Generated Files

- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_text_font_layout_summary.json`
- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_text_script_type_audit.csv`
- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_right_route_text_layout.csv`
