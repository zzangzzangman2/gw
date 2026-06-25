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
local i=e[1]
local a=303111606
local o=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if o then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(a)
t.AddBuffEnergyStorage(o,e[2])
end
n.HeroBattleInfo:DispelGranBuff(true,e[3])
t.CurrHeroCtrl:AddFuryWithBuff(e[4])
return i
end
return s

