local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,a)
local t=(e.CurrHeroCtrl.HeroBattleInfo.MaxHP-e.CurrHeroCtrl.HeroBattleInfo.CurrHP)/e.CurrHeroCtrl.HeroBattleInfo.MaxHP
t=t*a[1]
t=math.floor(t)
local o={}
local a=HeroBuffValueInfo:New()
a.buffId=e.buffId
a.attrId=HeroAttrId.injureRateAdd
a.value=t
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
return o
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.attack)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]
end
return i

