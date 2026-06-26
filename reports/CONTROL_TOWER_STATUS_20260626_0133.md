# CONTROL_TOWER_STATUS_20260626_0133

- Workspace: `C:\Users\godho\Downloads\girlswar`
- Control tower time: `2026-06-26 01:33 KST`
- Overall restored claim: `false`
- Main reference image: `C:\Users\godho\.codex\attachments\e607fc34-b674-4516-b051-8d396cd6df06\image-1.png`
- Auxiliary video: `C:\Users\godho\Downloads\참고.mp4`
- Missing reference video: `C:\Users\godho\Downloads\플레이.mp4`

## Threads

- UI worker: `019eff6c-a02a-7f73-9ffb-74456322d1ce`
- Battle worker: `019eff6c-edb7-7ca1-b7b9-fff5378a6ff6`
- Character/data worker: `019eff6d-307b-7532-8b1d-7105b18cd6b7`

## Results Recovered

### Character/data

- Completed: `CHARACTER_LOCAL_PLAYABLE_BATTLE_PAYLOAD_MANIFEST`
- Outputs:
  - `reports\battle\BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST.md`
  - `reports\battle\BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST.json`
  - `reports\battle\BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST.csv`
  - `_restore_tools\scripts\build_battle_local_playable_payload_manifest.py`
- Key facts:
  - Classification: `local_playable_subset_only_not_full_payload`
  - Actors loadable: `3 / 12`
  - Loadable actors: our `1002`, our `1034`, enemy `1100111 -> prefab 3001`
  - `1036` remains `not_fetchable_local`
  - Enemy ids `1100112/1100113/1100121/1100122/1100123/1100131/1100132/1100133` remain unresolved
  - Skill timeline rows resolved: `39 / 61`
  - Resource-complete loadable skill rows: `4`
  - Missing common speedline bundles remain unresolved
- Control-tower action: manifest path and limits forwarded to battle worker. It is only for debug/interaction/runtime validation, not a full restore claim.

### MainInterface/UI

- Completed/recovered: `MAININTERFACE_125_NORMAL_HOME_STATE_AND_LAYER_RECONSTRUCTION` trace outputs
- Outputs:
  - `reports\maininterface\MAININTERFACE_125_ANIMATOR_HOME_STATE_TRACE.md`
  - `reports\maininterface\MAININTERFACE_125_unitypy_generic_bindings.csv`
  - `reports\maininterface\MAININTERFACE_125_prefab_node_candidates.csv`
  - `reports\maininterface\MAININTERFACE_125_button_handler_candidates.csv`
  - `girlswar_maininterface_unity\Assets\Editor\MainInterface125NormalHomeAnimatorTrace.cs`
  - `_restore_tools\cmd_archive\125_TRACE_MAININTERFACE_NORMAL_HOME_ANIMATOR_STATE.cmd`
- Key facts:
  - `UI_MainInterface` controller/clips are in `maininterface_ext_4.assetbundle`
  - Lua `UI_MainPage.OnOpen` plays `UI_MainInterface_in`, then `UI_MainInterface_idle`; hide/show plays out/in
  - UnityPy generic binding path hashes resolved to `bg_dibu`, `left`, `mask`, `mask/btn_jiantou1`, `mask/btn_jiantou2`, and `right`
  - Specific `node_middle`, `wanfaWorldNode`, `worldwanfaBtn`, and `UI_Main_wanfa_item` route hide/move evidence is still not present
  - No evidence-backed hide/sibling/canvas patch was applied
- Current blocker: reference screen likely requires identifying the actual UI open-stack/prefab/layer composition, not arbitrary hiding of route/world nodes.
- Control-tower action: dispatched `MAININTERFACE_126_REFERENCE_SCREEN_OPEN_STACK_AND_PREFAB_ID_TRACE`.

### Battle

- Completed/recovered: `BATTLE_46_TRACE_GRAPHICRAYCASTER_EVENT_CAMERA_SCREENSPACE_AND_BLOCKERS`
- Outputs:
  - `reports\battle\BATTLE_46_TRACE_GRAPHICRAYCASTER_EVENT_CAMERA_SCREENSPACE_AND_BLOCKERS_RESULT.md`
  - `reports\battle\BATTLE_46_TRACE_GRAPHICRAYCASTER_EVENT_CAMERA_SCREENSPACE_AND_BLOCKERS_RESULT.json`
  - `girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_46_TRACE_GRAPHICRAYCASTER_EVENT_CAMERA_SCREENSPACE_AND_BLOCKERS_COMPONENTS.csv`
  - `reports\battle\BATTLE_46_TRACE_GRAPHICRAYCASTER_EVENT_CAMERA_SCREENSPACE_AND_BLOCKERS_CONTACT_SHEET.jpg`
  - `girlswar_battle_unity\Assets\Editor\Battle46GraphicRaycasterEventCameraScreenSpaceEditor.cs`
  - `_restore_tools\scripts\battle46_graphicraycaster_event_camera_screenspace_verify.py`
  - `_restore_tools\cmd_archive\BATTLE_46_TRACE_GRAPHICRAYCASTER_EVENT_CAMERA_SCREENSPACE_AND_BLOCKERS.cmd`
- Key facts:
  - Button probes / registry included / raycast-ready: `14 / 10 / 0`
  - `RectTransformUtility.RectangleContainsScreenPoint(eventCamera)`: `14 / 14`
  - `Graphic.Raycast(eventCamera)` passing samples: `10`
  - worldCamera disabled / target culling / CanvasGroup blocked: `0 / 0 / 0`
  - `GraphicRaycaster.Raycast` hit count remains `0`
  - All 14 button target graphics have `targetDepth = -1`
- Current blocker: Graphic targets can accept event-camera points, but Unity `GraphicRaycaster` filters depth `-1` graphics from candidates. The likely next area is Canvas/Graphic rebuild, CanvasRenderer absoluteDepth, registry/depth plumbing, display/blocking/sort internals.
- Control-tower action: dispatched `BATTLE_47_FIX_GRAPHIC_DEPTH_AND_RAYCAST_CANDIDATE_REGISTRATION`.

## Command Policy

- Root `.cmd` count: `1`
- Root command file: `00_COMMAND_CENTER.cmd`
- `_restore_tools` direct `.cmd` count: `0`
- New wrappers remain under `_restore_tools\cmd_archive`

## Active Follow-ups

- UI: `MAININTERFACE_126_REFERENCE_SCREEN_OPEN_STACK_AND_PREFAB_ID_TRACE`
  - Goal: identify whether the reference screen is pure `UI_MainInterface` or another source-backed UI overlay/prefab/open-stack composition.
  - No route/world arbitrary hide is allowed.
- Battle: `BATTLE_47_FIX_GRAPHIC_DEPTH_AND_RAYCAST_CANDIDATE_REGISTRATION`
  - Goal: make original HUD graphics become valid `GraphicRaycaster` candidates by resolving depth/rebuild/registration plumbing.
  - No fake button handlers, fake overlays, screenshot paste, or coordinate-only success.

## Current Non-Completion Reasons

- MainInterface still does not match the reference; route/world cluster issue is not solved by source evidence yet.
- Battle HUD is visible enough for deeper probing but not raycast-ready/playable.
- Full original battle payload still lacks `1036` actor bundle and unresolved enemy actor mappings.
- `플레이.mp4` remains missing; `참고.mp4` is auxiliary only.

