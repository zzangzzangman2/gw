# MainInterface Navigation Target Sprite Atlas Slice Join Result

Generated: 2026-06-25 18:19:23 KST

## Verdict

UI_GuildMain top white areas were joined by original prefab hierarchy path to serialized `m_Sprite` PPtr evidence. No coordinate override, fake panel, debug overlay, or whole-atlas Image assignment was used. Confirmed SpriteRes bundles are preloaded so Unity can resolve the original Sprite slices during prefab instantiate.

## Counts

| Metric | Count |
| --- | ---: |
| Top white areas analyzed | `30` |
| Resolved top white areas | `24` |
| Unresolved top white areas | `6` |
| Resolved unique missing refs | `13` |
| Confirmed dependency bundles | `2` |
| Direct sprite/crop overrides | `0` |

## Confirmed Sprite Dependencies

| Bundle | Clean UnityFS path |
| --- | --- |
| `download/artsources/uispriteres/uicommonother.assetbundle` | `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\extracted\unity\clean_unityfs_slices\download\artsources\uispriteres\uicommonother.assetbundle` |
| `download/artsources/uispriteres/uiguild.assetbundle` | `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\extracted\unity\clean_unityfs_slices\download\artsources\uispriteres\uiguild.assetbundle` |

## UI_GuildMain Top Ref Join

| Rank | Missing ref | Original path | Sprite | Bundle | Confidence | Reason |
| ---: | --- | --- | --- | --- | --- | --- |
| `1` | `missing#53252` | `UI_GuildMain/middle/Image` | `guild_tmqj` (`4660243182255679956`) | `download/artsources/uispriteres/uiguild.assetbundle` | `confirmed_original_hierarchy_sprite_path_id` | `` |
| `2` | `missing#49778` | `UI_GuildMain/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa1/bg_ditu` | `T_tianxiazhengba` (`-8340595513483815996`) | `download/artsources/uispriteres/uiguild.assetbundle` | `confirmed_original_hierarchy_sprite_path_id` | `` |
| `3` | `missing#53218` | `UI_GuildMain/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa3/bg_ditu` | `T_tongmenghezhan` (`-7852898000241823806`) | `download/artsources/uispriteres/uiguild.assetbundle` | `confirmed_original_hierarchy_sprite_path_id` | `` |
| `4` | `missing#53260` | `UI_GuildMain/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa4/bg_ditu` | `T_juntuanshilian` (`7184576713228992994`) | `download/artsources/uispriteres/uiguild.assetbundle` | `confirmed_original_hierarchy_sprite_path_id` | `` |
| `5` | `missing#53270` | `UI_GuildMain/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa5/bg_ditu` | `hufu_rukouda` (`8708379610202915794`) | `download/artsources/uispriteres/uiguild.assetbundle` | `confirmed_original_hierarchy_sprite_path_id` | `` |
| `6` | `missing#53222` | `UI_GuildMain/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa6/bg_ditu` | `huachuanbisairukou` (`-6790297150442701508`) | `download/artsources/uispriteres/uiguild.assetbundle` | `confirmed_original_hierarchy_sprite_path_id` | `` |
| `7` | `missing#53254` | `UI_GuildMain/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa7/img_award_cup` | `T_yanchang1` (`5105025851456227429`) | `download/artsources/uispriteres/uiguild.assetbundle` | `confirmed_original_hierarchy_sprite_path_id` | `` |
| `8` | `missing#53238` | `UI_GuildMain/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa7/img_award_cup2` | `T_yanchang3` (`-2200601506677780780`) | `download/artsources/uispriteres/uiguild.assetbundle` | `confirmed_original_hierarchy_sprite_path_id` | `` |
| `9` | `missing#53256` | `UI_GuildMain/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa7/img_award_preheat` | `T_yanchangx` (`5442454674963506861`) | `download/artsources/uispriteres/uiguild.assetbundle` | `confirmed_original_hierarchy_sprite_path_id` | `` |
| `10` | `missing#53242` | `UI_GuildMain/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa8/bg_ditu` | `lsmj_rukou` (`220566425327702820`) | `download/artsources/uispriteres/uiguild.assetbundle` | `confirmed_original_hierarchy_sprite_path_id` | `` |
| `11` | `missing#53250` | `UI_GuildMain/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa9/img_award_cup` | `snls_rk_01` (`2648960642312224647`) | `download/artsources/uispriteres/uiguild.assetbundle` | `confirmed_original_hierarchy_sprite_path_id` | `` |
| `12` | `` | `UI_GuildMain/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa3/im_renwu` | `` (`0`) | `` | `unresolved` | `original_image_m_Sprite_is_null_or_runtime_bound` |
| `13` | `` | `UI_GuildMain/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa4/im_renwu` | `` (`0`) | `` | `unresolved` | `original_image_m_Sprite_is_null_or_runtime_bound` |
| `14` | `` | `UI_GuildMain/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa5/im_renwu` | `` (`0`) | `` | `unresolved` | `original_image_m_Sprite_is_null_or_runtime_bound` |
| `15` | `` | `UI_GuildMain/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa6/im_renwu` | `` (`0`) | `` | `unresolved` | `original_image_m_Sprite_is_null_or_runtime_bound` |
| `16` | `` | `UI_GuildMain/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa8/im_renwu` | `` (`0`) | `` | `unresolved` | `original_image_m_Sprite_is_null_or_runtime_bound` |
| `17` | `` | `UI_GuildMain/middle/node_gonggao/gongao_bg/gonggaoMask` | `` (`0`) | `` | `unresolved` | `original_image_m_Sprite_is_null_or_runtime_bound` |
| `18` | `missing#53202` | `UI_GuildMain/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa10/guideRoot/lingtu_boxicon` | `wjczbx3` (`7383107375737598934`) | `download/artsources/uispriteres/uicommonother.assetbundle` | `confirmed_original_hierarchy_sprite_path_id` | `` |
| `19` | `missing#53202` | `UI_GuildMain/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa2/titan_boxicon` | `wjczbx3` (`7383107375737598934`) | `download/artsources/uispriteres/uicommonother.assetbundle` | `confirmed_original_hierarchy_sprite_path_id` | `` |
| `20` | `missing#53202` | `UI_GuildMain/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa3/box` | `wjczbx3` (`7383107375737598934`) | `download/artsources/uispriteres/uicommonother.assetbundle` | `confirmed_original_hierarchy_sprite_path_id` | `` |
| `21` | `missing#53202` | `UI_GuildMain/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa4/Boxicon` | `wjczbx3` (`7383107375737598934`) | `download/artsources/uispriteres/uicommonother.assetbundle` | `confirmed_original_hierarchy_sprite_path_id` | `` |
| `22` | `missing#53202` | `UI_GuildMain/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa6/Boxicon` | `wjczbx3` (`7383107375737598934`) | `download/artsources/uispriteres/uicommonother.assetbundle` | `confirmed_original_hierarchy_sprite_path_id` | `` |
| `23` | `missing#53202` | `UI_GuildMain/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa8/box` | `wjczbx3` (`7383107375737598934`) | `download/artsources/uispriteres/uicommonother.assetbundle` | `confirmed_original_hierarchy_sprite_path_id` | `` |
| `24` | `missing#46800` | `UI_GuildMain/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa10/guideRoot/node_tips/itembg` | `T_qipao` (`-2202370261854215715`) | `download/artsources/uispriteres/uicommonother.assetbundle` | `confirmed_original_hierarchy_sprite_path_id` | `` |
| `25` | `missing#46800` | `UI_GuildMain/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa2/node_tips/itembg` | `T_qipao` (`-2202370261854215715`) | `download/artsources/uispriteres/uicommonother.assetbundle` | `confirmed_original_hierarchy_sprite_path_id` | `` |
| `26` | `missing#46800` | `UI_GuildMain/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa3/node_tips/itembg` | `T_qipao` (`-2202370261854215715`) | `download/artsources/uispriteres/uicommonother.assetbundle` | `confirmed_original_hierarchy_sprite_path_id` | `` |
| `27` | `missing#46800` | `UI_GuildMain/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa4/node_tips/itembg` | `T_qipao` (`-2202370261854215715`) | `download/artsources/uispriteres/uicommonother.assetbundle` | `confirmed_original_hierarchy_sprite_path_id` | `` |
| `28` | `missing#46800` | `UI_GuildMain/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa5/node_tips/itembg` | `T_qipao` (`-2202370261854215715`) | `download/artsources/uispriteres/uicommonother.assetbundle` | `confirmed_original_hierarchy_sprite_path_id` | `` |
| `29` | `missing#46800` | `UI_GuildMain/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa6/node_tips/itembg` | `T_qipao` (`-2202370261854215715`) | `download/artsources/uispriteres/uicommonother.assetbundle` | `confirmed_original_hierarchy_sprite_path_id` | `` |
| `30` | `missing#46800` | `UI_GuildMain/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa8/node_tips/itembg` | `T_qipao` (`-2202370261854215715`) | `download/artsources/uispriteres/uicommonother.assetbundle` | `confirmed_original_hierarchy_sprite_path_id` | `` |

## Before / After Capture

| Metric | Before trace | After sprite join |
| --- | ---: | ---: |
| UI_GuildMain white no-sprite Images | `731` | `78` |
| UI_GuildMain missing Image sprites | `814` | `152` |
| UI_GuildMain missing script objects | `881` | `881` |
| UI_GuildMain capture path | `after_trace_fix` | `Assets/RestoreCaptures/navigation_targets_after_sprite_join/UI_GuildMain_1680x720.png` |

## Verification

| Check | Result |
| --- | --- |
| Join JSON | `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\maininterface_navigation_target_sprite_atlas_slice_join.json (37422 bytes)` |
| Join CSV | `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_navigation_target_sprite_atlas_slice_join.csv (18656 bytes)` rows=`30` |
| After join capture JSON | `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\maininterface_navigation_target_sprite_atlas_slice_join_capture.json (6681 bytes)` |
| Capture targets | `5/5` success, blank suspicion `0` |
| Click validation generatedAt | `2026-06-25 18:19:23` |
| Active / clickable / blocked / invoked | `24` / `24` / `0` / `24` |
| Tool | `C:\Users\godho\Downloads\girlswar\_restore_tools\106_JOIN_MAININTERFACE_NAVIGATION_TARGET_SPRITE_ATLAS_SLICES.cmd` |

## Unresolved Blocker

Some top white areas have original `m_Sprite` set to null (`m_FileID=0`, `m_PathID=0`), especially runtime-bound character/news nodes. These need target runtime Lua/XLua initialization or script/type reconstruction evidence; they were not guessed.

## Next Recommendation

Next: `remaining navigation target sprite joins`

## Generated Files

- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\maininterface_navigation_target_sprite_atlas_slice_join.json`
- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_navigation_target_sprite_atlas_slice_join.csv`
- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\maininterface_navigation_target_sprite_atlas_slice_join_capture.json`
- `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_NAVIGATION_TARGET_SPRITE_ATLAS_SLICE_JOIN_RESULT.md`