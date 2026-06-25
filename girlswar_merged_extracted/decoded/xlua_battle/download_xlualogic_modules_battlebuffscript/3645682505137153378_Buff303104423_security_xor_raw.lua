local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,i,o,i,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
elseif a.buffTriggerTime==BuffTriggerTime.attack then
local a=HeroBuffValueInfo:New()
a.buffId=e.buffId
a.attrId=t[3]
a.value=t[4]
o.HeroBattleInfo:AddTempBuffValue(a)
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.attack)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return i

