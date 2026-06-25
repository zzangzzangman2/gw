local e={}
local s=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eColumn)
if(a==nil)then
return
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local s=e[1]
t:AddFuryWithSkill(e[9])
local h=e[10]
local o=e[11]
local n={e[12],e[13]}
t:AddBuff(t,h,o,n)
local o=#a
for o=1,o do
local a=a[o]
if(o==1)then
local o=e[3]
local i=e[4]
local e=e[5]
a:CheckAddBuff(o,t,i,e,0)
end
local o=s
if(a.profession==e[6]or a.profession==e[7])then
o=o+e[8]
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,o)
end
t:FuryHealth(FuryHealthType.Attack)
local e=ModulesInit.BattleBuffMgr.GetBuffScript(302104103)
return e.HandleSkillChangeData(t)
end
return s

