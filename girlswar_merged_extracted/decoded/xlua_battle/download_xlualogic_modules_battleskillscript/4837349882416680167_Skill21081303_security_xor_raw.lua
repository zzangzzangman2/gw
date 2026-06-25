local y=require("Modules/Battle/BattleUtil")
local e={
}
local u=e
function e.DoAction(t,i,a,e)
local e=t:JudgeSkillPreView(i)
local s=false
local n=302108111
local o=t.HeroBattleInfo:GetBuff(n)
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
local e=e.IsSuperState(o)
if e then
s=true
end
end
local o=302108106
local d=t.HeroBattleInfo:GetBuff(o)
local l=ModulesInit.BattleBuffMgr.GetBuffScript(o)
local n=302108118
local o=t.HeroBattleInfo:GetBuff(n)
local h=nil
if a then
h=a.triggerSkillAtkType
end
if s==false then
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eColumn)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
t:ReduceFury(i.costMp)
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
e.DoActionBigSkill1(o)
end
local s=e[1]
local u=e[3]
local c=e[4]
local r=e[7]
local h=e[8]
local o=#a
for o=1,o do
local a=a[o]
local o={e[5],e[6]}
local n={e[9],e[10]}
if a:IsRealFirstRowHero()then
o={e[5],e[6]*e[11]*MillionCoe}
n={e[9],e[10]*e[11]*MillionCoe}
end
a:AddBuff(t,u,c,o)
a:AddBuff(t,r,h,n)
local e=l.GetRealHurtValue(d,a)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,s,0,e)
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
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
e.DoActionBigSkill2(o)
end
local h=e[13]
if a and a.skillHurtRateFinal then
h=h*a.skillHurtRateFinal*MillionCoe
end
local w=e[15]
local f=e[16]
local m={e[17],e[18]}
local c={
attrId=e[19],
value=e[20],
}
local a=t:GetFinalAtk()
local u=a*e[21]*MillionCoe
local r=0
local a=#s
for a=1,a do
local a=s[a]
a:AddBuff(t,w,f,m)
a:AddAttrValueInCurAttack(c)
local s=0
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
s=e.GetReduceDefRage(o,a)
end
local n={
ignoreThorn=true,
reduceDefRage=s,
}
local o=0
if a:IsRealFirstRowHero()then
o=u
local t=a.HeroBattleInfo:GetTotalBuffValue(HeroAttrId.shield)
if t>0 then
o=o*e[22]*MillionCoe
end
end
local e=l.GetRealHurtValue(d,a)
local e=o+e
local e=ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,h,0,e,n)
local e=e[3]
local e=e.reduceHpValue
r=r+e
end
local o=r*e[23]*MillionCoe
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.selfColumn)
if(a)then
for n=1,#a do
local n=a[n]
local a=n.HeroBattleInfo.MaxHP
local s=math.max(o,a*e[24]*MillionCoe)
s=math.min(o,a*e[25]*MillionCoe)
y:HpHealthWithBigSkillAndParam(t,i.skilltype,s,1,nil,nil,n)
end
end
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(nil,nil,nil,nil,EBattleSkillType.SkillBig,nil,nil,nil,e[12])
end
return nil
end
return u 
