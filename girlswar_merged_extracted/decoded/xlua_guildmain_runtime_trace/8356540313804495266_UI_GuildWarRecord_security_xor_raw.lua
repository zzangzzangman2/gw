local s={
'UICommonOther/UI_jingjichang_zhanbao_shenglidi',
'UICommonOther/UI_jingjichang_zhanbao_shibaidi'
}
local r={
'UICommonOther/multilang_UI_jingjichang_zhanbao_shibaizi',
'UICommonOther/multilang_UI_jingjichang_zhanbao_shenglizi'
}
local e=nil
local n=ModulesInit.CSGuildWarManager
local a=nil
function OnInit(e,e)
bg.onClick:AddListener(
function()
GameTools.CloseUIForm(UIFormId.UI_CSGuildWarRecord)
end
)
uiScroll:InitListView(-1,GetItemByIndex)
end
function OnOpen(t)
a=t
LuaUtils.SetActive(kong,false)
e=t.records
uiScroll:SetListItemCount(#e)
uiScroll:RefreshAllShownItem()
uiScroll:MovePanelToItemIndex(0,0)
if#e==0 then
LuaUtils.SetActive(kong,true)
end
end
function GetItemByIndex(o,t)
if t<0 then
return nil
end
local h=o:NewListViewItem("item")
if not e then
return h
end
local t=e[t+1]
if not t then
return h
end
local e=LuaUtils.GetLuaComBinder(h.transform)
local e=e:GetComponents()
local i=nil
if a.isDef then
i=a.playerInfo
else
i=t.attPlayer
end
UIUtil.SetPlayerIconFrame(e['head1']:Find('head_yuan150'),i)
LuaUtils.SetLabelTextWrap(e['head1']:Find('txt_lv'),i.level)
LuaUtils.SetLabelText(e['txt_name'],i.name)
local o=nil
if not a.isDef then
o=t.attWin
if o then
GameTools:SetImageSprite(e['im_statu_bg'],s[1])
GameTools:SetImageSprite(e['im_statu2'],r[1])
else
GameTools:SetImageSprite(e['im_statu_bg'],s[2])
GameTools:SetImageSprite(e['im_statu2'],r[2])
end
else
o=t.win
if not o then
GameTools:SetImageSprite(e['im_statu_bg'],s[1])
GameTools:SetImageSprite(e['im_statu2'],r[1])
else
GameTools:SetImageSprite(e['im_statu_bg'],s[2])
GameTools:SetImageSprite(e['im_statu2'],r[2])
end
end
if a.isDef then
LuaUtils.SetActive(e['im_att'],false)
LuaUtils.SetActive(e['im_def'],true)
else
LuaUtils.SetActive(e['im_att'],true)
LuaUtils.SetActive(e['im_def'],false)
end
local o=nil
if a.isDef then
o=t.fightTime
else
o=t.attTimestamp
end
if o and o~=0 then
LuaUtils.SetLabelText(e['txt_time'],TimeUtil.TimestampToyyyyMMddHHmmss2(o))
end
local o=nil
if a.isDef then
o=t.playerInfo
else
o=t.defPlayer
end
local s=nil
if a.isDef then
s=t.killCount
end
UIUtil.SetPlayerIconFrame(e['head2']:Find('head_yuan150'),o)
LuaUtils.SetLabelTextWrap(e['head2']:Find('txt_lv'),o.level)
LuaUtils.SetLabelText(e['txt_name_2'],o.name)
if not a.isDef then
LuaUtils.SetLabelText(e['txt_points'],t.score)
LuaUtils.SetLabelText(e['txt_kills'],t.killCount)
else
LuaUtils.SetLabelText(e['txt_points'],o.gainGrade)
LuaUtils.SetLabelText(e['txt_kills'],s or 0)
end
local t=t.battleId
LuaUtils.GetUIEventListener(e['im_replay']).onClick=function()
local e=n:SendSeeBattleInfoRequest(t)
e.onCompleted=function()
GameTools.CloseUIForm(UIFormId.UI_CSGuildWarRecord)
if GameEntry.UI:IsExists(UIFormId.UI_GuildWarEmbattle)then
GameTools.CloseUIForm(UIFormId.UI_GuildWarEmbattle)
end
if a.isDef then
n:ToPlayback(n.Playback.fightInfo.fight,o,i)
else
n:ToPlayback(n.Playback.fightInfo.fight,i,o)
end
end
end
return h
end
function function_name()
end
function OnClose()
end
function OnBeforeDestroy()
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

