# MainInterface Visual Mismatch Cause And Revised Direction

작성 시각: 2026-06-25 14:52 KST

최신 갱신: 2026-06-25 15:29 KST

## 판정

현재 캡처에서 보이는 글씨 위치, 폰트, 오른쪽 route UI는 정상 복원으로 보면 안 된다.

특히 `모험`, `개최 중`, `전국`처럼 보이는 오른쪽 라벨은 원본 TMP/TextMeshPro 계열이다. 현재 Unity 복원 Scene은 TMP 분리 적용과 원본 source font 기반 FontAsset 적용까지 진행됐지만, 원본 정적 TMP atlas/glyph/material을 완전히 이식한 단계는 아니다. 따라서 baseline, 자간, 행간, 정렬, 머티리얼 두께가 원본과 다르게 보일 수 있다.

## 직접 원인

| 원인 | 확인 결과 |
| --- | --- |
| TextMeshPro shim package 없음 | `girlswar_maininterface_unity\Packages\manifest.json`에 `com.unity.textmeshpro` shim은 없지만, Unity 6000의 TMP runtime은 `com.unity.ugui` 2.0에 포함됨 |
| TMP compile probe | 격리 Unity 6000 probe에서 `using TMPro`와 `TextMeshProUGUI` 생성 성공, compile errors 0 |
| 빌더가 TMP를 만들지 않음 | 해결 진행: `ApplyTexts()`가 TMP/UGUI를 분리하고 TMP row는 `TextMeshProUGUI`로 생성 |
| OS fallback 폰트 사용 | 해결 진행: active TMP 84개는 원본 source font 기반 `riyu`/`EPM`/`num` TMP FontAsset 사용, Malgun fallback 0 |
| TMP 원본 row가 많음 | 전체 text 495개 중 TMP-like 271개 |
| 오른쪽 route도 TMP 중심 | right route text 70개 중 TMP-like 49개 |
| 원본 TMP 폰트 근거 존재 | `download/ui/uifont/japanese/tmp`에서 TMP FontAsset 54개, atlas/image PNG 73개 확인 |

## 왜 좌표를 더 만져도 해결되지 않는가

현재 어긋남은 단순 좌표 오차가 아니다.

TMP/TextMeshPro는 `m_fontAsset`, `m_fontMaterial`, `m_textAlignment`, `m_characterSpacing`, `m_lineSpacing`, `m_margin`, SDF shader/material을 기준으로 글자 모양과 박스 안 위치를 계산한다. 초기 빌더는 이 필드들을 버리고 UGUI `Text.fontSize`, `Text.alignment` 정도만 넣었다. 현재는 TMP 분기와 source font 적용까지 들어갔지만, 원본 TMP의 정적 glyph/character table, material preset, atlas texture를 완전히 재조립한 상태는 아니다.

그래서 RectTransform이 맞아도 글자가 박스 안에서 위/아래/좌/우로 밀리고, 원본 게임 폰트가 아니라 Windows 기본 한글 폰트처럼 보인다.

## 수정된 복원 방향

1. 배경/버튼 좌표 보정보다 TMP 복원을 먼저 한다.
2. TMP compile/create probe는 통과했으므로, 기존 `com.unity.ugui` 2.0 기반에서 TMP 분기를 추가한다.
3. `maininterface_text_components.csv`를 UGUI row와 TMP-like row로 분리한다.
4. UGUI row는 기존 `UnityEngine.UI.Text` 경로를 유지한다.
5. TMP-like row는 `TextMeshProUGUI`로 생성하고 원본 TMP serialized field를 반영한다.
6. `download/ui/uifont/japanese/tmp/*.assetbundle`의 TMP FontAsset metric/pathID/atlas PNG를 폰트 기준으로 사용한다.
7. Material/Texture property가 더 필요하면 uifont bundle을 Material/Texture tree 포함 모드로 재추출한다.
8. 그 다음에만 Spine `main_only`, right route state, 버튼 occlusion을 다시 캡처로 판정한다.

## 바로 확인할 파일

| 파일 | 내용 |
| --- | --- |
| `reports\maininterface\MAININTERFACE_TEXT_FONT_LAYOUT_ANALYSIS.md` | TMP-like row와 right route 라벨 문제 |
| `reports\maininterface\MAININTERFACE_TMP_FONT_ASSET_INVENTORY.md` | 원본 TMP FontAsset/atlas 근거 |
| `girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_text_font_layout_summary.json` | 텍스트 분류 요약 |
| `girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_tmp_font_assets_summary.json` | TMP 폰트 인벤토리 요약 |

## 현재 결론

지금 보이는 화면은 “원본 UI를 거의 맞춘 상태”가 아니라 “RectTransform/Sprite/Button 근거 위에 텍스트 시스템이 아직 임시로 얹힌 상태”다.

따라서 다음 단계의 성공 기준은 캡처가 예뻐 보이는지가 아니라, 오른쪽 route의 TMP 라벨이 실제 `TextMeshProUGUI`와 원본 TMP 정적 FontAsset/atlas/material 기준으로 렌더되는지다.
