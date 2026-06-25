local i=require("Modules/Battle/BattleUtil")
local e={}
local o=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,t)
if e==nil or e.CurrHeroCtrl==nil or t==nil then
return
end
o.CheckAddDamageRes(e)
end
function e.OnRemoveSelf(e,t)
if e==nil or e.CurrHeroCtrl==nil then
return
end
e.CurrHeroCtrl:ClearDamageResData(e.buffId)
end
function e.DoAction(e,a,a,a,a,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t.buffTriggerTime==BuffTriggerTime.now then
end
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
local e=e:GetBuffData()
return true
end
function e.OnDamageRes(e,t)
local t=e:GetBuffData()
local a=math.floor(t[2]*e.CurrHeroCtrl.HeroBattleInfo.MaxHP*MillionCoe)
e.CurrHeroCtrl:HpHealthWithDirect(a,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
e.CurrHeroCtrl:AddFuryWithBuff(t[3])
local a=303111606
local o=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(a)
e.AddBuffEnergyStorage(o,t[4])
end
local o=303111606
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if a then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(o)
if t[5]>RandomMgr:GetBattleRandom()then
e.AddAttackTaskScatteredCuts(a,0,ETriggerSkillAtkType.Normal)
else
e.AddAttackTaskVetoGun(a,0,ETriggerSkillAtkType.Normal)
end
end
i:ReduceHeroBuffFloor(e.CurrHeroCtrl,303111618,1)
end
return o

