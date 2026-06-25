# MainInterface Route Rect Override Plan

작성 시각: 2026-06-25 16:00 KST

## 적용 대상

`MAININTERFACE_ROUTE_TMP_STATE_AFTER_MATERIAL.md`에서 active route TMP 중 zero-height로 잡힌 2개만 보정한다.

| rect pathID | object | parent | text | original size | override size | reason |
|---|---|---|---|---|---|---|
| `-3578904844754949875` | `text_name` | `UI_Main_wanfa_item_4` | `모험` | `200x0` | `200x35` | 같은 sibling `UI_Main_wanfa_item_1/2`의 `text_name`이 `100x35`이고, height 0은 TMP overflow 렌더를 불안정하게 만든다. |
| `-6275118336609310875` | `text_name` | `UI_Main_wanfa_item_3` | `모험` | `200x0` | `200x35` | 같은 sibling 근거. |

## 원칙

- 좌표를 감으로 새로 그리지 않는다.
- sprite/atlas 통짜를 쓰지 않는다.
- zero-height TMP만 보수적으로 보정한다.
- 보정은 `maininterface_route_rect_overrides.csv`에 기록해 추적 가능하게 유지한다.
- 캡처와 클릭 검증으로 부작용을 확인한다.

## 파일

- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\maininterface_route_rect_overrides.csv`
