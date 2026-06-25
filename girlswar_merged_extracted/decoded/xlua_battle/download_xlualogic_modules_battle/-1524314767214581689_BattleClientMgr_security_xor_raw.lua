local t=require("Modules/Battle/BattleClient/BattleClientField")
local e=Class("BattleClientMgr")
function e:Create(t)
local e=e:New()
e:Init(t)
return e
end
function e:Init(e)
self.battleData=nil
self.mBattleViewData=e
self.mBattleClientField=t:Create(self)
end
function e:SetData(e)
self.battleData=e
end
function e:OnDataRefreshed()
end
function e:Start()
CameraMgr:SetSceneType(CameraMgr.ESceneType.NormalBattle)
RandomMgr:InitSpeed()
self.mBattleClientField:LoadInitRes()
end
function e:GetBattleViewData()
return self.mBattleViewData
end
return e 
