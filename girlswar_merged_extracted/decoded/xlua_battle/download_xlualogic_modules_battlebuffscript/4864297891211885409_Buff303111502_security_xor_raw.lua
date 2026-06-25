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
if#t>=2 then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
end
elseif a.buffTriggerTime==BuffTriggerTime.eachRoundEnd then
local a=e:GetFloors()
e.CurrHeroCtrl:RealHurtWithBuff(t[3]*a,e)
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

