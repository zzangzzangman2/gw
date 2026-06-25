local m=require("Modules/Battle/BattleUtil")
local e={
}
local w=e
function e.DoAction(t,s,e,e)
local e=t:JudgeSkillPreView(s)
local o={}
local i=false
local n=302107419
local a=t.HeroBattleInfo:GetBuff(n)
if a then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
e.DoActionBigSkill(a)
local e=e.CheckConsumeToChangeBigSkill(a)
if e then
i=true
end
end
local r=0
local h=0
local l=0
if i then
o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
local e=a:GetBuffData()
r=e[4]
h=e[4]
else
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(t==nil)then
return nil
end
l=t.HeroId
table.insert(o,t)
local a=e[1]
r=a
h=e[3]
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.fHollow)
for t=1,#e do
table.insert(o,e[t])
end
end
t:ReduceFury(s.costMp)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(o)
local d=e[4]
local c=e[5]
local u={e[6],e[7],e[8],e[9],e[10],e[11]}
t:AddBuff(t,d,c,u)
local d=e[12]
local c=e[13]
local u={e[14],e[15],e[16],e[17]}
t:AddBuff(t,d,c,u)
t:SetMustSmallSkill()
local d=302107409
local u=t.HeroBattleInfo:GetBuff(d)
if u then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(d)
e.DoActionBigSkill(u,t)
end
local c=302107422
local u=t.HeroBattleInfo:GetBuff(c)
local d=0
local f=#o
for i=1,f do
local o=o[i]
local i=0
if o.HeroId==l then
i=r
else
i=h
end
local n={
attrId=e[18],
value=e[19],
}
o:AddAttrValueInCurAttack(n)
if(u)then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(c)
local e=t.AddControl(u,e[20],o)
if e then
d=d+1
end
end
local e=0
local e=ModulesInit.ProcedureNormalBattle.SkillHurt(t,o,s,i,nil,e)
if a then
local e=e[3]
local i=e.reduceHpValue
local e=a:GetBuffData()
local e=e[13]
local e=math.floor(i*e*MillionCoe)
m:AddSepsisHp(t,o,e)
end
end
if i then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
e.GainEyeBuff(a,d)
local e=a:GetBuffData()
local e=e[3]
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(nil,nil,nil,nil,EBattleSkillType.SkillBig,nil,nil,nil,e)
end
return nil
end
return w 
