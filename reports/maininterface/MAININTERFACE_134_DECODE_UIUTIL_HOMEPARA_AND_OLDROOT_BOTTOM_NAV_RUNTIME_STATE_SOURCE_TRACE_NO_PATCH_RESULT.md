# MAININTERFACE 134 Decode UIUtil HomePara And OldRoot Bottom Nav Runtime State Source Trace Result

Generated: 2026-06-26T03:27:48

## Verdict

- restoredClaim: false
- scenePatchApplied: false
- candidatePatchApplied: false
- patchDecision: no_scene_patch_source_trace_only

## UIUtil/HomePara

- Decoded UIUtil source: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_134_UIUtil_security_xor_raw.lua`
- `UIUtil.GetPlayerBigSpineAll` line: `2472`
- `homePara[1]`: scale
- `homePara[2]`: spawned `Painting_<id>` local x
- `homePara[3]`: spawned `Painting_<id>` local y
- optional `homePara[4]`: horizontal flip flag; when present x scale becomes negative
- Target transform: spawned `Painting_<id>` child under the pooled `paintingGroup`, not `UI_heroSpine` itself.
- For hero1005, `[1,0,0]` means scale `1`, x `0`, y `0`, no flip. This is now source-backed, but UI134 still applies no patch by request.

## DTmodelEntity Pattern

- Parsed rows: `244`
- Sample rows written: `78`
- Non-default homePara rows: `73`
- Top homePara patterns: `[["[1.0,0.0,0.0]", 171], ["[0.0]", 47], ["[1.0,50.0,0.0]", 26]]`

## Bottom Nav/Open Stack

- `UI_MainInterface` has source prefab/binding evidence for `node_bottom/toogles/btnToggle*` and `UI_MainPage` registers `btnToggle1..7` click handlers.
- Current UI133 old-root candidate does not expose that new-root bottom strip; it shows old-root shop/mail/friends/ranking/left banner/download candidates instead.
- `UI_Dock` is a stronger open-stack candidate for the actual bottom dock: it maps `DOCK_TYPE.MAIN_PAGE..MAIN_CITY`, defaults to `MAIN_PAGE`, and plays `UI_Dock_in/out` on show/hide.
- UI134 therefore does not import/activate `node_bottom` into old-root and does not patch coordinates. Next safe step is a separate UI_Dock open-stack candidate capture.

## Patch Matrix

| item | classification | patchPlanOnly | whyNoPatchInUI134 |
| --- | --- | --- | --- |
| Hero1005 homePara transform | source_backed_static_patch_possible_next_task | Apply homePara to the SkeletonGraphic/Painting child transform, not UI_heroSpine parent; for 1005 [1,0,0] means scale 1, local x 0, local y 0, no flip. | Task explicitly requested source trace no patch; visual/click validation should be separate. |
| Hero1005 back/front layers | needs_unity_runtime_probe | Probe whether adding back/front SkeletonGraphics improves reference without overpainting; no whole atlas image. | Layer ordering and material/canvas interaction still needs a candidate capture task. |
| Old-root bottom navigation strip | blocked_no_patch_needs_open_stack_candidate | Build a no-fake UI_Dock open-stack candidate alongside old-root UI_MainInterface and validate against reference bottom strip. | No source-backed proof that old-root UI_MainInterface alone should import/activate new-root node_bottom, and no UI_Dock candidate capture yet. |
| btn_discord/UI_bg/activity slots | source_backed_static_patch_not_allowed_by_guardrail | None. | Out of UI134 target and explicitly forbidden. |

## Outputs

- JSON: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_134_DECODE_UIUTIL_HOMEPARA_AND_OLDROOT_BOTTOM_NAV_RUNTIME_STATE_SOURCE_TRACE_NO_PATCH_RESULT.json`
- UIUtil/homePara trace CSV: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_134_uiutil_homepara_source_trace.csv`
- DTmodel homePara pattern CSV: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_134_dtmodel_homepara_pattern.csv`
- Bottom nav evidence CSV: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_134_bottom_nav_source_animator_runtime_state_evidence.csv`
- Patch matrix CSV: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_134_source_backed_patch_matrix_NO_SCENE_PATCH.csv`
- Decoded UIUtil Lua: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_134_UIUtil_security_xor_raw.lua`

## Command Policy

- root `.cmd` count: 1
- `_restore_tools` direct `.cmd` count: 0
- policyOk: true

## Next Blocker

- Build a separate UI_Dock open-stack candidate with source prefab/lua evidence and capture/diff/click validation.
- Apply the now-decoded homePara semantics only in a dedicated candidate patch/capture task; do not combine with bottom nav changes.
- Activity/account snapshot remains required before activity slot/text/icon/spine visibility changes.
