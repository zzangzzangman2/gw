local e={}
local t=e
function e.OnAdd(e,t)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.CurrHeroCtrl:AddImmuneDebuff(e.buffId)
end
function e.OnRemoveSelf(e,t)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.CurrHeroCtrl:RefreshImmuneDebuff()
end
function e.OnOverlap(e,e)
end
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,e)
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.GetWeight(e,t,t)
return e.buffWeight[1]
end
return t

