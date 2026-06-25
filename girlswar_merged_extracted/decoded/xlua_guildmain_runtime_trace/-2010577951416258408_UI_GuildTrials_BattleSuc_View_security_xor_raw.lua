local e=require("DataNode/DataTable/Create/maps/DTMapsDBModel")
local e=require("DataNode/DataTable/Create/constant/DTConstantDBModel")
local y=require("DataNode/DataTable/Create/model/DTmodelDBModel")
local w=require("DataNode/DataTable/Create/hero/DTHeroDBModel")
local e=Constant.calc_award_time
local f=require("Common/cs_coroutine")
local e=string.format
local p={
0.05,
0.10,
0.12,
0.12
}
local l=nil
local e=nil
local c
local i
local m
local d
local u=nil
local o=nil
local e
local n
local a=nil
local r=nil
local h=false
local s={}
function OnInit(e,t)
btn_statistical.onClick:AddListener(
function()
GameEntry.UI:OpenUIForm(UIFormId.UI_BattleStatistical,l)
end
)
bgBtn.onClick:AddListener(ClickBackBtnView)
c=spine_win1:GetComponent(typeof(CS.YouYou.UISpineCtr))
i=spine_win2:GetComponent(typeof(CS.YouYou.UISpineCtr))
m=spine_win3:GetComponent(typeof(CS.YouYou.UISpineCtr))
d=spine_win4:GetComponent(typeof(CS.YouYou.UISpineCtr))
a=e:Find('victory_spine_base/node_name')
end
function ClickBackBtnView()
if not h then
h=true
ModulesInit.GuildTrialsMgr:GoBack()
GameTools.CloseUIForm(UIFormId.UI_GuildTrials_BattleSuc_View)
end
end
function OnEnable(e)
if e==false then
local e=mvpSpineContainer.gameObject:GetComponent(typeof(CS.UnityEngine.Animator))
if e then
e.enabled=false
end
end
end
function OnOpen(t)
l=t
LuaUtils.SetActive(mvpSpineContainer,false)
LuaUtils.SetActive(bgBtn.transform,false)
LuaUtils.SetActive(a,false)
c:PlayAnimation(0,"A1",false,function()
c:PlayAnimation(0,"A2",true)
end)
m:PlayAnimation(0,"A1",false,function()
m:PlayAnimation(0,"A2",true)
end)
d:PlayAnimation(0,"A1",false,function()
d:PlayAnimation(0,"A2",true)
end)
local a=2
if GameEntry.UI:IsExists(UIFormId.UI_NormalBattleSkipView)then
i:PlayAnimation(0,"D",false)
else
LuaUtils.SetActive(i.transform,true)
i:PlayAnimation(0,"A1",false)
end
LuaUtils.SetActive(panel1,false)
if e then
e:Stop()
e=nil
end
e=ModulesInit.TimeActionMgr:CreateTimeAction()
e:Init(
0,
a,
1,
nil,
nil,
function()
EventSystem.SendEvent(CommonEventId.OnBattleEndUIShowComplete)
LoadMVP()
LuaUtils.SetActive(panel1,true)
LuaUtils.SetActive(panel2,false)
SetMapDropsStyle(grid1)
if t.killMonsterCount<t.totalMonsterCount then
LuaUtils.SetLabelText(text_progress,GameTools.GetLocalize("guildTrials_desc_39",LanguageCategory.LangCommon,UIUtil.GetRedTichText(t.killMonsterCount),UIUtil.GetRedTichText(t.score)))
else
LuaUtils.SetLabelText(text_progress,GameTools.GetLocalize("guildTrials_desc_40",LanguageCategory.LangCommon,UIUtil.GetRedTichText(t.score)))
end
LuaUtils.SetActive(bgBtn.transform,true)
end
)
e:Run()
StopPlayFanTweener()
n=UIUtil.PlayWinPageFanAudio()
GameTools:PlayAudioLua(345)
end
function SetWinHeroNameInfo(e)
local e=w.GetEntity(e)
local e=y.GetEntity(e.modelID)
LuaUtils.SetLocalPos(a,e.battleWinMvpname[1],e.battleWinMvpname[2],e.battleWinMvpname[3])
local t=a:Find('im_heroname'):GetComponent(typeof(CS.YouYou.YouYouImage))
LuaUtils.SetImageSprite(t,e.starHeroName)
LuaUtils.SetActive(a,true)
end
function LoadMVP()
local e=ModulesInit.ProcedureNormalBattle.GetMVPHeroDId()
if e~=nil and e>0 then
UIUtil.GetPlayerBigSpine(e,mvpSpineContainer,'battleWinMvp',function(t)
u=t
LuaUtils.SetActive(u.transform,true)
o=UIUtil.PlayHeroMvpVoice(e)
local e=mvpSpineContainer.gameObject:GetComponent(typeof(CS.UnityEngine.Animator))
e.enabled=true
LuaUtils.AnimtorPlay(e,"victory_win",0,0)
end)
SetWinHeroNameInfo(e)
end
LuaUtils.SetActive(mvpSpineContainer,true)
end
function DestroySpine(e)
if(not IsNil(e))then
UIUtil.SpinePoolDespawn(e)
end
e=nil
if o then
GameEntry.Audio:StopAudio(o)
o=nil
end
end
function SetMapDropsStyle(a)
local e=l.drops
LuaUtils.DestroyChildren(a)
LuaUtils.SetTransformRect(a,100*#e,100)
local e=f.start(
function()
coroutine.yield(CS.UnityEngine.WaitForSeconds(0.2))
local t=1
for i=1,#e do
local o=e[i]
local e=UIUtil.GetChild(a,i-1)
if not e then
e=LuaUtils.Instantiate(itemCell)
LuaUtils.SetParent(e,a)
end
LuaUtils.SetActive(e,true)
local a={
thingDid=o[1],
offset=45,
}
UIUtil.SetItemCell(e,{itemDid=o[1],count=o[2]},a)
local e=e:GetComponent(typeof(CS.DG.Tweening.DOTweenAnimation))
e:DOPlay()
if t>=5 then
t=1
end
coroutine.yield(CS.UnityEngine.WaitForSeconds(p[t]))
t=t+1
end
end
)
table.insert(s,e)
end
function OnClose()
h=false
if r then
r:Stop()
r=nil
end
EventSystem.SendEvent(CommonEventId.OnReStartGuide,{event="GUILDTRIALS_BATTLE_RESULT_CLOSE"})
LuaUtils.SetActive(panel1,false)
LuaUtils.SetActive(panel2,false)
GameEntry.Audio:StopAllAudio()
if e then
e:Stop()
e=nil
end
StopPlayFanTweener()
ModulesInit.ProcedureNormalBattle.Dispose()
DestroySpine(u)
for t,e in ipairs(s or{})do
f.stop(e)
end
s={}
end
function OnBeforeDestroy()
end
function StopPlayFanTweener()
if n~=nil then
n:Kill()
n=nil
end
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

