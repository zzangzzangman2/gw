function OnInit(e,e)
Image.onClick:AddListener(function()
GameTools.CloseUIForm(UIFormId.UI_GuildJoinEntranceView)
end)
btn_chuangjian.onClick:AddListener(function()
local e=ModulesInit.GuildMgr:ReqCreateGuildConsume()
e.onCompleted=function(t,e)
GameTools.CloseUIForm(UIFormId.UI_GuildJoinEntranceView)
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildCreateView,{consumeCount=e.consumeCount})
end
end)
btn_jiaru.onClick:AddListener(function()
GameTools.CloseUIForm(UIFormId.UI_GuildJoinEntranceView)
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildJoinListNewView)
end)
end
function OnOpen(e)
EventSystem.AddListener(CommonEventId.GuildCloseEntrance,onEventGuildCloseEntrance)
end
function OnClose()
EventSystem.RemoveListener(CommonEventId.GuildCloseEntrance,onEventGuildCloseEntrance)
end
function OnBeforeDestroy()
end
function refresh()
end
function onEventGuildCloseEntrance()
GameTools.CloseUIForm(UIFormId.UI_GuildJoinEntranceView)
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

