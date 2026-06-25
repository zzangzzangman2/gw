local e={}
local t=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
GameInit.LogError("Buff3104 heroBuffInfo or heroBuffInfo.CurrHeroCtrl == nil")
return
end
e.CurrHeroCtrl:AddExtraSoulMap(EBattleSoulId.Soul1120,3104)
e.isExec=true
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.GetWeight(e,t,t)
return e.buffWeight[1]
end
return t

