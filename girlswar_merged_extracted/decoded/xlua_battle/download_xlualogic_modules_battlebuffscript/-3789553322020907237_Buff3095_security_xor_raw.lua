local e={}
local s=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(o,e,t,a)
local n=e[1]
local i=e[2]
local e={e[3],e[4]}
o.CurrHeroCtrl:AddBuff(o.CurrHeroCtrl,n,i,e)
if o.CurrHeroCtrl.HeroId==a.HeroId then
if(a.FirstAtkSelfHeroId==0)then
a.FirstAtkSelfHeroId=t.HeroId
t:AddBuff(t,30361,-1,nil)
end
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.afterAttacked)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]
end
return s

