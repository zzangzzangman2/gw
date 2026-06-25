local e={}
local i=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(t,o)
local e=t.CurrHeroCtrl.CurrBattleTeam:GetAllHeros()
for a,e in ipairs(e)do
local a=o[1]
if(a>0)then
e.HeroBattleInfo:AddBuffValue(t.buffId,HeroAttrId.atkRate,a)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
local a=o[2]
if(a>0)then
e.HeroBattleInfo:AddBuffValue(t.buffId,HeroAttrId.defRate,a)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.realKill)then
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

