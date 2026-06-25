local e={}
local c=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
t:ReduceFury(o.costMp)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eColumn)
if(a==nil)then
return
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local l=e[1]
local s=e[3]
local n=e[4]
local i={}
for a=5,14 do
table.insert(i,e[a])
end
t:AddBuff(t,s,n,i)
local c=e[19]
local d=e[8]
local u=e[9]
local r={t.HeroId,e[10],e[11],e[12],e[13]}
local s=e[15]
local n=e[16]
local h=e[17]
local i=#a
for i=1,i do
local a=a[i]
if i<=e[18]then
a:CheckAddBuff(s,t,n,h)
end
a:CheckAddBuff(c,t,d,u,r)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,l)
end
return nil
end
return c

