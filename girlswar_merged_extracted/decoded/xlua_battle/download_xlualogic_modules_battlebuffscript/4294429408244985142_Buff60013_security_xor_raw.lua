local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t)
if(e.CurrHeroCtrl.profession==ProfessionType.Tank)then
local a=t[1]
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,HeroAttrId.defRate,a)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
local t=t[2]
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,HeroAttrId.blockStrengthRateAdd,t)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
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
function t.GetWeight(t,a,e)
return t.buffWeight[1]*e[1]
end
return o

