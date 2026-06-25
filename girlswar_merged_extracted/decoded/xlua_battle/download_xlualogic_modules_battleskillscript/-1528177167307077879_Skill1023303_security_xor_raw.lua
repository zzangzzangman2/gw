local e={
}
local n=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eOneBack)
if(o==nil)then
return
end
t:ReduceFury(i.costMp)
local a=e[1]
local n={
attrId=e[3],
value=e[4],
}
t:AddAttrValueInCurAttack(n)
if(o.profession==ProfessionType.Warrior)then
a=a+e[5]
local e={
attrId=e[6],
value=e[7],
}
t:AddAttrValueInCurAttack(e)
end
local n=t:CurrHPPer()
a=a+e[8]*math.max(0,1-n)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(o)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,o,i,a)
return nil
end
return n 
