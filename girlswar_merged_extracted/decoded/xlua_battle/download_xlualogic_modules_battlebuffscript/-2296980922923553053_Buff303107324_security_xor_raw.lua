local t=require("Modules/Battle/BattleUtil")
local e={}
local a=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,t)
if e==nil or e.CurrHeroCtrl==nil or t==nil then
return
end
a.CheckAddDamageRes(e)
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
function e.CheckAddDamageRes(e)
local t=e:GetBuffData()
e.CurrHeroCtrl:ClearDamageResData(e.buffId)
local t={
buffId=e.buffId,
reduceHpMinHpPercent=0,
reduceHpResRate=0,
minHpLockPercent=t[1],
damageResHeroId=e.CurrHeroCtrl.HeroId,
isNeedCheck=true,
}
e.CurrHeroCtrl:AddDamageResData(t)
end
function e.CheckCondHpLock(e)
local a=e:GetBuffData()
local a=303107321
local t,e=t:GetHeroNoBuffByType(e.CurrHeroCtrl,BattleHeroType.ourAll,a)
if#e>0 then
return true
end
return false
end
function e.OnDamageRes(e,t)
local t=e:GetBuffData()
a.OnHpLockConsume(e)
e.CurrHeroCtrl.HeroBattleInfo:DispelGranBuff(false,t[3])
if e.CurrHeroCtrl and e.CurrHeroCtrl.HeroBattleInfo then
local t=math.floor(t[4]*e.CurrHeroCtrl.HeroBattleInfo.MaxHP*MillionCoe)
e.CurrHeroCtrl:HpHealthWithDirect(t,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
end
end
function e.OnHpLockConsume(a)
local o=a:GetBuffData()
local e=303107321
local o=o[2]
local i,a=t:GetHeroNoBuffByType(a.CurrHeroCtrl,BattleHeroType.ourAll,e)
local a=a[1]
if a then
t:ReduceHeroBuffFloor(a,e,o)
end
end
return a

