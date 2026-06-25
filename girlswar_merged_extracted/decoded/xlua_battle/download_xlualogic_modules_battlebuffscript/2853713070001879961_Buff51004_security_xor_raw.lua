local e={}
local n=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(n,e,a,t,a)
local i=e[1]
local a=e[2]
local o=e[3]
local e={e[4]}
if(t)then
if(t:CurrHPPer()<i*MillionCoe)then
t:AddBuff(n.CurrHeroCtrl,a,o,e)
end
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.hpHealthWith1004)then
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

