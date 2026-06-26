# BATTLE_WORKER_STATUS_20260626_0952

## Scope

- Battle worker follow-up for `C:\Users\godho\Downloads\girlswar`.
- Focused on `girlswar_battle_unity`, especially B72/B73/B74/B75 battle UI/HUD/TMP/mask/handler gate.
- No `girlswar_maininterface_unity` files were edited.
- No scene patch, no canonical scene overwrite, no APK/emulator execution, no runtime instrumentation, no external xLua import, and no fake UI/handler/asset values were created.

## Current Verdict

- `restoredClaim=false`
- `playableClaim=false`
- `patchApplied=false`
- Static battle UI patch review is still blocked.

The immediate blocker remains the same as B75: the B75 runtime snapshot packet has no filled runtime values. A coordinate-only or reference-video-derived patch would not be source-backed.

## Fresh Validation

- Ran static validator:
  - command: `python _restore_tools\scripts\control_tower_validate_runtime_snapshot_packets.py`
  - result: `reports\CONTROL_TOWER_RUNTIME_SNAPSHOT_PACKET_VALIDATOR_20260626_095001_RESULT.json`
  - `readyForPatchReview=false`
  - `approvalStillRequired=true`
  - battle missing runtime values: `7337`
  - UI missing runtime values: `203`
  - total missing runtime values: `7540`

- Ran Unity batch compile/load only:
  - command: `Unity.exe -quit -batchmode -nographics -projectPath girlswar_battle_unity`
  - log: `reports\battle\BATTLE_WORKER_UNITY_COMPILE_20260626_0950.log`
  - exit code: `0`
  - script compile: `Tundra build success`, `0 items updated`, `263 evaluated`
  - note: logged asmdef warning for empty disabled Spine proxy assembly; not a compile failure.

## Actual File Evidence

- Candidate scene checked:
  - `girlswar_battle_unity\Assets\Scenes\Battle72Map11003TrueAspectReprojectionPersistedCandidate.unity`

- Bridge MonoScript GUID references in B72 candidate:
  - `Empty4Raycast`: `7`
  - `LuaUnit`: `2`
  - `LuaForm`: `1`
  - `LuaComBinder`: `1`
  - `UIEventListener`: `1`

- Remaining unresolved serialized state in B72 candidate:
  - `m_Script: {fileID: 0}` rows: `1092`
  - null GUID rows: `157`
  - TMP font rows observed: `65`
  - TMP shared material rows observed: `65`
  - skeletonDataAsset rows observed: `6`
  - sprite rows observed: `861`

- B73 focused HUD/right rail component matrix:
  - rows: `353`
  - loaded `CanvasScaler`: `0`
  - loaded `Mask`: `0`
  - loaded `RectMask2D`: `0`
  - `activeSelf=True`: `74`
  - `activeInHierarchy=True`: `68`

- B73 decision matrix:
  - rows: `373`
  - `no_patch_in_battle73`: `373`
  - `runtime_snapshot_required`: `269`
  - `handler_or_xlua_required`: `94`
  - `already_matches_candidate_scene`: `10`

- B74 TMP/mask component gap matrix:
  - rows: `81`
  - `no_patch_in_battle74`: `81`
  - `component_rehydration_required`: `81`
  - exact source/candidate path matches: `38`
  - source rows absent from B73 focused candidate paths: `43`

- B75 field-to-patch matrix:
  - rows: `7337`
  - `safeToPatchNow=true`: `0`
  - largest categories: `rect_transform=2356`, `graphic_image_button_raycast=1780`, `tmp_autosize_font_material=997`, `active_chain=942`, `mask_rectmask_stencil_material=411`, `handler_lua_lifecycle=148`

- B75 static-vs-runtime matrix:
  - rows: `7337`
  - `safeSourceBackedStaticPatchCandidateNow=true`: `0`
  - `handler_or_xlua_required`: `5118`
  - `component_rehydration_required`: `2204`
  - `runtime_snapshot_required`: `15`

## Root Cause Summary

- B72 map reprojection remains the latest validated candidate-state improvement.
- The battle UI is not playable because original `UI_NormalBattle` / `ModulesInit.ProcedureNormalBattle` lifecycle state is not available locally.
- Button/raycast plumbing has partial source-backed bridge evidence, but gameplay handler binding remains unavailable without original runtime Lua/GameEntry/LuaManager state.
- TMP/mask/stencil/autosize data has source evidence in older rows, but loaded candidate components remain absent/unresolved; applying those fields statically would cross the no-fake/no-coordinate-only guardrail.
- Character card/skill card/list linkage is still separated from the HUD patch gate because B75 marks those rows as payload/card UI blockers, not safe HUD patch inputs.

## Files Generated This Pass

- `reports\CONTROL_TOWER_RUNTIME_SNAPSHOT_PACKET_VALIDATOR_20260626_095001_RESULT.json`
- `reports\CONTROL_TOWER_RUNTIME_SNAPSHOT_PACKET_VALIDATOR_20260626_095001_RESULT.md`
- `reports\CONTROL_TOWER_RUNTIME_SNAPSHOT_PACKET_VALIDATOR_20260626_095001_VALIDATION_MATRIX.csv`
- `reports\CONTROL_TOWER_RUNTIME_SNAPSHOT_PACKET_VALIDATOR_20260626_095001_FIELD_SAMPLE.csv`
- `reports\battle\BATTLE_WORKER_UNITY_COMPILE_20260626_0950.log`
- `reports\BATTLE_WORKER_STATUS_20260626_0952.md`

Unity batch import also refreshed these untracked metadata files:

- `girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_73_ROUTE_HUD_RIGHT_RAIL_RUNTIME_STATE_SIBLING_MASK_TMP_AUDIT_AFTER_PERSISTED_MAP_REPROJECTION_NO_PATCH_UNITY.json.meta`
- `girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_73_ROUTE_HUD_RIGHT_RAIL_RUNTIME_STATE_SIBLING_MASK_TMP_AUDIT_AFTER_PERSISTED_MAP_REPROJECTION_NO_PATCH_COMPONENT_STATE_UNITY.csv.meta`

## Next Safe Step

Do not patch battle HUD/TMP/mask/handler fields from the current static data. The next safe step is still:

1. Obtain explicit approval for original runtime snapshot/dump, or receive filled B75 runtime snapshot values from approved original runtime evidence.
2. Re-run `control_tower_validate_runtime_snapshot_packets.py`.
3. Proceed to BATTLE_76 patch review only if the validator reports `readyForPatchReview=true`.

