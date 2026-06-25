local e={
}
local s=e
function e.DoAction(e,i)
local t=e:JudgeSkillPreView(i)
local n=t[1]
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
if(o)then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(o)
local a=0
for o,t in ipairs(o)do
local e=ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,i,n)
a=a+e[1]
end
local o=t[3]
local i=t[4]
local t={math.floor(t[5]*a*MillionCoe)}
e:AddBuff(e,o,i,t)
end
return nil
end
return s 
