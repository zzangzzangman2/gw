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
e.CurrHeroCtrl:HpHealthWithBuffImmediately(a,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
local a=t[3]
local o=t[4]
local t={t[5]}
if(a and o)then
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,o,t)
end
e.isExec=true
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.hpDown)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]+e.buffWeight[2]*t[2]
end
return i

