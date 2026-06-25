local e={}
local i=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eColumn)
if(a==nil)then
return
end
local i=#a
if(i==1)then
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(SkillChangeType.Change,e[9])
end
t:ReduceFury(o.costMp)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local n=e[1]
local i=e[3]
if(t:CurrHPPer()>e[4]*MillionCoe)then
local e={
attrId=e[5],
value=e[6],
}
t:AddAttrValueInCurAttack(e)
else
local e={
attrId=e[7],
value=e[8],
}
t:AddAttrValueInCurAttack(e)
end
local e=#a
for e=1,e do
local a=a[e]
local e=n
if(a.profession==ProfessionType.Mage)then
e=e+i
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,e)
end
return nil
end
return i

