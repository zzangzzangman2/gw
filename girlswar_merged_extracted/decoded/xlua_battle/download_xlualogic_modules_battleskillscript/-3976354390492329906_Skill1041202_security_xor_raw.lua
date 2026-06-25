local e={}
local s=e
function e.DoAction(t,n)
local e=t:JudgeSkillPreView(n)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eColumn)
if(a==nil)then
return
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local s=e[1]
if(e[7]>=RandomMgr:GetBattleRandom())then
t:AddFuryWithSkill(e[8])
end
local h=e[9]
local i=e[10]
local o={e[11],e[12]}
t:AddBuff(t,h,i,o)
local o=#a
for i=1,o do
local o=a[i]
if(i==1)then
if(e[3]>=RandomMgr:GetBattleRandom())then
local a=e[4]
local e=e[5]
o:AddBuff(t,a,e,0)
end
end
local a=s
if(o.profession==ProfessionType.Mage)then
a=a+e[6]
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,o,n,a)
end
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return s

