# MainInterface TMP Static Font Apply Result

작성 시각: 2026-06-25 15:44 KST

## 결과

MainInterface 빌더가 `riyu`, `EPM`, `num` TMP 텍스트에 원본 source font 기반 dynamic TMP asset보다 원본 정적 glyph/character table + atlas PNG 기반 static TMP FontAsset을 우선 사용하도록 변경했다.

## 적용 근거

| font | original glyphs/chars | static probe asset | active scene refs |
|---|---:|---|---:|
| `riyu` | 383 / 384 | `GirlsWarStaticProbe_riyu_TMP.asset` | 40 |
| `EPM` | 442 / 444 | `GirlsWarStaticProbe_EPM_TMP.asset` | 40 |
| `num` | 24 / 24 | `GirlsWarStaticProbe_num_TMP.asset` | 4 |

## 검증

| 항목 | 결과 |
|---|---:|
| Unity build compile errors | 0 |
| TMP missing character warning | 0 |
| TMP 적용 수 | 84 / 271 |
| UGUI Text 적용 수 | 54 |
| Scene static TMP refs | 84 |
| capture size | 1680x720 |
| visible pixel | 1,201,703 |
| capture generated | 2026-06-25 15:43:08 |
| active button raycast-clickable | 24 / 24 |
| active button blocked | 0 |
| click validation generated | 2026-06-25 15:43:41 |

최신 캡처:

`C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreCaptures\maininterface_restored_1680x720.png`

## 현재 판정

원본 정적 glyph/character table과 atlas PNG는 MainInterface active TMP 84개에 실제 적용됐다. 이전 source font dynamic preload 단계에서 남던 missing character warning은 사라졌다.

하지만 화면은 아직 정상 완성으로 보면 안 된다. 캡처상 route 라벨과 일부 텍스트의 크기/위치가 여전히 이상하므로 다음 병목은 TMP material preset, point size/scale, route parent active state, sibling/sorting, mask/overlay 정리다.

## 다음 작업

1. `maininterface_text_tmp_details.csv`의 원본 font size, autosize, margin, alignment가 정적 TMP asset과 같이 들어갔을 때 실제 GameView에서 어떻게 변하는지 route 라벨 중심으로 비교한다.
2. 원본 Material property CSV의 `_GradientScale`, `_FaceDilate`, `_OutlineWidth`, `_Underlay*` 계열을 static TMP material에 더 정확히 반영한다.
3. route icon/label parent의 active state와 sibling order를 다시 분리해 현재 화면에 보이면 안 되는 상태 UI를 제거한다.
4. 그 다음에 MainInterface button route를 Lua page/panel transition으로 연결한다.

## 관련 파일

- `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_ORIGINAL_TMP_STATIC_FONT_ANALYSIS.md`
- `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_TMP_STATIC_FONT_PROBE_RESULT.md`
- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_tmp_static_vs_current_comparison.csv`
- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_tmp_static_font_probe_result.json`
