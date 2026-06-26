# CONTROL_TOWER_STATUS_20260626_0148

- Workspace: `C:\Users\godho\Downloads\girlswar`
- Control tower time: `2026-06-26 01:48 KST`
- Overall restored claim: `false`
- Main reference image: `C:\Users\godho\.codex\attachments\e607fc34-b674-4516-b051-8d396cd6df06\image-1.png`
- Auxiliary video: `C:\Users\godho\Downloads\참고.mp4`
- Missing reference video: `C:\Users\godho\Downloads\플레이.mp4`

## Current Worker Threads

- UI worker: `019eff6c-a02a-7f73-9ffb-74456322d1ce`
- Battle worker: `019eff6c-edb7-7ca1-b7b9-fff5378a6ff6`
- Character/data worker: `019eff6d-307b-7532-8b1d-7105b18cd6b7`

## MainInterface/UI

### Recovered Results

- Completed/recovered: `MAININTERFACE_126_REFERENCE_SCREEN_OPEN_STACK_AND_PREFAB_ID_TRACE`
- Key files:
  - `reports\maininterface\MAININTERFACE_126_REFERENCE_SCREEN_OPEN_STACK_AND_PREFAB_ID_TRACE_RESULT.md`
  - `reports\maininterface\MAININTERFACE_126_OLDROOT_CANDIDATE_CAPTURE.md`
  - `reports\maininterface\MAININTERFACE_126_REFERENCE_DIFF_CONTACT.png`
  - `reports\maininterface\MAININTERFACE_126_reference_element_candidates.csv`
  - `reports\maininterface\MAININTERFACE_126_prefab_root_candidates.csv`
  - `reports\maininterface\MAININTERFACE_126_reference_diff_regions.csv`
  - `reports\maininterface\MAININTERFACE_126_lua_open_stack_candidates.csv`
  - `girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_126_oldroot_click_validation_summary.json`
  - `girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_126_oldroot_click_validation.csv`

### UI126 Facts

- `UI_MainInterface_old` and `UI_MainInterface` both have `UI_MainPage.bytes` and `UI_MainInterface` Animator controller.
- Old-root candidate removes the new-root `right/node_middle/wanfaWorldNode/worldwanfaBtn` route cluster and exposes reference-like right social/chat buttons, right activity stack, left task/story/banner nodes, profile/currency clusters, and bottom navigation.
- Full pixel correlation improved from UI124 new-root `0.188564` to old-root candidate `0.394`.
- Candidate still fails as restored screen:
  - background is black because old-root `UI_bg` is inactive/unresolved
  - activity/runtime icons/text remain placeholder-like
  - one click blocker remains
- Old-root click validation: `55 total / 44 active / 44 interactable / 43 clickable / 1 blocked`.
- Blocked row: `btn_discord__-4707263110286473242` is topped by `right/node_act_btn/btn_act_12/btn_act`.
- UI124 real Hero1005 `SkeletonGraphic` mount is preserved; no whole `Painting_1005.png` image was used.

### UI Follow-up

- Dispatched: `MAININTERFACE_127_OLDROOT_BACKGROUND_RUNTIME_RESOURCE_AND_LAYER_STATE_RECONSTRUCTION`
- Focus:
  - trace old-root black background: `UI_bg`, `bg`, `bg_dibu`, `PaintingBG_1005`, `zhuye_di1/zhuye_bian`, Lua `GetPaintingBg` / `LoadSpriteWithFullPath`
  - trace placeholder activity/runtime icon source: `node_act_btn`, `UI_MainPageActItem`, `UI_MainPageFaceActItem`, `DTMainInlet`, `DTMainInterface`, `MainPageLimitMgr`
  - trace/fix old-root candidate layer blocker for `btn_discord` only with source-backed evidence
- Still forbidden: arbitrary hide of `zhuye_di1/zhuye_bian`, `right/node_middle/wanfaWorldNode/worldwanfaBtn`, fake HUD/icons, screenshot paste, coordinate-only fixes.

## Battle

### Recovered Results

- Completed/recovered: `BATTLE_48_TRACE_SORT_ORDER_DISPLAY_AND_HIT_OCCLUSION_AFTER_DEPTH_REBUILD`
- Key files:
  - `reports\battle\BATTLE_48_TRACE_SORT_ORDER_DISPLAY_AND_HIT_OCCLUSION_AFTER_DEPTH_REBUILD_RESULT.md`
  - `reports\battle\BATTLE_48_TRACE_SORT_ORDER_DISPLAY_AND_HIT_OCCLUSION_AFTER_DEPTH_REBUILD_RESULT.json`
  - `girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_48_TRACE_SORT_ORDER_DISPLAY_AND_HIT_OCCLUSION_AFTER_DEPTH_REBUILD_TARGET_POINTS.csv`
  - `girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_48_TRACE_SORT_ORDER_DISPLAY_AND_HIT_OCCLUSION_AFTER_DEPTH_REBUILD_REGISTERED_GRAPHICS.csv`
  - `reports\battle\BATTLE_48_TRACE_SORT_ORDER_DISPLAY_AND_HIT_OCCLUSION_AFTER_DEPTH_REBUILD_CONTACT_SHEET.jpg`

### BATTLE48 Facts

- Final playable claim remains `false`.
- Status: `raycast_ready_candidate_found_after_sort_display_trace`.
- Reopen raycast-ready / Unity-hit-positive / mirror-target-candidate: `15 / 15 / 15`.
- Ready point kinds: `eventCamera_worldToScreen`, `b47_before_open_baseline`, `viewport_pixelRect`.
- Ready original targets include:
  - `btnAuto` at `578/349`
  - `btnBuff` at `578/439`
  - `btnTwoSpeed` at `578/169`
  - `btnFastSkill` at `578/79`
  - `btn_box` at `2.75/4.15`
- Some failures remain from pixelRect reject / depth -1 targets, but at least one source-backed targetGraphic hit path exists now.

### Battle Follow-up

- Dispatched: `BATTLE_49_VALIDATE_REAL_CLICK_INPUT_AND_HANDLER_BINDING`
- Focus:
  - validate `EventSystem.RaycastAll`, `ExecuteEvents`, Button state, and handler binding for the 5 ready buttons
  - connect with BATTLE44 original button MonoScript/targetGraphic evidence
  - distinguish input plumbing success from missing Lua/IL2CPP handler blockers
  - only after real input/handler path is clear, use `BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST` local subset for runtime validation

## Character/Data

- Latest character/data result remains `BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST`.
- Classification: `local_playable_subset_only_not_full_payload`.
- Loadable actors: our `1002`, our `1034`, enemy `1100111 -> prefab 3001`.
- Full original payload still needs `1036` actor bundle and unresolved enemy mappings.

## Command Policy

- Root `.cmd` count: `1`
- Root command file: `00_COMMAND_CENTER.cmd`
- `_restore_tools` direct `.cmd` count: `0`
- New wrappers remain under `_restore_tools\cmd_archive`

## Current Non-Completion Reasons

- MainInterface old-root candidate is structurally closer but still lacks correct background/runtime resources and has a layer blocker.
- Battle now has source-backed raycast-ready candidates, but real EventSystem click and handler binding are not validated yet.
- Full battle payload remains incomplete due missing `1036` bundle and unresolved enemy mappings.
- `플레이.mp4` remains missing; `참고.mp4` remains auxiliary only.

