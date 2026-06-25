local e=require("Modules/Battle/BattleUtil")
local i={
}
local r=i
function i.DoAction(t,n,e)
local e=t:JudgeSkillPreView(n)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a==nil or#a<=0)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local i=e[5]
local o=t.CurrBattleTeam:GetTotalHPPercent()
local o=math.min((1-o)*e[7]/e[6],e[8]*MillionCoe)
o=math.max(0,o)
i=math.floor(i*(1+o))
local r=e[9]
local s=e[10]
local h=e[11]
local o={}
local d=t:GetFinalAtk()
local d=math.floor(d*e[12]*MillionCoe)
table.insert(o,d)
for t=13,16 do
if e[t]then
table.insert(o,e[t])
else
table.insert(o,0)
end
end
local e=#a
for e=1,e do
local e=a[e]
e:CheckAddBuff(r,t,s,h,o)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,n,i)
end
return nil
end
function i.GetCanTriggerSkill(e)
return false
end
function i.DoPassiveAction(a,e)
local t=a:JudgeSkillPreView(e)
local i=t[1]
local o=t[2]
local e={e.id}
for a=3,4 do
if t[a]then
table.insert(e,t[a])
else
table.insert(e,0)
end
end
table.insert(e,0)
a:AddBuff(a,i,o,e)
return nil
end
return r 
