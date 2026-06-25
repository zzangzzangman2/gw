local e={
}
local i=e
function e.DoAction(e,a)
local t=e:JudgeSkillPreView(a)
e:ReduceFury(a.costMp)
local i=t[1]
local o=t[3]
local s=t[4]
local h=t[5]
local n={t[6]}
e:AddFuryWithSkill(o)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
if(t~=nil)then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(t)
for o,t in ipairs(t)do
t:AddBuff(e,s,h,n)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,a,i)
end
end
return nil
end
return i 
