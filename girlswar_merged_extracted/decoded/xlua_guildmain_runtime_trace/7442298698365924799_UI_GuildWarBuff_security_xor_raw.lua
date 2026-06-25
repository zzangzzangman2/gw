local t=ModulesInit.CSGuildWarManager
local e=t:GetGuildWarDBCfg()
local a=nil
function OnInit(a,a)
bg.onClick:AddListener(
function()
GameTools.CloseUIForm(UIFormId.UI_GuildWarBuff)
end
)
btn_bot.onClick:AddListener(
function()
local h,s,n,o,a,i=GetBuffCondition()
if not a then
UIUtil.ShowCommonTipsForLocalize("UI.guildBattle.layout.19")
return
end
if h then
UIUtil.ShowCommonTipsForLocalize("UI.guildBattle.layout.15")
return
end
if s then
UIUtil.ShowCommonTipsForLocalize("UI.guildBattle.layout.16")
return
end
if not n then
UIUtil.ShowCommonTipsForLocalize("UI.guildBattle.layout.17")
return
end
if o then
UIUtil.ShowCommonTipsForLocalize("UI.guildBattle.layout.18")
return
end
if not i then
UIUtil.ShowCommonTipsForLocalize("UI.guildBattle.entry.04")
return
end
local a=ModulesInit.BagManager:GetItemCountById(e.inspireCost[1])
if a<e.inspireCost[2]then
GameTools:GotoWays({id=e.inspireCost[1]})
return
end
local t=t:SendGuildWarBuffRequest()
t.onCompleted=function()
UIUtil.ShowCommonTipsForLocalize("UI.guildBattle.layout.14",LanguageCategory.LangCommon,PlayerMgr.PlayerInfo.name,e.inspireAtkAdd,e.inspireHpAdd)
GameTools.CloseUIForm(UIFormId.UI_GuildWarBuff)
end
end
)
UI_scrollview_cont:InitListView(-1,GetItemByIndex)
end
function OnOpen(e)
EventSystem.AddListener(CommonEventId.OnPlayCurrencyRefresh,UpdateContent)
UpdateContent()
end
function OnClose()
EventSystem.RemoveListener(CommonEventId.OnPlayCurrencyRefresh,UpdateContent)
end
function UpdateContent()
a=t.CurBuffRecordInfos.name
SetContent()
UI_scrollview_cont:SetListItemCount(#a,true)
UI_scrollview_cont:RefreshAllShownItem()
UI_scrollview_cont:MovePanelToItemIndex(#a,0)
end
function SetContent()
local o=e.inspireAward[1]
UIUtil.SetCurrencyIcon(im_gem,o[1])
LuaUtils.SetTextMeshText(txt_gen_num,o[2])
local o=e.inspireAward[2]
UIUtil.SetCurrencyIcon(im_gem2,o[1])
LuaUtils.SetTextMeshText(txt_gen_num2,o[2])
LuaUtils.SetLabelTextWrap(
txt_disc,
GameTools.GetLocalize("UI.guildBattle.main2.06",LanguageCategory.LangCommon,e.inspireAtkAdd),
GameTools.GetLocalize("UI.guildBattle.main2.07",LanguageCategory.LangCommon,e.inspireHpAdd)
)
UIUtil.SetCurrencyIcon(btn_im_gem,e.inspireCost[1])
LuaUtils.SetTextMeshText(btn_txt_num,e.inspireCost[2])
local t=t.GuildWarStatusInfo.selfInspireCount>0
if t then
LuaUtils.SetActive(txt_ready,true)
LuaUtils.SetActive(btn_bot.transform,false)
else
LuaUtils.SetActive(txt_ready,false)
LuaUtils.SetActive(btn_bot.transform,true)
end
local t=e.inspireAtkAdd*#a
local e=e.inspireHpAdd*#a
LuaUtils.SetLabelTextWrap(
txt_tip,
GameTools.GetLocalize("UI.guildBattle.main2.06",LanguageCategory.LangCommon,t),
GameTools.GetLocalize("UI.guildBattle.main2.07",LanguageCategory.LangCommon,e)
)
UpdateBotBtnState()
end
function UpdateBotBtnState()
local n,o,i,a,t,e=GetBuffCondition()
if not n and not o and i and not a and t and e then
UIUtil.SetGray(btn_bot.transform,false)
LuaUtils.SetChildActive(btn_bot.transform,'im_redpoint',true)
else
UIUtil.SetGray(btn_bot.transform,true)
LuaUtils.SetChildActive(btn_bot.transform,'im_redpoint',false)
end
end
function GetBuffCondition()
local o=t:SelfIsCanJoin()
local a=false
if t:GetGuildWarStage()~=PROTO_ENUM.ENUM_GUILD_WAR_STATUS.MATCHING then
a=t:GuildIsBye()
end
local i=t:GetGuildWarStage()==PROTO_ENUM.ENUM_GUILD_WAR_STATUS.NOT_OPEN or t:GetGuildWarStage()==PROTO_ENUM.ENUM_GUILD_WAR_STATUS.STOP
local n=t:GuildIsCanJoin()
local e=t.GuildWarStatusInfo.guildInspireCount>=e.guildInspire
local t=t:GetGuildWarStage()==PROTO_ENUM.ENUM_GUILD_WAR_STATUS.FIGHTING
return a,i,n,e,t,o
end
function GetItemByIndex(t,o)
if o<0 then
return nil
end
local t=t:NewListViewItem("tiltle")
local a=a[o+1]
if a then
LuaUtils.SetChildLabelTextWrap(
t.transform,
"text_title",
a,
GameTools.GetLocalize("UI.guildBattle.main2.06",LanguageCategory.LangCommon,e.inspireAtkAdd),
GameTools.GetLocalize("UI.guildBattle.main2.07",LanguageCategory.LangCommon,e.inspireHpAdd)
)
end
return t
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

