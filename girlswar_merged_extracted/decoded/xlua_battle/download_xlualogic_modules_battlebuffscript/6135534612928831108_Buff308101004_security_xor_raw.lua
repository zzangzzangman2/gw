local i=require("Modules/Battle/BattleUtil")
local o={}
local h=o
function o.GetCanAdd(e,e)
return true
end
function o.OnAdd(e,e)
end
function o.OnRemoveSelf(a,e)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
if e[9]==1 then
local t={
triggerSkillAtkType=ETriggerSkillAtkType.Normal,
}
local e={
triggerSkillAtkType=ETriggerSkillAtkType.PursuitAttack,
isSingle=true,
}
i:AddFightPetAttackTask(a.CurrHeroCtrl,e,t)
end
end
function o.DoAction(t,e,s,n,o,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[1],e[2])
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[3],e[4])
elseif a.buffTriggerTime==BuffTriggerTime.skill3Play
or a.buffTriggerTime==BuffTriggerTime.skill2Play
or a.buffTriggerTime==BuffTriggerTime.skillPlay then
e[10]=nil
elseif a.buffTriggerTime==BuffTriggerTime.afterAttacked then
local a=t.CurrHeroCtrl.HeroId
if a==s.HeroId then
if e[5]==1 and e[10]==nil and i:IsNormalSkillAtkType(o.triggerSkillAtkType)then
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(n,BattleHeroType.fHollow)
local t=t[1]
if t then
local a=o.reduceHpValue
local o=t.HeroId
local t=math.floor(a*e[6]*MillionCoe)
local t={
heroId=o,
damage=t,
}
e[10]=t
end
end
elseif a==n.HeroId then
if e[7]>0 and t:GetFloors()<e[8]then
t:AddFloors(e[7])
end
end
elseif a.buffTriggerTime==BuffTriggerTime.skillPlayEnd
or a.buffTriggerTime==BuffTriggerTime.skill2PlayEnd
or a.buffTriggerTime==BuffTriggerTime.skill3PlayEnd then
if e[5]==1 then
local e=e[10]
if e then
local e=e
local a=i:GetTargetHeroCtrl(e.heroId)
if a then
a:RealHurtWithBuff(e.damage,t)
end
end
end
end
end
function o.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.skill3Play
or e==BuffTriggerTime.skill2Play
or e==BuffTriggerTime.skillPlay
or e==BuffTriggerTime.skillPlayEnd
or e==BuffTriggerTime.skill2PlayEnd
or e==BuffTriggerTime.skill3PlayEnd
or e==BuffTriggerTime.afterAttacked)then
return true
end
return false
end
function o.SetLogicData(e,e)
end
return h

