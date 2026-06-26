# Control Tower Status 2026-06-26 01:24 KST

Final restored/playable claim: `false`.

## MainInterface

- UI124 completed and mounted Hero1005 through real Spine `SkeletonGraphic`.
- UI124 remains mismatch against reference because normal-home state/layering is wrong:
  - route/world cluster remains active.
  - `rightSiblingIndex=3` > `UI_heroSpine=1`, so route draws above hero.
  - full reference correlation remains low: `0.188564`.
- UI125 is active:
  - task: `MAININTERFACE_125_NORMAL_HOME_STATE_AND_LAYER_RECONSTRUCTION`
  - focus: preserve Hero1005, reconstruct normal-home active state/layering from prefab/Lua/datatable/runtime evidence.
  - current visible output: `reports\maininterface\MAININTERFACE_125_prefab_node_candidates.csv`
- Still forbidden:
  - arbitrary route hide
  - fake PNG/screenshot paste
  - coordinate-only success
  - hiding `zhuye_di1/zhuye_bian` without stronger original evidence

## Battle

- BATTLE45 completed and moved the blocker forward.
- BATTLE45 result:
  - `Empty4Raycast` persistence fixed by dedicated `Assets/Scripts/Empty4Raycast.cs`.
  - Empty4Raycast before/after/reopen: `0 / 7 / 7`.
  - missing scripts before/reopen: `1208 / 1208`.
  - target Graphics are included in GraphicRegistry after reopen: `10`.
  - raycast-ready Button remains `0 / 0`.
  - reason remains `no_graphic_hits_at_target_center`.
- BATTLE45 report:
  - `reports\battle\BATTLE_45_TRACE_CANVAS_GRAPHIC_REGISTRY_CAMERA_AND_EMPTY4RAYCAST_RUNTIME_ENABLE_RESULT.md`
- BATTLE46 dispatched:
  - task: `BATTLE_46_TRACE_GRAPHICRAYCASTER_EVENT_CAMERA_SCREENSPACE_AND_BLOCKERS`
  - focus: screen-space/camera/canvas/raycast blocker mismatch, not visual art.
- `플레이.mp4` is still missing. `참고.mp4` remains auxiliary only.

## Character/Data

- 1036 CDN acquisition trace completed:
  - `reports\characters\CHARACTER_1036_CDN_ACQUISITION_TRACE.md`
  - classification: `not_fetchable_from_local_evidence`
  - exact local actor bundle path missing: `download/roleprefabsandres/battleprefabandres/1036.assetbundle`
  - candidate asset CDN URLs: `0`
  - login/account URLs: `2`
  - HEAD/GET/download executed: `false`
- Character worker dispatched to produce local playable payload manifest:
  - task: `CHARACTER_LOCAL_PLAYABLE_BATTLE_PAYLOAD_MANIFEST`
  - focus: distinguish full original payload gaps from fake-free locally loadable subset for interaction/runtime validation.
  - full restore still requires 1036 actor bundle and unresolved enemy actor mapping.

## Reference Video

- `참고.mp4` analysis package remains:
  - `C:\Users\godho\Documents\Codex\2026-06-25\c-users-godho-downloads-girlswar-2\outputs\reference_video_analysis\REFERENCE_VIDEO_RESTORE_ANALYSIS.md`
- Battle HUD reference frames: `20.0s`, `29.0s`, `50.1s`, `58.4s`.
- Skill/cut-in reference window: `62.6s-84.0s`.

## Command Policy

- Root CMD count last verified: `1`
- `_restore_tools` direct CMD count last verified: `0`
- New CMD wrappers must remain under `_restore_tools\cmd_archive`.

## Next Watch Points

1. UI125: normal-home state/layer evidence and capture/diff result.
2. BATTLE46: whether GraphicRaycaster miss is eventCamera/canvas/screen coordinate/blocker issue.
3. Character local playable manifest: battle-ready loadable subset vs full-payload gap list.
