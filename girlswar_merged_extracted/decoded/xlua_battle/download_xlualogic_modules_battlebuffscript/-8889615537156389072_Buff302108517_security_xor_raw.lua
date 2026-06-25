local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,o,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
local t=302108515
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if a then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
local t=t.GetBraveTaskcount(a)
if t>=o[1]then
local t=302108508
local t=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if t then
local a=t:GetFloors()
local t=302108507
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
t.GainTeamTaskHalo(e,a,o[2]*MillionCoe)
end
end
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.HeroDead)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return i

