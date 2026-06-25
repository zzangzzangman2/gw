local e=table.add
local d=math.ceil
local o=4
local h={
'UILegion/juntuan_itembg',
'UILegion/juntuan_itembg1',
'UILegion/juntuan_itembg3'
}
local t=ModulesInit.CSGuildWarManager
local e=ModulesInit.GuildMgr
local r=t:GetGuildWarDBCfg()
local i=nil
local a={}
local n={}
local s=0
local l=0
function OnInit(e,e)
btn_fanhui.onClick:AddListener(function()
GameTools.CloseUIForm(UIFormId.UI_GuildWarNoOpenForFirst)
end)
btn_reward.onClick:AddListener(function()
if t:SelfIsCanJoin()then
if t:GuildFirstTimeJoinAwardIsGeted()then
ShowFirstJoinRewardReview(true)
else
local e=t:SendGuildWarGetBoxRequest()
e.onCompleted=function()
UpdateFirstJoinBoxStatu()
end
end
return
end
ShowFirstJoinRewardReview()
end)
btn_help.onClick:AddListener(
function()
GameEntry.UI:OpenUIForm(UIFormId.UI_Help,{helpId="Tournament",isOpen=t.GuildWarStatusInfo.warType==PROTO_ENUM.ENUM_GUILD_WAR_TYPE.WAR_CS_SERVER})
end
)
LuaUtils.SetActive(tips_reward,false)
scroll:InitListView(0,GetBossItemByIndex)
end
function OnOpen(e)
SetContent()
RedPointCheck()
EventSystem.AddListener(SysEventId.OnClick,OnClickCallBack)
EventSystem.AddListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
end
function SetContent()
local e=t:SelfIsCanJoin()
local o=t:GuildIsCanJoin()
LuaUtils.SetActive(im_warring,PlayerMgr.PlayerInfo.level<r.lv)
LuaUtils.SetChildrenActive(awardsGrid,false)
local e=r.showAward
for t=1,#e do
local a=e[t]
local e=UIUtil.GetChild(awardsGrid,t-1)
if not e then
e=LuaUtils.Instantiate(itemCell90)
LuaUtils.SetParent(e,awardsGrid)
LuaUtils.SetLocalScale(e,0.85,0.85,1)
end
LuaUtils.SetActive(e,true)
local t={
thingDid=a[1],
offset=45,
}
UIUtil.SetItemCell(e,{itemDid=a[1],count=0},t)
end
LuaUtils.SetActive(txt_tips1,not o)
local e='성주>Lv.20이상, 로그인 3일차 조건 만족'
UIUtil.SetMarqueeWithDesc(mask_notice,text_notice_desc,100,e,false,true)
UpdateTime()
UpdatePlayerInfoList()
UpdateFirstJoinBoxStatu()
end
function UpdateTime()
if i then
i:Stop()
end
local e=t:GetGuildWarCountDown()
i=ModulesInit.TimeActionMgr:CreateTimeAction()
i:Init(0,1,e,nil,
function(e)
LuaUtils.SetLabelText(text_2nd_title,TimeUtil.TimestampToDate2(e))
end,
function()
GameTools.CloseUIForm(UIFormId.UI_GuildWarNoOpenForFirst)
local e=ModulesInit.CSGuildWarManager:SendGuildWarStatusInfoRequest()
e.onCompleted=function()
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildWarMain)
end
end):Run()
end
function UpdateFirstJoinBoxStatu()
if t:SelfIsCanJoin()then
if t:GuildFirstTimeJoinAwardIsGeted()then
LuaUtils.SetChildActive(btn_reward.transform,'im_redpoint',false)
else
LuaUtils.SetChildActive(btn_reward.transform,'im_redpoint',true)
end
else
LuaUtils.SetChildActive(btn_reward.transform,'im_redpoint',false)
end
end
function ShowFirstJoinRewardReview(i)
local e=LuaUtils.GetLuaComBinder(tips_reward)
local a=e:GetComponents()
local o=a['rewardiips_grid']
LuaUtils.SetActive(tips_reward,true)
LuaUtils.SetChildrenActive(o,false)
local e=r.firstAward
for a=1,#e do
local t=e[a]
local e=UIUtil.GetChild(o,a-1)
if not e then
e=LuaUtils.Instantiate(itemCell90)
LuaUtils.SetParent(e,o)
LuaUtils.SetLocalScale(e,1,1,1)
end
LuaUtils.SetActive(e,true)
local a={
thingDid=t[1],
offset=45,
}
UIUtil.SetItemCell(e,{itemDid=t[1],count=t[2]},a)
end
if not i then
if not t:GuildIsCanJoin()then
UIUtil.SetTextMeshTextForLocalize(a['text_tiaojian'],'UI.guildBattle.main.17')
else
if PlayerMgr.PlayerInfo.level<r.lv then
UIUtil.SetTextMeshTextForLocalize(a['text_tiaojian'],'UI.guildBattle.main.18',LanguageCategory.LangCommon,r.level)
else
LuaUtils.SetTextMeshText(a['text_tiaojian'],'')
end
end
else
LuaUtils.SetTextMeshText(a['text_tiaojian'],'수령 완료')
end
end
function CloseFirstJoinRewardReview()
LuaUtils.SetActive(tips_reward,false)
end
function GetBossItemByIndex(i,t)
if t<0 then
return nil
end
local e
if t==0 then
e=i:NewListViewItem("title")
LuaUtils.SetChildActive(e.transform,'text_title',true)
LuaUtils.SetChildActive(e.transform,'text_title2',false)
local t
if#a<8 then
t=string.format("<color=#FF2022FF>%d",#a)
else
t=string.format("<color=green>%d",#a)
end
LuaUtils.SetChildLabelTextWrap(e.transform,'text_title',t,8)
elseif t>0 and t<=s then
e=i:NewListViewItem("item")
for n=1,o do
local i=(t-1)*o+n
local o=UIUtil.GetChild(e.transform,n-1)
local t=a[i]
local e=LuaUtils.GetLuaComBinder(o)
local e=e:GetComponents()
LuaUtils.SetActive(o,true)
if i<=#a then
LuaUtils.SetActive(e['node_1'],true)
LuaUtils.SetActive(e['node_2'],false)
UIUtil.SetPlayerIconFrame(e["head_yuan150"],t)
LuaUtils.SetLabelTextWrap(e['txt_lv'],t.level)
LuaUtils.SetLabelText(e['txt_name'],t.name)
if t.playerId==PlayerMgr.PlayerInfo.uid then
GameTools:SetImageSprite(e['im_bg'],h[2])
else
GameTools:SetImageSprite(e['im_bg'],h[1])
LuaUtils.GetUIEventListener(o).onClick=handler(t,function()
if t.playerId~=PlayerMgr.PlayerInfo.uid then
UIUtil.showPlayerInfo(t.playerId,t.serverId)
end
end)
end
else
if i<=8 then
LuaUtils.SetActive(e['node_1'],false)
LuaUtils.SetActive(e['node_2'],true)
GameTools:SetImageSprite(e['im_bg'],h[1])
else
LuaUtils.SetActive(o,false)
end
end
end
elseif t==s+1 then
e=i:NewListViewItem("title")
LuaUtils.SetChildActive(e.transform,'text_title',false)
LuaUtils.SetChildActive(e.transform,'text_title2',true)
LuaUtils.SetChildLabelTextWrap(e.transform,'text_title2',#n)
else
t=t-(s+2)
e=i:NewListViewItem("item")
for a=1,o do
local o=t*o+a
local a=UIUtil.GetChild(e.transform,a-1)
local e=n[o]
local t=LuaUtils.GetLuaComBinder(a)
local t=t:GetComponents()
if o<=#n then
LuaUtils.SetActive(a,true)
LuaUtils.SetActive(t['node_1'],true)
LuaUtils.SetActive(t['node_2'],false)
UIUtil.SetPlayerIconFrame(t["head_yuan150"],e)
LuaUtils.SetLabelTextWrap(t['txt_lv'],e.level)
LuaUtils.SetLabelText(t['txt_name'],e.name)
if e.playerId==PlayerMgr.PlayerInfo.uid then
GameTools:SetImageSprite(t['im_bg'],h[2])
else
GameTools:SetImageSprite(t['im_bg'],h[3])
LuaUtils.GetUIEventListener(a).onClick=handler(e,function()
if e.playerId~=PlayerMgr.PlayerInfo.uid then
UIUtil.showPlayerInfo(e.playerId,e.serverId)
end
end)
end
else
LuaUtils.SetActive(a,false)
end
end
end
return e
end
function UpdatePlayerInfoList()
local e=t:SendGuildActivePlayerRequest(false)
e.onCompleted=function()
OnGuildActivePlayer(t.CurReqActivePlauerInfo)
end
end
function OnGuildActivePlayer(e)
a=e.activePlayers
n=e.unactivePlayers
s=d(#a/o)
if s<2 then
s=2
end
l=d(#n/o)
local e=d((#a+#n)/o)+3
scroll:SetListItemCount(e)
scroll:RefreshAllShownItem()
scroll:MovePanelToItemIndex(0)
end
function OnClickCallBack()
if LuaUtils.GetActive(tips_reward)then
CloseFirstJoinRewardReview()
end
end
function RedPointCheck()
end
function OnEventNetReconnectSuccess()
UpdatePlayerInfoList()
end
function OnFormBack()
SetContent()
end
function OnClose()
if i then
i:Stop()
end
EventSystem.RemoveListener(SysEventId.OnClick,OnClickCallBack)
EventSystem.RemoveListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
end
function OnBeforeDestroy()
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

