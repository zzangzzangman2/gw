local e={}
local i=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,a,o,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if(o.profession==a[1])then
local t=HeroBuffValueInfo:New()
t.buffId=e.buffId
t.attrId=a[2]
t.value=a[3]
o.HeroBattleInfo:AddTempBuffValue(t)
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.attacked)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
return i

