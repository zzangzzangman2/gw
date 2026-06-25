local e={
}
local n=e
function e.DoAction(t,a)
local e=t:JudgeSkillPreView(a)
local n=e[1]
local d=e[3]
local l=e[4]
local h=e[5]
local r=e[6]
local s=e[7]
local o=e[8]
local i={e[9]}
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eColumn)
if(e)then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(e)
for u,e in ipairs(e)do
e:CheckAddBuff(d,t,l,h,0)
e:CheckAddBuff(r,t,s,o,i)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,a,n)
end
end
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return n 
