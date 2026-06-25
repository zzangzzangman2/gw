local e=require("Modules/Battle/BattleUtil")
local e={
}
local m=e
function e.DoAction(t,o,i,e)
local e=t:JudgeSkillPreView(o)
local n=false
local a=302108111
local s=t.HeroBattleInfo:GetBuff(a)
if s then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(a)
local e=e.IsSuperState(s)
if e then
n=true
end
end
local a=302108106
local r=t.HeroBattleInfo:GetBuff(a)
local d=ModulesInit.BattleBuffMgr.GetBuffScript(a)
local s=302108118
local a=t.HeroBattleInfo:GetBuff(s)
local h=nil
if i then
h=i.triggerSkillAtkType
end
if n==false then
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eColumn)
if(i==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(i)
t:ReduceFury(o.costMp)
if a then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(s)
e.DoActionBigSkill1(a)
end
local u=e[1]
local h=e[3]
local c=e[4]
local s=e[7]
local l=e[8]
local a=#i
for a=1,a do
local a=i[a]
local n={e[5],e[6]}
local i={e[9],e[10]}
if a:IsRealFirstRowHero()then
n={e[5],e[6]*e[11]*MillionCoe}
i={e[9],e[10]*e[11]*MillionCoe}
end
a:AddBuff(t,h,c,n)
a:AddBuff(t,s,l,i)
local e=d.GetRealHurtValue(r,a)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,u,0,e)
end
return nil
else
local n=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(n==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(n)
if h~=ETriggerSkillAtkType.FightBack then
t:ReduceFury(o.costMp)
end
if a then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(s)
e.DoActionBigSkill2(a)
end
local h=e[13]
if i and i.skillHurtRateFinal then
h=h*i.skillHurtRateFinal*MillionCoe
end
local l=e[15]
local c=e[16]
local u={e[17],e[18]}
local i=0
local i=#n
for e=1,i do
local e=n[e]
e:AddBuff(t,l,c,u)
local i=0
if a then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(s)
i=t.GetReduceDefRage(a,e)
end
local n={
reduceDefRage=i,
}
local a=0
local i=d.GetRealHurtValue(r,e)
local a=a+i
local e=ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,o,h,0,a,n)
end
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(nil,nil,nil,nil,EBattleSkillType.SkillBig,nil,nil,nil,e[12])
end
return nil
end
return m 
