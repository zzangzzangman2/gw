# BATTLE_29 Hero List Skill-Card Bind Preview

This is not a final restored battle screen. It tests the BATTLE_28 finding that `ui_normalbattle_heroitem` exists as a template but is not cloned/bound into `HeroListContainer` at runtime.

## Verdict
- visual_status: `improved_hero_list_cards_bound_not_final`
- reference video: `C:\Users\godho\Downloads\플레이.mp4` clip05 around 486s
- capture: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreCaptures\battle_hud\BattleHeroListSkillCardBindClip05_1920x1080.png`
- contact sheet: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_29_HERO_LIST_SKILLCARD_BIND_CLIP05_CONTACT_SHEET.jpg`

## Binding Evidence
- templateFound: `True`
- containerFound: `True`
- boundHeroCardCount: `3`
- headSpriteBindCount: `3`
- extractedSpriteBindCount: `57`
- hiddenUnresolvedWhiteDataIconCount: `9`
- visibleCardImageCount: `51`
- visibleWhiteLikeCardImageCount: `0`
- BATTLE_27 bottom nonFloorLikeRatio: `0.212505`
- BATTLE_29 bottom nonFloorLikeRatio: `0.244674`
- capture nearWhiteRatio: `0.000278`

## Battle Map Evidence
- capture resolution: `1920x1080`
- originalBattlemapBundleLoaded: `True`
- originalBattlemapSpriteBindCount: `17`
- mapLayerCreatedCount: `10`
- pixelMatchedMapLayerCount: `9`
- pixelMatchedMapLayers: `Map_11003_11, Map_11003_5, Map_11003_4_2, Map_11003_4_1, Map_11003_3, Map_11003_2, Map_11003_1_3, Map_11003_1_4, Map_11003_1_1`

## Bound Cards
- slot `1` heroDid `1036` head `head1036` headBind `1` spriteBind `19` hiddenUnresolved `3` visibleImages `17` whiteLike `0` skills `1036101/1036201/1036301`
- slot `2` heroDid `1002` head `head1002` headBind `1` spriteBind `19` hiddenUnresolved `3` visibleImages `17` whiteLike `0` skills `1002101/1002201/1002301`
- slot `3` heroDid `1034` head `head1034` headBind `1` spriteBind `19` hiddenUnresolved `3` visibleImages `17` whiteLike `0` skills `1034101/1034201/1034301`

## Interpretation
- BATTLE_29 uses the original `ui_normalbattle_heroitem` prefab template and original `HeroListContainer`, not a hand-drawn card.
- Hero head sprites are bound from extracted original sprite slices: `head1036`, `head1002`, `head1034`.
- The result is still not final because card positions are inferred from the original container width/template size rather than proven by the original Lua/UI runtime layout pass.
- Actor animation and skill-effect runtime replay remain unresolved.

## Next Blocker
- `BATTLE_30_VERIFY_HERO_CARD_RUNTIME_LAYOUT_AND_ATTACH_ACTOR_ANIMATION_TRACE`

## Outputs
- result JSON: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_HERO_LIST_SKILLCARD_BIND_CLIP05_RESULT.json`
- Unity JSON: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_HERO_LIST_SKILLCARD_BIND_CLIP05.json`
- contact sheet: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_29_HERO_LIST_SKILLCARD_BIND_CLIP05_CONTACT_SHEET.jpg`
- map sprite sheet: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_29_MAP_11003_SPRITE_CONTACT_SHEET.jpg`
