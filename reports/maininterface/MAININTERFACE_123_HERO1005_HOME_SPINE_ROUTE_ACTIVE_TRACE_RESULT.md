# MainInterface 123 Hero 1005 Home Spine And Route Active Trace Result

Generated: 2026-06-26 01:00:44 KST

## Verdict

Not restored. `maininterface_restored_1680x720.png` now uses the 1005 night/moon background, but the 1005 character is still absent and the right route/world cluster remains visible.

No visual patch was applied in UI123. The evidence supports a hero runtime restoration blocker, not an arbitrary route hide.

## Capture Check

| path | exists | size | bytes | meanAbsDiffVsReference | classification |
| --- | --- | --- | --- | --- | --- |
| C:\Users\godho\.codex\attachments\e607fc34-b674-4516-b051-8d396cd6df06\image-1.png | True | [1180, 526] | 1233287 |  |  |
| C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreCaptures\maininterface_restored_1680x720.png | True | [1680, 720] | 1333141 | 65.733 | mismatch |

## Hero Runtime Evidence

- `UI_heroSpine` is active in the prefab rows, but has `sizeDelta=0,0`, no child ids, and sprite rows with `empty_sprite_ref` plus alpha `0.0`.
- Decoded `UI_MainPage.refreshMiddle` normal branch calls `UIUtil.GetPlayerBigSpineAll(i, UI_heroSpine, "homePara", ...)`, then loads `UI_bg` from `UIUtil.GetPaintingBg(i)`.
- For hero/background 1005, the home Spine candidate is `download/roleprefabsandres/paintingprefabandres/1005.assetbundle`, which contains `Painting_1005.skel`, `Painting_1005.atlas`, `Painting_1005_back.skel`, `Painting_1005_back.atlas`, and the `PaintingBG_1005` image family.
- `battleprefabandres/1005.assetbundle` is indexed, but it is the battle actor bundle. It is not the evidence-backed first choice for `homePara` lobby restoration.
- Live2D evidence is split: `download/live2d/1005.assetbundle` appears in the CDN versionfile but is not present in the current extracted `assetbundles.csv`; `download/live2d/1043.assetbundle` is extracted locally and `UI_heroLive2d_1005` exists under `marry.assetbundle`.
- Even with that Live2D evidence, decoded `UI_MainPage` reaches `SetMarryHeroModel -> UIUtil.GetPlayerLive2dModel` only in the `isMarry/isSelfMarry` branches, not the normal home branch.
| bundle | source | name | size | status | output |
| --- | --- | --- | --- | --- | --- |
| download/live2d/1005.assetbundle | assetbundle |  |  | missing_from_index |  |
| download/live2d/1005_ext_prefab.assetbundle | assetbundle |  |  | missing_from_index |  |
| download/live2d/1043.assetbundle | assetbundle |  | 8321689 | ok |  |
| download/live2d/1043_ext_prefab.assetbundle | assetbundle |  | 136494 | ok |  |
| download/roleprefabsandres/paintingprefabandres/1005.assetbundle | assetbundle |  | 3976259 | ok |  |
| download/live2d/1043.assetbundle | versionfile_VersionFile_bytes | 1043.assetbundle | 8321689 | IsFirstData=True; IsEncrypt=False; Version=; ResOffset=0 | MD5=d69bb88debb15f2ce5af4e493f762439 |
| download/live2d/1043_ext_prefab.assetbundle | versionfile_VersionFile_bytes | 1043_ext_prefab.assetbundle | 136494 | IsFirstData=True; IsEncrypt=False; Version=; ResOffset=0 | MD5=c3c7827e5048b7eb23ab59021f81401e |
| download/roleprefabsandres/paintingprefabandres/1005.assetbundle | versionfile_VersionFile_bytes | 1005.assetbundle | 4212729 | IsFirstData=True; IsEncrypt=True; Version=; ResOffset=0 | MD5=68430385ff3f51d6195cc178d11d9e03 |
| download/live2d/1005.assetbundle | versionfile_CDNVersionFile_bytes | 1005.assetbundle | 12015360 | IsFirstData=False; IsEncrypt=False; Version=1.0.536; ResOffset=165 | MD5=f81906997bb5a16db1f26c0818e728d5 |
| download/live2d/1005_ext_prefab.assetbundle | versionfile_CDNVersionFile_bytes | 1005_ext_prefab.assetbundle | 219126 | IsFirstData=False; IsEncrypt=False; Version=1.0.277; ResOffset=341 | MD5=323c765629355d4afde1cacae409678b |
| download/live2d/1043.assetbundle | versionfile_CDNVersionFile_bytes | 1043.assetbundle | 8321689 | IsFirstData=True; IsEncrypt=False; Version=1.0.458; ResOffset=280 | MD5=d69bb88debb15f2ce5af4e493f762439 |
| download/live2d/1043_ext_prefab.assetbundle | versionfile_CDNVersionFile_bytes | 1043_ext_prefab.assetbundle | 136494 | IsFirstData=True; IsEncrypt=False; Version=1.0.255; ResOffset=361 | MD5=c3c7827e5048b7eb23ab59021f81401e |
| download/roleprefabsandres/paintingprefabandres/1005.assetbundle | versionfile_CDNVersionFile_bytes | 1005.assetbundle | 4212729 | IsFirstData=True; IsEncrypt=True; Version=1.0.279; ResOffset=392 | MD5=68430385ff3f51d6195cc178d11d9e03 |
| download/live2d/1043.assetbundle | textasset | Live2d_1043.model3 | 2478 | indexed | extracted/unity/bundles/b_2618c58d7b326e63/textassets/-2273146679508954321_Live2d_1043.model3.txt |
| download/live2d/1043.assetbundle | textasset | Live2d_1043.physics3 | 4378 | indexed | extracted/unity/bundles/b_2618c58d7b326e63/textassets/7598925105523137601_Live2d_1043.physics3.txt |
| download/live2d/1043.assetbundle | textasset | Live2d_1043.cdi3 | 17476 | indexed | extracted/unity/bundles/b_2618c58d7b326e63/textassets/8086648397649200835_Live2d_1043.cdi3.txt |
| download/roleprefabsandres/paintingprefabandres/1005.assetbundle | textasset | Painting_1005_back.skel | 100542 | indexed | extracted/unity/bundles/b_a47980c73bab4250/textassets/-8857548251462254639_Painting_1005_back.skel.txt |
| download/roleprefabsandres/paintingprefabandres/1005.assetbundle | textasset | Painting_1005.atlas | 4700 | indexed | extracted/unity/bundles/b_a47980c73bab4250/textassets/-3076532181206688105_Painting_1005.atlas.txt |
| download/roleprefabsandres/paintingprefabandres/1005.assetbundle | textasset | Painting_1005.skel | 571209 | indexed | extracted/unity/bundles/b_a47980c73bab4250/textassets/1567254803433793860_Painting_1005.skel.txt |
| download/roleprefabsandres/paintingprefabandres/1005.assetbundle | textasset | SP_heroname_1005.atlas | 156 | indexed | extracted/unity/bundles/b_a47980c73bab4250/textassets/5081366588584777480_SP_heroname_1005.atlas.txt |
| download/roleprefabsandres/paintingprefabandres/1005.assetbundle | textasset | SP_heroname_1005.skel | 5074 | indexed | extracted/unity/bundles/b_a47980c73bab4250/textassets/7884510430429545721_SP_heroname_1005.skel.txt |
| download/roleprefabsandres/paintingprefabandres/1005.assetbundle | textasset | Painting_1005_back.atlas | 699 | indexed | extracted/unity/bundles/b_a47980c73bab4250/textassets/8883680961857034524_Painting_1005_back.atlas.txt |
| download/xlualogic/modules/marry.assetbundle | textasset | UI_heroLive2d_1005 | 17741 | indexed | extracted/unity/bundles/b_a38dff04ab8594e2/textassets/1004685034597122548_UI_heroLive2d_1005.txt |
| download/live2d/1043.assetbundle | image | texture_00 | 2048x2048 | indexed | extracted/unity/bundles/b_2618c58d7b326e63/images/T/-3903353114922054368_texture_00.png |
| download/live2d/1043.assetbundle | image | texture_01 | 2048x2048 | indexed | extracted/unity/bundles/b_2618c58d7b326e63/images/T/7479956811166899722_texture_01.png |
| download/roleprefabsandres/paintingprefabandres/1005.assetbundle | image | noalphabg_PaintingBG_1005 | 1680x720 | indexed | extracted/unity/bundles/b_a47980c73bab4250/images/T/-4530015849589015318_noalphabg_PaintingBG_1005.png |
| download/roleprefabsandres/paintingprefabandres/1005.assetbundle | image | SP_heroname_1005 | 512x512 | indexed | extracted/unity/bundles/b_a47980c73bab4250/images/T/-3719539670443368749_SP_heroname_1005.png |
| download/roleprefabsandres/paintingprefabandres/1005.assetbundle | image | Painting_1005_back | 2048x1024 | indexed | extracted/unity/bundles/b_a47980c73bab4250/images/T/-3614049832703651791_Painting_1005_back.png |
| download/roleprefabsandres/paintingprefabandres/1005.assetbundle | image | noalphabg_Tujian_1005 | 1154x577 | indexed | extracted/unity/bundles/b_a47980c73bab4250/images/T/-3423690144217353563_noalphabg_Tujian_1005.png |
| download/roleprefabsandres/paintingprefabandres/1005.assetbundle | image | Painting_1005 | 2048x2048 | indexed | extracted/unity/bundles/b_a47980c73bab4250/images/T/-1388925835232960436_Painting_1005.png |
| download/roleprefabsandres/paintingprefabandres/1005.assetbundle | image | noalphabg_PaintingBG_1005 | 1680x720 | indexed | extracted/unity/bundles/b_a47980c73bab4250/images/S/1249758843074273264_noalphabg_PaintingBG_1005.png |
| download/roleprefabsandres/paintingprefabandres/1005.assetbundle | image | noalphabg_Tujian_1005 | 1154x577 | indexed | extracted/unity/bundles/b_a47980c73bab4250/images/S/2762434863806027550_noalphabg_Tujian_1005.png |

## Current Hero Sprite Rows

| name | gameObjectId | status | alpha | asset |
| --- | --- | --- | --- | --- |
| UI_bg | -739438087074354188 | ready | 1.0 | Assets/RestoredSprites/maininterface/download_uicommonbg_uicommonbg2/fid9_4648636570285078741_noalphabg_BG_changjing_2.png |
| UI_heroSpine | 2247224239628523787 | empty_sprite_ref | 0.0 |  |
| UI_heroSpine | 6569245046781814939 | empty_sprite_ref | 0.0 |  |
| UI_touchSpine | 3101055438495186894 | empty_sprite_ref | 0.0 |  |
| UI_touchSpine | -1874286104444283317 | empty_sprite_ref | 0.0 |  |
| UI_bg | -1457103517121630268 | ready | 0.0 | Assets/RestoredSprites/maininterface/download_uicommonbg_uicommonbg2/fid9_4648636570285078741_noalphabg_BG_changjing_2.png |

## Route Active-State Evidence

| key | active | siblingIndex | anchored | size | scale | children |
| --- | --- | --- | --- | --- | --- | --- |
| right | True | 4 | 0.0,0.0 | 0.0,0.0 | 1.0,1.0,1.0 | 7 |
| node_middle | True | 4 | -135.0,-100.0 | 0.0,0.0 | 1.0,1.0,1.0 | 5 |
| wanfaWorldNode | True | 0 | -12.0,87.0 | 100.0,100.0 | 1.0,1.0,1.0 | 6 |
| worldwanfaBtn | True | 0 | -101.0,1.0 | 253.0,253.0 | 1.0,1.0,1.0 | 1 |
| mian_wanfa_item_1 | True | 1 | -246.0,192.0 | 100.0,100.0 | 1.0,1.0,1.0 | 9 |
| mian_wanfa_item_2 | True | 2 | 18.0,192.0 | 100.0,100.0 | 1.0,1.0,1.0 | 9 |
| mian_wanfa_item_3 | True | 3 | -246.0,-14.0 | 100.0,100.0 | 1.0,1.0,1.0 | 9 |
| mian_wanfa_item_4 | True | 4 | 18.0,-14.0 | 100.0,100.0 | 1.0,1.0,1.0 | 9 |

Decoded Lua hides or shows `mian_wanfa_item_3/4` based on review mode and `MainPageLimitMgr`, but no normal-home evidence was found that hides `right`, `node_middle`, `wanfaWorldNode`, or `worldwanfaBtn`.

## Lua Evidence Map

| lines | evidence |
| --- | --- |
| 103-130 | OnInit review-only active changes |
| 1327-1385 | refreshRightMiddleView and item 3/4 dynamic active state |
| 1419-1489 | right-bottom function gates |
| 1491-1560 | refreshMiddle normal hero Spine and background path |
| 1637-1667 | SetMarryHeroModel Live2D branch |
| 2896-2898 | world button click handler |

## Builder Evidence Map

| lines | evidence |
| --- | --- |
| 252-259 | CanvasScaler |
| 281-285 | initial SetActive from RectTransform CSV |
| 305-316 | sibling order and rect overrides |
| 371-383 | capture rebuilds before screenshot |
| 504-510 | ApplyRectRow preserves source localScale |
| 591-604 | active overrides |
| 607-640 | Image/Sprite application skips empty sprite refs |

The current builder now rebuilds before capture and preserves CSV `localScale`. Its sprite path still skips rows with `empty_sprite_ref`, so it cannot create the missing 1005 character until a runtime Spine/Live2D mount path is implemented.

## Next Blocker

Implement an evidence-backed 1005 home Spine restoration path for `UI_heroSpine`: import/build from `paintingprefabandres/1005` and mount the `Painting_1005` home skeleton with the same `homePara` semantics used by Lua. Route/world cluster deactivation remains blocked until real runtime evidence is found; hiding `wanfaWorldNode/worldwanfaBtn` now would be arbitrary.

## Files

- JSON: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\maininterface_123_hero1005_home_spine_route_active_trace.json`
- Bundle asset CSV: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_123_hero1005_bundle_assets.csv`
- Route active CSV: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_123_route_active_evidence.csv`
- Tool: `C:\Users\godho\Downloads\girlswar\_restore_tools\cmd_archive\123_TRACE_HERO1005_HOME_SPINE_ROUTE_ACTIVE_STATE.cmd`
- Capture: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreCaptures\maininterface_restored_1680x720.png`
