local e={}
local i=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(a,e,o,o,t)
if(t==nil or#t<=0)then
return
end
local o=t[1]
local t=t[2]
if(t==BuffRemoveType.Expire or t==BuffRemoveType.Dispel)then
if(o==e[1])then
local t=e[2]
local o=e[3]
local e={e[4]}
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
a.CurrHeroCtrl:AddBuff(a.CurrHeroCtrl,t,o,e)
end
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
return i

