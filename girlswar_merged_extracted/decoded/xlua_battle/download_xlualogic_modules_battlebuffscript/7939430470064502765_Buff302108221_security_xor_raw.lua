local n=require("Modules/Battle/BattleUtil")
local e={}
local t=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,a)
if e==nil or e.CurrHeroCtrl==nil or a==nil then
return
end
t.CheckAddDamageRes(e,a)
end
function e.OnRemoveSelf(e,t)
if e==nil or e.CurrHeroCtrl==nil then
return
end
e.CurrHeroCtrl:ClearDamageResData(e.buffId)
end
function e.DoAction(e,a,o,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a[6]==1 then
a[6]=0
t.OnDamageResOnce(e)
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.skillEndBuff)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.OnDamageRes(e,i)
local a=e:GetBuffData()
local o=e.CurrHeroCtrl.HeroBattleInfo.MaxHP
local o=math.floor(o*a[2]*MillionCoe)
if ModulesInit.ProcedureNormalBattle.IsSkillAttackType(EBattleSkillAttackType.None)then
e.CurrHeroCtrl:HpHealthWithBuffImmediately(o,EBattleSrcType.LockHp,e.releaseHeroId,e.buffId,false,{heroHurtType=i})
t.OnDamageResOnce(e)
else
a[6]=1
local t=e.CurrHeroCtrl.HeroId
local a=21082102
local o={
ignoreControl=true,
buffId=e.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.HelpMate,
addHp=o,
}
local e=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(a,t)
if e==nil then
local e={
triggerSkillAtkType=ETriggerSkillAtkType.Normal
}
n:AddTriggerAttackTask(t,a,o,e)
end
end
end
function e.OnHpLockConsume(a)
local e=a:GetBuffData()
e[5]=e[5]+e[4]
t.CheckAddDamageRes(a,e)
end
function e.OnDamageResOnce(e)
local a=e:GetBuffData()
e.CurrHeroCtrl.HeroBattleInfo:DispelAllGranBuff(false)
e.CurrHeroCtrl:AddFuryWithBuff(a[3])
t.OnHpLockConsume(e)
end
function e.CheckAddDamageRes(e,t)
e.CurrHeroCtrl:ClearDamageResData(e.buffId)
local t={
buffId=e.buffId,
reduceHpMinHpPercent=0,
reduceHpResRate=0,
minHpLockPercent=t[5],
damageResHeroId=e.CurrHeroCtrl.HeroId,
}
e.CurrHeroCtrl:AddDamageResData(t)
end
function e.ResetDamageRes(a,e)
local e=a:GetBuffData()
e[5]=e[1]
t.CheckAddDamageRes(a,e)
end
return t

