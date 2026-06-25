local e={
}
local r=e
function e.DoAction(t,n)
local e=t:JudgeSkillPreView(n)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eColumn)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local r=e[1]
local s=e[6]
local i=e[7]
local o={e[8],e[9]}
t:AddBuff(t,s,i,o)
local o=#a
for s=1,o do
local a=a[s]
local h=a.HeroBattleInfo:GetBuff(e[10])
local o=r
local i=e[3]
if h~=nil then
o=o+e[11]
i=i+e[12]
end
if s==1 then
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
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,n,o)
end
t:FuryHealth(FuryHealthType.Attack)
end
return r 
