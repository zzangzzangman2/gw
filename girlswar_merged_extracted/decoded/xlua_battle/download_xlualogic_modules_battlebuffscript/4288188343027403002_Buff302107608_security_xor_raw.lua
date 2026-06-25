local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,a,o,o,o,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t.buffTriggerTime==BuffTriggerTime.eachRoundStart then
e.CurrHeroCtrl:AddFuryWithBuff(a[1])
e.CurrHeroCtrl.HeroBattleInfo:PlayBattleEffectWithType(BattleEffectType.AddFury)
e.CurrHeroCtrl.HeroBattleInfo:DispelAllGranBuff(false)
elseif t.buffTriggerTime==BuffTriggerTime.eachRoundEnd then
local t=a[2]*MillionCoe
local t=e.CurrHeroCtrl.HeroBattleInfo.MaxHP*t
e.CurrHeroCtrl:HpHealthWithBuffImmediately(t,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
end
end
function t.GetCanTrigger(e)
if e==BuffTriggerTime.eachRoundStart or e==BuffTriggerTime.eachRoundEnd then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return o

