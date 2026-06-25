local e={}
local i=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,e)
end
function e.OnRemoveSelf(e,e)
end
function e.DoAction(e,t,o,a)
local o=t[1]
local i=e.CurrHeroCtrl.CurrBattleTeam.OpponentTeam:GetAllHerosCount()
local i=6-i
local t=t[3]*i
local t=o+t
if(t>=RandomMgr:GetBattleRandom())then
local t={3001,3002,3003,3010,3011}
local o=RandomMgr:GetBattleRandomWithRange(1,#t)
local t=t[o]
a:AddBuff(a,t,1,nil)
e.IsTriggerControl=true
end
return nil
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
return e.buffWeight[1]*t[1]+e.buffWeight[2]*t[2]+e.buffWeight[3]*t[3]
end
return i

