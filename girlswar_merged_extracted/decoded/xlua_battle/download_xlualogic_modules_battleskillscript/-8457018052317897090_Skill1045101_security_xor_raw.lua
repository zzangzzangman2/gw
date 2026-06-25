local e={
}
local n=e
function e.DoAction(e,i)
local t=e:JudgeSkillPreView(i)
local o=t[1]
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(t==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
local a=ModulesInit.BattleBuffMgr.GetBuffScript(30104505)
if a then
local i=a.GeHurtAddRate(e,t)
o=o+i
a.AddBoneCrashBuff(e,t)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,i,o)
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return n 
