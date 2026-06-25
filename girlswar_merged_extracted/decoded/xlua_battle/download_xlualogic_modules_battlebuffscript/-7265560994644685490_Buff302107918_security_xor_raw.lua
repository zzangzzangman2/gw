local e={}
local s=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.isExec=true
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.DoActionSmallSkill(t,n)
local e=t:GetBuffData()
local o=302107909
local a=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if a then
local o=ModulesInit.BattleBuffMgr.GetBuffScript(o)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.ourAll)
local t=#t
o.AddEnergyByPercent(a,t*e[1])
end
local i=e[2]
local o=e[3]
local a=e[4]
n:CheckAddBuff(i,t.CurrHeroCtrl,o,a,0)
local a=e[5]
local o=e[6]
local n={e[7],e[8]}
local i=e[9]
t.CurrHeroCtrl:AddBuffWithMaxFloor(t.CurrHeroCtrl,a,o,n,1,i)
local o=e[10]
local a=e[11]
local i={e[12],e[13]}
local e=e[14]
t.CurrHeroCtrl:AddBuffWithMaxFloor(t.CurrHeroCtrl,o,a,i,1,e)
end
return s

