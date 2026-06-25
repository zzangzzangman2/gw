local e={}
local n=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eColumn)
if(a==nil)then
return
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local n=e[1]
t:AddFuryWithSkill(e[9])
local o=#a
for o=1,o do
local a=a[o]
if(o==1)then
local i=e[3]
local o=e[4]
local e=e[5]
a:CheckAddBuff(i,t,o,e,0)
end
local o=n
if(a.profession==e[6]or a.profession==e[7])then
o=o+e[8]
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,o)
end
t:FuryHealth(FuryHealthType.Attack)
local e=ModulesInit.BattleBuffMgr.GetBuffScript(302104103)
return e.HandleSkillChangeData(t)
end
return n

