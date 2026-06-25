local e=require("Modules/Battle/BattleUtil")
local i={
}
local s=i
function i.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local s=e[16]
local o=0
local n=#a
for e=1,n do
local t=a[e]
local e=308200302
local e=t.HeroBattleInfo:GetBuff(e)
if e then
local e=e:GetFloors()
o=o+e
end
end
local n=#a
for n=1,n do
local a=a[n]
if o>=e[17]then
t:AddMustCritValueInCurAttack()
local a=math.floor((o-e[17])/e[18])
a=math.min(a,e[21])
local a=e[20]*a
local e={
attrId=e[19],
value=a,
}
t:AddAttrValueInCurAttack(e)
end
local o=308200302
local o=a.HeroBattleInfo:GetBuff(o)
if o then
local t=o:GetFloors()
local e={
attrId=e[12],
value=e[13]*t,
}
a:AddAttrValueInCurAttack(e)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,s)
t:RemoveMustCritValueInCurAttack()
t:ResetAttrValuesInCurAttack()
a:ResetAttrValuesInCurAttack()
end
return nil
end
function i.GetCanTriggerSkill(e)
return false
end
function i.DoPassiveAction(e,o)
local t=e:JudgeSkillPreView(o)
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.fFightPet)
if i then
local n=t[1]
local o=t[2]
local a={}
for e=3,13 do
table.insert(a,t[e])
end
for e=1,2 do
table.insert(a,0)
end
i:AddBuff(e,n,o,a)
end
local a=t[14]
local i=t[15]
local t={o.id}
e:AddBuff(e,a,i,t)
return nil
end
return s 
