local a={}
local s=a
function a.GetCanAdd(e,e)
return true
end
function a.OnAdd(e,e)
end
function a.OnRemoveSelf(e,t)
local t=t[10]*MillionCoe
local t=e.CurrHeroCtrl.HeroBattleInfo.MaxHP*t
e.CurrHeroCtrl:HpHealthWithBuffImmediately(t,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
end
function a.DoAction(t,e,a,i,i,o)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if o.buffTriggerTime==BuffTriggerTime.now then
if#e>=2 then
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[1],e[2])
end
elseif o.buffTriggerTime==BuffTriggerTime.attacked then
if a and a.HeroBattleInfo and#e>=9 then
local i=e[3]
local o=e[4]
local n=e[5]
local e={t.CurrHeroCtrl.HeroId,e[6],e[7],e[8],e[9]}
local e=a:CheckAddBuff(i,t.CurrHeroCtrl,o,n,e)
if e then
if a.HeroBattleInfo then
a.HeroBattleInfo:PlayBattleEffectWithBuffId(o)
end
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.attacked)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return s

