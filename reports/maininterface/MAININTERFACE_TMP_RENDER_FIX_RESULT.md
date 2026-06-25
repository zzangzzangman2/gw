# MainInterface TMP Render Fix Result

작성 시각: 2026-06-25 15:16 KST

## 왜 화면이 틀렸는가

이전 캡처는 정상 복원이 아니었다. 원본 MainInterface 텍스트 상당수가 TextMeshPro 계열인데, 복원 SceneBuilder가 이를 UGUI `Text`와 OS fallback 폰트로 처리했다. 그래서 글씨 위치, 줄간격, 정렬, 마진, 폰트가 전부 흔들렸다.

추가로 Unity 프로젝트 안에 TMP Essential Resources가 실제로 풀려 있지 않았다. `TMP Settings.asset`만 있는 상태였고, `LiberationSans SDF`, TMP SDF shader, 기본 material/font atlas가 없어서 `TextMeshProUGUI`가 생성되어도 정상 렌더링 조건이 아니었다.

## 이번에 고친 것

- `Assets/TextMesh Pro` 아래에 TMP Essential Resources를 직접 추출했다.
- `MainInterfaceSceneBuilder.cs`에서 TMP/UGUI 텍스트 적용 경로를 분리했다.
- 원본 TMP field CSV의 alignment, margin, font size, autosize, wrapping, overflow, character/word/line/paragraph spacing을 `TextMeshProUGUI`에 적용했다.
- `GirlsWarRestore_KoreanFallback_TMP.asset` 생성 시 atlas texture와 material을 sub-asset으로 저장하도록 고쳤다.
- 기존처럼 깨진 TMP font asset이 있으면 SceneBuilder가 감지해 재생성하도록 했다.
- 최신 캡처 열기/검증 CMD가 `1680x720` 캡처를 보도록 수정했다.

## 검증 결과

| 항목 | 결과 |
|---|---:|
| RectTransform | 806 |
| Sprite 적용 | 214 |
| Text 적용 | 138 |
| TMP 적용 | 84 |
| UGUI 적용 | 54 |
| TMP font asset 참조 0개 여부 | 0개 |
| TMP atlas/material 저장 | 통과 |
| 캡처 크기 | 1680x720 |
| visible pixel | 1,202,637 |
| 캡처 TMP atlas/font missing 예외 | 없음 |
| active button raycast-clickable | 24 / 24 |
| active button blocked | 0 |

최신 캡처:

`C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreCaptures\maininterface_restored_1680x720.png`

## 아직 정상이라고 보면 안 되는 부분

- `Malgun Gothic` 단일 fallback은 제거됐다. 현재는 원본 source font bytes 기반 `riyu`, `EPM`, `num` TMP FontAsset을 사용한다. 다만 원본 `tmp/*.assetbundle`의 정적 atlas/glyph/material을 완전히 이식한 단계는 아니다.
- 원본 TMP detail은 271개지만 현재 scene graph에서 실제 적용된 TMP는 84개다. 나머지는 비활성/다른 상태/prefab variant 쪽 매핑을 더 좁혀야 한다.
- 좌상단 프로필, 일부 아이콘/마스크/하단 패널은 아직 원본 스프라이트 또는 동적 상태가 빠져 있다.
- `UI_heroSpine` 1001번 Spine은 probe에서 검증됐지만 메인 프로젝트에는 아직 병합하지 않았다.

## 다음 방향

1. `uifont/japanese/tmp`의 `riyu`, `EPM`, `num` 원본 TMP FontAsset/Material/Texture/glyph table을 더 깊게 복원해 source font 동적 TMP를 원본 정적 TMP에 가깝게 교체한다.
2. TMP detail 271개 중 미적용 187개를 pathID/gameObject 기준으로 분리해, 비활성 상태와 prefab variant를 구분한다.
3. 현재 active state 기준으로 좌상단 프로필, route icon label, 하단 chat/guide panel의 누락 sprite와 mask를 재검증한다.
4. `UI_heroSpine` 1001번 Spine을 메인 scene에 붙인 뒤 그래픽 캡처와 클릭 검증을 다시 돌린다.
5. 캡처 비교 기준은 `visible pixel`, TMP 예외 0개, active button blocked 0개, 화면별 crop 육안 확인으로 유지한다.
