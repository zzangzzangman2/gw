local e={
}
local n=e
function e.DoAction(a,o,t,e)
local t=a:JudgeSkillPreView(o)
local i=e.skillHurtRate
local t=e.defHeroIds
local e={}
if t then
for a=1,#t do
local t=t[a]
local t=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(t)
if(t.HeroBattleInfo.CurrHP>0 and t:IsUsualState())then
table.insert(e,t)
end
end
end
if#e<=0 then
return
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(e)
local t=#e
for t=1,t do
local e=e[t]
local t={
openAddFury=false
}
e:SetDisableDefRage(true)
ModulesInit.ProcedureNormalBattle.SkillHurt(a,e,o,i)
e:SetDisableDefRage(false)
end
return nil
end
return n 
