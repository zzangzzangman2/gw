# BATTLE_28 Actor Motion And Skill-Card Evidence

This is not a final restored battle screen. It uses the play video as a motion gate and separates actor motion, bottom skill-card UI, actor bundle coverage, and skill-effect availability.

## Verdict
- verdict: `battle28_evidence_collected_not_final`
- reference video: `C:\Users\godho\Downloads\플레이.mp4` clip05 around 486s
- contact sheet: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_28_ACTOR_MOTION_SKILLCARD_EVIDENCE_CONTACT_SHEET.jpg`
- BATTLE_27 capture: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreCaptures\battle_hud\BattleCorrectMapSceneHudPreviewClip05_1680x720.png`

## Video Motion Gate
- frame pair count: `5`
- motion component count: `54`
- actor motion component count: `26`
- bottom motion component count: `14`
- interpretation: the source video has moving actors and changing bottom-card/skill visual state, so a still or static prefab placement is not enough.

## Bottom Skill-Card Evidence
- video bottom-card bright saturated average: `0.405907`
- BATTLE_27 bottom-card bright saturated ratio: `0.399478`
- HUD bottom candidate rows: `56`
- active visible bottom candidate rows: `7`
- meaningful bottom-center rows: `0`
- interpretation: the color ratio alone is weak because the warm floor also has high chroma; the stronger failure evidence is that meaningful bottom-center HUD rows are `0` while the video motion mask catches changing bottom card regions.

## Actor Runtime Evidence
- runtime actor slots: `12`
- runtime prefab slots: `3`
- missing actor slots: `9`
- BATTLE_27 instantiated actors: `3`
- BATTLE_27 textured actors: `3`
- interpretation: BATTLE_27 improved from blank/magenta to textured actors, but actor motion/formation/scale still does not match the video.

## Missing Actor Slots
- `our` wave `0` slot `1` heroDid `1036` model `1036` reason `listed_in_cdn_versionfile_not_extracted` skills `[1036101, 1036201, 1036301, 1036401, 1036402]`
- `enemy` wave `1` slot `2` heroDid `1100112` model `1100112` reason `not_loadable_yet` skills `[1012101, 1012201, 1012301, 1012401, 1012403]`
- `enemy` wave `1` slot `3` heroDid `1100113` model `1100113` reason `not_loadable_yet` skills `[1012101, 1012201, 1012301, 1012401, 1012403]`
- `enemy` wave `2` slot `1` heroDid `1100121` model `1100121` reason `not_loadable_yet` skills `[1012101, 1012201, 1012301, 1012401, 1012403]`
- `enemy` wave `2` slot `2` heroDid `1100122` model `1100122` reason `not_loadable_yet` skills `[1012101, 1012201, 1012301, 1012401, 1012403]`
- `enemy` wave `2` slot `3` heroDid `1100123` model `1100123` reason `not_loadable_yet` skills `[1012101, 1012201, 1012301, 1012401, 1012403]`
- `enemy` wave `3` slot `1` heroDid `1100131` model `1100131` reason `not_loadable_yet` skills `[1012101, 1012101, 1001401, 1001403]`
- `enemy` wave `3` slot `2` heroDid `1100132` model `1100132` reason `not_loadable_yet` skills `[1012101, 1012101, 1001401, 1001403]`
- `enemy` wave `3` slot `3` heroDid `1100133` model `1100133` reason `not_loadable_yet` skills `[1012101, 1012101, 1001401, 1001403]`

## Skill Effect Evidence
- skill count: `20`
- skill found count: `12`
- timeline found count: `12`
- loadable effect bundle probes: `12`
- loadable effect prefab total with repeated bundles: `204`
- unique loadable effect bundles: `4`
- unique loadable effect prefab total: `68`
- missing effect bundle candidates: `8`
- unique missing effect bundle candidates: `3`
- interpretation: skill/effect assets exist for part of the fight, but they are not yet integrated into a runtime actor animation/motion replay.

## Lua Evidence Samples
- `girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\191332877364712173_BattleUtil_security_xor_raw.lua:983` `if ModulesInit.ProcedureNormalBattle.CheckDoGameFastSkillPlayFirstAnim(i)==false then`
- `girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\191332877364712173_BattleUtil_security_xor_raw.lua:984` `if ModulesInit.ProcedureNormalBattle.GameFastSkill==true then`
- `girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\191332877364712173_BattleUtil_security_xor_raw.lua:993` `if ModulesInit.ProcedureNormalBattle.CheckDoGameFastSkillPlayFirstAnim(i)==false then`
- `girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\191332877364712173_BattleUtil_security_xor_raw.lua:994` `if ModulesInit.ProcedureNormalBattle.GameFastSkill==true then`
- `girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\191332877364712173_BattleUtil_security_xor_raw.lua:1006` `if ModulesInit.ProcedureNormalBattle.CheckDoGameFastSkillPlayFirstAnim(i)==false then`
- `girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\191332877364712173_BattleUtil_security_xor_raw.lua:1007` `if ModulesInit.ProcedureNormalBattle.GameFastSkill==true and a.fastPrefabId2>0 then`
- `girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\191332877364712173_BattleUtil_security_xor_raw.lua:1014` `if ModulesInit.ProcedureNormalBattle.CheckDoGameFastSkillPlayFirstAnim(i)==false then`
- `girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\191332877364712173_BattleUtil_security_xor_raw.lua:1015` `if ModulesInit.ProcedureNormalBattle.GameFastSkill==true and a.fastPrefabId>0 then`
- `girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\2411250927983938450_HeroSkillInfo_security_xor_raw.lua:1` `HeroSkillInfo={`
- `girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\2411250927983938450_HeroSkillInfo_security_xor_raw.lua:3` `function HeroSkillInfo:New()`
- `girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\2411250927983938450_HeroSkillInfo_security_xor_raw.lua:12` `function HeroSkillInfo:SetSkill(e)`
- `girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\5715894101901633899_RecordManager_security_xor_raw.lua:33` `ModulesInit.ProcedureNormalBattle.SetLeftInfo(n,nil,i,o)`
- `girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\5715894101901633899_RecordManager_security_xor_raw.lua:34` `ModulesInit.ProcedureNormalBattle.SetRightInfo(nil,e.Icon,GameTools.GetLocalize(e.mosterName,LanguageCategory.LangBattle),e.level)`
- `girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\5715894101901633899_RecordManager_security_xor_raw.lua:37` `ModulesInit.ProcedureNormalBattle.SetLeftInfo(n,nil,i,o)`
- `girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\846054528645605280_HeroBattleInfo_security_xor_raw.lua:662` `e=HeroSkillInfo:New()`
- `girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\846054528645605280_HeroBattleInfo_security_xor_raw.lua:668` `e=HeroSkillInfo:New()`
- `girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\846054528645605280_HeroBattleInfo_security_xor_raw.lua:674` `e=HeroSkillInfo:New()`
- `girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\846054528645605280_HeroBattleInfo_security_xor_raw.lua:686` `t=HeroSkillInfo:New()`
- `girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\846054528645605280_HeroBattleInfo_security_xor_raw.lua:692` `t=HeroSkillInfo:New()`
- `girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\846054528645605280_HeroBattleInfo_security_xor_raw.lua:698` `t=HeroSkillInfo:New()`

## Current Failure Axes
- actor motion is not proven against the video sequence
- bottom skill-card runtime UI is not restored
- 9 of 12 runtime actor slots still lack loadable actor prefabs
- skill effect prefabs are available but not attached to a video-matched runtime battle replay
- runtime manifest mapId `11001` conflicts with video-matched `map_11003` evidence

## Next Blocker
- `BATTLE_29_BIND_UI_NORMALBATTLE_HERO_LIST_SKILL_CARDS_AND_TRACE_ACTOR_ANIMATION_RUNTIME`

## Outputs
- result JSON: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_28_ACTOR_MOTION_SKILLCARD_EVIDENCE_RESULT.json`
- contact sheet: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_28_ACTOR_MOTION_SKILLCARD_EVIDENCE_CONTACT_SHEET.jpg`
- reference sequence: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_28_PLAY_VIDEO_CLIP05_486S_SEQUENCE.jpg`
