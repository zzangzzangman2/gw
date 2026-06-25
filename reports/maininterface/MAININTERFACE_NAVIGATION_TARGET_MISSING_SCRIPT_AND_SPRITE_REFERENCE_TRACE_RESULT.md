# MainInterface Navigation Target Missing Script And Sprite Reference Trace Result

Generated: 2026-06-25 18:05:15 KST

## Verdict

5개 navigation target prefab을 실제 instantiate한 상태에서 Image/RawImage/Text/TMP/Button/MonoBehaviour 상태를 분리했다. 좌표 보정이나 synthetic panel은 적용하지 않았고, 원본 prefab hierarchy/RectTransform/local id와 SerializedObject reference evidence만 기록했다.

## Counts

| Metric | Count |
| --- | ---: |
| Targets traced | `5` |
| Total Image components | `1013` |
| Total Image null sprite | `956` |
| Total white no-sprite Image | `861` |
| Total missing script components | `1139` |
| Total missing script objects | `1080` |
| Applied sprite/slice fixes | `0` |

## Target Breakdown

| Target | Images | Null sprite | Resolved sprite | White no-sprite | Missing script comps | Missing script objects | Buttons | TMP | Blocker |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| `UI_AdventureInterface` | `63` | `60` | `3` | `60` | `137` | `131` | `14` | `23` | `white_no_sprite_images_remain; serialized sprite refs are null/missing and need original script-driven binding or explicit sprite pathID evidence` |
| `UI_GuildMain` | `868` | `814` | `54` | `731` | `930` | `881` | `212` | `373` | `white_no_sprite_images_remain; serialized sprite refs are null/missing and need original script-driven binding or explicit sprite pathID evidence` |
| `UI_JingjiFrame` | `24` | `24` | `0` | `21` | `46` | `45` | `12` | `16` | `white_no_sprite_images_remain; serialized sprite refs are null/missing and need original script-driven binding or explicit sprite pathID evidence` |
| `UI_SystemSettings` | `47` | `47` | `0` | `41` | `17` | `15` | `22` | `13` | `white_no_sprite_images_remain; serialized sprite refs are null/missing and need original script-driven binding or explicit sprite pathID evidence` |
| `UI_PlayBgDownload` | `11` | `11` | `0` | `8` | `9` | `8` | `3` | `8` | `white_no_sprite_images_remain; serialized sprite refs are null/missing and need original script-driven binding or explicit sprite pathID evidence` |

## UI_GuildMain Top White Areas

| Rank | Hierarchy path | Area | Size | Local id | Sprite ref | Cause | Active |
| ---: | --- | ---: | --- | ---: | --- | --- | --- |
| `1` | `UI_GuildMain_NavigationPrototype/middle/Image` | `273700.0` | `1700.0x161.0` | `0` | `missing#53252` | `missing_sprite_serialized_reference` | `True` |
| `2` | `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa1/bg_ditu` | `110004.0` | `267.0x412.0` | `0` | `missing#49778` | `missing_sprite_serialized_reference` | `True` |
| `3` | `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa3/bg_ditu` | `110004.0` | `267.0x412.0` | `0` | `missing#53218` | `missing_sprite_serialized_reference` | `True` |
| `4` | `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa4/bg_ditu` | `110004.0` | `267.0x412.0` | `0` | `missing#53260` | `missing_sprite_serialized_reference` | `True` |
| `5` | `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa5/bg_ditu` | `110004.0` | `267.0x412.0` | `0` | `missing#53270` | `missing_sprite_serialized_reference` | `False` |
| `6` | `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa6/bg_ditu` | `110004.0` | `267.0x412.0` | `0` | `missing#53222` | `missing_sprite_serialized_reference` | `True` |
| `7` | `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa7/img_award_cup` | `110004.0` | `267.0x412.0` | `0` | `missing#53254` | `missing_sprite_serialized_reference` | `True` |
| `8` | `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa7/img_award_cup2` | `110004.0` | `267.0x412.0` | `0` | `missing#53238` | `missing_sprite_serialized_reference` | `True` |
| `9` | `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa7/img_award_preheat` | `110004.0` | `267.0x412.0` | `0` | `missing#53256` | `missing_sprite_serialized_reference` | `True` |
| `10` | `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa8/bg_ditu` | `110004.0` | `267.0x412.0` | `0` | `missing#53242` | `missing_sprite_serialized_reference` | `True` |
| `11` | `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa9/img_award_cup` | `110004.0` | `267.0x412.0` | `0` | `missing#53250` | `missing_sprite_serialized_reference` | `True` |
| `12` | `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa3/im_renwu` | `81788.0` | `254.0x322.0` | `0` | `` | `null_sprite_no_serialized_reference` | `False` |
| `13` | `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa4/im_renwu` | `81788.0` | `254.0x322.0` | `0` | `` | `null_sprite_no_serialized_reference` | `False` |
| `14` | `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa5/im_renwu` | `81788.0` | `254.0x322.0` | `0` | `` | `null_sprite_no_serialized_reference` | `False` |
| `15` | `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa6/im_renwu` | `81788.0` | `254.0x322.0` | `0` | `` | `null_sprite_no_serialized_reference` | `False` |
| `16` | `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa8/im_renwu` | `81788.0` | `254.0x322.0` | `0` | `` | `null_sprite_no_serialized_reference` | `False` |
| `17` | `UI_GuildMain_NavigationPrototype/middle/node_gonggao/gongao_bg/gonggaoMask` | `51645.0` | `-175.0x62.599998474121094` | `0` | `` | `null_sprite_no_serialized_reference` | `True` |
| `18` | `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa10/guideRoot/lingtu_boxicon` | `45496.0` | `242.0x188.0` | `0` | `missing#53202` | `missing_sprite_serialized_reference` | `True` |
| `19` | `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa2/titan_boxicon` | `45496.0` | `242.0x188.0` | `0` | `missing#53202` | `missing_sprite_serialized_reference` | `True` |
| `20` | `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa3/box` | `45496.0` | `242.0x188.0` | `0` | `missing#53202` | `missing_sprite_serialized_reference` | `True` |
| `21` | `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa4/Boxicon` | `45496.0` | `242.0x188.0` | `0` | `missing#53202` | `missing_sprite_serialized_reference` | `True` |
| `22` | `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa6/Boxicon` | `45496.0` | `242.0x188.0` | `0` | `missing#53202` | `missing_sprite_serialized_reference` | `True` |
| `23` | `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa8/box` | `45496.0` | `242.0x188.0` | `0` | `missing#53202` | `missing_sprite_serialized_reference` | `True` |
| `24` | `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa10/guideRoot/node_tips/itembg` | `44400.0` | `296.0x150.0` | `0` | `missing#46800` | `missing_sprite_serialized_reference` | `False` |
| `25` | `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa2/node_tips/itembg` | `44400.0` | `296.0x150.0` | `0` | `missing#46800` | `missing_sprite_serialized_reference` | `False` |
| `26` | `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa3/node_tips/itembg` | `44400.0` | `296.0x150.0` | `0` | `missing#46800` | `missing_sprite_serialized_reference` | `False` |
| `27` | `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa4/node_tips/itembg` | `44400.0` | `296.0x150.0` | `0` | `missing#46800` | `missing_sprite_serialized_reference` | `False` |
| `28` | `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa5/node_tips/itembg` | `44400.0` | `296.0x150.0` | `0` | `missing#46800` | `missing_sprite_serialized_reference` | `False` |
| `29` | `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa6/node_tips/itembg` | `44400.0` | `296.0x150.0` | `0` | `missing#46800` | `missing_sprite_serialized_reference` | `False` |
| `30` | `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa8/node_tips/itembg` | `44400.0` | `296.0x150.0` | `0` | `missing#46800` | `missing_sprite_serialized_reference` | `False` |

## Evidence Interpretation

- `Image component exists but sprite is null` is the dominant class. These are not missing UnityEngine.UI.Image components.
- `null_sprite_no_serialized_reference` on the largest `UI_GuildMain` white areas means the loaded prefab does not carry a direct serialized Sprite reference that can be safely mapped to a slice in this pass.
- Missing MonoBehaviour counts remain high, so many visual elements are likely initialized by original Lua/XLua/controller scripts after prefab load.
- No sprite/slice fix was applied because no top white area produced a concrete original sprite pathID/name/fileID evidence chain. Whole-atlas fallback was intentionally not used.

## After Trace Capture

| Metric | Count |
| --- | ---: |
| Captures | `5` |
| Capture success | `5` |
| Blank suspicion | `0` |
| White placeholder suspicion | `5` |

## Verification

| Check | Result | Evidence |
| --- | --- | --- |
| Trace JSON | `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\maininterface_navigation_target_missing_script_sprite_trace.json (197421 bytes)` | `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\logs\unity_maininterface_navigation_target_missing_script_sprite_trace.log` |
| Trace CSV | `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_navigation_target_missing_script_sprite_trace.csv (30820 bytes)` | rows=`119` |
| Trace capture JSON | `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\maininterface_navigation_target_missing_script_sprite_trace_capture.json (6672 bytes)` | after trace capture directory |
| Click validation generatedAt | `2026-06-25 18:05:20` | `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_click_validation_summary.json` |
| Active / clickable / blocked / invoked | `24` / `24` / `0` / `24` | `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\logs\unity_maininterface_button_navigation_click_validation.log` |
| Tool | `C:\Users\godho\Downloads\girlswar\_restore_tools\105_TRACE_MAININTERFACE_NAVIGATION_TARGET_MISSING_SCRIPT_AND_SPRITES.cmd` | no source/evidence deletion |

## Recommendation

Next: `sprite/atlas slice join`

Video reference note: `C:\Users\godho\Downloads\플레이.mp4` and `reports\video_reference\PLAY_REFERENCE_RESTORE_NOTES.md` are now treated as UI flow/transition priority evidence for later validation, while the persistent top-center circular overlay is treated as a recording/touch artifact and must not be restored into final UI.

## Generated Files

- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\maininterface_navigation_target_missing_script_sprite_trace.json`
- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_navigation_target_missing_script_sprite_trace.csv`
- `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_NAVIGATION_TARGET_MISSING_SCRIPT_AND_SPRITE_REFERENCE_TRACE_RESULT.md`
