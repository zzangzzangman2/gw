local h=require("Modules/Battle/BattleUtil")
local t={}
local n=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[3],t[4])
n.AddBuffSeed(e,e.CurrHeroCtrl)
n.AddBuffGrow(e,e.CurrHeroCtrl,t[10])
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.after)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.AddBuffSeed(t,i)
local a=t:GetBuffData()
local o=a[5]
local e=i.HeroBattleInfo:GetBuff(o)
if e==nil then
local n=a[6]
local e={}
for t=7,9 do
table.insert(e,a[t])
end
local a=43249
local a=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if a then
local t=a:GetBuffData()
for a=2,4 do
table.insert(e,t[a])
end
else
for t=2,4 do
table.insert(e,0)
end
end
table.insert(e,0)
i:AddBuff(t.CurrHeroCtrl,o,n,e)
end
end
function t.AddBuffGrow(a,t,o)
local e=a:GetBuffData()
local n={43246,43247,43248}
local i={}
for a=1,#n do
local a=n[a]
local t=t.HeroBattleInfo:GetBuff(a)
if t==nil or t:GetFloors()<e[23]then
table.insert(i,a)
end
end
if#i>0 then
local i=RandomTableWithSeed(i,1)
local i=i[1]
if i==43246 then
local s=e[11]
local n=e[12]
local i={}
for a=13,14 do
table.insert(i,e[a])
end
t:AddBuff(a.CurrHeroCtrl,s,n,i,o)
elseif i==43247 then
local s=e[15]
local n=e[16]
local i={}
for a=17,18 do
table.insert(i,e[a])
end
t:AddBuff(a.CurrHeroCtrl,s,n,i,o)
elseif i==43248 then
local n=e[19]
local s=e[20]
local i={}
for a=21,22 do
table.insert(i,e[a])
end
t:AddBuff(a.CurrHeroCtrl,n,s,i,o)
end
end
if t.HeroBattleInfo then
local e=math.floor(t.HeroBattleInfo.SepsisHp*e[24]*MillionCoe)
h:ReduceSepsisHp(a.CurrHeroCtrl,t,e,true,true)
end
end
return n

