local u=require("Modules/Battle/BattleUtil")
local e={
}
local c=e
function e.DoAction(t,i,e,a)
local e=t:JudgeSkillPreView(i)
local n=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eOneBack)
if(n==nil)then
return nil
end
local r=e[1]
if a and a.isPursuitAttack then
r=a.skillHurtRate
else
t:ReduceFury(i.costMp)
end
local h=e[3]
local s=e[4]
local o={e[5],e[6]}
t:AddBuff(t,h,s,o)
local o=e[7]
local s=e[8]
local h={e[9],e[10]}
t:AddBuff(t,o,s,h)
local o=e[11]
local h=e[12]
local s={e[13],e[14]}
t:AddBuff(t,o,h,s)
local o=t:GetFinalAtk()
local c=math.floor(o*e[15]*MillionCoe)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(n,BattleHeroType.fHollow)
table.insert(o,n)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(o)
local s=false
local h=0
local l=302108620
local d=t.HeroBattleInfo:GetBuff(l)
if d then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(l)
s,h=e.DoActionBigSkill(d,o)
if a and a.isPursuitAttack then
s=false
h=0
end
end
for a=1,#o do
local o=o[a]
local s
local a
if o.HeroId==n.HeroId then
s=r
a=0
else
s=0
a=c
if ModulesInit.ProcedureNormalBattle.IsPVE()==false or e[17]==1 then
local t=o.HeroBattleInfo:GetMaxHP()
a=a+math.floor(t*e[16]*MillionCoe)
end
end
local n=e[18]
local r=e[19]
local h=e[20]
o:CheckAddBuff(n,t,r,h,0)
local n=0
if o.profession==ProfessionType.Warrior or o.HeroBattleInfo:HasControlBuff()then
local t=t.HeroBattleInfo:GetMaxHP()
n=math.floor(t*e[21]*MillionCoe)
a=a+n
end
local a=ModulesInit.ProcedureNormalBattle.SkillHurt(t,o,i,s,0,a)
local a=a[3]
local a=a.reduceHpValue
local e=e[22]
if e>0 and n>0 then
local a=math.min(a,n)
local e=math.floor(a*e*MillionCoe)
u:AddSepsisHp(t,o,e)
end
end
if s then
local e=i.id
local t={skillHurtRate=h,isPursuitAttack=true}
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(SkillChangeType.Sequence,e,nil,nil,EBattleSkillType.SkillBig,t)
end
return nil
end
return c 
