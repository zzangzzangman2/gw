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
function e.DoAction(e,t,i,n,a,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if o.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[2],t[3])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[4],t[5])
elseif o.buffTriggerTime==BuffTriggerTime.anyHeroSkillBeAttack then
local o=a.attackType
if i:IsPet()==false
and o==AttackType.BigSkill
and a.criticalOrBlock==1 then
e.CurrHeroCtrl:AddFuryWithBuffImmediately(t[6])
end
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.anyHeroSkillBeAttack)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.CheckCondHpLock(a)
local e=a:GetBuffData()
if e[12]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[12]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[11]=0
end
local t=302108408
local a=a.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if a then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
local t=t.GetMirrorFloor(a)
if t>=e[7]+e[11]*e[8]then
return true
end
end
return false
end
function e.OnDamageRes(e,t)
local t=e:GetBuffData()
a.OnDamageResOnce(e)
end
function e.OnHpLockConsume(t)
local e=t:GetBuffData()
if e[12]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[12]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[11]=0
end
local a=302108408
local t=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if t then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(a)
a.ReduceMirrorFloor(t,e[7]+e[11]*e[8])
end
e[11]=e[11]+1
end
function e.OnDamageResOnce(e)
local o=e:GetBuffData()
a.OnHpLockConsume(e)
e.CurrHeroCtrl.HeroBattleInfo:DispelAllGranBuff(false)
local t=e.CurrHeroCtrl.HeroBattleInfo.MaxHP
local t=t*o[9]*MillionCoe
e.CurrHeroCtrl:HpHealthWithBuffImmediately(t,EBattleSrcType.LockHp,e.releaseHeroId,e.buffId)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.enemyAll)
if#t>0 then
e.CurrHeroCtrl:AddFuryWithBuffImmediately(o[10]*#t)
end
end
function e.CheckAddDamageRes(e)
local a=e:GetBuffData()
e.CurrHeroCtrl:ClearDamageResData(e.buffId)
local i=a[1]
local t=302108415
local o=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(t)
i=e.GetMinHpLockPercent(o)
end
local t={
buffId=e.buffId,
reduceHpMinHpPercent=0,
reduceHpResRate=0,
minHpLockPercent=a[1],
damageResHeroId=e.CurrHeroCtrl.HeroId,
isNeedCheck=true,
}
e.CurrHeroCtrl:AddDamageResData(t)
end
return a

