# MainInterface Progress And Delay Reason

작성 시각: 2026-06-25 15:56 KST

## 지금까지 진행상황

| 항목 | 현재 상태 |
|---|---:|
| Scene root | `UI_MainInterface` |
| RectTransform 복원 | 806 |
| Sprite PNG 적용 | 214 |
| Text 적용 | 138 / 495 |
| TMP 적용 | 84 / 271 |
| UGUI Text 적용 | 54 |
| ScrollRect 적용 | 3 / 12 |
| Button logger | 77 |
| active Button hit 검증 | 24 / 24 clickable |
| active Button blocked | 0 |
| Lua handler 정확 매칭 | 39 |
| Lua 후보 매칭 | 21 |
| Lua 미매칭 | 16 |
| 최신 capture | 1680x720, visible pixel `1,201,680` |
| 최신 Unity build | compile errors 0 |
| static TMP refs | 84 |
| shared material refs | 84 |

## 왜 MainInterface 하나가 오래 걸리는가

좌표만 복사해서 붙이는 작업이면 빠르게 보이는 화면 한 장은 만들 수 있다. 하지만 지금 목표는 바로 복원해서 다시 붙일 수 있는 형태라서, 화면 한 장이 아니라 Unity UI 구조 자체를 되살려야 한다.

MainInterface는 단순 이미지 배치가 아니라 다음 요소가 같이 맞아야 정상이다.

- 부모/자식 hierarchy, sibling order, active state
- RectTransform anchor, pivot, sizeDelta, anchoredPosition, localScale
- CanvasScaler 기준 해상도와 실제 캡처 해상도
- Image sprite, sliced sprite, mask, alpha, raycastTarget
- TextMeshPro FontAsset, Material, SDF atlas, glyph table, alignment, margin, spacing
- Button hit area, top raycast object, blocker, interactable 상태
- Lua/XLua handler, module target, inline function, page/panel route
- Spine/동적 배경처럼 PNG 한 장으로 끝나지 않는 렌더링 자산

그래서 `좌표 보고 딱딱 넣기`만 하면 아래 문제가 바로 생긴다.

- 글씨 박스 좌표가 맞아도 TMP font/material/atlas가 다르면 baseline과 자간이 달라져 위치가 틀어진다.
- 버튼 위치가 맞아도 위에 투명 Image나 inactive parent가 있으면 raycast가 다른 오브젝트로 간다.
- 버튼이 클릭 가능해도 Lua route가 없으면 다음 페이지가 열리지 않는다.
- 페이지 전환은 버튼 GameObject 이름만으로 안 되고 원본 Lua module, handler, prefab/panel load 경로가 연결되어야 한다.
- Spine/동적 배경은 이미지 좌표가 아니라 runtime skeleton/material/atlas 조합이라 별도 검증이 필요하다.

## 지금 불안정해 보이는 직접 원인

현재는 active 버튼 hit까지는 안정화됐다. 검증 결과 active 24개는 전부 raycast-clickable이고 blocked는 0이다.

불안정해 보이는 주된 이유는 화면의 시각 품질 쪽이다.

- 원본 `riyu`, `EPM`, `num` TMP 정적 glyph/character table과 atlas PNG는 active TMP 84개에 적용됐다.
- 원본 shared material preset 19개도 전부 찾았고, active TMP 84개가 `fontSharedMaterial`로 참조한다.
- 이전 source font dynamic preload 단계의 missing character warning은 사라졌다.
- 오른쪽 route 라벨, 좌상단 프로필, 하단 panel은 TMP/active state/sprite/mask가 함께 맞아야 해서 좌표만으로 해결되지 않는다.
- active가 아닌 버튼/패널이 많아서 지금 보이는 첫 상태와 다른 상태의 UI를 섞으면 화면이 바로 이상해진다.

## 현재 판정

현재 복원물은 `좌표 없는 빈 화면` 단계는 지났다. 배경, sprite, TMP, 버튼 hit 검증은 들어갔다.

하지만 `원본과 같은 메인 화면` 단계는 아직 아니다. 정적 glyph/atlas와 shared material은 들어갔지만 route 라벨 크기/위치가 아직 틀어져 있으므로 route active state, zero/tight RectTransform, font size/scale, sibling/sorting까지 맞춰야 완성 판정을 낼 수 있다.

## 다음에 해야 할 일

1. route TMP active 21개 중 suspicious 7개를 hierarchy별로 판정한다.
2. `text_name=모험` zero-height active 2개가 원본 동적 layout 누락인지 확인한다.
3. 오른쪽 route 라벨, 좌상단 프로필, 하단 chat/guide panel의 active state와 sibling order를 캡처 기준으로 하나씩 고친다.
4. route label font size/autosize/margin/alignment가 원본 serialized field와 맞는지 검증한다.
5. 그 다음에 Button 클릭을 실제 Lua route/page transition으로 연결한다.

## 사용자가 바로 확인할 파일

- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreCaptures\maininterface_restored_1680x720.png`
- `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_RESTORE_STATUS.md`
- `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_CLICK_VALIDATION.md`
- `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_TMP_STATIC_FONT_APPLY_RESULT.md`
