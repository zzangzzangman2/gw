local o={}
local h=o
function o.GetCanAdd(e,e)
return true
end
function o.DoAction(t,e,a,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
local s=e[1]
local n=e[2]
local a={}
local o=e[11]*MillionCoe
local i=302107823
local i=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(i)
if i then
local e=i:GetBuffData()
o=e[11]*MillionCoe
end
for t=3,5 do
table.insert(a,e[t])
end
table.insert(a,math.floor(e[6]*o))
for t=7,8 do
table.insert(a,e[t])
end
table.insert(a,math.floor(e[9]*o))
table.insert(a,e[10])
t.CurrHeroCtrl:AddTeamBuff(t.CurrHeroCtrl,s,n,a)
t.isExec=true
end
function o.GetCanTrigger(e)
if(e==BuffTriggerTime.HeroDead)then
return true
end
return false
end
function o.SetLogicData(e,e)
end
return h

