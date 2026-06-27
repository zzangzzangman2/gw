# Codex 전투 — 시급(URGENT) + 해야 할 것(TODO) 종합 (2026-06-27 14:00 기준)

기준 커밋 `809419da9` "Restore battle visual lineup mapping". 최신 결과
`reports/battle/BATTLE_90_PLAYMODE_BOOTSTRAP_RESULT.json` (13:59) + 캡처
`reports/battle/BATTLE_90_PLAYMODE_BOOTSTRAP_CAPTURE.png`. 목표는 여전히 `참고.mp4`와 시각 일치.

---

## A. 지금까지 된 것 (유지)

- Play Mode 부팅 + `battleEntered=true`, 전투 라운드/공격 태스크 프리뷰 진행(trace 정상).
- **거대 컷인 원화 버그 해결됨** — `BattleRuntimeSpineActorFactory.SuppressWorldCutinRenderers`/
  `LooksLikeWorldCutin`(path에 `painting`/`bigset`/`cutin` 포함 시 SpriteRenderer 비활성)로
  `rolebigsetpainting/1036`가 전장에 안 뜨게 막음. (`worldCutinSuppressed` 카운터 존재)
- 6개 로직 액터가 Spine으로 렌더(`skinSpineCount=6`, `skinQuadFallbackCount=0`).
- 참고 키프레임 추출/커밋(`reports/battle/reference_video/keyframes/ref_005s..080s.jpg`,
  `ref020_left_actors.png`/`ref020_enemy_actors.png`/`ref020_cards.png`).
- 캐릭터 신원 조사(`reports/battle/NAVER_LOUNGE_CHARACTER_MATCHES.{json,csv,md}`).

---

## B. 🔴 시급 (지금 화면이 깨져 보이는 직접 원인)

### U0. ★최우선 결정 — 로스터 데이터 소스 (모든 겹침/혼란의 뿌리)
- 테스트 페이로드(`BATTLE_TEST_PAYLOAD.json`)는 **우리편 3명(1036/1002/1034)**, 적 3명.
- 그런데 Codex가 참고 영상의 팀에 맞추려 **시각 전용 엑스트라 2명(1025/1050)** 을 추가
  (`BattlePlayModeBootstrap.cs:29 ReferenceLineupExtraActorIds={1025,1050}`,
  `MaterializeReferenceLineupExtras` @1792, `HudCardActorIds={1002,1025,1036,1034,1050}`).
- 결과: **로직 3 + 시각 2 + 적 3 = 8명**이 좁은 좌측에 몰려 **겹침(`visualActorMaxOverlapRatio=0.425`,
  `visualActorOverlappedPairCount=4`)**. 로직과 시각이 따로 노는 "가짜 인원"이라 원복으로 부적절.
- **결정 필요(둘 중 하나로 통일):**
  - (A) **참고 영상 전투를 그대로 재현** → 영상의 실제 5인(+적/웨이브)에 맞는 **battleInfo 페이로드를
    새로 구성**(heroDid/포메이션/waveData/actionData). 이러면 로직=시각 일치, 엑스트라 hack 불필요.
    영상 신원은 `NAVER_LOUNGE_CHARACTER_MATCHES`로 매핑 시도하되, **actionData/결과까지 영상과
    같게 만들 데이터가 없으면 (B)로**.
  - (B) **시스템 원복 우선** → 테스트 페이로드(3v3) 그대로 정확히 구동하고, 참고 영상은 **레이아웃/
    룩(맵·액터크기·HUD·이펙트·컷인 방식)** 의 기준으로만 사용. **`ReferenceLineupExtraActorIds`
    엑스트라(1025/1050)는 제거.** ← 권장(가짜 인원 없이 깔끔, 즉시 겹침 해소).

### U1. 액터 겹침/배치 (U0와 직결)
- 좌측 우리편이 서로 겹침. 참고 `ref020_left_actors.png`/`ref_040s.jpg`는 **3명이 사선으로 벌어진
  포메이션**(앞2/뒤1 식). 현재 위치 하드코딩(`BattlePlayModeBootstrap.cs:1840` 부근 `case 1025/1050`등).
- 할 일: U0=(B)면 엑스트라 제거 후 3v3 포메이션 좌표를 참고와 맞춤. U0=(A)면 6슬롯 포메이션 좌표를
  영상대로. 검증: `visualActorOverlappedPairCount=0`, `visualActorMaxOverlapRatio<0.02` 목표.

### U2. 비주얼 폴백 4건 = 잘못된 스켈레톤 (`skinVisualFallbackCount=4`)
- **1036은 `battleprefabandres/1036.assetbundle`이 없음** → 현재 `1036->1034`로 남의 Spine을 씀
  (`runtimeActorVisualFallbackCount=4`). 화면의 1036이 1034 외형으로 나옴.
- 할 일: 1036의 **정확 modelId**를 `DTHero`(또는 `DTmodel`)에서 조회해 그 `battleprefabandres/<modelId>`
  사용. 그래도 번들이 없으면 누락을 명시 로깅(가짜로 1034 쓰지 말 것). 적도 동일(B-U1 참고).

---

## C. 🟡 해야 할 것 (참고 영상 수준까지)

### T1. 스킬 이펙트가 안 보임 (`runtimeSourceSkillPrefabRenderableCount=0`)
- 스킬 프리팹은 인스턴스화/디렉터 재생되는데 **보이는 렌더러 0**(`renderers=0 particles=0 animators=0
  directors=1`). 참고 025–035s엔 타격 이펙트가 뚜렷.
- 원인 후보: 프리팹 렌더러가 비활성/머티리얼 누락/타임라인(Playable)이 클립을 못 물림(현재
  `timelineBlocked=True`, `playableLoaded=0`). 할 일: `skillprefabsandres/<fam>/<skillId>.playable`을
  바인딩하거나, 프리팹의 ParticleSystem/Animator를 직접 Play. **컷인 억제 로직이 일반 이펙트
  렌더러까지 끄지 않는지** 확인(`SuppressWorldCutinRenderers`가 과도하게 끄면 이펙트도 사라짐).

### T2. 적 몬스터 정확 매핑 (`monsterBaseFallbackCount=2`)
- enemy `heroDid 1100111/2/3` ↔ DTMonster `1100110`(그룹 base) 폴백 중. modelId가 부정확하면 외형 틀림.
- 할 일: `HeroCtrl:OnOpen`(833행대)의 enemy→monster→modelId 경로대로 정확 row 조회. base 폴백은 카운트
  로깅하고 최소화. 참고 `ref020_enemy_actors.png`와 외형 대조.

### T3. 궁극기 컷인 = 전체화면 시네마틱 (참고 070/075/080s)
- 지금은 컷인을 "억제(끄기)"만 함. **원복 목표는 궁극기 때 전체화면 컷인을 잠깐 재생**.
- 할 일: big/ult 액션일 때 **전용 풀스크린 오버레이**(UI 캔버스/풀스크린 Quad)에서
  `roleprefabsandres/rolebigsetpainting/<did>` 또는 `skillprefabsandres/<fam>/*dh*.mp4`(VideoPlayer)를
  ~1초 재생 후 제거. 전장 월드 배치 금지(억제 유지). 참고 070s(핑크 컷인)/080s(블루 컷인) 타이밍 대조.

### T4. HUD/HP바/MP/스킬슬롯/데미지숫자
- 참고 025–060s: 상단 HP바(아군 초록/적 주황), 데미지 숫자(예 1303) 팝업, 하단 5스킬 슬롯.
- 할 일: HUD 레이어 구성(이미 일부 있음). HP바가 액터를 따라가고, 피격 시 데미지 숫자 표시, 스킬 슬롯이
  실제 스킬과 연동. `HudCardActorIds`도 U0 결정에 맞춰 정리.

### T5. 전체 전투 재생 + 결과(승리) 흐름
- 참고: 라운드 자동 진행 → 적 전멸 → 다음 웨이브 → 최종 승리/결과. 지금은 일부 라운드 프리뷰만.
- 할 일: `BattleAllBigRoundBegin`~`FinalBattleEnd`까지 끝까지 재생되며 HP/사망/웨이브 전환이
  payload `waveData`/`heroStatistics`와 일치. `isBattleEnd=true`/결과 화면까지.

### T6. 맵/카메라/종횡비
- 맵은 `artsources/map/battlemap/map_11001` 사용 중(배경 OK). 참고와 **카메라 줌/종횡비/액터 스케일**
  최종 대조(`visualTuningVersion`이 reference-scale 계열). 참고 020/040s와 1:1 비교.

---

## D. 에셋 매핑 (모두 `merged_content/AssetBundles/download/`에 존재 — 재확인)

| 요소 | 경로 |
|---|---|
| 맵 | `artsources/map/battlemap/map_11001/` |
| 배틀 SD Spine | `roleprefabsandres/battleprefabandres/<modelId>.assetbundle` (1036 부재 주의) |
| 스킬 이펙트 | `skillprefabsandres/<fam>/<skillId>.prefab` + `.playable` |
| 궁극 컷인 영상/원화 | `skillprefabsandres/<fam>/*dh*.mp4`·`*sp*.mp4`, `roleprefabsandres/rolebigsetpainting/<did>` |
| 참고 정답 | `참고.mp4` + `reports/battle/reference_video/keyframes/ref_0XXs.jpg` |

---

## E. 검증 (매 단계)
- Play Mode 캡처를 `ref_0XXs.jpg`와 1:1 비교.
- `RESULT.json` 카운터 목표: `skinVisualFallbackCount=0`, `monsterBaseFallbackCount=0`,
  `visualActorOverlappedPairCount=0`, `runtimeSourceSkillPrefabRenderableCount>0`(이펙트 보임),
  컷인은 전장에 0 / 오버레이에서만.
- 가짜 인원/좌표만/임의 외형 금지. 원본·디코드·번들·영상 삭제 금지. 매 동작 commit+push to main.

---

## F. 권장 순서
U0 결정(→권장 B: 엑스트라 제거, 3v3 정확) → U1 겹침 해소 → U2 정확 modelId(1036 포함) →
T1 스킬 이펙트 보이게 → T2 적 매핑 → T4 HUD → T5 끝까지 재생 → T3 궁극 컷인 → T6 카메라 최종 대조.

## G. 새 챗(Codex)용 프롬프트
```text
작업 위치 C:\Users\godho\Downloads\girlswar. git pull origin main 먼저.
reports\CODEX_BATTLE_URGENT_AND_TODO_20260627.md 읽고 시작.
최우선 U0: 로스터 통일 — 기본은 (B) 테스트 페이로드 3v3로 정확 구동, ReferenceLineupExtraActorIds
(1025/1050) 시각 엑스트라 제거해 겹침 해소. 이어 U2 정확 modelId(1036 battle actor 부재→DTHero
modelID 조회), T1 스킬 이펙트 렌더(렌더러 0 원인=playable 미바인딩/컷인억제 과도 확인), T2 적 몬스터
매핑, T4 HUD, T5 끝까지 재생, T3 궁극 컷인은 전장 아닌 전체화면 오버레이로. 매 단계 캡처를
reports\battle\reference_video\keyframes\ref_0XXs.jpg와 비교. 매 동작 commit+push to main.
```
