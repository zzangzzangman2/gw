local m=require("Modules/Battle/BattleUtil")
local e={
}
local w=e
function e.DoAction(t,n,e,e)
local e=t:JudgeSkillPreView(n)
local o={}
local i=false
local d=302107419
local a=t.HeroBattleInfo:GetBuff(d)
if a then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(d)
e.DoActionBigSkill(a)
local e=e.CheckConsumeToChangeBigSkill(a)
if e then
i=true
end
end
local h=0
local s=0
local u=0
if i then
o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
local e=a:GetBuffData()
h=e[4]
s=e[4]
else
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(t==nil)then
return nil
end
u=t.HeroId
table.insert(o,t)
local a=e[1]
h=a
s=e[3]
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.fHollow)
for t=1,#e do
table.insert(o,e[t])
end
end
t:ReduceFury(n.costMp)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(o)
local r=e[4]
local c=e[5]
local l={e[6],e[7],e[8],e[9],e[10],e[11]}
t:AddBuff(t,r,c,l)
local r=e[12]
local c=e[13]
local l={e[14],e[15],e[16],e[17]}
t:AddBuff(t,r,c,l)
t:SetMustSmallSkill()
local l=302107409
local r=t.HeroBattleInfo:GetBuff(l)
if r then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(l)
e.DoActionBigSkill(r,t)
end
local c=302107422
local l=t.HeroBattleInfo:GetBuff(c)
local r=0
local f=#o
for i=1,f do
local o=o[i]
local i=0
if o.HeroId==u then
i=h
else
i=s
end
local s={
attrId=e[18],
value=e[19],
}
o:AddAttrValueInCurAttack(s)
if(l)then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(c)
local e=t.AddControl(l,e[20],o)
if e then
r=r+1
end
end
local s=0
if o.HeroBattleInfo:HasControlBuff()then
local t=o.HeroBattleInfo.MaxHP
s=math.floor(t*e[21]*MillionCoe)
end
local e=ModulesInit.ProcedureNormalBattle.SkillHurt(t,o,n,i,nil,s)
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
local e=ModulesInit.BattleBuffMgr.GetBuffScript(d)
e.GainEyeBuff(a,r)
local e=a:GetBuffData()
local e=e[3]
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(nil,nil,nil,nil,EBattleSkillType.SkillBig,nil,nil,nil,e)
end
return nil
end
return w 
