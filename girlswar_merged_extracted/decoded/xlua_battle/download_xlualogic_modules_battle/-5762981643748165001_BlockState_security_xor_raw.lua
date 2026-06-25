local e=require("Modules/Battle/HeroState/BaseState")
local t={}
function t:New(t)
self.__index=self
local e=e:New(HeroState.Block)
e.HeroCtrl=t
e.enterTime=0
e.buffEffectId=0
setmetatable(e,self)
return e
end
function t:OnEnter()
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
self.enterTime=Time.time
if(IsNil(self.HeroCtrl.spineboy))then
return
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
end
function t:OnUpdate()
end
function t:OnLeave()
end
return t

