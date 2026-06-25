# Battle HUD Sprite Region Font Join + Video Motion Validation Result

## Outputs
- Join candidates JSON: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_HUD_SPRITE_REGION_FONT_JOIN_CANDIDATES.json`
- Unity result JSON: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_HUD_SPRITE_REGION_FONT_JOIN_RESULT.json`
- Components CSV: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_HUD_SPRITE_REGION_FONT_JOIN_COMPONENTS.csv`
- Scene: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\Scenes\BattleRuntimeFlowWithHudSpriteFontJoin.unity`
- Capture: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreCaptures\battle_hud\BattleRuntimeFlowWithHudSpriteFontJoin_1680x720.png`
- Capture visual status: `debug_overlay_suppressed_hud_not_camera_visible_yet`
- Capture visual reason: Existing flow evidence roots are hidden for capture; HUD prefab references are joined, but Canvas render mode/camera/sorting/runtime binding still need BATTLE_20+ validation before the original HUD is visible in a still capture.
- Video validation JSON: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreCaptures\battle_hud\video_motion_validation\BATTLE_19_VIDEO_MOTION_VALIDATION.json`
- Unity batchmode success: `True`

## Counts
- Applied/resolved sprite slices: `223`
- Resolved Text/TMP fonts: `0`
- Resolved text/font materials: `68`
- Unresolved sprite/image refs: `188`
- Component candidates / explicit sprite refs / explicit font-material refs: `566` / `343` / `74`
- Button / raycast-ready / handler-linked: `26` / `25` / `0`
- Click validation: `component_raycast_ready_25_of_26_handler_linked_0`

## Root Results
| role | prefab | sprites | unresolved sprites | text | tmp | fonts | buttons | raycast | handlers | active |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| battle_root_hud | `assets/download/ui/uiprefabandres/battle_ext_prefabs/prefabs/ui_normalbattle.prefab` | 176 | 149 | 1 | 58 | 0 | 19 | 18 | 0 | True |
| battle_3d_overlay_hud | `assets/download/ui/uiprefabandres/battle_ext_prefabs/prefabs/ui_battle3dui.prefab` | 0 | 1 | 0 | 0 | 0 | 1 | 1 | 0 | True |
| actor_heroitem_template | `assets/download/ui/uiprefabandres/battle_ext_prefabs/prefabs/ui_normalbattle_heroitem.prefab` | 17 | 5 | 0 | 1 | 0 | 0 | 0 | 0 | False |
| buff_icon_left_template | `assets/download/ui/uiprefabandres/battle_ext_prefabs/prefabs/item_buff_left.prefab` | 9 | 6 | 0 | 0 | 0 | 0 | 0 | 0 | False |
| buff_icon_right_template | `assets/download/ui/uiprefabandres/battle_ext_prefabs/prefabs/item_buff_right.prefab` | 9 | 6 | 0 | 0 | 0 | 0 | 0 | 0 | False |
| pause_panel_entry | `assets/download/ui/uiprefabandres/battle_ext_prefabs/prefabs/ui_normalbattle_pause.prefab` | 5 | 1 | 0 | 3 | 0 | 2 | 2 | 0 | False |
| skip_panel_entry | `assets/download/ui/uiprefabandres/battle_ext_prefabs/prefabs/ui_normalbattle_skipview.prefab` | 0 | 2 | 0 | 0 | 0 | 1 | 1 | 0 | False |
| test_battle_ui_entry | `assets/download/ui/uiprefabandres/battle_ext_prefabs/prefabs/ui_testbattle.prefab` | 7 | 16 | 5 | 0 | 0 | 3 | 3 | 0 | False |
| winlose_entry_victory_spine_base | `assets/download/ui/uiprefabandres/winlose_ext_prefabs/victory_spine_base.prefab` | 0 | 2 | 0 | 0 | 0 | 0 | 0 | 0 | False |
| winlose_entry_victory_spine_base2 | `assets/download/ui/uiprefabandres/winlose_ext_prefabs/victory_spine_base2.prefab` | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | False |

## Evidence Rules
- Whole atlases were not placed as UI Images.
- Sprite/font/material readiness is counted from resolved original AssetBundle references after loading candidate dependency bundles.
- RectTransform hierarchy, anchors, pivots, local scale, and sibling order are preserved from source prefabs.
- Missing refs remain unresolved/log-only; no fake icons, fake panels, or fake click handlers were added.

## Video Motion Validation
- Source video: `C:\Users\godho\Downloads\플레이.mp4`
- Motion report: `C:\Users\godho\Downloads\girlswar\reports\video_reference\PLAY_REFERENCE_VIDEO_MOTION_ANALYSIS.md`
- Restore notes: `C:\Users\godho\Downloads\girlswar\reports\video_reference\PLAY_REFERENCE_RESTORE_NOTES.md`
- Top-center circular overlay is excluded as recording/touch artifact.
| clip | validation | current status | mismatch class |
| --- | --- | --- | --- |
| `C:\Users\godho\Downloads\girlswar\reports\video_reference\clips\battle_motion_clip_01_0088s.mp4` | projectile_hit_floating_damage | pending_motion_reconstruction | floating_damage_timing_and_effect_motion_not_reconstructed_yet |
| `C:\Users\godho\Downloads\girlswar\reports\video_reference\clips\battle_motion_clip_02_0146s.mp4` | bright_cut_in_flash_with_hud_camera_behavior | pending_motion_reconstruction | cutin_flash_sorting_and_camera_timing_not_reconstructed_yet |
| `C:\Users\godho\Downloads\girlswar\reports\video_reference\clips\battle_motion_clip_03_0380s.mp4` | red_black_special_skill_stage_cutin | pending_motion_reconstruction | special_skill_stage_overlay_not_reconstructed_yet |
| `C:\Users\godho\Downloads\girlswar\reports\video_reference\clips\battle_motion_clip_05_0486s.mp4` | normal_battle_hud_persistence_top_bottom_right | partially_ready_after_sprite_font_join | canvas_sorting_camera_and_runtime_data_binding_still_pending |
| `C:\Users\godho\Downloads\girlswar\reports\video_reference\clips\battle_motion_clip_06_0500s.mp4` | full_width_beam_flash_hit | pending_motion_reconstruction | beam_flash_effect_motion_not_reconstructed_yet |

## Remaining Mismatch Classification
- Normal HUD persistence is partially ready at static component/sprite/font level, but Canvas sorting/camera/runtime binding still needs motion-scene validation.
- Still capture suppresses prior evidence/debug overlays; HUD visual is not camera-visible yet because Canvas/camera/sorting/runtime binding is still unresolved.
- Floating damage/heal, hit flash, beam, and cut-in timing are motion reconstruction tasks and cannot be validated from a single still capture.
- Button handlers are not linked yet; current validation is component/raycast-only.

## BATTLE_20 Recommendation
- `BATTLE_20_BATTLE_UI_BUTTON_HANDLER_LUA_IL2CPP_TRACE`
