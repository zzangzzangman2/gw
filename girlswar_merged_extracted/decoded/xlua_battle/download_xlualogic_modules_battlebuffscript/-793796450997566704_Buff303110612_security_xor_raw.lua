local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,o,o,n,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
local i=t[1]
local o=t[2]
local a={t[3],t[4]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,i,o,a)
local i=t[5]
local o=t[6]
local a={t[7],t[8]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,i,o,a)
local a=t[9]
local o=t[10]
local t={t[11],t[12]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,o,t)
elseif a.buffTriggerTime==BuffTriggerTime.DoAddFury
or a.buffTriggerTime==BuffTriggerTime.DoAddFuryWithReset then
if e.CurrHeroCtrl:IsFullFuryWithFury(n.oldFury)==false and e.CurrHeroCtrl:IsFullFury()then
if ModulesInit.ProcedureNormalBattle.IsSkillAttackType(EBattleSkillAttackType.BigSkillAttacking)and e.CurrHeroCtrl:IsOnAttack()then
e.CurrHeroCtrl.HeroBattleInfo:DispelAllGranBuff(false)
local a=303110603
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if e then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(a)
a.GeneratePowerPerseus(e,t[13],0)
end
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.DoAddFury
or e==BuffTriggerTime.DoAddFuryWithReset)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return n

