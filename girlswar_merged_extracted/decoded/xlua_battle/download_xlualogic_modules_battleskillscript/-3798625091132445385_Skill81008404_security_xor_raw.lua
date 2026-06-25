local e=require("Modules/Battle/BattleUtil")
local i={
}
local r=i
function i.DoAction(a,i,e)
local e=a:JudgeSkillPreView(i)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.enemyAll)
if(t==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(t)
local n=e[4]
local d=e[7]
local s=e[8]
local h=e[9]
local r={e[10],e[11]}
local o=table.lightCopyList(t)
local o=RandomTableWithSeed(o,e[6])
for e=1,#o do
local e=o[e]
e:CheckAddBuff(d,a,s,h,r)
end
local o=true
if e[5]==1 then
o=false
end
local e=#t
for e=1,e do
local e=t[e]
local t={
openAddFury=o,
}
if o==false then
e:SetDisableDefRage(true)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(a,e,i,n)
if o==false then
e:SetDisableDefRage(false)
end
end
return nil
end
function i.GetCanTriggerSkill(e)
if e==BuffTriggerTime.battleBeginPetHelpSkill then
return true
end
return false
end
function i.DoPassiveAction(t,o)
local a=t:JudgeSkillPreView(o)
local i=a[1]
local n=a[2]
local e={}
table.insert(e,o.id)
table.insert(e,a[3])
table.insert(e,0)
t:AddBuff(t,i,n,e)
return nil
end
return r 
