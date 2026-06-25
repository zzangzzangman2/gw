local e=require("Modules/Battle/HeroState/BaseState")
local t={
}
function t:New(t)
self.__index=self
local e=e:New(HeroState.BeAttackState)
e.HeroCtrl=t
e.AnimLen=0
e.EnterTime=0
setmetatable(e,self)
return e
end
function t:OnEnter()
end
function t:OnUpdate()
end
function t:OnLeave()
end
return t 
