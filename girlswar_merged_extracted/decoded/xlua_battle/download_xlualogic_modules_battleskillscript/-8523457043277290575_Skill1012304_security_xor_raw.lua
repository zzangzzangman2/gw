local e={
}
local s=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
t:ReduceFury(o.costMp)
local s=e[1]
local a=e[3]
t:AddFuryWithSkill(a)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAll)
if(a~=nil)then
for a,t in ipairs(a)do
t:AddFuryWithSkill(e[4])
end
end
local n=e[5]
local i=e[6]
local a={e[7]}
t:AddBuff(t,n,i,a)
local i=e[8]
local n=e[9]
local a={e[10]}
t:AddBuff(t,i,n,a)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
local i=e[11]
local n=e[12]
local e={e[13]}
a:AddBuff(t,i,n,e)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,s)
return nil
end
return s 
