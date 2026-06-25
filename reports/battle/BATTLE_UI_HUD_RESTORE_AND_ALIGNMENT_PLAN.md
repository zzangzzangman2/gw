# Battle UI/HUD Restore And Alignment Plan

## Outputs
- Candidates JSON: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_UI_HUD_CANDIDATES.json`
- Bundle probe JSON: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_UI_HUD_BUNDLE_PROBE.json`
- Probe scene: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\Scenes\BattleUIHudEvidenceProbe.unity`
- Unity batchmode success: `True`

## Counts
- HUD candidates: `24`
- Loadable bundles: `24`
- Loadable prefab bundles: `8`
- Prefab roots: `170`
- Canvas / RectTransform / Image / Text+TMP / Button: `19` / `985` / `0` / `0` / `0`
- Sprite candidates: `1407`

## Restore Rules Applied
- Rules file: `C:\Users\godho\Downloads\apk_extracted_ui_restore_rules.txt`
- Do not place whole atlases as UI. Track sprite/region evidence before final placement.
- Do not fake buttons or panels without original prefab/handler evidence. Unknown controls stay unknown/log-only.
- Final HUD must preserve prefab hierarchy, RectTransform anchor/pivot/scale, sibling order, CanvasScaler, font/material evidence, and click/raycast validation logs.
- Battle log/debug-only elements must not be final-screen overlays.

## Immediately Restorable HUD Prefab Candidates
| bundle | prefabs | canvas | scaler | rect | image | text/tmp | button | root sample |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| download/ui/uiprefabandres/battle.assetbundle | 14 | 0 | 0 | 62 | 0 | 0 | 0 | `assets/download/ui/uiprefabandres/battle/effect/bxsjsg.prefab;assets/download/ui/uiprefabandres/battle/effect/ui_touxianghuxi.prefab;assets/download/ui/uiprefabandres/battle/effect/ui_touxiangsg.prefab;assets/download/ui/uiprefabandres/battle/effect/uieff_jiaxue.prefab;assets/download/ui/uiprefabandres/battle/effect/uieff_lanlvjiaxue.prefab;assets/download/ui/uiprefabandres/battle/effect/uieffect_allskillnew.prefab;assets/download/ui/uiprefabandres/battle/effect/uieffect_bigskill.prefab;assets/download/ui/uiprefabandres/battle/effect/uieffect_meili.prefab;assets/download/ui/uiprefabandres/battle/effect/uieffect_normalskill.prefab;assets/download/ui/uiprefabandres/battle/effect/uieffect_smallskill.prefab;assets/download/ui/uiprefabandres/battle/effect/uihttx.prefab;assets/download/ui/uiprefabandres/battle/effect/uishanghua.prefab;assets/download/ui/uiprefabandres/battle/res/fadong/fadong.prefab` |
| download/ui/uiprefabandres/battle_ext_prefabs.assetbundle | 11 | 17 | 0 | 842 | 0 | 0 | 0 | `assets/download/ui/uiprefabandres/battle_ext_prefabs/prefabs/item_buff_left.prefab;assets/download/ui/uiprefabandres/battle_ext_prefabs/prefabs/item_buff_right.prefab;assets/download/ui/uiprefabandres/battle_ext_prefabs/prefabs/ui_battle3dui.prefab;assets/download/ui/uiprefabandres/battle_ext_prefabs/prefabs/ui_battleboxpage.prefab;assets/download/ui/uiprefabandres/battle_ext_prefabs/prefabs/ui_battleitemfly.prefab;assets/download/ui/uiprefabandres/battle_ext_prefabs/prefabs/ui_battlepreviewtalk.prefab;assets/download/ui/uiprefabandres/battle_ext_prefabs/prefabs/ui_normalbattle.prefab;assets/download/ui/uiprefabandres/battle_ext_prefabs/prefabs/ui_normalbattle_heroitem.prefab;assets/download/ui/uiprefabandres/battle_ext_prefabs/prefabs/ui_normalbattle_pause.prefab;assets/download/ui/uiprefabandres/battle_ext_prefabs/prefabs/ui_normalbattle_skipview.prefab;assets/download/ui/uiprefabandres/battle_ext_prefabs/prefabs/ui_testbattle.prefab` |
| download/ui/uiprefabandres/winlose_ext_prefabs.assetbundle | 2 | 0 | 0 | 78 | 0 | 0 | 0 | `assets/download/ui/uiprefabandres/winlose_ext_prefabs/victory_spine_base.prefab;assets/download/ui/uiprefabandres/winlose_ext_prefabs/victory_spine_base2.prefab` |
| download/ui/uiprefabandres/battle_ext_1.assetbundle | 2 | 2 | 0 | 2 | 0 | 0 | 0 | `assets/download/ui/uiprefabandres/battle_ext_1/effect/battlestart.prefab;assets/download/ui/uiprefabandres/battle_ext_1/turnover/turnover.prefab` |
| download/ui/uiprefabandres/battle_ext_3.assetbundle | 1 | 0 | 0 | 1 | 0 | 0 | 0 | `assets/download/ui/uiprefabandres/battle_ext_3/battle_armor.prefab` |

## Needs Sprite/Region Join
| bundle | sprites | textures | materials | note |
| --- | ---: | ---: | ---: | --- |
| download/ui/uiprefabandres/winlose.assetbundle | 0 | 1 | 2 | sprite/region mapping required before placement |
| download/artsources/uispriteres/uibattle.assetbundle | 109 | 0 | 0 | sprite/region mapping required before placement |
| download/artsources/uispriteres/uibufficon.assetbundle | 646 | 0 | 0 | sprite/region mapping required before placement |
| download/artsources/uispriteres/uihurtnum.assetbundle | 128 | 0 | 0 | sprite/region mapping required before placement |
| download/artsources/uispriteres/uiheroheadbattle.assetbundle | 438 | 0 | 0 | sprite/region mapping required before placement |
| download/ui/uiprefabandres/battle_ext_4.assetbundle | 0 | 1 | 0 | sprite/region mapping required before placement |
| download/ui/uiprefabandres/winlose_ext_1.assetbundle | 0 | 1 | 1 | sprite/region mapping required before placement |
| download/ui/uiprefabandres/winlose_ext_2.assetbundle | 0 | 2 | 6 | sprite/region mapping required before placement |
| download/ui/uiprefabandres/winlose_ext_3.assetbundle | 0 | 1 | 2 | sprite/region mapping required before placement |
| download/ui/uiprefabandres/winlose_ext_4.assetbundle | 0 | 1 | 2 | sprite/region mapping required before placement |
| download/ui/uiprefabandres/autohelper_ext_3.assetbundle | 0 | 4 | 4 | sprite/region mapping required before placement |
| download/artsources/uispriteres/uiminebattle.assetbundle | 69 | 0 | 0 | sprite/region mapping required before placement |
| download/artsources/uispriteres/autohelper.assetbundle | 17 | 0 | 0 | sprite/region mapping required before placement |

## Missing Or Header/Load Problem
| bundle | exists | header | load | reason |
| --- | --- | --- | --- | --- |

## Lua / Handler Evidence
| pattern | line | file | snippet |
| --- | ---: | --- | --- |
| IsSkipBattle | 184 | C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\-17427396491214324_BattleAttackTaskMgr_security_xor_raw.lua | `if(not ModulesInit.ProcedureNormalBattle.IsSkipBattle and r)then` |
| BattleInputMgr | 4 | C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\-3683694185079020577_BattleManager_security_xor_raw.lua | `local o=require("Modules/Battle/BattleInputMgr")` |
| IsSkipBattle | 17 | C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\-7877228141847976083_GlobalBattleEffectMgr_security_xor_raw.lua | `if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==true)then` |
| IsSkipBattle | 47 | C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\-7877228141847976083_GlobalBattleEffectMgr_security_xor_raw.lua | `if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==true)then` |
| IsSkipBattle | 102 | C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\-7877228141847976083_GlobalBattleEffectMgr_security_xor_raw.lua | `if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==true)then` |
| IsSkipBattle | 138 | C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\-7877228141847976083_GlobalBattleEffectMgr_security_xor_raw.lua | `if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==true)then` |
| IsSkipBattle | 1628 | C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\191332877364712173_BattleUtil_security_xor_raw.lua | `if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then` |
| IsSkipBattle | 1658 | C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\191332877364712173_BattleUtil_security_xor_raw.lua | `if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then` |
| IsSkipBattle | 1696 | C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\191332877364712173_BattleUtil_security_xor_raw.lua | `if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then` |
| IsSkipBattle | 1113 | C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\2347635220185957824_BattleTeam_security_xor_raw.lua | `if(not ModulesInit.ProcedureNormalBattle.IsSkipBattle)then` |
| IsSkipBattle | 1120 | C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\2347635220185957824_BattleTeam_security_xor_raw.lua | `if(not ModulesInit.ProcedureNormalBattle.IsSkipBattle)then` |
| IsSkipBattle | 1129 | C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\2347635220185957824_BattleTeam_security_xor_raw.lua | `if(not ModulesInit.ProcedureNormalBattle.IsSkipBattle)then` |
| IsSkipBattle | 1138 | C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\2347635220185957824_BattleTeam_security_xor_raw.lua | `if(not ModulesInit.ProcedureNormalBattle.IsSkipBattle)then` |
| IsSkipBattle | 1196 | C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\2347635220185957824_BattleTeam_security_xor_raw.lua | `if(not ModulesInit.ProcedureNormalBattle.IsSkipBattle)then` |
| IsSkipBattle | 1206 | C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\2347635220185957824_BattleTeam_security_xor_raw.lua | `if(not ModulesInit.ProcedureNormalBattle.IsSkipBattle)then` |
| IsSkipBattle | 1218 | C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\2347635220185957824_BattleTeam_security_xor_raw.lua | `if(not ModulesInit.ProcedureNormalBattle.IsSkipBattle)then` |
| IsSkipBattle | 1230 | C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\2347635220185957824_BattleTeam_security_xor_raw.lua | `if(not ModulesInit.ProcedureNormalBattle.IsSkipBattle)then` |
| IsSkipBattle | 1241 | C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\2347635220185957824_BattleTeam_security_xor_raw.lua | `if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then` |
| IsAutoMode | 1408 | C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\2347635220185957824_BattleTeam_security_xor_raw.lua | `if(ModulesInit.ProcedureNormalBattle.IsAutoMode)then` |
| IsSkipBattle | 1506 | C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\2347635220185957824_BattleTeam_security_xor_raw.lua | `if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==true)then` |
| IsSkipBattle | 1518 | C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\2347635220185957824_BattleTeam_security_xor_raw.lua | `if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==true)then` |
| IsSkipBattle | 1530 | C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\2347635220185957824_BattleTeam_security_xor_raw.lua | `if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==true)then` |
| IsSkipBattle | 1540 | C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\2347635220185957824_BattleTeam_security_xor_raw.lua | `if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==true)then` |
| IsAutoMode | 1565 | C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\2347635220185957824_BattleTeam_security_xor_raw.lua | `if(ModulesInit.ProcedureNormalBattle.IsAutoMode)then` |
| IsSkipBattle | 1653 | C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\2347635220185957824_BattleTeam_security_xor_raw.lua | `if(not ModulesInit.ProcedureNormalBattle.IsSkipBattle)then` |
| IsSkipBattle | 1662 | C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\2347635220185957824_BattleTeam_security_xor_raw.lua | `if(not ModulesInit.ProcedureNormalBattle.IsSkipBattle)then` |
| IsSkipBattle | 1699 | C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\2347635220185957824_BattleTeam_security_xor_raw.lua | `if(not ModulesInit.ProcedureNormalBattle.IsSkipBattle)then` |
| IsSkipBattle | 1720 | C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\2347635220185957824_BattleTeam_security_xor_raw.lua | `if ModulesInit.ProcedureNormalBattle.IsSkipBattle==false then` |
| IsSkipBattle | 1734 | C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\2347635220185957824_BattleTeam_security_xor_raw.lua | `if(not ModulesInit.ProcedureNormalBattle.IsSkipBattle)then` |
| IsSkipBattle | 1739 | C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\2347635220185957824_BattleTeam_security_xor_raw.lua | `if(not ModulesInit.ProcedureNormalBattle.IsSkipBattle)then` |
| IsSkipBattle | 2593 | C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\2347635220185957824_BattleTeam_security_xor_raw.lua | `if(not ModulesInit.ProcedureNormalBattle.IsSkipBattle)then` |
| IsSkipBattle | 2599 | C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\2347635220185957824_BattleTeam_security_xor_raw.lua | `if(not ModulesInit.ProcedureNormalBattle.IsSkipBattle)then` |
| IsSkipBattle | 2605 | C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\2347635220185957824_BattleTeam_security_xor_raw.lua | `if(not ModulesInit.ProcedureNormalBattle.IsSkipBattle)then` |
| IsSkipBattle | 2804 | C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\2347635220185957824_BattleTeam_security_xor_raw.lua | `if(not ModulesInit.ProcedureNormalBattle.IsSkipBattle)then` |
| IsSkipBattle | 2842 | C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\2347635220185957824_BattleTeam_security_xor_raw.lua | `if(not ModulesInit.ProcedureNormalBattle.IsSkipBattle)then` |
| IsSkipBattle | 2876 | C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\2347635220185957824_BattleTeam_security_xor_raw.lua | `if(not ModulesInit.ProcedureNormalBattle.IsSkipBattle)then` |
| IsSkipBattle | 2888 | C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\2347635220185957824_BattleTeam_security_xor_raw.lua | `if(not ModulesInit.ProcedureNormalBattle.IsSkipBattle)then` |
| IsSkipBattle | 2894 | C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\2347635220185957824_BattleTeam_security_xor_raw.lua | `if ModulesInit.ProcedureNormalBattle.IsSkipBattle then` |
| IsSkipBattle | 3710 | C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\2347635220185957824_BattleTeam_security_xor_raw.lua | `if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==true)then` |
| Skill_BattleUI_Reset | 3785 | C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\2347635220185957824_BattleTeam_security_xor_raw.lua | `EventSystem.SendEvent(CommonEventId.Skill_BattleUI_Reset)` |

## BATTLE_17 Order
1. Attach loadable battle HUD prefab roots from `download/ui/uiprefabandres/battle*.assetbundle` to a dedicated evidence scene, preserving original hierarchy and Canvas/CanvasScaler.
2. Attach result panel candidates from `winlose*.assetbundle` as separate entry-point roots, not as fake final overlays.
3. Map sprite-region dependencies from `uibattle`, `uibufficon`, `uihurtnum`, and `uiheroheadbattle` per component reference.
4. Add click/raycast validation logs only for buttons with original Button/handler evidence.
- Next recommendation: `BATTLE_17_ATTACH_LOADABLE_BATTLE_HUD_PREFABS_TO_FLOW_SCENE`
