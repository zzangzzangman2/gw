# MainInterface 123 Hero 1005 Home Spine Source Export Result

Generated: 2026-06-26 01:04:40 KST

## Verdict

Evidence-backed source export applied. This does not claim visual restoration: it prepares the original 1005 home Spine source assets required by the Lua `GetPlayerBigSpineAll(..., "homePara")` branch.

- Source export dir: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\hero1005_spine_source`
- Exported files: `35`
- Spine runtime in restore project: `present`
- 1005 `homePara`: `[1,0,0]`
- 1005 `paintingBg`: `"noalphabg_PaintingBG_1005"`

## Bundle Evidence

| bundle | status | size | object_count | export_dir |
| --- | --- | --- | --- | --- |
| download/roleprefabsandres/paintingprefabandres/1005.assetbundle | ok | 3976259 | 295 | extracted/unity/bundles/b_a47980c73bab4250 |
| download/roleprefabsandres/rolebigsetpainting/1005.assetbundle | ok | 1769688 | 33 | extracted/unity/bundles/b_9dd4a303d80bec5b |
| download/roleprefabsandres/battleprefabandres/1005.assetbundle | ok | 1512900 | 22 | extracted/unity/bundles/b_dbb6eb9e5987445e |
| download/commonprefabsandres/spinematandshaders.assetbundle | ok | 63615 | 44 | extracted/unity/bundles/b_60f9c03224a30ca7 |

## Lua Evidence

| line | note | text |
| --- | --- | --- |
| 1543 | default home BigSpine loader | UIUtil.GetPlayerBigSpineAll( |
| 1546 | homePara parameter | "homePara", |
| 1558 | UI_touchSpine active for default branch | LuaUtils.SetActive(UI_touchSpine.transform,true) |
| 1559 | painting background lookup | local e=UIUtil.GetPaintingBg(i) |
| 1560 | UI_bg LoadSpriteWithFullPath | GameTools:LoadSpriteWithFullPath(UI_bg,e,true) |
| 1640 | marry/self marry Live2D branch loader | UIUtil.GetPlayerLive2dModel(a,UI_heroSpine,nil,function(a,o) |

## Painting Prefab Structure

- Root RectTransforms: `4`
- SkeletonGraphic-like behaviours: `5`

| game_object_name | starting_animation | starting_loop | skeleton_data_asset |
| --- | --- | --- | --- |
| SP_heroname_1005 | A1 | 1 | {"m_FileID":0,"m_PathID":-5538124453423489143} |
| Painting_1005 | A | 1 | {"m_FileID":0,"m_PathID":-149282230390880246} |
| Painting_1005_back | A | 1 | {"m_FileID":0,"m_PathID":87356403628614173} |
| Painting_1005_back | A | 1 | {"m_FileID":0,"m_PathID":87356403628614173} |
| Painting_1005 | A | 1 | {"m_FileID":0,"m_PathID":-149282230390880246} |

## Atlas Evidence

| atlas_file | page | region_count | first_regions |
| --- | --- | --- | --- |
| -3076532181206688105_Painting_1005.atlas.txt | Painting_1005.png | 142 | A_eyeball_L, A_eyeball_L2, A_eyeball_R, A_eyeball_R2, A_eyeblow, A_eyelash_L1, A_eyelash_L2, A_eyelash_L3, A_eyelash_R1, A_eyelash_R2, A_eyelash_R3, A_mouth |
| 5081366588584777480_SP_heroname_1005.atlas.txt | SP_heroname_1005.png | 3 | images/1005, images/sr, images/t3 |
| 8883680961857034524_Painting_1005_back.atlas.txt | Painting_1005_back.png | 19 | bgb, bgb1, bgb10, bgb11, bgb12, bgb13, bgb14, bgb15, bgb16, bgb17, bgb18, bgb2 |

## Next Blocker

Create/import Unity Spine assets for `Painting_1005.atlas.txt`, `Painting_1005.skel.bytes`, and `Painting_1005.png`, then mount a real `SkeletonGraphic` under `UI_heroSpine` using the 1005 `homePara` evidence. Do not use `Painting_1005.png` as a whole UI Image.

Route/world cluster active state remains separately blocked: decoded Lua still provides no normal-home evidence to hide `wanfaWorldNode/worldwanfaBtn`.

## Files

- JSON: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\maininterface_123_hero1005_home_spine_source_export.json`
- Export CSV: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_123_hero1005_spine_source_export.csv`
- DTmodel CSV: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_123_hero1005_dtmodel_fields.csv`
- Atlas CSV: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_123_hero1005_atlas_regions.csv`
- Structure CSV: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_123_hero1005_paintingprefab_roots.csv`
- Tool: `C:\Users\godho\Downloads\girlswar\_restore_tools\cmd_archive\123_EXPORT_HERO1005_HOME_SPINE_SOURCE.cmd`
