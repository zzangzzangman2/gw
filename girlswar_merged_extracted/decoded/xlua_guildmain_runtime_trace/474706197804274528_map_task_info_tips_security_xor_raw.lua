local e=ModulesInit.GuildTerritoryMgr
local h=nil
local n=nil
local d=nil
local r=false
local o=0
local a=nil
local t=nil
local i=false
local s=nil
function OnInit(o)
btn_attack.onClick:AddListener(function()
local t=0
local o=e.airshipInfoMap
if o then
for a,e in pairs(o)do
if e then
t=t+1
end
end
end
local o=n and n.airNum or 0
if t>=o then
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI_GuildTerritory_18",LanguageCategory.LangCommon))
return
end
e:EnterTeamArrayView(a)
end)
btn_click_mask.onClick:AddListener(function()
SetTransActive(false)
end)
btn_wenhao.onClick:AddListener(function()
if t==nil then
return
end
local e={
worldPos=btn_wenhao.transform.position,
hintDes=GameTools.GetLocalize(t.tips,LanguageCategory.LangCommon),
offset=20,
priorPageArr={EHintPageDir.Down},
priorArrowArr={EHintArrowAlign.Horizontal_Center},
textSizeType=EHintSizeType.Standard
}
UIUtil.ShowHint(e)
end)
s=right_root.transform:GetComponent(typeof(CS.UnityEngine.Animator))
end
function OnOpen(t)
SetTransActive(false)
h=t.parentScriptEnv
n=e:GetRadarBaseCfg()
end
function OnClose()
SetTransActive(false)
o=0
a=nil
t=nil
n=nil
h=nil
d=nil
EventSystem.SendEvent(CommonEventId.OnEventClosePubTipView)
end
function OnRefresh()
if r then
SetTaskId(o)
end
end
function SetTaskId(i)
if i<=0 then
return
end
o=i
if GetTaskInfoAndCheckShow()==false then
return
end
t=e:GetRadarMissionCfgByDid(a.taskDid)
if t==nil then
return
end
LuaUtils.SetActive(img_bg.transform,t.quality<6)
LuaUtils.SetActive(img_bg_2.transform,t.quality>=6)
LuaUtils.SetImageSprite(img_icon,t.buildImg,true)
LuaUtils.SetTextMeshText(text_name,GameTools.GetLocalize(t.name,LanguageCategory.LangCommon))
local a=a.descIndex or 1
local a=t.lang[a]
LuaUtils.SetTextMeshText(text_desc,GameTools.GetLocalize(a,LanguageCategory.LangCommon))
local a="UI_GuildTerritory_04"
if t.taskEnumerate==e.ERadarEventType.Collect then
a="UI_GuildTerritory_03"
end
LuaUtils.SetTextMeshText(text_attack,GameTools.GetLocalize(a,LanguageCategory.LangCommon))
LuaUtils.SetActive(recommend_node.transform,t.taskEnumerate==e.ERadarEventType.Rescue)
if t.taskEnumerate==e.ERadarEventType.Rescue then
local e=e:GetRadarMonsterCfgByDid(t.id)
LuaUtils.SetTextMeshText(text_recommend,tostring(e.power))
end
local e=t.taskEnumerate==e.ERadarEventType.Assess or t.taskEnumerate==e.ERadarEventType.Army
LuaUtils.SetActive(text_advantage.transform,e==true)
if e==true then
LuaUtils.SetTextMeshText(text_advantage,GameTools.GetLocalize("UI_GuildTerritory_17",LanguageCategory.LangCommon,t.difficultyLevel))
end
RefreshShow()
SetTransActive(true)
CheckAddGuideNode()
end
function PlayOpenAnim()
if s~=nil then
LuaUtils.AnimtorPlay(s,"un_GuildTerritory_act04",0,0)
end
end
function GetTaskInfoAndCheckShow()
i=true
a=e:GetRadarEventInfoByRadarEventId(o)
if a==nil then
a=e:GetOtherRadarEventInfoByRadarEventId(o)
i=false
end
if a==nil or a.status==1 then
return false
end
local t=e:GetAirshipInfoByRadarEventId(o)
if t~=nil then
if e:GetLocalServerTime()>=t.battleOverTime then
if t.result==nil or t.result.win==true then
return false
end
end
end
return true
end
function RefreshShow()
LuaUtils.SetActive(self_task_node.transform,i==true)
LuaUtils.SetActive(other_player_task_node.transform,i==false)
if i==false then
LuaUtils.SetTextMeshText(text_other_player_name,a.name)
return
end
if GetTaskInfoAndCheckShow()==false then
SetTransActive(false)
return
end
local a=e:GetAirshipInfoByRadarEventId(o)
LuaUtils.SetActive(btn_attack.transform,a==nil)
LuaUtils.SetActive(left_time_node.transform,a~=nil)
if a==nil then
return
end
local i=0
local n=""
local o=e.EAirshipState.None
local s=e:GetLocalServerTime()
if s<a.flyAwayOverTime then
o=e.EAirshipState.GoTo
i=a.flyAwayOverTime-s
n=GameTools.GetLocalize("UI_GuildTerritory_07",LanguageCategory.LangCommon)
elseif s<a.battleOverTime then
o=e.EAirshipState.Battle
if t.taskEnumerate==e.ERadarEventType.Collect then
n=GameTools.GetLocalize("UI_GuildTerritory_09",LanguageCategory.LangCommon)
else
n=GameTools.GetLocalize("UI_GuildTerritory_08",LanguageCategory.LangCommon)
end
else
o=e.EAirshipState.Return
i=a.flyOffOverTime-s
n=GameTools.GetLocalize("UI_GuildTerritory_07",LanguageCategory.LangCommon)
end
if i<=0 then
i=0
end
if o==e.EAirshipState.Return then
if a.result==nil or a.result.win==true then
SetTransActive(false)
return
end
end
LuaUtils.SetTextMeshText(text_left_time_title,GameTools.GetLocalize(n,LanguageCategory.LangCommon))
LuaUtils.SetActive(text_left_time.transform,o~=e.EAirshipState.Battle)
LuaUtils.SetActive(img_left_time_bg.transform,o~=e.EAirshipState.Battle)
if o~=e.EAirshipState.Battle then
LuaUtils.SetTextMeshText(text_left_time,GameTools.GetLocalize("UI.Equip.Common.14",LanguageCategory.LangCommon,i))
end
end
function OnUpdateSec()
if r==false then
return
end
RefreshShow()
end
function SetTransActive(e)
r=e
LuaUtils.SetActive(transform,e)
if not e then
EventSystem.SendEvent(CommonEventId.OnEventClosePubTipView)
end
if h then
h.SetEventSelectNodeShow(e,o)
end
end
function CheckTaskTipsShow()
if GetTaskInfoAndCheckShow()==false then
SetTransActive(false)
return
end
end
function CheckAddGuideNode()
if ModulesInit.GuideMgr.isGuide then
if ModulesInit.GuideMgr.unit==ModulesInit.GuideMgr.EGuideCfg.Radar_Enter_Guide then
CS.YouYou.GuideMgr.AddCom(UIFormId.UI_GuildTerritory_Main,"guide_btn_attack",GetGuideRoot())
CS.YouYou.GuideMgr.AddCom(UIFormId.UI_GuildTerritory_Main,"guide_btn_attack_touch",GetGuideButton())
end
end
end
function GetGuideRoot()
return btn_attack.transform
end
function GetGuideButton()
return btn_attack
end

