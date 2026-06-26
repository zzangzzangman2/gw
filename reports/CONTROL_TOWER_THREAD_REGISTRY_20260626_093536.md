# CONTROL_TOWER_THREAD_REGISTRY_20260626_093536

## Purpose

- Records the existing four-thread GirlsWar coordination structure shown by the user.
- No new Codex thread should be created for this project unless the user explicitly asks.
- This `폴더 파악하기` thread remains the control tower.

## Threads

| Role | Title | Thread ID | Status | Latest Known Track |
| --- | --- | --- | --- | --- |
| Control tower | `폴더 파악하기` | `019eff46-f67e-7dc1-9438-0969408f29ee` | active | coordination/reporting |
| Battle worker | `GirlsWar 전투 복원 전용` | `019eff6c-edb7-7ca1-b7b9-fff5378a6ff6` | idle | BATTLE75 |
| UI worker | `GirlsWar UI 복원 전용` | `019eff6c-a02a-7f73-9ffb-74456322d1ce` | idle | MAININTERFACE148 |
| Character worker | `GirlsWar 캐릭터 목록 전용` | `019eff6d-307b-7532-8b1d-7105b18cd6b7` | idle | CHARACTER66 |

## Latest Worker State

### Battle Worker

- Latest completed task: `BATTLE_75_ORIGINAL_RUNTIME_SNAPSHOT_APPROVAL_PACKET_FOR_UI_NORMALBATTLE_ROUTE_TMP_MASK_HANDLER_AFTER_B74_NO_EXECUTION_NO_PATCH`
- Output root: `C:\Users\godho\Downloads\girlswar\reports\battle`
- Main result: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_75_ORIGINAL_RUNTIME_SNAPSHOT_APPROVAL_PACKET_FOR_UI_NORMALBATTLE_ROUTE_TMP_MASK_HANDLER_AFTER_B74_NO_EXECUTION_NO_PATCH_RESULT.md`
- Current conclusion:
  - B72 map reprojection candidate remains validated.
  - B75 deduplicated runtime fields: `7337`
  - source-backed static patch candidates now: `0`
  - next blocker: original `UI_NormalBattle` runtime snapshot or source-backed xLua/GameEntry/ModulesInit recovery.

### UI Worker

- Latest completed task: `MAININTERFACE_148_RUNTIME_SNAPSHOT_APPROVAL_PACKET_AND_STATIC_FIELD_EXHAUSTION_NO_RUNTIME_NO_PATCH`
- Output root: `C:\Users\godho\Downloads\girlswar\reports\maininterface`
- Main result: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_148_RUNTIME_SNAPSHOT_APPROVAL_PACKET_AND_STATIC_FIELD_EXHAUSTION_NO_RUNTIME_NO_PATCH_RESULT.md`
- Current conclusion:
  - main-screen mismatch root cause is not only aspect/capture framing.
  - required runtime fields: `197`
  - statically inferable new fields: `0`
  - next blocker: approved runtime snapshot/dump for UI_Dock/UI_MainPage form stack, CanvasHelper cascade, guarded active/sibling state, UI_bg raycast state, mask/stencil, and UI130-compatible dynamic values.

### Character Worker

- Latest completed task: `CHARACTER_66_UNRESOLVED_ENEMY_ID_SOURCE_ALIAS_TRACE_NO_NETWORK_NO_PROMOTION`
- Output root: `C:\Users\godho\Downloads\girlswar\reports\characters`
- Main result: `C:\Users\godho\Downloads\girlswar\reports\characters\CHARACTER_66_UNRESOLVED_ENEMY_ID_SOURCE_ALIAS_TRACE_NO_NETWORK_NO_PROMOTION_RESULT.md`
- Current conclusion:
  - unresolved enemy ids: `1100112`, `1100113`, `1100121`, `1100122`, `1100123`, `1100131`, `1100132`, `1100133`
  - source hits found: `1095`
  - source-backed aliases found: `0`
  - exact `1036` battle actor bundle remains missing.

## Control Tower Artifacts

- Latest unified pre-runtime packet: `C:\Users\godho\Downloads\girlswar\reports\CONTROL_TOWER_UNIFIED_PRE_RUNTIME_APPROVAL_PACKET_20260626_093259.md`
- Latest runtime approval gate report: `C:\Users\godho\Downloads\girlswar\reports\CONTROL_TOWER_RUNTIME_APPROVAL_GATE_20260626_072517.md`
- Latest broad status report: `C:\Users\godho\Downloads\girlswar\reports\CONTROL_TOWER_STATUS_20260626_072248.md`

## Guardrail / Command Policy

- No restored/playable claim.
- No new thread creation.
- No runtime instrumentation or APK/emulator execution.
- No external xLua import.
- No package/manifest edits.
- No fake HUD/card/icon/text/spine/effect/actor/handler.
- No screenshot/atlas paste.
- No coordinate-only success claim.
- Command policy verified: root `.cmd=1`, `_restore_tools` direct `.cmd=0`.

## Next Coordination Rule

- If the user approves runtime snapshot/dump, route the battle portion to `GirlsWar 전투 복원 전용` and the main-screen portion to `GirlsWar UI 복원 전용`.
- If the user provides source-backed actor bundle or alias evidence, route it to `GirlsWar 캐릭터 목록 전용`.
- Keep this current thread as the only coordination/control tower thread.
