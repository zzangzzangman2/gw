# BATTLE_54_VALIDATE_ROUTE_ACTIVE_SIBLING_MASK_TMP_SCALE_AUTOSIZE_ACTOR_PAYLOAD Result

**최종 playable battle screen은 아직 아니다.** BATTLE54는 최신 BATTLE51 후보 씬을 정적 YAML/기존 Unity probe 산출물 기준으로 재검증해 route active state, sibling order, mask/stencil, TMP scale/autosize, actor/card payload 상태를 분리했다.

## Verdict
- visual_status: `structural_route_actor_card_audit_complete_no_runtime_patch`
- final screen claim: `false`
- patch decision: `blocked_no_scene_patch_in_battle54_static_audit`
- scene: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\Scenes\Battle51LuaBridgeRaycasterRegistrationCandidate.unity`
- capture: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreCaptures\battle_actor\Battle51LuaBridgeRaycasterRegistrationCandidate_1920x1080.png`

## Route / Active / Sibling
- audited route rows: `1046`
- active routes with zero-ish local scale: `7`
- inactive critical route rows: `19`
- zero-scale samples:
  - `BattleHudSpriteAtlasTextureRuntimeBindingClip05Root/CanvasLuaStateHUD_01_ui_normalbattle`
  - `BattleHudSpriteAtlasTextureRuntimeBindingClip05Root/CanvasLuaStateHUD_01_ui_normalbattle/root_battle/BottomCenter/HeroListContainer/Battle29BoundHeroCard_1_1036/imgIconBG/tweener/UIEffect_meili`
  - `BattleHudSpriteAtlasTextureRuntimeBindingClip05Root/CanvasLuaStateHUD_01_ui_normalbattle/root_battle/BottomCenter/HeroListContainer/Battle29BoundHeroCard_2_1002/imgIconBG/tweener/UIEffect_meili`
  - `BattleHudSpriteAtlasTextureRuntimeBindingClip05Root/CanvasLuaStateHUD_01_ui_normalbattle/root_battle/BottomCenter/HeroListContainer/Battle29BoundHeroCard_3_1034/imgIconBG/tweener/UIEffect_meili`
  - `BattleHudSpriteAtlasTextureRuntimeBindingClip05Root/CanvasLuaStateHUD_01_ui_normalbattle/root_battle/BottomCenter/UI_BigSkillPress/Particle System/lizi`
  - `BattleHudSpriteAtlasTextureRuntimeBindingClip05Root/CanvasLuaStateHUD_02_ui_battle3dui`
  - `BattleHudSpriteAtlasTextureRuntimeBindingClip05Root/CanvasLuaStateHUD_03_ui_normalbattle_heroitem/imgIconBG/tweener/UIEffect_meili`

## Actors / Payload
- scene actor rows: `6`
- active scene actor rows: `3`
- active loadable scene actor rows: `3`
- disabled legacy actor rows: `3`
- manifest classification: `local_playable_subset_only_not_full_payload`
- manifest loadable actors: `3` / `12`
- manifest actor status counts: `{'not_fetchable_local': 1, 'loadable': 3, 'unresolved_enemy_payload_instance': 8}`

## Mask / Stencil
- mask rows: `16`
- serialized Mask component rows: `8`
- name-only mask candidate rows: `8`
- Important: BATTLE54 does not add Mask/RectMask2D/Stencil components. Rows with `m_ShowMaskGraphic` and `m_Script: fileID 0` remain serialized/missing-script evidence, not a confirmed working stencil pipeline.

## TMP / Text
- TMP/text rows: `65`
- TMP auto-size counts: `{'0': 64, '1': 1}`
- negative character-spacing rows: `15`

## Hero Cards / Buttons
- card rows: `4`
- active card rows: `3`
- active cards with at least one sprite-backed image: `3`
- button route rows: `31`
- button component rows: `26`
- active button rows: `16`

## Runtime Carryover
- BATTLE51 direct target included: `5`
- BATTLE51 forced EventSystem target included: `5`
- BATTLE52 Lua lifecycle executed: `0`
- BATTLE53 verdict: `accepted_block_no_source_backed_xlua_runtime_available_locally`

## Current Root Cause Split
- Visual mismatch is not explained by a single button coordinate. The latest candidate has active HUD routes and active loadable actor candidates, but final playability still lacks executable xLua/GameEntry/LuaManager lifecycle and original runtime placement/state.
- Actor/card payload is only a local subset: loadable actors are present for `1002`, `1034`, and enemy `1100111 -> 3001`; `1036` and most enemy payload ids are not locally resolved.
- Mask/stencil and TMP states are mostly preserved as serialized/missing-script evidence. BATTLE54 refuses to invent working stencil/TMP behavior without source/runtime confirmation.
- The next safe path is either source-backed runtime import, or a separate explicitly approved non-source-backed xLua experiment; otherwise continue non-runtime evidence tasks only.

## Outputs
- result JSON: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_54_VALIDATE_ROUTE_ACTIVE_SIBLING_MASK_TMP_SCALE_AUTOSIZE_ACTOR_PAYLOAD_RESULT.json`
- routes CSV: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_54_VALIDATE_ROUTE_ACTIVE_SIBLING_MASK_TMP_SCALE_AUTOSIZE_ACTOR_PAYLOAD_ROUTES.csv`
- actors CSV: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_54_VALIDATE_ROUTE_ACTIVE_SIBLING_MASK_TMP_SCALE_AUTOSIZE_ACTOR_PAYLOAD_ACTORS.csv`
- masks CSV: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_54_VALIDATE_ROUTE_ACTIVE_SIBLING_MASK_TMP_SCALE_AUTOSIZE_ACTOR_PAYLOAD_MASKS.csv`
- TMP/text CSV: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_54_VALIDATE_ROUTE_ACTIVE_SIBLING_MASK_TMP_SCALE_AUTOSIZE_ACTOR_PAYLOAD_TMP_TEXT.csv`
- hero cards CSV: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_54_VALIDATE_ROUTE_ACTIVE_SIBLING_MASK_TMP_SCALE_AUTOSIZE_ACTOR_PAYLOAD_HERO_CARDS.csv`
- buttons CSV: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_54_VALIDATE_ROUTE_ACTIVE_SIBLING_MASK_TMP_SCALE_AUTOSIZE_ACTOR_PAYLOAD_BUTTON_ROUTES.csv`

## Command Policy Check
- root CMD count: `1`
- `_restore_tools` direct CMD count: `0`
