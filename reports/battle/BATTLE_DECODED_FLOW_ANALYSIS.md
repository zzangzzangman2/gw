# Battle Decoded Flow Analysis

## Core Decoded Files

| Role | File |
|---|---|
| `ProcedureNormalBattle` | `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_procedure\-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua` |
| `BattleManager` | `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\-3683694185079020577_BattleManager_security_xor_raw.lua` |
| `BattleTeam` | `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\2347635220185957824_BattleTeam_security_xor_raw.lua` |
| `HeroCtrl` | `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\-2133702496468653963_HeroCtrl_security_xor_raw.lua` |
| `HeroBattleInfo` | `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\846054528645605280_HeroBattleInfo_security_xor_raw.lua` |
| `BattleInputMgr` | `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\8809785119562755294_BattleInputMgr_security_xor_raw.lua` |
| `BattleUtil` | `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\191332877364712173_BattleUtil_security_xor_raw.lua` |
| `fight_info` | `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_battle\2406239097966023345_fight_info_security_xor_raw.lua` |

## What The Flow Shows

- `ProcedureNormalBattle` requires `BattleSkillEffectManager`, `BattleTeam`, `HeroCtrl`, `HeroBattleInfo`, and the skill/monster datatables directly. This is the top-level battle lifecycle module.
- Entry data flows through `BeginFightPlayWithServer`, `InitDataWithFightPlayData`, and `InitDataWithFightBeforeData`, using `mapId`, `waveData`, our/enemy formations, hero lists, pets, random seed, and battle type.
- Battle has an embedded test payload in `BeginBattleWithServer_FightPlay`; this is immediately useful as deterministic prototype data without needing a server.
- `BattleTeam` owns the team attack pipeline: begin attack, choose skill, play skill prefab/timeline, check hurt values, check death, then complete callback.
- `HeroCtrl` maps model/data rows to battle Spine objects, animation names, hurt/death/fury/effect playback, and prefab ids.
- `HeroBattleInfo` maps server hero/monster skill arrays into `HeroSkillInfo` objects and applies buffs/attrs.
- `BattleInputMgr` already separates manual/auto input, so the prototype should expose auto toggle even before full UI is restored.

## Key Evidence Lines

### ProcedureNormalBattle

#### requires

| Line | Evidence |
|---:|---|
| `3` | `require"Modules/Battle/BattleSkillEffectManager"` |
| `5` | `require"Modules/Battle/BattleTeam"` |
| `6` | `require"Modules/Battle/HeroCtrl"` |
| `7` | `require"Modules/Battle/HeroBattleInfo"` |
| `8` | `require"Modules/Battle/HeroSkillInfo"` |
| `9` | `require"Modules/Battle/HeroBuffInfo"` |
| `10` | `require"Modules/Battle/HeroBuffValueInfo"` |
| `11` | `require"Modules/Battle/BattleEffectInfo"` |

#### event_listeners

| Line | Evidence |
|---:|---|
| `277` | `EventSystem.AddListener(CommonEventId.ProcedureNormalBattle_OnEnter,e.ProcedureNormalBattle_OnEnter)` |
| `278` | `EventSystem.AddListener(CommonEventId.ProcedureNormalBattle_OnLeave,e.ProcedureNormalBattle_OnLeave)` |
| `279` | `EventSystem.AddListener(CommonEventId.ProcedureNormalBattle_TestBattle,e.ProcedureNormalBattle_TestBattle)` |
| `280` | `EventSystem.AddListener(CommonEventId.ProcedureNormalBattle_SetCurrAttackHeroId,e.OnSetCurrAttackHeroId)` |
| `281` | `EventSystem.AddListener(CommonEventId.ProcedureNormalBattle_SetCurrBeAttackHeroId,e.OnSetCurrBeAttackHeroId)` |
| `282` | `EventSystem.AddListener(CommonEventId.ProcedureNormalBattle_SetStaticTarget,e.OnSetStaticTarget)` |
| `283` | `EventSystem.AddListener(CommonEventId.TestBattleSceneHeroMove,e.TestBattleSceneHeroMove)` |
| `284` | `EventSystem.AddListener(CommonEventId.OnCreateNameFinish,e.OnCreateNameFinish)` |
| `796` | `EventSystem.AddListener(CommonEventId.OnPlayDamagePoint,e.OnPlayDamagePoint)` |
| `797` | `EventSystem.AddListener(CommonEventId.OnBattleUILoadComplete,e.OnBattleUILoadComplete)` |
| `798` | `EventSystem.AddListener(CommonEventId.OnClickScreen,e.OnClickCallBack)` |
| `799` | `EventSystem.AddListener(CommonEventId.OnScrollSceneMoveComplete,e.OnScrollSceneMoveComplete)` |
| `800` | `EventSystem.AddListener(CommonEventId.OnEventNetReconnectSuccess,e.OnEventNetReconnectSuccess)` |
| `802` | `EventSystem.AddListener(CommonEventId.OnBattleEndUIShowComplete,e.OnBattleEndUIShowComplete)` |
| `803` | `EventSystem.AddListener(CommonEventId.OnEventRespError,e.OnEventRespError)` |
| `804` | `EventSystem.AddListener(CommonEventId.KillDragonCountDownFinish,e.OnKillDragonCountDownFinish)` |
| `805` | `EventSystem.AddListener(CommonEventId.ProcedureNormalBattle_ShowHeadBar,e.OnShowHeadBar)` |
| `909` | `EventSystem.RemoveListener(CommonEventId.OnPlayDamagePoint,e.OnPlayDamagePoint)` |

#### entry_points

| Line | Evidence |
|---:|---|
| `425` | `function t.BeginFightPlayWithServer(t)` |
| `437` | `function t.BeginBattleWithServer(t)` |
| `448` | `function t.InitDataWithFightPlayData(t)` |
| `468` | `function t.InitDataWithFightBeforeData(t)` |
| `566` | `function t.InitDataWithEmptyData()` |
| `577` | `function t.BeginBattleWithClient(t,a)` |
| `588` | `function t.BeginBattleWithServer_FightPlay()` |
| `785` | `function t.ProcedureNormalBattle_OnEnter(a)` |
| `897` | `function t.ProcedureNormalBattle_OnLeave()` |
| `1225` | `function t.ProcedureNormalBattle_TestBattle(t)` |
| `1274` | `function t.EnterBigSKillState(t)` |
| `1375` | `function t.SetBattleTeamTotalFirstValue(t)` |
| `1581` | `function t.LoadPlayerHeros(t,a,i,o)` |
| `1687` | `function t.LoadEnemyPlayerHeros(t,n,i,o)` |
| `1791` | `function t.LoadPlayerHero(h,n,i,s,r,a)` |
| `4197` | `function t.EnterBattleRoundNormalSkill()` |

#### map_and_wave

| Line | Evidence |
|---:|---|
| `54` | `e.FightPlay_CurrWave=nil` |
| `56` | `e.FightBefore_CurrWave=nil` |
| `62` | `e.MapId=0` |
| `70` | `e.CurrMapsWavesIndex=0` |
| `270` | `FightDataReportMgr:VerifyStatistic(e.FightPlayData,e.CurrMapsWavesIndex,e.HeroDic[t])` |
| `435` | `e.LoadEnemyPlayerHeros(e.FightPlay_CurrWave.enemyTeamFormation,e.FightPlay_CurrWave.enemyTeamFormationAlter,e.FightPlay_CurrWave.enemyHeros,e.FightPlay_CurrWave.enemyPets)` |
| `452` | `e.MapId=t.mapId` |
| `458` | `e.CurrMapsWavesIndex=e.CurrMapsWavesIndex+1` |
| `459` | `e.FightPlay_CurrWave=t.waveData[e.CurrMapsWavesIndex]` |
| `460` | `e.MaxMapsWave=#t.waveData` |
| `462` | `FightDataReportMgr:InitReport(e.BattleType,e.MapId,RandomMgr.seed,t.ourPlayerId,t.enemyPlayerId,a)` |
| `464` | `e.InitSupplementHerosData(t,e.FightPlay_CurrWave)` |
| `472` | `e.MapId=t.mapId` |
| `478` | `e.CurrMapsWavesIndex=e.CurrMapsWavesIndex+1` |
| `479` | `e.FightBefore_CurrWave=e.FightBeforeData.waveData[e.CurrMapsWavesIndex]` |
| `480` | `e.MaxMapsWave=#t.waveData` |
| `482` | `e.FightPlay_CurrWave=e.FightBefore_CurrWave` |
| `489` | `FightDataReportMgr:InitReport(e.BattleType,e.MapId,RandomMgr.seed,t.ourPlayerId,t.enemyPlayerId,a)` |

#### ui_and_result

| Line | Evidence |
|---:|---|
| `188` | `e.BattleResultReqCount=0` |
| `757` | `and ModulesInit.KillDragonsManager.CurFightInfo.resultShow` |
| `758` | `and ModulesInit.KillDragonsManager.CurFightInfo.resultShow.roomMember` |
| `760` | `local a=ModulesInit.KillDragonsManager.CurFightInfo.resultShow.roomMember` |
| `836` | `GameEntry.UI:OpenUIForm(UIFormId.UI_CommonLoading,{style=LoadingStyle.Cloud})` |
| `852` | `GameEntry.UI:OpenUIForm(UIFormId.UI_Global)` |
| `1881` | `GameEntry.UI:OpenUIForm(e.IsBattleTest and UIFormId.UI_TestBattle or UIFormId.UI_NormalBattle,{showOperMenu=e.showOperMenu})` |
| `2285` | `GameEntry.UI:OpenUIForm(UIFormId.UI_BattleVictory,t)` |
| `2299` | `if a==false and e.BattleResultReqCount>0 and t then` |
| `2300` | `e.BattleResultReqCount=e.BattleResultReqCount-1` |
| `2307` | `GameEntry.UI:OpenUIForm(UIFormId.UI_BattleFail,e)` |
| `2309` | `GameEntry.UI:OpenUIForm(UIFormId.UI_CommonLoading,{style=LoadingStyle.Black,blackAnimType=ELoadingBlackAnimType.Short,loadResFinish=function()` |
| `2323` | `if t==false and e.BattleResultReqCount>0 then` |
| `2324` | `e.BattleResultReqCount=e.BattleResultReqCount-1` |
| `2331` | `GameEntry.UI:OpenUIForm(UIFormId.UI_BattleFail,e)` |
| `2343` | `if t==false and e.BattleResultReqCount>0 then` |
| `2344` | `e.BattleResultReqCount=e.BattleResultReqCount-1` |
| `2351` | `GameEntry.UI:OpenUIForm(UIFormId.UI_BattleFail,e)` |

#### test_payload

| Line | Evidence |
|---:|---|
| `588` | `function t.BeginBattleWithServer_FightPlay()` |
| `589` | `local t='{"battleInfo":{"ourHeros":[{"heroDid":1036,"status":2,"rankLevel":3,"heroId":51469,"skills":[{"skillType":1,"skillDid":1036101},{"skillType":1,"skillDid":1036201},{"skillType":1,"skillDid":1036301},{"skillTyp...` |

### BattleManager

#### manager

| Line | Evidence |
|---:|---|
| `10` | `local a=Class("BattleManager")` |
| `11` | `function a:__init(n,d,a)` |
| `15` | `self.battleData=nil` |
| `20` | `self.battleData=e.New()` |
| `22` | `self.server:SetData(self.battleData)` |
| `24` | `self.client:SetData(self.battleData)` |
| `25` | `self.battleData:SetRefreshedCallback(self.client.OnDataRefreshed)` |
| `30` | `self.battleData=e.New()` |
| `31` | `self.client:SetData(self.battleData)` |
| `35` | `self.battleData=e.New()` |
| `37` | `self.server:SetData(self.battleData)` |

### BattleTeam

#### team_setup

| Line | Evidence |
|---:|---|
| `17` | `function BattleTeam:New()` |
| `76` | `function BattleTeam:Init()` |
| `141` | `function BattleTeam:Reset()` |
| `149` | `function BattleTeam:ResetHeroDataWhenNextWave()` |
| `165` | `function BattleTeam:LoadTeamTreasure(o)` |
| `231` | `function BattleTeam:AddHeroCtrl(e)` |
| `317` | `function BattleTeam:GetHeroCtrl(t)` |
| `331` | `function BattleTeam:GetHeroCtrlWithBuffId(a)` |
| `377` | `function BattleTeam:GetHeroCtrlByStation(t)` |
| `591` | `function BattleTeam:GetHeroCtrlWithId(t)` |
| `605` | `function BattleTeam:GetHeroCtrlWithPos(a)` |
| `1478` | `function BattleTeam:ResetExplosiveState()` |
| `1483` | `function BattleTeam:ResetHerosRoundIsAttack(t)` |
| `1496` | `function BattleTeam:ResetPetRoundIsAttack(e)` |
| `1580` | `function BattleTeam:GetHeroCtrlWithAttrId(e,t,a)` |
| `1583` | `function BattleTeam:GetHeroCtrlWithAttrIdWithExcludeHeroId(e,n,i,t)` |
| `1759` | `function BattleTeam:ResetBuffInCurAttack()` |
| `2622` | `function BattleTeam:ResetHpHealthInTimeLine()` |

#### attack_pipeline

| Line | Evidence |
|---:|---|
| `3648` | `function BattleTeam:TeamFightAttack(t,e)` |
| `3653` | `function BattleTeam:TeamFightBeginAttack()` |
| `3661` | `function BattleTeam:TeamFightAttackCoroutine()` |
| `3779` | `function BattleTeam:TeamFightAttackCoroutine_After(e,a,t)` |
| `3796` | `function BattleTeam:TeamFightAttackCoroutine_AfterAndCheckHurtValue(e,a,t)` |
| `3801` | `function BattleTeam:TeamFightAttackCoroutine_AfterAndCheckHeroDie(a,t,e)` |
| `3806` | `function BattleTeam:TeamFightAttackCoroutine_AfterAndEnd(e,e,e)` |
| `3835` | `function BattleTeam:OnTeamFightAttackComplete()` |

#### skill_effect_bridge

| Line | Evidence |
|---:|---|
| `1325` | `if e~=nil and e:GetCanPetFightAttack(e.PetFightSkillId,t)then` |
| `3686` | `FightDataReportMgr:SetErrorCode(ServerErrorCode.SkillIdNoExists,string.format("技能Id不存在 TeamId %s TeamSkillId %s",self.TeamId,o))` |
| `3719` | `ModulesInit.BattleSkillEffectManager.ResetStateOnStart()` |
| `3728` | `ModulesInit.BattleSkillEffectManager.CurrTimelineEffect=o:GetComponent(typeof(CS.YouYou.TimelineEffect))` |
| `3729` | `if ModulesInit.BattleSkillEffectManager.CurrTimelineEffect==nil then` |
| `3730` | `GameInit.LogErrorAndUpdate("battle TeamFightAttack CurrTimelineEffect == nil , skillPrefabId = "..tostring(a))` |
| `3732` | `BuildPatchMgr:PlayTimeLine(ModulesInit.BattleSkillEffectManager.CurrTimelineEffect)` |
| `3735` | `ModulesInit.ProcedureNormalBattle.CurrTimelineEffectAttackPointCount=ModulesInit.BattleSkillEffectManager.CurrTimelineEffect.AttackPointCount` |
| `3737` | `ModulesInit.BattleSkillEffectManager.CurrTimelineEffect.OnStopped=function()` |
| `3741` | `ModulesInit.BattleSkillEffectManager:StopCurVideo()` |
| `3775` | `C:PlaySkillPrefabAndRemoveAsyncPreload(a,TeamFightAttack)` |
| `3790` | `ModulesInit.BattleSkillEffectManager.DespawnAllTrans()` |
| `3791` | `ModulesInit.BattleSkillEffectManager.CameraControlReset()` |
| `3792` | `ModulesInit.BattleSkillEffectManager.KillTweener()` |

#### death_and_hurt_checks

| Line | Evidence |
|---:|---|
| `1695` | `function BattleTeam:CheckHeroDie(a)` |
| `1749` | `function BattleTeam:CheckHeroDieWhenWaiting()` |
| `2385` | `ModulesInit.ProcedureNormalBattle.CheckHeroDieWhenWaiting()` |
| `2402` | `ModulesInit.ProcedureNormalBattle.CheckHeroDieWhenWaiting()` |
| `2589` | `function BattleTeam:CheckHurtValue(t)` |
| `2598` | `e:CheckHurtValue()` |
| `3698` | `ModulesInit.ProcedureNormalBattle.CurrAttackCauseHeroDie=false` |
| `3712` | `self:TeamFightAttackCoroutine_AfterAndCheckHurtValue(nil,t,e.type)` |
| `3748` | `if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then` |
| `3794` | `self:TeamFightAttackCoroutine_AfterAndCheckHurtValue(e,a,t)` |
| `3796` | `function BattleTeam:TeamFightAttackCoroutine_AfterAndCheckHurtValue(e,a,t)` |
| `3797` | `ModulesInit.ProcedureNormalBattle.CheckHurtValue(function()` |
| `3798` | `self:TeamFightAttackCoroutine_AfterAndCheckHeroDie(e,a,t)` |
| `3801` | `function BattleTeam:TeamFightAttackCoroutine_AfterAndCheckHeroDie(a,t,e)` |
| `3802` | `ModulesInit.ProcedureNormalBattle.CheckHeroDie(function()` |
| `3810` | `if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then` |
| `3817` | `local t=ModulesInit.ProcedureNormalBattle.CurrAttackCauseHeroDie and 0.5 or 0` |

### HeroCtrl

#### data_sources

| Line | Evidence |
|---:|---|
| `21` | `local i=require("DataNode/DataTable/Create/skillAct/DTSkillActDBModel")` |
| `22` | `local m=require("DataNode/DataTable/Create/skillAct/DTSkillPasDBModel")` |
| `23` | `local n=require("DataNode/DataTable/Create/model/DTmodelDBModel")` |
| `26` | `local t=require("DataNode/DataTable/Create/skillAct/DTBuffDBModel")` |
| `124` | `self.DTMonsterRow=nil` |
| `125` | `self.HeroServerData=nil` |
| `127` | `self.DTmodelRow=nil` |
| `128` | `self.PrefabId=0` |
| `129` | `self.haloPrefabId=0` |
| `321` | `self.petPrefabId=0` |
| `329` | `self.mCurTransferSkinPrefabId=0` |
| `330` | `self.mRecordTransferSkinPrefabId=0` |
| `368` | `self.CurImmnuneSepsisHpPrefabId=0` |
| `369` | `self.ImmuneSepsisHpEffectPrefabId=0` |
| `590` | `self.DTmodelRow=n.GetEntity(o)` |
| `591` | `self.PrefabId=self.DTmodelRow.prefabId` |
| `592` | `self.petPrefabId=self.DTmodelRow.petPainting` |
| `593` | `self.haloPrefabId=self.DTmodelRow.haloPrefabId` |

#### spine_setup

| Line | Evidence |
|---:|---|
| `57` | `self.spineboy=nil` |
| `58` | `self.spineboyTransform=nil` |
| `309` | `self.spineboyScale=1` |
| `317` | `self.spinePet=nil` |
| `1268` | `self.spinePet=nil` |
| `1299` | `self.spinePet=e:GetComponent(typeof(CS.Spine.Unity.SkeletonAnimation))` |
| `1306` | `self:RefreshSpinePetScale()` |
| `1319` | `if not IsNil(self.spineboyTransform)then` |
| `1320` | `self.spineboyTransform:DOKill()` |
| `1322` | `self:SetSpineInvisible(false)` |
| `1327` | `self.spineboy=nil` |
| `1328` | `self.spineboyTransform=nil` |
| `1354` | `self.spineboy=e:GetComponent(typeof(CS.Spine.Unity.SkeletonAnimation))` |
| `1355` | `self.spineboyTransform=self.spineboy.transform` |
| `1356` | `self.topBone=self.spineboy.skeleton:FindBone("top")` |
| `1357` | `self.pointBone=self.spineboy.skeleton:FindBone("point")` |
| `1368` | `self:RefreshSpineBoyScale()` |
| `1372` | `self:SetSpineInvisible(false)` |

#### animation_state

| Line | Evidence |
|---:|---|
| `1120` | `return self.DTmodelRow.deathEffectScale` |
| `1382` | `local t=e:FindAnimation("strike")` |
| `1388` | `local t=e:FindAnimation("strike2")` |
| `1394` | `local t=e:FindAnimation("death")` |
| `1396` | `self.AnimLenDic["death"]=t.Duration` |
| `1398` | `local t=e:FindAnimation("change")` |
| `1420` | `self:SetSpineAnimation(0,"run",true)` |
| `1440` | `Vector3(self.DTmodelRow.standHeadOffsetX,self.DTmodelRow.standHeadOffsetY,0),` |
| `1745` | `function HeroCtrl:PlaySpineAnim(o,a,e,t)` |
| `1754` | `local t=self:SetSpineAnimation(0,o,a,t)` |
| `1763` | `self:ChangeToIdleAfterPlaySpineAnim(a)` |
| `1767` | `function HeroCtrl:PlaySpineAnims(i,a,e,s,r,h)` |
| `1831` | `a=self:AddSpineAnimation(0,i,true,0,h)` |
| `1833` | `a=self:AddSpineAnimation(0,i,false,0,h)` |
| `1837` | `if e~=t or i~="stand"then` |
| `1850` | `self:ChangeToIdleAfterPlaySpineAnim(o)` |
| `1853` | `function HeroCtrl:ChangeToIdleAfterPlaySpineAnim(t)` |
| `1917` | `if e=="stand"then` |

#### hurt_damage

| Line | Evidence |
|---:|---|
| `5` | `local E=require("Modules/Battle/HeroState/HurtState")` |
| `120` | `self.CurrHurtNum=nil` |
| `136` | `self.WillHurtValueDic={}` |
| `137` | `self.willHurtQueue=nil` |
| `138` | `self.WillThornHurtValueQueue=nil` |
| `140` | `self.needHurtValue=0` |
| `141` | `self.hurtBeforeHP=0` |
| `142` | `self.needHurtArmorValue=0` |
| `143` | `self.hurtBeforeArmor=0` |
| `145` | `self.hurtBeforeSepsisHP=0` |
| `146` | `self.hurtBeforeCurrMaxHP=0` |
| `147` | `self.hurtBeforeCurrSepsisHp=0` |
| `162` | `self.PrevHurtCategory=0` |
| `163` | `self.PrevTotalHurtValue=0` |
| `164` | `self.HurtNumType=nil` |
| `215` | `self.hurtLimit=0` |
| `219` | `self.ImmuneReduceFury=false` |
| `236` | `self.WillAddFuryWithSkill=0` |

#### effect_prefab

| Line | Evidence |
|---:|---|
| `128` | `self.PrefabId=0` |
| `129` | `self.haloPrefabId=0` |
| `321` | `self.petPrefabId=0` |
| `329` | `self.mCurTransferSkinPrefabId=0` |
| `330` | `self.mRecordTransferSkinPrefabId=0` |
| `368` | `self.CurImmnuneSepsisHpPrefabId=0` |
| `369` | `self.ImmuneSepsisHpEffectPrefabId=0` |
| `591` | `self.PrefabId=self.DTmodelRow.prefabId` |
| `592` | `self.petPrefabId=self.DTmodelRow.petPainting` |
| `593` | `self.haloPrefabId=self.DTmodelRow.haloPrefabId` |
| `594` | `if self.petPrefabId>0 then` |
| `620` | `self.PrefabId=self.DTmodelRow.prefabId` |
| `621` | `self.petPrefabId=self.DTmodelRow.petPainting` |
| `622` | `self.haloPrefabId=self.DTmodelRow.haloPrefabId` |
| `667` | `self.PrefabId=self.DTmodelRow.prefabId` |
| `668` | `self.petPrefabId=self.DTmodelRow.petPainting` |
| `669` | `self.haloPrefabId=self.DTmodelRow.haloPrefabId` |
| `706` | `if self.petPrefabId>0 then` |

### HeroBattleInfo

#### skills

| Line | Evidence |
|---:|---|
| `655` | `self.CurrHeroCtrl.SkillMode=e.skillMode` |
| `656` | `if(e.skillMode==SkillMode.Normal)then` |
| `664` | `e.SkillDid=self.CurrHeroCtrl.NormalSkillId` |
| `670` | `e.SkillDid=self.CurrHeroCtrl.SmallSkillId` |
| `676` | `e.SkillDid=self.CurrHeroCtrl.BigSkillId` |
| `679` | `elseif(e.skillMode==SkillMode.DragonWar)then` |
| `688` | `t.SkillDid=e.monSkill1` |
| `694` | `t.SkillDid=e.monSkill2` |
| `700` | `t.SkillDid=e.monSkill3` |
| `706` | `t.SkillDid=e.monSkill4` |
| `716` | `e.SkillDid=t` |
| `723` | `if(e.SkillDid==t)then` |
| `886` | `function HeroBattleInfo:SetHeroSkill(e)` |
| `891` | `self.CurrHeroCtrl.SkillMode=e.skillMode` |
| `892` | `if(e.skillMode==SkillMode.DragonWar)then` |
| `898` | `local t=t.skillDid==nil and 0 or t.skillDid` |
| `914` | `local t=t.skillDid==nil and 0 or t.skillDid` |
| `940` | `function HeroBattleInfo:SetPetSkill(e)` |

#### buffs

| Line | Evidence |
|---:|---|
| `72` | `BuffDic={},` |
| `73` | `BuffValueDic={},` |
| `74` | `TempBuffValueDic={},` |
| `79` | `BeforeTimeLineBuffValueDic={},` |
| `82` | `immuneBuffMap={},` |
| `83` | `mCtrlBuffImmuneMap={},` |
| `93` | `function HeroBattleInfo:DisposeBuff()` |
| `95` | `GameInit.LogError("Call HeroBattleInfo:DisposeBuff() When isTimeLine!")` |
| `98` | `local e=self:GetBuffSortArr()` |
| `101` | `self:RemoveBuffWithId(e.buffId,BuffRemoveType.Expire)` |
| `103` | `self.BuffDic={}` |
| `104` | `self.BuffValueDic={}` |
| `105` | `self.TempBuffValueDic={}` |
| `173` | `local e=self:GetBuffSortArr()` |
| `176` | `self:RemoveBuffWithId(e.buffId,BuffRemoveType.Expire)` |
| `179` | `self.BuffDic={}` |
| `180` | `self.BuffValueDic={}` |
| `181` | `self.TempBuffValueDic={}` |

#### attrs

| Line | Evidence |
|---:|---|
| `1` | `local e=require("DataNode/DataTable/Create/constant/DTBattleAttrDBModel")` |
| `21` | `Fury=Constant.battle_fury_max,` |
| `22` | `OriginalFury=0,` |
| `23` | `CurrFury=0,` |
| `24` | `BeforeTimeLineFury=0,` |
| `25` | `OverdrawFury=0,` |
| `26` | `BeforeTimeLineOverdrawFury=0,` |
| `29` | `Critical=0,` |
| `30` | `CriticalRes=0,` |
| `31` | `CriticalStrength=0,` |
| `61` | `petCritical=0,` |
| `62` | `petCriticalRes=0,` |
| `63` | `petCriticalStrength=0,` |
| `68` | `petCriticalStrengthRes=0,` |
| `85` | `BeansStatFury=0,` |
| `86` | `BeforeTimeLineBeansStatFury=0,` |
| `122` | `self.Fury=Constant.battle_fury_max` |
| `123` | `self.OriginalFury=0` |

### BattleInputMgr

#### input

| Line | Evidence |
|---:|---|
| `4` | `self.currentAuto=false` |
| `7` | `function e:SetAuto(e)` |
| `8` | `self.currentAuto=e` |
| `13` | `function e:SendEventDataRefreshed()` |
| `22` | `elseif self.currentAuto then` |
| `23` | `e=self:GenOneInputAuto()` |
| `29` | `self:SendEventDataRefreshed()` |
| `31` | `function e:GenOneInputAuto()` |

### BattleUtil

#### utility

| Line | Evidence |
|---:|---|
| `1` | `local w=require("DataNode/DataTable/Create/skillAct/DTSkillActDBModel")` |
| `10` | `local u=require("DataNode/DataTable/Create/treasure/DTTreasureSkillDBModel")` |
| `23` | `function e:CheckCanTriggerAttackTask(e)` |
| `24` | `if e==ETriggerSkillAtkType.Normal` |
| `25` | `or e==ETriggerSkillAtkType.PursuitComboAttack then` |
| `30` | `function e:IsNormalSkillAtkType(e)` |
| `31` | `if e==ETriggerSkillAtkType.Normal then` |
| `36` | `function e:IsPreventSkillAtkType(e)` |
| `37` | `if e~=ETriggerSkillAtkType.Normal` |
| `38` | `and e~=ETriggerSkillAtkType.PursuitAttackMate then` |
| `43` | `function e:AddTriggerAttackTask(s,i,t,n)` |
| `59` | `local o=EBattleActionType.NormalOrSmallSkill` |
| `60` | `local a=e:GetSkillActData(i)` |
| `62` | `GameInit.LogError("BattleUtil:AddAttackTask drSkillData is nil skillDid = %s ",i)` |
| `65` | `local h=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(s)` |
| `70` | `if ModulesInit.ProcedureNormalBattle.IsHeroSkillAttackState()==false then` |
| `74` | `if e:CheckCanTriggerAttackTask(n.triggerSkillAtkType)==false then` |
| `84` | `o=EBattleActionType.NormalOrSmallSkill` |

### fight_info

#### schema

| Line | Evidence |
|---:|---|
| `6` | `waveData={` |
| `13` | `heroDid=1141011,` |
| `14` | `heroId=-1` |
| `20` | `heroDid=1141012,` |
| `21` | `heroId=-2` |
| `27` | `heroDid=1141013,` |
| `28` | `heroId=-3` |
| `37` | `actionData={` |
| `39` | `heroId=100174402,` |
| `41` | `actionType=2` |
| `47` | `actionData={` |
| `49` | `heroId=-2,` |
| `51` | `actionType=2` |
| `54` | `heroId=-3,` |
| `56` | `actionType=2` |
| `67` | `actionData={` |
| `69` | `heroId=100174402,` |
| `71` | `actionType=1` |

## Prototype-Oriented Restore Order

1. Use the embedded `BeginBattleWithServer_FightPlay` payload as a first replay/test fixture, but store a shortened JSON copy separately before wiring Unity.
2. Build a battle scene shell from `mapId` to `download/artsources/map/battlemap/map_<id>/...` and `download/map/battlemap/<id>.assetbundle`.
3. Spawn `HeroCtrl`-compatible actor slots for our/enemy formations using battle Spine bundles from `roleprefabsandres/battleprefabandres/<prefabId>.assetbundle`.
4. Implement the first visible loop as `stand/wait -> attack -> hurt number -> death/stand`, using original animation names from the skeletons.
5. Add `BattleInputMgr` auto/manual state and pause/speed controls after the visual loop is stable.

## Outputs

- JSON: `C:\Users\godho\Downloads\girlswar\reports\battle\battle_decoded_flow_summary.json`
- Markdown: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_DECODED_FLOW_ANALYSIS.md`
