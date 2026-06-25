local n=require("Modules/Battle/BattleUtil")
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
t.AddBuffEnergyStorage(e,a[5])
elseif o.buffTriggerTime==BuffTriggerTime.eachRoundStart then
t.AddBuffElectricalPower(e)
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.AddBuffEnergyStorage(e,s)
local a=e:GetBuffData()
if s<=0 then
return
end
local o=a[6]
local r=a[7]
local i={}
for e=8,11 do
table.insert(i,a[e])
end
local h=0
local n=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if n then
h=n:GetFloors()
end
local i=e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,r,i,s)
local i=0
local o=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if o then
i=o:GetFloors()
end
local o=i-h
a[20]=a[20]+o
t.CheckAddBuffLockHpByEnergyStorage(e)
end
function e.CheckAddBuffLockHpByEnergyStorage(t)
local e=t:GetBuffData()
local a=303111612
local t=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if t then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(a)
local t=a.CheckAddBuffLockHp(t,e[20])
if t then
e[20]=0
end
end
end
function e.AddBuffElectricalPower(e)
local a=e:GetBuffData()
local i=a[12]
local n=a[13]
local o={}
for e=14,19 do
table.insert(o,a[e])
end
table.insert(o,0)
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(i)
if(a)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(i)
e.AddShield(a)
a:SetRound(n)
a:PlayBuffPrefabEffect(EBuffEffectType.custom)
else
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,i,n,o)
end
local a=303111610
local o=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(a)
e.AddBuffElectricalPowerUp(o)
end
local a=303111613
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if(a)then
local a=a:GetBuffData()
t.AddBuffEnergyStorage(e,a[15])
end
end
function e.CheckCondition(e,o,i)
local t=e:GetBuffData()
local t=303111607
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if a then
local a=a:GetFloors()
if a>=o then
if i then
n:ReduceHeroBuffFloor(e.CurrHeroCtrl,t,o)
end
return true
end
end
return false
end
function e.HandleOnDoAction(o,a,e)
local a=0
if e and e.skillData and e.skillData.energyStorageCount then
a=e.skillData.energyStorageCount
end
if t.CheckCondition(o,a,true)==true then
return true
end
return false
end
function e.AddAttackTaskScatteredCuts(e,a,o)
local i=e:GetBuffData()
if t.CheckCondition(e,a,false)==false then
return false
end
local t=e.CurrHeroCtrl.HeroId
local e=31116204
local i={
costMp=false,
buffId=303111606,
triggerSkillAtkType=ETriggerSkillAtkType.PursuitAttack,
energyStorageCount=a,
}
local a=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(e,t)
if a==nil then
n:AddTriggerAttackTask(t,e,i,{triggerSkillAtkType=o})
end
end
function e.AddAttackTaskVetoGun(e,a,o)
local i=e:GetBuffData()
if t.CheckCondition(e,a,false)==false then
return false
end
local t=e.CurrHeroCtrl.HeroId
local e=31116304
local a={
costMp=false,
buffId=303111606,
triggerSkillAtkType=ETriggerSkillAtkType.PursuitAttack,
energyStorageCount=a,
}
local i=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(e,t)
if i==nil then
n:AddTriggerAttackTask(t,e,a,{triggerSkillAtkType=o})
end
end
function e.AddFuryByHorse(a,t,o)
local e=a:GetBuffData()
if e[22]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[22]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[21]=0
end
if e[21]<o then
local o=o-e[21]
t=math.min(o,t)
a.CurrHeroCtrl:AddFuryWithBuff(t)
e[21]=e[21]+t
end
end
return t

