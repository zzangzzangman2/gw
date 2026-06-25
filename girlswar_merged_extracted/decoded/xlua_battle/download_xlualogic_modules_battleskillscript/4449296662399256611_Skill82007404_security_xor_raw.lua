local e=require("Modules/Battle/BattleUtil")
local t={
}
local h=t
function t.DoAction(e,o)
local t=e:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eBackMinHpPercentWithCount)
local a=a[1]
if(a==nil)then
return nil
end
local s=t[4]
local i=nil
local n=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
if#n<t[5]then
local t={
attrId=t[6],
value=t[7],
}
e:AddAttrValueInCurAttack(t)
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,o,s,0,0,i)
return nil
end
function t.GetCanTriggerSkill(e)
return false
end
function t.DoPassiveAction(t,a)
local e=t:JudgeSkillPreView(a)
local o=e[1]
local i=e[2]
local e={a.id,e[3]}
t:AddBuff(t,o,i,e)
return nil
end
return h 
