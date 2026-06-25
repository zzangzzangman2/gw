local a=require("Modules/Battle/BattleUtil")
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
function e.DoAction(e,t,o,o,o,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[3],t[4])
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
minHpLockPercent=t[6],
damageResHeroId=e.CurrHeroCtrl.HeroId,
isNeedCheck=true,
}
e.CurrHeroCtrl:AddDamageResData(t)
end
function e.CheckCondHpLock(t)
local e=t:GetBuffData()
if e[10]>=e[9]then
return false
end
local o=303111401
local a,t=a:GetHeroNoBuffByType(t.CurrHeroCtrl,BattleHeroType.enemyAll,o,nil,true)
if#t>=e[7]then
return true
end
return false
end
function e.OnDamageRes(e,t)
local t=e:GetBuffData()
o.OnHpLockConsume(e)
local t=math.floor(t[8]*e.CurrHeroCtrl.HeroBattleInfo.MaxHP*MillionCoe)
e.CurrHeroCtrl:HpHealthWithDirect(t,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
local o=e.CurrHeroCtrl.HeroId
local t=e.CurrHeroCtrl.SmallSkillId
if t>0 then
local e={
buffId=e.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.FightBack,
}
local i=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(t,o)
if i==nil then
local i={
triggerSkillAtkType=ETriggerSkillAtkType.Normal
}
a:AddTriggerAttackTask(o,t,e,i)
end
end
end
function e.OnHpLockConsume(o)
local e=o:GetBuffData()
e[10]=e[10]+1
local t=303111401
local o,a=a:GetHeroNoBuffByType(o.CurrHeroCtrl,BattleHeroType.enemyAll,t,nil,true)
for e=1,e[7]do
if a[e]then
a[e].HeroBattleInfo:RemoveBuffWithId(t,BuffRemoveType.Expire)
end
end
end
return o

