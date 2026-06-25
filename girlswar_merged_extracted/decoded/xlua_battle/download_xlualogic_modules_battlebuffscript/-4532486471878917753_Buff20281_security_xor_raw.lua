local e={}
local a=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(t,e,a,a,a)
local t=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(e[1])
if(t)then
t:ReduceFloors(e[2])
local e=e[1]
local e=ModulesInit.BattleBuffMgr.GetBuffScript(e)
if e and e.CheckRemove then
e.CheckRemove(t)
end
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.afterNormalOrSmallSkillAttacked)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]
end
return a

