local e=require("Modules/Battle/BattleUtil")
local o={
}
local h=o
function o.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eBackMinHpPercentWithCount)
local a=a[1]
if(a==nil)then
return nil
end
local s=e[4]
local o=nil
local n=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if#n<e[5]then
local i={
attrId=e[6],
value=e[7],
}
t:AddAttrValueInCurAttack(i)
local e={
attrId=e[8],
value=e[9],
}
t:AddAttrValueInCurAttack(e)
o={
openAddFury=false
}
a:SetDisableDefRage(true)
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,s,0,0,o)
a:SetDisableDefRage(false)
return nil
end
function o.GetCanTriggerSkill(e)
return false
end
function o.DoPassiveAction(e,a)
local t=e:JudgeSkillPreView(a)
local o=t[1]
local i=t[2]
local t={a.id,t[3]}
e:AddBuff(e,o,i,t)
return nil
end
return h 
