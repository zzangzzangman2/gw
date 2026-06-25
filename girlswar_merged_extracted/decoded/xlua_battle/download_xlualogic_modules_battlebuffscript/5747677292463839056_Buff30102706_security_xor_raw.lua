local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,a,t,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local t=t.HeroBattleInfo:GetBuff(a[1])
if t then
local t=HeroBuffValueInfo:New()
t.buffId=e.buffId
t.attrId=a[2]
t.value=a[3]
e.CurrHeroCtrl.HeroBattleInfo:AddTempBuffValue(t)
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.attacked)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return o

