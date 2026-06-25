local e={
}
local n=e
function e.DoAction(e,a)
local t=e:JudgeSkillPreView(a)
e:ReduceFury(a.costMp)
local n=t[1]
local o=t[3]
local s=t[5]
local i=t[6]
local h={t[7]}
e:AddFuryWithSkill(o)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.fBack)
if(o~=nil)then
for o,a in ipairs(o)do
if(a.HeroId~=e.HeroId)then
a:AddFuryWithSkill(t[4])
end
end
end
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
if(t~=nil)then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(t)
for o,t in ipairs(t)do
t:AddBuff(e,s,i,h)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,a,n)
end
end
return nil
end
return n 
