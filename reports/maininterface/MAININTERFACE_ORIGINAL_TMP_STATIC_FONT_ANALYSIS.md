# MainInterface Original TMP Static Font Analysis

Generated: 2026-06-25 15:37:28

## Verdict

원본 `riyu`/`EPM`/`num` TMP FontAsset에는 정적 glyph table, character table, material, atlas Texture2D가 실제로 들어 있다. 현재 Unity 프로젝트의 `GirlsWarOriginal_*_TMP.asset`은 source font로 다시 만든 동적 TMP asset이라 원본 정적 TMP asset과 family/glyph coverage가 다르다.

따라서 현재 글씨가 어긋나는 다음 병목은 좌표가 아니라 원본 정적 TMP atlas/glyph/material 이식이다.

## Original Static TMP Assets

| font | family | style | atlas | glyphs | chars | material | texture image |
| --- | --- | --- | --- | ---: | ---: | --- | --- |
| `riyu` | `DFMincho-SU` | `Regular` | `2048x2048` | 383 | 384 | `riyu Atlas Material` `254871510493496748` | `-1980486418211286436_riyu Atlas.png` |
| `EPM` | `EPSON ?????S?V?b?N???a` | `Regular` | `1024x2048` | 442 | 444 | `EPM Atlas Material` `-161800820888374377` | `5218067429375919017_EPM Atlas.png` |
| `num` | `Impact` | `Regular` | `256x256` | 24 | 24 | `num Atlas Material` `7258057046760579642` | `-3487941317702978074_num Atlas.png` |

## Current Unity Asset Difference

| font | original family | current family | original glyphs/chars | current glyphs/chars | unicode overlap | original missing in current | current extra |
| --- | --- | --- | ---: | ---: | ---: | ---: | ---: |
| `riyu` | `DFMincho-SU` | `tway_sky` | 383 / 384 | 129 / 129 | 109 | 275 | 20 |
| `EPM` | `EPSON ?????S?V?b?N???a` | `NanumGothic` | 442 / 444 | 159 / 160 | 131 | 313 | 29 |
| `num` | `Impact` | `Impact` | 24 / 24 | 15 / 15 | 15 | 9 | 0 |

## Important Notes

- `riyu` 원본 family는 `DFMincho-SU`이지만 현재 Unity 재생성 asset은 `tway_sky`로 잡힌다.
- `EPM` 원본 family는 EPSON 계열 이름으로 들어오지만 현재 Unity 재생성 asset은 source font import 결과에 의존한다.
- `num`은 원본과 현재가 모두 `Impact` 계열이지만 unicode coverage는 원본 정적 table과 다르다.
- 원본 atlas PNG는 이미 추출되어 있으며, 다음 단계에서 이 PNG와 glyph/character table을 Unity TMP FontAsset sub-asset에 맞춰 재구성해야 한다.

## Next Restore Step

1. Unity TMP FontAsset YAML에 원본 `m_FaceInfo`, `m_GlyphTable`, `m_CharacterTable`, `m_AtlasTextures`, material preset을 주입 가능한지 probe한다.
2. 직접 YAML patch가 깨지면 Editor script에서 TMP FontAsset을 만든 뒤 SerializedObject로 원본 table/material/atlas를 복사한다.
3. `riyu`, `EPM`, `num` 3개만 먼저 적용하고 MainInterface 캡처에서 오른쪽 route label과 좌상단 텍스트를 비교한다.
4. 성공하면 나머지 색상/outline variant TMP bundle로 확장한다.

## Generated Files

- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_original_tmp_static_font_summary.json`
- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_original_tmp_static_font_summary.csv`
- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_original_tmp_static_glyphs.csv`
- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_original_tmp_static_characters.csv`
- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_original_tmp_static_material_properties.csv`
- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_tmp_static_vs_current_comparison.csv`
