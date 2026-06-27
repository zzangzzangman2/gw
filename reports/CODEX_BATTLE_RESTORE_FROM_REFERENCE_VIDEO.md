# Codex 지시서 — 참고.mp4 기준 전투 100% 원복 (우리 파일로 전부 가능)

작성 2026-06-27. 목표: GirlsWar 전투를 **`C:\Users\godho\Downloads\참고.mp4`** 와 **시각적으로 일치**하게
Play Mode에서 원복. 필요한 원본 에셋이 `girlswar_merged_extracted/merged_content/AssetBundles/download/`에
**전부 존재**함을 확인함(아래 매핑). "정확히 우리가 있는 파일들로 전부 원복 가능" = 맞음.

## 1. 정답 레퍼런스 (이미 추출됨)

- 원본 영상: `C:\Users\godho\Downloads\참고.mp4` (26MB).
- 키프레임(이미 추출): `reports/battle/reference_video/keyframes/ref_005s.jpg ~ ref_080s.jpg`,
  종합본 `reports/battle/reference_video/REFERENCE_KEYFRAMES_5_80S.jpg`,
  `REFERENCE_CONTACT_5SEC.jpg`. **작업 중 매 캡처를 이 키프레임과 1:1 비교**.

## 2. 참고 영상이 정의하는 전투 (타임라인)

| 시각 | 화면 | 의미 |
|---|---|---|
| 005s | 홈/캐릭터 화면 | 전투 외 |
| 015s | 스테이지 선택(벚꽃 노드맵) | 전투 진입 전 |
| **020s** | **"전투시작" + 마을폐허 맵, 3v3 포메이션** | 전투 시작 |
| **025–060s** | **작은 SD(Spine) 액터 3v3, HP바, 데미지 숫자(예 1303), 스킬 이펙트** | 본 전투(타깃 룩) |
| 030s | 붉은/핑크 임팩트 이펙트 | 일반/스킬 타격 |
| 070s · 075s · 080s | **풀스크린 캐릭터 컷인(애니 원화) / 보스 입 클로즈업 / 캐릭터 컷인** | **궁극기 컷인 = 잠깐 전체화면 시네마틱** |

**핵심 규칙(현재 버그의 정답):** 본 전투의 액터는 **작은 SD Spine**이다. 대형 캐릭터 원화는
**궁극기 때만 잠깐 "전체화면 컷인"**으로 나오고 **전장에 배치되지 않는다.** 지금 화면의 거대 블론드는
`rolebigsetpainting/1036`(1036의 컷인 원화)를 전장 월드에 그대로 띄운 버그다(아래 4번).

## 3. 원복 에셋 매핑 (모두 `download/` 아래에 존재)

| 요소 | 파일/경로 | 비고 |
|---|---|---|
| 전투 맵(마을폐허) | `artsources/map/battlemap/map_11001/map_11001_1.assetbundle` | battleType=1, mapId=11001 |
| **본 전투 액터(SD Spine)** | `roleprefabsandres/battleprefabandres/<modelId>.assetbundle` | 59개. our 1002/1034 존재. **1036 없음→현재 1034로 폴백** (5번) |
| 적 몬스터 액터 | 같은 `battleprefabandres/<modelId>` (heroDid→modelId는 DTMonster row) | enemy 1100111 등 |
| 스킬 이펙트 | `skillprefabsandres/<family>/<skillId>.prefab` + `.playable` | 일반/소형 스킬 |
| **스킬/궁극기 컷인 영상** | `skillprefabsandres/<family>/*dh*.mp4 / *sp*.mp4` | 예: `1002/1002dh1.mp4`, `1034/1034sp.mp4` (dh=대초식/궁극, sp=스페셜) |
| **궁극기 컷인 원화** | `roleprefabsandres/rolebigsetpainting/<heroDid>.assetbundle` | our 1036/1002/1034 전부 존재. **거대 블론드=여기 1036** |
| 캐릭터 획득/드로우 영상 | `videoroleget/jy_*.mp4`, `videocommon/activityherodraw_*.mp4` | 전투 외 컷신 |
| Live2D | `live2d/` | 일부 컷인 |
| UI/배경/사운드 | `ui/`, `uicommonbg/`, `audio/` | HUD·HP바·스킬슬롯 |

샘플 전투 데이터(이미 있음): `girlswar_battle_unity/Assets/RestoreData/battle/BATTLE_TEST_PAYLOAD.json`
(our 1036/1002/1034, 3 waves of 1100111.., mapId 11001, fightResult 1).

## 4. ★최우선 버그: 컷인 원화가 전장에 뜸 (거대 블론드)

- 증상: 본 전투 중 `rolebigsetpainting/1036` 전신 원화가 전장 월드에 scale=1로 떠서 아군을 덮음.
- 원인: 미커밋 `BattleRuntimeSpineActorFactory.cs`의 `TryPlaySourceSkillPrefab`가 스킬/컷인 프리팹을
  **월드 좌표에 그대로 Instantiate**. 커밋된 상태(`RESULT.json`: `runtimeSourceSkillPrefabRenderable=0`,
  캡처 정상)에선 안 떴음 → 이번 변경의 회귀.
- 1초 확인: `git stash` 후 재실행 → 사라지면 확정(`git stash pop` 복구). Hierarchy에서 거대 오브젝트는
  `B90_SourceSkillPrefab_<id>` 계열.
- **정답 동작:**
  1. 본 전투 액터 = `battleprefabandres` SD Spine만. 컷인 원화/Live2D/영상은 전장 월드에 절대 배치 금지.
  2. 궁극기 컷인은 **별도 전체화면 오버레이(UI 캔버스/풀스크린 Quad)** 에서 **짧게**(참고 070s처럼 ~1초)
     재생 후 제거 — `rolebigsetpainting/<did>` 원화 또는 `skillprefabsandres/<fam>/*dh*.mp4`(VideoPlayer)
     사용. 액션 타입이 궁극(big/ult)일 때만.
  3. 일반/소형 스킬은 `skillprefabsandres/<fam>/<skillId>.prefab`(파티클/디렉터)만 액터 위치에 짧게.
     큰 `SpriteRenderer/Image`(컷인) 자식은 제거하거나 전장 패스에서 스킵.

## 5. 알려진 데이터 갭

- **1036 배틀 액터 없음**: `battleprefabandres/1036.assetbundle` 부재 → 현재 `1036->1034` Spine 폴백.
  실제 영상의 1036 SD가 다른 modelId일 수 있음 → `DTHero`/`DTmodel`에서 1036의 `modelID`를 조회해
  그 `battleprefabandres/<modelID>`를 사용(폴백이 아니라 정확 매핑). 없으면 폴백 사유를 로그로 남길 것.
- 적 몬스터 데이터: enemy `heroDid 1100111/2/3` ↔ DTMonster row `1100110`(그룹 base, 끝자리 0).
  `heroDid//10*10` 또는 원본의 enemy→monster 매핑 확인(`HeroCtrl:OnOpen` 833행대). modelId는 거기서.

## 6. 작업 순서 (Codex)

- **T1 컷인 버그 격리/수정** (4번) — 거대 원화 제거, 컷인은 전체화면 오버레이로만. 최우선.
- **T2 본 전투 액터 정확 매핑** — 6명 모두 `battleprefabandres/<정확 modelId>` Spine. 폴백 0 목표.
  1036 modelId 정확 조회, 적 modelId(DTMonster) 정확 조회. 위치=참고 020/040s의 3v3 레이아웃.
- **T3 스킬 이펙트** — actionType별로 `skillprefabsandres`의 해당 prefab/playable 재생. 데미지 숫자/타격
  이펙트가 참고 025–035s와 맞게.
- **T4 궁극기 컷인** — big skill 시 `rolebigsetpainting`/`*dh*.mp4`를 전체화면 컷인으로 짧게(070/080s).
- **T5 전투 흐름/HUD** — HP바·MP·스킬슬롯(하단)·라운드 진행이 참고와 일치. 한 판 끝까지 재생 후 결과.
- **검증**: 매 단계 Play Mode 캡처를 `ref_0XXs.jpg`와 비교. 폴백/누락은 RESULT.json 카운터로 0 확인.

## 7. 가드레일

- 참고.mp4와 **시각적으로 일치**할 때만 "원복됨"이라 함(좌표만/가짜 금지).
- 원본/디코드/번들/영상 삭제 금지. 매 동작 commit+push to main. 루트 CMD 1개.
- 재사용: 데이터 배선 수정 11종은 `GirlsWarLuaBootstrapMilestone2.RunServerReplay`/Play Mode
  bootstrap에 이미 있음(`reports/CODEX_HANDOFF_PLAYMODE_BATTLE_20260627.md` 참고).

## 8. 새 챗(Codex)용 프롬프트

```text
작업 위치 C:\Users\godho\Downloads\girlswar. git pull origin main 먼저.
reports\CODEX_BATTLE_RESTORE_FROM_REFERENCE_VIDEO.md 읽고 시작.
목표: 참고.mp4(키프레임 reports\battle\reference_video\keyframes\)와 일치하게 전투 원복.
최우선 T1: 거대 캐릭터 원화(rolebigsetpainting/1036)가 전장에 뜨는 버그 수정 — 컷인은 전장 배치 금지,
궁극기 때만 전체화면 오버레이로 짧게(rolebigsetpainting 또는 skillprefabsandres/<fam>/*dh*.mp4).
본 전투 액터는 battleprefabandres SD Spine만. 그 다음 T2 정확 modelId 매핑(1036 battle actor 부재→
DTHero modelID 조회), T3 스킬 이펙트(skillprefabsandres), T4 궁극 컷인, T5 HUD/흐름.
매 단계 Play Mode 캡처를 ref_0XXs.jpg와 비교. 매 동작 commit+push to main.
```
