function OnInit(e,e)
Image.onClick:AddListener(function()
GameTools.CloseUIForm(UIFormId.UI_GuildManageView)
end)
btn_set_icon.onClick:AddListener(
function()
if ModulesInit.GuildMgr:checkCanManageGuild(ModulesInit.GuildMgr.EGuildManageType.CHANGE_ICON)then
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildIconSetView)
else
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI.guild.Manage.68",LanguageCategory.LangCommon))
end
end
)
btn_set_apply.onClick:AddListener(
function()
if ModulesInit.GuildMgr:checkCanManageGuild(ModulesInit.GuildMgr.EGuildManageType.MANAGE_APPLY)then
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildApplyManageView)
else
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI.guild.Manage.68",LanguageCategory.LangCommon))
end
end
)
btn_guild_mail.onClick:AddListener(
function()
if ModulesInit.GuildMgr:checkCanManageGuild(ModulesInit.GuildMgr.EGuildManageType.EDIT_GUILD_MAIL)then
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildMailView)
else
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI.guild.Manage.68",LanguageCategory.LangCommon))
end
end
)
btn_set_cond.onClick:AddListener(
function()
if ModulesInit.GuildMgr:checkCanManageGuild(ModulesInit.GuildMgr.EGuildManageType.SET_JOIN_CONDITON)then
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildFightSetView)
else
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI.guild.Manage.68",LanguageCategory.LangCommon))
end
end
)
btn_set_notice.onClick:AddListener(
function()
if ModulesInit.GuildMgr:checkCanManageGuild(ModulesInit.GuildMgr.EGuildManageType.EDIT_GUILD_NOTICE)then
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildNoticeView)
else
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI.guild.Manage.68",LanguageCategory.LangCommon))
end
end
)
btn_set_recruit.onClick:AddListener(
function()
if ModulesInit.GuildMgr:checkCanManageGuild(ModulesInit.GuildMgr.EGuildManageType.EDIT_RECRUIT_NOTICE)then
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildRecruitNoticeView)
else
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI.guild.Manage.68",LanguageCategory.LangCommon))
end
end
)
end
function OnOpen(e)
EventSystem.AddListener(CommonEventId.GuildInfoChange,OnEventGuildInfoChange)
EventSystem.AddListener(CommonEventId.OnGuildLeave,OnGuildLeave)
EventSystem.AddListener(CommonEventId.OnGuildPosChange,OnGuildPosChange)
EventSystem.AddListener(CommonEventId.RedPointInfoChange,RefreshRedPoint)
Refresh()
end
function OnClose()
EventSystem.RemoveListener(CommonEventId.GuildInfoChange,OnEventGuildInfoChange)
EventSystem.RemoveListener(CommonEventId.OnGuildLeave,OnGuildLeave)
EventSystem.RemoveListener(CommonEventId.OnGuildPosChange,OnGuildPosChange)
EventSystem.RemoveListener(CommonEventId.RedPointInfoChange,RefreshRedPoint)
end
function OnBeforeDestroy()
end
function Refresh()
if ModulesInit.GuildMgr.guildInfo==nil then
return
end
GameTools:SetImageSprite(bg_huizhang.transform,ModulesInit.GuildMgr:getGuildIconBg(ModulesInit.GuildMgr.guildInfo.bg),false)
GameTools:SetImageSprite(im_huizhang.transform,ModulesInit.GuildMgr:getGuildFg(ModulesInit.GuildMgr.guildInfo.fg),false)
if ModulesInit.GuildMgr:checkCanManageGuild(ModulesInit.GuildMgr.EGuildManageType.CHANGE_ICON)then
UIUtil.SetGray(bg_set_icon.transform,false)
else
UIUtil.SetGray(bg_set_icon.transform,true)
end
if ModulesInit.GuildMgr:checkCanManageGuild(ModulesInit.GuildMgr.EGuildManageType.MANAGE_APPLY)then
UIUtil.SetGray(bg_set_apply.transform,false)
else
UIUtil.SetGray(bg_set_apply.transform,true)
end
if ModulesInit.GuildMgr:checkCanManageGuild(ModulesInit.GuildMgr.EGuildManageType.EDIT_GUILD_MAIL)then
UIUtil.SetGray(bg_guild_mail.transform,false)
else
UIUtil.SetGray(bg_guild_mail.transform,true)
end
if ModulesInit.GuildMgr:checkCanManageGuild(ModulesInit.GuildMgr.EGuildManageType.SET_JOIN_CONDITON)then
UIUtil.SetGray(bg_set_cond.transform,false)
else
UIUtil.SetGray(bg_set_cond.transform,true)
end
if ModulesInit.GuildMgr:checkCanManageGuild(ModulesInit.GuildMgr.EGuildManageType.EDIT_GUILD_NOTICE)then
UIUtil.SetGray(bg_set_notice.transform,false)
else
UIUtil.SetGray(bg_set_notice.transform,true)
end
if ModulesInit.GuildMgr:checkCanManageGuild(ModulesInit.GuildMgr.EGuildManageType.EDIT_RECRUIT_NOTICE)then
UIUtil.SetGray(bg_set_recruit.transform,false)
else
UIUtil.SetGray(bg_set_recruit.transform,true)
end
local t=""
if ModulesInit.GuildMgr.guildInfo.joinFightLimit>0 then
t=GameTools.GetLocalize("UI.guild.Join.26",LanguageCategory.LangCommon,ModulesInit.GuildMgr.guildInfo.joinFightLimit)
else
local e=GameTools.GetLocalize("UI.guild.Join.09",LanguageCategory.LangCommon)
t=GameTools.GetLocalize("UI.guild.Join.26",LanguageCategory.LangCommon,e)
end
local e
if ModulesInit.GuildMgr.guildInfo.joinNeedApprove then
e=GameTools.GetLocalize("UI.guild.Join.27",LanguageCategory.LangCommon)
else
e=GameTools.GetLocalize("UI.guild.Manage.69",LanguageCategory.LangCommon)
end
LuaUtils.SetTextMeshText(text_tiaojian1,t)
LuaUtils.SetTextMeshText(text_tiaojian2,e)
local e=ModulesInit.GuildMgr:getGuildNotice(ModulesInit.GuildMgr.guildInfo.notice)
e=string.gsub(e,"%s","")
UIUtil.SetMarqueeWithDesc(mask_notice,text_notice_desc,100,e,false,true)
local e=ModulesInit.GuildMgr:getGuildNotice(ModulesInit.GuildMgr.guildInfo.recruitMsg)
e=string.gsub(e,"%s","")
UIUtil.SetMarqueeWithDesc(mask_recruit_notice,text_recruit_notice_desc,100,e,false,true)
RefreshRedPoint()
end
function RefreshRedPoint()
LuaUtils.SetActive(rd_apply.transform,RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.GUILD_APPLY))
end
function OnEventGuildInfoChange()
Refresh()
end
function OnGuildLeave()
GameTools.CloseUIForm(UIFormId.UI_GuildManageView)
end
function OnGuildPosChange()
Refresh()
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

