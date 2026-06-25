local a={}
local o=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,o,o,o,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if a.buffTriggerTime==BuffTriggerTime.attacked then
if t.CurrHeroCtrl.HeroBattleInfo.CurrHP>0 then
t.CurrHeroCtrl:RealHurtWithBuff(e[1],t)
e[3]=e[1]+e[3]
local t=0
if e[1]>0 then
t=e[3]/e[1]
end
end
elseif a.buffTriggerTime==BuffTriggerTime.HeroDead then
if#e>=2 then
local t=t.releaseHeroId
local t=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(t)
if t then
t:AddFuryWithBuff(e[2])
if t.HeroBattleInfo then
t.HeroBattleInfo:PlayBattleEffectWithType(BattleEffectType.AddFury)
end
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.attacked or e==BuffTriggerTime.HeroDead)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return o

