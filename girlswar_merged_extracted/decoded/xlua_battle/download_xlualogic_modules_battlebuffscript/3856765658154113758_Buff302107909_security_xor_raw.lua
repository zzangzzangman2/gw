local s=require("Modules/Battle/BattleUtil")
local e={}
local t=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,a,i,i,i,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if o.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,a[1],a[2])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,a[3],a[4])
e.CurrHeroCtrl:SetEnergyConsumeCond(a[7]*MillionCoe)
elseif o.buffTriggerTime==BuffTriggerTime.attacked then
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.ourAll)
local o=#o
local a=o*a[11]
t.AddEnergyByPercent(e,a)
elseif o.buffTriggerTime==BuffTriggerTime.eachRoundStart then
t.GainWindBuff(e,10000)
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.attacked
or e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.SetMaxEnergy(e,t)
local e=e:GetBuffData()
e[18]=t
end
function e.ResetEnergyMaxEnergy(e)
local a=e:GetBuffData()
local a=a[18]
t.AddEnergy(e,a)
end
function e.AddEnergyByPercent(e,o)
local a=e:GetBuffData()
local a=a[18]
t.AddEnergy(e,math.floor(a*o*MillionCoe))
end
function e.AddEnergy(e,n)
local a=e:GetBuffData()
local o=a[18]
local i=e.CurrHeroCtrl.HeroBattleInfo:GetTotalBuffValue(HeroAttrId.energy)
if i>=o then
t.EnergyDamageInFull(e)
else
local t=math.max(0,o-i)
local t=math.min(n,t)
local i=a[5]
local n=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(i)
if n then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(i)
e.AddEnergy(n,t)
else
local i=a[5]
local a=a[6]
local t={t,o}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,i,a,t)
end
end
end
function e.EnergyDamageInExhaust(a)
local e=a:GetBuffData()
if e[20]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[20]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[19]=0
end
local o=e[9]
if(e[19]>=o)then
return nil
end
e[19]=e[19]+1
local e=math.floor(a.CurrHeroCtrl.HeroBattleInfo.MaxHP*e[8]*MillionCoe)
t.TriggerExplodeDamageWithEnergy(a,e)
end
function e.EnergyDamageInFull(a)
local e=a:GetBuffData()
local i=302107921
local o=a.CurrHeroCtrl.HeroBattleInfo:GetBuff(i)
if o then
local i=ModulesInit.BattleBuffMgr.GetBuffScript(i)
local i,o=i.GetEnergyDamageData(o)
if e[22]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[22]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[21]=0
end
if(e[21]>=o)then
return nil
end
e[21]=e[21]+1
local e=math.floor(a.CurrHeroCtrl.HeroBattleInfo.MaxHP*i*MillionCoe)
t.TriggerExplodeDamageWithEnergy(a,e)
end
end
function e.TriggerExplodeDamageWithEnergy(e,a)
local t=e:GetBuffData()
local t=e.CurrHeroCtrl.HeroId
local e=21079399
local a={
triggerSkillAtkType=ETriggerSkillAtkType.FightBack,
realHurt=a
}
local o=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(e,t)
if o==nil then
local o={
triggerSkillAtkType=ETriggerSkillAtkType.Normal
}
s:AddTriggerAttackTask(t,e,a,o)
end
end
function e.GainWindBuff(t,o,a)
local e=t:GetBuffData()
local i=e[12]
local a=a or e[13]
local n={e[14],math.floor(e[15]*o*MillionCoe)}
local o={e[16],math.floor(e[17]*o*MillionCoe)}
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.ourAll)
for s=1,#e do
local e=e[s]
if e:IsRealFirstRowHero()then
e:AddBuff(t.CurrHeroCtrl,i,a,o)
else
e:AddBuff(t.CurrHeroCtrl,i,a,n)
end
end
end
return t

