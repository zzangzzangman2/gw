# MainInterface Original TMP Font Apply Result

작성 시각: 2026-06-25 15:29 KST

최신 정정: 2026-06-25 15:44 KST 기준 이 문서는 source font 기반 TMP 적용 단계의 기록이다. 현재 MainInterface active TMP 84개는 `MAININTERFACE_TMP_STATIC_FONT_APPLY_RESULT.md`의 원본 정적 glyph/character table + atlas PNG 기반 static TMP FontAsset을 우선 사용한다.

## 결과

MainInterface TMP 텍스트가 더 이상 단일 `Malgun Gothic` fallback을 쓰지 않는다. 원본 `uifont/japanese/font` 번들에서 추출한 source font bytes로 `riyu`, `EPM`, `num` 각각의 TMP FontAsset을 생성했고, `maininterface_text_tmp_details.csv`의 `font_asset_name`/`font_asset_path_id` 기준으로 씬에 적용했다.

2026-06-25 15:27 빌드에서는 TMP FontAsset을 폰트별로 캐시해 한 번만 preload하도록 수정했다. 생성된 3개 TMP asset은 `m_GlyphTable`/`m_CharacterTable`가 비어 있지 않고, `m_ClearDynamicDataOnBuild: 0`으로 저장된다.

## 생성/적용된 FontAsset

| 원본 TMP | source font | 생성 TMP FontAsset | scene 적용 수 |
|---|---|---|---:|
| `riyu` | `riyu_source.ttf` | `GirlsWarOriginal_riyu_TMP.asset` | 40 |
| `EPM` | `EPM_source.ttf` | `GirlsWarOriginal_EPM_TMP.asset` | 40 |
| `num` | `num_source.ttf` | `GirlsWarOriginal_num_TMP.asset` | 4 |
| Malgun fallback | `malgun.ttf` | `GirlsWarRestore_KoreanFallback_TMP.asset` | 0 |

## 검증

| 항목 | 결과 |
|---|---:|
| Unity build compile errors | 0 |
| TMP 적용 수 | 84 |
| TMP `m_fontAsset` 비어 있음 | 0 |
| 원본 source font TMP asset 사용 | 84 |
| Malgun fallback TMP asset 사용 | 0 |
| TMP glyph table empty | 0 / 3 |
| TMP character table empty | 0 / 3 |
| TMP clear dynamic data on build | 0 / 3 enabled |
| TMP missing character warning | 3 font assets, font별 1회 |
| capture size | 1680x720 |
| visible pixel | 1,202,257 |
| capture TMP font/atlas exception | 0 |
| active button raycast-clickable | 24 / 24 |
| active button blocked | 0 |

최신 캡처:

`C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreCaptures\maininterface_restored_1680x720.png`

## 아직 남은 한계

- 이번 단계는 원본 source font bytes 기반 TMP 생성이다. 원본 `tmp/*.assetbundle`의 정적 glyph table, atlas texture, material preset을 완전히 그대로 이식한 단계는 아니다.
- source font preload 후에도 `riyu`, `EPM`, `num` 각각에서 일부 missing character가 남는다. 따라서 현재 화면의 글씨 위치와 형태는 원본 정적 TMP atlas/glyph/material을 이식하기 전까지 완성 판정 불가다.
- `riyu` source font는 Unity import 후 family가 `tway_sky`로 잡힌다. 원본 TMP inventory의 family는 `DFMincho-SU`로 기록되어 있어 face index/name table 추가 검증이 필요하다.
- 현재 active scene에 적용된 TMP는 84개이며, 원본 TMP detail 전체 271개 중 비활성/다른 상태/prefab variant에 속한 나머지 187개는 별도 매핑이 필요하다.
- 화면상 route 라벨과 좌상단 일부 UI는 여전히 정상이라고 보기 어렵다. 다음 병목은 원본 TMP atlas/glyph/material 완전 이식, active state 정리, 누락 sprite/mask 복원이다.

## 다음 작업

1. `riyu`, `EPM`, `num` 원본 TMP FontAsset typetree에서 face index, glyph table, character table, material property, atlas texture 참조를 재추출한다.
2. 가능하면 `tmp/*.assetbundle`의 atlas PNG와 glyph/character table을 Unity TMP FontAsset sub-asset으로 재구성해 동적 생성 폰트가 아니라 원본 정적 TMP asset에 가깝게 만든다.
3. active scene에서 보이는 84개 TMP와 원본 271개 TMP의 미적용 사유를 `active=false`, parent inactive, missing gameObject, prefab variant로 분류한다.
4. 캡처 육안 기준으로 route icon label, 좌상단 프로필, 하단 chat/guide panel을 다음 시각 수정 대상으로 잡는다.
