local i=require("Modules/Battle/BattleUtil")
local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,n,s,o,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
local i=e[1]
local a=e[2]
local o={e[3],e[4]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,i,a,o)
local o=e[5]
local a=e[6]
local e={e[7],e[8]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,a,e)
elseif a.buffTriggerTime==BuffTriggerTime.skillPlay then
if e[14]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[14]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[15]=0
end
e[15]=e[15]+1
elseif a.buffTriggerTime==BuffTriggerTime.afterAttacked then
local t=t.CurrHeroCtrl.HeroId
if t==n.HeroId and o.attackType==AttackType.BigSkill then
e[13]=e[13]+o.reduceHpValue
end
elseif a.buffTriggerTime==BuffTriggerTime.skillPlayEnd then
if e[15]<=e[12]then
local a=303110804
local a=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if a then
local a=a:GetBuffData()
local a=a[19]
if e[13]>=a*e[10]*MillionCoe then
e[13]=0
i:StealMultiEnemyBuff(t.CurrHeroCtrl,true,1)
t.CurrHeroCtrl:AddFuryWithBuff(e[11])
end
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.afterAttacked
or e==BuffTriggerTime.skillPlay
or e==BuffTriggerTime.skillPlayEnd)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return n

