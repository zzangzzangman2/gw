local e={}
local i=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,a,t,o,o)
if(t.HeroBattleInfo:GetBuff(a[1]))then
local o={}
local t=HeroBuffValueInfo:New()
t.buffId=e.buffId
t.attrId=HeroAttrId.eXSkillINjureResRateAdd
t.value=a[2]
o[#o+1]=t
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
return o
end
return nil
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.sufferSkillDmg)then
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

