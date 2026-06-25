local e=require("Modules/Battle/BattleUtil")
local e={
}
local d=e
function e.DoAction(e,i,t,t)
local t=e:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
e:ReduceFury(i.costMp)
local d=t[1]
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local n=303111610
local o=e.HeroBattleInfo:GetBuff(n)
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
e.DoActionBigSkill(o,a)
end
local n=303111606
local o=e.HeroBattleInfo:GetBuff(n)
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
e.AddBuffEnergyStorage(o,t[3])
end
local r=t[4]
local s=t[5]
local h={t[6],t[7]}
e:AddBuff(e,r,s,h)
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
e.AddAttackTaskVetoGun(o,t[8],i.atkType)
end
local t=#a
for t=1,t do
local a=a[t]
local t=0
local e=ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,i,d,0,t)
end
return nil
end
return d 
