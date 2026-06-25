local e=require("Modules/Battle/BattleUtil")
local o={
}
local s=o
function o.DoAction(t,i,e)
local e=t:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local h=e[4]
local s=e[5]
local r=e[6]
local n=e[7]
local o={}
for t=8,11 do
table.insert(o,e[t])
end
local e=#a
for e=1,e do
local e=a[e]
e:CheckAddBuff(s,t,r,n,o)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,i,h)
end
return nil
end
function o.GetCanTriggerSkill(e)
return false
end
function o.DoPassiveAction(e,a)
local t=e:JudgeSkillPreView(a)
local o=t[1]
local i=t[2]
local t={a.id,t[3],0}
e:AddBuff(e,o,i,t)
return nil
end
return s 
