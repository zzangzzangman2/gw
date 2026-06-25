local e={}
local u=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
if t:GetSkillUseCount(1027304)<=e[20]then
local e=ModulesInit.ProcedureNormalBattle.GetBattleHerosByHeroModelId(t,BattleHeroType.ourAll,e[19])
if(#e>0)then
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(SkillChangeType.Change,1027304,e)
end
end
t:ReduceFury(o.costMp)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eColumn)
if(a==nil)then
return
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local u=e[1]
local n=e[3]
local s=e[4]
local i={}
for a=5,14 do
table.insert(i,e[a])
end
t:AddBuff(t,n,s,i)
local l=e[8]
local d=e[9]
local h={t.HeroId,e[10],e[11],e[12],e[13]}
local s=e[15]
local r=e[16]
local n=e[17]
local i=#a
for i=1,i do
local a=a[i]
if i<=e[18]then
a:CheckAddBuff(s,t,r,n)
end
a:AddBuff(t,l,d,h)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,u)
end
return nil
end
return u

