local e=require("Modules/Battle/Formula")
local e={
}
local u=e
function e.DoAction(t,n,e,e)
local e=t:JudgeSkillPreView(n)
local a=nil
if a==nil then
a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
end
if(a==nil)then
return nil
end
t:ReduceFury(n.costMp)
local l=e[1]
local i=e[3]
local o=e[4]
local s={e[5],e[6]}
t:AddBuff(t,i,o,s)
local o=e[7]
local s=e[8]
local i={e[9],e[10]}
t:AddBuff(t,o,s,i)
local h=e[11]
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.fHollow)
table.insert(o,a)
local i=false
local r=302108915
local s=t.HeroBattleInfo:GetBuff(r)
if s then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(r)
i=e.DoActionBigSkill(s,o)
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(o)
local s=math.floor(t:GetFinalDef()*e[12]*MillionCoe)
local s={
attrId=HeroAttrId.atkAdd,
value=s,
}
t:AddAttrValueInCurAttack(s)
local d=e[13]
local s=e[14]
local r={e[15],e[16],e[30]}
t:AddBuff(t,d,s,r)
for e=1,#o do
local e=o[e]
local o=h
if e.HeroId==a.HeroId then
o=l
else
o=h
end
local a
if i==true then
a={
openAddFury=false,
}
e:SetDisableDefRage(true)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,n,o)
if i==true then
e:SetDisableDefRage(false)
end
end
local a=302108905
local t=t.HeroBattleInfo:GetBuff(a)
if t then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(a)
if a.CheckJinFull(t)then
a.ConsumeAllJin(t)
local i=e[17]
local o={}
for t=18,29 do
table.insert(o,e[t])
end
a.AddPursuitAttack(t,i,o)
end
end
return nil
end
return u 
