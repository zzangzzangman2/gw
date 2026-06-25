local o=require("Modules/Battle/BattleUtil")
local e={}
local n=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,t)
if e==nil or e.CurrHeroCtrl==nil or t==nil then
return
end
n.CheckAddDamageRes(e)
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
local a=e:GetBuffData()
local i=e.CurrHeroCtrl.HeroId
local t=e.CurrHeroCtrl.SmallSkillId
if t>0 then
local e={
triggerSkillAtkType=ETriggerSkillAtkType.PursuitAttack,
}
local a=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(t,i)
if a==nil then
o:AddTriggerAttackTask(i,t,e,{triggerSkillAtkType=ETriggerSkillAtkType.Normal})
end
end
local t=math.floor(a[3]*e.CurrHeroCtrl.HeroBattleInfo.MaxHP*MillionCoe)
e.CurrHeroCtrl:HpHealthReset(t,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
o:ReduceHeroBuffFloor(e.CurrHeroCtrl,e.buffId,a[2])
end
return n

