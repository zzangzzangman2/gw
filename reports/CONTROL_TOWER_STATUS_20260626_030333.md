# CONTROL_TOWER_STATUS_20260626_030333

## Current Verdict

- Final restored main UI: `false`
- Final playable battle screen: `false`
- Reference image: `C:\Users\godho\.codex\attachments\e607fc34-b674-4516-b051-8d396cd6df06\image-1.png`
- `플레이.mp4`: `missing`
- `참고.mp4`: `available, auxiliary only`

## MainInterface Latest

- Latest completed UI task: `MAININTERFACE_131_REFERENCE_DIFF_ROOT_CAUSE_AND_SOURCE_BACKED_PATCH_MATRIX_NO_FAKE_PATCH`
- Result: `restoredClaim=false`, `candidatePatchApplied=false`, `scenePatchApplied=false`
- Full diff vs reference remains large: corr `0.424216`, meanAbsDiff `0.209078`, changed30 `0.70151`
- Classification counts:
  - `requires_runtime_snapshot`: `4`
  - `needs_unity_runtime_probe`: `3`
  - `source_backed_static_patch_possible`: `1`
  - `source_backed_static_patch_not_allowed_by_guardrail`: `2`
  - `already_matches_or_low_priority`: `1`

### UI Blockers

- Activity stack, face activity, chat text, and top profile/currency values require runtime/account/server snapshot.
- No activity slot hide/label/icon/spine patch is allowed before UI130 snapshot replay succeeds.
- `btn_discord` review hide, `UI_bg` raycast/interactable off, `node_act_btn/btn_act_*` arbitrary hide, and route/world/zhuye guardrail node hide remain forbidden.
- Only snapshot-free candidate lane is static TMP/font/material binding for source-identified static labels.

### UI Next Delegation

- Sent to UI worker `019eff6c-a02a-7f73-9ffb-74456322d1ce`:
  - `MAININTERFACE_132_SOURCE_BACKED_STATIC_TMP_FONT_MATERIAL_BINDING_AUDIT_AND_CANDIDATE_PATCH_NO_DYNAMIC_TEXT`
- Scope: node-level TMP/text audit, exclude runtime labels, apply candidate material/font patch only if source-backed.

## Battle Latest

- Latest completed battle task: `BATTLE_55_VALIDATE_CANVAS_ZERO_SCALE_RUNTIME_RENDER_AND_ACTOR_VISIBILITY_OR_SOURCE_BACKED_PATCH`
- Result: `isFinalRestoredBattleScreen=false`, `patchDecision=blocked_no_patch`, `sceneSaved=false`
- Zero-scale Canvas suspicion was reduced:
  - zero-scale rows probed: `7`
  - zero-scale Canvas rows: `2`
  - runtime zero local-scale Canvas rows: `0`
  - zero-scale Canvas rows with depth-ready descendant Graphics: `2`
- Actor visibility blocker was narrowed:
  - active actors probed: `3`
  - actor ids: `1002`, `1034`, `1100111 -> 3001`
  - enabled Renderer rows: `3`
  - MeshFilter mesh rows: `0`
  - camera/layer/frustum candidate rows: `3`
  - capture pixel signal in projected actor rect: `0`
  - conclusion: `actor_invisibility_primary_blocker_no_mesh_filter_mesh`

### Battle Blockers

- xLua/GameEntry runtime bootstrap remains source-blocked from BATTLE53/BATTLE52.
- Direct GraphicRaycaster/ExecuteEvents click path exists for selected buttons, but gameplay handler/Lua lifecycle binding remains `0`.
- Active actor candidates are present but render as empty MeshRenderer rows with empty mesh/material/shader and bounds `0/0/0`.
- No fake actor, fake handler, external xLua package, coordinate-only success, screenshot paste, or whole-atlas patch is allowed.

### Battle Next Delegation

- Sent to battle worker `019eff6c-edb7-7ca1-b7b9-fff5378a6ff6`:
  - `BATTLE_56_TRACE_ACTOR_PREFAB_MESH_MATERIAL_SHADER_SOURCE_IMPORT_GAP_OR_SOURCE_BACKED_PATCH`
- Scope: audit local actor bundle prefab/PPtr/resource contents for `1002`, `1034`, and `3001`; patch only if mesh/material/shader restoration is source-backed.

## Character/Data Latest

- Latest character/data task: `BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST`
- Local actor subset: `loadable 3/12`
  - loadable: our `1002`, our `1034`, enemy `1100111 -> 3001`
  - `1036`: `not_fetchable_local`
  - enemies `1100112/1100113/1100121/1100122/1100123/1100131/1100132/1100133`: unresolved payload instance ids
- Skill rows: `61`
  - `loadable`: `4`
  - `loadable_with_unresolved_common_resource_deps`: `8`
  - `data_only_missing_actor`: `27`
  - `passive_no_timeline`: `22`
- The local subset is for runtime/interaction validation only, not a full restore claim.

## Command Policy

- root `.cmd` count: `1`
- `_restore_tools` direct `.cmd` count: `0`
- Archive wrappers under `_restore_tools\cmd_archive` are allowed.

## Latest Source Reports

- `reports\maininterface\MAININTERFACE_131_REFERENCE_DIFF_ROOT_CAUSE_AND_SOURCE_BACKED_PATCH_MATRIX_NO_FAKE_PATCH_RESULT.md`
- `reports\battle\BATTLE_55_VALIDATE_CANVAS_ZERO_SCALE_RUNTIME_RENDER_AND_ACTOR_VISIBILITY_OR_SOURCE_BACKED_PATCH_RESULT.md`
- `reports\battle\BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST.md`
