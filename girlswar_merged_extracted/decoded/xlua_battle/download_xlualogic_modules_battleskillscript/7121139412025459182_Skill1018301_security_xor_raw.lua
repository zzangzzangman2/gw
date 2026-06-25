local e={
}
local h=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
t:ReduceFury(o.costMp)
local h=e[1]
local s=e[4]
local n=e[5]
local i=e[6]
local a={e[7]}
t:AddBuff(t,n,i,a)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eRandom,e[2])
if(a~=nil)then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
for i,e in ipairs(a)do
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,o,h)
end
a=RandomTableWithSeed(a,e[3])
for a,e in ipairs(a)do
e:ReduceFuryWithSkill(s,t,EBattleSrcType.SkillBig,true)
end
end
return nil
end
return h 
