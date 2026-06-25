local e={}
local t=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,t)
e.CurrHeroCtrl:AddDisableOtherHeal(e.buffId)
e.CurrHeroCtrl:AddDisableOtherShield(e.buffId)
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,HeroAttrId.zeroHurt,t[1])
end
function e.OnRemoveSelf(e,t)
e.CurrHeroCtrl:RefreshDisableOtherHeal()
e.CurrHeroCtrl:RefreshDisableOtherShield()
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
function e.isZeroHurt(e)
local e=e:GetBuffData()
if(e[1]>=RandomMgr:GetBattleRandom())then
return true
end
return false
end
return t

