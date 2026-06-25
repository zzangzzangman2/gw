local t=require("Modules/Battle/BattleBeforeData/CampainBBData")
local e={
}
function e:GetBattleBeforeDataScript(e)
if e==BattleType.campaign then
return t
end
end
function e:GetBattleBeforeData(o,t,a,i)
local e=e:GetBattleBeforeDataScript(o)
return e:GetBattleBeforeData(t,a,i)
end
return e 
