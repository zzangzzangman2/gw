# Codex 전투 — 크기/프레이밍 + "진짜 전투" 마감 (2026-06-27 20:00, cd190e2e3 이후)

이게 이번 단계의 **완료 기준**. `참고.mp4`(특히 `reports/battle/reference_video/keyframes/ref_040s.jpg`)와
**시각적으로 같아질 때까지**가 목표. (이전 `CODEX_BATTLE_POLISH_20260627.md`는 이 문서로 대체·삭제.)

---

## 0. 측정된 사실 — 캐릭터가 왜 작아 보이나
- 화면 1280×570, `camera.orthographicSize=2.55` → 세로 시야 5.1유닛 → **1유닛 ≈ 111.8px**.
- `StandingSnapshotTargetHeight=1.36` 로 **모든 액터를 1.36유닛(≈152px)에 균일 정규화**
  (`BattlePlayModeBootstrap.cs:1361, 1370`). 측정 actor 화면높이 = 우리편 ~115–126px.
- 참고 ref_040s(576세로): **주요 영웅 ~200–255px(≈35–45%), 치비는 ~100px** — 즉 키 편차가 크고
  주요 캐릭이 현재의 **약 1.6–2배**. → "작아 보임"의 정확한 원인 = **균일 1.36 정규화가 너무 작고 밋밋**.

---

## 1. ★S1 캐릭터 크기 (이번 핵심)
- **균일 정규화(1.36) 폐기 → 캐릭터별 네이티브 배틀 프리팹 스케일 사용.** 참고는 캐릭마다 크기가 다름
  (탱커/큰 캐릭은 크게, 치비는 작게). 네이티브 스케일이 그 편차를 복원함. (정규화는 컷인 거대화 막으려
  넣었던 것 — 이제 실제 스켈레톤 쓰므로 불필요. 대신 컷인은 풀스크린 오버레이로 분리(S5).)
- 균일을 유지해야 한다면 **target 1.36 → 우리편 ~1.95, 적 ~1.95(보스/큰적은 2.3)** 로 상향(≈1.5×).
  계산: 참고 주요 영웅 ~230px 목표 → `target = 230 / 111.8 ≈ 2.05유닛`.
- 검증: RESULT `visualActorScreenRects`의 주요 영웅 height가 **~200–250px**, 치비는 더 작게(편차 존재).

## 2. ★S2 카메라/프레이밍 (빈 바닥 과다)
- 현재: 넓은 돌바닥에 작은 액터 → 휑함. 참고는 전투가 프레임 하단 ~2/3를 꽉 채움.
- 조치: S1로 액터를 키운 뒤, **카메라 중심 Y를 전투 영역으로 내리고**(액터 발이 화면 하단 ~15–20%에
  오게), 필요시 `orthographicSize`를 2.55→**~2.1**로 약간 줌인. 맵 상단(하늘/지붕)이 ~1/3만 보이게.
- 원본 값 참고: PNB OnEnter는 `CameraCtrlOriginalOrthographicSize = OG_DESIGN_SIZE*OGAdjustSizeRate`
  로 카메라를 잡음(디코드 Lua) — 가능하면 그 원본 산식/값을 그대로 쓰면 정답에 수렴.

## 3. S3 포메이션 (사선 2열, 원근)
- 참고 040s: 우리편이 **앞열/뒤열 사선** 배치, 뒤열은 화면상 위+살짝 작게(원근), 앞열 아래+크게.
- 현 3인(1036/1002/1034): 앞2 + 뒤1 (또는 참고 비율의 사선 3점). 적도 대칭으로 우측. 좌표를
  `ref020_left_actors.png`/`ref_040s.jpg` 비율로. 겹침 0 유지.

## 4. S4 접지/그림자/정렬
- 각 액터 **발밑 소프트 그림자**(참고에 있음) 추가 → 붕 뜬 느낌 제거, 바닥에 선 느낌.
- 발이 돌바닥 평면에 닿게 Y정렬. 뒤열이 앞열 **뒤로** 그려지게 sortingOrder(Y 기반).

## 5. S5 살아있는 모션 + 궁극 컷인
- 액터가 **idle/attack Spine 애니를 계속 재생**(정지 스냅샷 금지) — 참고처럼 미세 흔들+공격 모션.
- 궁극기 컷인은 **풀스크린 오버레이**(`rolebigsetpainting/<did>` 또는 `skillprefabsandres/<fam>/*dh*.mp4`)
  ~1초, "ULTIMATE" 디버그 텍스트 제거(참고 070/080s). 전장 월드 배치 금지 유지.

## 6. S6 남은 외형 폴백 0 확인
- `skinVisualFallbackCount`/`monsterBaseFallbackCount`가 아직 >0이면 해당 캐릭을 정확 `modelID`로
  (특히 1036). 남의 스켈레톤/가짜 외형 금지. 0 될 때까지.

---

## 7. 완료 판정 (이게 되어야 다음 단계)
참고 ref_040s와 나란히 놓고 **사람이 봐서 같은 전투**로 보일 것. 수치 게이트:
- 주요 영웅 화면높이 ~200–250px(편차 존재), `orthographicSize` 참고 프레이밍.
- `visualActorOverlappedPairCount=0`, `skinVisualFallbackCount=0`, `monsterBaseFallbackCount=0`,
  `runtimeSourceSkillPrefabRenderableCount>0`(이펙트 보임).
- 그림자 있음, 액터 애니 재생 중, 궁극 컷인은 풀스크린/디버그텍스트 없음.

## 8. 작업 순서
S1(네이티브 스케일/타깃 상향) → S2(카메라 프레이밍) → S3(사선 포메이션) → S4(그림자/정렬) →
S6(폴백 0) → S5(모션/컷인 마감). 매 단계 캡처를 `ref_040s.jpg`와 1:1.

## 9. 에셋 (모두 `merged_content/AssetBundles/download/`)
맵 `artsources/map/battlemap/map_11001/` · 배틀Spine `roleprefabsandres/battleprefabandres/<modelId>` ·
스킬 `skillprefabsandres/<fam>/<skillId>.prefab/.playable` · 컷인 `rolebigsetpainting/<did>`·`*dh*.mp4` ·
HUD `artsources/uispriteres/uibattle.assetbundle`.

## 10. 새 챗(Codex)용 프롬프트
```text
작업 위치 C:\Users\godho\Downloads\girlswar. git pull origin main 먼저.
reports\CODEX_BATTLE_SCALE_AND_REALISM_20260627.md 읽고 시작(완료 기준).
핵심 S1: 캐릭터가 참고보다 ~1.6–2배 작음. StandingSnapshotTargetHeight 균일 1.36 정규화를 폐기하고
네이티브 배틀 프리팹 스케일 사용(캐릭별 키 편차 복원), 또는 target을 ~2.0으로 상향. 주요 영웅이 화면
세로 ~40%(약 220–250px@570) 되게. S2: orthographicSize 2.55→~2.1 + 카메라 중심 내려 빈 바닥 줄이고
전투가 프레임 채우게(원본 OG_DESIGN_SIZE*OGAdjustSizeRate 산식 참고). S3 사선 2열 포메이션, S4 발밑
그림자+Y정렬, S5 idle/attack 애니 재생 & 궁극 컷인 풀스크린(ULTIMATE 텍스트 제거), S6 외형 폴백 0.
매 단계 캡처를 reports\battle\reference_video\keyframes\ref_040s.jpg와 1:1 비교. 매 동작 commit+push.
```
