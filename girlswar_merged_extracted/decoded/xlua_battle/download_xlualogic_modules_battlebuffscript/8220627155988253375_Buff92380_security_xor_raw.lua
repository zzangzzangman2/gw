local a={}
local h=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,s,o,o,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.skillPlay
or a.buffTriggerTime==BuffTriggerTime.skill2Play
or a.buffTriggerTime==BuffTriggerTime.skill3Play then
e[7]=t.CurrHeroCtrl.HeroBattleInfo:GetCurrFury()
return
end
local i=0
local o=0
local n=e[7]
if a.buffTriggerTime==BuffTriggerTime.normalAttack
or a.buffTriggerTime==BuffTriggerTime.skill2Attack then
local t=math.floor(n/e[1])
i=e[2]
o=t*e[3]
else
local t=math.floor(n/e[4])
i=e[5]
o=t*e[6]
end
if o>0 then
local e=HeroBuffValueInfo:New()
e.buffId=t.buffId
e.attrId=i
e.value=o
s.HeroBattleInfo:AddTempBuffValue(e)
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.skillAttack)
or(e==BuffTriggerTime.skill2Attack)
or(e==BuffTriggerTime.normalAttack)
or(e==BuffTriggerTime.skillPlay)
or(e==BuffTriggerTime.skill2Play)
or(e==BuffTriggerTime.skill3Play)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return h

