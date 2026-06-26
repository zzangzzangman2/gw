# MainInterface 122 Home Reference Route Runtime State Trace Result

Generated: 2026-06-26 00:41:26 KST

## Verdict

Not restored. The actual reference is a character lobby/home screen, while the current captures are route/world-cluster state over a castle background.

No evidence-backed visual patch was applied in UI122. Hiding `wanfaWorldNode`, `worldwanfaBtn`, `zhuye_di1`, or `zhuye_bian` would be an arbitrary visual match because decoded `UI_MainPage` does not provide normal-home SetActive evidence that disables the world button, and UI121 confirms `zhuye_di1/zhuye_bian` are pre-clipping original attachments.

## Image Comparison

| image | exists | size | bytes | notes |
| --- | ---: | --- | ---: | --- |
| `C:\Users\godho\.codex\attachments\e607fc34-b674-4516-b051-8d396cd6df06\image-1.png` | `True` | `1180x526` | `1233287` | `meanRgb=150.71,125.425,137.716` |
| `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreCaptures\maininterface_restored_1680x720.png` | `True` | `1680x720` | `1525113` | `meanRgb=158.745,174.519,190.771` |
| `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreCaptures\maininterface_route_spine_runtime_ui_material_bound_1680x720.png` | `True` | `1680x720` | `1447439` | `meanRgb=161.743,177.368,194.625` |

- `maininterface_restored_1680x720.png` vs reference: `mismatch`, meanAbsDiff=`89.042`, rmsDiff=`61.669`.
- `maininterface_route_spine_runtime_ui_material_bound_1680x720.png` vs reference: `mismatch`, meanAbsDiff=`89.053`, rmsDiff=`61.761`.

## Active-State Evidence

| key | active | sibling | father | anchored | size | scale | children |
| --- | --- | ---: | --- | --- | --- | --- | ---: |
| `UI_MainInterface` | `True` | `None` | `0` | `0.0,0.0` | `0.0,0.0` | `0.0,0.0,0.0` | `15` |
| `UI_bg` | `True` | `0` | `5568884429252053541` | `0.0,0.0` | `1680.0,720.0` | `1.0,1.0,1.0` | `0` |
| `UI_heroSpine` | `True` | `1` | `5568884429252053541` | `0.0,0.0` | `0.0,0.0` | `1.0,1.0,1.0` | `0` |
| `UI_touchSpine` | `True` | `2` | `5568884429252053541` | `-61.0,-28.0` | `650.0,400.0` | `1.0,1.0,1.0` | `0` |
| `right` | `True` | `4` | `5568884429252053541` | `0.0,0.0` | `0.0,0.0` | `1.0,1.0,1.0` | `7` |
| `node_middle` | `True` | `4` | `6922878451781464554` | `-135.0,-100.0` | `0.0,0.0` | `1.0,1.0,1.0` | `5` |
| `wanfaWorldNode` | `True` | `0` | `9056630568254389742` | `-12.0,87.0` | `100.0,100.0` | `1.0,1.0,1.0` | `6` |
| `worldwanfaBtn` | `True` | `0` | `-3820167396480157270` | `-101.0,1.0` | `253.0,253.0` | `1.0,1.0,1.0` | `1` |
| `spine_diqiu` | `True` | `0` | `3512211464843089861` | `0.0,-1.0` | `100.0,100.0` | `1.0,1.0,1.0` | `15` |
| `left` | `True` | `9` | `5568884429252053541` | `-125.0,0.0` | `0.0,0.0` | `1.0,1.0,1.0` | `11` |
| `middle` | `True` | `5` | `5568884429252053541` | `0.0,0.0` | `0.0,0.0` | `1.0,1.0,1.0` | `2` |
| `mask` | `True` | `7` | `5568884429252053541` | `0.0,0.0` | `0.0,100.0` | `1.0,1.0,1.0` | `2` |
| `bg_dibu` | `False` | `14` | `5568884429252053541` | `0.0,-360.0` | `2500.0,48.0` | `1.0,1.0,1.0` | `1` |

The CSV prefab state has `right/node_middle/wanfaWorldNode/worldwanfaBtn/spine_diqiu` active. `MainInterfaceSceneBuilder` preserves `row.active` first, then applies only the override CSV. The current override CSV does not target these route owners for deactivation.

## Lua Evidence

| lines | meaning |
| --- | --- |
| `103-125` | `OnInit` wires right/left buttons and only hides `mian_wanfa_item_3/4` in review mode; no normal-home hide for `wanfaWorldNode/worldwanfaBtn`. |
| `1327-1385` | `refreshRightMiddleView`, `SetLimitPageView`, and `SetActJumpPageView` populate items 1/2 and conditionally hide/show items 3/4. |
| `1419-1489` | `SetFuncShowStatus` gates bottom toggles by function unlock; this supports runtime active-state dependency, not static prefab success. |
| `1491-1560` | `refreshMiddle` chooses the player hero, mounts hero Spine/Live2D, and loads `UI_bg` from `UIUtil.GetPaintingBg(heroId)`. |
| `2896-2897` | `onBtnWorld` jumps to idle/world; it is a click handler, not default route activation evidence. |

## Builder/Material Checks

- Canvas/CanvasScaler: builder creates ScreenSpaceOverlay and ScaleWithScreenSize 1680x720, match 0.5.
- Sibling order: builder replays each CSV parent `child_ids` order. The route cluster is active because the source rows and route visual overrides are active, not because of an observed sibling-order bug.
- TMP: builder loads TMP detail rows including font size, auto-size, material, spacing, wrapping, and color. TMP mismatch remains secondary to the wrong route/home state.
- Mask/stencil/clipping: UI121 says `zhuye_di1/zhuye_bian` are pre-clipping and `zong1` clips later attachments such as `diqiu/yun/yun2`; no evidence supports hiding zhuye.

## Runtime Gaps

- `UI_bg` `-739438087074354188`: status=`ready`, asset=`Assets/RestoredSprites/maininterface/download_uicommonbg_uicommonbg2/fid9_4648636570285078741_noalphabg_BG_changjing_2.png`, alpha=`1.0`.
- `UI_heroSpine` `2247224239628523787`: status=`empty_sprite_ref`, asset=``, alpha=`0.0`.
- `UI_heroSpine` `6569245046781814939`: status=`empty_sprite_ref`, asset=``, alpha=`0.0`.
- `UI_touchSpine` `3101055438495186894`: status=`empty_sprite_ref`, asset=``, alpha=`0.0`.
- `UI_touchSpine` `-1874286104444283317`: status=`empty_sprite_ref`, asset=``, alpha=`0.0`.
- `UI_bg` `-1457103517121630268`: status=`ready`, asset=`Assets/RestoredSprites/maininterface/download_uicommonbg_uicommonbg2/fid9_4648636570285078741_noalphabg_BG_changjing_2.png`, alpha=`0.0`.

## Next Blocker

Reconstruct or simulate the original `UI_MainPage` normal-home runtime pass from evidence: player hero selection, `UIUtil.GetPaintingBg(heroId)`, `UIUtil.GetPlayerBigSpineAll/GetPlayerLive2dModel`, and GameFunction/MainPageLimitMgr active-state results. Until that exists, the current static/route capture must remain failed and should not be judged against the character lobby reference as restored.

## Files

- JSON: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\maininterface_122_home_reference_route_runtime_state_trace.json`
- Tool: `C:\Users\godho\Downloads\girlswar\_restore_tools\cmd_archive\122_TRACE_HOME_REFERENCE_ROUTE_RUNTIME_STATE.cmd`
- Reference: `C:\Users\godho\.codex\attachments\e607fc34-b674-4516-b051-8d396cd6df06\image-1.png`
- Current route capture: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreCaptures\maininterface_route_spine_runtime_ui_material_bound_1680x720.png`
- Current home capture: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreCaptures\maininterface_restored_1680x720.png`

## Command Layout

- root CMDs: `1` ['00_COMMAND_CENTER.cmd']
- `_restore_tools` direct CMDs: `0` []
