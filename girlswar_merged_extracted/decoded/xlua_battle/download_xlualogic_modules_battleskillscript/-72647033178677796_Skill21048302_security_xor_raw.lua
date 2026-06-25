local c=require("Modules/Battle/BattleUtil")
local e={
}
local u=e
function e.DoAction(t,n)
local e=t:JudgeSkillPreView(n)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
local a=#a
if(a==e[18])then
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(SkillChangeType.Change,e[19])
end
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eBack)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
t:ReduceFury(n.costMp)
local d=e[6]
local i=e[7]
local h=e[12]
local r=e[10]
local s=302104817
local o=t.HeroBattleInfo:GetBuff(s)
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(s)
e.DoActionBigSkill(o,a)
local e=o:GetBuffData()
d=e[5]
i=e[6]
h=e[7]
r=e[8]
end
local l=e[1]
local s=e[3]
local o=e[4]
local d={e[5],d}
t:AddBuff(t,s,o,d)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAllExcludeSelf)
local o=c:GetHeroWithProfession(o,e[8])
if#o<i then
table.insert(o,t)
end
local o=RandomTableWithSeed(o,i)
for a=1,#o do
local i=o[a]
local o=e[9]
local a=r
local e={e[11],h}
i:AddBuff(t,o,a,e)
end
local i=e[13]
local s=e[14]
local h=e[15]
local o={e[16],e[17]}
local e=#a
for e=1,e do
local e=a[e]
e:CheckAddBuff(i,t,s,h,o)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,n,l)
end
return nil
end
return u 
