local e={
}
local n=e
function e.DoAction(e,i)
local a=e:JudgeSkillPreView(i)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eOneBack)
if(t==nil)then
return
end
e:ReduceFury(i.costMp)
local o=a[1]
local n={
attrId=a[3],
value=a[4],
}
e:AddAttrValueInCurAttack(n)
if(t.profession==ProfessionType.Warrior)then
o=o+a[5]
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,i,o)
return nil
end
return n 
