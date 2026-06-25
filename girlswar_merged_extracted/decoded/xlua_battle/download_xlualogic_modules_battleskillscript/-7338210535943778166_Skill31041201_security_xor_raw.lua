local e={}
local d=e
function e.DoAction(e,h)
local t=e:JudgeSkillPreView(h)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eColumn)
if(o==nil)then
return
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(o)
local i=303104105
local a=e.HeroBattleInfo:GetBuff(i)
if a then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(i)
e.DoActionAllSkill(a,o)
end
local s=nil
local i=303104112
local a=e.HeroBattleInfo:GetBuff(i)
if(a)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(i)
e.DoBeansActionSmallSkill(a,o)
end
local r=t[1]
e:AddFuryWithSkill(t[9])
local i=#o
for n=1,i do
local i=o[n]
if(n==1)then
local o=t[3]
if(a)then
local e=a:GetBuffData()
o=e[12]
end
local n=t[4]
local t=t[5]
local e=i:CheckAddBuff(o,e,n,t,0)
if e and a then
local e=a:GetBuffData()
s={triggerType="countByBean1",sepsisHPRate=e[19]}
end
end
local o=r
if(i.profession==t[6]or i.profession==t[7])then
if(a)then
local e=a:GetBuffData()
o=o+e[17]
else
o=o+t[8]
end
end
ModulesInit.ProcedureNormalBattle.SkillHurt(e,i,h,o)
end
e:FuryHealth(FuryHealthType.Attack)
local t=ModulesInit.BattleBuffMgr.GetBuffScript(303104103)
return t.HandleSkillChangeData(e,s)
end
return d

