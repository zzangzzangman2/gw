local t=require("Modules/Battle/HeroState/BaseState")
local e={}
function e:New(a)
self.__index=self
local e=t:New(HeroState.Defense)
e.HeroCtrl=a
e.enterTime=0
setmetatable(e,self)
return e
end
function e:OnEnter()
self.HeroCtrl:SetHeroPoseType(HeroPoseType.defense)
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
self.enterTime=Time.time
if(IsNil(self.HeroCtrl.spineboy))then
return
end
self.HeroCtrl:SetSpineAnimation(0,"change2",false)
self.HeroCtrl:AddSpineAnimation(0,"defence",true,0)
self.HeroCtrl.HeroBattleInfo:HeroPoseTypeChange(self.HeroCtrl.HeroPoseType)
end
end
function e:OnUpdate()
end
function e:OnLeave()
self.HeroCtrl:SetHeroPoseType(HeroPoseType.none)
end
return e

