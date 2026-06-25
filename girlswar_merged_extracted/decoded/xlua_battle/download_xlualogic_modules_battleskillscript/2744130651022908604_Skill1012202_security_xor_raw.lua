local e={
}
local i=e
function e.DoAction(e,a)
local t=e:JudgeSkillPreView(a)
local n=t[1]
local o=t[3]
e:AddFuryWithSkill(o)
local i=t[4]
local o=t[5]
local t={t[6],t[7]}
e:AddBuff(e,i,o,t)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(t==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,a,n)
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return i 
