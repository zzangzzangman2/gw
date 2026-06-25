local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t)
local a=t[1]
local t=t[2]
if(a>0)then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,HeroAttrId.injureRateAdd,a)
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if(t>0)then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,HeroAttrId.blockResRateAdd,t)
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.isExec=true
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
return o

