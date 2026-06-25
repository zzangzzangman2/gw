local e={}
local s=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
t:ReduceFury(i.costMp)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eColumn)
if(a==nil)then
return
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local o=e[1]
local n=false
if(t:CurrHPPer()>e[6]*MillionCoe)then
n=true
local e={
attrId=e[7],
value=e[8],
}
t:AddAttrValueInCurAttack(e)
else
local e={
attrId=e[9],
value=e[10],
}
t:AddAttrValueInCurAttack(e)
end
local s=#a
for s=1,s do
local a=a[s]
local o=o
if(a.profession==e[3]or a.profession==e[4])then
o=o+e[5]
end
if n==false then
a.HeroBattleInfo:DispelGranBuff(true,e[11],nil,nil,t.HeroId)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,o)
end
local e=ModulesInit.BattleBuffMgr.GetBuffScript(302104103)
return e.HandleSkillChangeData(t)
end
return s

