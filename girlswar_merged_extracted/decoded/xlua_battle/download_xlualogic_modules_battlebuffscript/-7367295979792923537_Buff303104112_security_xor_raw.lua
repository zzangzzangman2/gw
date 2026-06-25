local o=require("Modules/Battle/BattleUtil")
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
function e.DoAction(e,t,a,a,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local o=t[1]
local i=t[2]
local a={t[3],t[4]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,i,a)
local o=t[5]
local a=t[6]
local t={t[7],t[8]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,a,t)
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
function e.DoBeansActionSmallSkill(e,t)
local a=e:GetBuffData()
local t=t[1]
local t=nil
e.CurrHeroCtrl:AddFuryWithBuff(a[18])
end
function e.OnDamageRes(e,t)
local t=e:GetBuffData()
a.OnDamageResOnce(e)
end
function e.OnDamageResOnce(e)
local t=e:GetBuffData()
local a=e.CurrHeroCtrl.HeroBattleInfo.MaxHP
local a=math.floor(a*t[10]*MillionCoe)
o:ReduceSepsisHp(e.CurrHeroCtrl,e.CurrHeroCtrl,a,true,true)
e.CurrHeroCtrl:AddFuryWithBuffImmediately(t[11])
e.CurrHeroCtrl:ClearDamageResData(e.buffId)
e.CurrHeroCtrl.HeroBattleInfo:DispelAllGranBuff(false)
end
function e.CheckAddDamageRes(e)
local t=e:GetBuffData()
e.CurrHeroCtrl:ClearDamageResData(e.buffId)
local t={
buffId=e.buffId,
reduceHpMinHpPercent=0,
reduceHpResRate=0,
minHpLockPercent=t[9],
damageResHeroId=e.CurrHeroCtrl.HeroId,
isNeedCheck=false,
}
e.CurrHeroCtrl:AddDamageResData(t)
end
return a

