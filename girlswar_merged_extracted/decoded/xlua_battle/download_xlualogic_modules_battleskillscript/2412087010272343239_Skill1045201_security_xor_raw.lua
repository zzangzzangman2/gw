local e={
}
local h=e
function e.DoAction(t,s)
local e=t:JudgeSkillPreView(s)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eColumn)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local o=e[1]
local i=#a
for n=1,i do
local a=a[n]
local h=a.HeroBattleInfo:GetBuff(e[6])
local o=o
local i=e[3]
if h~=nil then
o=o+e[7]
i=i+e[8]
end
if n==1 then
local o=e[4]
local e=e[5]
a:CheckAddBuff(i,t,o,e)
end
local e=ModulesInit.BattleBuffMgr.GetBuffScript(30104505)
if e then
local i=e.GeHurtAddRate(t,a)
o=o+i
e.AddBoneCrashBuff(t,a)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,s,o)
end
t:FuryHealth(FuryHealthType.Attack)
end
return h 
