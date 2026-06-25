local e={}
local u=e
function e.DoAction(t,n,i)
local e=t:JudgeSkillPreView(n)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a==nil)then
return
end
t:ReduceFury(n.costMp)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local r=e[1]
local h=e[3]
local s=e[4]
local o={}
for a=5,14 do
table.insert(o,e[a])
end
t:AddBuff(t,h,s,o)
if i then
for e=1,#i do
i[e]:AddBuff(t,h,s,o)
end
end
local c=e[19]
local l=e[8]
local u=e[9]
local d={t.HeroId,e[10],e[11],e[12],e[13]}
local s=e[15]
local i=e[16]
local h=e[17]
local o=#a
for o=1,o do
local a=a[o]
if o<=e[18]then
a:CheckAddBuff(s,t,i,h)
end
a:CheckAddBuff(c,t,l,u,d)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,n,r)
end
return nil
end
return u

