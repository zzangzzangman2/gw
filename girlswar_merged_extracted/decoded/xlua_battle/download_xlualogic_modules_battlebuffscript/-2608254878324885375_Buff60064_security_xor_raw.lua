local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t)
local o=t[1]*MillionCoe
local a=t[2]*MillionCoe
if(e.CurrHeroCtrl:CurrHPPer()<o and e.CurrHeroCtrl.HeroBattleInfo.CurrHP>0)then
local a=e.CurrHeroCtrl.HeroBattleInfo.MaxHP*a
a=math.floor(a)
e.CurrHeroCtrl:HpHealthWithBuffImmediately(a,EBattleSrcType.Relic,e.releaseHeroId,e.buffId)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
local a=t[3]
local o=t[4]
local t={t[5]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,o,t)
e.isExec=true
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.hpDown or e==BuffTriggerTime.now)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.GetWeight(t,a,e)
return t.buffWeight[1]*e[1]
end
return i

