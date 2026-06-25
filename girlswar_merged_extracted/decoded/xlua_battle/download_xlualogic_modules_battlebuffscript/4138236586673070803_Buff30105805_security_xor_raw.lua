local a={}
local i=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,a,a,a,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if o.buffTriggerTime==BuffTriggerTime.attacked then
local a=e.CurrHeroCtrl
if a:CurrHPPer()<t[1]*MillionCoe then
if t[4]<t[3]then
local o=a.HeroBattleInfo:GetMaxHP()-a.HeroBattleInfo:GetCurrHP()
local o=o*t[2]*MillionCoe
a:HpHealthWithBuffImmediately(o,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
t[4]=t[4]+1
end
end
elseif o.buffTriggerTime==BuffTriggerTime.eachRoundStart then
t[4]=0
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.attacked or e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return i

