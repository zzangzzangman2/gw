local r={
"UICommonOther/IC_paihangbang_tubiao1",
"UICommonOther/IC_paihangbang_tubiao2",
"UICommonOther/IC_paihangbang_tubiao3"
}
local o={
Total=1,
Compare=2
}
local e=ModulesInit.CSGuildWarManager
local s=e:GetGuildWarDBCfg()
local n=o.Total
local a=nil
local h={}
function OnInit(e,t)
bg.onClick:AddListener(
function()
GameTools.CloseUIForm(UIFormId.UI_GuildWarRank)
end
)
btn_switch.onClick:AddListener(
function()
if n==o.Total then
n=o.Compare
else
n=o.Total
end
UpdateSwitchBtnStage()
end
)
UI_scrollview1:InitListView(-1,GetItemByIndex1)
UI_scrollview2:InitListView(-1,GetItemByIndex2)
GameTools:ChangeSkeletonGraphic(e:Find("im_char"),"Assets/Download/RolePrefabsAndRes/StoryPrefabAndRes/1019_1/1019_1.prefab")
end
function OnOpen()
UpdateSwitchBtnStage()
end
function UpdateSwitchBtnStage()
local t=e:GetRankListInfo()
local i=e:GetGuildWarStage()
if t then
a=t.allRank
end
if n==o.Total then
LuaUtils.SetLocalPos(move,44,-18,0)
LuaUtils.SetActive(node_p1,true)
LuaUtils.SetActive(node_p2,false)
if not e:GuildIsCanJoin()or
e:GetGuildWarStage()==PROTO_ENUM.ENUM_GUILD_WAR_STATUS.MATCHING or
(i~=PROTO_ENUM.ENUM_GUILD_WAR_STATUS.NOT_OPEN and i~=PROTO_ENUM.ENUM_GUILD_WAR_STATUS.MATCHING and e:GuildIsBye())
then
LuaUtils.SetActive(node_none1,true)
LuaUtils.SetActive(node1,false)
else
LuaUtils.SetActive(node_none1,false)
LuaUtils.SetActive(node1,true)
SetRankItem1(item_self,t.allRankSelf,true)
UI_scrollview1:SetListItemCount(#a,true)
UI_scrollview1:RefreshAllShownItem()
UI_scrollview1:MovePanelToItemIndex(#a,0)
end
else
LuaUtils.SetLocalPos(move,124,-18,0)
LuaUtils.SetActive(node_p1,false)
LuaUtils.SetActive(node_p2,true)
if not e:GuildIsCanJoin()or
e:GetGuildWarStage()==PROTO_ENUM.ENUM_GUILD_WAR_STATUS.MATCHING or
(i~=PROTO_ENUM.ENUM_GUILD_WAR_STATUS.NOT_OPEN and i~=PROTO_ENUM.ENUM_GUILD_WAR_STATUS.MATCHING and e:GuildIsBye())
then
LuaUtils.SetActive(node_none2,true)
LuaUtils.SetActive(node2,false)
else
LuaUtils.SetActive(node_none2,false)
LuaUtils.SetActive(node2,true)
local e=0
if#t.downRank>#t.upRank then
e=#t.downRank
else
e=#t.upRank
end
h={}
for e=1,e do
local a=t.downRank[e]
local e=t.upRank[e]
table.add(h,{downInfo=a,upInfo=e})
end
UI_scrollview2:SetListItemCount(e,true)
UI_scrollview2:RefreshAllShownItem()
UI_scrollview2:MovePanelToItemIndex(0,0)
end
end
end
function GetItemByIndex1(t,e)
if e<0 then
return nil
end
local t=t:NewListViewItem("item")
local e=a[e+1]
if e then
SetRankItem1(t.transform,e)
end
return t
end
function GetItemByIndex2(t,e)
if e<0 then
return nil
end
local t=t:NewListViewItem("item")
local e=h[e+1]
if e then
SetRankItem(t.transform,e)
end
return t
end
function SetRankItem1(e,t,o)
local e=LuaUtils.GetLuaComBinder(e)
local e=e:GetComponents()
if t then
if t.rankNo<=3 then
LuaUtils.SetActive(e["im_flag"].transform,true)
GameTools:SetImageSprite(e["im_flag"],r[t.rankNo])
LuaUtils.SetActive(e["txt_rank_1"].transform,false)
else
LuaUtils.SetActive(e["im_flag"].transform,false)
LuaUtils.SetActive(e["txt_rank_1"].transform,true)
LuaUtils.SetTextMeshText(e["txt_rank_1"],t.rankNo)
end
LuaUtils.SetTextMeshText(e["txt_lv"],t.level)
LuaUtils.SetLabelText(e["txt_name"],t.name)
LuaUtils.SetLabelText(e["txt_power"],UIUtil.toBigNum(t.fight))
LuaUtils.SetLabelText(e["txt_points"],t.gainGrade)
LuaUtils.SetLabelText(e["txt_times"],s.attackTime-t.leftAttCount)
UIUtil.SetPlayerIconFrame(e["head_yuan150"],t)
else
if o then
LuaUtils.SetActive(e["im_flag"].transform,false)
LuaUtils.SetActive(e["txt_rank_1"].transform,false)
LuaUtils.SetTextMeshText(e["txt_lv"],'0')
LuaUtils.SetLabelText(e["txt_name"],PlayerMgr.PlayerInfo.name)
LuaUtils.SetLabelText(e["txt_power"],'0')
LuaUtils.SetLabelText(e["txt_points"],'0')
LuaUtils.SetLabelText(e["txt_times"],s.attackTime)
UIUtil.SetPlayerIconFrame(e["head_yuan150"],PlayerMgr.PlayerInfo)
end
end
if o then
local t=false
if a then
for a,e in pairs(a)do
if e.playerId==PlayerMgr.PlayerInfo.uid then
t=true
end
end
end
if not t then
LuaUtils.SetActive(e["txt_rank_0"],true)
else
LuaUtils.SetActive(e["txt_rank_0"],false)
end
end
end
function SetRankItem(a,t)
local e=t.downInfo
local t=t.upInfo
if not e then
LuaUtils.SetChildActive(a,"down",false)
else
LuaUtils.SetChildActive(a,"down",true)
local t=LuaUtils.GetLuaComBinder(a:Find("down"))
local t=t:GetComponents()
LuaUtils.SetTextMeshText(t["txt_lv"],e.level)
LuaUtils.SetLabelText(t["txt_name"],e.name)
LuaUtils.SetLabelText(t["txt_power"],UIUtil.toBigNum(e.fight))
LuaUtils.SetLabelText(t["txt_points"],e.gainGrade)
LuaUtils.SetLabelText(t["txt_times"],s.attackTime-e.leftAttCount)
UIUtil.SetPlayerIconFrame(t["head_yuan150"],e)
end
if not t then
LuaUtils.SetChildActive(a,"up",false)
else
LuaUtils.SetChildActive(a,"up",true)
local e=LuaUtils.GetLuaComBinder(a:Find("up"))
local e=e:GetComponents()
LuaUtils.SetTextMeshText(e["txt_lv"],t.level)
LuaUtils.SetLabelText(e["txt_name"],t.name)
LuaUtils.SetLabelText(e["txt_power"],UIUtil.toBigNum(t.fight))
LuaUtils.SetLabelText(e["txt_points"],t.gainGrade)
LuaUtils.SetLabelText(e["txt_times"],s.attackTime-t.leftAttCount)
UIUtil.SetPlayerIconFrame(e["head_yuan150"],t)
end
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

