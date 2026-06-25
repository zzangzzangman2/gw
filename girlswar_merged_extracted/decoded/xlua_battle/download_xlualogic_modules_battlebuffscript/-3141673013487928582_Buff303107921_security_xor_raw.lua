local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,o,o,o,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[3],t[4])
elseif a.buffTriggerTime==BuffTriggerTime.HeroDead then
local a=303107909
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if e then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(a)
a.GainWindBuff(e,t[7],t[8])
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now or e==BuffTriggerTime.HeroDead)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.GetEnergyDamageData(e)
local e=e:GetBuffData()
return e[5],e[6]
end
return o

