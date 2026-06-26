# Control Tower Status - 2026-06-26 03:39 KST

## 현재 상태
- 프로젝트: `C:\Users\godho\Downloads\girlswar`
- `참고.mp4`: 분석 완료, 보조 visual/motion reference로만 사용
- `플레이.mp4`: missing
- root `.cmd`: 1
- `_restore_tools` 직속 `.cmd`: 0
- 최종 복원 성공 선언: 아직 금지

## Video Reference
- 분석 산출물:
  - `reports\video_reference\REFERENCE_MP4_RESTORE_NOTES_20260626_024037.md`
  - `reports\video_reference\reference_overview_10s_contact.jpg`
  - `reports\video_reference\reference_frames\frame_000s.jpg` ~ `frame_120s.jpg`
- 메타: 약 121.28초, 1280x570, 30fps
- 용도: runtime/account/xLua 근거가 아니라 화면 움직임/구도 보조 근거

## Battle
### BATTLE59 완료
- 산출물:
  - `reports\battle\BATTLE_59_AUDIT_LOCAL_SOURCE_BACKED_XLUA_RUNTIME_RECOVERY_FEASIBILITY_AND_BOOTSTRAP_REQUIREMENTS_NO_STUB_NO_EXTERNAL_RESULT.md`
  - `reports\battle\BATTLE_59_AUDIT_LOCAL_SOURCE_BACKED_XLUA_RUNTIME_RECOVERY_FEASIBILITY_AND_BOOTSTRAP_REQUIREMENTS_NO_STUB_NO_EXTERNAL_RESULT.json`
  - xLua runtime evidence CSV
  - GameEntry/LuaManager/ModulesInit bootstrap graph CSV
  - original handler feasibility matrix CSV
  - full payload blocker separation CSV
- 결론:
  - `patchDecision=blocked_no_patch`
  - `sceneSaved=false`
  - `sourceBackedBootstrapApplied=false`
  - `handlerBindingApplied=false`
  - `isFinalRestoredBattleScreen=false`
- 핵심 수치:
  - source-backed importable editor xLua runtime candidates: 0
  - executable xLua runtime available: false
  - GameEntry/LuaManager executable bootstrap available: false
  - BATTLE57 actor carryover: source-backed actor/render/pixel signal 3/3
  - BATTLE58 button carryover: direct raycast 5/5, forced EventSystem 5/5, handler bound 0, Lua lifecycle 0
- 판정:
  - 로컬 원본에는 decoded Lua, IL2CPP/DummyDll type signature, bridge schema, native player artifact가 있음.
  - 하지만 Unity Editor에서 실행 가능한 source-backed `XLua.LuaEnv`, `GameEntry.Lua`, `LuaManager.LoadUIScript` runtime은 없음.
  - DummyDll/IL2CPP는 signature evidence일 뿐 executable runtime이 아님.
  - native player artifact는 source-backed이지만 editor-importable managed runtime이 아님.

### Battle Next Decision Boundary
- 다음 blocker:
  - `requires_original_xlua_runtime_or_user_approved_external_xlua_and_full_payload_gaps`
- 현재 상태에서는 fake handler, dummy Lua, stub GameEntry/LuaManager, no-op handler 성공 처리 금지.
- 사용자 명시 승인 없이 external xLua/package 실험은 진행하지 않음.
- Full payload gap은 별도:
  - local actor subset 3/12
  - skill/timeline도 subset

## MainInterface UI
### UI135 완료
- 산출물:
  - `reports\maininterface\MAININTERFACE_135_APPLY_SOURCE_BACKED_HERO1005_HOMEPARA_AND_BACK_FRONT_LAYER_CANDIDATE_CAPTURE_NO_DOCK_PATCH_RESULT.md`
  - `reports\maininterface\MAININTERFACE_135_APPLY_SOURCE_BACKED_HERO1005_HOMEPARA_AND_BACK_FRONT_LAYER_CANDIDATE_CAPTURE_NO_DOCK_PATCH_RESULT.json`
  - `reports\maininterface\MAININTERFACE_135_hero_transform_before_after.csv`
  - `reports\maininterface\MAININTERFACE_135_back_front_layer_evidence_probe.csv`
  - `reports\maininterface\MAININTERFACE_135_reference_diff_regions.csv`
  - `reports\maininterface\MAININTERFACE_135_REFERENCE_DIFF_CONTACT.png`
- 결론:
  - `restoredClaim=false`
  - `sceneSaved=true`
  - `candidatePatchApplied=true`
  - `productionPatchApplied=false`
  - `patchDecision=candidate_patch_homepara_noop_and_back_layer_probe_no_dock_patch`
- Hero1005:
  - existing UI128 candidate already matched Hero1005 `homePara=[1,0,0]`
  - UI135 applied homePara to `Painting_1005` child, not `UI_heroSpine` parent
  - result is source-backed no-op: local position 0,0,0 and scale 1,1,1
- Back/front:
  - `Painting_1005_back` source atlas/skel/png exists and animation `A` exists
  - current zero-offset back-layer mount renders but overpaints and worsens reference metrics
  - `Painting_1005_front` complete source triplet missing; no front layer created
  - current `Painting_1005_back` mount must not be promoted without original prefab transform/order/mask evidence
- Metrics:
  - UI128 vs reference full corr 0.424216, hero corr 0.475187
  - UI135 vs reference full corr 0.153161, hero corr 0.034676
  - click validation: 55 total / 45 active / 43 clickable / 2 blocked

### UI136 진행 중
- 지시 완료:
  - `MAININTERFACE_136_TRACE_UIDOCK_OPEN_STACK_BOTTOM_NAV_CANDIDATE_NO_BACK_LAYER_PROMOTION`
- 현재 관찰:
  - UI worker found `UI_Dock` / `UI_Dock_old` roots inside `maininterface.assetbundle`
  - Lua bindings and Dock source candidates are present
  - Unity-side candidate attach feasibility is being checked
- Guardrail:
  - Start from UI128/safe old-root baseline
  - carry over `Painting_1005` main + homePara no-op only
  - do not carry UI135 overpainting `Painting_1005_back`
  - do not touch activity stack, face activity, chat/account/currency, `btn_discord`, `UI_bg` raycast/interactable, route/world nodes
- Current UI136 status: active, no UI136 report file yet

## 다음 확인 순서
1. UI136 산출물 생성 여부 확인
2. UI136 candidate capture/diff/click 판정
3. Battle은 user decision 전까지 source-backed xLua runtime blocker로 유지
4. 필요 시 이후 전투는 runtime decision package 또는 payload gap inventory 확장으로만 진행
