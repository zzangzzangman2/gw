local o=require("Modules/Battle/BattleUtil")
local e={
}
local i=e
function e.DoAction(i,a,e)
local t=ModulesInit.ProcedureNormalBattle:GetTeamSkillArgs(a)
local t=e.hurtDataMap
local e={}
for t,a in pairs(t)do
local t=o:GetTargetHeroCtrl(t)
if t then
table.insert(e,t)
end
end
table.sort(e,function(e,t)
return e.HeroId<t.HeroId
end)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(e)
local o=#e
for o=1,o do
local e=e[o]
local t=t[e.HeroId]
ModulesInit.ProcedureNormalBattle.SkillHurtWithTeam(i,e,a,0,0,t)
end
return nil
end
return i 
