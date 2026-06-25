local r=require("Modules/Battle/BattleUtil")
local e={}
local c=e
function e.DoAction(e,h)
local t=e:JudgeSkillPreView(h)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
if(a==nil or#a<=0)then
return nil
end
e:ReduceFury(h.costMp)
e:RemoveOneBeans()
local l=t[1]
local u=t[3]*#a
local s=t[4]
local c=t[5]
local d={}
for e=6,9 do
table.insert(d,t[e])
end
local n={}
local i={}
local o={}
local m=#a
for h=1,m do
local a=a[h]
local e=r:GetHeroBuffFloor(e,s)
if e<t[10]then
table.insert(o,a)
end
n[a.HeroId]=0
i[a.HeroId]=0
end
for a=1,u do
if#o<=0 then
break
end
local h=RandomMgr:GetBattleRandomWithRange(1,#o)
local a=o[h]
local d=a:AddBuff(e,s,c,d)
local e=r:GetHeroBuffFloor(a,s)
n[a.HeroId]=n[a.HeroId]+e
if d then
i[a.HeroId]=i[a.HeroId]+1
end
if e>=t[10]then
table.remove(o,h)
end
end
e.HeroBattleInfo:DispelAllGranBuff(false)
local d=t[11]
local r=t[12]
local o={t[13],t[14]}
local s=303111719
local s=e.HeroBattleInfo:GetBuff(s)
if(s)then
local a=s:GetBuffData()
for e=4,9 do
table.insert(o,t[e])
end
for e=1,2 do
table.insert(o,a[e])
end
end
local r=e:AddBuff(e,d,r,o)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local s=303111716
local o=e.HeroBattleInfo:GetBuff(s)
if(o)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(s)
e.DoBeansActionBigSkill1(o,r)
e.DoBeansActionBigSkill2(o,i)
end
local o=e.HeroBattleInfo.MaxHP
local o=math.floor(o*t[15]*MillionCoe)
local t=#a
for t=1,t do
local t=a[t]
local a=o*n[t.HeroId]
local e=ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,h,l,0,a)
end
return nil
end
return c

