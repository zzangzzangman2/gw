local e={}
local t=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,a)
if e==nil or e.CurrHeroCtrl==nil or a==nil then
return
end
t.CheckAddDamageRes(e)
end
function e.OnRemoveSelf(e,t)
if e==nil or e.CurrHeroCtrl==nil then
return
end
e.CurrHeroCtrl:ClearDamageResData(e.buffId)
end
function e.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.isExec=true
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.GetWeight(e,a,t)
return-1*(e.buffWeight[1]*t[1])
end
function e.CheckAddDamageRes(e)
local t=e:GetBuffData()
e.CurrHeroCtrl:ClearDamageResData(e.buffId)
local t={
buffId=e.buffId,
reduceHpMinHpPercent=0,
reduceHpResRate=0,
minHpLockPercent=0,
damageResHeroId=e.CurrHeroCtrl.HeroId,
isNeedCheck=false,
damgeMaxHpPercent=t[1],
}
e.CurrHeroCtrl:AddDamageResData(t)
end
return t

