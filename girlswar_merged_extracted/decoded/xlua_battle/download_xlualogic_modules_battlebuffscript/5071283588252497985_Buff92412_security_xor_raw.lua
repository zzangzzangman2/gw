local e={}
local t=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,t)
e.CurrHeroCtrl:AddDisableBlock(e.buffId)
end
function e.OnRemoveSelf(e,t)
e.CurrHeroCtrl:RefreshDisableBlock()
end
function e.DoAction(e,t,t,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
end
function e.GetCanTrigger(e)
return false
end
function e.SetLogicData(e,e)
end
return t

