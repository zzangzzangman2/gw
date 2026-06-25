local c=require("Modules/Battle/BattleUtil")
local e={
}
local m=e
function e.DoAction(t,r,e,e)
local e=t:JudgeSkillPreView(r)
local o={}
local s=false
local i=302107419
local a=t.HeroBattleInfo:GetBuff(i)
if a then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(i)
e.DoActionBigSkill(a)
local e=e.CheckConsumeToChangeBigSkill(a)
if e then
s=true
end
end
local n=0
local h=0
local d=0
if s then
o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
local e=a:GetBuffData()
n=e[4]
h=e[4]
else
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(t==nil)then
return nil
end
d=t.HeroId
table.insert(o,t)
local a=e[1]
n=a
h=e[3]
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.fHollow)
for t=1,#e do
table.insert(o,e[t])
end
end
t:ReduceFury(r.costMp)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(o)
local m=e[4]
local u=e[5]
local l={e[6],e[7],e[8],e[9],e[10],e[11]}
t:AddBuff(t,m,u,l)
local m=e[12]
local u=e[13]
local l={e[14],e[15],e[16],e[17]}
t:AddBuff(t,m,u,l)
t:SetMustSmallSkill()
local u=302107409
local l=t.HeroBattleInfo:GetBuff(u)
if l then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(u)
e.DoActionBigSkill(l,t)
end
local l=302107422
local l=t.HeroBattleInfo:GetBuff(l)
local u=0
local l=#o
for i=1,l do
local o=o[i]
local i=0
if o.HeroId==d then
i=n
else
i=h
end
local e={
attrId=e[18],
value=e[19],
}
o:AddAttrValueInCurAttack(e)
local e=0
local e=ModulesInit.ProcedureNormalBattle.SkillHurt(t,o,r,i,nil,e)
if a then
local e=e[3]
local e=e.reduceHpValue
local a=a:GetBuffData()
local a=a[13]
local e=math.floor(e*a*MillionCoe)
c:AddSepsisHp(t,o,e)
end
end
if s then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(i)
e.GainEyeBuff(a,u)
local e=a:GetBuffData()
local e=e[3]
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(nil,nil,nil,nil,EBattleSkillType.SkillBig,nil,nil,nil,e)
end
return nil
end
return m 
