local i=require("Modules/Battle/BattleUtil")
local o={
}
local h=o
function o.DoAction(a,n)
local t=a:JudgeSkillPreView(n)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.enemyAll)
if(e==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(e)
local s=t[3]
local o=i:GetNewTable(e)
local o=i:FindMostBigAtk(o)
if o then
local i=t[5]
local e=t[6]
local t={t[7],t[8]}
o:AddBuff(a,i,e,t)
end
local t=#e
for t=1,t do
local e=e[t]
ModulesInit.ProcedureNormalBattle.SkillHurt(a,e,n,s)
end
return nil
end
function o.GetCanTriggerSkill(e)
return false
end
function o.DoPassiveAction(e,t)
local a=e:JudgeSkillPreView(t)
local o=a[1]
local a=a[2]
local t={t.id}
e:AddBuff(e,o,a,t)
return nil
end
return h 
