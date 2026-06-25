local o=require("Modules/Battle/BattleUtil")
local t={}
local s=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,a,n,s,i,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t.buffTriggerTime==BuffTriggerTime.skill3Play
or t.buffTriggerTime==BuffTriggerTime.skill2Play
or t.buffTriggerTime==BuffTriggerTime.skillPlay then
local t=i.triggerSkillAtkType
if o:IsDependAtkType(t)==false then
e:AddFloors(a[1])
end
elseif t.buffTriggerTime==BuffTriggerTime.attacked then
if#a>=3 and e.releaseHeroId~=n.HeroId then
local t=HeroBuffValueInfo:New()
t.buffId=e.buffId
t.attrId=a[2]
t.value=a[3]
e.CurrHeroCtrl.HeroBattleInfo:AddTempBuffValue(t)
end
end
end
function t.GetCanTrigger(e)
if e==BuffTriggerTime.skillPlay
or e==BuffTriggerTime.skill2Play
or e==BuffTriggerTime.skill3Play
or e==BuffTriggerTime.attacked then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return s

