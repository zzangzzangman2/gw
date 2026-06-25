local r=require('DataNode/DataTable/Create/function/DTLoseJumpDBModel')
local e=nil
local h
local s
local i
local a=nil
local o=nil
local t={}
local n={}
local d={
["doXinZhiZhen"]=function()
return GameFunction.IsFunctionUnLock(GameFunctionType.HeroStar,true)
end,
["doHunZhiSuo"]=function()
return GameFunction.IsFunctionUnLock(GameFunctionType.HeroLock,true)
end,
["doEquipOper"]=function()
return GameFunction.IsFunctionUnLock(GameFunctionType.Equip,true)
end,
["doUpgradeStar"]=function()
return GameFunction.IsFunctionUnLock(GameFunctionType.HeroAwake,true)
end,
["doEquipGemOper"]=function()
local e,t,t=HeroMgr:getFristHeroHasEquip()
if e==nil then
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI.Equip.Hero.07",LanguageCategory.LangCommon))
return false
else
return true
end
end,
["doActSuitGacha"]=function()
if ActMgr:IsOpen(407)then
return true
else
UIUtil.ShowCommonTips(GameTools.GetLocalize("errCode22",LanguageCategory.LangCommon))
return false
end
end,
["doActLuckyFood"]=function()
if ActMgr:IsOpen(409)then
return true
else
UIUtil.ShowCommonTips(GameTools.GetLocalize("errCode22",LanguageCategory.LangCommon))
return false
end
end,
}
function OnInit(o,a)
e=a
btn_statistical.onClick:AddListener(
function()
if e.battleType then
if e.battleType==BattleType.arena or e.battleType==BattleType.spaceArena then
GameEntry.UI:OpenUIForm(UIFormId.UI_ArenaStatistical,e)
return
end
end
GameEntry.UI:OpenUIForm(UIFormId.UI_BattleStatistical,e)
end
)
bgBtn.onClick:AddListener(
function()
ExitBattle()
end
)
btn_huifang.onClick:AddListener(
function()
GameEntry.UI:OpenUIForm(UIFormId.UI_BattleRecord,{mapId=e.mapId,battleType=e.battleType})
end
)
h=spine_lose1:GetComponent(typeof(CS.YouYou.UISpineCtr))
s=spine_lose2:GetComponent(typeof(CS.YouYou.UISpineCtr))
i=spine_lose3:GetComponent(typeof(CS.YouYou.UISpineCtr))
local e=LuaUtils.GetChildrenCount(layout.transform)
for e=1,e do
local o=e
n[e]={}
local a=UIUtil.GetChild(layout.transform,e-1)
n[e].icon=a.transform:GetComponent(typeof(CS.YouYou.YouYouImage))
n[e].text_name=a.transform:Find("text_name"):GetComponent(typeof(CS.TMPro.TextMeshProUGUI))
local e=a.transform:GetComponent(typeof(CS.UnityEngine.UI.Button))
self:AddBtnClickListener(e,function()
doFuncJump(t[o])
end)
end
if GameEntry.IsReview then
LuaUtils.SetActive(i.transform,false)
end
end
function OnOpen(t)
e=t
o=nil
LuaUtils.SetActive(bgBtn.transform,false)
h:PlayAnimation(
0,
"A1",
false,
function()
h:PlayAnimation(0,"A2",true)
end
)
i:PlayAnimation(0,"in",false,function()
i:PlayAnimation(0,"idle",true)
end)
if GameEntry.UI:IsExists(UIFormId.UI_NormalBattleSkipView)then
s:PlayAnimation(0,"C1",false)
else
s:PlayAnimation(0,"A1",false)
end
GameEntry.Audio:StopBGM()
if a then
a:Stop()
a=nil
end
a=ModulesInit.TimeActionMgr:CreateTimeAction()
a:Init(
0,
1.5,
1,
nil,
nil,
function()
EventSystem.SendEvent(CommonEventId.OnBattleEndUIShowComplete)
LuaUtils.SetActive(bgBtn.transform,true)
end
):Run()
LuaUtils.SetActive(btn_huifang.transform,false)
ShowFuncIcon()
if ModulesInit.ProcedureNormalBattle.BattleType==BattleType.bigBoss then
LuaUtils.SetActive(node_score.transform,true)
LuaUtils.SetTextMeshText(txt_score,"+"..tostring(t.gainScore))
else
LuaUtils.SetActive(node_score.transform,false)
end
if ModulesInit.ProcedureNormalBattle.BattleType==BattleType.trial or
ModulesInit.ProcedureNormalBattle.BattleType==BattleType.campaign or
ModulesInit.ProcedureNormalBattle.BattleType==BattleType.elite or
ModulesInit.ProcedureNormalBattle.BattleType==BattleType.carnival or
ModulesInit.ProcedureNormalBattle.BattleType==BattleType.thiefCrusade or
ModulesInit.ProcedureNormalBattle.BattleType==BattleType.guildBossPersonal or
ModulesInit.ProcedureNormalBattle.BattleType==BattleType.maze then
LuaUtils.SetActive(btn_shibai.transform,true)
else
LuaUtils.SetActive(btn_shibai.transform,false)
end
end
function OnClose()
if a then
a:Stop()
a=nil
end
end
function OnBeforeDestroy()
end
function ShowFuncIcon()
t=nil
t={}
local o=PlayerMgr.PlayerInfo.level
local e=r.GetList()
for a,e in ipairs(e)do
if GameEntry.IsReview then
if a==1 or a==3 then
table.add(t,e)
end
else
if o>=e.showLever[1]and o<=e.showLever[2]then
table.add(t,e)
end
end
end
for a,e in ipairs(n)do
if t[a]then
LuaUtils.SetActive(e.icon.transform,true)
LuaUtils.SetImageSprite(e.icon,string.format("UIJumpIcon/%s",t[a].icon),true)
LuaUtils.SetTextMeshText(e.text_name,GameTools.GetLocalize(t[a].info,LanguageCategory.LangCommon))
else
LuaUtils.SetActive(e.icon.transform,false)
end
end
end
function doFuncJump(e)
o=e.uiKey
if d[o]()then
ModulesInit.ProcedureTransmitCenter:SetProcedureTrasnmit(ProcedureState.MainCity,'OpenUI',o)
BecomeStrongerExitBattle(e)
end
end
function BecomeStrongerExitBattle(t)
if e and e.battleType==BattleType.maze then
ModulesInit.MazeMgr:backToMaze(o)
end
if t.highermenu==DOCK_TYPE.CAMP then
ModulesInit.ExpeditionManager.isFormIdleAndOpenCamp=true
end
GameEntry.Procedure:ChangeState(CS.YouYou.ProcedureState.MainCity)
if GameEntry.UI:IsExists(UIFormId.UI_BattleFail)then
GameTools.CloseUIForm(UIFormId.UI_BattleFail)
end
end
function ExitBattle()
if GameEntry.UI:IsExists(UIFormId.UI_NormalBattleSkipView)then
GameTools.CloseUIForm(UIFormId.UI_NormalBattleSkipView)
end
if e and e.IsInLevelTestMode==true then
GameEntry.Procedure:ChangeState(CS.YouYou.ProcedureState.MainCity)
return
elseif e and e.battleType==BattleType.maze then
ModulesInit.MazeMgr:backToMaze()
end
if ModulesInit.ProcedureNormalBattle.BattleType==BattleType.trial then
GameEntry.Procedure:ChangeState(CS.YouYou.ProcedureState.Tower)
elseif ModulesInit.ProcedureNormalBattle.BattleType==BattleType.campaign then
GameEntry.UI:OpenUIForm(UIFormId.UI_CommonLoading,{style=LoadingStyle.Black,blackAnimType=ELoadingBlackAnimType.Short,loadResFinish=function()
ModulesInit.ExpeditionManager:BackBigMap()
end})
local e=ModulesInit.TimeActionMgr:CreateTimeAction()
e:Init(0.2,0,1,nil,nil,function()
if GameEntry.UI:IsExists(UIFormId.UI_BattleFail)then
GameTools.CloseUIForm(UIFormId.UI_BattleFail)
end
end):Run()
elseif ModulesInit.ProcedureNormalBattle.BattleType==BattleType.elite then
ModulesInit.EliteMgr:GoBack()
local e=ModulesInit.TimeActionMgr:CreateTimeAction()
e:Init(0.2,0,1,nil,nil,function()
if GameEntry.UI:IsExists(UIFormId.UI_BattleFail)then
GameTools.CloseUIForm(UIFormId.UI_BattleFail)
end
end):Run()
elseif ModulesInit.ProcedureNormalBattle.BattleType==BattleType.carnival then
ModulesInit.ActCarnivalManager:GoBack()
local e=ModulesInit.TimeActionMgr:CreateTimeAction()
e:Init(0.2,0,1,nil,nil,function()
if GameEntry.UI:IsExists(UIFormId.UI_BattleFail)then
GameTools.CloseUIForm(UIFormId.UI_BattleFail)
end
end):Run()
elseif ModulesInit.ProcedureNormalBattle.BattleType==BattleType.newCarnival then
ModulesInit.ActCarnivalNewManager:GoBack()
local e=ModulesInit.TimeActionMgr:CreateTimeAction()
e:Init(0.2,0,1,nil,nil,function()
if GameEntry.UI:IsExists(UIFormId.UI_BattleFail)then
GameTools.CloseUIForm(UIFormId.UI_BattleFail)
end
end):Run()
elseif ModulesInit.ProcedureNormalBattle.BattleType==BattleType.bigBoss then
ModulesInit.ActBigBossMgr:GoBack()
elseif ModulesInit.ProcedureNormalBattle.BattleType==BattleType.guildBossPersonal then
ModulesInit.ActGuildBossMgr:GoBack()
elseif ModulesInit.ProcedureNormalBattle.BattleType==BattleType.arena then
ModulesInit.ArenaManager.isForm=true
GameEntry.Procedure:ChangeState(CS.YouYou.ProcedureState.MainCity)
elseif ModulesInit.ProcedureNormalBattle.BattleType==BattleType.friendArena then
ModulesInit.FriendManage.isForm=true
GameEntry.Procedure:ChangeState(CS.YouYou.ProcedureState.MainCity)
elseif ModulesInit.ProcedureNormalBattle.BattleType==BattleType.spaceArena then
ModulesInit.CrossArenaManager.isForm=true
GameEntry.Procedure:ChangeState(CS.YouYou.ProcedureState.MainCity)
elseif ModulesInit.ProcedureNormalBattle.BattleType==BattleType.maze then
ModulesInit.MazeMgr:backToMaze()
elseif ModulesInit.ProcedureNormalBattle.BattleType==BattleType.thiefCrusade then
ModulesInit.CrusadeAgainstMgr.isOpenCrusadeAgainst=true
ModulesInit.ExpeditionManager.isForm=true
GameEntry.UI:OpenUIForm(UIFormId.UI_CommonLoading,{style=LoadingStyle.Cloud,loadResFinish=function()
GameEntry.Procedure:ChangeState(CS.YouYou.ProcedureState.MainCity)
end})
elseif ModulesInit.ProcedureNormalBattle.BattleType==BattleType.unionCraft then
ModulesInit.CSGuildWarManager:EnterWarProcedure()
elseif ModulesInit.ProcedureNormalBattle.BattleType==BattleType.dragonWar then
GameEntry.UI:OpenUIForm(UIFormId.UI_CommonLoading,{style=LoadingStyle.Cloud,loadResFinish=function()
if GameEntry.UI:IsExists(UIFormId.UI_BattleFail)then
GameTools.CloseUIForm(UIFormId.UI_BattleFail)
end
ModulesInit.KillDragonsManager.isForm=true
GameEntry.Procedure:ChangeState(CS.YouYou.ProcedureState.MainCity)
end})
else
GameEntry.Procedure:ChangeState(CS.YouYou.ProcedureState.MainCity)
end
if ModulesInit.ProcedureNormalBattle.BattleType~=BattleType.dragonWar and
ModulesInit.ProcedureNormalBattle.BattleType~=BattleType.campaign then
if GameEntry.UI:IsExists(UIFormId.UI_BattleFail)then
GameTools.CloseUIForm(UIFormId.UI_BattleFail)
end
end
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

