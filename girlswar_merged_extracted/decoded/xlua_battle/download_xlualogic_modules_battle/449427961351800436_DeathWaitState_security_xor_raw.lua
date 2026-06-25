local t=require("Modules/Battle/HeroState/BaseState")
local e={}
function e:New(a)
self.__index=self
local e=t:New(HeroState.DeathWait)
e.HeroCtrl=a
e.enterTime=0
setmetatable(e,self)
return e
end
function e:OnEnter()
self.HeroCtrl:ClearHurtQueue()
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
self.enterTime=Time.time
end
self.HeroCtrl.WillNotUsual=false
if(self.HeroCtrl.HeroBattleInfo~=nil)then
self.HeroCtrl.HeroBattleInfo:SetHpEmptyWhenDeath()
end
end
function e:OnUpdate()
end
function e:OnLeave()
end
return e

