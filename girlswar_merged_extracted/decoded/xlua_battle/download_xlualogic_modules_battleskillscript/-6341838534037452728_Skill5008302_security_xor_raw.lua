local e={
}
local h=e
function e.DoAction(a,i)
local e=a:JudgeSkillPreView(i)
local s=e[1]
local n=e[3]
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.enemyAll)
if(e~=nil)then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(e)
local o=#e
local t=0
for a=1,o do
local e=e[a]
if(e.HeroBattleInfo:GetBuff(2032))then
t=t+1
end
end
local t=n*t
for o=1,o do
local e=e[o]
ModulesInit.ProcedureNormalBattle.SkillHurt(a,e,i,s+t)
end
end
return nil
end
return h 
