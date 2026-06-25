local a={}
local o=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,o,o,o,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
if#t>=2 then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
end
elseif a.buffTriggerTime==BuffTriggerTime.eachRoundEnd then
if#t>=4 then
local a=e.CurrHeroCtrl.HeroBattleInfo:GetMaxHP()*t[3]*MillionCoe
local t=t[4]
a=math.min(a,t)
e.CurrHeroCtrl:RealHurtWithBuff(a,e)
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now or e==BuffTriggerTime.eachRoundEnd)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return o

