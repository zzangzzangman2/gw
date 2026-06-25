local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,n,i,o,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
local o=e[1]
local a=e[2]
local e={e[3],e[4]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,a,e)
elseif a.buffTriggerTime==BuffTriggerTime.evadeed then
local a=e[10]
if(e[13]>=a)then
return nil
end
e[13]=e[13]+1
local o=e[5]
local a=e[6]
local i={e[7],e[8]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,a,i)
t.CurrHeroCtrl:AddFuryWithBuff(e[9])
elseif a.buffTriggerTime==BuffTriggerTime.evade then
if n and o.isPetTrigger==false and o.isTeamAttack~=true then
local a=303110906
local o=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if o then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(a)
t.AddBuffBloodPower(o,e[11])
end
local e=t.CurrHeroCtrl.HeroBattleInfo.MaxHP*e[12]*MillionCoe
t.CurrHeroCtrl:HpHealthWithBuffImmediately(e,EBattleSrcType.Buff,t.releaseHeroId,t.buffId)
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.evadeed
or e==BuffTriggerTime.evade)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return n

