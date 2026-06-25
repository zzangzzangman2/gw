local e=require("Modules/Battle/HeroState/BaseState")
local t={}
function t:New(t)
self.__index=self
local e=e:New(HeroState.Idle)
e.HeroCtrl=t
setmetatable(e,self)
return e
end
function t:OnEnter()
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then


end
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
if(IsNil(self.HeroCtrl.spineboy))then
return
end
local e=self.HeroCtrl.CurrFsm.ParamDic["changeToIdleType"]
if(e==ChangeToIdleType.NormalIdle)then
if(self.HeroCtrl.HeroPoseType==HeroPoseType.stand and not ModulesInit.ProcedureNormalBattle.IsBattleTest)then
return
end
self.HeroCtrl:SetSpineAnimation(0,"stand",true)
self.HeroCtrl:SetHeroPoseType(HeroPoseType.stand)
self.HeroCtrl.HeroBattleInfo:HeroPoseTypeChange(self.HeroCtrl.HeroPoseType)
elseif(e==ChangeToIdleType.AppearIdle)then
if(self.HeroCtrl.HeroPoseType==HeroPoseType.stand and not ModulesInit.ProcedureNormalBattle.IsBattleTest)then
return
end
self.HeroCtrl:SetSpineAnimation(0,"appear",false)
self.HeroCtrl:AddSpineAnimation(0,"stand",true,0)
self.HeroCtrl:SetHeroPoseType(HeroPoseType.stand)
self.HeroCtrl.HeroBattleInfo:HeroPoseTypeChange(self.HeroCtrl.HeroPoseType)
elseif(e==ChangeToIdleType.ChangeToFightIdle)then
if(self.HeroCtrl.HeroPoseType==HeroPoseType.fight and not ModulesInit.ProcedureNormalBattle.IsBattleTest)then
return
end
self.HeroCtrl:SetSpineAnimation(0,"change",false)
self.HeroCtrl:AddSpineAnimation(0,"fight",true,0)
self.HeroCtrl:SetHeroPoseType(HeroPoseType.fight)
self.HeroCtrl.HeroBattleInfo:HeroPoseTypeChange(self.HeroCtrl.HeroPoseType)
elseif(e==ChangeToIdleType.FightIdle)then
if(self.HeroCtrl.HeroPoseType==HeroPoseType.fight and not ModulesInit.ProcedureNormalBattle.IsBattleTest)then
return
end
self.HeroCtrl:SetSpineAnimation(0,"stand",false)
self.HeroCtrl:AddSpineAnimation(0,"change",false,0)
self.HeroCtrl:AddSpineAnimation(0,"fight",true,0)
self.HeroCtrl:SetHeroPoseType(HeroPoseType.fight)
self.HeroCtrl.HeroBattleInfo:HeroPoseTypeChange(self.HeroCtrl.HeroPoseType)
elseif(e==ChangeToIdleType.FreezeIdle)then
if(self.HeroCtrl.HeroPoseType==HeroPoseType.freezeIdle and not ModulesInit.ProcedureNormalBattle.IsBattleTest)then
return
end
self.HeroCtrle:SetSpineAnimation(0,"stand",false)
self.HeroCtrl:SetHeroPoseType(HeroPoseType.freezeIdle)
self.HeroCtrl.HeroBattleInfo:HeroPoseTypeChange(self.HeroCtrl.HeroPoseType)
elseif(e==ChangeToIdleType.EmptyAnim)then
end
end
end
function t:OnUpdate()
end
function t:OnLeave(e)
if(e~=HeroState.Idle)then
self.HeroCtrl:SetHeroPoseType(HeroPoseType.none)
end
end
return t

