local t={}
local a=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t)
if(ModulesInit.MazeMgr:IsEliteLayer())then
local t=t[1]
if(t>0)then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,HeroAttrId.atkRate,t)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,HeroAttrId.defRate,t)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
local t=t*MillionCoe
if(t>0)then
e.CurrHeroCtrl.HeroBattleInfo:AddHPAndMaxHPPer(t)
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
e.isExec=true
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
return a

