local s=require("Modules/Battle/BattleUtil")
local i=82013391
local e={}
local h=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,e,e,e,e,e)
end
function e.GetCanTrigger(e)
return false
end
function e.SetLogicData(e,e)
end
function e.SyncChaseRoundIfNeeded(e)
local t=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
if e[5]~=t then
e[5]=t
e[4]=0
end
end
function e.AddAttackTask(a,o,h,n)
local t=a:GetBuffData()
e.SyncChaseRoundIfNeeded(t)
local e=t[3]
if e<=0 then
return
end
if t[4]>=e then
return
end
if ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(i,o.HeroId)~=nil then
return
end
local e={
buffId=a.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.PursuitComboAttack,
costMp=false,
targetHeroId=h,
chaseSkillHurtRate=t[2],
hadShieldBeforeMain=n
}
s:AddTriggerAttackTask(o.HeroId,i,e,{
triggerSkillAtkType=ETriggerSkillAtkType.Normal,
})
end
function e.HandleOnDoAction(o,t,a)
local a=a.skillData
local o=a.targetHeroId
local a=a.hadShieldBeforeMain
e.SyncChaseRoundIfNeeded(t)
local e=t[3]
if e<=0 then
return false
end
if t[4]>=e then
return false
end
local e=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(o)
if e==nil or e.HeroBattleInfo==nil or e.HeroBattleInfo.CurrHP<=0 then
return false
end
local o=e.HeroBattleInfo:GetTotalBuffValue(HeroAttrId.shield)
local o=a and o<=0
local a=t[1]
local a=a*MillionCoe
local e=e:CurrHPPer()<=a
if not o and not e then
return false
end
t[4]=t[4]+1
return true
end
return h

