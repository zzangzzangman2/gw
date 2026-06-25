local d=require("DataNode/DataManager/DataMgr/DataUtil")
local s=require("DataNode/DataTable/Create/monster/DTMonsterDBModel")
local e=require("DataNode/DataTable/Create/monster/DTMonsterAttrDBModel")
local h=require("DataNode/DataTable/Create/model/DTmodelDBModel")
local a=require('DataNode/DataTable/Create/constant/DTServerListDBModel')
local o={
Attack=1,
Def=2
}
local e=nil
local r=nil
local n=ModulesInit.CrossArenaManager
function OnInit(e,e)
bg.onClick:AddListener(
function()
self:Close()
end
)
LuaUtils.GetUIEventListener(bg_tanchuang:Find("btn_1")).onClick=function()
if false then
UIUtil.ShowCommonTips("暂未加入军团，无法分享")
return
end
LuaUtils.SetActive(bg_tanchuang,false)
end
LuaUtils.GetUIEventListener(bg_tanchuang:Find("btn_2")).onClick=function()
LuaUtils.SetActive(bg_tanchuang,false)
GameEntry.UI:OpenUIForm(UIFormId.UI_ArenaRecordShare)
end
LuaUtils.GetUIEventListener(bg_tanchuang:Find("big")).onClick=function()
LuaUtils.SetActive(bg_tanchuang,false)
end
uiScroll:InitListView(-1,GetItemByIndex)
end
function OnOpen(t)
LuaUtils.SetActive(kong,false)
e=n.FightRecoed.records
uiScroll:SetListItemCount(#e)
uiScroll:RefreshAllShownItem()
uiScroll:MovePanelToItemIndex(0,0)
if#e==0 then
LuaUtils.SetActive(kong,true)
end
LuaUtils.SetActive(bg_tanchuang,false)
end
function GetItemByIndex(i,t)
if t<0 then
return nil
end
local i=i:NewListViewItem("bg_juese1")
if not e then
return i
end
local t=e[t+1]
if not t then
return i
end
local e=LuaUtils.GetLuaComBinder(i.transform)
local e=e:GetComponents()
LuaUtils.SetActive(e["bg_shengli"],false)
LuaUtils.SetActive(e["bg_shibai"],false)
LuaUtils.SetActive(e["im_lujiantou"],false)
LuaUtils.SetActive(e["im_hongjiantou"],false)
LuaUtils.SetActive(e["im_shou"],false)
LuaUtils.SetActive(e["im_gong"],false)
LuaUtils.SetActive(e["text_rank"].transform,false)
LuaUtils.SetLabelText(e["text_name"],t.enemy.name)
local a=a.GetEntity(t.enemy.serverId)
LuaUtils.SetLabelTextWrap(e['text_fuwuqi'],LuaUtils.GetLocalize(a.key))
if t.enemy.playerId>0 then
UIUtil.SetPlayerHead(e["btn_head"],t.enemy.head)
UIUtil.SetPlayerFrame(e["im_kuang"],t.enemy.headFrame)
else
local t=s.GetEntity(t.enemy.npcId)
local t=h.GetEntity(t.modelID)
UIUtil.SetPlayerHead(e["btn_head"],nil,t.head)
end
if t.fightType==o.Attack then
LuaUtils.SetActive(e["im_gong"],true)
else
LuaUtils.SetActive(e["im_shou"],true)
end
if t.isWin then
LuaUtils.SetActive(e["bg_shengli"],true)
LuaUtils.SetChildLabelText(e["bg_shengli"],"text_riqi",t.fightTime)
else
LuaUtils.SetActive(e["bg_shibai"],true)
LuaUtils.SetChildLabelText(e["bg_shibai"],"text_riqi",t.fightTime)
end
local a=0
local o=0
if t.newRank>0 then
a=t.newRank
end
if t.oldRank>0 then
o=t.oldRank
end
if a>0 then
LuaUtils.SetLabelTextWrap(e["text_rank"],tostring(a))
else
LuaUtils.SetLabelTextWrap(e["text_rank"],'')
end
if o~=0 then
if o>a then
LuaUtils.SetActive(e["im_lujiantou"],true)
LuaUtils.SetActive(e["text_rank"].transform,true)
LuaUtils.SetLabelText(e["text_up"],tostring(o-a))
elseif o<a then
LuaUtils.SetActive(e["im_hongjiantou"],true)
LuaUtils.SetActive(e["text_rank"].transform,true)
LuaUtils.SetLabelText(e["text_down"],tostring(a-o))
else
LuaUtils.SetActive(e["im_lujiantou"],false)
LuaUtils.SetActive(e["im_hongjiantou"],false)
end
else
LuaUtils.SetActive(e["text_rank"].transform,true)
LuaUtils.SetActive(e["im_lujiantou"],false)
LuaUtils.SetActive(e["im_hongjiantou"],false)
LuaUtils.SetLabelText(e["text_up"],'')
LuaUtils.SetLabelText(e["text_down"],'')
end
if t.newScore==t.oldScore then
LuaUtils.SetActive(e["text_jifen"].transform,false)
elseif t.newScore>t.oldScore then
LuaUtils.SetActive(e["text_jifen"].transform,true)
LuaUtils.SetLabelTextWrap(e["text_jifen"],string.format('<color=green>+%d</color>',t.newScore-t.oldScore))
else
LuaUtils.SetActive(e["text_jifen"].transform,true)
LuaUtils.SetLabelTextWrap(e["text_jifen"],string.format('<color=red>-%d</color>',t.oldScore-t.newScore))
end
local a=0
if t.enemy.playerId>0 then
a=t.enemy.fight
else
local o=d:GetArenaNpcData(t.enemy.rank)
for e=1,6 do
local e=o.robots[t.enemy.npcGroupId+1][e]
local e=s.GetEntity(e)
if e then
a=a+e.monValue
end
end
end
LuaUtils.SetLabelText(e["text_fight"],string.format('%s%s',UIUtil.NumericalUnitConvert(a)))
LuaUtils.SetLabelText(e["text_num2"],tostring(t.targetFirstValue))
LuaUtils.GetUIEventListener(e["btn_1"]).onClick=function()
r=t
SharePanelLocation(i.transform)
LuaUtils.SetActive(bg_tanchuang,true)
end
LuaUtils.GetUIEventListener(e["btn_2"]).onClick=function()
local e=n:SendPlaybackRequest(t.recordId)
e.onCompleted=function()
local a=n.Playback
local e=t.enemy
e.targetFirstValue=t.targetFirstValue
local t=table.deepCopy(PlayerMgr.PlayerInfo)
n:ToPlayback(a.fightInfo,t,e)
self:Close()
if GameEntry.UI:IsExists(UIFormId.UI_CrossArena)then
GameEntry.UI:CloseUIForm(UIFormId.UI_CrossArena)
end
if GameEntry.UI:IsExists(UIFormId.UI_CrossArenaMatching)then
GameEntry.UI:CloseUIForm(UIFormId.UI_CrossArenaMatching)
end
end
end
return i
end
function SharePanelLocation(e)
local e=bg_tanchuang.parent:InverseTransformPoint(e.position)
LuaUtils.SetLocalPos(bg_tanchuang,e.x+145,e.y-65,e.z)
end
function OnClose()
end
function OnBeforeDestroy()
end

