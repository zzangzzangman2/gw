local n=require("Modules/Battle/BattleUtil")
local o={
}
local h=o
function o.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
local a=n:GetMaxFuryHeroArrByHeroArr(a,1)
local a=a[1]
if(a==nil)then
return
end
local s=e[1]
local n=e[4]
local h=e[5]
local o={}
for t=6,11 do
table.insert(o,e[t])
end
local r=e[3]
a:AddBuff(t,n,h,o,r)
local n=a.HeroBattleInfo.CurrFury
a:ReduceFuryWithBuffImmediately(e[12],t)
local o=a.HeroBattleInfo.CurrFury
local h=n-o
local o=a.HeroBattleInfo.MaxHP
local o=math.floor(o*e[13]*MillionCoe)
local n=t:GetFinalAtk()
local n=math.floor(n*e[14]*MillionCoe)
o=math.min(o,n)
if e[15]~=nil then
local a=308201106
local a=t.HeroBattleInfo:GetBuff(a)
if a then
local a=a:GetBuffData()
a[1]=a[1]+h
if a[1]>=e[17]then
a[1]=a[1]-e[17]
local o=e[7]
local i=e[8]
local a={}
for t=9,11 do
table.insert(a,e[t])
end
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eRandom,e[18])
if(e~=nil)then
for n,e in ipairs(e)do
e:AddBuff(t,o,i,a)
end
end
end
end
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,s,0,o)
return nil
end
function o.DoPassiveAction(t,e)
local e=t:JudgeSkillPreView(e)
if e[15]~=nil then
local a=e[15]
local o=e[16]
local e={}
table.insert(e,0)
t:AddBuff(t,a,o,e)
end
return nil
end
return h 
