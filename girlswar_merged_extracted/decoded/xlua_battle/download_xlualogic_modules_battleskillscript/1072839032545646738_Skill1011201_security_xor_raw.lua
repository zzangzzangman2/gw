local e={
}
local s=e
function e.DoAction(e,a)
local t=e:JudgeSkillPreView(a)
local i=t[1]
local n=t[3]
local o=t[4]
local t={t[5],t[6]}
e:AddBuff(e,n,o,t)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eColumn)
if(t~=nil)then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(t)
for o,t in ipairs(t)do
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,a,i)
end
end
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return s 
