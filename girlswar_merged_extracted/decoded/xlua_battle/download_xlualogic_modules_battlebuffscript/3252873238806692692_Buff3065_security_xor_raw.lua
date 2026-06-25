local e={}
local i=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(t,e,a,a,a)
local o=e[1]
local a=e[2]
local e={e[3]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,a,e)
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.firstBigSkillEnd)then
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

