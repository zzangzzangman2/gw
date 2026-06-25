local e={}
local t=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,t)
e.CurrHeroCtrl:AddForbidHeal(e.buffId)
end
function e.OnRemoveSelf(e,t)
e.CurrHeroCtrl:RefreshForbidHeal()
end
function e.DoAction(e,t,a,a,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.CurrHeroCtrl:RealHurtWithBuff(t[1],e)
return nil
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundEnd)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
return t

