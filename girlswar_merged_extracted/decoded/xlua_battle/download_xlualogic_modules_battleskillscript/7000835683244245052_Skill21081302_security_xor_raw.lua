local e=require("Modules/Battle/BattleUtil")
local e={
}
local f=e
function e.DoAction(t,i,o,e)
local e=t:JudgeSkillPreView(i)
local s=false
local n=302108111
local a=t.HeroBattleInfo:GetBuff(n)
if a then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
local e=e.IsSuperState(a)
if e then
s=true
end
end
local a=302108106
local d=t.HeroBattleInfo:GetBuff(a)
local r=ModulesInit.BattleBuffMgr.GetBuffScript(a)
local n=302108118
local a=t.HeroBattleInfo:GetBuff(n)
local h=nil
if o then
h=o.triggerSkillAtkType
end
if s==false then
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eColumn)
if(o==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(o)
t:ReduceFury(i.costMp)
if a then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
e.DoActionBigSkill1(a)
end
local u=e[1]
local h=e[3]
local c=e[4]
local s=e[7]
local l=e[8]
local a=#o
for a=1,a do
local a=o[a]
local n={e[5],e[6]}
local o={e[9],e[10]}
if a:IsRealFirstRowHero()then
n={e[5],e[6]*e[11]*MillionCoe}
o={e[9],e[10]*e[11]*MillionCoe}
end
a:AddBuff(t,h,c,n)
a:AddBuff(t,s,l,o)
local e=r.GetRealHurtValue(d,a)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,u,0,e)
end
return nil
else
local s=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(s==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(s)
if h~=ETriggerSkillAtkType.FightBack then
t:ReduceFury(i.costMp)
end
if a then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
e.DoActionBigSkill2(a)
end
local h=e[13]
if o and o.skillHurtRateFinal then
h=h*o.skillHurtRateFinal*MillionCoe
end
local o=e[15]
local u=e[16]
local l={e[17],e[18]}
local m={
attrId=e[19],
value=e[20],
}
local c=0
local c=#s
for e=1,c do
local e=s[e]
e:AddBuff(t,o,u,l)
e:AddAttrValueInCurAttack(m)
local o=0
if a then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(n)
o=t.GetReduceDefRage(a,e)
end
local n={
ignoreThorn=true,
reduceDefRage=o,
}
local a=0
local o=r.GetRealHurtValue(d,e)
local a=a+o
local e=ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,i,h,0,a,n)
end
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(nil,nil,nil,nil,EBattleSkillType.SkillBig,nil,nil,nil,e[12])
end
return nil
end
return f 
