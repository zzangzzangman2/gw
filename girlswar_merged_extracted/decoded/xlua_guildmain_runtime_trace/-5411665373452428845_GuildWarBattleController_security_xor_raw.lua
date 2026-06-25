local e=5
local e=30
local e={
CSGuildWarManager=nil,
CurBattleInfo=nil,
mainLoopTimer=nil,
syncTimeLag=0
}
function e:Init()
self.CSGuildWarManager=ModulesInit.CSGuildWarManager
EventSystem.AddListener(CommonEventId.GuildWarBattleInfoSync,self.OnGuildWarBattleInfoSync,self)
end
function e:Start()
self:OnGuildWarBattleInfoSync()
if self.mainLoopTimer then
self.mainLoopTimer:Stop()
self.mainLoopTimer=nil
end
self.mainLoopTimer=ModulesInit.TimeActionMgr:CreateTimeAction()
self.mainLoopTimer:Init(
0,
1,
-1,
nil,
function()
self:MainLoop()
end,
nil
):Run()
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildWarBattleGround)
end
function e:OnGuildWarBattleInfoSync()
self.CurBattleInfo=self.CSGuildWarManager.CurBattleInfo
end
function e:MainLoop()
end
function e:Update()
end
function e:OnGuildWarStageSync()
end
function e:Stop()
if self.mainLoopTimer then
self.mainLoopTimer:Stop()
self.mainLoopTimer=nil
end
self.CSGuildWarManager=nil
self.CurBattleInfo=nil
self.mainLoopTimer=nil
self.syncTimeLag=0
EventSystem.RemoveListener(CommonEventId.GuildWarBattleInfoSync,self.OnGuildWarBattleInfoSync,self)
end
function e:Close()
GameTools.CloseUIForm(UIFormId.UI_GuildWarBattleGround)
self:Stop()
end
return e

