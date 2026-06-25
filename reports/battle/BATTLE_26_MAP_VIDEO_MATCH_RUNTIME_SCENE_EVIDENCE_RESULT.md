# BATTLE_26 Map/Runtime Scene Evidence

This is not a final restored battle screen. It checks whether the current runtime flow map and actor evidence match `플레이.mp4` clip05 around 486s.

## Verdict
- flow mapId: `11001`
- battlemap candidates checked: `31`
- top map ids from video similarity: `11001, 11002, 11003, 11005`
- flow mapId in top 18: `True`
- flow map best rank: `5`
- contact sheet: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_26_MAP_VIDEO_MATCH_CANDIDATES_CONTACT_SHEET.jpg`

## Top Map Candidates
- `#1` score `0.62752` map `11003` `Map_11003_2` `1920x599` `download/artsources/map/battlemap/map_11003/map_11003_1.assetbundle`
- `#2` score `0.608746` map `11003` `Map_11003_5` `1920x433` `download/artsources/map/battlemap/map_11003/map_11003_2.assetbundle`
- `#3` score `0.553215` map `11003` `Map_11003_4_2` `1010x417` `download/artsources/map/battlemap/map_11003/map_11003_1.assetbundle`
- `#4` score `0.538893` map `11003` `Map_11003_3` `1920x272` `download/artsources/map/battlemap/map_11003/map_11003_1.assetbundle`
- `#5` score `0.46263` map `11001` `Map_11001_4` `702x350` `download/artsources/map/battlemap/map_11001/map_11001_1.assetbundle`
- `#6` score `0.407721` map `11001` `Map_11001_3` `1920x304` `download/artsources/map/battlemap/map_11001/map_11001_1.assetbundle`
- `#7` score `0.368714` map `11001` `Map_11001_2` `1920x669` `download/artsources/map/battlemap/map_11001/map_11001_1.assetbundle`
- `#8` score `0.355817` map `11005` `Map_11005_3` `2048x808` `download/artsources/map/battlemap/map_11005/map_11005_1.assetbundle`
- `#9` score `0.320345` map `11002` `Map_11002_3_2` `884x378` `download/artsources/map/battlemap/map_11002/map_11002_1.assetbundle`
- `#10` score `0.313267` map `11002` `Map_11002_3_1` `592x371` `download/artsources/map/battlemap/map_11002/map_11002_1.assetbundle`
- `#11` score `0.30437` map `11005` `Map_11005_5` `1899x533` `download/artsources/map/battlemap/map_11005/map_11005_2.assetbundle`
- `#12` score `0.296244` map `11003` `Map_11003_6` `1920x199` `download/artsources/map/battlemap/map_11003/map_11003_2.assetbundle`

## Actor Runtime Evidence
- actor slots: `12`
- loadable runtime prefabs: `3`
- missing/placeholders: `9`
- loadable `our` wave `0` slot `2` hero `1002` model `1002` `download/roleprefabsandres/battleprefabandres/1002.assetbundle`
- loadable `our` wave `0` slot `3` hero `1034` model `1034` `download/roleprefabsandres/battleprefabandres/1034.assetbundle`
- loadable `enemy` wave `1` slot `1` hero `1100111` model `3001` `download/roleprefabsandres/battleprefabandres/3001.assetbundle`

## HUD Carryover From BATTLE_25
- BATTLE_25 visual_status: `failed_missing_battle_scene_actors_skill_cards_runtime_camera`
- blank texture rows: `0`
- extracted sprite texture bind count: `290`

## Interpretation
- BATTLE_26 does not accept `mapId=11001` blindly. If the contact sheet shows another map id closer to the video, BATTLE_27 must rebuild the scene with that map evidence.
- Only extracted battlemap Sprite candidates are compared. No whole-atlas UI placement or fake HUD is used.
- Actor rendering remains incomplete until loadable Spine/prefab actors are placed with the correct runtime camera and missing actors are resolved from extracted bundles or documented as unavailable.

## Outputs
- result JSON: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_26_MAP_VIDEO_MATCH_RUNTIME_SCENE_EVIDENCE_RESULT.json`
- contact sheet: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_26_MAP_VIDEO_MATCH_CANDIDATES_CONTACT_SHEET.jpg`
- reference frame: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_26_PLAY_VIDEO_CLIP05_486S_BACKGROUND_REFERENCE.jpg`
- reference sequence: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_26_PLAY_VIDEO_CLIP05_486S_SEQUENCE.jpg`
