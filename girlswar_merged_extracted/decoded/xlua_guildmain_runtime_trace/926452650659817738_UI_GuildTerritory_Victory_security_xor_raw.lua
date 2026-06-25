local u=require("DataNode/DataTable/Create/model/DTmodelDBModel")
local c=require("DataNode/DataTable/Create/hero/DTHeroDBModel")
local e=string.format
local e={
0.05,
0.10,
0.12,
0.12
}
local e=nil
local d
local l
local r
local h
local s=nil
local i=nil
local t
local o
local a=nil
local n
local m={}
function OnInit(t,o)
bgBtn.onClick:AddListener(ClickBackBtnView)
btn_statistical.onClick:AddListener(function()
GameEntry.UI:OpenUIForm(UIFormId.UI_BattleStatistical,e)
end)
d=spine_win1:GetComponent(typeof(CS.YouYou.UISpineCtr))
l=spine_win2:GetComponent(typeof(CS.YouYou.UISpineCtr))
r=spine_win3:GetComponent(typeof(CS.YouYou.UISpineCtr))
h=spine_win4:GetComponent(typeof(CS.YouYou.UISpineCtr))
a=t:Find('victory_spine_base/node_name')
end
function ClickBackBtnView()
GameTools.CloseUIForm(self.UIFormId)
if not n then
ModulesInit.GuildTerritoryMgr:BattleBackGuildTerritoryView()
else
ModulesInit.GuildTerritoryMgr:GoBack()
end
end
function OnOpen(i)
e=i
LuaUtils.SetActive(a,false)
LuaUtils.SetActive(bgBtn.transform,false)
LuaUtils.SetActive(mvpSpineContainer,false)
n=e and e.notTrueBattle~=true
LuaUtils.SetActive(btn_statistical.transform,e and e.notTrueBattle~=true)
d:PlayAnimation(0,"A3",false,function()
d:PlayAnimation(0,"A2",true)
end)
r:PlayAnimation(0,"A3",false,function()
r:PlayAnimation(0,"A2",true)
end)
h:PlayAnimation(0,"A3",false,function()
h:PlayAnimation(0,"A2",true)
end)
l:PlayAnimation(0,"C1",false)
local e=0.2
if t then
t:Stop()
t=nil
end
t=ModulesInit.TimeActionMgr:CreateTimeAction()
t:Init(
0,
e,
1,
nil,
nil,
function()
EventSystem.SendEvent(CommonEventId.OnBattleEndUIShowComplete)
LoadMVP()
LuaUtils.SetActive(bgBtn.transform,true)
end
)
t:Run()
StopPlayFanTweener()
o=UIUtil.PlayWinPageFanAudio()
SetTextSettleStr()
GameTools:PlayAudioLua(345)
end
function SetTextSettleStr()
local t=e.taskId
if t==nil or t<=0 then
return""
end
local t=ModulesInit.GuildTerritoryMgr:GetRadarEventInfoByRadarEventId(t)
if t==nil then
return""
end
local t=ModulesInit.GuildTerritoryMgr:GetRadarMissionCfgByDid(t.taskDid)
if t==nil then
return""
end
local t=GameTools.GetLocalize(t.name,LanguageCategory.LangCommon)
LuaUtils.SetTextMeshText(text_settle_1,GameTools.GetLocalize("UI_GuildTerritory_13",LanguageCategory.LangCommon,t))
if e and e.notTrueBattle~=true then
LuaUtils.SetTextMeshText(text_settle_2,GameTools.GetLocalize("UI_GuildTerritory_14",LanguageCategory.LangCommon))
else
LuaUtils.SetTextMeshText(text_settle_2,GameTools.GetLocalize("UI_GuildTerritory_15",LanguageCategory.LangCommon))
end
CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(settle_root)
end
function SetWinHeroNameInfo(e)
local e=c.GetEntity(e)
local e=u.GetEntity(e.modelID)
LuaUtils.SetLocalPos(a,e.battleWinMvpname[1],e.battleWinMvpname[2],e.battleWinMvpname[3])
local t=a:Find('im_heroname'):GetComponent(typeof(CS.YouYou.YouYouImage))
LuaUtils.SetImageSprite(t,e.starHeroName)
LuaUtils.SetActive(a,true)
end
function LoadMVP()
local t=0
if not n then
t=e.mvpHeroDid
else
t=ModulesInit.ProcedureNormalBattle.GetMVPHeroDId()
end
if t~=nil and t>0 then
UIUtil.GetPlayerBigSpine(t,mvpSpineContainer,'battleWinMvp',function(e)
s=e
LuaUtils.SetActive(s.transform,true)
i=UIUtil.PlayHeroMvpVoice(t)
local e=mvpSpineContainer.gameObject:GetComponent(typeof(CS.UnityEngine.Animator))
e.enabled=true
LuaUtils.AnimtorPlay(e,"victory_win",0,0)
end)
end
SetWinHeroNameInfo(t)
LuaUtils.SetActive(mvpSpineContainer,true)
end
function DestroySpine(e)
if(not IsNil(e))then
UIUtil.SpinePoolDespawn(e)
end
e=nil
if i then
GameEntry.Audio:StopAudio(i)
i=nil
end
end
function OnClose()
GameEntry.Audio:StopAllAudio()
if t then
t:Stop()
t=nil
end
StopPlayFanTweener()
if e and e.notTrueBattle~=true then
ModulesInit.ProcedureNormalBattle.Dispose()
end
DestroySpine(s)
end
function OnBeforeDestroy()
end
function StopPlayFanTweener()
if o~=nil then
o:Kill()
o=nil
end
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

