local e={}
local a=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,a,o,o,o,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t.buffTriggerTime==BuffTriggerTime.skillPlay then
local t=43230
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
t.ReduceMoonPhaseFloors(e,a[2])
end
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.skillPlay)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
return a

