local i=require("Modules/Battle/BattleUtil")
local e={}
local c=e
function e.DoAction(e,s)
local t=e:JudgeSkillPreView(s)
local n=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(n==nil)then
return nil
end
local a={}
table.insert(a,n)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
e:ReduceFury(s.costMp)
e:RemoveOneBeans()
local u=t[1]
local l=0
local o=303101209
local o=e.HeroBattleInfo:GetBuff(o)
if(o)then
local e=o:GetBuffData()
l=e[1]
end
local o=303101210
local h=e.HeroBattleInfo:GetBuff(o)
if(h)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(o)
e.ConsumeEnergyToAddHp(h)
end
local o=nil
local h=303101218
local h=e.HeroBattleInfo:GetBuff(h)
if(h)then
local e=h:GetBuffData()
o=e[1]
end
local d=0
local r=303101225
local h=e.HeroBattleInfo:GetBuff(r)
if(h)then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(r)
local e=t.GetSkillRate(h,#a,31012321)
if e~=nil then
u=e
end
d=t.DoBuffWithBigSkill(h,a)
end
local h=t[3]
local r=t[4]
if o==nil then
o=t[5]
end
local c={o,l}
local l=t[6]
local o=t[7]
local m={t[8],t[9]}
e:AddBuff(e,l,o,m)
local m=t[10]
local l=t[11]
local o={t[12],t[13]}
e:AddBuff(e,m,l,o)
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
local o=#a
n.HeroBattleInfo:DispelAllGranBuff(true,nil,e.HeroId)
for t=1,o do
local t=a[t]
t:AddBuff(e,h,r,c)
local a=ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,s,u,0,d)
local a=a[3]
local o=a.reduceHpValue
local a=303101201
local a=e.HeroBattleInfo:GetBuff(a)
if a then
local a=a:GetBuffData()
local a=a[5]
local a=math.floor(o*a*MillionCoe)
i:AddSepsisHp(e,t,a)
end
end
local a=303101229
local o=e.HeroBattleInfo:GetBuff(a)
if(o)then
local s=ModulesInit.BattleBuffMgr.GetBuffScript(a)
local n=303101233
local a=i:GetHeroListBuffFloor(e,BattleHeroType.enemyAll,n,true,t[16])
for h=1,#a do
local a=a[h].enemy
s.AddBuffWireRestraint(o,a,t[17])
if i:GetHeroBuffFloor(a,n)>=t[18]then
local o=t[19]
local i=t[20]
local t={}
a:AddBuff(e,o,i,t)
end
end
end
return nil
end
return c

