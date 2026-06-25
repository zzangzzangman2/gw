local t=require("Modules/Battle/BattleClient/BattleClientMgr")
local i=require("Modules/Battle/BattleServer/BattleServer")
local e=require("Modules/Battle/BattleData")
local o=require("Modules/Battle/BattleInputMgr")
local a=require("Modules/Battle/BattleInput")
local a=require("Modules/Battle/HeroInputRange")
local h=1
local r=2
local s=3
local a=Class("BattleManager")
function a:__init(n,d,a)
self.managerType=n
self.client=nil
self.server=nil
self.battleData=nil
self.inputMgr=nil
if self.managerType==h then
self.client=t:Create(a)
self.server=i.New()
self.battleData=e.New()
self.inputMgr=o.New()
self.server:SetData(self.battleData)
self.inputMgr:SetServer(self.server)
self.client:SetData(self.battleData)
self.battleData:SetRefreshedCallback(self.client.OnDataRefreshed)
self.server:Start()
self.client:Start()
elseif self.managerType==r then
self.client=t:Create(a)
self.battleData=e.New()
self.client:SetData(self.battleData)
self.client:Start()
elseif self.managerType==s then
self.server=i.New()
self.battleData=e.New()
self.inputMgr=o.New()
self.server:SetData(self.battleData)
self.inputMgr:SetServer(self.server)
self.inputMgr:SetAuto(true)
self.server:Start()
end
end
return a 
