local t={}
local n=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(a,e,t,t)
if(ModulesInit.ProcedureNormalBattle.BattleType==BattleType.dragonWar)then
local o=e[1]
local i=e[2]
local t={}
local e=HeroBuffValueInfo:New()
e.buffId=a.buffId
e.attrId=HeroAttrId.injureRateAdd
e.value=o
t[#t+1]=e
e=HeroBuffValueInfo:New()
e.buffId=a.buffId
e.attrId=HeroAttrId.injureResRateAdd
e.value=i
t[#t+1]=e
return t
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.attack or e==BuffTriggerTime.attacked)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]+e.buffWeight[2]*t[2]
end
return n

