local e={}
local t=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,t)
local t=math.floor(e.CurrHeroCtrl.HeroBattleInfo.CurrMaxHP*t[1]*MillionCoe)
e.CurrHeroCtrl:AddImmuneSepsisHp(e.buffId,0,t)
end
function e.OnRemoveSelf(e,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
e.CurrHeroCtrl:ReduceImmuneSepsisHp(e.buffId)
end
function e.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.isExec=true
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
return t

