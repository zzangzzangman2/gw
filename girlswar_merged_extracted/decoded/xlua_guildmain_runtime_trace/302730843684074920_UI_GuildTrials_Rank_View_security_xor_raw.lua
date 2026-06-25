local i=ModulesInit.GuildTrialsMgr
local o={}
local e={}
local n={}
local s={}
local a=1
function OnInit(t,t)
Image.onClick:AddListener(function()
GameTools.CloseUIForm(UIFormId.UI_GuildTrials_Rank_View)
end)
toggle1.onClick:AddListener(function()
if a==1 then
return
end
a=1
local t=i:reqGuildTrialsPlayerRank()
t.onCompleted=function(a,t)
o=t.rankList
e=t.selfRank
SelectToggleView()
end
end)
toggle2.onClick:AddListener(function()
if a==2 then
return
end
a=2
local e=i:reqGuildTrialsGuildRank()
e.onCompleted=function(t,e)
n=e.rankList
s=e.selfRank
SelectToggleView()
end
end)
playerScrollView:InitListView(0,OnGetPlayerItemByIndex)
guildScrollView:InitListView(0,OnGetGuildItemByIndex)
end
function OnOpen(t)
EventSystem.AddListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
a=1
local t=i:reqGuildTrialsPlayerRank()
t.onCompleted=function(a,t)
o=t.rankList
e=t.selfRank
SelectToggleView()
end
end
function OnClose()
EventSystem.RemoveListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
end
function OnEventNetReconnectSuccess()
GameTools.CloseUIForm(UIFormId.UI_GuildTrials_Rank_View)
end
function Refresh(e)
RefreshView()
end
function RefreshData()
end
function RefreshView()
LuaUtils.SetActive(playerRankNode.transform,false)
LuaUtils.SetActive(guildRankNode.transform,false)
if a==1 then
LuaUtils.SetActive(playerRankNode.transform,true)
RefreshPlayRankView()
else
LuaUtils.SetActive(guildRankNode.transform,true)
RefreshGuildRankView()
end
end
function RefreshPlayRankView()
LuaUtils.SetActive(playerScrollView.transform,false)
LuaUtils.SetActive(player_bg_empty.transform,false)
if#o>0 then
LuaUtils.SetActive(playerScrollView.transform,true)
else
LuaUtils.SetActive(player_bg_empty.transform,true)
end
playerScrollView:SetListItemCount(#o)
playerScrollView:RefreshAllShownItem()
playerScrollView:MovePanelToItemIndex(0)
RefreshMyPlayInfoView()
end
function RefreshMyPlayInfoView()
local t=bg_juese_ziji:GetComponents()
local e=e
UIUtil.SetPlayerIconFrame(t["head"],e or PlayerMgr.PlayerInfo)
LuaUtils.SetLabelText(t["text_name"],(e and e.name)or PlayerMgr.PlayerInfo.name)
LuaUtils.SetLabelText(t["text_tiaozhanNum_txt"],GameTools.GetLocalize("guildTrials_desc_24",LanguageCategory.LangCommon,(e and e.fightCount)or 0))
LuaUtils.SetTextMeshText(t["text_score_num"],(e and e.score)or 0)
LuaUtils.SetActive(t["top"].transform,false)
LuaUtils.SetActive(t["text_paiming_num"].transform,false)
if e and e.rankNo and e.rankNo>0 and e.rankNo<4 then
LuaUtils.SetActive(t["top"].transform,true)
for a=1,3 do
LuaUtils.SetActive(t["im_no"..a].transform,false)
if e.rankNo==a then
LuaUtils.SetActive(t["im_no"..a].transform,true)
end
end
else
LuaUtils.SetActive(t["text_paiming_num"].transform,true)
if(e and e.rankNo and e.rankNo==0)or not e then
LuaUtils.SetTextMeshText(t["text_paiming_num"],GameTools.GetLocalize("UI.Titans.Main.07",LanguageCategory.LangCommon))
else
if e.rankNo>i:getGuildTrialsBaseCfg().playerRank then
LuaUtils.SetTextMeshText(t["text_paiming_num"],GameTools.GetLocalize("UI.Titans.Main.07",LanguageCategory.LangCommon))
else
LuaUtils.SetTextMeshText(t["text_paiming_num"],e.rankNo)
end
end
end
end
function OnGetPlayerItemByIndex(t,e)
e=e+1
local a=o[e]
local e=t:NewListViewItem("bg_juese")
local t=LuaUtils.GetLuaComBinder(e.transform)
local t=t:GetComponents()
RefreshPlayerRankInfo(t,a)
return e
end
function RefreshPlayerRankInfo(e,t)
if e==nil or t==nil then
return
end
UIUtil.SetPlayerIconFrame(e["head"],t)
LuaUtils.SetLabelText(e["text_name"],t.name)
LuaUtils.SetLabelText(e["text_tiaozhanNum_txt"],GameTools.GetLocalize("guildTrials_desc_24",LanguageCategory.LangCommon,t.fightCount))
LuaUtils.SetTextMeshText(e["text_score_num"],t.score)
LuaUtils.SetActive(e["top"].transform,false)
LuaUtils.SetActive(e["text_paiming_num"].transform,false)
if t.rankNo and t.rankNo>0 and t.rankNo<4 then
LuaUtils.SetActive(e["top"].transform,true)
for a=1,3 do
LuaUtils.SetActive(e["im_no"..a].transform,false)
if t.rankNo==a then
LuaUtils.SetActive(e["im_no"..a].transform,true)
end
end
else
LuaUtils.SetActive(e["text_paiming_num"].transform,true)
if t.rankNo==0 then
LuaUtils.SetTextMeshText(e["text_paiming_num"],GameTools.GetLocalize("UI.Titans.Main.07",LanguageCategory.LangCommon))
else
LuaUtils.SetTextMeshText(e["text_paiming_num"],t.rankNo)
end
end
end
function RefreshGuildRankView()
LuaUtils.SetActive(guildScrollView.transform,false)
LuaUtils.SetActive(guild_bg_empty.transform,false)
if#n>0 then
LuaUtils.SetActive(guildScrollView.transform,true)
else
LuaUtils.SetActive(guild_bg_empty.transform,true)
end
guildScrollView:SetListItemCount(#n)
guildScrollView:RefreshAllShownItem()
guildScrollView:MovePanelToItemIndex(0)
RefreshMyGuildInfoView()
end
function RefreshMyGuildInfoView()
local e=bg_guild_ziji:GetComponents()
local t=s
LuaUtils.SetImageSprite(e["bg_huizhang"],ModulesInit.GuildMgr:getGuildIconBg(t.bg),false)
LuaUtils.SetImageSprite(e["im_huizhang"],ModulesInit.GuildMgr:getGuildFg(t.fg),false)
LuaUtils.SetLabelText(e["text_guildName"],t.name)
LuaUtils.SetLabelText(e["text_huizhangName"],GameTools.GetLocalize("UI.guild.Join.29",LanguageCategory.LangCommon,t.captainName))
LuaUtils.SetTextMeshText(e["text_socre_num"],t.score)
LuaUtils.SetActive(e["top"].transform,false)
LuaUtils.SetActive(e["text_paiming_num"].transform,false)
if t.rankNo and t.rankNo>0 and t.rankNo<4 then
LuaUtils.SetActive(e["top"].transform,true)
for a=1,3 do
LuaUtils.SetActive(e["im_no"..a].transform,false)
if t.rankNo==a then
LuaUtils.SetActive(e["im_no"..a].transform,true)
end
end
else
LuaUtils.SetActive(e["text_paiming_num"].transform,true)
if t.rankNo==0 then
LuaUtils.SetTextMeshText(e["text_paiming_num"],GameTools.GetLocalize("UI.Titans.Main.07",LanguageCategory.LangCommon))
else
if t.rankNo>i:getGuildTrialsBaseCfg().guildRank then
LuaUtils.SetTextMeshText(e["text_paiming_num"],GameTools.GetLocalize("UI.Titans.Main.07",LanguageCategory.LangCommon))
else
LuaUtils.SetTextMeshText(e["text_paiming_num"],t.rankNo)
end
end
end
end
function OnGetGuildItemByIndex(t,e)
e=e+1
local a=n[e]
local e=t:NewListViewItem("bg_guild")
local t=LuaUtils.GetLuaComBinder(e.transform)
local t=t:GetComponents()
RefreshGuildRankInfo(t,a)
return e
end
function RefreshGuildRankInfo(e,t)
if e==nil or t==nil then
return
end
LuaUtils.SetImageSprite(e["bg_huizhang"],ModulesInit.GuildMgr:getGuildIconBg(t.bg),false)
LuaUtils.SetImageSprite(e["im_huizhang"],ModulesInit.GuildMgr:getGuildFg(t.fg),false)
LuaUtils.SetLabelText(e["text_guildName"],t.name)
LuaUtils.SetLabelText(e["text_huizhangName"],GameTools.GetLocalize("UI.guild.Join.29",LanguageCategory.LangCommon,t.captainName))
LuaUtils.SetTextMeshText(e["text_socre_num"],t.score)
LuaUtils.SetActive(e["top"].transform,false)
LuaUtils.SetActive(e["text_paiming_num"].transform,false)
if t.rankNo and t.rankNo>0 and t.rankNo<4 then
LuaUtils.SetActive(e["top"].transform,true)
for a=1,3 do
LuaUtils.SetActive(e["im_no"..a].transform,false)
if t.rankNo==a then
LuaUtils.SetActive(e["im_no"..a].transform,true)
end
end
else
LuaUtils.SetActive(e["text_paiming_num"].transform,true)
if t.rankNo==0 then
LuaUtils.SetTextMeshText(e["text_paiming_num"],GameTools.GetLocalize("UI.Titans.Main.07",LanguageCategory.LangCommon))
else
LuaUtils.SetTextMeshText(e["text_paiming_num"],t.rankNo)
end
end
end
function SelectToggleView()
for t=1,2 do
local e=selfEnv["toggle"..t].transform
if a==t then
LuaUtils.SetChildActive(e,'im_on',true)
LuaUtils.SetChildActive(e,'im_off',false)
else
LuaUtils.SetChildActive(e,'im_on',false)
LuaUtils.SetChildActive(e,'im_off',true)
end
end
Refresh()
end
function OnBeforeDestroy()
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

