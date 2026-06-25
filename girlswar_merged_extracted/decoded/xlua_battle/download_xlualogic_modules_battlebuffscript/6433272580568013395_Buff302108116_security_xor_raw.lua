local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local a=t[1]
if e.CurrHeroCtrl:CurrHPPer()<t[2]*MillionCoe then
a=t[3]
end
local t=e.CurrHeroCtrl.HeroBattleInfo:GetMaxHP()
local t=t*a*MillionCoe
e.CurrHeroCtrl:HpHealthWithBuffImmediately(t,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundStart or e==BuffTriggerTime.eachRoundEnd)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return o

