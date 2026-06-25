local u=require("Modules/Battle/BattleUtil")
local e={
}
local m=e
function e.DoAction(e,s,t,t)
local t=e:JudgeSkillPreView(s)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
e:ReduceFury(s.costMp)
local m=t[1]
local o=e.HeroBattleInfo.MaxHP
local c=math.floor(o*t[3]*MillionCoe)
local n=#a
local i=303110801
local h=RandomMgr:GetBattleRandomWithRange(t[4],t[5])
local o={}
for e=1,n do
local e=a[e]
local t=e.HeroBattleInfo:GetBuff(i)
if t then
table.insert(o,e)
end
end
local d={}
local o=RandomTableWithSeed(o,h)
for e=1,#o do
local e=o[e]
d[e.HeroId]=e
end
local h=t[7]
local r=t[8]
local o={t[9],t[10]}
e:AddBuff(e,h,r,o)
local r=t[11]
local h=t[12]
local o={t[13],t[14]}
e:AddBuff(e,r,h,o)
local o=303110812
local h=e.HeroBattleInfo:GetBuff(o)
if(h)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(o)
e.AddAttackTask(h)
end
local h=303110813
local o=e.HeroBattleInfo:GetBuff(h)
local l=303110804
local r=e.HeroBattleInfo:GetBuff(l)
for n=1,n do
local a=a[n]
local n=c
if d[a.HeroId]then
if t[6]>=RandomMgr:GetBattleRandom()then
local e=a.HeroBattleInfo:GetBuff(i)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(i)
local e=t.GetAccumulateDamage(e)
n=n+e
end
end
end
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(h)
e.DoActionBigSkill(o,a)
end
local t=ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,s,m,0,n)
if o then
local i=o:GetBuffData()
local t=t[3]
local o=t.reduceHpValue
local t=i[1]
if t>0 then
local t=math.floor(o*t*MillionCoe)
local e=u:AddSepsisHp(e,a,t)
if e then
if r then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(l)
e.AddMaxHpBySepsis(r,t)
end
end
end
end
end
return nil
end
return m 
