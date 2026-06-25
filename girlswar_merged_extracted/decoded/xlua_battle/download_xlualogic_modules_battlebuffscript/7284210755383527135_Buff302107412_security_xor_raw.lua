local e={}
local i=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,t,t)
e.isExec=true
end
function e.GetCanTrigger(e)
return false
end
function e.SetLogicData(e,e)
end
function e.AddcumulativeNumber(o,e)
local e=o:GetBuffData()
if e[5]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[5]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[6]=0
e[4]=0
end
local t=e[3]-e[6]
if t>0 then
e[4]=e[4]+1
local a=math.floor(e[4]*e[2]/e[1])
if a>0 then
local t=math.min(t,a)
e[4]=e[4]-t*e[1]
e[6]=e[6]+t
local e=302107423
local a=o.CurrHeroCtrl.HeroBattleInfo:GetBuff(e)
if a then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(e)
e.AddEyeBuff(a,t)
end
end
end
end
return i

