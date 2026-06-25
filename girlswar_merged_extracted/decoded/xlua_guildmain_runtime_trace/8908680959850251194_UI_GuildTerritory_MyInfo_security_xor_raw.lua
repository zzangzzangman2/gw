function OnInit(e,e)
Image.onClick:AddListener(function()
GameTools.CloseUIForm(self.UIFormId)
end)
btn_city.onClick:AddListener(function()
PlayerCityMgr:EnterView()
GameTools.CloseUIForm(self.UIFormId)
end)
end
function OnOpen(e)
Refresh()
end
function OnClose()
end
function OnBeforeDestroy()
end
function Refresh()
local e=PlayerMgr.PlayerInfo
UIUtil.SetPlayerIconFrame(head_yuan150,{head=e.head,headFrame=e.headFrame})
LuaUtils.SetTextMeshText(text_lv,GameTools.GetLocalize("UI.guild.Main.03",LanguageCategory.LangCommon,e.level))
LuaUtils.SetLabelText(text_name,UIUtil.GetNameWithBackServerAndBlue(e.name,e.serverId,20))
local t
if e.guildId>0 then
t=GameTools.GetLocalize("UI.friends.info.10",LanguageCategory.LangCommon,e.guildName,e.guildId)
LuaUtils.SetLabelText(text_juntuanname,t)
else
t=GameTools.GetLocalize("UI.Tower.Ranking.03",LanguageCategory.LangCommon)
LuaUtils.SetLabelText(text_juntuanname,t)
end
local t=ModulesInit.FormationManager:GetFormationFightValue(PROTO_ENUM.FormationNO.FN_MAIN)
LuaUtils.SetTextMeshText(text_fight,UIUtil.NumTrim(t))
LuaUtils.SetLabelText(text_tile,GameTools.GetLocalize("UI.friends.info.11",LanguageCategory.LangCommon))
UIUtil.SetMarqueeWithDesc(mask_marquee,text_desc,100,PlayerMgr:getPlayerSign(e.sign))
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end 
