local e={
}
local i=e
function e.DoAction(e,o)
local t=e:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(a==nil)then
return nil
end
local i=t[1]
local t={
attrId=t[3],
value=t[4],
}
e:AddAttrValueInBattle(t)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,o,i)
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return i 
