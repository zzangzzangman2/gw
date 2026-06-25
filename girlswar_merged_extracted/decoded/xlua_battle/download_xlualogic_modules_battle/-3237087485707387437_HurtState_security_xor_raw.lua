local t=require("Modules/Battle/HeroState/BaseState")
local e={}
function e:New(a)
self.__index=self
local e=t:New(HeroState.Hurt)
e.HeroCtrl=a
e.enterTime=0
setmetatable(e,self)
return e
end
function e:OnEnter()
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
self.enterTime=Time.time
if(IsNil(self.HeroCtrl.spineboy))then
return
end
self.HeroCtrl:SetSpineAnimation(0,"strike",false)
end
end
function e:OnUpdate()
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
local e=self.HeroCtrl.AnimLenDic["strike"]or 0
if(Time.time>self.enterTime+e)then
self.HeroCtrl:ChangeState(HeroState.Idle)
end
else
self.HeroCtrl:ChangeState(HeroState.Idle)
end
end
function e:OnLeave()
end
return e

