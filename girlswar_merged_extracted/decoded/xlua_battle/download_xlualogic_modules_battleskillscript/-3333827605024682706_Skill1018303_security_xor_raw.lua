local e={
}
local s=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
local a=t.CurrBattleTeam.OpponentTeam:GetAllHerosCount()
if(a==1)then
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(SkillChangeType.Change,e[11])
end
t:ReduceFury(o.costMp)
local s=e[1]
local h=e[4]
local n=e[5]
local i=e[6]
local a={e[7]}
t:AddBuff(t,n,i,a)
local a=e[8]
local i=e[9]
local n={e[10]}
t:AddBuff(t,a,i,n)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eRandom,e[2])
if(a~=nil)then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
for i,e in ipairs(a)do
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,o,s)
end
a=RandomTableWithSeed(a,e[3])
for a,e in ipairs(a)do
e:ReduceFuryWithSkill(h,t,EBattleSrcType.SkillBig,true)
end
end
return nil
end
return s 
