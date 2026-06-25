# MainInterface Active TMP Variant Font Assets

Generated: 2026-06-25 16:43:00

## Verdict

active route TMP는 prefab상 base FontAsset(`riyu`/`EPM`)을 참조하지만, shared material 이름과 동일한 TMP FontAsset bundle도 원본에 존재한다. 이 리포트는 그 variant FontAsset의 glyph/character/atlas/material을 별도 evidence로 내보내 A/B 렌더 검증에 쓸 수 있게 한다.

## Active Shared Material Usage

| variant/material | refs | base fonts | text samples | flags |
| --- | ---: | --- | --- | --- |
| `riyu_baibian_0.2_0.2_1` | 14 | `riyu` | `마을;상점 ;옷장과의 약속;세 ;소환수;수호  ;무장 ;동맹 ` | `font_larger_than_rect;shared_material_found;visible_chain` |
| `riyu_shenzong_0.2_0.2` | 6 | `riyu` | `모험;국;전` | `shared_material_found;visible_chain;zero_or_negative_height` |
| `EPM_bai_0.2_0.2` | 1 | `EPM` | `개최 중` | `shared_material_found;visible_chain` |

## Exported Variant TMP FontAssets

| variant | base | atlas | glyphs | chars | source image |
| --- | --- | --- | ---: | ---: | --- |
| `riyu_baibian_0.2_0.2_1` | `riyu` | `2048x2048` | 599 | 601 | `8776376539229871138_riyu Atlas.png` |
| `riyu_shenzong_0.2_0.2` | `riyu` | `2048x1024` | 424 | 426 | `569021843135281428_riyushufazi Atlas.png` |
| `EPM_bai_0.2_0.2` | `EPM` | `2048x2048` | 588 | 591 | `-5547209632630771065_EPMGOBLD Atlas.png` |

## Restore Notes

- 기본 복원 경로는 원본 component의 base `m_fontAsset` + `m_sharedMaterial` 조합을 유지한다.
- variant FontAsset은 shared material 이름과 같은 TMP bundle을 실험적으로 렌더링해 보기 위한 근거다.
- 실제 적용은 `MainInterfaceSceneBuilder`에서 shared material pathID별 opt-in mapping으로만 해야 한다.

## Generated Files

- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_active_tmp_variant_usage.csv`
- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_active_tmp_variant_font_summary.csv`
- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_active_tmp_variant_glyphs.csv`
- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_active_tmp_variant_characters.csv`
- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_active_tmp_variant_material_properties.csv`
- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_active_tmp_variant_font_assets_summary.json`
