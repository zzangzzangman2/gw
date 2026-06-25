local a=require("Modules/Battle/BattleUtil")
local e={
}
local s=e
function e.DoAction(t,o,e)
local i=t:JudgeSkillPreView(o)
local e=e.cfgArgs
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
local a=a:GetMinHpPercentHeroArr(i,e[1])
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local i=e[2]
local n={
attrId=e[3],
value=e[4],
}
t:AddAttrValueInCurAttack(n)
local e={
attrId=e[5],
value=e[6],
}
t:AddAttrValueInCurAttack(e)
local e=#a
for e=1,e do
local e=a[e]
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,o,i)
end
return nil
end
return s 
