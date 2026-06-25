local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,o,a,a,i)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if i.buffTriggerTime==BuffTriggerTime.skill2Attack then
if t[1]>=RandomMgr:GetBattleRandom()then
local a=HeroBuffValueInfo:New()
a.buffId=e.buffId
a.attrId=t[2]
a.value=t[3]
o.HeroBattleInfo:AddTempBuffValue(a)
end
elseif i.buffTriggerTime==BuffTriggerTime.skillAttack then
if t[1]>=RandomMgr:GetBattleRandom()then
local a=HeroBuffValueInfo:New()
a.buffId=e.buffId
a.attrId=t[4]
a.value=t[5]
o.HeroBattleInfo:AddTempBuffValue(a)
end
end
return nil
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.skill2Attack or e==BuffTriggerTime.skillAttack)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return n

