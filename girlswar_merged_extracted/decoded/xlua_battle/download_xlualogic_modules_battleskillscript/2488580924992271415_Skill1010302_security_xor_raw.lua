local e={
}
local r=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
t:ReduceFury(i.costMp)
local r=e[1]
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(o)then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(o)
local h=(e[3]>=RandomMgr:GetBattleRandom())
local s
local a
local n
if(h)then
if(t.HeroBattleInfo:IsExistsSkill(1010404))then
s=e[7]
a=e[8]
n={e[9],e[10]}
else
s=e[4]
a=e[5]
n={e[6]}
end
end
for o,e in ipairs(o)do
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,i,r)
if(h)then
e:AddBuff(t,s,a,n)
end
end
end
return nil
end
return r 
