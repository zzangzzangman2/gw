local e=require("Modules/Battle/BattleUtil")
local a={}
local i=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,o,o,o,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[3],t[4])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[5],t[6])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[7],t[8])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[9],t[10])
local t=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(302108816)
local a=0
if t then
a=t:GetFloors()
end
i.OnEnergyChange(e,a)
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.OnEnergyChange(e,a)
local t=e:GetBuffData()
if a>t[30]then
i.CheckAddDamageRes(e)
else
e.CurrHeroCtrl:ClearDamageResData(e.buffId)
if t[29]==0 then
t[29]=1
e.CurrHeroCtrl.isTriggerSkillEndBuffForEver=true
e.CurrHeroCtrl.HeroBattleInfo:DispelAllGranBuff(false)
local o=t[22]
local i=t[23]
local a={}
for o=24,28 do
table.insert(a,t[o])
end
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,i,a)
end
end
end
function a.CheckAddDamageRes(e)
local t=e:GetBuffData()
e.CurrHeroCtrl:ClearDamageResData(e.buffId)
local t=t[11]
if t>=0 then
local t={
buffId=e.buffId,
reduceHpMinHpPercent=0,
reduceHpResRate=0,
minHpLockPercent=t,
damageResHeroId=e.CurrHeroCtrl.HeroId,
isNeedCheck=false,
}
e.CurrHeroCtrl:AddDamageResData(t)
end
end
function a.OnDamageRes(e,t)
local t=e:GetBuffData()
local o=302108815
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if a then
local i=ModulesInit.BattleBuffMgr.GetBuffScript(o)
local o=i.GetEnergyCount(a)
if o>0 then
local o=math.ceil(o*t[12]*MillionCoe)
o=math.max(o,t[13])
i.ConumeEnergy(a,o)
local a=e.CurrHeroCtrl.HeroBattleInfo.MaxHP
local a=math.floor(a*t[14]*MillionCoe)
if ModulesInit.ProcedureNormalBattle.IsSkillAttackType(EBattleSkillAttackType.None)then
e.CurrHeroCtrl:HpHealthSimple(e.CurrHeroCtrl,a,EBattleSrcType.LockHp)
else
local o=302108824
local t=1
local a={a}
e.CurrHeroCtrl:AddBuffAfterRemove(e.CurrHeroCtrl,o,t,a)
end
e.CurrHeroCtrl.HeroBattleInfo:DispelAllGranBuff(false)
e.CurrHeroCtrl:AddFuryWithBuff(t[15])
local i=t[16]
local o=t[17]
local a={}
for o=18,21 do
table.insert(a,t[o])
end
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,i,o,a)
end
end
end
return i

