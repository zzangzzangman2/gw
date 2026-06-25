local e={}
local i=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(t,o,a,i,e)
if(e)then
local e=e*o[1]*MillionCoe
e=math.floor(e)
local a=a.CurrBattleTeam:GetOneRandomHeroExcludeHeroId(a.HeroId)
if(a)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
a:RealHurtWithBuff(e,t,true)
end
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.lastHurtPoint or e==BuffTriggerTime.realHurtWithBuff)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.GetWeight(t,a,e)
return t.buffWeight[1]*e[1]
end
return i

