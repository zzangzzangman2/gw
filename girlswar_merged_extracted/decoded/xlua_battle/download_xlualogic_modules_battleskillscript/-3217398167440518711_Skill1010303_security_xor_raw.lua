local e={
}
local d=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
t:ReduceFury(o.costMp)
local d=e[1]
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a)then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local r=(e[3]>=RandomMgr:GetBattleRandom())
local s
local h
local n
if(r)then
s=e[4]
h=e[5]
n={e[6],e[7]}
end
local i=0
for t,e in ipairs(a)do
if(e.HeroBattleInfo:GetBuff(2009))then
i=i+1
end
end
local i=e[10]*i
if(i>0)then
local o=e[8]
local a=e[9]
local e={i,e[11]}
t:AddBuff(t,o,a,e)
end
for a,e in ipairs(a)do
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,o,d)
if(r)then
e:AddBuff(t,s,h,n)
end
end
end
return nil
end
return d 
