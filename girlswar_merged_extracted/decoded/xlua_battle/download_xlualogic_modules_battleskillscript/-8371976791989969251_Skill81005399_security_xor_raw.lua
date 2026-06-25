local e={
}
local n=e
function e.DoAction(n,i,e)
local t=ModulesInit.ProcedureNormalBattle:GetTeamSkillArgs(i)
local t=0
local o={}
local t=e.defHeroDatas
local e={}
if#t>0 then
for a=1,#t do
local t=t[a]
local a=t.heroId
o[a]=t.realhurt
local t=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(a)
if ModulesInit.ProcedureNormalBattle.CheckTargetCondition(t)then
table.insert(e,t)
end
end
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(e)
local t=#e
for t=1,t do
local e=e[t]
local t=o[e.HeroId]
ModulesInit.ProcedureNormalBattle.SkillHurtWithTeam(n,e,i,0,0,t)
end
return nil
end
return n 
