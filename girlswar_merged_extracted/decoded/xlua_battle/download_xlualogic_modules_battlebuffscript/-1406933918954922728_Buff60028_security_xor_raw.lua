local e={}
local n=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t)
local i=t[1]
local a=1
local o=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(60029)
if(o)then
a=t[2]*MillionCoe
end
local o={}
local t=HeroBuffValueInfo:New()
t.buffId=e.buffId
t.attrId=HeroAttrId.ProfResRateAdd
t.value=i*a
o[#o+1]=t
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
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
return n

