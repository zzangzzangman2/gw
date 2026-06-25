# GirlsWar Next Restore Handoff

Generated: 2026-06-25 23:25 KST

## Pull At Home

```powershell
cd C:\Users\godho\Downloads\girlswar
git pull origin main
```

Start from:
- `00_COMMAND_CENTER.cmd`
- home checkpoint note: `reports\HOME_RESUME_AFTER_UI121_BATTLE40_20260625_2325.md`
- running status log: `reports\WORK_SPLIT_STATUS_20260625_1708.md`

## Home Test Commands

Recommended:
- Run `00_COMMAND_CENTER.cmd`
- Press `B` for the home checkpoint test.

Direct wrappers:
- `_restore_tools\current\00_RUN_HOME_CHECKPOINT_TESTS.cmd`
- `_restore_tools\current\01_RUN_LATEST_MAININTERFACE_UI_VALIDATION.cmd`
- `_restore_tools\current\02_RUN_LATEST_BATTLE_VALIDATION.cmd`

Checkpoint targets:
- UI: `_restore_tools\cmd_archive\121_VERIFY_ROUTE_SKELETONGRAPHIC_CANVASRENDERER_TEXTURE_HANDOFF_AND_CLIPPING_TRIANGULATION_ZONG1.cmd`
- Battle: `_restore_tools\cmd_archive\BATTLE_40_FIX_BATTLE_HUD_CAMERA_RENDER_BINDING_IN_RUNTIME_CONTEXT.cmd`

Experimental next battle tool, not default:
- `_restore_tools\cmd_archive\BATTLE_41_TRACE_BATTLE_HUD_RUNTIME_SPRITE_TEXTURE_PERSISTENCE_AND_CAPTURE_PIPELINE.cmd`
- It was created as the next blocker probe but was not run before this checkpoint.

## Rule Source

- Expected original rule file: `C:\Users\godho\Downloads\apk_extracted_ui_restore_rules.txt`
- Current status: still not found.
- Authoritative fallback until the original file is restored:
  - `reports\RESTORE_RULES_APPLIED_CURRENT.md`

Hard rules still active:
- Do not call a screen restored unless the actual capture/contact sheet matches the reference visually.
- No coordinate-only UI placement.
- No whole-atlas placement, crop guessing, fake icon, fake HUD, debug text, path text, or evidence labels in final captures.
- Preserve original hierarchy, RectTransform, anchors, pivot, localScale, sibling order, Canvas, CanvasScaler, and runtime binding unless exact evidence supports a change.
- Validate button click/raycast with JSON/logs.
- Compare battle against `C:\Users\godho\Downloads\플레이.mp4`, especially clip05 485.0-487.0s.
- Do not delete or move original/evidence files such as XAPK, OBB, extracted bundles, decoded Lua, IL2CPP dumps, or raw TextAssets until usage coverage is documented.

## Current Command Layout

- Root CMD count must stay `1`.
- Only root launcher:
  - `00_COMMAND_CENTER.cmd`
- `_restore_tools` direct `.cmd` count must stay `0`.
- Current wrappers:
  - `_restore_tools\current\00_RUN_HOME_CHECKPOINT_TESTS.cmd`
  - `_restore_tools\current\01_RUN_LATEST_MAININTERFACE_UI_VALIDATION.cmd`
  - `_restore_tools\current\02_RUN_LATEST_BATTLE_VALIDATION.cmd`
- Archive tools:
  - `_restore_tools\cmd_archive\`

## Latest UI State

Latest completed task:
- `MAININTERFACE_121_VERIFY_ROUTE_SKELETONGRAPHIC_CANVASRENDERER_TEXTURE_HANDOFF_AND_CLIPPING_TRIANGULATION_ZONG1`

Verdict:
- MainInterface is still not a normal/restored UI.
- UI121 was trace-only and applied no visual fix.
- `zhuye_di1` and `zhuye_bian` are confirmed pre-clipping drawOrder attachments and should not be hidden by `zong1`.
- `zong1` clipping affects later attachments such as `diqiu`, `yun`, and `yun2`.
- Texture handoff is present through `SkeletonGraphic.mainTexture`, private `baseTexture`, atlas primary material, and attachment renderer objects. `CanvasRenderer.GetTexture` may remain empty by API/reflection path.

Useful evidence:
- Report: `reports\maininterface\MAININTERFACE_121_VERIFY_ROUTE_SKELETONGRAPHIC_CANVASRENDERER_TEXTURE_HANDOFF_AND_CLIPPING_TRIANGULATION_ZONG1_RESULT.md`
- Tool: `_restore_tools\cmd_archive\121_VERIFY_ROUTE_SKELETONGRAPHIC_CANVASRENDERER_TEXTURE_HANDOFF_AND_CLIPPING_TRIANGULATION_ZONG1.cmd`
- JSON: `girlswar_maininterface_unity\Assets\RestoreData\maininterface_121_route_skeletongraphic_canvasrenderer_texture_handoff_clipping_zong1.json`
- CSV: `girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_121_route_skeletongraphic_canvasrenderer_texture_handoff_clipping_zong1.csv`
- Reviewed capture: `girlswar_maininterface_unity\Assets\RestoreCaptures\maininterface_route_spine_runtime_ui_material_bound_1680x720.png`

Key numbers:
- visual fixes applied: `0`
- targets considered/traced: `1 / 1`
- clip rows / clipped rows: `9 / 6`
- pre-clip zhuye rows: `2`
- UV region rows: `5`
- texture present / expected-missing rows: `11 / 3`
- click validation: `2026-06-25 23:22:51`, `24 / 24 / 0 / 24`

Next UI blocker:
- `route frame visual mismatch likely original art/style expectation or SkeletonGraphic material property block texture path capture review, not evidence-backed zhuye hide`

## Latest Battle State

Latest completed task:
- `BATTLE_40_FIX_BATTLE_HUD_CAMERA_RENDER_BINDING_IN_RUNTIME_CONTEXT`

Verdict:
- Original clip05 actor motion/layout/timing + map/HUD context is still not reproduced.
- BATTLE40 confirmed the HUD Canvas is already `ScreenSpaceCamera` and world-camera bound.
- The reopened runtime context has resolved active Graphic rows `0` and Image rows `0`, so final capture has no HUD/card render substance.
- This means the next blocker is runtime UI component/sprite/texture persistence, not just camera binding.

Useful evidence:
- Report: `reports\battle\BATTLE_40_FIX_BATTLE_HUD_CAMERA_RENDER_BINDING_IN_RUNTIME_CONTEXT_RESULT.md`
- JSON: `reports\battle\BATTLE_40_FIX_BATTLE_HUD_CAMERA_RENDER_BINDING_IN_RUNTIME_CONTEXT_RESULT.json`
- Tool: `_restore_tools\cmd_archive\BATTLE_40_FIX_BATTLE_HUD_CAMERA_RENDER_BINDING_IN_RUNTIME_CONTEXT.cmd`
- Scene: `girlswar_battle_unity\Assets\Scenes\Battle40HudCameraRenderBindingRuntimeContext.unity`
- Capture: `girlswar_battle_unity\Assets\RestoreCaptures\battle_actor\Battle40HudCameraRenderBindingRuntimeContext_1920x1080.png`
- Contact sheet: `reports\battle\BATTLE_40_FIX_BATTLE_HUD_CAMERA_RENDER_BINDING_IN_RUNTIME_CONTEXT_CONTACT_SHEET.jpg`
- Video sequence sheet: `reports\battle\BATTLE_40_PLAY_VIDEO_CLIP05_485_487_SEQUENCE.jpg`

Key numbers:
- visual status: `failed_hud_graphic_components_missing_after_scene_reload`
- reference video used: `True`, 485.0-487.0s
- camera-visible HUD/cards: `False`
- resolved active Graphic rows: `0`
- resolved Image rows: `0`
- after ScreenSpaceCamera canvas rows: `18`
- reference/runtime actor boxes: `181 / 0`

Next battle blocker:
- `BATTLE_41_TRACE_BATTLE_HUD_RUNTIME_SPRITE_TEXTURE_PERSISTENCE_AND_CAPTURE_PIPELINE`
- BATTLE41 files exist but the tool was not run before this checkpoint; keep it experimental unless you want to test the next probe.

## Existing Threads

- UI thread: `019efdb6-503d-7373-be2b-6dcd1a247b1a`
- Battle thread: `019efdb6-9db2-7e52-bbef-c959eb4d619e`

Use them separately:
- UI thread handles MainInterface visual/font/layout/material/runtime restoration.
- Battle thread handles battle actor/HUD/video-motion restoration.
- Main thread handles command layout, handoff docs, commit, and push.

## Suggested Next Work

1. Pull and run the home checkpoint test from `00_COMMAND_CENTER.cmd` option `B`.
2. Review the UI121 and BATTLE40 reports/captures.
3. If continuing, run BATTLE41 only as an experimental next probe, then make BATTLE42 persistent HUD reconstruction only from original prefab/PPtr/sprite evidence.
4. For UI, do not hide `zhuye_di1`/`zhuye_bian`; they are pre-clipping original attachments.
