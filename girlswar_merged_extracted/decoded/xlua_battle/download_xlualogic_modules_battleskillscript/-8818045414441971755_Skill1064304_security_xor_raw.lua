local e=require("Modules/Battle/BattleUtil")
local e={}
local i=e
function e.DoAction(o,a,t,e)
local t=o:JudgeSkillPreView(a)
local i=e.realHurt
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
ModulesInit.ProcedureNormalBattle.SkillHurt(o,e,a,0,0,i)
e:SetDisableDefRage(false)
end
return nil
end
return i

