local e=require("Modules/Battle/BattleUtil")
local o={
}
local r=o
function o.DoAction(o,s,t)
local e=o:JudgeSkillPreView(s)
local i=e[8]
local h=e[9]
local n=e[16]
local a={}
if t and t.defHeroIds then
local e=t.defHeroIds
i=t.skillHurtRate
h=t.buffPro
n=t.buffFloor
for t=1,#e do
local e=e[t]
local e=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e)
table.insert(a,e)
end
else
a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(o,BattleHeroType.enemyAll)
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local t=#a
for t=1,t do
local t=a[t]
local h=h
local r=e[10]
local a=e[11]
local e={e[12],e[13],e[14],e[15]}
t:CheckAddBuff(h,o,r,a,e,n)
if i>0 then
ModulesInit.ProcedureNormalBattle.SkillHurt(o,t,s,i)
end
end
end
function o.GetCanTriggerSkill(e)
if e==BuffTriggerTime.battleBeginPetHelpSkill then
return true
end
return false
end
function o.DoPassiveAction(a,e)
local t=a:JudgeSkillPreView(e)
local o=t[1]
local i=t[2]
local e={e.id}
for a=3,23 do
if t[a]then
table.insert(e,t[a])
else
table.insert(e,0)
end
end
for t=1,6 do
table.insert(e,0)
end
table.insert(e,0)
a:AddBuff(a,o,i,e)
return nil
end
return r 
