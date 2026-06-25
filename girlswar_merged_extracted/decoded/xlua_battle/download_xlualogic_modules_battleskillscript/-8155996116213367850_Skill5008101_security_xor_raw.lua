local e={
}
local n=e
function e.DoAction(e,a)
local t=e:JudgeSkillPreView(a)
local i=t[1]
local t=BattleHeroType.eFront
if(RandomMgr:GetBattleRandom()>5000)then
t=BattleHeroType.eBack
end
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,t)
if(t~=nil)then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(t)
local o=#t
for o=1,o do
local t=t[o]
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,a,i)
end
end
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return n 
