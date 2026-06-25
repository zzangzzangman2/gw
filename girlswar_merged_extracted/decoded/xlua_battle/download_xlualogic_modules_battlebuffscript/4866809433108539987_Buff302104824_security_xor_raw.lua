local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(a,e,o,t)
if a==nil then
return
end
local a=e[6]
if a[t.battleStationIndex]then
local a=e[1]
local i=e[2]
local o=e[3]
local e={e[4],e[5]}
t:CheckAddBuff(a,t,i,o,e)
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.addMyMate)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return i

