# Battle HUD Runtime Binding + Sprite PPtr Visual Trace Result

## User-Visible Verdict
- 아직 원본 전투 HUD 아님.
- clip05의 HP/VS, 하단 actor/skill cards, 오른쪽 세로 control sprite 형태와 일치하지 않습니다.
- debug/evidence text, placeholder block, 검은 화면, 정적 zone pass는 성공 기준이 아닙니다.

## Verdict First
- visual_status: `failed_missing_runtime_binding`
- matches_clip05_static_hud_layout: `False`
- camera_visible_hud: `True`
- camera_visible_original_hud: `False`
- placeholder_block_visible: `True`
- battle20_top_bottom_right_zone_false_positive: `True`
- video_clip05_contact_compared: `True`
- visible_original_sprite_count: `0`
- visible_original_sprite_candidate_count: `146`
- visible_placeholder_block_count: `16`
- nextBlocker: `BATTLE_22_BATTLE_HUD_SPRITE_PPTR_DEEP_TRACE_AND_RUNTIME_LUA_BINDING`

## What This Means Visually
- The current capture is still not the original clip05 battle HUD.
- The camera can see live UI hierarchy, but placeholder/default Image blocks still cover the layout and create false positives.
- Contact-sheet comparison remains the gate: if it does not look like play.mp4 clip05, this stage is failed.
- No fake HUD, arbitrary icon replacement, whole-atlas Image placement, or coordinate-only fix was applied.

## Counts
- component rows: `505`
- active/visible component count: `275`
- PPtr join matched rows: `445`
- capture visualization fix applied: `True`
- fixApplied: `False`

## Unresolved Reason Counts
- `resolved_or_inactive`: `249`
- `sprite_pptr_unresolved`: `188`
- `font_pptr_unresolved`: `68`

## Outputs
- Unity trace JSON: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_HUD_RUNTIME_BINDING_SPRITE_PPTR_TRACE.json`
- Components CSV: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_HUD_RUNTIME_BINDING_SPRITE_PPTR_TRACE_COMPONENTS.csv`
- Report JSON: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_HUD_RUNTIME_BINDING_SPRITE_PPTR_TRACE_RESULT.json`
- Live capture: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreCaptures\battle_hud\BattleHudRuntimeBindingSpritePptrTrace_1680x720.png`
- Contact sheet: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_21_HUD_RUNTIME_BINDING_SPRITE_PPTR_TRACE_CONTACT_SHEET.jpg`

## Lua / XLua / IL2CPP Handler Hints
- `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_FLOW_WITH_HUD_ATTACH_RESULT.json:4`     "ui_normalbattle.prefab",
- `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_FLOW_WITH_HUD_ATTACH_RESULT.json:5`     "ui_battle3dui.prefab",
- `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_FLOW_WITH_HUD_ATTACH_RESULT.json:6`     "ui_normalbattle_heroitem.prefab",
- `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_FLOW_WITH_HUD_ATTACH_RESULT.json:9`     "ui_normalbattle_pause.prefab",
- `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_FLOW_WITH_HUD_ATTACH_RESULT.json:10`     "ui_normalbattle_skipview.prefab",
- `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua\-3029001242551076572_UI_Flower_Complete_Tips_security_xor_raw.lua:75` elseif GameEntry.Procedure.CurrProcedureState==CS.YouYou.ProcedureState.NormalBattle then
- `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_procedure\-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua:3` require"Modules/Battle/BattleSkillEffectManager"
- `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_procedure\-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua:8` require"Modules/Battle/HeroSkillInfo"
- `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_procedure\-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua:20` local y=require("DataNode/DataTable/Create/skillAct/DTSkillActDBModel")
- `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_procedure\-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua:38` DTSkillPasDBModel,
- `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_procedure\-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua:41` DTTreasureSkillDBModel,
- `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_procedure\-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua:58` e.GameSpeed=1
- `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_procedure\-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua:59` e.GameFastSkill=false
- `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_procedure\-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua:60` e.GameFastSkillPlayFirstAnimMap={}
- `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_procedure\-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua:100` e.CurrSkillMinStopTime=0
- `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_procedure\-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua:105` e.CurrSkillAttackType=0
- `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_procedure\-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua:114` e.IsAutoMode=false
- `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_procedure\-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua:150` e.autoExitGuideBattle=true
- `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_procedure\-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua:159` e.IsAutoCloseSkipView=true

## BATTLE_22 Recommendation
- `BATTLE_22_BATTLE_HUD_SPRITE_PPTR_DEEP_TRACE_AND_RUNTIME_LUA_BINDING`
