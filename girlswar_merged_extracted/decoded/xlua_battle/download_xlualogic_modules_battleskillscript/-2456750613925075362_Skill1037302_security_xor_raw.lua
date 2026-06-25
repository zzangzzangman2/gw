local e={
}
local n=e
function e.DoAction(t,a)
local e=t:JudgeSkillPreView(a)
t:ReduceFury(a.costMp)
local s=e[1]
local n=e[8]
local h=e[9]
local i={e[10]}
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(o)then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(o)
for o,e in ipairs(o)do
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,a,s)
e:AddBuff(t,n,h,i)
end
end
local a=e[3]
if(a>=RandomMgr:GetBattleRandom())then
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eRandom,e[4])
if(a)then
local o=e[5]
local e=e[6]
for i,a in ipairs(a)do
a:AddBuff(t,o,e,0)
end
end
end
return nil
end
return n 
