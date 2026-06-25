# Battle Flow With HUD Attach Result

## Outputs
- Attach manifest: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_FLOW_WITH_HUD_ATTACH_MANIFEST.json`
- Attach result JSON: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_FLOW_WITH_HUD_ATTACH_RESULT.json`
- Scene: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\Scenes\BattleRuntimeFlowWithHudPrototype.unity`
- Capture: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreCaptures\battle_hud\BattleRuntimeFlowWithHudPrototype_1680x720.png`
- Unity batchmode success: `True`

## Counts
- Attached HUD roots: `10`
- Canvas / RectTransform / Image / Text+TMP / Button: `12` / `814` / `0` / `0` / `0`
- Missing script/component count: `889`
- Sprite/material/font dependency unresolved count: `889`
- Capture exists: `True`
- Capture visual assessment: `capture_exists_but_not_original_hud_like_due_unresolved_ui_widget_components_and_sprite_region_dependencies`
- Click validation: `deferred:no_resolved_Button_component`

## Attached Roots
| order | role | mode | prefab | active original/scene | gameObjects | rect | canvas | image | text/tmp | button | missing scripts | root RectTransform evidence |
| ---: | --- | --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| 1 | battle_root_hud | active_evidence_root | `assets/download/ui/uiprefabandres/battle_ext_prefabs/prefabs/ui_normalbattle.prefab` | True/True | 556 | 540 | 2 | 0 | 0 | 0 | 601 | anchor `0,0`-`0,0`, pivot `0.5,0.5`, pos `320,240`, size `640,480` |
| 2 | battle_3d_overlay_hud | active_evidence_root | `assets/download/ui/uiprefabandres/battle_ext_prefabs/prefabs/ui_battle3dui.prefab` | True/True | 27 | 27 | 4 | 0 | 0 | 0 | 12 | anchor `0,0`-`0,0`, pivot `0,0`, pos `0,0`, size `0,0` |
| 3 | actor_heroitem_template | template_inactive | `assets/download/ui/uiprefabandres/battle_ext_prefabs/prefabs/ui_normalbattle_heroitem.prefab` | True/False | 62 | 39 | 2 | 0 | 0 | 0 | 51 | anchor `0.5,0.5`-`0.5,0.5`, pivot `0.5,0.5`, pos `0,0`, size `269,200` |
| 4 | buff_icon_left_template | template_inactive | `assets/download/ui/uiprefabandres/battle_ext_prefabs/prefabs/item_buff_left.prefab` | True/False | 19 | 19 | 0 | 0 | 0 | 0 | 22 | anchor `0,0`-`0,0`, pivot `0.5,0.5`, pos `0,0`, size `240,90` |
| 5 | buff_icon_right_template | template_inactive | `assets/download/ui/uiprefabandres/battle_ext_prefabs/prefabs/item_buff_right.prefab` | True/False | 19 | 19 | 0 | 0 | 0 | 0 | 22 | anchor `0,0`-`0,0`, pivot `0.5,0.5`, pos `0,0`, size `240,90` |
| 6 | pause_panel_entry | entry_inactive | `assets/download/ui/uiprefabandres/battle_ext_prefabs/prefabs/ui_normalbattle_pause.prefab` | True/False | 14 | 14 | 1 | 0 | 0 | 0 | 16 | anchor `0,0`-`0,0`, pivot `0.5,0.5`, pos `320,240`, size `640,480` |
| 7 | skip_panel_entry | entry_inactive | `assets/download/ui/uiprefabandres/battle_ext_prefabs/prefabs/ui_normalbattle_skipview.prefab` | True/False | 41 | 41 | 2 | 0 | 0 | 0 | 47 | anchor `0,0`-`0,0`, pivot `0.5,0.5`, pos `320,240`, size `640,480` |
| 8 | test_battle_ui_entry | entry_inactive | `assets/download/ui/uiprefabandres/battle_ext_prefabs/prefabs/ui_testbattle.prefab` | True/False | 37 | 37 | 1 | 0 | 0 | 0 | 33 | anchor `0,0`-`0,0`, pivot `0.5,0.5`, pos `320,240`, size `640,480` |
| 9 | winlose_entry_victory_spine_base | entry_inactive | `assets/download/ui/uiprefabandres/winlose_ext_prefabs/victory_spine_base.prefab` | True/False | 47 | 47 | 0 | 0 | 0 | 0 | 50 | anchor `0.5,0.5`-`0.5,0.5`, pivot `0.5,0.5`, pos `0,0`, size `100,100` |
| 10 | winlose_entry_victory_spine_base2 | entry_inactive | `assets/download/ui/uiprefabandres/winlose_ext_prefabs/victory_spine_base2.prefab` | True/False | 31 | 31 | 0 | 0 | 0 | 0 | 35 | anchor `0.5,0.5`-`0.5,0.5`, pivot `0.5,0.5`, pos `0,0`, size `100,100` |

## Image/Text/Button Count Analysis
- BATTLE_16 and BATTLE_17 both resolve RectTransform/Canvas but resolve `Image`, `Text/TMP`, and `Button` as zero.
- The battle Unity prototype has `com.unity.modules.ui`, so this is not simply a missing UI module.
- The attached prefabs carry many missing MonoBehaviour components. Current evidence points to original UI widget/controller scripts and serialized UI component references not being resolved in this prototype project.
- Therefore sprite/material/font dependencies remain unresolved at component level and must be joined after missing type/script reconstruction. Whole atlas placement is still forbidden.

## Sprite/Region Dependencies Deferred
- `download/artsources/uispriteres/uibattle.assetbundle`
- `download/artsources/uispriteres/uibufficon.assetbundle`
- `download/artsources/uispriteres/uihurtnum.assetbundle`
- `download/artsources/uispriteres/uiheroheadbattle.assetbundle`

## Restore Policy Check
- Attached roots are original loadable AssetBundle prefabs, not fake HUD.
- Entry/template/result roots are kept inactive and are not final-screen overlays.
- Original prefab hierarchy is instantiated from source bundles. Root RectTransform anchor/pivot/scale/position evidence is recorded.
- Click/raycast validation is deferred because no resolved Button component exists yet.

## BATTLE_18 Recommendation
- `BATTLE_18_RECONSTRUCT_BATTLE_UI_COMPONENT_TYPES`
- Reason: HUD prefab roots attach successfully, but actual Image/Text/Button behavior is blocked first by missing script/type reconstruction. Sprite/region join should follow after UI component types resolve.
