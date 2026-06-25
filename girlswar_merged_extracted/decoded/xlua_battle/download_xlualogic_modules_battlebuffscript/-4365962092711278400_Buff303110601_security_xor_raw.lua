local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,o,o,o,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[3],t[4])
elseif a.buffTriggerTime==BuffTriggerTime.eachRoundEnd then
local a=math.floor(e.CurrHeroCtrl.HeroBattleInfo.MaxHP*t[1]*MillionCoe)
a=math.min(a,t[2])
e.CurrHeroCtrl:RealHurtWithBuff(a,e)
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.eachRoundEnd)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return o

