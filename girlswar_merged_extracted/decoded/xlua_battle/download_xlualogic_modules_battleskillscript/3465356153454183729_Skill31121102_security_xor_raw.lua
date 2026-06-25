local o=require("Modules/Battle/BattleUtil")
local e={
}
local l=e
function e.DoAction(e,h,a)
local t=e:JudgeSkillPreView(h)
local t=nil
if a then
t=a.skillParam
end
if t==nil then
return nil
end
local a=303112106
local s=o:GetHeroBuffFloor(e,a)
if s<=0 then
return nil
end
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.ourAll)
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
local o={}
table.appendList(o,a)
table.appendList(o,i)
local n={}
local i={}
local a={}
local r=#o
for e=1,s do
local e=RandomMgr:GetBattleRandomWithRange(1,r)
local e=o[e]
if e then
if a[e.HeroId]==nil then
a[e.HeroId]=1
else
a[e.HeroId]=1+a[e.HeroId]
end
end
end
for t=1,#o do
local t=o[t]
if a[t.HeroId]then
if t.IsOurHero==e.IsOurHero then
table.insert(n,t)
else
table.insert(i,t)
end
end
end
if#n>0 then
local t=303112123
local a=1
local o={}
e:AddBuff(e,t,a,o)
end
if#i>0 then
local o=303112124
local t=1
local a={}
e:AddBuff(e,o,t,a)
end
local d=t[7]
local r=t[8]
local s={t[9],t[10]}
for o=1,#n do
local o=n[o]
local a=a[o.HeroId]
o:AddBuff(e,d,r,s,a)
local i=o.HeroBattleInfo.MaxHP
local t=math.floor(i*t[6]*a*MillionCoe)
o:HpHealthWithBuffImmediately(t,EBattleSrcType.Buff,e.HeroId,303112118)
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(i)
local o=t[1]
local r=t[2]
local s=t[3]
local n={t[4],t[5]}
local t=#i
for t=1,t do
local t=i[t]
local a=a[t.HeroId]
t:AddBuff(e,r,s,n,a)
local e=ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,h,o*a)
end
end
return l 
