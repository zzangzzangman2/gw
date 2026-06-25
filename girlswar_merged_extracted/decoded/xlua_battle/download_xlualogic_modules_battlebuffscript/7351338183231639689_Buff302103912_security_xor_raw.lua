local t=require("Modules/Battle/BattleUtil")
local e={}
local a=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,a)
e.CurrHeroCtrl:AddImmunneBuffId(3011)
t:AddImmuneDebuffDizzy(e.CurrHeroCtrl)
end
function e.OnRemoveSelf(e,a)
e.CurrHeroCtrl:ReduceImmunneBuffId(3011)
t:ReduceImmuneDebuffDizzy(e.CurrHeroCtrl)
end
function e.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
return a

