# CONTROL_TOWER_STATUS_20260626_025430

## Scope

- Project: `C:\Users\godho\Downloads\girlswar`
- Overall status: not final restored.
- Main reference image: `C:\Users\godho\.codex\attachments\e607fc34-b674-4516-b051-8d396cd6df06\image-1.png`
- `C:\Users\godho\Downloads\참고.mp4`: auxiliary visual/motion reference only.
- `C:\Users\godho\Downloads\플레이.mp4`: still missing.
- Generated at: `2026-06-26 02:54:30 KST`

## MainInterface Current State

Latest completed task:
- `MAININTERFACE_130_RUNTIME_ACTIVITY_SNAPSHOT_IMPORT_REPLAY_PIPELINE_NO_FAKE_PATCH`

Verdict:
- `restoredClaim=false`
- No scene visual patch.
- Runtime snapshot replay pipeline exists and refuses fake defaults.
- Default replay status: `blocked_missing_runtime_snapshot_fields`
- Candidate patch allowed: `false`

Main UI blocker:
- Real `ActMgr.activitys` plus account/server runtime fields are required before activity slots, labels, redpoints, visibility, or spines can be source-backed.
- Missing fields include `activitys`, `faceActivitys`, `playerInfo.level`, `playerInfo.vip`, redpoint ids, review flags, guide state, server time, and client callback outputs.

## Battle Current State

Latest completed control-tower task:
- `BATTLE_54_VALIDATE_ROUTE_ACTIVE_SIBLING_MASK_TMP_SCALE_AUTOSIZE_ACTOR_PAYLOAD`

Important outputs:
- `reports\battle\BATTLE_54_VALIDATE_ROUTE_ACTIVE_SIBLING_MASK_TMP_SCALE_AUTOSIZE_ACTOR_PAYLOAD_RESULT.md`
- `reports\battle\BATTLE_54_VALIDATE_ROUTE_ACTIVE_SIBLING_MASK_TMP_SCALE_AUTOSIZE_ACTOR_PAYLOAD_RESULT.json`
- `reports\battle\BATTLE_54_VALIDATE_ROUTE_ACTIVE_SIBLING_MASK_TMP_SCALE_AUTOSIZE_ACTOR_PAYLOAD_ROUTES.csv`
- `reports\battle\BATTLE_54_VALIDATE_ROUTE_ACTIVE_SIBLING_MASK_TMP_SCALE_AUTOSIZE_ACTOR_PAYLOAD_ACTORS.csv`
- `reports\battle\BATTLE_54_VALIDATE_ROUTE_ACTIVE_SIBLING_MASK_TMP_SCALE_AUTOSIZE_ACTOR_PAYLOAD_MASKS.csv`
- `reports\battle\BATTLE_54_VALIDATE_ROUTE_ACTIVE_SIBLING_MASK_TMP_SCALE_AUTOSIZE_ACTOR_PAYLOAD_TMP_TEXT.csv`
- `reports\battle\BATTLE_54_VALIDATE_ROUTE_ACTIVE_SIBLING_MASK_TMP_SCALE_AUTOSIZE_ACTOR_PAYLOAD_HERO_CARDS.csv`
- `reports\battle\BATTLE_54_VALIDATE_ROUTE_ACTIVE_SIBLING_MASK_TMP_SCALE_AUTOSIZE_ACTOR_PAYLOAD_BUTTON_ROUTES.csv`
- `_restore_tools\scripts\battle54_validate_route_active_sibling_mask_tmp_actor_payload.py`

BATTLE54 verdict:
- `visual_status=structural_route_actor_card_audit_complete_no_runtime_patch`
- `isFinalRestoredBattleScreen=false`
- `patchDecision=blocked_no_scene_patch_in_battle54_static_audit`
- Audited route rows: `1046`
- Active zero-ish scale route rows: `7`
- Inactive critical route rows: `19`
- Scene actor rows: `6`
- Active scene actor rows: `3`
- Active loadable actor rows: `3`
- TMP/text rows: `65`
- TMP auto-size counts: `{'0': 64, '1': 1}`
- Negative character-spacing rows: `15`
- Mask rows: `16`
- Serialized Mask-ish rows: `8`
- Name-only mask candidate rows: `8`
- Active hero card rows: `3`
- Active cards with sprite-backed images: `3`
- Button rows: `31`
- Active button rows: `16`

Payload state:
- Manifest classification: `local_playable_subset_only_not_full_payload`
- Loadable actors: `3/12`
- Active/loadable scene actor ids: our `1002`, our `1034`, enemy `1100111 -> 3001`
- `1036` remains `not_fetchable_local`
- Enemy payload ids `1100112`, `1100113`, `1100121`, `1100122`, `1100123`, `1100131`, `1100132`, `1100133` remain unresolved.

Runtime carryover:
- BATTLE51 direct GraphicRaycaster target included: `5`
- BATTLE51 forced EventSystem target included: `5`
- BATTLE52 Lua lifecycle executed: `0`
- BATTLE53 verdict: `accepted_block_no_source_backed_xlua_runtime_available_locally`

Battle blocker split:
- The current mismatch is not explained by a single button coordinate.
- Latest scene has active HUD/card/button/actor candidates, but source-backed Lua lifecycle/handler binding is still not executing.
- Current local payload is a subset, not the full original battle payload.
- Mask/stencil and TMP states are serialized evidence, but not enough to invent runtime behavior or fake stencil/TMP patches.

## Worker Coordination

Battle worker `019eff6c-edb7-7ca1-b7b9-fff5378a6ff6` has been sent the next task:
- `BATTLE_55_VALIDATE_CANVAS_ZERO_SCALE_RUNTIME_RENDER_AND_ACTOR_VISIBILITY_OR_SOURCE_BACKED_PATCH`

BATTLE55 objective:
- Use BATTLE54 route/actor/card CSVs.
- Verify whether zero-ish Canvas/root scale affects runtime render/raycast/child coordinates.
- Separate why active actor 3 candidates are not visible in BATTLE51 capture: camera culling, layer, render queue, material, shader, mask, sibling/order, or other.
- Save only source-backed candidate scene patches; otherwise report `blocked_no_patch`.
- No fake actor, card, icon, text, handler, or coordinate-only success.

UI worker `019eff6c-a02a-7f73-9ffb-74456322d1ce` has been sent the next task:
- `MAININTERFACE_131_REFERENCE_DIFF_ROOT_CAUSE_AND_SOURCE_BACKED_PATCH_MATRIX_NO_FAKE_PATCH`

UI131 objective:
- Split the reference-vs-current capture mismatch into a root-cause matrix.
- Classify each mismatch as `requires_runtime_snapshot`, `source_backed_static_patch_possible`, `source_backed_static_patch_not_allowed_by_guardrail`, `needs_unity_runtime_probe`, or `already_matches_or_low_priority`.
- Preserve UI130 rule: activity slot/icon/text/spine patching is forbidden until a real runtime snapshot passes replay.
- Keep guardrails for `btn_discord`, `UI_bg`, `node_act_btn/btn_act_*`, `zhuye_di1`, `zhuye_bian`, route/world nodes, and screenshot/atlas/fake assets.

## Reference Video State

Latest `참고.mp4` analysis remains:
- `reports\video_reference\REFERENCE_MP4_RESTORE_NOTES_20260626_024037.md`
- `reports\video_reference\reference_overview_10s_contact.jpg`
- `reports\video_reference\reference_frames\frame_000s.jpg` through `frame_120s.jpg`

Reference-use verdict:
- `0s`: auxiliary MainInterface visual validation only.
- `20s`, `50s`, `60s`, `90s`: useful battle baseline/HUD/skill-state references.
- The video is visual/motion evidence, not executable xLua runtime evidence and not account/server activity-state evidence.

## Command Policy

Latest checked:
- root `.cmd` count: `1`
- root command file: `00_COMMAND_CENTER.cmd`
- `_restore_tools` direct `.cmd` count: `0`
- Archive wrappers under `_restore_tools\cmd_archive` remain allowed.

## Current Control Decision

BATTLE54 is complete and BATTLE55 is delegated to the battle worker.

The goal remains active. It is not complete, because the final main UI and final playable battle screen are still unproven and current evidence shows missing runtime/account/source inputs.
