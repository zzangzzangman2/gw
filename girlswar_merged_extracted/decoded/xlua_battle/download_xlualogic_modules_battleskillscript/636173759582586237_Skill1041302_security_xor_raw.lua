local e={}
local n=e
function e.DoAction(e,o)
local t=e:JudgeSkillPreView(o)
e:ReduceFury(o.costMp)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eColumn)
if(a==nil)then
return
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local n=t[1]
local i=t[3]
if(e:CurrHPPer()>t[4]*MillionCoe)then
local t={
attrId=t[5],
value=t[6],
}
e:AddAttrValueInCurAttack(t)
else
local t={
attrId=t[7],
value=t[8],
}
e:AddAttrValueInCurAttack(t)
end
local t=#a
for t=1,t do
local a=a[t]
local t=n
if(a.profession==ProfessionType.Mage)then
t=t+i
end
ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,o,t)
end
return nil
end
return n

