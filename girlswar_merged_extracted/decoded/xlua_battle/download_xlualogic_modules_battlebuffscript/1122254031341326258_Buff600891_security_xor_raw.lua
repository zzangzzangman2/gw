local t={}
local a=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t)
local t=t[1]*MillionCoe
local t=math.floor(e.MaxHP*t)
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,HeroAttrId.shield,t)
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
function t.SetLogicData(t,e)
t.MaxHP=e.HeroBattleInfo.MaxHP
end
function t.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]
end
return a

