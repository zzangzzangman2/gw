local t=nil
local a={}
local n=nil
function OnInit(e,e)
Image.onClick:AddListener(function()
GameTools.CloseUIForm(UIFormId.UI_GuildDetailView)
end)
btn_shenqing.onClick:AddListener(function()
if t==nil then
return
end
if t.applyState==PROTO_ENUM.ENUM_APPLY_STATE.GUILD_APPLY_WAIT_APPROVE then
return
end
local e,a=ModulesInit.GuildMgr:checkApplyGuild(t)
if e==false then
ModulesInit.GuildMgr:ShowGuildNameErrorTip(a)
return
end
local e={
guildId=t.guildId
}
ModulesInit.GuildMgr:ReqGuildApply(e,t.joinNeedApprove)
end)
local e={}
e.mPadding1=0
e.mPadding2=0
e.mColumnOrRowCount=5
e.mItemWidthOrHeight=130
lsg_hero:InitListView(0,e,OnGetItemByIndex)
end
function OnOpen(e)
EventSystem.AddListener(CommonEventId.OnRespGuildApply,OnRespGuildApply)
EventSystem.AddListener(CommonEventId.GuildCloseEntrance,onEventGuildCloseEntrance)
t=e.guild
a=e.members
SortMemberInfo()
n=e.serverId
LuaUtils.SetActive(btn_shenqing.transform,false)
Refresh()
end
function OnClose()
EventSystem.RemoveListener(CommonEventId.OnRespGuildApply,OnRespGuildApply)
EventSystem.RemoveListener(CommonEventId.GuildCloseEntrance,onEventGuildCloseEntrance)
lsg_hero:SetListItemCount(0)
end
function OnBeforeDestroy()
end
function Refresh()
if t==nil then
return
end
local e=t
GameTools:SetImageSprite(bg_huizhang,ModulesInit.GuildMgr:getGuildIconBg(e.bg),false)
GameTools:SetImageSprite(im_huizhang,ModulesInit.GuildMgr:getGuildFg(e.fg),false)
LuaUtils.SetTextMeshText(text_name,e.name)
LuaUtils.SetLabelText(text_lv,GameTools.GetLocalize("UI.guild.Main.03",LanguageCategory.LangCommon,e.level))
LuaUtils.SetLabelText(text_num,GameTools.GetLocalize("UI.guild.Main.02",LanguageCategory.LangCommon,e.curMemCount,e.maxMemCount))
LuaUtils.SetLabelText(text_id,GameTools.GetLocalize("UI.guild.Main.01",LanguageCategory.LangCommon,e.guildId))
LuaUtils.SetLabelText(text_fight,GameTools.GetLocalize("UI.guild.Join.30",LanguageCategory.LangCommon,UIUtil.NumTrim(e.fight)))
lsg_hero:SetListItemCount(#a,true)
LuaUtils.SetActive(btn_shenqing.transform,PlayerMgr.PlayerInfo.guildId<=0 and UserAccountInfo.serverId==n)
if e.applyState==PROTO_ENUM.ENUM_APPLY_STATE.GUILD_APPLY_WAIT_APPROVE then
UIUtil.SetGray(btn_shenqing.transform,true)
LuaUtils.SetTextMeshText(text_shenqing,GameTools.GetLocalize("UI.guild.Join.28",LanguageCategory.LangCommon))
else
local t,a=ModulesInit.GuildMgr:checkApplyGuild(e)
UIUtil.SetGray(btn_shenqing.transform,t==false)
if e.joinNeedApprove==true then
LuaUtils.SetTextMeshText(text_shenqing,GameTools.GetLocalize("UI.guild.Join.11",LanguageCategory.LangCommon))
else
LuaUtils.SetTextMeshText(text_shenqing,GameTools.GetLocalize("UI.dragon.TeamList.05",LanguageCategory.LangCommon))
end
end
end
function OnGetItemByIndex(e,o)
o=o+1
local e=e:NewListViewItem("item")
local t=LuaUtils.GetLuaComBinder(e.transform)
local t=t:GetComponents()
local i=a[o]
if e.IsInitHandlerCalled==false then
t["btn_hero"].onClick:AddListener(handler(e,function(e)
local e=e.UserObjectData
local e=a[e]
UIUtil.showPlayerInfo(e.memberId,n)
end))
e.IsInitHandlerCalled=true
end
e.UserObjectData=o
UIUtil.SetPlayerIconFrame(t["head_yuan150"],i)
LuaUtils.SetTextMeshText(t["text_lv"],GameTools.GetLocalize("UI.guild.Main.03",LanguageCategory.LangCommon,i.level))
LuaUtils.SetLabelText(t["text_name"],i.name)
LuaUtils.SetActive(t["im_guild_leader"].transform,i.postion==PROTO_ENUM.ENUM_MEM_POSITION.MEM_LEADER)
return e
end
function OnRespGuildApply(e)
local a=e.guildId
if a~=t.guildId then
return
end
if e.state==PROTO_ENUM.ENUM_APPLY_STATE.GUILD_APPLY_WAIT_APPROVE then
t.applyState=e.state
Refresh()
elseif e.state==PROTO_ENUM.ENUM_APPLY_STATE.GUILD_APPLY_AGREE then
JumpMgr.OnGameJumpUIGuild()
end
end
function onEventGuildCloseEntrance()
GameTools.CloseUIForm(UIFormId.UI_GuildDetailView)
end
function SortMemberInfo()
table.sort(a,function(e,t)
if e.postion~=t.postion then
if e.postion==PROTO_ENUM.ENUM_MEM_POSITION.MEM_LEADER then
return true
end
if t.postion==PROTO_ENUM.ENUM_MEM_POSITION.MEM_LEADER then
return false
end
end
if e.fight~=t.fight then
return e.fight>t.fight
end
return e.memberId>t.memberId
end)
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

