# GirlsWar Work Split and GitHub Status

생성 시각: 2026-06-25

## 현재 채팅 역할

이 채팅은 총괄 채팅으로 유지한다.

- GitHub `zzangzzangman2/gw` `main` push 상태 확인
- UI/전투 전용 채팅 간 충돌 관리
- 공통 원본/추출물/도구 폴더 구조 관리
- `C:\Users\godho\Downloads\apk_extracted_ui_restore_rules.txt` 기준 유지

## 새로 나눈 채팅

### GirlsWar UI 복원 전용

- Thread ID: `019efdb6-503d-7373-be2b-6dcd1a247b1a`
- 범위: MainInterface UI, TMP FontAsset/material, route label, 버튼 hit/raycast, 캡처 검증
- 작업 폴더: `C:\Users\godho\Downloads\girlswar`
- 주요 금지: Git commit/push 금지, battle 전용 구현 폴더 수정 금지

### GirlsWar 전투 구현 전용

- Thread ID: `019efdb6-9db2-7e52-bbef-c959eb4d619e`
- 범위: battle/fight/skill/formation/IL2CPP/Lua 전투 흐름
- 작업 폴더: `C:\Users\godho\Downloads\girlswar`
- 주요 금지: Git commit/push 금지, MainInterface scene/builder/report 수정 금지

## 충돌 방지 규칙

- UI 전용 채팅은 `girlswar_maininterface_unity`, `reports\maininterface`, MainInterface 관련 `_restore_tools` CMD만 수정한다.
- 전투 전용 채팅은 `reports\battle`, battle 전용 Unity/probe 폴더, battle 전용 `_restore_tools` CMD만 수정한다.
- Git commit/push는 이 총괄 채팅에서만 한다.
- 원본/evidence 파일은 커버리지와 사용 여부가 문서화되기 전에는 삭제하지 않는다.
- 상세 MD는 `reports` 아래에 둔다.
- 실행 CMD는 `_restore_tools` 아래에 모으고, 사용자가 바로 누를 필요가 있는 것만 메인 폴더에 둔다.

## GitHub push 상태

현재 원격:

- `origin`: `https://github.com/zzangzzangman2/gw.git`
- branch: `main`
- 최초 커밋: `3f505aa7 Add girlswar restore workspace`

2026-06-25 16:23:46에 `PUSH_TO_GITHUB_MAIN_BACKGROUND.cmd`로 1차 background push를 시작했다.
대용량 LFS 파일이 많아서 `git-lfs` 업로드가 오래 걸릴 수 있다.

2026-06-25 16:43 기준:

- 원격 `refs/heads/main`은 아직 생성 전이다.
- 첫 push 프로세스는 `git-lfs.exe pre-push origin https://github.com/zzangzzangman2/gw.git` 상태로 살아 있다.
- 후속 watcher는 `_restore_tools\logs\github_push_followup_main.log`에 `waiting for existing git-lfs.exe`를 남기며 대기 중이다.
- 후속 watcher는 첫 push가 끝난 뒤 최신 UI/전투 산출물을 `git add -A`로 커밋하고 다시 push한다.

확인 방법:

- 메인 폴더: `SHOW_GIT_PUSH_STATUS.cmd`
- 도구 폴더: `_restore_tools\94_SHOW_GIT_PUSH_STATUS.cmd`
- 로그: `_restore_tools\logs\github_push_main.log`

2026-06-25 16:47 추가:

- `SHOW_GIT_PUSH_STATUS.cmd`는 이제 전체 `git status`를 펼치지 않고 요약만 보여준다.
- 현재 요약 기준 tracked changed files: `13`
- 현재 요약 기준 untracked files: `8822`
- 원격 `refs/heads/main`은 여전히 생성 전이다.
- 첫 push는 `git-lfs pre-push` 상태이고, 후속 watcher는 계속 대기 중이다.
- 새 채팅들이 battle Lua/raw TextAsset을 많이 만들기 때문에 상태 확인은 반드시 요약형 CMD로 보는 편이 낫다.

2026-06-25 16:50 추가:

- `SHOW_GIT_PUSH_STATUS.cmd`가 LFS 진단 정보도 보여주도록 보강되었다.
- Git LFS tracked files: `43990`
- 첫 push age: 약 `26.7`분
- `git-lfs.exe` CPU 누적: 약 `39.5`초
- `git-lfs.exe` memory: 약 `87.6 MB`
- CPU 시간이 계속 늘고 있으므로 현재 상태는 실패 확정이 아니라 대용량 LFS pre-push 진행/대기 상태로 본다.

2026-06-25 16:52 추가:

- UI/전투 전용 채팅이 모두 1차 작업 완료 후 idle 상태였기 때문에 다음 작업을 재투입했다.
- UI 전용 채팅은 active/inProgress 상태로 전환되었다.
  - 새 작업: 오른쪽 route cluster의 `UI_Main_wanfa_item_*`, `wanfaWorldNode`, active state, sibling order, parent layout 원본 비교 및 수정/검증
  - 검증 요구: Unity scene build, graphics capture, click validation 24/24 유지
- 전투 전용 채팅도 active/inProgress 상태로 전환되었다.
  - 새 작업: `ProcedureNormalBattle.BeginBattleWithServer_FightPlay` test payload 구조화, datatable/resource join, battle prototype manifest 생성
  - 기대 산출물: `BATTLE_PROTOTYPE_MANIFEST.json`, `BATTLE_PROTOTYPE_BUILD_PLAN.md`, `BATTLE_05_...cmd`
- GitHub 원격 `refs/heads/main`은 아직 생성 전이며, 후속 watcher는 계속 `waiting for existing git-lfs.exe` 상태다.

2026-06-25 16:53 추가:

- UI 전용 채팅은 계속 active/inProgress다.
  - 최신 관찰: `node_middle` 아래 `UI_Main_wanfa_item_1..4`와 `wanfaWorldNode`가 원본 CSV 기준 모두 active라서, 단순히 route item 하나를 끄는 방식은 원본 근거가 약하다.
  - 현재 분석 방향: child order, 카드 내부 sprite/text/button 상태, 카드 간 중복인지 카드 내부 label/state 조합인지 판정.
- 전투 전용 채팅도 계속 active/inProgress다.
  - 최신 관찰: `BattleResPreloadMgr`와 `BattleTimelineResMap` 파일을 확인했고, 긴 `rg` 대신 Python 스크립트에서 line evidence를 직접 수집하는 방식으로 우회 중이다.
  - 현재 분석 방향: test payload 구조화, datatable/resource join, manifest와 build plan 생성.
- GitHub 원격 `refs/heads/main`은 아직 생성 전이다.
  - `git-lfs.exe`는 계속 살아 있으며 CPU 누적이 약 `42.2`초까지 증가했다.
  - 후속 watcher는 계속 `waiting for existing git-lfs.exe` 상태다.

2026-06-25 16:54 추가:

- UI 전용 채팅은 여전히 active/inProgress다.
  - 새 파일 생성 확인: `_restore_tools\scripts\analyze_maininterface_route_cluster_hierarchy.py`
  - 목적: MainInterface route cluster의 원본 hierarchy/active/sibling/card 내부 상태를 기계적으로 비교하기 위한 분석 스크립트.
- 전투 전용 채팅도 여전히 active/inProgress다.
  - 최신 조인 규칙:
    - hero: `heroDid -> DTHero.modelID -> DTmodel.prefabId`
    - monster: `monsterId -> DTMonster.modelID -> DTmodel.prefabId`
    - skill: `skillDid -> DTSkillAct.prefabId -> LuaUtils.GetSysprefabData -> BattleTimelineResMap[AssetPath]`
  - 이 규칙으로 `BATTLE_PROTOTYPE_MANIFEST.json`의 actor/spine/timeline/effect resource 목록을 만들고 있다.
- GitHub 원격 `refs/heads/main`은 아직 생성 전이다.
  - `git-lfs.exe` CPU 누적은 약 `43.2`초까지 증가했다.
  - 후속 watcher는 계속 `waiting for existing git-lfs.exe` 상태다.

2026-06-25 16:55 추가:

- UI 전용 채팅은 계속 active/inProgress다.
  - 최신 관찰: route owner 5개는 원본에서도 모두 active라서 카드 자체 off는 부적절하다.
  - 새 원인 후보: 원본 localScale `0`인 `Entry`가 `MainInterfaceSceneBuilder`의 zero-scale 보정 규칙 때문에 `1`로 살아나 route 내부 상태 UI가 겹칠 수 있다.
  - 현재 방향: 이 후보를 route hierarchy evidence 표에 붙이고, 원본 localScale/active/sibling 기반 override가 필요한지 판정 중.
- 전투 전용 채팅도 계속 active/inProgress다.
  - 최신 관찰: `HeroCtrl`, `BattleResPreloadMgr`, `BattleTimelineResMap` 기준 조인 규칙을 확정했고, prototype manifest 스크립트 구현 전 datatable schema를 확인 중이다.
- GitHub 원격 `refs/heads/main`은 아직 생성 전이다.
  - `git-lfs.exe` CPU 누적은 약 `44.4`초까지 증가했다.
  - 후속 watcher는 계속 `waiting for existing git-lfs.exe` 상태다.

## 후속 push 절차

1차 background push가 끝난 뒤, 그 사이에 생긴 최신 MainInterface 캡처/검증 결과도 다시 커밋해서 올려야 한다.

메인 폴더에서 실행:

- `PUSH_LATEST_TO_GITHUB_MAIN_AFTER_CURRENT_BACKGROUND.cmd`

이 CMD는 현재 떠 있는 `git-lfs.exe` / `git-remote-https.exe`가 끝날 때까지 기다린 뒤 다음 순서로 진행한다.

1. `git status` 기록
2. 변경분 `git add -A`
3. 변경분이 있으면 `Update girlswar restore workspace` 커밋 생성
4. `git push -u origin main`

후속 push 로그:

- `_restore_tools\logs\github_push_followup_main.log`

## 현재 MainInterface 주의점

최근 route rect override 2개는 Scene에 적용되었지만, 화면 캡처 기준으로 route label과 일부 오른쪽 UI는 여전히 틀어져 있다.

가장 가능성이 높은 다음 원인:

- 원본 TMP가 `riyu_shenzong_0.2_0.2`, `riyu_baibian_0.2_0.2_1` 같은 material/font variant를 쓰는데,
- 현재 복원은 base `riyu` FontAsset에 variant material만 붙이는 형태라 glyph metric/atlas/material 조합이 어긋날 수 있다.

UI 전용 채팅의 다음 우선순위는 variant TMP FontAsset을 원본 bundle에서 glyph/character/atlas/material 단위로 복원하는 것이다.

## 메인 폴더 바로가기 CMD

사용자가 직접 확인하기 쉬운 CMD는 `C:\Users\godho\Downloads\girlswar` 메인 폴더에도 둔다.

- `SHOW_GIT_PUSH_STATUS.cmd`: GitHub push, 원격 main, 변경분 count, 로그 tail 확인
- `OPEN_WORK_SPLIT_STATUS.cmd`: 이 총괄 문서 열기
- `EXPORT_ACTIVE_TMP_VARIANT_FONT_ASSETS.cmd`: `_restore_tools\96_EXPORT_ACTIVE_TMP_VARIANT_FONT_ASSETS.cmd` 호출
- `PROBE_ACTIVE_TMP_VARIANT_FONT_ASSETS.cmd`: `_restore_tools\97_PROBE_ACTIVE_TMP_VARIANT_FONT_ASSETS.cmd` 호출
- `PUSH_TO_GITHUB_MAIN_BACKGROUND.cmd`: 최초 GitHub main background push 시작
- `PUSH_LATEST_TO_GITHUB_MAIN_AFTER_CURRENT_BACKGROUND.cmd`: 현재 LFS push가 끝난 뒤 후속 commit/push watcher 시작

## 2026-06-25 16:43 UI 진행상황

UI 전용 채팅이 active TMP shared material 기준으로 variant FontAsset evidence를 추출했다.

- 리포트: `reports\maininterface\MAININTERFACE_ACTIVE_TMP_VARIANT_FONT_ASSETS.md`
- 요약 JSON: `girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_active_tmp_variant_font_assets_summary.json`
- active shared material count: `3`
- variant FontAsset count: `3`

추출된 variant:

- `riyu_baibian_0.2_0.2_1`: glyph `599`, character `601`, atlas `2048x2048`
- `riyu_shenzong_0.2_0.2`: glyph `424`, character `426`, atlas `2048x1024`
- `EPM_bai_0.2_0.2`: glyph `588`, character `591`, atlas `2048x2048`

다음 UI 검증 포인트:

- variant FontAsset을 실제 Scene에 opt-in mapping으로 적용했는지
- 그래픽 모드 캡처에서 route label이 줄었는지
- Button click validation 24/24 상태가 유지되는지

2026-06-25 16:44 추가:

- static TMP variant probe도 완료되었다.
- 리포트: `reports\maininterface\MAININTERFACE_ACTIVE_TMP_VARIANT_STATIC_FONT_PROBE_RESULT.md`
- probe 결과:
  - `riyu_baibian_0.2_0.2_1`: success `True`, glyph `599`, character `601`
  - `riyu_shenzong_0.2_0.2`: success `True`, glyph `424`, character `426`
  - `EPM_bai_0.2_0.2`: success `True`, glyph `588`, character `591`
- 생성 위치: `girlswar_maininterface_unity\Assets\RestoreData\TMP\static_probe\variants`
- 다음 UI 단계는 이 asset들을 shared material pathID 기반 opt-in mapping으로 Scene에 적용하고 그래픽 캡처/클릭 검증을 다시 돌리는 것이다.

## 2026-06-25 16:43 Battle 진행상황

전투 전용 채팅이 battle evidence index와 XLua decode를 생성했다.

- 리포트: `reports\battle\BATTLE_RESTORE_PLAN.md`
- decode 리포트: `reports\battle\BATTLE_XLUA_DECODE_RESULTS.md`
- decoded output: `girlswar_merged_extracted\decoded\xlua_battle`
- raw output: `girlswar_merged_extracted\extracted\unity\raw_textassets\battle_xlua`

현재 evidence count:

- Battle AssetBundle candidates: `149`
- Battle TextAsset candidates: `5787`
- Battle image candidates: `3057`
- XLua decode targets: `4382`
- Raw TextAssets extracted: `4378`
- Decode rows: `4378`
- Saved decoded Lua-like outputs: `4375`

전투 쪽 빠른 시작점:

- `download/xlualogic/modules/battle.assetbundle`: `HeroCtrl`, `BattleTeam`, `BattleUtil`, `HeroBattleInfo`
- `download/xlualogic/modules/procedure.assetbundle`: `ProcedureNormalBattle`
- `download/xlualogic/modules/battleskillscript.assetbundle`: skill scripts `1728`
- `download/xlualogic/modules/battlebuffscript.assetbundle`: buff scripts `2540`
- `download/roleprefabsandres/battleprefabandres/*.assetbundle`: battle actor Spine evidence

2026-06-25 16:44 추가:

- 전투 decoded flow analysis도 생성되었다.
- 리포트: `reports\battle\BATTLE_DECODED_FLOW_ANALYSIS.md`
- 요약 JSON: `reports\battle\battle_decoded_flow_summary.json`
- 핵심 진입 모듈: `ProcedureNormalBattle`
- 확인된 주요 entry point:
  - `BeginFightPlayWithServer`
  - `BeginBattleWithServer`
  - `InitDataWithFightPlayData`
  - `InitDataWithFightBeforeData`
  - `BeginBattleWithServer_FightPlay`
  - `ProcedureNormalBattle_OnEnter`
  - `ProcedureNormalBattle_TestBattle`
- 흐름상 `BeginBattleWithServer_FightPlay`에 테스트 payload가 있어 서버 없이 deterministic battle prototype을 만들 근거가 있다.
