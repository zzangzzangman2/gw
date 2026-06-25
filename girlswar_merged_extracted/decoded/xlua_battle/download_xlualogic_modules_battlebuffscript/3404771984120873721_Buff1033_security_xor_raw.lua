local e={}
local a=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t)
local t=t[1]*MillionCoe
local t=math.floor(e.MaxHP*t)
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,HeroAttrId.shield,t)
e.isExec=true
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,t)
e.MaxHP=t.HeroBattleInfo.MaxHP
end
function e.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]
end
return a

