# Control Tower Status - 2026-06-26 03:33 KST

## 현재 상태
- 프로젝트: `C:\Users\godho\Downloads\girlswar`
- 기준 영상 `참고.mp4`: 분석 완료, 보조 시각 레퍼런스로만 사용
- `플레이.mp4`: 로컬에서 missing으로 취급
- root `.cmd`: 1
- `_restore_tools` 직속 `.cmd`: 0

## 참고 영상 분석 산출물
- `reports\video_reference\REFERENCE_MP4_RESTORE_NOTES_20260626_024037.md`
- `reports\video_reference\reference_overview_10s_contact.jpg`
- `reports\video_reference\reference_frames\frame_000s.jpg` ~ `frame_120s.jpg`
- 영상 메타: 약 121.28초, 1280x570, 30fps
- 판정: runtime/account/xLua 근거가 아니라 motion/visual auxiliary reference

## Battle
### BATTLE58 완료
- 산출물:
  - `reports\battle\BATTLE_58_TRACE_XLUA_GAMEENTRY_MODULESINIT_HANDLER_BINDING_WITH_BATTLE57_ACTORS_NO_FAKE_HANDLER_RESULT.md`
  - `reports\battle\BATTLE_58_TRACE_XLUA_GAMEENTRY_MODULESINIT_HANDLER_BINDING_WITH_BATTLE57_ACTORS_NO_FAKE_HANDLER_RESULT.json`
  - HUD/button audit, xLua/GameEntry trace, dependency graph, click validation, full payload gaps CSV
- 핵심 수치:
  - active/interactable HUD buttons: 5/5
  - direct GraphicRaycaster target included: 5/5
  - forced EventSystem target included: 5/5
  - UnityEvent/onClick known rows: 0
  - UIEventListener delegate rows: 0
  - Lua lifecycle executed rows: 0
- 판정:
  - `patchDecision=blocked_no_patch`
  - `handlerBindingApplied=false`
  - `sceneSaved=false`
  - `isFinalRestoredBattleScreen=false`
- 이유:
  - `XLua.LuaEnv`, `YouYou.GameEntry.Lua`, `YouYou.LuaManager.LoadUIScript`, initialized `ModulesInit.ProcedureNormalBattle`가 restored Unity project에서 실행 가능한 형태로 없음.
  - 버튼 입력 경로는 살아 있지만, source-backed 원본 handler binding은 아직 불가능.

### BATTLE59 진행 중
- 전투 스레드에 지시 완료:
  - `BATTLE_59_AUDIT_LOCAL_SOURCE_BACKED_XLUA_RUNTIME_RECOVERY_FEASIBILITY_AND_BOOTSTRAP_REQUIREMENTS_NO_STUB_NO_EXTERNAL`
- 목표:
  - 로컬 원본 증거만으로 실행 가능한 xLua runtime 복구가 가능한지 감사
  - 단순 type/string/signature와 Unity Editor 실행 가능 runtime 구현을 분리
  - `GameEntry.Lua` / `LuaManager.LoadUIScript` / `ModulesInit.ProcedureNormalBattle` / button handler bootstrap requirement graph 작성
  - external xLua package, dummy Lua, stub GameEntry/LuaManager, fake handler 금지
- 현재 스레드 상태: active

## MainInterface UI
### UI134 완료
- `UIUtil.GetPlayerBigSpineAll`를 `download/xlualogic/common.assetbundle`의 `UIUtil.txt`에서 복호화 완료.
- `homePara` 의미:
  - `[1]=scale`
  - `[2]=Painting_<id> child local x`
  - `[3]=Painting_<id> child local y`
  - optional `[4]=horizontal flip`
- 적용 대상:
  - `UI_heroSpine` parent가 아니라 pooled `paintingGroup` 아래 `Painting_<id>` child
- Hero1005:
  - `[1,0,0]` = scale 1, x 0, y 0, no flip
- bottom nav:
  - old-root 단독 patch 근거 부족
  - `UI_Dock` open-stack 후보가 더 강함
  - UI134에서는 no scene patch

### UI135 진행 중
- UI 스레드에 지시 완료:
  - `MAININTERFACE_135_APPLY_SOURCE_BACKED_HERO1005_HOMEPARA_AND_BACK_FRONT_LAYER_CANDIDATE_CAPTURE_NO_DOCK_PATCH`
- 현재 관찰:
  - `homePara` 값 자체는 Hero1005 기준 no-op일 가능성이 높음
  - `Painting_1005` child transform이 source-backed semantics와 일치하는지 Unity probe 진행 중
  - `Painting_1005_back` source 후보는 존재
  - `Painting_1005_front`는 이름 검색 기준 미확인, 없는 front layer 생성 금지
- guardrail:
  - bottom nav/UI_Dock, activity stack, account/currency, route/world nodes, `UI_bg` raycast/interactable, `btn_discord`는 이번 작업에서 건드리지 않음
- 현재 스레드 상태: active, 아직 UI135 result 파일 없음

## 다음 확인 순서
1. UI135 산출물 생성 여부 확인 및 판정
2. BATTLE59 산출물 생성 여부 확인 및 판정
3. UI135 완료 시 다음 UI 작업은 `UI_Dock` open-stack candidate를 별도 작업으로 분리
4. BATTLE59 완료 시 xLua runtime 복구 가능/불가에 따라 원본 runtime 확보 또는 사용자 승인 external 실험 여부를 blocker로 정리
