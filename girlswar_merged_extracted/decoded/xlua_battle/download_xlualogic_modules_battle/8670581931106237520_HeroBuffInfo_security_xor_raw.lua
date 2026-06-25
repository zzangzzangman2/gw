local e=require("DataNode/DataTable/Create/skillAct/DTBuffDBModel")
local a=require("Modules/Battle/BattleUtil")
local o
if(GameInit.IsClient)then
o=require("Common/cs_coroutine")
else
o=require("Common/cs_coroutine_server")
end
HeroBuffInfo={}
function HeroBuffInfo:New(e)
local e={
CurrHeroCtrl=e,
buffId=0,
releaseHeroId=0,
round=0,
originRound=0,
floors=0,
isExec=false,
buffData=nil,
buffEffectId=0,
hurtValue=0,
hurtType=HeroHurtType.buff,
onRoundChange=nil,
onFloorsChange=nil,
isGran=-1,
atkBuffPairMgrData=nil,
atkBuffPairData=nil,
defBuffPairData=nil,
teamId=0,
battleStationIndex=0,
roundArr={},
isRemoved=false,
isOpenAttrFloor=true,
}
setmetatable(e,self)
self.__index=self
return e
end
function HeroBuffInfo:Dispose()
if self.buffId==nil or self.buffId==0 then
return
end
local e=ModulesInit.BattleBuffMgr.GetBuffScript(self.buffId).Dispose
if(e~=nil)then
e(self)
end
self:RemoveBuffEffect()
self.CurrHeroCtrl=nil
self.buffId=0
self.releaseHeroId=0
self.round=0
self.floors=0
self.isExec=false
self.buffData=nil
self.hurtValue=0
self.hurtType=HeroHurtType.buff
self.onRoundChange=nil
self.onFloorsChange=nil
self.isGran=-1
self.atkBuffPairMgrData=nil
self.atkBuffPairData=nil
self.defBuffPairData=nil
self.teamId=0
self.battleStationIndex=0
self.roundArr={}
self.isOpenAttrFloor=true
end
function HeroBuffInfo:SetAtkBuffPairMgrData(e)
self.atkBuffPairMgrData=e
end
function HeroBuffInfo:GetAtkBuffPairMgrData()
return self.atkBuffPairMgrData
end
function HeroBuffInfo:SetAtkBuffPairData(e)
self.atkBuffPairData=e
end
function HeroBuffInfo:GetAtkBuffPairData()
return self.atkBuffPairData
end
function HeroBuffInfo:SetDefBuffPairData(e)
self.defBuffPairData=e
end
function HeroBuffInfo:GetDefBuffPairData()
return self.defBuffPairData
end
function HeroBuffInfo:GetFloors()
return self.floors
end
function HeroBuffInfo:GetRound()
return self.round
end
function HeroBuffInfo:SetRound(e)
self.round=e
self:HandleRoundChange()
end
function HeroBuffInfo:ResetFloors(e)
if e>self.floors then
local e=e-self.floors
self:AddFloors(e)
elseif e<self.floors then
local e=self.floors-e
self:ReduceFloors(e)
end
end
function HeroBuffInfo:AddFloors(t)
local e=e.GetEntity(self.buffId)
if e==nil then
return
end
local o=self.floors
if(e.canOverlap~=EBuffOverlapType.MultiRoundOverlap)then
self.floors=self.floors+t
if e.layerLimit>=0 then
self.floors=math.min(self.floors,e.layerLimit)
end
else
a:HandleMultiRoundOverlapBuff(self,t,self.originRound,e.layerLimit)
end
if(o==0)then
self:PlayBuffEffect()
else
if(self.CurrHeroCtrl)then
self.CurrHeroCtrl:DoSpecialBuffEffectWithPrefabId(self.buffEffectId,"AddFloors",self.floors-o)
end
end
self:OnOverlap()
if(self.CurrHeroCtrl)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
end
function HeroBuffInfo:ReduceFloors(t)
local e=e.GetEntity(self.buffId)
if e==nil then
return
end
if(e.canOverlap~=EBuffOverlapType.MultiRoundOverlap)then
self.floors=self.floors-t
else
if#self.roundArr>0 then
local e=math.min(#self.roundArr,t)
for e=e,1,-1 do
table.remove(self.roundArr,e)
end
self.floors=#self.roundArr
else
self.floors=0
end
end
self.floors=math.max(self.floors,0)
self:ReduceFloorsWithView(t)
end
function HeroBuffInfo:ReduceFloorsWithView(e)
if(self.floors==0)then
if self.CurrHeroCtrl then
self.CurrHeroCtrl:DoSpecialBuffEffectWithPrefabId(self.buffEffectId,"ReduceFloors",e)
end
self:RemoveBuffEffect()
else
if(self.onFloorsChange)then
self.onFloorsChange()
end
self:NotifyBossUIBuffChange("onFloorsChange")
if self.CurrHeroCtrl then
self.CurrHeroCtrl:DoSpecialBuffEffectWithPrefabId(self.buffEffectId,"ReduceFloors",e)
end
end
if(self.CurrHeroCtrl)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
end
function HeroBuffInfo:AddRound(e)
self.round=self.round+e
self:HandleRoundChange()
end
function HeroBuffInfo:HandleRoundChange()
if(self.CurrHeroCtrl)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
if(self.onFloorsChange)then
self.onFloorsChange()
end
self:NotifyBossUIBuffChange("onFloorsChange")
end
function HeroBuffInfo:AddBuffData(e)
self.buffData=e
end
function HeroBuffInfo:GetBuffData()
return self.buffData
end
function HeroBuffInfo:SetLogicData(e)
ModulesInit.BattleBuffMgr.GetBuffScript(self.buffId).SetLogicData(self,e)
end
function HeroBuffInfo:DoAction(e)
local e={
buffTriggerTime=e
}
local e=self:DoBuffAction(nil,nil,nil,e)
return e
end
function HeroBuffInfo:DoBuffAction(a,t,o,n)
local i=ModulesInit.BattleBuffMgr.GetBuffScript(self.buffId)
local t=i.DoAction(self,self.buffData,a,t,o,n)
if type(t)=="table"and t.ret==true then
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
local e=e.GetEntity(self.buffId)
if e and e.effectType==EBuffEffectType.buffDoActionTrigger then
self:PlayBuffPrefabEffect(EBuffEffectType.buffDoActionTrigger)
end
end
end
return t
end
function HeroBuffInfo:OnAdd()
local e=ModulesInit.BattleBuffMgr.GetBuffScript(self.buffId).OnAdd
if(e)then
e(self,self.buffData)
end
self:ExcuteAddEffect()
end
function HeroBuffInfo:ExcuteAddEffect(t)
self:PlayAnim(t)
if(self.CurrHeroCtrl)then
local e=e.GetEntity(self.buffId)
if e.effectType==EBuffEffectType.damagePointTrigger then
self.CurrHeroCtrl:AddBuffIdEffectOnDamagePoint(self.buffId)
end
if(self.CurrHeroCtrl.HeroHeadItem~=nil)then
if(e.controlText~="")then
self.CurrHeroCtrl.HeroHeadItem:ShowBeControlText(e.controlText)
end
end
end
end
function HeroBuffInfo:PlayAnim(t)
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
if(self.CurrHeroCtrl)then
if(IsNil(self.CurrHeroCtrl.spineboy))then
return
end
local e=e.GetEntity(self.buffId)
if(e and e.controlPose~="")then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
self.CurrHeroCtrl:CheckAndSetSpineAnim(0,e.controlPose,true,nil,t)
end
end
end
end
function HeroBuffInfo:OnRemoveSelf(a)
local t=ModulesInit.BattleBuffMgr.GetBuffScript(self.buffId).OnRemoveSelf
if(t)then
t(self,self.buffData,a)
end
if(self.CurrHeroCtrl)then
local e=e.GetEntity(self.buffId)
if e.effectType==EBuffEffectType.damagePointTrigger then
self.CurrHeroCtrl:RemoveBuffIdEffectOnDamagePoint(self.buffId)
end
if(self.CurrHeroCtrl.HeroHeadItem~=nil)then
if(e.controlText~="")then
self.CurrHeroCtrl.HeroHeadItem:HideBeControlText()
end
end
end
end
function HeroBuffInfo:OnOverlap()
local e=ModulesInit.BattleBuffMgr.GetBuffScript(self.buffId).OnOverlap
if(e)then
e(self,self.buffData)
end
if(self.onFloorsChange)then
self.onFloorsChange()
end
self:NotifyBossUIBuffChange("onFloorsChange")
end
function HeroBuffInfo:CheckPlayBuffEffect()
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==true)then
return
end
if(not self.CurrHeroCtrl)then
return
end
if(self.buffEffectId==0)then
local e=e.GetEntity(self.buffId)
if(e.isAnimation==0)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
self:PlayBuffEffect()
else
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
self.CurrHeroCtrl.HeroBattleInfo:AddBattleEffectWithBuff(self,ModulesInit.ProcedureNormalBattle.CurrBattleBigRound)
end
end
end
function HeroBuffInfo:PlayBuffEffect()
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==true)then
return
end
if(self.buffEffectId>0)then
return
end
if(self.buffId<1)then
return
end
if(not self.CurrHeroCtrl)then
return
end
self:NotifyBossUIBuffChange("addBuff")
local e=e.GetEntity(self.buffId)
self:PlayBuffPrefabEffect()
if self.CurrHeroCtrl.CurrHeadBarView then
if(e.buffIcon~="")then
self.CurrHeroCtrl.CurrHeadBarView:AddSkillBuff(self.buffId,self,e.settleAction)
end
end
for t,e in ipairs(e.battleWord)do
if(#e==2)then
self.CurrHeroCtrl:ShowHudText(tonumber(e[1]),e[2])
end
end
local e=ModulesInit.BattleBuffMgr.GetBuffScript(self.buffId).OnBuffEffect
if(e)then
e(self,self.buffData)
end
end
function HeroBuffInfo:PlayBuffPrefabEffect(t)
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==true)then
return
end
local e=e.GetEntity(self.buffId)
if e.effectType<=EBuffEffectType.threeD or e.effectType==t then
local t=a:GetBuffPrefabIdByReleaseHeroId(e,self.releaseHeroId)
if(t>0)then
if self.CurrHeroCtrl then
local t=e.effectType==EBuffEffectType.threeD and SysPrefabId.BuffEffectSurroundShield or t
self.buffEffectId=t
self.CurrHeroCtrl:CheckAddBuffEffect(self.buffId,t,e,function()
if self.CurrHeroCtrl and e.effectType==EBuffEffectType.threeD then
self.CurrHeroCtrl:DoSpecialBuffEffectWithPrefabId(self.buffEffectId,"InitBuffData",{t,self.floors})
end
end)
end
end
end
end
function HeroBuffInfo:HeroPoseTypeChange(t)
if(not self.CurrHeroCtrl)then
return
end
o.start(
function()
coroutine.yield(CS.UnityEngine.WaitForSeconds(0.5))
local t=e.GetEntity(self.buffId)
if(t)then
if(t.buffPosition==1)then
local e=self.CurrHeroCtrl:GetHearBarFollowPos()
local a=self.CurrHeroCtrl:GetBuffEffectData(self.buffEffectId)
if(a and not IsNil(a.buffEffectTrans))then
e=e+Vector3(t.buffOffsetX,t.buffOffsetY,0)
e=self.CurrHeroCtrl.CurrSkinTransform:InverseTransformPoint(e)
e.z=e.z*ModulesInit.ProcedureNormalBattle.mirrorScaleX
LuaUtils.DoTweenLocalPosMove(a.buffEffectTrans,e.x,e.y,e.z,0.2)
end
end
end
end
)
end
function HeroBuffInfo:OnRoundChange()
if(self.onRoundChange)then
self.onRoundChange()
end
self:NotifyBossUIBuffChange("onRoundChange")
end
function HeroBuffInfo:GetCanTrigger(e)
return ModulesInit.BattleBuffMgr.GetBuffScript(self.buffId).GetCanTrigger(e)
end
function HeroBuffInfo:NotifyBossUIBuffChange(e)
if self.CurrHeroCtrl then
if(self.CurrHeroCtrl.IsOurHero==false and self.CurrHeroCtrl:GetHeroId()==ModulesInit.ProcedureNormalBattle.BossHeroId)then
EventSystem.SendEvent(CommonEventId.OnEventBossBuffTip,{changeType=e,buffId=self.buffId,round=self.round,floors=self.floors})
end
end
end
function HeroBuffInfo:RemoveBuffEffect()
if(self.CurrHeroCtrl)then
if self.CurrHeroCtrl.CurrHeadBarView then
self.CurrHeroCtrl.CurrHeadBarView:RemoveSkillBuff(self.buffId,self.CurrHeroCtrl.HeroId)
end
end
self:NotifyBossUIBuffChange("removeBuff")
if(self.buffEffectId>0)then
if self.CurrHeroCtrl then
self.CurrHeroCtrl:RemoveBuffEffectByBuffId(self.buffId,self.buffEffectId)
end
self.buffEffectId=0
end
end
function HeroBuffInfo:ShowOrHideBuffEffect(a,t)
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==true)then
return
end
if(not self.CurrHeroCtrl)then
return
end
if(self.CurrHeroCtrl.isHideHero)then
return
end
if t then
local e=e.GetEntity(self.buffId)
if e.buffPosition<100 then
return
end
end
local e=self.CurrHeroCtrl:GetBuffEffectData(self.buffEffectId)
if e then
if(not IsNil(e.buffEffectTrans))then
LuaUtils.SetActive(e.buffEffectTrans,a)
else
e.buffEffectTrans=nil
end
end
end
function HeroBuffInfo:GetPrefabIdInCfg()
local e=e.GetEntity(self.buffId)
local t=a:GetBuffPrefabIdByReleaseHeroId(e,self.releaseHeroId)
return t,e.mirror
end

