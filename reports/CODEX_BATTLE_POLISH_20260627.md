# Codex 전투 — 남은 어색함 정밀 교정 (2026-06-27 19:40, BATTLE90~92 이후)

기준: 최신 `reports/battle/BATTLE_90_PLAYMODE_BOOTSTRAP_RESULT.json`(19:36) + 캡처/시퀀스.
정답: `참고.mp4` + `reports/battle/reference_video/keyframes/ref_0XXs.jpg`(특히 040s 본전투, 070/080s 컷인).
이 문서가 현 시점 단일 기준. (구 문서 4종은 이 커밋에서 삭제 — 내용은 여기에 흡수.)

---

## A. 지금 잘 된 것 (유지/회귀 금지)
- `battleEntered=true`, Play Mode 라운드 진행. **스킬 이펙트 렌더 0→72**(`runtimeSourceSkillPrefabRenderableCount=72`).
- **가짜 엑스트라(1025/1050) 제거**, 오버랩 0.42→0.077. **거대 컷인 원화 전장 노출 차단** 유지(`SuppressWorldCutinRenderers`).
- HUD 골격(턴/WAVE 라벨, AUTO/스킵/배속 버튼, 리더 HP, 스킬카드 독, 데미지 팝업) 생성됨.

---

## B. 아직 어색한 부분 (참고 대비 — 우선순위 순)

### B1. ★캐릭터 외형이 본인이 아님 (가장 큰 어색함)
- `skinVisualFallbackCount=3` + `monsterBaseFallbackCount=2`: **5명 중 3명이 남의 스켈레톤**, 적 2종이 base 모델 폴백.
- 특히 **1036은 `battleprefabandres/1036.assetbundle`이 없어 1034 외형으로 대체** 중 → 화면의 1036이 다른 캐릭터로 보임.
- 정답: 각 영웅 `heroDid`→`DTHero`의 **정확 `modelID`**→`roleprefabsandres/battleprefabandres/<modelID>` 사용.
  적은 `heroDid`→`DTMonster` row→`modelID`. 번들이 진짜 없을 때만 명시 로깅(가짜 외형 금지).
  교차검증: `rolebigsetpainting/<did>`(원화)와 같은 캐릭터인지 눈으로 확인(예 1036=블론드).

### B2. ★로스터 vs 로직 불일치 (전략적 뿌리 — 먼저 정해야 B1이 깔끔)
- 현 페이로드(`BATTLE_TEST_PAYLOAD.json`)의 **실제 전투 데이터는 우리편 3명(1036/1002/1034)** 뿐. 적 3명/3웨이브.
- 참고 영상의 **정확한 전투 데이터(영상 속 5인의 heroDid·포메이션·waveData·actionData)는 없음**(서버 사망).
  Naver 아트 매칭은 "추정 신원"일 뿐, 영상의 라운드/결과를 재현할 데이터가 아님.
- **결정(권장): 영상은 "룩/레이아웃 기준"으로만 쓰고, 보유 데이터인 3인 전투를 정확히 렌더한다.**
  - 즉 우리편 **3명을 본인 외형으로**(B1), 참고의 포메이션/HUD/이펙트 **스타일**에 맞춰 배치.
  - "Naver 매칭 5인 코스메틱 로스터"로 인원을 늘리지 말 것(로직은 3명이라 HP/행동/카드가 어긋나 어색).
  - HUD 하단 카드도 **실제 팀 인원수(3, 또는 6슬롯 중 3채움)** 로. 참고의 5카드는 5인 팀일 때 얘기.
  - (영상 5인 전투를 꼭 보고 싶으면 5인 battleInfo를 새로 저작해야 하나 actionData가 영상과 다르므로
    "비슷한 다른 전투"가 됨 — 원복 아님. 비권장.)

### B3. 액터 스케일/포메이션이 참고와 다름
- 참고 040s: 우리편이 **2열 사선 포메이션**(뒤열 위·앞열 아래)으로 **크고 시원하게** 퍼짐, 화면 세로의 ~1/3 차지.
- 현재: 더 작고 좌하단에 몰린 느낌. 정답: `camera.orthographicSize`/액터 스케일을 참고 040s에 맞춰 키우고,
  포메이션 좌표를 참고대로(앞2 뒤1 식, 3인 기준). 검증: `visualActorOverlappedPairCount=0`, 액터 화면비 참고와 유사.

### B4. ★궁극기 컷인이 작은 배너 + "ULTIMATE" 디버그 텍스트
- 현재(시퀀스 0120): 화면 중앙 **가로 작은 박스**에 컷인 이미지 + 아래 빨간 "ULTIMATE" 글자 → 어색/임시.
- 참고 070/075/080s: 궁극기 때 **전체화면** 캐릭터 시네마틱이 ~1초 떴다 사라짐(디버그 텍스트 없음).
- 정답: 컷인 오버레이를 **풀스크린**으로(캔버스 stretch 또는 풀스크린 Quad), `rolebigsetpainting/<did>` 원화
  또는 `skillprefabsandres/<fam>/*dh*.mp4`(VideoPlayer)를 원본 비율/연출로 ~1초 재생 후 제거.
  "ULTIMATE"/디버그 라벨 제거. 전장 월드 배치는 계속 금지(억제 유지).

### B5. HUD 디테일 마감
- 참고 040s 대조: 좌상단 리더 **다이아몬드 초상 프레임**+이름+HP수치(성주13918)+Lv, 중앙 VS/턴/WAVE,
  우측 **AUTO/▶▶|/X2.0 세로 스택**, 하단 SR 스킬카드(별·아이콘). 현재 라벨/버튼 위치·스프라이트를 참고와 1:1로.
- 데미지 숫자는 하드코딩(1303)이 아니라 **실제 피격값**으로 표시되게(있으면).

---

## C. 에셋 매핑 (모두 `merged_content/AssetBundles/download/`에 존재)
| 요소 | 경로 |
|---|---|
| 맵 | `artsources/map/battlemap/map_11001/` |
| 배틀 SD Spine | `roleprefabsandres/battleprefabandres/<modelId>.assetbundle` (※1036 부재 → modelId 재확인) |
| 스킬 이펙트 | `skillprefabsandres/<fam>/<skillId>.prefab` + `.playable` |
| 궁극 컷인 | `roleprefabsandres/rolebigsetpainting/<did>`, `skillprefabsandres/<fam>/*dh*.mp4`·`*sp*.mp4` |
| HUD 스프라이트 | `artsources/uispriteres/uibattle.assetbundle` (btn_zidong/Skip/x2 등) |
| 정답 | `참고.mp4`, `reports/battle/reference_video/keyframes/ref_0XXs.jpg` |

---

## D. 작업 순서 (권장)
B2 결정(→3인 정확 렌더, 코스메틱 로스터 폐기) → B1 정확 modelId(1036 포함, 폴백 0) →
B3 스케일/포메이션 참고 일치 → B4 궁극 컷인 풀스크린 → B5 HUD 마감.

## E. 검증
- 매 단계 Play Mode 캡처를 `ref_040s.jpg`(본전투)·`ref_070s/080s.jpg`(컷인)와 1:1 비교.
- 목표 카운터: `skinVisualFallbackCount=0`, `monsterBaseFallbackCount=0`, `visualActorOverlappedPairCount=0`,
  `runtimeSourceSkillPrefabRenderableCount>0` 유지. 컷인은 전장 0/풀스크린 오버레이로만.
- 가짜 인원/가짜 외형/좌표만/디버그 텍스트 금지. 원본·디코드·번들·영상 삭제 금지. 매 동작 commit+push to main.

## F. 새 챗(Codex)용 프롬프트
```text
작업 위치 C:\Users\godho\Downloads\girlswar. git pull origin main 먼저.
reports\CODEX_BATTLE_POLISH_20260627.md 읽고 시작(현 시점 단일 기준).
B2: 코스메틱 5인 로스터 폐기, 보유 데이터인 3인(1036/1002/1034) 전투를 정확 렌더(영상=룩 기준).
B1: 각 영웅 DTHero modelID로 정확 battleprefabandres 사용, 가짜 폴백 0(1036 modelId 재확인).
B3: 참고 ref_040s대로 2열 사선 포메이션·스케일. B4: 궁극 컷인을 작은 배너/ULTIMATE 텍스트 말고
풀스크린 오버레이(rolebigsetpainting/<did> 또는 skillprefabsandres/<fam>/*dh*.mp4)로 ~1초.
B5: HUD를 ref_040s와 1:1(리더 다이아 초상/턴·WAVE/우측 AUTO·배속/하단 카드는 실제 인원수).
매 단계 캡처를 reports\battle\reference_video\keyframes\ref_0XXs.jpg와 비교. 매 동작 commit+push to main.
```
