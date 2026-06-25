local o=require("Modules/Battle/BattleUtil")
local e={
}
local n=e
function e.DoAction(a,t,e)
local i=a:JudgeSkillPreView(t)
local e=e.defHeroId
local e=o:GetTargetHeroCtrl(e)
if e==nil then
return
end
local o=i[5]
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(e)
ModulesInit.ProcedureNormalBattle.SkillHurt(a,e,t,o)
return nil
end
function e.GetCanTriggerSkill(e)
return false
end
function e.DoPassiveAction(t,e)
local a=t:JudgeSkillPreView(e)
local i=a[1]
local o=a[2]
local e={e.id}
for t=3,4 do
table.insert(e,a[t])
end
for t=5,7 do
table.insert(e,0)
end
table.insert(e,0)
table.insert(e,0)
table.insert(e,0)
t:AddBuff(t,i,o,e)
return nil
end
return n 
