local e={
}
local n=e
function e.DoAction(t,a)
local e=t:JudgeSkillPreView(a)
t:ReduceFury(a.costMp)
local s=e[1]
local n=e[10]
local i=e[11]
local h={e[12]}
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(o)then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(o)
for o,e in ipairs(o)do
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,a,s)
e:AddBuff(t,n,i,h)
end
end
local a=e[3]
if(a>=RandomMgr:GetBattleRandom())then
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eRandom,e[4])
if(a)then
local o=e[5]
local i=e[6]
local e={e[7],e[8],e[9]}
for n,a in ipairs(a)do
a:AddBuff(t,o,i,e)
end
end
end
return nil
end
return n 
