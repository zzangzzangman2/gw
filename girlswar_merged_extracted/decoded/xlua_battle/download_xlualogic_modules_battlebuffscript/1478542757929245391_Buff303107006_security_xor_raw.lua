local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,a,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local t=HeroBuffValueInfo:New()
t.buffId=e.buffId
t.attrId=a[1]
t.value=a[2]
e.CurrHeroCtrl.HeroBattleInfo:AddTempBuffValue(t)
e.isExec=true
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.skillAttack)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return o

