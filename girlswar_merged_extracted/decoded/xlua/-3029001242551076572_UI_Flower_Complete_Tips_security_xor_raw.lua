local m=require('DataNode/DataTable/Create/flower/DTFlowerJumpDBModel')
local e=nil
local t=nil
local i=0
local r=0
local a=nil
local u=false
local l=false
local h=false
local s={}
local c=false
local o={
Embattle=1,
Goto=2
}
local n=0
local d={
[PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_SIGN]={},
[PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_SIGN_OVER]={},
[PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_PRELIME_READY]={},
[PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_PRELIME_FIGHT]={tipType=o.Embattle,wheel=10,langKey="flowerFight_97",crossLangKey="flowerFight_107",btnType="embattle"},
[PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_PRELIME_OVER]={},
[PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_TOP64_READY]={tipType=o.Goto,langKey="flowerFight_98",crossLangKey="flowerFight_108",btnType="embattle"},
[PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_TOP64_FIGHT]={tipType=o.Embattle,wheel=3,langKey="flowerFight_99",crossLangKey="flowerFight_109",btnType="embattle"},
[PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_BREAK_OUT_READY]={tipType=o.Goto,langKey="flowerFight_98",crossLangKey="flowerFight_110",btnType="embattle"},
[PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_BREAK_OUT_FIGHT]={tipType=o.Embattle,wheel=3,langKey="flowerFight_99",crossLangKey="flowerFight_111",btnType="embattle"},
[PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_BREAK_OUT_OVER]={},
[PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_FINAL_READY]={tipType=o.Goto,langKey="flowerFight_100",crossLangKey="flowerFight_112",btnType="embattle"},
[PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_FINAL_FIGHT]={tipType=o.Embattle,wheel=3,langKey="flowerFight_101",crossLangKey="flowerFight_113",btnType="embattle"},
[PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_FINAL_OVER]={tipType=o.Goto,langKey="flowerFight_102",crossLangKey="flowerFight_102",btnType="look",specialPageType=ModulesInit.FlowerFightMgr.EPageType.Court},
[PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_FINAL_OVER_STOP]={},
}
function OnInit(o,o)
btn_jump.onClick:AddListener(function()
if a==nil or CheckShowTipWithPage()==false then
return
end
if GameEntry.Procedure.CurrProcedureState==CS.YouYou.ProcedureState.MainCity then
if ModulesInit.FlowerFightMgr.isInFlowerMyCourse~=true then
if GameEntry.UI:IsExists(UIFormId.UI_FlowerFightMainView)then
EventSystem.SendEvent(CommonEventId.OnRespFlowerSwitchPage,{pageType=ModulesInit.FlowerFightMgr.EPageType.MyCourse})
ViewMgr:clostEnableLayerView({UIFormId.UI_FlowerFightMainView})
EventSystem.SendEvent(CommonEventId.CloseChatView)
if t and e then
SetShowTipTimeByState(t.state,e.prelimeRedayTimestamp)
end
else
local a=ModulesInit.FlowerFightMgr:GetFlowerFightType(e.tipState)
local a={
isSign=true,
stage=e.stage,
fromFlowerEntrance=false,
state=e.tipState,
selfMaxType=a,
serverType=e.serverType,
serverCount=1,
pageIndex=ModulesInit.FlowerFightMgr.EPageType.MyCourse
}
local o={
stage=a.stage,
type=PROTO_ENUM.ENUM_FLOWER_FIGHT_TYPE.FLOWER_FIGHT_TYPE_NONE
}
ModulesInit.FlowerFightMgr:ReqFlowerMyRaceInfo(o,function(o)
ViewMgr:clostEnableLayerView({UIFormId.UI_CommonLoading})
EventSystem.SendEvent(CommonEventId.CloseChatView)
JumpMgr.OnGameJumpUIAdventure()
a.proto=o
GameEntry.UI:OpenUIForm(UIFormId.UI_FlowerFightMainView,a)
if t and e then
SetShowTipTimeByState(t.state,e.prelimeRedayTimestamp)
end
end)
end
end
elseif GameEntry.Procedure.CurrProcedureState==CS.YouYou.ProcedureState.NormalBattle then
end
end)
end
function OnOpen(o)
EventSystem.AddListener(SysEventId.OnUpdate,OnUpdate)
EventSystem.AddListener(CommonEventId.PlayerLevelUp,OnPlayerLevelUp)
EventSystem.AddListener(CommonEventId.OnEventCloseFlowerJump,OnEventCloseFlowerJump)
EventSystem.AddListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
EventSystem.AddListener(CommonEventId.OnOpenLuaView,onOpenLuaView)
EventSystem.AddListener(CommonEventId.OnCloseLuaView,onCloseLuaView)
EventSystem.AddListener(CommonEventId.OnRespFlowerQualification,OnRespFlowerQualification)
EventSystem.AddListener(CommonEventId.OnEventClearFlowerTipReqCount,OnEventClearFlowerTipReqCount)
e=nil
t=nil
i=0
r=0
a=nil
u=false
l=false
s={}
h=false
c=false
n=0
OnPlayerLevelUp()
end
function OnClose()
EventSystem.RemoveListener(SysEventId.OnUpdate,OnUpdate)
EventSystem.RemoveListener(CommonEventId.PlayerLevelUp,OnPlayerLevelUp)
EventSystem.RemoveListener(CommonEventId.OnEventCloseFlowerJump,OnEventCloseFlowerJump)
EventSystem.RemoveListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
EventSystem.RemoveListener(CommonEventId.OnOpenLuaView,ViewMgr.onOpenLuaView)
EventSystem.RemoveListener(CommonEventId.OnCloseLuaView,ViewMgr.onCloseLuaView)
EventSystem.RemoveListener(CommonEventId.OnRespFlowerQualification,OnRespFlowerQualification)
EventSystem.RemoveListener(CommonEventId.OnEventClearFlowerTipReqCount,OnEventClearFlowerTipReqCount)
end
function OnUpdate()
if h==true then
h=false
if a then
if CheckShowTipWithPage()==false then
ExitFlowerTips()
end
end
end
UpdateServerInfo()
UpdateTipInfo()
end
function UpdateServerInfo()
i=i-Time.deltaTime
if i>0 then
return
end
if l==false then
return
end
if e and e.normal==false then
if e.abnormalEndTimestamp>0 and e.abnormalEndTimestamp-TimeUtil.GetServerTimeStamp()<0 then
ReqFlowerQualificationInfoWithTime()
else
i=1
end
return
end
if e==nil
or t==nil
or c==true
or(t.stateOverTime-TimeUtil.GetServerTimeStamp()<0)then
ReqFlowerQualificationInfoWithTime()
else
i=1
end
if u==false and PlayerMgr.loginComplete and PlayerMgr.loginLoadComplete then
u=true
CheckFlowerMyRaceInfo()
end
end
function UpdateTipInfo()
if a==nil then
return
end
r=r-Time.deltaTime
if r>0 then
return
end
r=1
local t=""
local e=a.endTime-TimeUtil.GetServerTimeStamp()
local o=math.max(e,0)
local a=a.tipStateData
local a=GetTipTextStr(a)
if a then
t=GameTools.GetLocalize(a,LanguageCategory.LangCommon,o)
end
LuaUtils.SetChildLabelText(offset,"text",t)
if e<=0 then
ExitFlowerTips()
end
end
function GetTipTextStr(t)
if e.serverType==PROTO_ENUM.ENUM_FLOWER_SERVER_TYPE.SERVER_TYPE_CROSS then
return t.crossLangKey
else
return t.langKey
end
end
function ShowFlowerTips(e)
if not e then
return
end
a=e
local e=offset:GetComponent(typeof(CS.DG.Tweening.DOTweenAnimation))
e:DOPlayForward()
local t=""
local e=a.endTime-TimeUtil.GetServerTimeStamp()
local o=math.max(e,0)
local e=a.tipStateData
local a=GetTipTextStr(e)
if a then
t=GameTools.GetLocalize(a,LanguageCategory.LangCommon,o)
end
LuaUtils.SetChildLabelText(offset,"text",t)
if e.btnType=="embattle"then
LuaUtils.SetTextMeshText(txt_btn_go,GameTools.GetLocalize("flowerFight_103",LanguageCategory.LangCommon))
else
LuaUtils.SetTextMeshText(txt_btn_go,GameTools.GetLocalize("flowerFight_104",LanguageCategory.LangCommon))
end
end
function ExitFlowerTips()
local e=offset:GetComponent(typeof(CS.DG.Tweening.DOTweenAnimation))
e:DOPlayBackwards()
a=nil
end
function ReqFlowerQualificationInfoWithTime()
if n>3 then
return
end
n=n+1
ReqFlowerQualificationInfo()
i=3
c=false
end
function ReqFlowerQualificationInfo()
if ModulesInit.FlowerFightMgr:IsOpen()then
NetManager.Send(ProtoId.PRT_FLOWER_QUALIFICAION_TIPS_REQ)
else
GameTools.CloseUIForm(UIFormId.UI_Flower_Complete_Tips)
end
end
function OnRespFlowerQualification(e)
n=0
SynFlowerMyRaceInfo(e)
end
function OnEventClearFlowerTipReqCount(e)
n=0
end
function SynFlowerMyRaceInfo(t)
e=t
CheckFlowerMyRaceInfo()
end
function CheckFlowerMyRaceInfo()
if e==nil or e.normal==false then
return
end
local a=CalculateStateInfoByState(e.tipState,e.wheel,e.serverType,e.prelimeRedayTimestamp,e.stateOver)
if a==nil then
return
end
if t==nil
or(a~=nil and t~=nil and(a.state~=t.state or a.wheel~=t.wheel))then
t=a
end
if t then
;
end
if t
and e.hasQualification
and GameEntry.Procedure.CurrProcedureState==CS.YouYou.ProcedureState.MainCity
then
local a=t.tipInfo
local o=t.tipStateData.specialPageType
if a and a.isDone==false
and GetShowTipTimeByState(t.state)~=e.prelimeRedayTimestamp
and a.startTime<=TimeUtil.GetServerTimeStamp()and a.endTime>TimeUtil.GetServerTimeStamp()
and CheckShowTipWithPage()
and ModulesInit.GuideMgr.isGuide==false
and PlayerMgr.loginComplete
and PlayerMgr.loginLoadComplete
and ModulesInit.AutoPopViewMgr:IsWorking()==false
and ModulesInit.FlowerFightMgr.FlowerPageType~=ModulesInit.FlowerFightMgr.EPageType.MyCourse
and(o==nil or ModulesInit.FlowerFightMgr.FlowerPageType~=o)
then
a.isDone=true
local e={
startTime=a.startTime,
endTime=a.endTime,
tipStateData=t.tipStateData
}
ShowFlowerTips(e)
else
;
end
end
end
function GetShowTipTimeByState(e)
if s[e]==nil then
local t=SaveMgr.GetIntegerForKey("flower_complete_tip_"..tostring(e),0)
s[e]=t
end
return s[e]
end
function SetShowTipTimeByState(t,e)
s[t]=e
SaveMgr.SetIntegerForKey("flower_complete_tip_"..tostring(t),e)
end
function CheckShowTipWithPage()
for e=1,#ViewMgr.openUIList do
local t=ViewMgr.openUIList[e]
local e=m.GetEntity(t)
if e==nil or e.showJumpPage<=0 then
;
return false
end
end
return true
end
function CalculateStateInfoByState(t,e,a,n,l)
local e=d[t]
if e==nil then
return
end
local a=a==PROTO_ENUM.ENUM_FLOWER_SERVER_TYPE.SERVER_TYPE_CROSS
local i=ModulesInit.FlowerFightMgr:FindNextState(a,t)
local s=d[i]
if e==nil then
return
end
local s=ModulesInit.FlowerFightMgr:GetFlowerDurationByTowState(a,PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_PRELIME_READY,t)
local d=n+s
local a=ModulesInit.FlowerFightMgr:GetFlowerDurationByTowState(a,PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_PRELIME_READY,i)
local r=n+a
local s=nil
local n=nil
local i=r
local h=0
if e.tipType~=nil and l==false then
if e.tipType==o.Embattle then
local a=d
local t=ModulesInit.FlowerFightMgr:GetFlowerFightType(t)
for s=1,e.wheel do
local t=ModulesInit.FlowerFightMgr:GetFlowerFightTimeById(t,s)
if t then
local i=a
local o=a+t.setoutTime
a=a+t.setoutTime+t.countDown
if i<=TimeUtil.GetServerTimeStamp()and o>TimeUtil.GetServerTimeStamp()then
n={
startTime=i,
endTime=o,
isDone=false,
tipType=e.tipType
}
h=s
break
end
end
end
i=a
if i==d then
i=r
end
elseif e.tipType==o.Goto then
n={
startTime=TimeUtil.GetServerTimeStamp(),
endTime=TimeUtil.GetServerTimeStamp()+10,
isDone=false,
tipType=e.tipType
}
end
end
s={
tipStateData=e,
tipInfo=n,
stateOverTime=i,
state=t,
wheel=h
}
return s
end
function OnPlayerLevelUp()
if l==true then
return
end
local e,t,t=GameFunction.IsFunctionUnLock(GameFunctionType.Flower)
if e then
l=true
ReqFlowerQualificationInfoWithTime()
end
end
function OnEventCloseFlowerJump()
if a then
ExitFlowerTips()
end
end
function OnEventNetReconnectSuccess()
OnPlayerLevelUp()
end
function onOpenLuaView()
h=true
end
function onCloseLuaView()
h=true
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end
function CalculateStateWithTimeStamp(o,e)
local i=nil
local t=e==PROTO_ENUM.ENUM_FLOWER_SERVER_TYPE.SERVER_TYPE_CROSS
local e={}
if t then
e=ModulesInit.FlowerFightMgr.EFightCrossStateArr
else
e=ModulesInit.FlowerFightMgr.EFightLocalStateArr
end
for n=1,#e-1 do
local a=e[n]
local s=d[a]
local s=ModulesInit.FlowerFightMgr:GetFlowerDurationByTowState(t,PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_PRELIME_READY,a)
local s=o+s
local e=e[n+1]
local n=d[e]
local e=ModulesInit.FlowerFightMgr:GetFlowerDurationByTowState(t,PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_PRELIME_READY,e)
local e=o+e
if s<=TimeUtil.GetServerTimeStamp()and e>TimeUtil.GetServerTimeStamp()then
i=a
break
end
end
return i
end
function TestReqFlowerQualificationInfo()
local i=0
local n=PROTO_ENUM.ENUM_FLOWER_SERVER_TYPE.SERVER_TYPE_LOCAL
local t=PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_SIGN
local a=0
if e==nil then
i=TimeUtil.GetServerTimeStamp()-(4*60-2)
t=CalculateStateWithTimeStamp(i,n)
else
i=e.prelimeRedayTimestamp
local o=e.serverType
if e.tipState==PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_PRELIME_FIGHT then
if e.wheel<10 then
a=e.wheel+1
else
t=ModulesInit.FlowerFightMgr:FindNextState(o,t)
end
elseif e.tipState==PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_TOP64_FIGHT then
if e.wheel<3 then
a=e.wheel+1
else
t=ModulesInit.FlowerFightMgr:FindNextState(o,t)
end
elseif e.tipState==PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_BREAK_OUT_FIGHT then
if e.wheel<3 then
a=e.wheel+1
else
t=ModulesInit.FlowerFightMgr:FindNextState(o,t)
end
elseif e.tipState==PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_FINAL_FIGHT then
if e.wheel<3 then
a=e.wheel+1
else
t=ModulesInit.FlowerFightMgr:FindNextState(o,t)
end
else
t=ModulesInit.FlowerFightMgr:FindNextState(o,t)
end
if e.tipState==PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_PRELIME_FIGHT
or e.tipState==PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_TOP64_FIGHT
or e.tipState==PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_BREAK_OUT_FIGHT
or e.tipState==PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_FINAL_FIGHT then
a=math.max(1,a)
end
end
local e={
prelimeRedayTimestamp=i,
tipState=t,
wheel=a,
serverType=n,
hasQualification=true,
stage=1,
normal=true,
abnormalEndTimestamp=TimeUtil.GetServerTimeStamp()+30,
stateOver=false,
}
return e
end 
