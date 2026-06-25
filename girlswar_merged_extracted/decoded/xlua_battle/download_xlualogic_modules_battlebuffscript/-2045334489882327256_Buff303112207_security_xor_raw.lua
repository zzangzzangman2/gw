local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,a,i,i,i,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t.buffTriggerTime==BuffTriggerTime.eachRoundStart then
a[8]=0
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffValue(e.buffId,a[2])
return
elseif t.buffTriggerTime==BuffTriggerTime.skillPlayEnd
or t.buffTriggerTime==BuffTriggerTime.skill2PlayEnd
or t.buffTriggerTime==BuffTriggerTime.skill3PlayEnd then
o.ApplyEmptyMarkHurtAndInjureRes(e)
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.skillPlayEnd
or e==BuffTriggerTime.skill2PlayEnd
or e==BuffTriggerTime.skill3PlayEnd
or e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.ApplyEmptyMarkHurtAndInjureRes(e)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local t=e:GetBuffData()
local a=t[8]
t[8]=a+1
local o=math.max(t[3]+a*t[5],t[7])
e.CurrHeroCtrl.HeroBattleInfo:CheckAddBuffValue(e.buffId,t[2],o)
local t=math.min(t[1]+a*t[4],t[6])
local t=t*MillionCoe
local t=math.floor(e.CurrHeroCtrl:GetFinalAtk()*t)
if t>0 then
e.CurrHeroCtrl:RealHurtWithBuff(t,e)
end
end
return o

