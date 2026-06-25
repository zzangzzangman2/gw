local e={}
local s=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
t:ReduceFury(o.costMp)
local s=e[1]
local n=e[3]
local i=e[4]
local h={e[5],e[6]}
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eColumn)
if(a~=nil)then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local e=#a
for e=1,e do
local e=a[e]
e:AddBuff(t,n,i,h)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,o,s)
end
end
local i=e[7]
local o=e[8]
local n={e[9],e[10]}
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.fBack)
if(a)then
for a,e in ipairs(a)do
e:AddBuff(t,i,o,n)
end
end
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(SkillChangeType.Sequence,e[11])
end
return s

