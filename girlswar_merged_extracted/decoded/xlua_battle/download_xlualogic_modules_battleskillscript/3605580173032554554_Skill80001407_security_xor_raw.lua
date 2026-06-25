local i=require("Modules/Battle/BattleUtil")
local o={
}
local h=o
function o.DoAction(a,n)
local e=a:JudgeSkillPreView(n)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.enemyAll)
if(t==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(t)
local s=e[3]
local o=i:GetNewTable(t)
local o=i:FindMostBigAtk(o)
if o then
local i=e[5]
local n=e[6]
local t={e[7],e[8]}
o:AddBuff(a,i,n,t)
local t=e[9]
local i=e[10]
local e={e[11],e[12]}
o:AddBuff(a,t,i,e)
end
local e=#t
for e=1,e do
local e=t[e]
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
