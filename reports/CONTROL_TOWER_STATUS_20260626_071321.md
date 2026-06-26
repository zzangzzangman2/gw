# CONTROL_TOWER_STATUS_20260626_071321

## Scope

- Continued control-tower management after `CONTROL_TOWER_STATUS_20260626_065734`.
- Dispatched and verified BATTLE73 and BATTLE74 after the BATTLE72 persisted map-framing candidate.
- No restored/playable claim is made.

## BATTLE73 Result

- Report: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_73_ROUTE_HUD_RIGHT_RAIL_RUNTIME_STATE_SIBLING_MASK_TMP_AUDIT_AFTER_PERSISTED_MAP_REPROJECTION_NO_PATCH_RESULT.md`
- JSON: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_73_ROUTE_HUD_RIGHT_RAIL_RUNTIME_STATE_SIBLING_MASK_TMP_AUDIT_AFTER_PERSISTED_MAP_REPROJECTION_NO_PATCH_RESULT.json`
- Candidate scene used: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\Scenes\Battle72Map11003TrueAspectReprojectionPersistedCandidate.unity`
- Editor probe: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\Editor\Battle73RouteHudRightRailAuditEditor.cs`
- Analysis script: `C:\Users\godho\Downloads\girlswar\_restore_tools\scripts\battle73_route_hud_right_rail_audit.py`
- `restoredClaim=false`
- `playableClaim=false`
- `patchApplied=false`
- `sceneSaved=false`
- `canonicalSceneOverwritten=false`
- `candidateSceneUsed=true`
- `runtimeInstrumentationUsed=false`
- `hudRoutePatched=false`
- `cardPayloadPatched=false`
- `actorPayloadPatched=false`
- `mapReprojectionCandidateState=validated_persisted_battle72`
- HUD nodes reviewed: `353`
- Right rail nodes reviewed: `293`
- Sibling/order rows reviewed: `353`
- Source-backed static route/HUD patch candidates: `0`
- Runtime snapshot required rows: `269`
- Handler/xLua required rows: `94`
- Forbidden guess rows: `1`
- Minimal runtime snapshot fields: `5334`
- Next blocker: `ORIGINAL_RUNTIME_SNAPSHOT_OR_XLUA_GAMEENTRY_MODULESINIT_HANDLER_STATE_REQUIRED_FOR_HUD_RIGHT_RAIL_PATCH`

Control interpretation:

- BATTLE73 confirms that, after B72, route/HUD/right rail active state, on/off children, skip/pause/speed/fast-skill state, sibling order, and route-owned values cannot be patched statically from the candidate scene or reference video.
- The candidate scene can be audited, but original `UI_NormalBattle.lua` / `ModulesInit.ProcedureNormalBattle` runtime state is still required before any real HUD/right rail patch.
- BATTLE73 had `tmpRowsReviewed=0` and `maskStencilRowsReviewed=0`; this was not accepted as sufficient because TMP/mask/stencil were explicit user requirements.

## BATTLE74 Result

- Report: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_74_TMP_MASK_STENCIL_AUTOSIZE_GAP_CLOSURE_AFTER_B73_NO_PATCH_RESULT.md`
- JSON: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_74_TMP_MASK_STENCIL_AUTOSIZE_GAP_CLOSURE_AFTER_B73_NO_PATCH_RESULT.json`
- Script: `C:\Users\godho\Downloads\girlswar\_restore_tools\scripts\battle74_tmp_mask_stencil_autosize_gap_closure.py`
- `restoredClaim=false`
- `playableClaim=false`
- `patchApplied=false`
- `sceneSaved=false`
- `canonicalSceneOverwritten=false`
- `candidateSceneUsed=true`
- `runtimeInstrumentationUsed=false`
- `hudRoutePatched=false`
- `tmpMaskPatched=false`
- `cardPayloadPatched=false`
- `actorPayloadPatched=false`
- `battle73ResultUsed=true`
- B54 TMP rows reviewed: `65`
- B54 mask/stencil rows reviewed: `16`
- B73 candidate rows reviewed: `353`
- TMP rows mapped to B73 candidate: `33`
- Mask rows mapped to B73 candidate: `5`
- Candidate loaded TMP components: `0`
- Candidate loaded Mask/RectMask2D components: `0`
- Missing script/component rows: `81`
- Runtime snapshot required rows: `81`
- Handler/xLua-owned rows: `34`
- Component rehydration required rows: `81`
- Source-backed static TMP/mask patch candidates: `0`
- Forbidden guess rows: `1`
- TMP/mask runtime snapshot fields: `2204`
- Next blocker: `TMP_MASK_STENCIL_COMPONENT_REHYDRATION_AND_ORIGINAL_RUNTIME_SNAPSHOT_REQUIRED_NO_STATIC_PATCH`

Control interpretation:

- BATTLE74 closes the BATTLE73 TMP/mask zero-count gap.
- B54 serialized TMP/TextMeshProUGUI and mask evidence exists, but B73/B72 candidate scene observation does not load valid TMP/Mask/RectMask2D components for those rows.
- The result is not permission to patch TMP/mask/stencil statically. It proves a component rehydration plus original runtime snapshot blocker.
- TMP scale/autosize, font/material refs, alpha/raycast, mask enabled/showMaskGraphic/rectMask/stencil behavior, parent active chain, and sibling index need approved original runtime snapshot or equivalent original runtime evidence.

## Current Battle State

- BATTLE72 map framing candidate remains validated and persisted:
  - B68 baseline gutter: `200/27`
  - B71 memory candidate gutter: `0/0`
  - B72 persisted candidate gutter: `0/0`
- BATTLE73/BATTLE74 found no safe static patch candidates for route/HUD/right rail/TMP/mask after B72.
- The next battle blocker is no longer map framing. It is runtime ownership and component rehydration:
  - `ORIGINAL_RUNTIME_SNAPSHOT_OR_XLUA_GAMEENTRY_MODULESINIT_HANDLER_STATE_REQUIRED_FOR_HUD_RIGHT_RAIL_PATCH`
  - `TMP_MASK_STENCIL_COMPONENT_REHYDRATION_AND_ORIGINAL_RUNTIME_SNAPSHOT_REQUIRED_NO_STATIC_PATCH`

## Other Tracks

- MainInterface remains gated by UI148 runtime snapshot approval packet:
  - `requiredRuntimeFieldsCount=197`
  - `staticKnownFieldsCount=8`
  - `staticallyInferableNewFieldsCount=0`
  - `approvalRequiredForRuntimeDump=true`
- Character track remains gated after CHARACTER66:
  - unresolved ids `1100112`, `1100113`, `1100121`, `1100122`, `1100123`, `1100131`, `1100132`, `1100133`
  - `sourceBackedAliasesFound=0`
  - exact `1036` battle actor bundle still missing

## Guardrail Status

- No full restored/playable claim.
- No canonical scene overwrite.
- No package import.
- No manifest/package-lock edit.
- No APK/emulator runtime instrumentation.
- No xLua or handler patch.
- No HUD/right rail/TMP/mask/card/actor payload patch.
- No fake HUD/card/icon/text/spine/actor/effect.
- No screenshot/atlas paste.
- No coordinate-only success claim.
- Command policy verified: root `.cmd=1`, `_restore_tools` direct `.cmd=0`, policy ok.

## Safe Next Direction

- Do not patch route/HUD/right rail/TMP/mask from reference video or candidate scene coordinates.
- The next useful battle step is an approved original runtime snapshot/dump acquisition plan for `UI_NormalBattle` route/HUD/right rail/TMP/mask fields, or source-backed recovery of xLua/GameEntry/ModulesInit runtime handler state.
- UI and character tracks still require new runtime/source evidence before a safe static patch path exists.
