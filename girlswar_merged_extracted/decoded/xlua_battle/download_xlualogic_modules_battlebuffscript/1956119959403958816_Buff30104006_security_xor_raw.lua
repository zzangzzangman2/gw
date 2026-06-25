local e={}
local a=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(a,t,e,o)
if e and e.HeroBattleInfo:GetBuff(t[1])~=nil then
a.CurrHeroCtrl:AddFuryWithBuff(t[2])
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.attacked)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
return a

