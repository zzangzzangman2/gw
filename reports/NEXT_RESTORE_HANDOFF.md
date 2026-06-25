# GirlsWar Next Restore Handoff

Generated: 2026-06-25 22:30 KST

## Pull At Home

```powershell
cd C:\Users\godho\Downloads\girlswar
git pull origin main
```

Start from:
- `00_COMMAND_CENTER.cmd`
- latest handoff: `reports\NEXT_RESTORE_HANDOFF.md`
- running status: `reports\WORK_SPLIT_STATUS_20260625_1708.md`

## Rule Source

- Expected original rule file: `C:\Users\godho\Downloads\apk_extracted_ui_restore_rules.txt`
- Current status: still not found.
- Use this fallback as authoritative until the original file is restored:
  - `reports\RESTORE_RULES_APPLIED_CURRENT.md`

Hard rules still active:
- No coordinate-only UI placement.
- No whole-atlas placement, crop guessing, fake icon, fake HUD, debug/path/evidence text in final captures.
- Preserve original hierarchy, RectTransform, anchors, pivot, localScale, sibling order, Canvas, and CanvasScaler unless exact evidence is documented.
- Validate button click/raycast with JSON/logs.
- Compare battle against `C:\Users\godho\Downloads\플레이.mp4`, especially clip05 485.0-487.0s, as motion sequence evidence.
- Do not delete or move original/evidence files such as XAPK, OBB, extracted bundles, decoded Lua, IL2CPP dumps, or raw TextAssets until usage coverage is documented.

## Current Command Layout

- Root CMD count should remain `1`.
- Only root launcher:
  - `00_COMMAND_CENTER.cmd`
- `_restore_tools` direct `.cmd` count should remain `0`.
- Current wrappers:
  - `_restore_tools\current\01_RUN_LATEST_MAININTERFACE_UI_VALIDATION.cmd`
  - `_restore_tools\current\02_RUN_LATEST_BATTLE_VALIDATION.cmd`
- Archive tools:
  - `_restore_tools\cmd_archive\`

## Latest UI State

Latest task:
- `MAININTERFACE_117_VALIDATE_AND_FIX_ROUTE_SKELETONGRAPHIC_LAYOUT_AGAINST_ORIGINAL_EVIDENCE`

Verdict:
- MainInterface is still not a normal/restored UI.
- UI117 only cleaned up evidence-backed duplicate interim bitmap fallback layers in a separate replay candidate scene.
- The validated capture still shows a large white route diamond/panel around the route cluster.

Useful evidence:
- Report: `reports\maininterface\MAININTERFACE_117_VALIDATE_AND_FIX_ROUTE_SKELETONGRAPHIC_LAYOUT_AGAINST_ORIGINAL_EVIDENCE_RESULT.md`
- Tool: `_restore_tools\cmd_archive\117_VALIDATE_AND_FIX_ROUTE_SKELETONGRAPHIC_LAYOUT_AGAINST_ORIGINAL_EVIDENCE.cmd`
- Scene: `girlswar_maininterface_unity\Assets\Scenes\MainInterface_RouteSpineRuntimeReplay_Validated.unity`
- Capture: `girlswar_maininterface_unity\Assets\RestoreCaptures\maininterface_route_spine_runtime_bridge_validated_1680x720.png`
- JSON: `girlswar_maininterface_unity\Assets\RestoreData\maininterface_117_route_skeletongraphic_layout_validation.json`
- CSV: `girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_117_route_skeletongraphic_layout_validation.csv`

Key numbers:
- `spine_diqiu`, `spine_xiaoren`: RectTransform/sibling/animation evidence matched `2/2`
- route TMP label variant: `6/6`
- interim bitmap fallback suppressed: `3`
- click validation: `2026-06-25 22:25:37`, `24 / 24 / 0 / 24`

Next UI blocker:
- `MAININTERFACE_118_BIND_ROUTE_SKELETONGRAPHIC_UI_MATERIAL_SHADER_PASS_FROM_ORIGINAL_FIELDS`
- Reason: route `SkeletonGraphic` currently uses `Spine/Skeleton` material/shader, and the remaining white diamond/panel suggests the original UI `SkeletonGraphic` material/shader pass binding is still wrong.

## Latest Battle State

Latest task:
- `BATTLE_37_BIND_ORIGINAL_SPINE_SHADER_VARIANTS_AND_MATERIAL_PASSES`

Verdict:
- Original clip05 actor motion is still not reproduced.
- BATTLE37 greatly reduced the magenta shader problem, but actor scale/camera/timing/battle context does not match the video yet.

Useful evidence:
- Report: `reports\battle\BATTLE_37_BIND_ORIGINAL_SPINE_SHADER_VARIANTS_AND_MATERIAL_PASSES_RESULT.md`
- Tool: `_restore_tools\cmd_archive\BATTLE_37_BIND_ORIGINAL_SPINE_SHADER_VARIANTS_AND_MATERIAL_PASSES.cmd`
- Scene: `girlswar_battle_unity\Assets\Scenes\Battle37BindOriginalSpineShaderVariantsAndMaterialPasses.unity`
- Capture: `girlswar_battle_unity\Assets\RestoreCaptures\battle_actor\Battle37BindOriginalSpineShaderVariantsAndMaterialPasses_1920x1080.png`
- Contact sheet: `reports\battle\BATTLE_37_BIND_ORIGINAL_SPINE_SHADER_VARIANTS_AND_MATERIAL_PASSES_CONTACT_SHEET.jpg`
- JSON: `reports\battle\BATTLE_37_BIND_ORIGINAL_SPINE_SHADER_VARIANTS_AND_MATERIAL_PASSES_RESULT.json`
- Unity data: `girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_37_BIND_ORIGINAL_SPINE_SHADER_VARIANTS_AND_MATERIAL_PASSES.json`
- Material CSV: `girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_37_BIND_ORIGINAL_SPINE_SHADER_VARIANTS_AND_MATERIAL_PASSES_MATERIALS.csv`

Key numbers:
- unsupported shader/material before: `5`
- unsupported shader/material after: `0`
- same-name supported project shader rebinds: `5`
- magenta ratio: `0.071884 -> 0.000387`
- mesh hash changed actors: `3 / 3`

Next battle blocker:
- `BATTLE_38_MATCH_ACTOR_SCALE_CAMERA_TIMING_AND_BATTLE_SCENE_CONTEXT_TO_CLIP05`
- Reason: shader/pass binding improved rendering, but the full video motion/layout/timing still does not match `플레이.mp4` clip05.

## Existing Threads

- UI thread: `019efdb6-503d-7373-be2b-6dcd1a247b1a`
- Battle thread: `019efdb6-9db2-7e52-bbef-c959eb4d619e`

Use them separately:
- UI thread handles MainInterface visual/font/layout/material restoration.
- Battle thread handles battle actor/HUD/video-motion restoration.
- Main thread handles command layout, handoff docs, commit, and push.

## Suggested Next Work

1. UI: run UI118 to trace original `SkeletonGraphic` UI material/shader pass fields and bind the correct UI shader/material evidence.
2. Battle: run BATTLE38 to match actor scale, camera, timing, and scene context to `플레이.mp4` clip05.
3. Keep using graphics captures and contact sheets. Do not call a capture restored unless the visual evidence actually matches.
