local e=require("Modules/Battle/BattleUtil")
local e={
}
local n=e
function e.DoAction(i,o,t)
local e=ModulesInit.ProcedureNormalBattle:GetTeamSkillArgs(o)
local e={}
local a=t.damageMap
local t={}
for t,a in pairs(a)do
local t=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(t)
if t then
table.insert(e,t)
end
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(e)
local t=#e
for t=1,t do
local e=e[t]
local t=a[e.HeroId]
ModulesInit.ProcedureNormalBattle.SkillHurtWithTeam(i,e,o,0,0,t)
end
return nil
end
return n 
