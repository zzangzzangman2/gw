local o=require("Modules/CSGuildWar/PlayerListView")
local e=ModulesInit.CSGuildWarManager
local t=nil
function OnInit(e,e)
bg.onClick:AddListener(function()
GameTools.CloseUIForm(UIFormId.UI_GuildWarGuildStatusReview)
end)
toggle1.onValueChanged:AddListener(function(e)
if e then
if t then
ApplyPlayerInfos(false)
end
end
end)
toggle2.onValueChanged:AddListener(function(e)
if e then
if not t then
ApplyPlayerInfos(true)
end
end
end)
o:Init(UI_scrollview_cont,6)
end
function OnOpen(e)
SetPlayerListView()
end
function ApplyPlayerInfos(a)
t=a
local t=e:SendGuildActivePlayerRequest(a)
t.onCompleted=function()
o:Show(e.CurReqActivePlauerInfo)
end
end
function SetPlayerListView()
LuaUtils.SetToggleValue(toggle2,true)
LuaUtils.SetActive(txt_tips_R,not e:GuildIsCanJoin())
LuaUtils.SetActive(txt_tips_L,not e:GuildIsCanJoinForNextSeason())
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

