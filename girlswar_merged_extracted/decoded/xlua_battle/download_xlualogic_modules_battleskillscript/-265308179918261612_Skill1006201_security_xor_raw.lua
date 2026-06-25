local e={
}
local n=e
function e.DoAction(e,a)
local t=e:JudgeSkillPreView(a)
local i=t[1]
local o=t[3]
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(t==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,a,i)
t:ReduceFuryWithSkill(o,e,EBattleSrcType.SkillSmall,true)
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return n 
