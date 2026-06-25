local o=require("Modules/Battle/BattleUtil")
local e={
}
local s=e
function e.DoAction(s,n,t)
local e=ModulesInit.ProcedureNormalBattle:GetTeamSkillArgs(n)
local a={}
local e={}
local t=t.damageList
for i=1,#t do
local i=t[i]
local t=i.defHeroId
local o=o:GetTargetHeroCtrl(t)
if o then
a[t]=i
table.insert(e,o)
end
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(e)
local t=#e
for t=1,t do
local e=e[t]
local t=a[e.HeroId].reduceHpConvert
ModulesInit.ProcedureNormalBattle.SkillHurtWithTeam(s,e,n,0,0,t)
end
return nil
end
return s 
