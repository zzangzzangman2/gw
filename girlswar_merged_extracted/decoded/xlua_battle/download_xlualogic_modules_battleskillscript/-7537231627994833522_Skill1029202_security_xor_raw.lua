local e={
}
local i=e
function e.DoAction(e,o)
local a=e:JudgeSkillPreView(o)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eColumn)
if(t==nil)then
return
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(t)
local n=a[1]
local s=a[3]
local i=a[4]
local a=#t
for a=1,a do
local t=t[a]
t:AddBuff(e,s,i)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,o,n)
end
e:FuryHealth(FuryHealthType.Attack)
end
return i 
