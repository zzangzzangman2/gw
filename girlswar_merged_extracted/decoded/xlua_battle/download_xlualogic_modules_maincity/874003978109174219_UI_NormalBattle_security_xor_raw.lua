local e=1
local D=require"Modules/MainCity/UI_NormalBattle_HeroItem"
local L=require('DataNode/DataTable/Create/constant/DTBattleDBModel')
local R=require("DataNode/DataTable/Create/maps/DTMapsDBModel")
local N=require("DataNode/DataManager/DataMgr/DataUtil")
local I=require("Modules/Battle/BattleUtil")
local S=require('DataNode/DataTable/Create/dragon/DTDragonStageDBModel')
local H=require('DataNode/DataTable/Create/monster/DTMonsterDBModel')
local e=BattleType
require"Modules/MainCity/UI_NormalBattle_TeamView"
require"Modules/MainCity/UI_NormalBattle_TeamViewForKD"
local a
local l
local u
local o=false
local m=false
local O=false
local j
local v=nil
local d=nil
local b=0
local h=false
local n=nil
local _=true
local r={}
local c=false
local s=false
local E=-206
local k=-367
local t=0.65
local i=nil
local p=nil
local w=0
local q=nil
local A=false
local f=false
local T={}
local g=false
function OnClickSkipBattle()
if ModulesInit.ProcedureNormalBattle.isAlreadyShowBattleEnd then
return
end
if not GameFunction.IsFunctionUnLock(GameFunctionType.SkipBattle,true)then
return
end
local t=CheckRoundMaxSkipBattle()
if not t and ModulesInit.ProcedureNormalBattle.openSkipFromOut==false then
if ModulesInit.ExpeditionManager:MapIsThrough(Constant.bossSkipEaseMapId)then
UIUtil.ShowCommonTips(GameTools.GetLocalize("noskip_battle_tips",LanguageCategory.LangCommon,Constant.bossSkipEaseRound-1))
else
UIUtil.ShowCommonTips(GameTools.GetLocalize("noskip_battle_tips",LanguageCategory.LangCommon,Constant.bossSkipButtonShow-1))
end
return
end
if ModulesInit.ProcedureNormalBattle.BattleType==e.dragonWar then
if b>0 then
UIUtil.ShowCommonTipsForLocalize('UI.dragon.Settlement.30',LanguageCategory.LangCommon,b)
return
end
elseif ModulesInit.ProcedureNormalBattle.BattleType==e.maze then
end
ModulesInit.PhotoArtistMgr:SaveShowNew(ModulesInit.PhotoArtistMgr.NEW_ID.BattleBtnSkip)
RefreshSkipNewTip()
if o then
ModulesInit.ProcedureNormalBattle.FinalBattleEnd(ModulesInit.ProcedureNormalBattle.BattleType)
return
end
GameEntry.UI:OpenUIForm(UIFormId.UI_NormalBattleSkipView,{closeDoorCallback=function()
ModulesInit.ProcedureNormalBattle.SkipBattle()
end})
end
function OnInit(e,e)
btnPause.onClick:AddListener(
function()
if ModulesInit.ProcedureNormalBattle.isAlreadyShowBattleEnd then
return
end
GameEntry.UI:OpenUIForm(UIFormId.UI_NormalBattle_Pause)
end
)
btnSkip.onClick:AddListener(
function()
OnClickSkipBattle()
end
)
btnAuto.onClick:AddListener(
function()
if ModulesInit.ProcedureNormalBattle.isAlreadyShowBattleEnd then
return
end
if n==false then
return
end
if not GameFunction.IsFunctionUnLock(GameFunctionType.BattleAuto,true)then
return
end
if o then
return
end
ModulesInit.PhotoArtistMgr:SaveShowNew(ModulesInit.PhotoArtistMgr.NEW_ID.BattleBtnAuto)
RefreshAutoNewTip()
h=not h
LuaUtils.SetChildActive(btnAuto.transform,'im_on',h)
LuaUtils.SetChildActive(btnAuto.transform,'im_off',not h)
if(h)then
ModulesInit.ProcedureNormalBattle.ChangeToAuto(true)
else
ModulesInit.ProcedureNormalBattle.ChangeToManual()
end
end)
btnTwoSpeed.onClick:AddListener(
function()
if ModulesInit.ProcedureNormalBattle.isAlreadyShowBattleEnd then
return
end
if n==false then
return
end
if not GameFunction.IsFunctionUnLock(GameFunctionType.DoubleSpeed,true)then
return
end
ModulesInit.ProcedureNormalBattle.SetGameSpeed()
if(ModulesInit.ProcedureNormalBattle.GameSpeed==1)then
LuaUtils.SetChildActive(btnTwoSpeed.transform,'im_on',false)
LuaUtils.SetChildActive(btnTwoSpeed.transform,'im_off',true)
else
LuaUtils.SetChildActive(btnTwoSpeed.transform,'im_on',true)
LuaUtils.SetChildActive(btnTwoSpeed.transform,'im_off',false)
end
end
)
btnFastSkill.onClick:AddListener(
function()
if ModulesInit.ProcedureNormalBattle.isAlreadyShowBattleEnd then
return
end
if n==false then
return
end
if not GameFunction.IsFunctionUnLock(GameFunctionType.BattleFastSkill,true)then
return
end
ModulesInit.ProcedureNormalBattle.ChangeGameFastSkill()
CheckFastSkill()
end
)
btn_Explosive_All.onClick:AddListener(
function()
ModulesInit.ProcedureNormalBattle.CurrAttackTeam:ExplosiveAll()
end
)
btnHelp.onClick:AddListener(
function()
if ModulesInit.ProcedureNormalBattle.isAlreadyShowBattleEnd then
return
end
GameEntry.UI:OpenUIForm(UIFormId.UI_PhotoArtistView,{helpId="Skill.Help"})
end
)
LuaUtils.SetActive(btnHelp.transform,GameTools:IsReview()==false)
guideBattlejihuo.onClick:AddListener(
function()
if ModulesInit.ProcedureNormalBattle.isAlreadyShowBattleEnd then
return
end
ModulesInit.ProcedureNormalBattle.OnClickJihuoCallBack(-3)
LuaUtils.SetActive(guideBattlejihuo.transform,false)
end
)
btn_battle_preview_skip.onClick:AddListener(
function()
ModulesInit.BattlePreviewMgr:SkipAllPreview()
end
)
btn_preivew_touch.onClick:AddListener(
function()
StartShowPreviewSkip()
end
)
btnBuff.onClick:AddListener(
function()
ShowBuffView(f==false)
end
)
btnLeftClosebuff.onClick:AddListener(
function()
ShowBuffView(false)
end
)
btnRightClosebuff.onClick:AddListener(
function()
ShowBuffView(false)
end
)
btn_arrow.onClick:AddListener(OnBtnEliteArrow)
btn_arrowbg.onClick:AddListener(OnBtnEliteArrow)
ScrollViewBuff:InitListView(0,OnGetItemByIndex)
ScrollViewBuff.ScrollRect.enabled=false
local e=UI_BattleItemFly:GetComponent(typeof(CS.YouYou.LuaUnit))
e:Init()
end
function OnOpen(d)
A=false
b=15
v=d
m=false
o=ModulesInit.ProcedureNormalBattle.FightPlayData~=nil
n=nil
if v and v.showOperMenu==false then
n=false
end
_=true
r={}
RefreshActScrollView(true)
LuaUtils.SetActive(UI_BigSkillPress,false)
LuaUtils.SetActive(bg_wave.transform,false)
ShowBtnAuto(true)
h=false
LuaUtils.SetChildActive(btnAuto.transform,'im_on',h)
LuaUtils.SetChildActive(btnAuto.transform,'im_off',not h)
LuaUtils.SetActive(HeroListContainer,true)
LuaUtils.SetActive(TopCenter,true)
LuaUtils.SetActive(longzhan,false)
LuaUtils.SetActive(btn_Explosive_All.transform,false)
LuaUtils.SetActive(btn_Explosive_Cancel.transform,false)
LuaUtils.SetActive(black_cover.transform,ModulesInit.ProcedureNormalBattle.IsShowDreamBlackImg==true)
LuaUtils.SetActive(btn_preivew_touch.transform,ModulesInit.ProcedureNormalBattle.BattleType==e.skillPreview)
CheckShowPreviewSkip()
LuaUtils.SetActive(guideBattlejihuo.transform,false)
if ModulesInit.GuideMgr.isGuide then
LuaUtils.SetActive(guideBattlejihuo.transform,true)
end
ShowBattleTip(false)
EventSystem.AddListener(CommonEventId.Skill_BattleUI_Hide,OnSkill_BattleUI_Hide)
EventSystem.AddListener(CommonEventId.Skill_BattleUI_Show,OnSkill_BattleUI_Show)
EventSystem.AddListener(CommonEventId.Skill_BattleUI_Reset,OnSkill_BattleUI_Reset)
EventSystem.AddListener(CommonEventId.OnNextRoundChangeToManual,OnNextRoundChangeToManual)
EventSystem.AddListener(CommonEventId.OnNormalBattle_ShowAutoTip,NormalBattle_ShowAutoTip)
EventSystem.AddListener(CommonEventId.HideBattleHeadList,SetHeroHeadListEnable)
EventSystem.AddListener(CommonEventId.OnLoadNormalBattleMonster,OnLoadNormalBattleMonster)
EventSystem.AddListener(CommonEventId.OnBattleHeroSupplement,OnBattleHeroSupplement)
EventSystem.AddListener(CommonEventId.OnShowOrHideExplosiveUI,OnShowOrHideExplosiveUI)
EventSystem.AddListener(CommonEventId.OnBattleBigRoundBegin,OnBattleBigRoundBegin)
EventSystem.AddListener(CommonEventId.OnHeroPlayBigSkillBegin,OnHeroPlayBigSkillBegin)
EventSystem.AddListener(CommonEventId.OnHeroPlayBigSkillEnd,OnHeroPlayBigSkillEnd)
EventSystem.AddListener(CommonEventId.OnEventReloadHeroItem,OnEventReloadHeroItem)
EventSystem.AddListener(CommonEventId.ExpeditionMonsterInfoUpdate,OnExpeditionMonsterInfoUpdate)
EventSystem.AddListener(CommonEventId.OnEventHideBattleUI,OnEventHideBattleUI)
EventSystem.AddListener(CommonEventId.OnEventShowBattleTip,OnEventShowBattleTip)
EventSystem.AddListener(CommonEventId.OnEventBossBuffTip,OnEventBossBuffTip)
EventSystem.AddListener(CommonEventId.OnBattle1v1RoundChange,OnBattle1v1RoundChange)
EventSystem.AddListener(CommonEventId.OnSetGuideBattleSpeed,OnSetGuideBattleSpeed)
EventSystem.AddListener(CommonEventId.OnEventBattleFlyFinish,OnEventBattleFlyFinish)
EventSystem.AddListener(CommonEventId.OnSendBattleFouces,OnSendBattleFouces)
EventSystem.AddListener(CommonEventId.OnBattleShowPreviewBtn,OnBattleShowPreviewBtn)
EventSystem.AddListener(CommonEventId.OnGuideClickBattleAtk,OnGuideClickBattleAtk)
EventSystem.AddListener(CommonEventId.OnBattleHeroDeath,OnBattleHeroDeath)
EventSystem.AddListener(CommonEventId.OnBattleHeroBuffChange,OnBattleHeroBuffChange)
EventSystem.AddListener(SysEventId.OnUpdate,OnUpdate)
OnLoadNormalBattleMonster()
T={}
g=false
LuaUtils.SetActive(UI_BattleItemFly.transform,true)
local o=UI_BattleItemFly:GetComponent(typeof(CS.YouYou.LuaUnit))
o:Open({battleBoxPosition=im_ui_battle_box.transform.position})
ShowBuffView(false)
w=0
if ModulesInit.ProcedureNormalBattle.dropBoxData and#ModulesInit.ProcedureNormalBattle.dropBoxData>0 then
LuaUtils.SetActive(trans_battle_box.transform,true)
LuaUtils.SetTextMeshText(text_battle_box_count,w)
else
LuaUtils.SetActive(trans_battle_box.transform,false)
end
O=false
if(a==nil)then
a={}
end
LoadHeroList()
CheckGameFunction()
CheckSkipBtnState()
CheckPauseBtnState()
CheckAutoModeState()
CheckSpeedState()
CheckFastSkill()
OnBattleBigRoundBegin()
OnKillDragonCountDown()
CheckShowBtnState()
if(GameInit.IsClient)then
ModulesInit.GuideMgr:CheckGuideByBattleStart()
end
if ModulesInit.ProcedureNormalBattle.BattleType==e.elite then
local a=ModulesInit.ProcedureNormalBattle.MapId
local e=require('DataNode/DataTable/Create/maps/DTEliteMapsDBModel')
local a=e.GetEntity(a)
LuaUtils.SetActive(cizhui_group.transform,true)
for e=1,ModulesInit.EliteMgr.ELITE_MAGIC_ENTRY_MAX do
LuaUtils.SetActive(selfEnv["text_cizhui"..e].transform,false)
end
for e,t in ipairs(a.monsterInfo1)do
LuaUtils.SetTextMeshText(selfEnv["text_cizhui"..e],GameTools.GetLocalize(t,LanguageCategory.LangCommon))
LuaUtils.SetActive(selfEnv["text_cizhui"..e].transform,true)
end
s=false
local e,o,a=LuaUtils.GetLocalPos(cizhui_group.transform)
LuaUtils.SetLocalPos(cizhui_group.transform,e,E,a)
LuaUtils.SetLocalScale(btn_arrow.transform,t,t,t)
local e=CS.DG.Tweening.DOTween.Sequence()
e:AppendInterval(8)
e:AppendCallback(function()
LuaUtils.DoTweenDLocalPosMoveY(cizhui_group.transform,k,0.5,function()
c=false
s=true
LuaUtils.SetLocalScale(btn_arrow.transform,t,-t,t)
i=nil
end)
end)
i=e
elseif ModulesInit.ProcedureNormalBattle.BattleType==e.carnival then
local a=ModulesInit.ProcedureNormalBattle.MapId
local e=require('DataNode/DataTable/Create/activity/DTCarnivalMapWaveDBModel')
local e=e.GetEntity(a)
LuaUtils.SetActive(cizhui_group.transform,false)
for e=1,ModulesInit.EliteMgr.ELITE_MAGIC_ENTRY_MAX do
LuaUtils.SetActive(selfEnv["text_cizhui"..e].transform,false)
end
s=false
local e,o,a=LuaUtils.GetLocalPos(cizhui_group.transform)
LuaUtils.SetLocalPos(cizhui_group.transform,e,E,a)
LuaUtils.SetLocalScale(btn_arrow.transform,t,t,t)
local e=CS.DG.Tweening.DOTween.Sequence()
e:AppendInterval(8)
e:AppendCallback(function()
LuaUtils.DoTweenDLocalPosMoveY(cizhui_group.transform,k,0.5,function()
c=false
s=true
LuaUtils.SetLocalScale(btn_arrow.transform,t,-t,t)
i=nil
end)
end)
i=e
elseif ModulesInit.ProcedureNormalBattle.BattleType==e.GoldHoliday then
local e=ModulesInit.ProcedureNormalBattle.MapId
local a=require("DataNode/DataTable/Create/activity/DTGoldHolidaylMapWaveDBModel")
local e=a.GetEntity(e)
LuaUtils.SetActive(cizhui_group.transform,false)
for e=1,ModulesInit.EliteMgr.ELITE_MAGIC_ENTRY_MAX do
LuaUtils.SetActive(selfEnv["text_cizhui"..e].transform,false)
end
s=false
local e,o,a=LuaUtils.GetLocalPos(cizhui_group.transform)
LuaUtils.SetLocalPos(cizhui_group.transform,e,E,a)
LuaUtils.SetLocalScale(btn_arrow.transform,t,t,t)
local e=CS.DG.Tweening.DOTween.Sequence()
e:AppendInterval(8)
e:AppendCallback(function()
LuaUtils.DoTweenDLocalPosMoveY(cizhui_group.transform,k,0.5,function()
c=false
s=true
LuaUtils.SetLocalScale(btn_arrow.transform,t,-t,t)
i=nil
end)
end)
i=e
else
LuaUtils.SetActive(cizhui_group.transform,false)
end
if ModulesInit.ProcedureNormalBattle.BattleType==e.waterMelon then
GameTools:PoolGameObjectSpawn(
SysPrefabId.Battle_armor,
nil,
function(e,t,t)
local t=EnemyInfo:Find("imgPlayerHPBG/imgPlayerShield/trans_shield_frame/trans_shield_point")
if t then
LuaUtils.SetParent(e,t)
LuaUtils.SetLocalPos(e,0,0,0)
LuaUtils.SetLocalScale(e,1,1,1)
end
end
)
end
RefreshAutoNewTip()
RefreshSkipNewTip()
CheckAutoBattle()
end
function CheckAutoBattle()
if ModulesInit.AutoBattleMgr.isAuto==true then
if ModulesInit.ProcedureNormalBattle.BattleType~=e.campaign
and ModulesInit.ProcedureNormalBattle.BattleType~=e.urTestFight
and ModulesInit.ProcedureNormalBattle.BattleType~=e.lrTestFight then
ModulesInit.AutoBattleMgr:SetIsAuto(false)
return
end
local t=ModulesInit.AutoBattleMgr:GetCurFuncType()
if t==ModulesInit.AutoBattleMgr.AutoFuncType.MainChapter
or t==ModulesInit.AutoBattleMgr.AutoFuncType.URChapter
then
local e=ModulesInit.AutoBattleMgr.autoDict[t]
e.UIFormId=self.UIFormId
if e.curStep==ModulesInit.AutoBattleMgr.AutoExecuteResult.ClickEnterBattle
or e.curStep==ModulesInit.AutoBattleMgr.AutoExecuteResult.ClickSkipBattle then
e.clickCallBack=nil
local a=ModulesInit.AutoBattleMgr.AutoExecuteResult.ClickSkipBattle
ModulesInit.AutoBattleMgr:SetAutoDataNextStep(t,a)
if ModulesInit.ProcedureNormalBattle.IsAutoMode==false and GameFunction.IsFunctionUnLock(GameFunctionType.BattleAuto)then
ModulesInit.ProcedureNormalBattle.ChangeToAuto(true)
LuaUtils.SetChildActive(btnAuto.transform,'im_on',ModulesInit.ProcedureNormalBattle.IsAutoMode)
LuaUtils.SetChildActive(btnAuto.transform,'im_off',ModulesInit.ProcedureNormalBattle.IsAutoMode==false)
end
if GameFunction.IsFunctionUnLock(GameFunctionType.DoubleSpeed,false)then
if ModulesInit.ProcedureNormalBattle.GameSpeed==1 then
ModulesInit.ProcedureNormalBattle.SetGameSpeed()
if(ModulesInit.ProcedureNormalBattle.GameSpeed==1)then
LuaUtils.SetChildActive(btnTwoSpeed.transform,'im_on',false)
LuaUtils.SetChildActive(btnTwoSpeed.transform,'im_off',true)
else
LuaUtils.SetChildActive(btnTwoSpeed.transform,'im_on',true)
LuaUtils.SetChildActive(btnTwoSpeed.transform,'im_off',false)
end
end
end
if ModulesInit.ProcedureNormalBattle.isAlreadyShowBattleEnd then
return
end
if not GameFunction.IsFunctionUnLock(GameFunctionType.SkipBattle,true)then
return
end
local a=CheckRoundMaxSkipBattle()
if not a and ModulesInit.ProcedureNormalBattle.openSkipFromOut==false then
return
end
e.clickCallBack=function()
OnClickSkipBattle()
end
ModulesInit.AutoBattleMgr:OnDelayExecute(t)
else
end
end
end
end
function RefreshAutoNewTip()
LuaUtils.SetActive(im_new_auto.transform,false)
if GameFunction.IsFunctionUnLock(GameFunctionType.BattleAuto)
and ModulesInit.PhotoArtistMgr:checkShowNew(ModulesInit.PhotoArtistMgr.NEW_ID.BattleBtnAuto)
and CheckShowNewDate()then
LuaUtils.SetActive(im_new_auto.transform,true)
end
end
function RefreshSkipNewTip()
LuaUtils.SetActive(im_new_skip.transform,false)
if GameFunction.IsFunctionUnLock(GameFunctionType.SkipBattle)
and ModulesInit.PhotoArtistMgr:checkShowNew(ModulesInit.PhotoArtistMgr.NEW_ID.BattleBtnSkip)
and CheckShowNewDate()then
LuaUtils.SetActive(im_new_skip.transform,true)
end
end
function CheckShowNewDate()
local e={year=2022,month=8,day=24,hour=3,minute=5,second=0}
local e=TimeUtil.dateToTimeStampWithserverZone(e)
if PlayerMgr and PlayerMgr.PlayerInfo and PlayerMgr.PlayerInfo.createTime>e*1000 then
return true
end
return false
end
function OnPlayBgMusic()
end
function OnBattleBigRoundBegin()
local t=math.max(1,ModulesInit.ProcedureNormalBattle.CurrBattleBigRound)
if ModulesInit.ProcedureNormalBattle.BattleType==e.skillPreview then
LuaUtils.SetActive(txtRound.transform,false)
else
LuaUtils.SetActive(txtRound.transform,true)
end
UIUtil.SetTextMeshTextForLocalize(txtRound,"UI.Campaign.Battle.01",LanguageCategory.LangCommon,t,ModulesInit.ProcedureNormalBattle.MaxBattleBigRound)
if(GameFunction.IsFunctionUnLock(GameFunctionType.SkipBattle)and ModulesInit.ProcedureNormalBattle.openSkipFromOut)then
LuaUtils.SetActive(im_Skip_Auto.transform,false)
else
local e=false
if not GameFunction.IsFunctionUnLock(GameFunctionType.SkipBattle)then
e=false
else
e=CheckRoundMaxSkipBattle()
end
if im_Skip_Auto.transform.gameObject.activeSelf==true and e==true then
if A==false and t>1 then
A=true
CheckAutoBattle()
end
end
LuaUtils.SetActive(im_Skip_Auto.transform,not e)
end
end
function CheckRoundMaxSkipBattle()
if ModulesInit.ProcedureNormalBattle.BattleType==e.campaign then
local e=math.max(1,ModulesInit.ProcedureNormalBattle.CurrBattleBigRound)
if ModulesInit.ExpeditionManager:MapIsThrough(Constant.bossSkipEaseMapId)then
if e>=Constant.bossSkipEaseRound then
return true
end
else
if e>=Constant.bossSkipButtonShow then
return true
end
end
end
return false
end
function OnBattle1v1RoundChange()
local e=ModulesInit.ProcedureNormalBattle.GetBattle1V1SmallStartRound()
local e=math.max(1,math.ceil(e/2))
UIUtil.SetTextMeshTextForLocalize(txtRound,"UI.Campaign.Battle.01",LanguageCategory.LangCommon,e,ModulesInit.ProcedureNormalBattle.MaxBattleBigRound)
end
function CheckGameFunction()
if n==false then
ShowAllOperBtn(false)
return
end
if(GameFunction.IsFunctionUnLock(GameFunctionType.BattleAuto))then
LuaUtils.SetActive(im_lock_Auto.transform,false)
else
LuaUtils.SetActive(im_lock_Auto.transform,true)
end
if(GameFunction.IsFunctionUnLock(GameFunctionType.SkipBattle)and ModulesInit.ProcedureNormalBattle.openSkipFromOut)then
LuaUtils.SetActive(im_Skip_Auto.transform,false)
else
LuaUtils.SetActive(im_Skip_Auto.transform,true)
end
if(GameFunction.IsFunctionUnLock(GameFunctionType.DoubleSpeed))then
LuaUtils.SetActive(im_lock_TwoSpeed.transform,false)
else
LuaUtils.SetActive(im_lock_TwoSpeed.transform,true)
end
if(GameFunction.IsFunctionUnLock(GameFunctionType.BattleFastSkill))then
LuaUtils.SetActive(im_lock_FastSkill.transform,false)
else
LuaUtils.SetActive(im_lock_FastSkill.transform,true)
end
end
function CheckSkipBtnState()
local t=L.GetEntity(ModulesInit.ProcedureNormalBattle.BattleType)
local e=true
if t then
e=t.canSkip==1
end
LuaUtils.SetActive(btnSkip.transform,e)
end
function CheckPauseBtnState()
if ModulesInit.ProcedureNormalBattle.BattleType==e.dragonWar or
ModulesInit.ProcedureNormalBattle.BattleType==e.arena or
ModulesInit.ProcedureNormalBattle.BattleType==e.WarOfAttrition or
ModulesInit.ProcedureNormalBattle.BattleType==e.islandEscort or
ModulesInit.ProcedureNormalBattle.BattleType==e.spaceArena or
ModulesInit.ProcedureNormalBattle.BattleType==e.friendArena or
ModulesInit.ProcedureNormalBattle.BattleType==e.flower or
ModulesInit.ProcedureNormalBattle.BattleType==e.waterMelon or
ModulesInit.ProcedureNormalBattle.BattleType==e.guildBossPersonal or
ModulesInit.ProcedureNormalBattle.BattleType==e.guildBossGuild or
ModulesInit.ProcedureNormalBattle.BattleType==e.urBackBossFight or
ModulesInit.ProcedureNormalBattle.BattleType==e.mineBattle or
ModulesInit.ProcedureNormalBattle.BattleType==e.skillPreview or
ModulesInit.ProcedureNormalBattle.BattleType==e.GuildRadar or
ModulesInit.ProcedureNormalBattle.BattleType==e.girlChallenge then
LuaUtils.SetActive(btnPause.transform,false)
ShowBtnAuto(false)
LuaUtils.SetActive(btnHelp.transform,false)
return
end
if ModulesInit.ProcedureNormalBattle.BattleType==e.trial and o then
ShowBtnAuto(false)
LuaUtils.SetActive(btnPause.transform,true)
LuaUtils.SetActive(btnHelp.transform,false)
return
end
if ModulesInit.ProcedureNormalBattle.BattleType==e.burningBuild then
ShowBtnAuto(o==false)
LuaUtils.SetActive(btnPause.transform,true)
LuaUtils.SetActive(btnHelp.transform,false)
return
end
if ModulesInit.ProcedureNormalBattle.BattleType==e.cityWar then
ShowBtnAuto(false)
LuaUtils.SetActive(btnPause.transform,true)
LuaUtils.SetActive(btnHelp.transform,false)
return
end
if ModulesInit.ProcedureNormalBattle.BattleType==e.richMan then
ShowBtnAuto(false)
LuaUtils.SetActive(btnPause.transform,false)
LuaUtils.SetActive(btnHelp.transform,false)
return
elseif ModulesInit.ProcedureNormalBattle.BattleType==e.Inspiration then
ShowBtnAuto(true)
LuaUtils.SetActive(btnPause.transform,false)
LuaUtils.SetActive(btnHelp.transform,false)
return
end
if(GameInit.IsClient)and ModulesInit.ExpeditionManager:MapIsThrough(11010)==false then
LuaUtils.SetActive(btnPause.transform,false)
else
LuaUtils.SetActive(btnPause.transform,true)
end
if(GameInit.IsClient)and ModulesInit.ExpeditionManager:MapIsThrough(11002)==false then
LuaUtils.SetActive(btnHelp.transform,false)
else
LuaUtils.SetActive(btnHelp.transform,true)
end
if ModulesInit.ProcedureNormalBattle.BattleType==e.elite then
LuaUtils.SetActive(btnHelp.transform,false)
end
if ModulesInit.ProcedureNormalBattle.BattleType==e.carnival then
LuaUtils.SetActive(btnHelp.transform,false)
end
if ModulesInit.ProcedureNormalBattle.BattleType==e.GoldHoliday then
LuaUtils.SetActive(btnHelp.transform,false)
end
ShowBtnAuto(o==false)
if GameTools:IsReview()then
LuaUtils.SetActive(btnHelp.transform,false)
end
if o then
LuaUtils.SetActive(btnPause.transform,false)
end
end
function OnNextRoundChangeToManual()
end
function OnSetGuideBattleSpeed()
CheckSpeedState()
end
function OnEventBattleFlyFinish(e)
local e=e.flyFlag
if e=="battle_box_key"then
local e=root_battle_box.gameObject:GetComponent(typeof(CS.UnityEngine.Animator))
e.enabled=true
LuaUtils.AnimtorPlay(e,"battle_box_breath",0,0)
w=w+1
LuaUtils.SetTextMeshText(text_battle_box_count,w)
end
end
function OnGuideClickBattleAtk(e)
if e and e.type==1 then
local e=a[1]
e:Click()
elseif e and e.type==2 then
local e=a[1]
e.IsLongPress=true
e:MouseUpOut()
end
end
function OnBattleHeroDeath(e)
CheckRefreshBuffView()
end
function OnBattleHeroBuffChange(e)
local e=e.heroId
T[e]=true
g=true
end
function OnUpdate()
if g==true then
g=false
CheckRefreshBuffView()
T={}
end
end
function OnBattleShowPreviewBtn(e)
if e==nil then
return
end
if e.showState=="hide"then
LuaUtils.SetActive(btn_battle_preview_skip.transform,false)
elseif e.showState=="check"then
CheckShowPreviewSkip()
end
end
function CheckSpeedState()
local e=1
if(ModulesInit.ProcedureNormalBattle.GameSpeed==1)then
e=1
elseif(ModulesInit.ProcedureNormalBattle.GameSpeed==1.5)then
e=2
elseif(ModulesInit.ProcedureNormalBattle.GameSpeed==2)then
e=3
end
if(e==1)then
LuaUtils.SetChildActive(btnTwoSpeed.transform,'im_on',false)
LuaUtils.SetChildActive(btnTwoSpeed.transform,'im_off',true)
else
LuaUtils.SetChildActive(btnTwoSpeed.transform,'im_on',true)
LuaUtils.SetChildActive(btnTwoSpeed.transform,'im_off',false)
end
end
function CheckFastSkill()
if(ModulesInit.ProcedureNormalBattle.GameFastSkill==false)then
LuaUtils.SetChildActive(btnFastSkill.transform,'im_on',false)
LuaUtils.SetChildActive(btnFastSkill.transform,'im_off',true)
else
LuaUtils.SetChildActive(btnFastSkill.transform,'im_on',true)
LuaUtils.SetChildActive(btnFastSkill.transform,'im_off',false)
end
end
function CheckAutoModeState()
if(ModulesInit.ProcedureNormalBattle.IsAutoMode)then
LuaUtils.SetChildActive(btnAuto.transform,'im_on',true)
LuaUtils.SetChildActive(btnAuto.transform,'im_off',false)
else
LuaUtils.SetChildActive(btnAuto.transform,'im_on',false)
LuaUtils.SetChildActive(btnAuto.transform,'im_off',true)
end
end
function HideEffectWhenHideUI()
end
function ShowEffectWhenShowUI()
end
function OnClose()
if d then
d:Stop()
d=nil
end
if l then
l:OnClose()
l=nil
end
if u then
u:OnClose()
u=nil
end
if i then
i:Kill()
i=nil
end
if p then
p:Kill()
p=nil
end
StopDelaySequenceShowPreviewSkip()
if ModulesInit.ProcedureNormalBattle.BattleType==e.waterMelon then
local e=EnemyInfo:Find("imgPlayerHPBG/imgPlayerShield/trans_shield_frame/trans_shield_point")
UIUtil.CleanChildrenAndDespawn(e.transform)
end
LuaUtils.SetActive(bg_wave.transform,false)
EventSystem.RemoveListener(CommonEventId.Skill_BattleUI_Hide,OnSkill_BattleUI_Hide)
EventSystem.RemoveListener(CommonEventId.Skill_BattleUI_Show,OnSkill_BattleUI_Show)
EventSystem.RemoveListener(CommonEventId.Skill_BattleUI_Reset,OnSkill_BattleUI_Reset)
EventSystem.RemoveListener(CommonEventId.OnNextRoundChangeToManual,OnNextRoundChangeToManual)
EventSystem.RemoveListener(CommonEventId.OnNormalBattle_ShowAutoTip,NormalBattle_ShowAutoTip)
EventSystem.RemoveListener(CommonEventId.HideBattleHeadList,SetHeroHeadListEnable)
EventSystem.RemoveListener(CommonEventId.OnLoadNormalBattleMonster,OnLoadNormalBattleMonster)
EventSystem.RemoveListener(CommonEventId.OnBattleHeroSupplement,OnBattleHeroSupplement)
EventSystem.RemoveListener(CommonEventId.OnShowOrHideExplosiveUI,OnShowOrHideExplosiveUI)
EventSystem.RemoveListener(CommonEventId.OnBattleBigRoundBegin,OnBattleBigRoundBegin)
EventSystem.RemoveListener(CommonEventId.OnHeroPlayBigSkillBegin,OnHeroPlayBigSkillBegin)
EventSystem.RemoveListener(CommonEventId.OnHeroPlayBigSkillEnd,OnHeroPlayBigSkillEnd)
EventSystem.RemoveListener(CommonEventId.OnEventReloadHeroItem,OnEventReloadHeroItem)
EventSystem.RemoveListener(CommonEventId.ExpeditionMonsterInfoUpdate,OnExpeditionMonsterInfoUpdate)
EventSystem.RemoveListener(CommonEventId.OnEventHideBattleUI,OnEventHideBattleUI)
EventSystem.RemoveListener(CommonEventId.OnEventShowBattleTip,OnEventShowBattleTip)
EventSystem.RemoveListener(CommonEventId.OnEventBossBuffTip,OnEventBossBuffTip)
EventSystem.RemoveListener(CommonEventId.OnSendBattleFouces,OnSendBattleFouces)
EventSystem.RemoveListener(CommonEventId.OnBattle1v1RoundChange,OnBattle1v1RoundChange)
EventSystem.RemoveListener(CommonEventId.OnSetGuideBattleSpeed,OnSetGuideBattleSpeed)
EventSystem.RemoveListener(CommonEventId.OnEventBattleFlyFinish,OnEventBattleFlyFinish)
EventSystem.RemoveListener(CommonEventId.OnBattleShowPreviewBtn,OnBattleShowPreviewBtn)
EventSystem.RemoveListener(CommonEventId.OnGuideClickBattleAtk,OnGuideClickBattleAtk)
EventSystem.RemoveListener(CommonEventId.OnBattleHeroDeath,OnBattleHeroDeath)
EventSystem.RemoveListener(CommonEventId.OnBattleHeroBuffChange,OnBattleHeroBuffChange)
EventSystem.RemoveListener(SysEventId.OnUpdate,OnUpdate)
UnLoadHeroList()
local e=UI_BattleItemFly:GetComponent(typeof(CS.YouYou.LuaUnit))
e:Close()
ModulesInit.AutoBattleMgr.lastExecuteStepEndTime=TimeUtil.GetServerTimeStamp()
end
function OnBeforeDestroy()
end
function OnHeroPlayBigSkillBegin()
LuaUtils.SetActive(btnHelp.transform,false)
end
function OnHeroPlayBigSkillEnd()
if n==false then
ShowAllOperBtn(false)
return
end
if ModulesInit.ProcedureNormalBattle.BattleType==e.dragonWar or
ModulesInit.ProcedureNormalBattle.BattleType==e.arena or
ModulesInit.ProcedureNormalBattle.BattleType==e.WarOfAttrition or
ModulesInit.ProcedureNormalBattle.BattleType==e.islandEscort or
ModulesInit.ProcedureNormalBattle.BattleType==e.friendArena or
ModulesInit.ProcedureNormalBattle.BattleType==e.spaceArena or
ModulesInit.ProcedureNormalBattle.BattleType==e.flower or
ModulesInit.ProcedureNormalBattle.BattleType==e.waterMelon or
ModulesInit.ProcedureNormalBattle.BattleType==e.guildBossPersonal or
ModulesInit.ProcedureNormalBattle.BattleType==e.guildBossGuild or
ModulesInit.ProcedureNormalBattle.BattleType==e.urBackBossFight or
ModulesInit.ProcedureNormalBattle.BattleType==e.mineBattle or
ModulesInit.ProcedureNormalBattle.BattleType==e.skillPreview or
ModulesInit.ProcedureNormalBattle.BattleType==e.girlChallenge or
ModulesInit.ProcedureNormalBattle.BattleType==e.GuildRadar
then
LuaUtils.SetActive(btnPause.transform,false)
ShowBtnAuto(false)
LuaUtils.SetActive(btnHelp.transform,false)
CheckSkipBtnState()
LuaUtils.SetActive(btnTwoSpeed.transform,true)
elseif ModulesInit.ProcedureNormalBattle.BattleType==e.burningBuild then
LuaUtils.SetActive(btnPause.transform,true)
ShowBtnAuto(false)
LuaUtils.SetActive(btnHelp.transform,false)
CheckSkipBtnState()
LuaUtils.SetActive(btnTwoSpeed.transform,true)
elseif ModulesInit.ProcedureNormalBattle.BattleType==e.cityWar then
LuaUtils.SetActive(btnPause.transform,true)
ShowBtnAuto(false)
LuaUtils.SetActive(btnHelp.transform,false)
CheckSkipBtnState()
LuaUtils.SetActive(btnTwoSpeed.transform,true)
elseif ModulesInit.ProcedureNormalBattle.BattleType==e.richMan then
LuaUtils.SetActive(btnPause.transform,false)
ShowBtnAuto(false)
LuaUtils.SetActive(btnHelp.transform,false)
CheckSkipBtnState()
LuaUtils.SetActive(btnTwoSpeed.transform,true)
elseif ModulesInit.ProcedureNormalBattle.BattleType==e.Inspiration then
LuaUtils.SetActive(btnPause.transform,false)
ShowBtnAuto(true)
LuaUtils.SetActive(btnHelp.transform,false)
CheckSkipBtnState()
LuaUtils.SetActive(btnTwoSpeed.transform,true)
else
if(GameInit.IsClient)and
ModulesInit.ExpeditionManager:MapIsThrough(11010)==false then
LuaUtils.SetActive(btnPause.transform,false)
else
LuaUtils.SetActive(btnPause.transform,true)
end
if(GameInit.IsClient)and
ModulesInit.ExpeditionManager:MapIsThrough(11002)==false then
LuaUtils.SetActive(btnHelp.transform,false)
else
LuaUtils.SetActive(btnHelp.transform,true)
end
LuaUtils.SetActive(btnSkip.transform,true)
ShowBtnAuto(true)
LuaUtils.SetActive(btnTwoSpeed.transform,true)
if ModulesInit.ProcedureNormalBattle.BattleType==e.elite then
LuaUtils.SetActive(btnHelp.transform,false)
end
if ModulesInit.ProcedureNormalBattle.BattleType==e.carnival then
LuaUtils.SetActive(btnHelp.transform,false)
end
if ModulesInit.ProcedureNormalBattle.BattleType==e.GoldHoliday then
LuaUtils.SetActive(btnHelp.transform,false)
end
end
ShowBtnAuto(o==false)
if GameTools:IsReview()then
LuaUtils.SetActive(btnHelp.transform,false)
end
if o then
LuaUtils.SetActive(btnPause.transform,false)
end
end
function OnEventReloadHeroItem()
ReloadHeroList()
end
function OnExpeditionMonsterInfoUpdate()
NormalBattle_LoadTeamInfo()
end
function NormalBattle_LoadTeamInfo()
if ModulesInit.ProcedureNormalBattle.BattleType==e.dragonWar then
l=UI_NormalBattle_TeamViewForKD:New()
l:Load(ModulesInit.ProcedureNormalBattle.OurTeam,PlayerInfo2)
if ModulesInit.KillDragonsManager.CurFightInfo
and ModulesInit.KillDragonsManager.CurFightInfo.resultShow then
local e=ModulesInit.KillDragonsManager.CurFightInfo.resultShow.eliteId
local e=S.GetEntity(e)
local e=H.GetEntity(e.bossId)
LuaUtils.SetTextMeshText(team_desc_left,GameTools.GetLocalize(e.monName,LanguageCategory.LangBattle))
else
LuaUtils.SetTextMeshText(team_desc_left,"")
end
u=UI_NormalBattle_TeamView:New()
u:Load(ModulesInit.ProcedureNormalBattle.EnemyTeam,EnemyInfo2)
LuaUtils.SetTextMeshText(team_desc_right,GameTools.GetLocalize("UI_Common_1",LanguageCategory.LangCommon))
else
local i=PlayerInfo
local o=EnemyInfo
local e=team_desc_left
local t=team_desc_right
local a=true
if ModulesInit.ProcedureNormalBattle:GetMirrorScaleX()==-1 then
i=EnemyInfo
o=PlayerInfo
e=team_desc_right
t=team_desc_left
a=false
end
l=UI_NormalBattle_TeamView:New()
l:Load(ModulesInit.ProcedureNormalBattle.OurTeam,i,ModulesInit.ProcedureNormalBattle.leftInfo,a)
if ModulesInit.ProcedureNormalBattle.leftInfo then
LuaUtils.SetTextMeshText(e,ModulesInit.ProcedureNormalBattle.leftInfo.name)
else
LuaUtils.SetTextMeshText(e,"")
end
u=UI_NormalBattle_TeamView:New()
u:Load(ModulesInit.ProcedureNormalBattle.EnemyTeam,o,ModulesInit.ProcedureNormalBattle.rightInfo,a==false)
if ModulesInit.ProcedureNormalBattle.leftInfo then
LuaUtils.SetTextMeshText(t,ModulesInit.ProcedureNormalBattle.rightInfo.name)
else
LuaUtils.SetTextMeshText(t,"")
end
end
end
function NormalBattle_LoadTeamArmor()
NormalBattle_LoadTeamArmorWithParent(armor_root_left)
NormalBattle_LoadTeamArmorWithParent(armor_root_right)
end
function NormalBattle_LoadTeamArmorWithParent(t)
NormalBattle_RemoveTeamArmorWithParent(t)
if ModulesInit.ProcedureNormalBattle.BattleType==e.waterMelon then
GameTools:PoolGameObjectSpawn(
prefabId,
nil,
function(e,a,a)
LuaUtils.SetParent(e,t)
LuaUtils.SetLocalEulerAngles(e,0,0,0)
LuaUtils.SetLocalPos(e,0,0,0)
LuaUtils.SetLayer(e,"UI")
end
)
end
end
function NormalBattle_RemoveTeamArmor()
NormalBattle_RemoveTeamArmorWithParent(armor_root_left)
NormalBattle_RemoveTeamArmorWithParent(armor_root_right)
end
function NormalBattle_RemoveTeamArmorWithParent(e)
UIUtil.CleanChildrenAndDespawn(e.transform)
end
function OnEventHideBattleUI(e)
local e=e.animName
local t=transform.gameObject:GetComponent(typeof(CS.UnityEngine.Animator))
t.enabled=true
LuaUtils.AnimtorPlay(t,e,0,0)
if e=="normal_battle_setup_out"then
_=false
else
_=true
end
end
function ShowBattleTip(e)
LuaUtils.SetActive(fadong.transform,e)
end
function OnEventShowBattleTip(a)
local t=a.battleState
local o=a.isOpen
local a=false
if ModulesInit.ProcedureNormalBattle.BattleType==e.campaign then
local e=ModulesInit.ProcedureNormalBattle.MapId
local e=R.GetEntity(e)
if e and e.bigStage==1 and e.smallStage<=6 then
a=true
end
end
if o==true and h==false and _==true and a==false then
local e="A"
if t=="bigSkill"then
e="A"
elseif t=="normalSkill"then
e="B"
end
LuaUtils.SetActive(fadong.transform,true)
UIUtil.SpinePlayAnimation(fadong,0,e,true,function()
LuaUtils.SetActive(fadong.transform,false)
end)
else
LuaUtils.SetActive(fadong.transform,false)
end
end
function NormalBattle_ShowAutoTip(e)
imgAutoTip.gameObject:YouYouSetActive(true)
if(e)then
txtAutoTip.text=GameTools.GetLocalize("Battle.Tips1",LanguageCategory.LangCommon)
else
txtAutoTip.text=GameTools.GetLocalize("Battle.Tips2",LanguageCategory.LangCommon)
end
if(j~=nil)then
j:Kill()
end
local e=0
local t=1
j=CS.DG.Tweening.DOTween.To(
function()
return e
end,
function(t)
e=t
end,
t,
0.2
):OnUpdate(
function()
imgAutoTip.alpha=e
end
):OnComplete(
function()
local e=1
local t=0
j=CS.DG.Tweening.DOTween.To(
function()
return e
end,
function(t)
e=t
end,
t,
0.2
):OnUpdate(
function()
imgAutoTip.alpha=e
end
):SetDelay(2)
end
)
end
function OnSkill_BattleUI_Hide(e)
O=true
if(e.ShowOrHideType==CS.MyCommonEnum.ShowOrHideType.Immediately)then
SetBattleCanvasGroupAlpha(0)
elseif(e.ShowOrHideType==CS.MyCommonEnum.ShowOrHideType.DoTween)then
local t=1
local a=0
p=CS.DG.Tweening.DOTween.To(
function()
return t
end,
function(e)
t=e
end,
a,
e.FadeIn
):OnUpdate(
function()
SetBattleCanvasGroupAlpha(t)
end
)
elseif(e.ShowOrHideType==CS.MyCommonEnum.ShowOrHideType.Animation)then
end
HideEffectWhenHideUI()
end
function SetBattleCanvasGroupAlpha(t)
local e=root_battle:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
e.alpha=t
end
function OnSkill_BattleUI_Show(e)
O=false
if(e.ShowOrHideType==CS.MyCommonEnum.ShowOrHideType.Immediately)then
SetBattleCanvasGroupAlpha(1)
elseif(e.ShowOrHideType==CS.MyCommonEnum.ShowOrHideType.DoTween)then
local t=0
local a=1
p=CS.DG.Tweening.DOTween.To(
function()
return t
end,
function(e)
t=e
end,
a,
e.FadeOut
):OnUpdate(
function()
SetBattleCanvasGroupAlpha(t)
end
)
elseif(e.ShowOrHideType==CS.MyCommonEnum.ShowOrHideType.Animation)then
end
ShowEffectWhenShowUI()
end
function OnSkill_BattleUI_Reset()
SetBattleCanvasGroupAlpha(1)
end
function LoadHeroList()
local e=#ModulesInit.ProcedureNormalBattle.OurTeam.HeroCtrls
LuaUtils.SetImageSizeDelta(bg_head_ditu,e*120+60,112)
local t=(e-1)*60
for e=1,e do
LoadHeroItem(t,e)
end
EventSystem.SendEvent(CommonEventId.OnBattleUILoadComplete)
end
function LoadHeroItem(n,i)
local t=ModulesInit.ProcedureNormalBattle.OurTeam.HeroCtrls[i]
local e=D:New(self)
e:OnOpen()
e:Load(t,HeroListContainer,n,i)
e.OnPressDown=function()
if ModulesInit.ProcedureNormalBattle.isAlreadyShowBattleEnd then
return
end
if(ModulesInit.ProcedureNormalBattle.IsSkillAttackType(EBattleSkillAttackType.BigSkillAttacking))then
if not m and not o then
if(e.heroItemTrans~=nil)then
UI_BigSkillPress.position=e.heroItemTrans.position
UI_BigSkillPress.gameObject:YouYouSetActive(true)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
end
end
end
e.OnShowClickEffect=function(t)
if ModulesInit.ProcedureNormalBattle.isAlreadyShowBattleEnd then
return
end
if not m and not o and ModulesInit.ProcedureNormalBattle.IsOpenShowHeadContainer then
GameEntry.Effect:ShowUIEffect(SysEffectId.UI_AvatarClick,self.Depth+30,EffectKeepType.AutoRelease,t.position.x,t.position.y,0)
end
end
e.OnPressUp=function()
if ModulesInit.ProcedureNormalBattle.isAlreadyShowBattleEnd then
return
end
if not m and not o then
UI_BigSkillPress.gameObject:YouYouSetActive(false)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
end
t.HeroHeadItem=e
a[#a+1]=e
end
function ReloadHeroList()
local t=ModulesInit.ProcedureNormalBattle.OurTeam.HeroCtrls
local e=#t
LuaUtils.SetImageSizeDelta(bg_head_ditu,e*120+60,112)
local o=#a
local o=(e-1)*60
for e=1,e do
local t=t[e].HeroHeadItem
if t==nil then
LoadHeroItem(o,e)
end
end
for t=1,#a do
local e=a[t]
if e.heroItemTrans then
e.heroItemTrans.anchoredPosition=Vector2(o-((t-1)*120),0)
e:ShowHeroInfo()
end
end
end
function OnBattleHeroSupplement(e)
RefreshBuffView()
if(e==nil)then
return
end
if e.CurrBattleTeam==nil then
return
end
if e.CurrBattleTeam.TeamId~=1 then
return
end
local t=a[e.battleStationIndex+1]
if(t==nil)then
EventSystem.SendEvent(CommonEventId.OnEventReloadHeroItem)
return
end
e.HeroHeadItem=t
t:ChangeHero(e)
t:OnOpen()
end
function UnLoadHeroList()
local e=#a
for e=1,e do
a[e]:Dispose()
end
a={}
end
function SetIdleModel(t)
LuaUtils.SetActive(HeroListContainer,not t)
if(GameInit.IsClient)and
ModulesInit.ExpeditionManager:MapIsThrough(11010)==false then
LuaUtils.SetActive(btnPause.transform,false)
else
LuaUtils.SetActive(btnPause.transform,not t)
end
if(GameInit.IsClient)and
ModulesInit.ExpeditionManager:MapIsThrough(11002)==false then
LuaUtils.SetActive(btnHelp.transform,false)
else
LuaUtils.SetActive(btnHelp.transform,(not t and ModulesInit.ProcedureNormalBattle.BattleType~=e.elite and ModulesInit.ProcedureNormalBattle.BattleType~=e.carnival and ModulesInit.ProcedureNormalBattle.BattleType~=e.GoldHoliday))
end
ShowBtnAuto(not t)
LuaUtils.SetActive(btnTwoSpeed.transform,not t)
LuaUtils.SetActive(TopCenter,not t)
if GameTools:IsReview()then
LuaUtils.SetActive(btnHelp.transform,false)
end
end
function SetHeroHeadListEnable(e)
LuaUtils.SetActive(HeroListContainer,e)
end
function OnShowOrHideExplosiveUI(e)
LuaUtils.SetActive(btn_Explosive_All.transform,e)
LuaUtils.SetActive(btn_Explosive_Cancel.transform,e)
end
function ApplyKillDragon()
local e=0
return e
end
function OnLoadNormalBattleMonster(t)
local t=false
if o then
t=true
end
if t then
LuaUtils.SetActive(HeroListContainer,false)
if ModulesInit.ProcedureNormalBattle.BattleType==e.dragonWar then
LuaUtils.SetActive(TopCenter,false)
LuaUtils.SetActive(longzhan,true)
local t=ApplyKillDragon()
local o,a,e=LuaUtils.GetLocalPos(longzhan,x,y,z)
LuaUtils.SetLocalPos(longzhan,t,a,e)
else
LuaUtils.SetActive(TopCenter,true)
LuaUtils.SetActive(longzhan,false)
end
else
if v and v.isIdleModel then
SetIdleModel(true)
m=true
else
m=false
SetIdleModel(false)
if ModulesInit.ProcedureNormalBattle.IsOpenShowHeadContainer==false then
LuaUtils.SetActive(HeroListContainer,false)
end
end
end
if ModulesInit.ProcedureNormalBattle.CurrMapsWaves~=nil then
LuaUtils.SetActive(bg_wave.transform,true)
text_waveNum.text=string.format("%s/%s",ModulesInit.ProcedureNormalBattle.CurrMapsWavesIndex,#ModulesInit.ProcedureNormalBattle.CurrMapsWaves)
end
NormalBattle_LoadTeamInfo()
end
function OnKillDragonCountDown()
GameTools:SetImageSprite(btnSkip.transform:GetComponent(typeof(CS.YouYou.YouYouImage)),'UIBattle/btn_Skip')
LuaUtils.SetChildActive(btnSkip.transform,'text',false)
if ModulesInit.ProcedureNormalBattle.BattleType==e.dragonWar then
GameTools:SetImageSprite(btnSkip.transform:GetComponent(typeof(CS.YouYou.YouYouImage)),'UIBattle/btn_Skip_2')
local e=btnSkip.transform:Find('text')
LuaUtils.SetActive(e,true)
if d then
d:Stop()
d=nil
end
d=ModulesInit.TimeActionMgr:CreateTimeAction()
d:Init(0,1,b,nil,function(t)
if t<=15 then
LuaUtils.SetLabelTextWrap(e,t)
end
b=t
end,
function()
GameTools:SetImageSprite(btnSkip.transform:GetComponent(typeof(CS.YouYou.YouYouImage)),'UIBattle/btn_Skip')
LuaUtils.SetActive(e,false)
end):Run()
end
end
function CheckShowBtnState()
if n~=nil then
ShowAllOperBtn(n)
end
end
function ShowAllOperBtn(t)
LuaUtils.SetActive(btnPause.transform,t)
LuaUtils.SetActive(btnSkip.transform,t)
ShowBtnAuto(t)
LuaUtils.SetActive(btnTwoSpeed.transform,t)
LuaUtils.SetActive(btnFastSkill.transform,t)
LuaUtils.SetActive(btnHelp.transform,t and ModulesInit.ProcedureNormalBattle.BattleType~=e.elite and ModulesInit.ProcedureNormalBattle.BattleType~=e.carnival and ModulesInit.ProcedureNormalBattle.BattleType~=e.GoldHoliday)
if GameTools:IsReview()then
LuaUtils.SetActive(btnHelp.transform,false)
end
end
function OnEventBossBuffTip(t)
if ModulesInit.ProcedureNormalBattle.BattleType~=e.dragonWar then
return
end
local function o(e)
for a=1,#r do
local e=r[a]
if e.buffId==t.buffId then
return a,e
end
end
end
local a,e=o(t.buffId)
if t.changeType=="addBuff"
or t.changeType=="onFloorsChange"
or t.changeType=="onRoundChange"
then
if e then
e.round=t.round
e.floors=t.floors
else
local e=N:GetBuffCfg(t.buffId)
if e and e.buffIcon~=nil and e.buffIcon~=""then
table.insert(r,t)
end
end
elseif t.changeType=="removeBuff"then
if a then
table.remove(r,a)
end
end
RefreshActScrollView(true)
end
function RefreshActScrollView(e)
UIUtil.RefreshScrollView(ScrollViewBuff,#r,e)
end
function OnGetItemByIndex(t,o)
o=o+1
local e=r[o]
local a=t:NewListViewItem("buff_icon")
local t=LuaUtils.GetLuaComBinder(a.transform)
local t=t:GetComponents()
local i=N:GetBuffCfg(e.buffId)
local i=i.buffIcon
GameTools:SetImageSprite(t["buff_icon"],string.format("UIBuffIcon/%s",i),false)
if(e.round>1 or e.floors>1)then
if(e.floors>1)then
LuaUtils.SetTextMeshText(t["text_round"],e.floors)
else
LuaUtils.SetTextMeshText(t["text_round"],e.round)
end
LuaUtils.SetActive(t["text_round"].transform,true)
else
LuaUtils.SetActive(t["text_round"].transform,false)
end
if a.IsInitHandlerCalled==false then
a.IsInitHandlerCalled=true
end
a.UserObjectData=o
return a
end
function OnBtnEliteArrow()
if ModulesInit.ProcedureNormalBattle.isAlreadyShowBattleEnd then
return
end
if i then
i:Kill()
i=nil
end
if c==false then
c=true
if s==true then
LuaUtils.DoTweenDLocalPosMoveY(cizhui_group.transform,E,0.5,function()
c=false
s=false
LuaUtils.SetLocalScale(btn_arrow.transform,t,t,t)
end)
else
LuaUtils.DoTweenDLocalPosMoveY(cizhui_group.transform,k,0.5,function()
c=false
s=true
LuaUtils.SetLocalScale(btn_arrow.transform,t,-t,t)
end)
end
end
end
function OnSendBattleFouces(e)
local e=e.isOpen or false
if e then
local e=im_oper_focus.transform:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
e.alpha=1;
LuaUtils.SetActive(im_oper_focus.transform,true)
if PlayerMgr.PlayerInfo and PlayerMgr:GetCampionMaxMap()==ModulesInit.ExpeditionManager:GetFirstMapId()then
LuaUtils.SetLocalScale(im_oper_focus.transform,1.5,1.5,0)
else
LuaUtils.SetLocalScale(im_oper_focus.transform,2.3,2.3,0)
end
local t=CS.DG.Tweening.DOTween.Sequence()
t:AppendInterval(1.5)
t:Append(e:DOFade(0,0.8))
t:AppendCallback(function()
e.alpha=1;
LuaUtils.SetActive(im_oper_focus.transform,false)
end)
else
LuaUtils.SetActive(im_oper_focus.transform,false)
end
end
function SetVisitAutoBubbleTips()
if not ModulesInit.PhotoArtistMgr:getDataById(10021)then
ModulesInit.PhotoArtistMgr:sendViewId(10021)
local t=auto_bubble_tips.transform:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
t.alpha=0
LuaUtils.SetActive(auto_bubble_tips.transform,true)
local e=CS.DG.Tweening.DOTween.Sequence()
e:Append(t:DOFade(1,0.8))
e:AppendInterval(3)
e:AppendCallback(function()
e:Append(t:DOFade(0,0.8))
end)
else
LuaUtils.SetActive(auto_bubble_tips.transform,false)
end
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end
function StopDelaySequenceShowPreviewSkip()
if q~=nil then
q:Kill()
q=nil
end
end
function CheckShowPreviewSkip()
LuaUtils.SetActive(btn_battle_preview_skip.transform,false)
if ModulesInit.ProcedureNormalBattle.BattleType==e.skillPreview then
if ModulesInit.BattlePreviewMgr.skipShowStartTime and ModulesInit.BattlePreviewMgr.skipShowStartTime>0 then
local e=ModulesInit.BattlePreviewMgr.skipShowStartTime+ModulesInit.BattlePreviewMgr.skipShowInterval-Time.realtimeSinceStartup
if e>0 then
local e=math.min(ModulesInit.BattlePreviewMgr.skipShowInterval,e)
ShowPreviewSkip(e)
end
end
end
end
function StartShowPreviewSkip()
if ModulesInit.ProcedureNormalBattle.BattleType==e.skillPreview then
ModulesInit.BattlePreviewMgr.skipShowStartTime=Time.realtimeSinceStartup
ShowPreviewSkip(ModulesInit.BattlePreviewMgr.skipShowInterval)
end
end
function ShowPreviewSkip(t)
LuaUtils.SetActive(btn_battle_preview_skip.transform,true)
StopDelaySequenceShowPreviewSkip()
local e=CS.DG.Tweening.DOTween.Sequence()
e:AppendInterval(t)
e:AppendCallback(function()
LuaUtils.SetActive(btn_battle_preview_skip.transform,false)
end)
q=e
end
function ShowBuffView(e)
f=e
LuaUtils.SetActive(root_buff.transform,f)
LuaUtils.SetChildActive(btnBuff.transform,'im_on',f)
LuaUtils.SetChildActive(btnBuff.transform,'im_off',f==false)
CheckRefreshBuffView()
end
function CheckRefreshBuffView()
if f then
RefreshBuffView()
end
end
function RefreshBuffView()
local o=ModulesInit.ProcedureNormalBattle:GetAllBuffIconShowMap()
local a=ModulesInit.ProcedureNormalBattle:GetMirrorScaleX()
for e=1,6 do
local t=o[e*a]
local e=selfEnv["item_buff_left_"..e]
if t then
LuaUtils.SetActive(e.transform,true)
RefreshHeroBuffTrans(e,t)
else
LuaUtils.SetActive(e.transform,false)
end
end
for e=1,6 do
local t=o[-e*a]
local e=selfEnv["item_buff_right_"..e]
if t then
LuaUtils.SetActive(e.transform,true)
RefreshHeroBuffTrans(e,t)
else
LuaUtils.SetActive(e.transform,false)
end
end
end
function RefreshHeroBuffTrans(e,a)
local e=LuaUtils.GetLuaComBinder(e.transform)
local t=e:GetComponents()
local e=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(a.heroId)
I.SetHeroHead(t["UI_BattleHeroItem"],e)
if(e.IsOurHero==false and e:GetHeroId()==ModulesInit.ProcedureNormalBattle.BossHeroId)then
I.RefreshBossBuffIcon(t["grid"],UI_Global_HeadBarItem_BuffIcon.transform,r)
end
local e=e:GetShowBuffIconList()
I.RefreshBuffIcon(t["grid"],UI_Global_HeadBarItem_BuffIcon.transform,e)
end
function ShowBtnAuto(e)
LuaUtils.SetActive(btnAuto.transform,e)
if e then
local e=btn_buff_pos.transform.position
LuaUtils.SetPos(btnBuff.transform,e.x,e.y,e.z)
else
local e=btnAuto.transform.position
LuaUtils.SetPos(btnBuff.transform,e.x,e.y,e.z)
end
end

