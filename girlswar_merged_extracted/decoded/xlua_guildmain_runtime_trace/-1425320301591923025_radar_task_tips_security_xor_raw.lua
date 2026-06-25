local t=ModulesInit.GuildTerritoryMgr
local e=nil
local e=nil
local e=nil
local a=nil
function OnInit(e)
btn_go.onClick:AddListener(function()
GameTools.CloseUIForm(UIFormId.UI_GuildTerritory_Radar)
EventSystem.SendEvent(CommonEventId.OnClickGuildRadarTaskInMap,{taskId=a.taskId})
end)
btn_tips.onClick:AddListener(function()
LuaUtils.SetActive(panel_tips.transform,true)
LuaUtils.RebuildLayout(panel_tips.transform)
LuaUtils.SetActive(btn_closetips.transform,true)
end)
btn_closetips.onClick:AddListener(function()
LuaUtils.SetActive(panel_tips.transform,false)
LuaUtils.SetActive(btn_closetips.transform,false)
end)
end
function OnOpen(e)
e=e or{}
LuaUtils.SetActive(panel_tips.transform,false)
LuaUtils.SetActive(btn_closetips.transform,false)
end
function OnClose()
end
function OnRefresh(o)
LuaUtils.SetActive(panel_tips.transform,false)
a=t:GetRadarEventInfoByRadarEventId(o)
local e=t:GetRadarMissionCfgByDid(a.taskDid)
LuaUtils.SetImageSprite(img_icon,e.buildImg)
LuaUtils.SetTextMeshText(text_task_name,t:GetRadarMissionNameAndQuality(e))
local a=a.descIndex or 1
local a=e.lang[a]
LuaUtils.SetTextMeshText(text_task_des,GameTools.GetLocalize(a,LanguageCategory.LangCommon))
LuaUtils.SetTextMeshText(text_tips,GameTools.GetLocalize(e.tips,LanguageCategory.LangCommon))
UIUtil.RefreshGridItemInfoSimple(Content,UI_CommonItemCell,e.award)
LuaUtils.SetActive(img_bg.transform,e.quality<6)
LuaUtils.SetActive(img_bg_2.transform,e.quality>=6)
local e=t:GetAirshipInfoByRadarEventId(o)~=nil
LuaUtils.SetActive(obj_doing.transform,e)
LuaUtils.SetActive(btn_go.transform,not e)
CheckAddGuideNode()
end
function CheckAddGuideNode()
if ModulesInit.GuideMgr.isGuide then
if ModulesInit.GuideMgr.unit==ModulesInit.GuideMgr.EGuideCfg.Radar_Enter_Guide then
CS.YouYou.GuideMgr.AddCom(UIFormId.UI_GuildTerritory_Radar,"guide_btn_go",GetGuideRoot())
CS.YouYou.GuideMgr.AddCom(UIFormId.UI_GuildTerritory_Radar,"guide_btn_go_touch",GetGuideButton())
end
end
end
function GetGuideRoot()
return btn_go.transform
end
function GetGuideButton()
return btn_go
end 
