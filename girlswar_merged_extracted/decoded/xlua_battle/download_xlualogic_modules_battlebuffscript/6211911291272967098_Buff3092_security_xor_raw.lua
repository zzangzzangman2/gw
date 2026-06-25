local e={}
local o=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(a,o)
if(a.CurrHeroCtrl.HeroBattleInfo:GetBuff(2028)~=nil)then
local t={}
local e=HeroBuffValueInfo:New()
e.buffId=a.buffId
e.attrId=HeroAttrId.eXSkillINjureResRateAdd
e.value=o[1]
t[#t+1]=e
return t
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
function e.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]
end
return o

