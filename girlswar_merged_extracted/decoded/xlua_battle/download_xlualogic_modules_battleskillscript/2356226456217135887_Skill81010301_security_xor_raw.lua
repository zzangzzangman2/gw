local d=require("Modules/Battle/BattleUtil")
local h={
}
local u=h
function h.DoAction(t,r,a)
local e=t:JudgeSkillPreView(r)
local n=false
if a and a.isSingle~=nil then
n=a.isSingle
end
local s=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(s==nil)then
return nil
end
local h=#s
if h<=0 then
return nil
end
local a=e[7]
if n==false then
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAll)
local i={}
for t=1,#o do
local o=o[t]
local t=o.HeroBattleInfo:GetBuff(a)
if t==nil or t:GetFloors()<e[16]then
table.insert(i,o)
end
end
local o=RandomTableWithSeed(i,e[2])
for i=1,#o do
local o=o[i]
if o then
local s=e[8]
local i={}
for t=9,17 do
table.insert(i,e[t])
end
table.insert(i,nil)
local e=e[6]
local n=o.HeroBattleInfo:GetBuff(a)
if n then
n:AddFloors(e)
else
o:AddBuff(t,a,s,i,e)
end
end
end
end
local i=1
if n==false then
local t,e=d:GetHeroNoBuffByType(t,BattleHeroType.ourAll,a)
i=#e+h
end
local o={}
for e=1,i do
local e=table.lightCopyList(s)
local e=RandomTableWithSeed(e,1)
table.insert(o,e[1])
end
local a={}
local i={}
for t=1,#o do
local e=o[t].HeroId
if a[e]==nil then
a[e]=0
table.insert(i,o[t])
end
a[e]=a[e]+1
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(i)
local o=308101003
local s=t.HeroBattleInfo:GetBuff(o)
local h=ModulesInit.BattleBuffMgr.GetBuffScript(o)
local o=t:GetFinalAtk()
local d=math.floor(o*e[19]*MillionCoe)
local l=e[1]
local o=#i
for o=1,o do
local n=i[o]
local o=n.HeroId
local i=0
if a[o]~=nil then
i=a[o]
end
local a=0
for t=1,i do
local t=h.GetDamageCount(s,o)
local e=l+t*e[5]
a=a+e
h.AddDamageCount(s,o,1)
end
local o=n.HeroBattleInfo:GetMaxHP()
local e=math.floor(o*e[18]*MillionCoe)
e=math.min(e,d)*i
ModulesInit.ProcedureNormalBattle.SkillHurt(t,n,r,a,0,e)
end
return nil
end
function h.DoPassiveAction(t,e)
local e=t:JudgeSkillPreView(e)
local a=e[3]
local o=e[4]
local e={}
table.insert(e,{})
table.insert(e,0)
t:AddBuff(t,a,o,e)
return nil
end
return u 
