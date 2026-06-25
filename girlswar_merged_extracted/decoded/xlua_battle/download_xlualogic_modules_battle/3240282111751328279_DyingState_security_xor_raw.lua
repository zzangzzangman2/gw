local t=require("Modules/Battle/HeroState/BaseState")
local e={}
function e:New(a)
self.__index=self
local e=t:New(HeroState.DyingState)
e.HeroCtrl=a
e.enterTime=0
setmetatable(e,self)
return e
end
function e:OnEnter()
self.HeroCtrl:ClearHurtQueue()
ModulesInit.ProcedureNormalBattle.CurrAttackCauseHeroDie=true
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
self.enterTime=Time.time
end
if(self.HeroCtrl.HeroBattleInfo~=nil)then
self.HeroCtrl.HeroBattleInfo:ClearAllBuffWhenDying()
end
end
function e:OnUpdate()
end
function e:OnLeave()
end
return e

