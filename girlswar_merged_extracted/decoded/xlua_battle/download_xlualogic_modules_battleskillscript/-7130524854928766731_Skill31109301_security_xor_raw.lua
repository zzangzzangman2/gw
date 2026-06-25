local m=require("Modules/Battle/BattleUtil")
local e={
}
local f=e
function e.DoAction(t,d,e,e)
local e=t:JudgeSkillPreView(d)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(o==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(o)
t:ReduceFury(d.costMp)
local f=e[1]
local i=e[3]
local a=e[4]
local n={e[5],e[6]}
t:AddBuff(t,i,a,n)
local a=e[7]
local n=e[8]
local i={e[9],e[10]}
t:AddBuff(t,a,n,i)
local a=nil
local i=303110915
local i=t.HeroBattleInfo:GetBuff(i)
if i then
a=i:GetBuffData()
end
local h=e[14]
local n=e[16]
local c=e[18]
local i=e[20]
local l=e[22]
local r=e[23]
local s=true
if a then
h=a[1]
n=a[4]
c=a[2]
i=a[4]
l=a[3]
r=a[5]
if a[6]>RandomMgr:GetBattleRandom()then
s=false
end
end
local n=1
local u=303110901
local i=t.HeroBattleInfo:GetBuff(u)
if i then
local o=i:GetFloors()
local a=e[11]
if s==false or o>=a then
if s==true then
m:ReduceHeroBuffFloor(t,u,a)
end
n=n+e[12]
t:AddFuryWithSkill(e[13])
end
end
local s=table.lightCopyList(o)
local s=RandomTableWithSeed(s,h)
for a=1,#s do
local a=s[a]
local s=e[15]
local i=e[16]
local o={e[17],c}
a:AddBuffWithMaxFloor(t,s,i,o,n,r)
local i=e[19]
local o=e[20]
local e={e[21],l}
a:AddBuffWithMaxFloor(t,i,o,e,n,r)
end
local e=#o
for e=1,e do
local e=o[e]
local o=0
if a then
h=a[1]
local n=303110907
local n=e.HeroBattleInfo:GetBuff(n)
if n then
if i then
local e=i:GetFloors()
if a[7]*e>RandomMgr:GetBattleRandom()then
t.IgnoreBlock=true
t.IgnoreInjureRes=true
end
end
if e:CurrHPPer()<a[8]*MillionCoe then
e.HeroBattleInfo:DispelGranBuff(true,a[9])
local e=t:GetFinalAtk()
o=e*a[10]*MillionCoe
end
end
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,d,f,0,o)
t.IgnoreBlock=false
t.IgnoreInjureRes=false
end
return nil
end
return f 
