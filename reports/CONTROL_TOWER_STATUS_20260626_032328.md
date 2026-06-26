# CONTROL_TOWER_STATUS_20260626_032328

## Overall
- Project: `C:\Users\godho\Downloads\girlswar`
- Final main UI restored claim: `false`
- Final playable battle screen claim: `false`
- `참고.mp4`: available, auxiliary visual reference only.
- `플레이.mp4`: missing.
- Command policy: root `.cmd` count `1`, `_restore_tools` direct `.cmd` count `0`.

## Active Threads
- UI worker: `019eff6c-a02a-7f73-9ffb-74456322d1ce`
- Battle worker: `019eff6c-edb7-7ca1-b7b9-fff5378a6ff6`
- Character/data worker: `019eff6d-307b-7532-8b1d-7105b18cd6b7`

## MainInterface Completed Since Last Report
`MAININTERFACE_133_HOME_HEROSPINE_BG_BOTTOM_NAV_RUNTIME_LAYOUT_PROBE_NO_COORDINATE_PATCH`
- Result: `no_scene_patch`
- `restoredClaim=false`, `scenePatchApplied=false`, `candidatePatchApplied=false`
- Hero/BG:
  - BG1005 sprite binding is active.
  - Hero1005 has one live `SkeletonGraphic`.
  - `UI_touchSpine` active/raycast-enabled.
  - No hero transform patch because `UIUtil.GetPlayerBigSpineAll(..., "homePara")` semantics were not yet recovered at UI133 time.
- Bottom nav:
  - old-root candidate does not expose active new-root `node_bottom/toogles/btnToggle*` strip.
  - visible candidates are old-root shop/mail/friends/ranking and left banner/download entries.
- UI133 region diff with UI131-compatible metric:
  - full corr `0.424216`
  - center_hero_background corr `0.475187`
  - bottom_nav corr `0.395621`
- Outputs:
  - `reports\maininterface\MAININTERFACE_133_HOME_HEROSPINE_BG_BOTTOM_NAV_RUNTIME_LAYOUT_PROBE_NO_COORDINATE_PATCH_RESULT.md`
  - `reports\maininterface\MAININTERFACE_133_REFERENCE_DIFF_CONTACT.png`

## MainInterface Active Task
`MAININTERFACE_134_DECODE_UIUTIL_HOMEPARA_AND_OLDROOT_BOTTOM_NAV_RUNTIME_STATE_SOURCE_TRACE_NO_PATCH`
- Status: in progress.
- Current live finding from worker:
  - `download/xlualogic/common.assetbundle` contains the `UIUtil.txt` TextAsset.
  - The worker reused the local xLua security/XOR decode path and successfully recovered `UIUtil`.
  - Current decoded semantic finding: `homePara` values map as `[1]=scale`, `[2]=local x`, `[3]=local y`, `[4]=optional x scale flip`; applied to the spawned `Painting_<id>` child transform, not directly to `UI_heroSpine`.
- UI134 still needs to finish:
  - structured CSV/JSON/MD evidence,
  - DTmodelEntity pattern table,
  - old-root bottom nav runtime/Animator/open-stack trace,
  - patch matrix. No scene patch in UI134.

## Battle Completed Since Last Report
`BATTLE_57_REHYDRATE_SOURCE_BACKED_ASSETBUNDLE_ACTORS_IN_CANDIDATE_BUILDER_AND_CAPTURE_VALIDATE_NO_FAKE_MESH`
- Result: `source_backed_assetbundle_actor_runtime_rehydrate_pixels_validated_playable_false`
- Patch decision: `candidate_runtime_rehydrate_patch_no_fake_mesh`
- Scene saved: `true`
- Runtime rehydrate used: `true`
- Persistent project asset import used: `false`
- Fake mesh/handler: `false`
- Actor render result:
  - source-backed rehydrated actors `3/3`
  - bundle loaded / prefab instantiated `3/3`
  - mesh/material/frustum/pixel signal `3/3/3/3`
  - renderer mesh vertices `2630`
  - unsupported shader after rebind `0`
  - old hollow shell disabled `3`
- Visual contact sheet confirms actor-on capture has visible source-backed actor pixels and actor-off diff mask catches them.
- Playable remains `false` because xLua/GameEntry/ModulesInit handler binding and full payload gaps remain.
- Outputs:
  - `reports\battle\BATTLE_57_REHYDRATE_SOURCE_BACKED_ASSETBUNDLE_ACTORS_IN_CANDIDATE_BUILDER_AND_CAPTURE_VALIDATE_NO_FAKE_MESH_RESULT.md`
  - `reports\battle\BATTLE_57_REHYDRATE_SOURCE_BACKED_ASSETBUNDLE_ACTORS_IN_CANDIDATE_BUILDER_AND_CAPTURE_VALIDATE_NO_FAKE_MESH_CONTACT_SHEET.jpg`

## Battle Active Task
`BATTLE_58_TRACE_XLUA_GAMEENTRY_MODULESINIT_HANDLER_BINDING_WITH_BATTLE57_ACTORS_NO_FAKE_HANDLER`
- Status: in progress.
- Goal:
  - audit latest Battle51/Battle57 HUD/card/button onClick/listener state,
  - trace `GameEntry`, `ModulesInit`, battle UI lifecycle, and source handler targets,
  - decide whether any source-backed handler binding is safe.
- Guardrail: no fake onClick/gameplay handler, dummy Lua, stub GameEntry, external xLua/package import/download, or actor-render-only playable claim.

## Character/Data Manifest
- Local battle payload remains subset-only:
  - actors loadable `3/12`: our `1002`, our `1034`, enemy `1100111 -> 3001`
  - `1036`: `not_fetchable_local`
  - eight additional enemy actor IDs unresolved locally
  - skill/timeline rows are still partial and cannot support full playable claim.

## Next Control Tower Checks
- Read UI134 outputs under `reports\maininterface\MAININTERFACE_134*` when generated.
- Read BATTLE58 outputs under `reports\battle\BATTLE_58*` when generated.
- If UI134 fully proves `homePara` semantics and produces a safe patch matrix, delegate a separate UI135 candidate patch/capture task.
- If BATTLE58 identifies source-backed handler binding, delegate a separate Battle59 candidate patch/click-validation task; otherwise keep blocker as GameEntry/ModulesInit/runtime source requirement.
