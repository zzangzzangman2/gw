local e={
}
local i=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
local i=e[1]
local s=e[4]
local n=e[5]
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a)then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
for h,a in ipairs(a)do
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,i)
if(e[3]>=RandomMgr:GetBattleRandom())then
a:AddBuff(t,s,n)
end
end
end
return nil
end
return i 
