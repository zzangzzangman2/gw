# CONTROL_TOWER_POST_APPROVAL_WORKER_PROMPTS_20260626_094058

## Purpose

- Draft worker prompts for the existing four-thread setup.
- These prompts were not sent to any worker thread.
- They are only for after approved runtime snapshot values or new source evidence exists.

## Current Threads

| Role | Title | Thread ID |
| --- | --- | --- |
| Control tower | `폴더 파악하기` | `019eff46-f67e-7dc1-9438-0969408f29ee` |
| Battle worker | `GirlsWar 전투 복원 전용` | `019eff6c-edb7-7ca1-b7b9-fff5378a6ff6` |
| UI worker | `GirlsWar UI 복원 전용` | `019eff6c-a02a-7f73-9ffb-74456322d1ce` |
| Character worker | `GirlsWar 캐릭터 목록 전용` | `019eff6d-307b-7532-8b1d-7105b18cd6b7` |

## Prerequisites Before Sending

- User explicitly approves original runtime snapshot/dump, or supplies filled UI148/B75 snapshot files.
- Run `control_tower_validate_runtime_snapshot_packets.py` against the filled snapshots.
- Proceed only if validator reports `readyForPatchReview=true`, or send a correction request instead of patch work.
- Do not send patch prompts based on null placeholders or inferred values.

## Battle Worker Prompt

Send to `019eff6c-edb7-7ca1-b7b9-fff5378a6ff6` only after B75 runtime values are filled and validator passes.

```text
프로젝트: C:\Users\godho\Downloads\girlswar

컨트롤타워에서 승인된 B75 runtime snapshot 값이 들어왔고, control_tower_validate_runtime_snapshot_packets.py 검증을 통과한 경우에만 진행하세요. 목표는 BATTLE_76_RUNTIME_SNAPSHOT_BACKED_UI_NORMALBATTLE_ROUTE_HUD_TMP_MASK_PATCH_REVIEW_NO_FAKE_PATCH 입니다.

반드시 먼저 읽을 것:
- reports\CONTROL_TOWER_STATUS_20260626_093938.md
- reports\CONTROL_TOWER_RUNTIME_SNAPSHOT_PACKET_VALIDATOR_20260626_093911_RESULT.json 또는 최신 validator RESULT.json
- reports\battle\BATTLE_75_ORIGINAL_RUNTIME_SNAPSHOT_APPROVAL_PACKET_FOR_UI_NORMALBATTLE_ROUTE_TMP_MASK_HANDLER_AFTER_B74_NO_EXECUTION_NO_PATCH_APPROVAL_PACKET_TEMPLATE.json
- filled B75 runtime snapshot file provided/approved by the control tower
- reports\battle\BATTLE_75...FIELD_TO_PATCH_UNBLOCK_MAPPING_MATRIX.csv
- reports\battle\BATTLE_75...STATIC_KNOWN_VS_RUNTIME_REQUIRED_CLASSIFICATION_MATRIX.csv

Allowed only after validator pass:
1. Compare filled runtime values against B72/B73/B74 candidate/source rows.
2. Produce a patch review matrix separating source-backed route/HUD/TMP/mask patch candidates from handler-only/runtime-only fields.
3. If and only if source-backed fields are proven, create a candidate patch plan. Do not overwrite canonical scenes without separate control-tower approval.
4. Validate captures against reference and 참고.mp4 only as auxiliary evidence.

Still forbidden:
- fake handlers/assets/cards/actors
- external xLua import
- package/manifest edit
- coordinate-only patch
- restored/playable claim before capture + interaction verification
```

## UI Worker Prompt

Send to `019eff6c-a02a-7f73-9ffb-74456322d1ce` only after UI148 runtime values are filled and validator passes.

```text
프로젝트: C:\Users\godho\Downloads\girlswar

컨트롤타워에서 승인된 UI148 runtime snapshot 값이 들어왔고, control_tower_validate_runtime_snapshot_packets.py 검증을 통과한 경우에만 진행하세요. 목표는 MAININTERFACE_149_RUNTIME_SNAPSHOT_BACKED_PATCH_REVIEW_AND_CANDIDATE_NO_FAKE_PATCH 입니다.

반드시 먼저 읽을 것:
- reports\CONTROL_TOWER_STATUS_20260626_093938.md
- reports\CONTROL_TOWER_RUNTIME_SNAPSHOT_PACKET_VALIDATOR_20260626_093911_RESULT.json 또는 최신 validator RESULT.json
- reports\maininterface\MAININTERFACE_148_RUNTIME_SNAPSHOT_APPROVAL_PACKET_AND_STATIC_FIELD_EXHAUSTION_NO_RUNTIME_NO_PATCH_approval_packet_template.json
- filled UI148 runtime snapshot file provided/approved by the control tower
- reports\maininterface\MAININTERFACE_148...minimal_runtime_snapshot_field_checklist.csv
- reports\maininterface\MAININTERFACE_148...mismatch_unblocked_by_field_risk_matrix.csv

Allowed only after validator pass:
1. Map filled runtime values to UI_Dock/UI_MainPage form stack, CanvasHelper depth, guarded active/sibling, UI_bg, mask/stencil, and dynamic activity/account/chat/currency decisions.
2. Classify which candidate patches are source-backed and which remain runtime-only.
3. If source-backed patch candidates exist, produce a candidate-only patch plan and capture validation plan.
4. Do not hide guarded nodes or modify UI_bg raycast without direct runtime evidence.

Still forbidden:
- fake icon/text/spine/card values
- screenshot/atlas paste
- arbitrary route/world hiding
- scene patch before source-backed candidate review
- restored claim before reference capture validation
```

## Character Worker Prompt

Send to `019eff6d-307b-7532-8b1d-7105b18cd6b7` only if new actor bundle, DTMonster/DTmodel chain, or source alias evidence is provided.

```text
프로젝트: C:\Users\godho\Downloads\girlswar

새 source-backed actor bundle, DTMonster/DTmodel chain, or explicit alias rule evidence가 제공된 경우에만 진행하세요. 목표는 CHARACTER_67_NEW_SOURCE_EVIDENCE_RECHECK_AND_PROPOSAL_ONLY_NO_IMPORT 입니다.

반드시 먼저 읽을 것:
- reports\CONTROL_TOWER_THREAD_REGISTRY_20260626_093536.md
- reports\characters\CHARACTER_66_UNRESOLVED_ENEMY_ID_SOURCE_ALIAS_TRACE_NO_NETWORK_NO_PROMOTION_RESULT.json
- reports\characters\CHARACTER_65_FULL_BATTLE_PAYLOAD_ROSTER_AND_BUNDLE_GAP_MATRIX_NO_NETWORK_NO_IMPORT_RESULT.json
- newly provided source evidence path(s)

Allowed:
1. Read-only verify the new evidence.
2. Decide whether it proves exact 1036 battle actor bundle, unresolved enemy actor chains, or explicit aliases.
3. Write proposal-only matrices. Do not copy/import/scene-modify.

Still forbidden:
- network download
- file copy/import/move/delete
- fake alias promotion
- replacing enemies with 3001 without exact source rule
```

## Current Blocker

- UI148/B75 runtime values are still null.
- Latest validator dry-run reports `readyForPatchReview=false`.
- Do not send patch-review prompts until filled values and explicit approval evidence exist.
