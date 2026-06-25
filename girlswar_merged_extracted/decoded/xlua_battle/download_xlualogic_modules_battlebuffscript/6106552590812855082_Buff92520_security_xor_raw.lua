local t={}
local a=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,o,n,s,i)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if i.buffTriggerTime==BuffTriggerTime.now then
a.AddBuffIceGuard(e,t,t[1])
elseif i.buffTriggerTime==BuffTriggerTime.eachRoundStart then
a.AddBuffIceGuard(e,t,t[8])
elseif i.buffTriggerTime==BuffTriggerTime.afterAttacked then
if o==nil or n==nil then
return
end
if e.CurrHeroCtrl.HeroId==n.HeroId then
if o:IsPet()==false then
if t[9]>=RandomMgr:GetBattleRandom()then
a.AddBuffIceBloodline(e,t,o)
end
end
end
end
end
function t.GetCanTrigger(e)
if e==BuffTriggerTime.now
or e==BuffTriggerTime.eachRoundStart
or e==BuffTriggerTime.afterAttacked then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.AddBuffIceGuard(a,e,t)
local i=e[2]
local o=e[3]
local n=t
local t={}
for a=4,7 do
table.insert(t,e[a])
end
table.insert(t,e[4])
a.CurrHeroCtrl:AddBuff(a.CurrHeroCtrl,i,o,t,n)
end
function t.AddBuffIceBloodline(t,e,a)
local o=e[10]
local i=e[11]
local n=t.CurrHeroCtrl
local t=math.floor(n:GetFinalAtk()*e[12]*MillionCoe)
local e=a.HeroBattleInfo:GetBuff(o)
if e then
local a=e:GetBuffData()
if t>a[1]then
a[1]=t
end
e:SetRound(i)
return
end
local e={}
table.insert(e,t)
table.insert(e,0)
a:AddBuff(n,o,i,e)
end
return a

