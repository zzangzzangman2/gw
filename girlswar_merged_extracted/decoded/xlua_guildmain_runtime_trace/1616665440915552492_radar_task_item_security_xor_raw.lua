local t=ModulesInit.GuildTerritoryMgr
local o=nil
local a=nil
local n=nil
local e=nil
local i=false
function OnInit(o)
btn_select.onClick:AddListener(function()
if e.status==PROTO_ENUM.PRT_TASK_STATUS.FINISH then
t:OnReqGuildRadarGetTaskReward(e.taskId)
else
a:OnClickTransformBtn(e.taskId)
end
end)
end
function OnOpen(e)
e=e or{}
o=e.playerPosTrans
a=e.parentScriptEnv
end
function OnClose()
o=nil
a=nil
n=nil
end
function OnRefresh(a)
i=a.isSelect
local a=a.taskId
e=t:GetRadarEventInfoByRadarEventId(a)
local o=t:GetRadarMissionCfgByDid(e.taskDid)
LuaUtils.SetImageSprite(img_icon_bg,string.format("UIGuildTerritory/tmld_renwupinzhi0%s",o.quality))
if e.status==PROTO_ENUM.PRT_TASK_STATUS.FINISH then
LuaUtils.SetImageSprite(img_icon,"UIGuildTerritory/tmld_renwu07")
else
LuaUtils.SetImageSprite(img_icon,o.icon)
end
LuaUtils.SetActive(un_GuildTerritory_glow1,e.status==PROTO_ENUM.PRT_TASK_STATUS.FINISH)
LuaUtils.SetActive(red_pos,e.status==PROTO_ENUM.PRT_TASK_STATUS.FINISH)
LuaUtils.SetActive(un_GuildTerritory_click.transform,i)
local t=t:GetAirshipInfoByRadarEventId(a)~=nil
LuaUtils.SetActive(un_GuildTerritory_glow.transform,t and e.status~=PROTO_ENUM.PRT_TASK_STATUS.FINISH)
CheckAddGuideNode()
end
function PlayItemEffect(t)
local e=img_icon_bg.transform:GetComponent(typeof(CS.UnityEngine.Animator))
if t==1 then
GameTools:PlayAudioLua(322)
LuaUtils.AnimtorPlay(e,"un_GuildTerritory_actchuxian",0,0)
elseif t==2 then
LuaUtils.AnimtorPlay(e,"un_GuildTerritory_actshuaxin",0,0)
elseif t==3 then
GameTools:PlayAudioLua(322)
LuaUtils.AnimtorPlay(e,"un_GuildTerritory_actxiaoshi",0,0)
end
end
function CheckAddGuideNode()
if ModulesInit.GuideMgr.isGuide then
if t.isGuideSelectTask==false then
local a=ModulesInit.GuideMgr.unit==ModulesInit.GuideMgr.EGuideCfg.Radar_RewardBack_Guide
if t:CheckIsGuideTask(e,a)then
t.isGuideSelectTask=true
CS.YouYou.GuideMgr.AddCom(UIFormId.UI_GuildTerritory_Radar,"guide_btn_select",GetGuideRoot())
CS.YouYou.GuideMgr.AddCom(UIFormId.UI_GuildTerritory_Radar,"guide_btn_select_touch",GetGuideButton())
end
end
end
end
function GetGuideRoot()
return root.transform
end
function GetGuideButton()
return btn_select
end 
