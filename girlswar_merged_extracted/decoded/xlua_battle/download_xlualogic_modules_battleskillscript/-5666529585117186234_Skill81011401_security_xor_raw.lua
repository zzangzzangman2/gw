local e=require("Modules/Battle/BattleUtil")
local i={
}
local d=i
function i.DoAction(i,h)
local e=i:JudgeSkillPreView(h)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(i,BattleHeroType.eColumn)
if(t==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(t)
local n=false
if e[6]>0 then
if#t==1 then
n=true
end
end
local r=e[4]
local s=e[7]
local d=e[8]
local a={}
for t=9,16 do
if e[t]then
table.insert(a,e[t])
else
table.insert(a,0)
end
end
table.insert(a,0)
local o=#t
for o=1,o do
local t=t[o]
local o=0
if n==true then
o=e[6]
else
if t:IsRealFirstRowHero()then
o=e[3]
else
o=e[5]
end
end
t:AddBuff(i,s,d,a,o)
local a=r
if n==true or t:IsRealFirstRowHero()==false then
local t=t.HeroBattleInfo:GetBuff(s)
local e=0
if t then
e=t:GetFloors()
end
e=math.max(1,e)
a=r*e
end
ModulesInit.ProcedureNormalBattle.SkillHurt(i,t,h,a)
end
return nil
end
function i.GetCanTriggerSkill(e)
return false
end
function i.DoPassiveAction(e,t)
local a=e:JudgeSkillPreView(t)
local o=a[1]
local a=a[2]
local t={t.id}
e:AddBuff(e,o,a,t)
return nil
end
return d 
