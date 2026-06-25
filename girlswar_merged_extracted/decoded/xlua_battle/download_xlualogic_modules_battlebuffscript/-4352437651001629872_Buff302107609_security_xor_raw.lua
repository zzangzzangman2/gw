local t=require("Modules/Battle/BattleUtil")
local e={}
local o=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(a,e)
t:ShowCampionEffect(a,e[2])
end
function e.OnRemoveSelf(e,a)
t:HideCampionEffect(e)
end
function e.DoAction(e,e)
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.GetWeight(e,e,e)
return 1
end
return o 
