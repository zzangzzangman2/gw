local r=require("Modules/Battle/BattleUtil")
local e={
}
local c=e
function e.DoAction(t,s,e,e)
local e=t:JudgeSkillPreView(s)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a==nil or#a<=0)then
return nil
end
t:ReduceFury(s.costMp)
local u=e[1]
local l=e[3]*#a
local n=e[4]
local c=e[5]
local d={}
for t=6,9 do
table.insert(d,e[t])
end
local h={}
local i={}
local o={}
local m=#a
for s=1,m do
local a=a[s]
local t=r:GetHeroBuffFloor(t,n)
if t<e[10]then
table.insert(o,a)
end
h[a.HeroId]=0
i[a.HeroId]=0
end
for a=1,l do
if#o<=0 then
break
end
local s=RandomMgr:GetBattleRandomWithRange(1,#o)
local a=o[s]
local d=a:AddBuff(t,n,c,d)
local t=r:GetHeroBuffFloor(a,n)
h[a.HeroId]=h[a.HeroId]+t
if d then
i[a.HeroId]=i[a.HeroId]+1
end
if t>=e[10]then
table.remove(o,s)
end
end
t.HeroBattleInfo:DispelAllGranBuff(false)
local r=e[11]
local h=e[12]
local o={e[13],e[14]}
local n=303111719
local n=t.HeroBattleInfo:GetBuff(n)
if(n)then
local t=n:GetBuffData()
for t=4,9 do
table.insert(o,e[t])
end
for e=1,2 do
table.insert(o,t[e])
end
end
local n=t:AddBuff(t,r,h,o)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local o=303111716
local e=t.HeroBattleInfo:GetBuff(o)
if(e)then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(o)
t.DoBeansActionBigSkill1(e,n)
t.DoBeansActionBigSkill2(e,i)
end
local e=#a
for e=1,e do
local e=a[e]
local a=0
local e=ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,s,u,0,a)
end
return nil
end
return c 
