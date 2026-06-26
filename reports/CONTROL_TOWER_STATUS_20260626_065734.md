# CONTROL_TOWER_STATUS_20260626_065734

## Scope

- Continued control-tower management after `CONTROL_TOWER_STATUS_20260626_065020`.
- Verified BATTLE72 persisted candidate outputs after BATTLE71 memory-only map reprojection validation.
- No restored/playable claim is made.

## BATTLE72 Result

- Report: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_72_PERSIST_VALIDATED_MAP_11003_TRUE_ASPECT_REPROJECTION_IN_CANDIDATE_BUILDER_AND_RERUN_VALIDATION_NO_CANONICAL_OVERWRITE_RESULT.md`
- JSON: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_72_PERSIST_VALIDATED_MAP_11003_TRUE_ASPECT_REPROJECTION_IN_CANDIDATE_BUILDER_AND_RERUN_VALIDATION_NO_CANONICAL_OVERWRITE_RESULT.json`
- Candidate scene: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\Scenes\Battle72Map11003TrueAspectReprojectionPersistedCandidate.unity`
- Candidate scene meta: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\Scenes\Battle72Map11003TrueAspectReprojectionPersistedCandidate.unity.meta`
- Candidate capture: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreCaptures\battle_actor\Battle72PersistedMap11003TrueAspectReprojectionCandidate_1920x855.png`
- Contact sheet: `C:\Users\godho\Downloads\girlswar\work\battle72_persisted_map_reprojection\BATTLE_72_PERSIST_VALIDATED_MAP_11003_TRUE_ASPECT_REPROJECTION_IN_CANDIDATE_BUILDER_AND_RERUN_VALIDATION_NO_CANONICAL_OVERWRITE_baseline_b71_b72_reference_contact_sheet.jpg`
- Editor script: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\Editor\Battle72PersistMap11003TrueAspectReprojectionEditor.cs`
- Analysis script: `C:\Users\godho\Downloads\girlswar\_restore_tools\scripts\battle72_persist_map_reprojection_validate.py`
- Cmd archive: `C:\Users\godho\Downloads\girlswar\_restore_tools\cmd_archive\BATTLE_72_PERSIST_VALIDATED_MAP_11003_TRUE_ASPECT_REPROJECTION_IN_CANDIDATE_BUILDER_AND_RERUN_VALIDATION_NO_CANONICAL_OVERWRITE.cmd`

Verified JSON fields:

- `restoredClaim=false`
- `playableClaim=false`
- `canonicalSceneOverwritten=false`
- `candidateSceneSaved=true`
- `sceneSaved=true` for the BATTLE72 candidate scene only
- `packageImported=false`
- `manifestModified=false`
- `runtimeInstrumentationUsed=false`
- `hudRoutePatched=false`
- `cardPayloadPatched=false`
- `actorPayloadPatched=false`
- `candidateBuilderPatched=true`
- `mapLayersPersistedCount=9`
- `mapLayerFormulaSourceBacked=true`
- Baseline B68 gutter: left `200px`, right `27px`, total `0.118229`
- B71 memory candidate gutter: left `0px`, right `0px`, total `0.0`
- B72 persisted candidate gutter: left `0px`, right `0px`, total `0.0`
- Reference sample gutter: left `4px`, right `4px`, total `0.00625`
- `persistedCandidateMatchesBattle71=true`
- `newMajorVisualRegressionDetected=false`
- `candidateDecision=persisted_map_reprojection_candidate_validated`
- Next blocker: `ROUTE_HUD_RUNTIME_STATE_AND_PAYLOAD_TIMELINE_XLUA_BLOCKERS_REMAIN_AFTER_PERSISTED_MAP_REPROJECTION`

Control interpretation:

- BATTLE72 successfully turns the BATTLE71 memory-only `Map_11003_*` true-aspect reprojection into a reproducible candidate scene artifact.
- The validated candidate removes the large black side gutters from the B68 true-aspect baseline and reproduces the B71 `0/0` gutter result from a saved candidate scene.
- This is still only a map framing/gutter correction candidate. Visual review confirms remaining in-frame black layer holes and major gameplay/HUD/card/actor mismatches relative to the reference.
- The BATTLE72 candidate scene is allowed as a candidate artifact; it is not a canonical scene overwrite and not a production-restored screen.

## BATTLE71 Baseline For BATTLE72

- BATTLE71 report: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_71_CANDIDATE_ONLY_MAP_11003_TRUE_ASPECT_REPROJECTION_AND_CAPTURE_VALIDATE_NO_CANONICAL_SCENE_OVERWRITE_RESULT.md`
- BATTLE71 candidate capture: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreCaptures\battle_actor\Battle71Map11003TrueAspectReprojectionCandidate_1920x855.png`
- BATTLE71 decision: `map_reprojection_candidate_validated_for_next_review`
- BATTLE71 scene save state: `candidateSceneSaved=false`, `sceneSaved=false`
- BATTLE72 persistence state: `candidateSceneSaved=true`, `sceneSaved=true`, `canonicalSceneOverwritten=false`

## Current Open Blockers

- Route/HUD/right rail active and handler state remains blocked by original runtime/xLua evidence. BATTLE70 classified `121` route/HUD rows as runtime/handler-required.
- Bottom five-card assembly remains blocked by missing/unfinished payload and layout validation.
- Exact `1036` battle actor bundle remains missing.
- Enemy ids `1100112`, `1100113`, `1100121`, `1100122`, `1100123`, `1100131`, `1100132`, `1100133` remain unresolved after CHARACTER66.
- Timeline package/type/binding and original xLua/GameEntry/LuaManager handler recovery remain separate playability blockers.
- MainInterface remains gated by UI148 runtime snapshot approval packet: `requiredRuntimeFieldsCount=197`, `staticKnownFieldsCount=8`, `staticallyInferableNewFieldsCount=0`.

## Guardrail Status

- No full restored/playable claim.
- No canonical scene overwrite.
- No package import.
- No manifest/package-lock edit.
- No APK/emulator runtime instrumentation.
- No xLua or handler patch.
- No HUD/right rail/card/actor payload patch.
- No fake HUD/card/icon/text/spine/actor/effect.
- No screenshot/atlas paste.
- No coordinate-only success claim.
- Command policy verified: root `.cmd=1`, `_restore_tools` direct `.cmd=0`, policy ok.

## Safe Next Direction

- Treat BATTLE72 as the current validated map-framing candidate.
- Do not proceed to HUD/right rail coordinate or active-state patch without runtime/handler evidence.
- Next useful battle task should be a no-patch runtime/handler blocker audit for route/HUD state requirements, or an explicitly approved runtime snapshot/dump acquisition plan.
- UI and character tracks currently have no safe static patch path without new runtime/source evidence.
