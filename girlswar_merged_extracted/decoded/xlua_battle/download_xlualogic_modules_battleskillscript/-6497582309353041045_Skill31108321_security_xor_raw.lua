local u=require("Modules/Battle/BattleUtil")
local e={}
local f=e
function e.DoAction(t,s)
local e=t:JudgeSkillPreView(s)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
t:ReduceFury(s.costMp)
t:RemoveOneBeans()
local m=e[1]
local o=t.HeroBattleInfo.MaxHP
local c=math.floor(o*e[3]*MillionCoe)
local n=#a
local o=303110801
local h=RandomMgr:GetBattleRandomWithRange(e[4],e[5])
local i={}
for e=1,n do
local e=a[e]
local t=e.HeroBattleInfo:GetBuff(o)
if t then
table.insert(i,e)
end
end
local l={}
local i=RandomTableWithSeed(i,h)
for e=1,#i do
local e=i[e]
l[e.HeroId]=e
end
local h=e[7]
local i=e[8]
local r={e[9],e[10]}
t:AddBuff(t,h,i,r)
local r=e[11]
local h=e[12]
local i={e[13],e[14]}
t:AddBuff(t,r,h,i)
local h=303110812
local i=t.HeroBattleInfo:GetBuff(h)
if(i)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(h)
e.AddAttackTask(i)
end
local r=303110813
local i=t.HeroBattleInfo:GetBuff(r)
local d=303110804
local h=t.HeroBattleInfo:GetBuff(d)
for n=1,n do
local a=a[n]
local n=c
if l[a.HeroId]then
if e[6]>=RandomMgr:GetBattleRandom()then
local i=a.HeroBattleInfo:GetBuff(o)
if i then
local s=ModulesInit.BattleBuffMgr.GetBuffScript(o)
local t=s.GetAccumulateDamage(i)
n=n+t
if e[15]>=RandomMgr:GetBattleRandom()then
local n={}
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.fHollow)
for e=1,#t do
local a=t[e].HeroBattleInfo:GetBuff(o)
if a==nil then
table.insert(n,t[e])
end
end
local t=RandomTableWithSeed(n,e[16])
for a=1,#t do
s.AddBuffSeed(i,t[a],e[17])
end
end
end
end
end
if i then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(r)
e.DoActionBigSkill(i,a)
end
local e=ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,s,m,0,n)
if i then
local i=i:GetBuffData()
local e=e[3]
local o=e.reduceHpValue
local e=i[1]
if e>0 then
local e=math.floor(o*e*MillionCoe)
local t=u:AddSepsisHp(t,a,e)
if t then
if h then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(d)
t.AddMaxHpBySepsis(h,e)
end
end
end
end
end
return nil
end
return f

