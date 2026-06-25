local e={
}
local s=e
function e.DoAction(e,a)
local t=e:JudgeSkillPreView(a)
local o=t[1]
local s=t[3]
local n=t[4]
local i={t[5]}
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(t==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
t:AddBuff(e,s,n,i)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,a,o)
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return s 
