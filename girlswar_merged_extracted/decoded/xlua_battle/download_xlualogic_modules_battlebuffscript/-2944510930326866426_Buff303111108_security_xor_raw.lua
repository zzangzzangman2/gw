local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,a,o,t,i,i)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t.HeroId==e.releaseHeroId then
local t=HeroBuffValueInfo:New()
t.buffId=e.buffId
t.attrId=a[1]
t.value=a[2]
o.HeroBattleInfo:AddTempBuffValue(t)
e.CurrHeroCtrl:RealHurtWithBuff(a[3],e)
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.attack)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return i

