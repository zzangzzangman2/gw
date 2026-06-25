local e=table.add
local e=math.ceil
local s=string.format
local n={
'UILegion/juntuan_itembg',
'UILegion/juntuan_itembg1',
'UILegion/juntuan_itembg3'
}
local o=nil
local t=ModulesInit.CSGuildWarManager
local a=ModulesInit.GuildMgr
local t=t:GetGuildWarDBCfg()
local i={
qualifiedMembers=nil,
notQualifiedMembers=nil,
qualifiedItemCount=nil,
notQualifiedItemCount=nil,
scroll=nil
}
local t=i
function i:Init(e,t)
self.scroll=e
o=t
self.scroll:InitListView(0,self.GetBossItemByIndex)
end
function i:Show(e)
self.qualifiedMembers=nil
self.notQualifiedMembers=nil
self.qualifiedItemCount=nil
self.notQualifiedItemCount=nil
self:OnRespGuildMemberList(e)
end
function i:OnRespGuildMemberList(t)
self.qualifiedMembers=t.activePlayers
self.notQualifiedMembers=t.unactivePlayers
self.qualifiedItemCount=e(#self.qualifiedMembers/o)
if self.qualifiedItemCount<2 then
self.qualifiedItemCount=2
end
self.notQualifiedItemCount=e(#self.notQualifiedMembers/o)
local e=e((#self.qualifiedMembers+#self.notQualifiedMembers)/o)+3
self.scroll:SetListItemCount(e)
self.scroll:RefreshAllShownItem()
self.scroll:MovePanelToItemIndex(0)
end
function i.GetBossItemByIndex(i,a)
if a<0 then
return nil
end
local e
if a==0 then
e=i:NewListViewItem("title")
LuaUtils.SetChildActive(e.transform,'text_title',true)
LuaUtils.SetChildActive(e.transform,'text_title2',false)
local a
if#t.qualifiedMembers<8 then
a=s("<color=#FF2022FF>%d",#t.qualifiedMembers)
else
a=s("<color=green>%d",#t.qualifiedMembers)
end
LuaUtils.SetChildLabelTextWrap(e.transform,'text_title',a,8)
elseif a>0 and a<=t.qualifiedItemCount then
e=i:NewListViewItem("item")
for s=1,o do
local i=(a-1)*o+s
local o=UIUtil.GetChild(e.transform,s-1)
local a=t.qualifiedMembers[i]
local e=LuaUtils.GetLuaComBinder(o)
local e=e:GetComponents()
LuaUtils.GetUIEventListener(o).onClick=nil
LuaUtils.SetActive(o,true)
if i<=#t.qualifiedMembers then
LuaUtils.SetActive(e['node_1'],true)
LuaUtils.SetActive(e['node_2'],false)
UIUtil.SetPlayerIconFrame(e["head_yuan150"],a)
LuaUtils.SetLabelTextWrap(e['txt_lv'],a.level)
LuaUtils.SetLabelText(e['txt_name'],a.name)
if a.playerId==PlayerMgr.PlayerInfo.uid then
GameTools:SetImageSprite(e['im_bg'],n[2])
else
GameTools:SetImageSprite(e['im_bg'],n[1])
end
LuaUtils.GetUIEventListener(o).onClick=function()
if a.playerId~=PlayerMgr.PlayerInfo.uid then
UIUtil.showPlayerInfo(a.playerId,a.serverId)
end
end
else
if i<=8 then
LuaUtils.SetActive(e['node_1'],false)
LuaUtils.SetActive(e['node_2'],true)
GameTools:SetImageSprite(e['im_bg'],n[1])
else
LuaUtils.SetActive(o,false)
end
end
end
elseif a==t.qualifiedItemCount+1 then
e=i:NewListViewItem("title")
LuaUtils.SetChildActive(e.transform,'text_title',false)
LuaUtils.SetChildActive(e.transform,'text_title2',true)
LuaUtils.SetChildLabelTextWrap(e.transform,'text_title2',#t.notQualifiedMembers)
else
a=a-(t.qualifiedItemCount+2)
e=i:NewListViewItem("item")
for i=1,o do
local s=a*o+i
local o=UIUtil.GetChild(e.transform,i-1)
local e=t.notQualifiedMembers[s]
local a=LuaUtils.GetLuaComBinder(o)
local a=a:GetComponents()
LuaUtils.GetUIEventListener(o).onClick=nil
if s<=#t.notQualifiedMembers then
LuaUtils.SetActive(o,true)
LuaUtils.SetActive(a['node_1'],true)
LuaUtils.SetActive(a['node_2'],false)
UIUtil.SetPlayerIconFrame(a["head_yuan150"],e)
LuaUtils.SetLabelTextWrap(a['txt_lv'],e.level)
LuaUtils.SetLabelText(a['txt_name'],e.name)
if e.playerId==PlayerMgr.PlayerInfo.uid then
GameTools:SetImageSprite(a['im_bg'],n[2])
else
GameTools:SetImageSprite(a['im_bg'],n[3])
LuaUtils.GetUIEventListener(o).onClick=function()
if e.playerId~=PlayerMgr.PlayerInfo.uid then
UIUtil.showPlayerInfo(e.playerId,e.serverId)
end
end
end
else
LuaUtils.SetActive(o,false)
end
end
end
return e
end
function i:Hide()
end
return i 
