# Battle UI Component Type Reconstruction Result

## Outputs
- Type evidence JSON: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_UI_COMPONENT_TYPE_EVIDENCE.json`
- Reconstruction result JSON: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_UI_COMPONENT_TYPE_RECONSTRUCTION_RESULT.json`
- Components CSV: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_UI_COMPONENT_TYPE_RECONSTRUCTION_COMPONENTS.csv`
- Scene: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\Scenes\BattleRuntimeFlowWithHudTypeProbe.unity`
- Capture: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreCaptures\battle_hud\BattleRuntimeFlowWithHudTypeProbe_1680x720.png`
- Unity batchmode success: `True`

## Counts
- Identified MonoScript/component types: `32`
- Official package types: `14`
- Stub/proxy types added: `18`
- Before Canvas / Rect / Image / Text / Button / Missing: `12` / `814` / `0` / `0` / `0` / `889`
- After Canvas / Rect / Image / Text / Button / Missing: `12` / `814` / `411` / `68` / `26` / `16`
- Missing script reduction: `873`
- Official UI resolved components: `510`
- Proxy resolved components: `370`
- Click validation: `validated:component_only_raycast_ready_25_of_26`
- Button validation / interactable / raycast-ready / without targetGraphic: `26` / `26` / `25` / `0`
- Capture visual assessment: `component_types_resolved_but_not_original_hud_like_until_sprite_region_font_material_and_canvas_sorting_join`

## Identified Type Evidence
| refs | assembly | full type | likely role | IL2CPP evidence | Lua evidence |
| ---: | --- | --- | --- | ---: | ---: |
| 306 | `UnityEngine.UI.dll` | `UnityEngine.UI.Image` | visual image/raycast | 2 | 2 |
| 151 | `spine-unity.dll` | `Spine.Unity.SkeletonSubmeshGraphic` | effect/animation | 0 | 0 |
| 147 | `Assembly-CSharp.dll` | `YouYou.YouYouImage` | visual image/raycast | 1 | 2 |
| 69 | `Unity.TextMeshPro.dll` | `TMPro.TextMeshProUGUI` | text/font | 0 | 2 |
| 45 | `UnityEngine.UI.dll` | `UnityEngine.UI.ContentSizeFitter` | layout/mask | 1 | 2 |
| 34 | `Assembly-CSharp.dll` | `LuaComponentBinder.LuaComBinder` | lua binder/controller | 1 | 2 |
| 33 | `UnityEngine.UI.dll` | `UnityEngine.UI.Button` | button/click | 0 | 2 |
| 18 | `Assembly-CSharp.dll` | `YouYou.YouYouCanvasHelper` | unknown/controller | 0 | 0 |
| 17 | `spine-unity.dll` | `Spine.Unity.SkeletonGraphic` | effect/animation | 0 | 0 |
| 15 | `Assembly-CSharp.dll` | `YouYou.UISpineCtr` | effect/animation | 2 | 2 |
| 15 | `UnityEngine.UI.dll` | `UnityEngine.UI.HorizontalLayoutGroup` | layout/mask | 1 | 2 |
| 15 | `UnityEngine.UI.dll` | `UnityEngine.UI.ScrollRect` | layout/mask | 1 | 2 |
| 14 | `UnityEngine.UI.dll` | `UnityEngine.UI.GraphicRaycaster` | canvas/raycast | 0 | 0 |
| 14 | `UnityEngine.UI.dll` | `UnityEngine.UI.GridLayoutGroup` | layout/mask | 1 | 1 |
| 14 | `UnityEngine.UI.dll` | `UnityEngine.UI.RectMask2D` | layout/mask | 0 | 0 |
| 10 | `UnityEngine.UI.dll` | `UnityEngine.UI.Text` | text/font | 2 | 2 |
| 9 | `Assembly-CSharp.dll` | `YouYou.FullscreenCenter` | unknown/controller | 1 | 0 |
| 8 | `UnityEngine.UI.dll` | `UnityEngine.UI.Mask` | layout/mask | 0 | 2 |
| 7 | `Assembly-CSharp.dll` | `UnityEngine.UI.Empty4Raycast` | visual image/raycast | 1 | 0 |
| 7 | `Coffee.UIParticle.dll` | `Coffee.UIExtensions.UIParticle` | effect/animation | 1 | 0 |
| 5 | `Assembly-CSharp.dll` | `YouYou.LuaForm` | lua binder/controller | 0 | 0 |
| 5 | `Assembly-CSharp.dll` | `YouYou.LuaUnit` | lua binder/controller | 0 | 2 |
| 4 | `Assembly-CSharp-firstpass.dll` | `DG.Tweening.DOTweenAnimation` | effect/animation | 0 | 2 |
| 4 | `UnityEngine.UI.dll` | `UnityEngine.UI.CanvasScaler` | canvas/raycast | 1 | 0 |
| 3 | `UnityEngine.UI.dll` | `UnityEngine.UI.VerticalLayoutGroup` | layout/mask | 2 | 0 |
| 2 | `Assembly-CSharp.dll` | `YouYou.EffectScale` | unknown/controller | 1 | 2 |
| 2 | `Assembly-CSharp.dll` | `YouYou.LookRotation` | unknown/controller | 0 | 0 |
| 2 | `Assembly-CSharp.dll` | `YouYou.UIEventListener` | button/click | 0 | 0 |
| 1 | `Assembly-CSharp.dll` | `SuperScrollView.LoopListView2` | unknown/controller | 0 | 0 |
| 1 | `Assembly-CSharp.dll` | `YouYou.ClickBase` | button/click | 2 | 0 |
| 1 | `Assembly-CSharp.dll` | `YouYou.GuideNode` | unknown/controller | 1 | 0 |
| 1 | `UnityEngine.UI.dll` | `UnityEngine.UI.RawImage` | visual image/raycast | 0 | 0 |

## Root Probe After Reconstruction
| role | prefab | image | text/tmp | button | missing | official UI | proxy | active |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| battle_root_hud | `assets/download/ui/uiprefabandres/battle_ext_prefabs/prefabs/ui_normalbattle.prefab` | 325 | 59 | 19 | 0 | 405 | 203 | True |
| battle_3d_overlay_hud | `assets/download/ui/uiprefabandres/battle_ext_prefabs/prefabs/ui_battle3dui.prefab` | 1 | 0 | 1 | 0 | 5 | 7 | True |
| actor_heroitem_template | `assets/download/ui/uiprefabandres/battle_ext_prefabs/prefabs/ui_normalbattle_heroitem.prefab` | 22 | 1 | 0 | 15 | 17 | 19 | False |
| buff_icon_left_template | `assets/download/ui/uiprefabandres/battle_ext_prefabs/prefabs/item_buff_left.prefab` | 15 | 0 | 0 | 0 | 15 | 7 | False |
| buff_icon_right_template | `assets/download/ui/uiprefabandres/battle_ext_prefabs/prefabs/item_buff_right.prefab` | 15 | 0 | 0 | 0 | 15 | 7 | False |
| pause_panel_entry | `assets/download/ui/uiprefabandres/battle_ext_prefabs/prefabs/ui_normalbattle_pause.prefab` | 6 | 3 | 2 | 0 | 15 | 1 | False |
| skip_panel_entry | `assets/download/ui/uiprefabandres/battle_ext_prefabs/prefabs/ui_normalbattle_skipview.prefab` | 2 | 0 | 1 | 1 | 7 | 39 | False |
| test_battle_ui_entry | `assets/download/ui/uiprefabandres/battle_ext_prefabs/prefabs/ui_testbattle.prefab` | 23 | 5 | 3 | 0 | 30 | 3 | False |
| winlose_entry_victory_spine_base | `assets/download/ui/uiprefabandres/winlose_ext_prefabs/victory_spine_base.prefab` | 2 | 0 | 0 | 0 | 1 | 49 | False |
| winlose_entry_victory_spine_base2 | `assets/download/ui/uiprefabandres/winlose_ext_prefabs/victory_spine_base2.prefab` | 0 | 0 | 0 | 0 | 0 | 35 | False |

## Video Reference Applied
- Motion report: `C:\Users\godho\Downloads\girlswar\reports\video_reference\PLAY_REFERENCE_VIDEO_MOTION_ANALYSIS.md`
- Restore notes: `C:\Users\godho\Downloads\girlswar\reports\video_reference\PLAY_REFERENCE_RESTORE_NOTES.md`
- Important clips for BATTLE_19 validation:
  - `C:\Users\godho\Downloads\girlswar\reports\video_reference\clips\battle_motion_clip_01_0088s.mp4`
  - `C:\Users\godho\Downloads\girlswar\reports\video_reference\clips\battle_motion_clip_02_0146s.mp4`
  - `C:\Users\godho\Downloads\girlswar\reports\video_reference\clips\battle_motion_clip_03_0380s.mp4`
  - `C:\Users\godho\Downloads\girlswar\reports\video_reference\clips\battle_motion_clip_05_0486s.mp4`
  - `C:\Users\godho\Downloads\girlswar\reports\video_reference\clips\battle_motion_clip_06_0500s.mp4`
- Top-center rounded gray overlay is treated as recording/touch artifact and is not a final HUD restore target.
- BATTLE_19 validation must compare HUD persistence during cut-ins, bottom skill/actor cards, right controls, floating damage/heal, hit flash, camera/effect shake, and cut-in timing against clips rather than still screenshots.

## Restore Policy Check
- No fake HUD or coordinate-only replacement was added.
- Original prefab hierarchy/RectTransform is still instantiated from source AssetBundles.
- Stub/proxy types are deserialize/resolve targets only; no battle AI or fake UI behavior was added.
- Whole atlas placement remains deferred until sprite/region evidence is joined.

## BATTLE_19 Recommendation
- `BATTLE_19_BATTLE_HUD_SPRITE_REGION_AND_FONT_JOIN_WITH_VIDEO_MOTION_VALIDATION`
