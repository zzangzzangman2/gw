local t=require("Modules/Battle/BattleUtil")
local e={
}
local n=e
function e.DoAction(e,o,a)
local i=e:JudgeSkillPreView(o)
local a=a.cfgArgs
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
local t=t:GetMinHpPercentHeroArr(i,a[1])
if(t==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(t)
local i=a[2]
local a={
attrId=a[3],
value=a[4],
}
e:AddAttrValueInCurAttack(a)
local a=#t
for a=1,a do
local t=t[a]
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,o,i)
end
local t=308200804
local e=e.HeroBattleInfo:GetBuff(t)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
t.AddAttackTask(e)
end
return nil
end
return n 
