local u=require("Modules/Battle/BattleUtil")
local e={
}
local c=e
function e.DoAction(e,i,t,t)
local t=e:JudgeSkillPreView(i)
local s=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(s==nil)then
return nil
end
local a={}
table.insert(a,s)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
e:ReduceFury(i.costMp)
local d=t[1]
local l=0
local o=303101209
local o=e.HeroBattleInfo:GetBuff(o)
if(o)then
local e=o:GetBuffData()
l=e[1]
end
local o=303101210
local n=e.HeroBattleInfo:GetBuff(o)
if(n)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(o)
e.ConsumeEnergyToAddHp(n)
end
local o=nil
local n=303101218
local n=e.HeroBattleInfo:GetBuff(n)
if(n)then
local e=n:GetBuffData()
o=e[1]
end
local h=0
local r=303101225
local n=e.HeroBattleInfo:GetBuff(r)
if(n)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(r)
local t=e.GetSkillRate(n,#a,31012303)
if t~=nil then
d=t
end
h=e.DoBuffWithBigSkill(n,a)
end
local c=t[3]
local m=t[4]
if o==nil then
o=t[5]
end
local l={o,l}
local r=t[6]
local o=t[7]
local n={t[8],t[9]}
e:AddBuff(e,r,o,n)
local r=t[10]
local n=t[11]
local o={t[12],t[13]}
e:AddBuff(e,r,n,o)
local o=t[14]
e:AddFuryWithSkill(o)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.ourAllExcludeSelf)
if(o~=nil)then
for o,a in ipairs(o)do
if(a.HeroId~=e.HeroId)then
a:AddFuryWithSkill(t[15])
end
end
end
local t=#a
s.HeroBattleInfo:DispelAllGranBuff(true,nil,e.HeroId)
for t=1,t do
local t=a[t]
t:AddBuff(e,c,m,l)
local a=ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,i,d,0,h)
local a=a[3]
local o=a.reduceHpValue
local a=303101201
local a=e.HeroBattleInfo:GetBuff(a)
if a then
local a=a:GetBuffData()
local a=a[5]
local a=math.floor(o*a*MillionCoe)
u:AddSepsisHp(e,t,a)
end
end
return nil
end
return c 
