local e={}
local i=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(t,e)
local a=(t.CurrHeroCtrl.HeroBattleInfo.MaxHP-t.CurrHeroCtrl.HeroBattleInfo.CurrHP)/t.CurrHeroCtrl.HeroBattleInfo.MaxHP
a=math.min(a*OneMillion,e[1])
local o={}
local e=HeroBuffValueInfo:New()
e.buffId=t.buffId
e.attrId=HeroAttrId.injureRateAdd
e.value=a
o[#o+1]=e
return o
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.attack)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]
end
return i

