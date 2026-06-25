local e=require("Modules/Battle/BattleUtil")
local o={
}
local s=o
function o.DoAction(t,o,e)
local e=t:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eMinHpPercent)
if(a==nil)then
return nil
end
local i=e[3]
if e[4]>0 then
local n=e[4]
local o=e[5]
local i=t:GetFinalAtk()
local i=math.floor(i*e[8]*MillionCoe)
local e={e[6],e[7],i}
a:AddBuff(t,n,o,e)
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,i)
return nil
end
function o.GetCanTriggerSkill(e)
return false
end
function o.DoPassiveAction(t,o)
local a=t:JudgeSkillPreView(o)
local n=a[1]
local i=a[2]
local e={}
table.insert(e,o.id)
for t=3,16 do
table.insert(e,a[t])
end
table.insert(e,0)
t:AddBuff(t,n,i,e)
return nil
end
return s 
