local o={}
local i=o
function o.GetCanAdd(e,e)
return true
end
function o.DoAction(a,e,i,n,o,t)
if a==nil or a.CurrHeroCtrl==nil or a.CurrHeroCtrl.HeroBattleInfo==nil or a.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t.buffTriggerTime==BuffTriggerTime.afterAttacked then
local t=a.CurrHeroCtrl.HeroId
if t==i.HeroId then
local t=o.reduceHpValue
e[3]=e[3]+t
end
elseif t.buffTriggerTime==BuffTriggerTime.skillPlay
or t.buffTriggerTime==BuffTriggerTime.skill2Play
or t.buffTriggerTime==BuffTriggerTime.skill3Play then
e[3]=0
elseif t.buffTriggerTime==BuffTriggerTime.skillPlayEnd
or t.buffTriggerTime==BuffTriggerTime.skill2PlayEnd
or t.buffTriggerTime==BuffTriggerTime.skill3PlayEnd then
if e[1]>=RandomMgr:GetBattleRandom()then
local e=math.ceil(e[2]*e[3]*MillionCoe)
a.CurrHeroCtrl:RealHurtWithBuff(e,a)
end
e[3]=0
end
return nil
end
function o.GetCanTrigger(e)
if(e==BuffTriggerTime.afterAttacked
or e==BuffTriggerTime.skillPlay
or e==BuffTriggerTime.skill2Play
or e==BuffTriggerTime.skill3Play
or e==BuffTriggerTime.skillPlayEnd
or e==BuffTriggerTime.skill2PlayEnd
or e==BuffTriggerTime.skill3PlayEnd)then
return true
end
return false
end
function o.SetLogicData(e,e)
end
return i 
