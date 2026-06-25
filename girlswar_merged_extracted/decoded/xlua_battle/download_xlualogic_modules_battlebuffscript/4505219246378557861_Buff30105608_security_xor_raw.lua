local t={}
local s=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,o,a,n)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local o=e.CurrHeroCtrl.HeroId
if o==a.HeroId then
local i=t[1]
local o=t[2]
local s={0}
local a=1
local n=n.criticalOrBlock
if n==2 then
a=2
end
local t=t[3]
e.CurrHeroCtrl:AddBuffWithMaxFloor(e.CurrHeroCtrl,i,o,s,a,t)
end
return nil
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.afterAttacked)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.ConsumeAllFloor(t,o)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil then
return 0
end
local a=0
local e=t:GetBuffData()
local n=e[1]
local i=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(n)
if i then
a=i:GetFloors()
t.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(n,BuffRemoveType.Expire)
e[4]=e[4]+a
if e[4]>=o then
local i=e[5]
local n=e[6]
local s={0}
local a=math.floor(e[4]/o)
e[4]=e[4]-o*a
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,i,n,s,a)
end
end
return a
end
return s

