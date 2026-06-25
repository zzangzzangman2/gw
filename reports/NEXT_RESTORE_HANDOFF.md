# GirlsWar Next Restore Handoff

Generated: 2026-06-25 22:41 KST

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
- `MAININTERFACE_118_BIND_ROUTE_SKELETONGRAPHIC_UI_MATERIAL_SHADER_PASS_FROM_ORIGINAL_FIELDS`

Verdict:
- MainInterface is still not a normal/restored UI.
- UI118 bound route `SkeletonGraphic` targets to the evidence-backed UI `SkeletonGraphic` material/shader pass.
- The capture still shows the same large white route diamond/panel around the route cluster, so shader/pass binding alone did not fix the visible defect.
- No coordinate, scale, RectTransform, sibling order, whole-atlas, crop, fake icon, or debug/path text fix was applied.

Useful evidence:
- Report: `reports\maininterface\MAININTERFACE_118_BIND_ROUTE_SKELETONGRAPHIC_UI_MATERIAL_SHADER_PASS_FROM_ORIGINAL_FIELDS_RESULT.md`
- Tool: `_restore_tools\cmd_archive\118_BIND_ROUTE_SKELETONGRAPHIC_UI_MATERIAL_SHADER_PASS_FROM_ORIGINAL_FIELDS.cmd`
- Scene: `girlswar_maininterface_unity\Assets\Scenes\MainInterface_RouteSpineRuntimeReplay_UIMaterialBound.unity`
- Capture: `girlswar_maininterface_unity\Assets\RestoreCaptures\maininterface_route_spine_runtime_ui_material_bound_1680x720.png`
- JSON: `girlswar_maininterface_unity\Assets\RestoreData\maininterface_118_route_skeletongraphic_ui_material_shader_pass_binding.json`
- CSV: `girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_118_route_skeletongraphic_ui_material_shader_pass_binding.csv`

Key numbers:
- targets bound: `2 / 2`
- original refs present: `2 / 2`
- additive/multiply/screen material refs bound: `2 / 2 / 2`
- SkeletonGraphic default material evidence: `True`
- visible/magenta/whiteish pixels: `1201680 / 223 / 160880`
- click validation: `2026-06-25 22:37:21`, `24 / 24 / 0 / 24`

Next UI blocker:
- `MAININTERFACE_119_VALIDATE_ROUTE_SKELETONGRAPHIC_MESH_BOUNDS_CANVASRENDERER_SUBMESH_MATERIAL`
- Reason: the route `SkeletonGraphic` UI material is now evidence-bound, but the large white route diamond/panel remains. Next pass should validate mesh bounds, CanvasRenderer material/submesh state, stencil/mask interaction, and original runtime fields.

## Latest Battle State

Latest task:
- `BATTLE_38_MATCH_ACTOR_SCALE_CAMERA_TIMING_AND_BATTLE_SCENE_CONTEXT_TO_CLIP05`

Verdict:
- Original clip05 actor motion/layout/timing is still not reproduced.
- BATTLE38 used `C:\Users\godho\Downloads\플레이.mp4` 485.0-487.0s sequence and found the current runtime actor probe remains actor-only.
- Actor motion exists, but the scene has no original battle map/HUD/context attached, so it must not be called a restored battle screen.

Useful evidence:
- Report: `reports\battle\BATTLE_38_MATCH_ACTOR_SCALE_CAMERA_TIMING_AND_BATTLE_SCENE_CONTEXT_TO_CLIP05_RESULT.md`
- Tool: `_restore_tools\cmd_archive\BATTLE_38_MATCH_ACTOR_SCALE_CAMERA_TIMING_AND_BATTLE_SCENE_CONTEXT_TO_CLIP05.cmd`
- Scene: `girlswar_battle_unity\Assets\Scenes\Battle38MatchActorScaleCameraTimingAndBattleSceneContextToClip05.unity`
- Capture: `girlswar_battle_unity\Assets\RestoreCaptures\battle_actor\Battle38MatchActorScaleCameraTimingAndBattleSceneContextToClip05_1920x1080.png`
- Runtime sequence: `girlswar_battle_unity\Assets\RestoreCaptures\battle_actor\battle38_sequence\`
- Contact sheet: `reports\battle\BATTLE_38_MATCH_ACTOR_SCALE_CAMERA_TIMING_AND_BATTLE_SCENE_CONTEXT_TO_CLIP05_CONTACT_SHEET.jpg`
- Video sequence sheet: `reports\battle\BATTLE_38_PLAY_VIDEO_CLIP05_485_487_SEQUENCE.jpg`
- JSON: `reports\battle\BATTLE_38_MATCH_ACTOR_SCALE_CAMERA_TIMING_AND_BATTLE_SCENE_CONTEXT_TO_CLIP05_RESULT.json`
- Unity data: `girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_38_MATCH_ACTOR_SCALE_CAMERA_TIMING_AND_BATTLE_SCENE_CONTEXT_TO_CLIP05.json`
- Actor bounds CSV: `girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_38_MATCH_ACTOR_SCALE_CAMERA_TIMING_AND_BATTLE_SCENE_CONTEXT_TO_CLIP05_ACTOR_BOUNDS.csv`
- Comparison CSV: `girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_38_MATCH_ACTOR_SCALE_CAMERA_TIMING_AND_BATTLE_SCENE_CONTEXT_TO_CLIP05_COMPARISON.csv`

Key numbers:
- visual status: `failed_battle_scene_context_map_hud_missing`
- reference video used: `True`, 485.0-487.0s, frames `6`
- reference/runtime actor boxes: `181 / 16`
- actor center gap norm: `0.020345`
- runtime/reference actor area ratio: `0.227836`
- runtime map/HUD: `False / False`
- BATTLE29 context map layers/cards: `10 / 3`
- mesh hash changed actors: `3 / 3`
- AnimationState SetAnimation success: `3 / 3`
- magenta pixel ratio: `0.000387`

Next battle blocker:
- `BATTLE_39_ATTACH_RUNTIME_ACTORS_TO_MAP11003_HUD_CONTEXT_WITH_EVIDENCE`
- Reason: BATTLE29 has evidence for `map_11003` map/HUD/card context and BATTLE38 has runtime actor sequence evidence, but they are still separate. Next pass must join them through original scene/prefab/Lua evidence, not coordinate-only placement.

## Existing Threads

- UI thread: `019efdb6-503d-7373-be2b-6dcd1a247b1a`
- Battle thread: `019efdb6-9db2-7e52-bbef-c959eb4d619e`

Use them separately:
- UI thread handles MainInterface visual/font/layout/material restoration.
- Battle thread handles battle actor/HUD/video-motion restoration.
- Main thread handles command layout, handoff docs, commit, and push.

## Suggested Next Work

1. UI: run UI119 to inspect route `SkeletonGraphic` mesh bounds, CanvasRenderer submesh material, mask/stencil state, and runtime field evidence for the remaining white diamond/panel.
2. Battle: run BATTLE39 to attach runtime actors to the evidence-backed `map_11003` battle context with HUD/card layout, then compare the sequence against `플레이.mp4` clip05.
3. Keep using graphics captures and contact sheets. Do not call a capture restored unless the visual evidence actually matches.
