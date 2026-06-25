local t={}
local n=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(o,e,t,a)
local o=e[1]
if(o>=RandomMgr:GetBattleRandom())then
if(t.HeroBattleInfo:IsExistsSkill(1012302))then
local i=e[5]
local o=e[6]
local e={e[7]}
a:AddBuff(t,i,o,e)
else
local i=e[2]
local o=e[3]
local e={e[4]}
a:AddBuff(t,i,o,e)
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.normalAttack or e==BuffTriggerTime.skill2Attack)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]
end
return n

