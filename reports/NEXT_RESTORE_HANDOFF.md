# GirlsWar Next Restore Handoff

Generated: 2026-06-25 23:03 KST

## Pull At Home

```powershell
cd C:\Users\godho\Downloads\girlswar
git pull origin main
```

Start from:
- `00_COMMAND_CENTER.cmd`
- stable handoff: `reports\NEXT_RESTORE_HANDOFF.md`
- home resume note: `reports\HOME_RESUME_AFTER_UI119_BATTLE39_20260625_2303.md`
- running status log: `reports\WORK_SPLIT_STATUS_20260625_1708.md`

## Rule Source

- Expected original rule file: `C:\Users\godho\Downloads\apk_extracted_ui_restore_rules.txt`
- Current status: still not found.
- Authoritative fallback until the original file is restored:
  - `reports\RESTORE_RULES_APPLIED_CURRENT.md`

Hard rules still active:
- Do not call a screen restored unless the actual capture matches the reference visually.
- No coordinate-only UI placement.
- No whole-atlas placement, crop guessing, fake icon, fake HUD, debug text, path text, or evidence labels in final captures.
- Preserve original hierarchy, RectTransform, anchors, pivot, localScale, sibling order, Canvas, CanvasScaler, and runtime binding unless exact evidence supports a change.
- Validate button click/raycast with JSON/logs.
- Compare battle against `C:\Users\godho\Downloads\플레이.mp4`, especially clip05 485.0-487.0s, as motion sequence evidence.
- Do not delete or move original/evidence files such as XAPK, OBB, extracted bundles, decoded Lua, IL2CPP dumps, or raw TextAssets until usage coverage is documented.

## Current Command Layout

- Root CMD count must stay `1`.
- Only root launcher:
  - `00_COMMAND_CENTER.cmd`
- `_restore_tools` direct `.cmd` count must stay `0`.
- Current wrappers:
  - `_restore_tools\current\01_RUN_LATEST_MAININTERFACE_UI_VALIDATION.cmd`
  - `_restore_tools\current\02_RUN_LATEST_BATTLE_VALIDATION.cmd`
- Archive tools:
  - `_restore_tools\cmd_archive\`

Latest validation targets:
- MainInterface: `_restore_tools\cmd_archive\119_VALIDATE_ROUTE_SKELETONGRAPHIC_MESH_BOUNDS_CANVASRENDERER_SUBMESH_MATERIAL.cmd`
- Battle: `_restore_tools\cmd_archive\BATTLE_39_ATTACH_RUNTIME_ACTORS_TO_MAP11003_HUD_CONTEXT_WITH_EVIDENCE.cmd`

## Latest UI State

Latest task:
- `MAININTERFACE_119_VALIDATE_ROUTE_SKELETONGRAPHIC_MESH_BOUNDS_CANVASRENDERER_SUBMESH_MATERIAL`

Verdict:
- MainInterface is still not a normal/restored UI.
- UI119 was trace-only. It did not hide, scale, or move the white route diamond/panel.
- The large white route shape is narrowed to original `Spine_shijieanniu` drawOrder attachment candidates, especially `zhuye_di1`, plus `zhuye_bian` and `diqiu`.
- Removing those attachments without original runtime mask/stencil/attachment-visibility evidence would violate the restore rules.

Useful evidence:
- Report: `reports\maininterface\MAININTERFACE_119_VALIDATE_ROUTE_SKELETONGRAPHIC_MESH_BOUNDS_CANVASRENDERER_SUBMESH_MATERIAL_RESULT.md`
- Tool: `_restore_tools\cmd_archive\119_VALIDATE_ROUTE_SKELETONGRAPHIC_MESH_BOUNDS_CANVASRENDERER_SUBMESH_MATERIAL.cmd`
- JSON: `girlswar_maininterface_unity\Assets\RestoreData\maininterface_119_route_skeletongraphic_mesh_bounds_canvasrenderer_submesh_material.json`
- CSV: `girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_119_route_skeletongraphic_mesh_bounds_canvasrenderer_submesh_material.csv`
- Reference capture reviewed: `girlswar_maininterface_unity\Assets\RestoreCaptures\maininterface_route_spine_runtime_ui_material_bound_1680x720.png`

Key numbers:
- visual fixes applied: `0`
- targets considered/traced: `2 / 2`
- drawOrder attachment rows: `46`
- high-white atlas regions: `0`
- large route shape candidates: `3`
- `Spine_shijieanniu` mesh: `63` vertices, bounds `0,0,0 / 253,253,0`, CanvasRenderer materials `1`, texture empty
- `8007` mesh: `737` vertices, bounds `-14.039,79.9131,0 / 144.8493,162.6354,0`, CanvasRenderer materials `1`, texture empty
- mask state for both: `maskable=True;Mask=False;RectMask2D=False`
- click validation: `2026-06-25 22:55:08`, `24 / 24 / 0 / 24`

Next UI blocker:
- `MAININTERFACE_120_TRACE_ROUTE_SKELETONGRAPHIC_ORIGINAL_RUNTIME_MASK_STENCIL_ATTACHMENT_VISIBILITY`
- Target evidence: original runtime mask, stencil, CanvasRenderer texture handoff, and attachment visibility state for `zhuye_di1` and the world route frame.

## Latest Battle State

Latest task:
- `BATTLE_39_ATTACH_RUNTIME_ACTORS_TO_MAP11003_HUD_CONTEXT_WITH_EVIDENCE`

Verdict:
- Original clip05 actor motion/layout/timing + map/HUD context is still not reproduced.
- BATTLE39 attached runtime actors to the BATTLE29 `map_11003` scene context, but the final capture does not show the clip05/BATTLE29 HUD/card regions correctly.
- The report separates scene object existence from camera-visible HUD. Scene has map/HUD/card objects, but camera-visible HUD/cards is false.
- Actor placement is still a candidate, not original runtime verified.

Useful evidence:
- Report: `reports\battle\BATTLE_39_ATTACH_RUNTIME_ACTORS_TO_MAP11003_HUD_CONTEXT_WITH_EVIDENCE_RESULT.md`
- JSON: `reports\battle\BATTLE_39_ATTACH_RUNTIME_ACTORS_TO_MAP11003_HUD_CONTEXT_WITH_EVIDENCE_RESULT.json`
- Tool: `_restore_tools\cmd_archive\BATTLE_39_ATTACH_RUNTIME_ACTORS_TO_MAP11003_HUD_CONTEXT_WITH_EVIDENCE.cmd`
- Scene: `girlswar_battle_unity\Assets\Scenes\Battle39RuntimeActorsMap11003HudContextCandidate.unity`
- Capture: `girlswar_battle_unity\Assets\RestoreCaptures\battle_actor\Battle39RuntimeActorsMap11003HudContext_1920x1080.png`
- Runtime sequence: `girlswar_battle_unity\Assets\RestoreCaptures\battle_actor\battle39_sequence\`
- Contact sheet: `reports\battle\BATTLE_39_ATTACH_RUNTIME_ACTORS_TO_MAP11003_HUD_CONTEXT_WITH_EVIDENCE_CONTACT_SHEET.jpg`
- Video sequence sheet: `reports\battle\BATTLE_39_PLAY_VIDEO_CLIP05_485_487_SEQUENCE.jpg`
- Unity data: `girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_39_ATTACH_RUNTIME_ACTORS_TO_MAP11003_HUD_CONTEXT_WITH_EVIDENCE.json`
- Actor bounds CSV: `girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_39_ATTACH_RUNTIME_ACTORS_TO_MAP11003_HUD_CONTEXT_WITH_EVIDENCE_ACTOR_BOUNDS.csv`
- Comparison CSV: `girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_39_ATTACH_RUNTIME_ACTORS_TO_MAP11003_HUD_CONTEXT_WITH_EVIDENCE_COMPARISON.csv`

Key numbers:
- visual status: `failed_hud_context_not_camera_visible_in_candidate_capture`
- reference video used: `True`, 485.0-487.0s, frames `6`
- map/HUD/cards object present: `True / True / True`
- camera-visible HUD/cards: `False`
- reference/runtime actor boxes: `181 / 18`
- actor center gap norm: `0.499238`
- runtime/reference actor area ratio: `0.042839`
- mesh hash changed actors: `3 / 3`
- AnimationState SetAnimation success: `3 / 3`
- magenta pixel ratio: `0.025204`

Next battle blocker:
- `BATTLE_40_FIX_BATTLE_HUD_CAMERA_RENDER_BINDING_IN_RUNTIME_CONTEXT`
- Target evidence: why BATTLE29 HUD/card objects exist in the scene but do not render as the clip05/BATTLE29 top HP, bottom cards, and right controls in the final camera capture.

## Existing Threads

- UI thread: `019efdb6-503d-7373-be2b-6dcd1a247b1a`
- Battle thread: `019efdb6-9db2-7e52-bbef-c959eb4d619e`

Use them separately:
- UI thread handles MainInterface visual/font/layout/material/runtime restoration.
- Battle thread handles battle actor/HUD/video-motion restoration.
- Main thread handles command layout, handoff docs, commit, and push.

## Suggested Next Work

1. UI: run `MAININTERFACE_120_TRACE_ROUTE_SKELETONGRAPHIC_ORIGINAL_RUNTIME_MASK_STENCIL_ATTACHMENT_VISIBILITY`.
2. Battle: run `BATTLE_40_FIX_BATTLE_HUD_CAMERA_RENDER_BINDING_IN_RUNTIME_CONTEXT`.
3. Keep checking actual captures/contact sheets. Component counts and object presence are not enough.
4. Keep root command layout clean: root only `00_COMMAND_CENTER.cmd`, `_restore_tools` direct CMD count `0`.
