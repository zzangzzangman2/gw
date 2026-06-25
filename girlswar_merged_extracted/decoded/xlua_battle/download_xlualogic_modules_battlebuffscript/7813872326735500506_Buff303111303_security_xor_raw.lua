local e={}
local i=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,t)
e.CurrHeroCtrl:SetForceAttackHeroId(e.releaseHeroId)
end
function e.OnRemoveSelf(e,t)
e.CurrHeroCtrl:SetForceAttackHeroId(0)
end
function e.DoAction(e,t,o,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local a=HeroBuffValueInfo:New()
a.buffId=e.buffId
a.attrId=t[1]
a.value=t[2]
o.HeroBattleInfo:AddTempBuffValue(a)
local a=HeroBuffValueInfo:New()
a.buffId=e.buffId
a.attrId=t[3]
a.value=t[4]
o.HeroBattleInfo:AddTempBuffValue(a)
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.attack)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
return i

