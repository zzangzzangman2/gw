local o=ModulesInit.GuildTerritoryMgr
local n=0
local t=0
local e=nil
function OnInit(e,e)
Image.onClick:AddListener(function()
GameTools.CloseUIForm(self.UIFormId)
end)
end
function OnOpen(a)
n=a.oldLevel
t=a.newLevel
e=a.closeCallback
Refresh()
GameTools:PlayAudioLua(11105)
end
function OnClose()
if e~=nil then
e()
end
end
function OnBeforeDestroy()
end
function Refresh()
local e=o:GetRadarLevelCfgByDid(t)
LuaUtils.SetTextMeshText(text_newLvTips,GameTools.GetLocalize("UI_GuildTerritoryLvUp_1",LanguageCategory.LangCommon)..e.normalEventsNum)
local a=0
for t=1,#e.normalEventsWeight do
a=math.max(a,e.normalEventsWeight[t][1])
end
local i=""
local e=o.radarMissionQualityMap[a]
if e then
i=" <color=#"..e.color..">"..GameTools.GetLocalize(e.strKey,LanguageCategory.LangCommon).."</color> "
end
LuaUtils.SetTextMeshText(text_MaxQuality,GameTools.GetLocalize("UI_GuildTerritoryLvUp_2",LanguageCategory.LangCommon)..i)
LuaUtils.SetTextMeshText(text_oldLv,GameTools.GetLocalize("UI_GuildTerritoryLvUp_3",LanguageCategory.LangCommon,n))
LuaUtils.SetTextMeshText(text_newLv,GameTools.GetLocalize("UI_GuildTerritoryLvUp_3",LanguageCategory.LangCommon,t))
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end 
