local e={}
local i=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,e,e,e,e)
end
function e.GetCanTrigger(e)
return false
end
function e.SetLogicData(e,e)
end
function e.GetBuffValue(t,a)
local o=t.HeroBattleInfo:GetBuff(30102003)
local e
if o then
e=o:GetBuffData()
end
e=e or{}
local o=t:GetFinalAtk()
local e={a[6],a[7],math.floor(o),t:GetHeroId(),e[1],e[2],e[3],e[4],e[5]}
return e
end
return i

