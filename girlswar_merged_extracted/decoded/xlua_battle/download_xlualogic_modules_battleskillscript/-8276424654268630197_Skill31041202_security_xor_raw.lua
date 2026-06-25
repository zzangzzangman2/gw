local e={}
local r=e
function e.DoAction(t,s)
local e=t:JudgeSkillPreView(s)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eColumn)
if(o==nil)then
return
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(o)
local i=303104105
local a=t.HeroBattleInfo:GetBuff(i)
if a then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(i)
e.DoActionAllSkill(a,o)
end
local n=nil
local i=303104112
local a=t.HeroBattleInfo:GetBuff(i)
if(a)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(i)
e.DoBeansActionSmallSkill(a,o)
end
local r=e[1]
t:AddFuryWithSkill(e[9])
local i=e[10]
local d=e[11]
local h={e[12],e[13]}
t:AddBuff(t,i,d,h)
local i=#o
for h=1,i do
local i=o[h]
if(h==1)then
local o=e[3]
if(a)then
local e=a:GetBuffData()
o=e[12]
end
local s=e[4]
local e=e[5]
local e=i:CheckAddBuff(o,t,s,e,0)
if e and a then
local e=a:GetBuffData()
n={triggerType="countByBean1",sepsisHPRate=e[19]}
end
end
local o=r
if(i.profession==e[6]or i.profession==e[7])then
if(a)then
local e=a:GetBuffData()
o=o+e[17]
else
o=o+e[8]
end
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,i,s,o)
end
t:FuryHealth(FuryHealthType.Attack)
local e=ModulesInit.BattleBuffMgr.GetBuffScript(303104103)
return e.HandleSkillChangeData(t,n)
end
return r

