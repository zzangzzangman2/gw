local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,o)
local t=e.CurrHeroCtrl.CurrBattleTeam:GetAllHeros()
for a,t in ipairs(t)do
local a=o[1]
if(a>0)then
t.HeroBattleInfo:AddBuffValue(e.buffId,HeroAttrId.atkRate,a)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
local a=o[2]
if(a>0)then
t.HeroBattleInfo:AddBuffValue(e.buffId,HeroAttrId.defRate,a)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.HeroDead)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]
end
return i

