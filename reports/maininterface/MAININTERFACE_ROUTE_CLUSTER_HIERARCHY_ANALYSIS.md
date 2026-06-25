# MainInterface Route Cluster Hierarchy Analysis

Generated: 2026-06-25 16:57:05

## Verdict

`node_middle` 아래 route cluster에는 현재 active override가 적용되지 않았다. 즉 현재 겹침은 builder가 원본 active를 잘못 덮은 결과가 아니라, 원본 active state를 그대로 살린 뒤 카드 내부 state/텍스트/스프라이트가 함께 보이는 문제다.

`UI_Main_wanfa_item_1..4`와 `wanfaWorldNode`는 원본 RectTransform CSV 기준 모두 active이며 같은 parent `node_middle` 아래 sibling으로 존재한다. 따라서 route item 자체를 임의로 끄는 것은 원본 근거가 약하다.

## node_middle Child Order

| idx | child | active | pos | size | pathID |
| ---: | --- | --- | --- | --- | --- |
| 0 | `wanfaWorldNode` | `True` | `-12.0,87.0` | `100.0x100.0` | `-3820167396480157270` |
| 1 | `UI_Main_wanfa_item_1` | `True` | `-246.0,192.0` | `100.0x100.0` | `51920382737909704` |
| 2 | `UI_Main_wanfa_item_2` | `True` | `18.0,192.0` | `100.0x100.0` | `-3930377403474185176` |
| 3 | `UI_Main_wanfa_item_3` | `True` | `-246.0,-14.0` | `100.0x100.0` | `1745568030950951925` |
| 4 | `UI_Main_wanfa_item_4` | `True` | `18.0,-14.0` | `100.0x100.0` | `7836085562230756963` |

## Route Owner Nodes

| owner | active | pos | size | scale | child order |
| --- | --- | --- | --- | --- | --- |
| `node_middle` | `True` | `-135.0,-100.0` | `0.0x0.0` | `1.0,1.0,1.0` | `wanfaWorldNode(-3820167396480157270);UI_Main_wanfa_item_1(51920382737909704);UI_Main_wanfa_item_2(-3930377403474185176);UI_Main_wanfa_item_3(1745568030950951925);UI_Main_wanfa_item_4(7836085562230756963)` |
| `UI_Main_wanfa_item_1` | `True` | `-246.0,192.0` | `100.0x100.0` | `1.0,1.0,1.0` | `wanfaBgImg(-2847822897649166745);Entry(1449871701069084495);un_MainInterface_fire(-6801489505443444490);im_bg(-4882528769436301220);text_wanfaTips(-2209049531134370308);text_name(-5982825750273040741);im_redpoint(1624559177700309340);im_new(7513344076664902408);wanfaBtn(1986840053565196790)` |
| `UI_Main_wanfa_item_2` | `True` | `18.0,192.0` | `100.0x100.0` | `1.0,1.0,1.0` | `wanfaBgImg(-6087085470653368835);Entry(-8318423108051799291);un_MainInterface_fire(-9047331040974660233);im_bg(2337463915861829486);text_wanfaTips(2778291803801687173);text_name(7817983549160651324);im_redpoint(-5936139281737355205);im_new(-8246999005634469339);wanfaBtn(840801985878816193)` |
| `UI_Main_wanfa_item_3` | `True` | `-246.0,-14.0` | `100.0x100.0` | `1.0,1.0,1.0` | `wanfaBgImg(-2011011070318215459);Entry(-249494615586118723);un_MainInterface_fire(3550262967849686076);im_bg(-1786927514953282374);text_wanfaTips(-4444991916405094732);text_name(-6275118336609310875);im_redpoint(1061094201511039461);im_new(8735560845260607414);wanfaBtn(7344258773029800384)` |
| `UI_Main_wanfa_item_4` | `True` | `18.0,-14.0` | `100.0x100.0` | `1.0,1.0,1.0` | `wanfaBgImg(-7952813358366190174);Entry(-2663983105510939953);un_MainInterface_fire(2420700212528543409);im_bg(412788869340406666);text_wanfaTips(-3039270450605219620);text_name(-3578904844754949875);im_redpoint(5954440455150368682);im_new(-3521887510053148211);wanfaBtn(-2510216933665100986)` |
| `wanfaWorldNode` | `True` | `-12.0,87.0` | `100.0x100.0` | `1.0,1.0,1.0` | `worldwanfaBtn(3512211464843089861);spine_xiaoren(3375689855543054311);text_big(5611221341508507661);text_small(4226973974425312330);world_node_red(3339705364331503776);fanhui_guide_shou(4770820143629459276)` |

## Active Text/Image Highlights

| owner | node | component | active | text/sprite | material/asset | font | size |
| --- | --- | --- | --- | --- | --- | ---: | --- |
| `UI_Main_wanfa_item_3` | `wanfaBtn` | `Image` | `True` | `Image_blank` | `fid1_6617065208850742552_Image_blank.png` |  | `130.0x130.0` |
| `UI_Main_wanfa_item_3` | `wanfaBtn` | `Button` | `True` | `` | `-5740242890252651072` |  | `130.0x130.0` |
| `UI_Main_wanfa_item_1` | `text_name` | `TMP` | `True` | `모험` | `4174273018840097604` | 28.0 | `100.0x35.0` |
| `UI_Main_wanfa_item_3` | `text_name` | `TMP` | `True` | `모험` | `4174273018840097604` | 28.0 | `200.0x0.0` |
| `UI_Main_wanfa_item_4` | `wanfaBtn` | `Image` | `True` | `Image_blank` | `fid1_6617065208850742552_Image_blank.png` |  | `130.0x130.0` |
| `UI_Main_wanfa_item_4` | `wanfaBtn` | `Button` | `True` | `` | `-7870406640315514268` |  | `130.0x130.0` |
| `UI_Main_wanfa_item_3` | `wanfaBgImg` | `Image` | `True` | `zhuye_maoxian` | `fid11_-1459155864645330874_zhuye_maoxian.png` |  | `144.0x144.0` |
| `UI_Main_wanfa_item_4` | `text_name` | `TMP` | `True` | `모험` | `4174273018840097604` | 28.0 | `200.0x0.0` |
| `wanfaWorldNode` | `worldwanfaBtn` | `Button` | `True` | `` | `4634358241626153568` |  | `253.0x253.0` |
| `UI_Main_wanfa_item_4` | `text_wanfaTips` | `TMP` | `True` | `개최 중` | `3932716197974622303` | 18.0 | `180.0x30.0` |
| `UI_Main_wanfa_item_1` | `wanfaBgImg` | `Image` | `True` | `zhuye_maoxian` | `fid11_-1459155864645330874_zhuye_maoxian.png` |  | `144.0x144.0` |
| `UI_Main_wanfa_item_2` | `text_name` | `TMP` | `True` | `모험` | `4174273018840097604` | 28.0 | `100.0x35.0` |
| `UI_Main_wanfa_item_2` | `wanfaBtn` | `Image` | `True` | `Image_blank` | `fid1_6617065208850742552_Image_blank.png` |  | `130.0x130.0` |
| `UI_Main_wanfa_item_2` | `wanfaBtn` | `Button` | `True` | `` | `7677582287010058776` |  | `130.0x130.0` |
| `UI_Main_wanfa_item_2` | `wanfaBgImg` | `Image` | `True` | `zhuye_maoxian` | `fid11_-1459155864645330874_zhuye_maoxian.png` |  | `144.0x144.0` |
| `UI_Main_wanfa_item_4` | `im_bg` | `Image` | `True` | `BG_wave` | `fid1_3767306702705834126_BG_wave.png` |  | `140.22999572753906x27.0` |
| `UI_Main_wanfa_item_4` | `wanfaBgImg` | `Image` | `True` | `zhuye_maoxian` | `fid11_-1459155864645330874_zhuye_maoxian.png` |  | `144.0x144.0` |
| `UI_Main_wanfa_item_1` | `wanfaBtn` | `Image` | `True` | `Image_blank` | `fid1_6617065208850742552_Image_blank.png` |  | `130.0x130.0` |
| `UI_Main_wanfa_item_1` | `wanfaBtn` | `Button` | `True` | `` | `975500412906767799` |  | `130.0x130.0` |
| `wanfaWorldNode` | `text_big` | `TMP` | `True` | `전` | `4174273018840097604` | 48.0 | `70.0x60.0` |
| `wanfaWorldNode` | `text_small` | `TMP` | `True` | `국` | `4174273018840097604` | 42.0 | `60.0x50.0` |
| `wanfaWorldNode` | `world_node_red` | `Image` | `True` | `T_hongdian_1` | `fid1_523894093744659759_T_hongdian_1.png` |  | `27.0x27.0` |

## Active Duplicate Text Groups

No duplicate active text components with the same owner/node/text key were found under route cluster.

## Current Scene Checks

- variant font GUID `a070138850f2c0741a7f23bbab89f6dc` references in scene: `7`
- variant font GUID `a25b0cd4a793905498ea765125d1fae5` references in scene: `25`
- variant font GUID `50f0e3d4993d93246b7b530934bd405d` references in scene: `18`

## Next

1. Do not disable `UI_Main_wanfa_item_1..4` as duplicates unless a stronger runtime state source is found.
2. Focus on each route card's internal active children: `text_name`, `text_wanfaTips`, `wanfaBgImg`, `wanfaBtn`, and world node `text_big/text_small` composition.
3. If capture shows label/image overlap after variant font use, prefer TMP layout/material override backed by the original TMP row over parent route-item deactivation.

## Generated Files

- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_route_cluster_hierarchy_analysis.json`
- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_route_cluster_nodes.csv`
- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_route_cluster_components.csv`
- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_route_cluster_duplicate_texts.csv`
