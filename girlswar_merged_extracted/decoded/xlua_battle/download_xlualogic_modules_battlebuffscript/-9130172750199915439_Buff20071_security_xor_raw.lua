local e={}
local a=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(a,t,o,o,e)
if(e==nil or#e<=0)then
return
end
local e=e[1]
if(e==t[1]or e==t[2])then
a.CurrHeroCtrl:AddFuryWithBuff(t[3])
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.removeBuff)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]
end
return a

