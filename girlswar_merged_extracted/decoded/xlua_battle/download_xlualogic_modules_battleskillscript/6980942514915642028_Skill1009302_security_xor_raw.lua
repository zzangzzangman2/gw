local e={
}
local d=e
function e.DoAction(t,a)
local e=t:JudgeSkillPreView(a)
t:ReduceFury(a.costMp)
local s=e[1]
local i=e[3]
local o=e[4]
local n={e[5]}
t:AddBuff(t,i,o,n)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eColumn)
if(o~=nil)then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(o)
for o,e in ipairs(o)do
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,a,s)
end
end
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.fHollow)
if(a)then
local r=e[6]
local i=e[7]
local o={e[8]}
local n=e[9]
local h=e[10]
local s={e[11]}
for a,e in ipairs(a)do
e:AddBuff(t,r,i,o)
e:AddBuff(t,n,h,s)
end
end
return nil
end
return d 
