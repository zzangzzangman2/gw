local s=require("Modules/Battle/BattleUtil")
local e={
}
local n=e
function e.DoAction(o,a,e,t)
local i=o:JudgeSkillPreView(a)
local t=0
if e then
t=e.defHeroId
end
local t=s:GetTargetHeroCtrl(t)
if(t==nil)then
return nil
end
local e={t}
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.fHollow)
table.appendList(e,t)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(e)
local i=i[3]
local t=#e
for t=1,t do
local e=e[t]
ModulesInit.ProcedureNormalBattle.SkillHurt(o,e,a,i)
end
return nil
end
function e.GetCanTriggerSkill(e)
return false
end
function e.DoPassiveAction(t,a)
local e=t:JudgeSkillPreView(a)
local o=e[1]
local i=e[2]
local e={a.id,e[4]}
table.insert(e,0)
table.insert(e,0)
table.insert(e,0)
t:AddBuff(t,o,i,e)
return nil
end
return n 
