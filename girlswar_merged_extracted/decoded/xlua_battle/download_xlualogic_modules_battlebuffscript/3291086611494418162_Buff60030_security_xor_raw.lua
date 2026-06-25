local t={}
local n=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,a)
local t=a[1]
local o=ModulesInit.ProcedureNormalBattle.GetRelicCountWithColor(t)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if(o>0)then
local t=a[2]
local i=a[3]
local t=t*o
t=math.min(t,i)
if(t>0)then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,HeroAttrId.defRate,t)
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
local t=a[2]
local a=a[3]
local t=t*o
t=math.min(t,a)
if(t>0)then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,HeroAttrId.atkRate,t)
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
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

