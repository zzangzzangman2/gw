local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,a,o,o,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t and t.attackType==AttackType.BigSkill then
local t=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e.releaseHeroId)
if t and t.HeroBattleInfo and t.HeroBattleInfo.CurrHP>0 and t:IsUsualState()then
local o=a[1]*MillionCoe
local i=t.HeroBattleInfo.CurrHP
local i=t.HeroBattleInfo.MaxHP-i
local o=i*o
t:HpHealthWithBuffImmediately(o,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
t:AddFuryWithBuff(a[2])
e.isExec=true
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.skillAttackComplete)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return n

