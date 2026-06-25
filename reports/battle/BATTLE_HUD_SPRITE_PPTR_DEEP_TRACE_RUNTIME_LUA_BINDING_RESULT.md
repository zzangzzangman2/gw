# Battle HUD Sprite PPtr Deep Trace + Runtime Lua Binding Result

## User-Visible Verdict
- 아직 원본 전투 HUD 아님.
- clip05의 HP/VS, 하단 actor/skill cards, 오른쪽 세로 control sprite 형태와 일치하지 않습니다.
- 이번 단계는 fix가 아니라 PPtr/external bundle/runtime binding blocker 추적입니다.

## Verdict First
- visual_status: `failed_missing_runtime_binding`
- matches_clip05_static_hud_layout: `False`
- camera_visible_original_hud: `False`
- placeholder_block_visible: `True`
- visible_original_sprite_count: `0`
- visible_placeholder_block_count: `16`
- fixApplied: `False`
- nextBlocker: `BATTLE_23_LOAD_MISSING_HUD_EXTERNAL_DEPENDENCIES_AND_VALIDATE_CLIP05_VISUAL`

## Video Gate
- Reference/contact: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_21_HUD_RUNTIME_BINDING_SPRITE_PPTR_TRACE_CONTACT_SHEET.jpg`
- BATTLE_20/BATTLE_21 top/bottom/right zone pass is treated as false positive unless sprite shapes match clip05.

## Deep Reason Counts
- `resolved_external_candidate_not_loaded_runtime`: `207`
- `external_bundle_not_loaded`: `79`
- `unknown`: `67`
- `font_bundle_missing`: `62`
- `custom_youyouimage_binding`: `59`
- `runtime_lua_set_image_sprite`: `16`
- `sprite_pptr_unresolved`: `9`
- `font_pptr_unresolved`: `6`

## Highest Priority Placeholder Rows
| priority | zone | path | sprite PPtr | external bundle | status | reason |
| ---: | --- | --- | --- | --- | --- | --- |
| 1425 | top+bottom | `BattleHudRuntimeBindingTraceLiveHudRoot/RuntimeTraceHUD_01_ui_normalbattle/root_opra/root_buff/im_bg_left` | `6:-8109585734443225392` | `download/artsources/uispriteres/uicommonother.assetbundle` | `resolved_sprite` | `external_bundle_not_loaded` |
| 1425 | top+bottom+right | `BattleHudRuntimeBindingTraceLiveHudRoot/RuntimeTraceHUD_01_ui_normalbattle/root_opra/root_buff/im_bg_right` | `6:-8109585734443225392` | `download/artsources/uispriteres/uicommonother.assetbundle` | `resolved_sprite` | `external_bundle_not_loaded` |
| 1425 | top | `BattleHudRuntimeBindingTraceLiveHudRoot/RuntimeTraceHUD_01_ui_normalbattle/root_opra/root_buff/root_buff_left/grid_all_buff_left/item_buff_left_1/ScrollViewGrid` | `0:0` | `` | `empty_pptr` | `runtime_lua_set_image_sprite` |
| 1425 | bottom | `BattleHudRuntimeBindingTraceLiveHudRoot/RuntimeTraceHUD_01_ui_normalbattle/root_opra/root_buff/root_buff_left/grid_all_buff_left/item_buff_left_4/ScrollViewGrid` | `0:0` | `` | `empty_pptr` | `runtime_lua_set_image_sprite` |
| 1425 | bottom | `BattleHudRuntimeBindingTraceLiveHudRoot/RuntimeTraceHUD_01_ui_normalbattle/root_opra/root_buff/root_buff_left/grid_all_buff_left/item_buff_left_5/ScrollViewGrid` | `0:0` | `` | `empty_pptr` | `runtime_lua_set_image_sprite` |
| 1425 | top | `BattleHudRuntimeBindingTraceLiveHudRoot/RuntimeTraceHUD_01_ui_normalbattle/root_opra/root_buff/root_buff_right/grid_all_buff_right/item_buff_right_1/ScrollViewGrid` | `0:0` | `` | `empty_pptr` | `runtime_lua_set_image_sprite` |
| 1425 | bottom | `BattleHudRuntimeBindingTraceLiveHudRoot/RuntimeTraceHUD_01_ui_normalbattle/root_opra/root_buff/root_buff_right/grid_all_buff_right/item_buff_right_4/ScrollViewGrid` | `0:0` | `` | `empty_pptr` | `runtime_lua_set_image_sprite` |
| 1425 | bottom | `BattleHudRuntimeBindingTraceLiveHudRoot/RuntimeTraceHUD_01_ui_normalbattle/root_opra/root_buff/root_buff_right/grid_all_buff_right/item_buff_right_5/ScrollViewGrid` | `0:0` | `` | `empty_pptr` | `runtime_lua_set_image_sprite` |
| 1425 | right | `BattleHudRuntimeBindingTraceLiveHudRoot/RuntimeTraceHUD_01_ui_normalbattle/root_opra/btnSkip/boxcollider` | `0:0` | `` | `empty_pptr` | `sprite_pptr_unresolved` |
| 1425 | top+bottom+right | `BattleHudRuntimeBindingTraceLiveHudRoot/RuntimeTraceHUD_01_ui_normalbattle/btn_preivew_touch` | `` | `` | `empty_pptr` | `unknown` |
| 1400 | middle | `BattleHudRuntimeBindingTraceLiveHudRoot/RuntimeTraceHUD_01_ui_normalbattle/root_opra/root_buff/root_buff_left/grid_all_buff_left/item_buff_left_2/ScrollViewGrid` | `0:0` | `` | `empty_pptr` | `runtime_lua_set_image_sprite` |
| 1400 | middle | `BattleHudRuntimeBindingTraceLiveHudRoot/RuntimeTraceHUD_01_ui_normalbattle/root_opra/root_buff/root_buff_left/grid_all_buff_left/item_buff_left_3/ScrollViewGrid` | `0:0` | `` | `empty_pptr` | `runtime_lua_set_image_sprite` |
| 1400 | middle | `BattleHudRuntimeBindingTraceLiveHudRoot/RuntimeTraceHUD_01_ui_normalbattle/root_opra/root_buff/root_buff_left/btnLeftClosebuff/boxcollider` | `0:0` | `` | `empty_pptr` | `runtime_lua_set_image_sprite` |
| 1400 | middle | `BattleHudRuntimeBindingTraceLiveHudRoot/RuntimeTraceHUD_01_ui_normalbattle/root_opra/root_buff/root_buff_right/grid_all_buff_right/item_buff_right_2/ScrollViewGrid` | `0:0` | `` | `empty_pptr` | `runtime_lua_set_image_sprite` |
| 1400 | middle | `BattleHudRuntimeBindingTraceLiveHudRoot/RuntimeTraceHUD_01_ui_normalbattle/root_opra/root_buff/root_buff_right/grid_all_buff_right/item_buff_right_3/ScrollViewGrid` | `0:0` | `` | `empty_pptr` | `runtime_lua_set_image_sprite` |
| 1400 | middle | `BattleHudRuntimeBindingTraceLiveHudRoot/RuntimeTraceHUD_01_ui_normalbattle/root_opra/root_buff/root_buff_right/btnRightClosebuff/boxcollider` | `0:0` | `` | `empty_pptr` | `runtime_lua_set_image_sprite` |

## Runtime Lua / XLua / IL2CPP Binding Evidence
### ui_open_load
- `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_procedure\-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua:797` EventSystem.AddListener(CommonEventId.OnBattleUILoadComplete,e.OnBattleUILoadComplete)
- `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_procedure\-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua:910` EventSystem.RemoveListener(CommonEventId.OnBattleUILoadComplete,e.OnBattleUILoadComplete)
- `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_procedure\-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua:1876` e.OnBattleUILoadComplete()
- `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_procedure\-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua:1888` function t.OnBattleUILoadComplete()
### runtime_state_binding
- `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_procedure\-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua:206` function t.SetLeftInfo(t,a,i,o,n)
- `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_procedure\-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua:209` function t.SetRightInfo(i,n,o,t,a)
- `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_procedure\-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua:805` EventSystem.AddListener(CommonEventId.ProcedureNormalBattle_ShowHeadBar,e.OnShowHeadBar)
- `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_procedure\-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua:918` EventSystem.RemoveListener(CommonEventId.ProcedureNormalBattle_ShowHeadBar,e.OnShowHeadBar)
- `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_procedure\-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua:1444` e.SetLeftInfo(PlayerMgr.PlayerInfo.head,nil,PlayerMgr.PlayerInfo.name,PlayerMgr.PlayerInfo.level)
- `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_procedure\-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua:1446` e.SetRightInfo(0,a.Icon,GameTools.GetLocalize(a.Name,LanguageCategory.LangBattle),a.level,"UILEliteAdventure/IC_touxiangkuang")
- `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_procedure\-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua:1453` e.SetLeftInfo(PlayerMgr.PlayerInfo.head,nil,PlayerMgr.PlayerInfo.name,PlayerMgr.PlayerInfo.level)
- `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_procedure\-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua:1455` e.SetRightInfo(0,a.Icon,GameTools.GetLocalize(a.Name,LanguageCategory.LangBattle),a.level,"UILEliteAdventure/IC_touxiangkuang")
- `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_procedure\-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua:1462` e.SetLeftInfo(PlayerMgr.PlayerInfo.head,nil,PlayerMgr.PlayerInfo.name,PlayerMgr.PlayerInfo.level)
- `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_procedure\-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua:1464` e.SetRightInfo(0,a.Icon,GameTools.GetLocalize(a.Name,LanguageCategory.LangBattle),a.level,"UILEliteAdventure/IC_touxiangkuang")
### button_controls
- `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_procedure\-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua:58` e.GameSpeed=1
- `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_procedure\-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua:59` e.GameFastSkill=false
- `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_procedure\-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua:60` e.GameFastSkillPlayFirstAnimMap={}
- `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_procedure\-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua:114` e.IsAutoMode=false
- `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_procedure\-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua:115` e.IsSkipBattle=false
- `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_procedure\-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua:150` e.autoExitGuideBattle=true
- `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_procedure\-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua:159` e.IsAutoCloseSkipView=true
- `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_procedure\-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua:194` e.openSkipFromOut=true
- `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_procedure\-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua:218` function t.SetAutoExitGuideBattle(t)
- `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_procedure\-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua:219` e.autoExitGuideBattle=t
### hide_show_motion
- none
### sprite_setters
- `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_procedure\-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua:1446` e.SetRightInfo(0,a.Icon,GameTools.GetLocalize(a.Name,LanguageCategory.LangBattle),a.level,"UILEliteAdventure/IC_touxiangkuang")
- `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_procedure\-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua:1455` e.SetRightInfo(0,a.Icon,GameTools.GetLocalize(a.Name,LanguageCategory.LangBattle),a.level,"UILEliteAdventure/IC_touxiangkuang")
- `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_procedure\-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua:1464` e.SetRightInfo(0,a.Icon,GameTools.GetLocalize(a.Name,LanguageCategory.LangBattle),a.level,"UILEliteAdventure/IC_touxiangkuang")
- `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_procedure\-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua:1473` e.SetRightInfo(0,a.Icon,GameTools.GetLocalize(a.Name,LanguageCategory.LangBattle),a.level,"UILEliteAdventure/IC_touxiangkuang")
- `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_procedure\-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua:1480` e.SetRightInfo(0,a.Icon,GameTools.GetLocalize(a.Name,LanguageCategory.LangBattle),a.level)
- `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_procedure\-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua:1487` e.SetRightInfo(0,a.Icon,GameTools.GetLocalize(a.Name,LanguageCategory.LangBattle),a.level)
- `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_procedure\-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua:1728` e.SetRightInfo(0,t.Icon,GameTools.GetLocalize(t.Name,LanguageCategory.LangBattle),t.level)
- `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_procedure\-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua:1736` e.SetRightInfo(0,t.Icon,GameTools.GetLocalize(t.Name,LanguageCategory.LangBattle),t.level,"UILEliteAdventure/IC_touxiangkuang")
- `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_procedure\-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua:1744` e.SetRightInfo(0,t.Icon,GameTools.GetLocalize(t.Name,LanguageCategory.LangBattle),t.level,"UILEliteAdventure/IC_touxiangkuang")
- `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_procedure\-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua:1752` e.SetRightInfo(0,t.Icon,GameTools.GetLocalize(t.Name,LanguageCategory.LangBattle),t.level,"UILEliteAdventure/IC_touxiangkuang")

## Outputs
- Unity data JSON: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_HUD_SPRITE_PPTR_DEEP_TRACE_RUNTIME_LUA_BINDING.json`
- Components CSV: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_HUD_SPRITE_PPTR_DEEP_TRACE_RUNTIME_LUA_BINDING_COMPONENTS.csv`
- Report JSON: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_HUD_SPRITE_PPTR_DEEP_TRACE_RUNTIME_LUA_BINDING_RESULT.json`

## BATTLE_23 Recommendation
- `BATTLE_23_LOAD_MISSING_HUD_EXTERNAL_DEPENDENCIES_AND_VALIDATE_CLIP05_VISUAL`
