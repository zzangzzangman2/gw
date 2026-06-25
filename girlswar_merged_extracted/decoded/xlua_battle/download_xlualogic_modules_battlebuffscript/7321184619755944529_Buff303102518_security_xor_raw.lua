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
function e.AddBuffEvilEnergy(a,e)
local t=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e)
if t then
local e=a:GetBuffData()
local o=e[2]
local n=e[3]
local i={e[6],0,0}
t:AddBuff(a.CurrHeroCtrl,o,n,i)
local o=e[4]
local i=e[5]
local n={}
t:AddBuff(a.CurrHeroCtrl,o,i,n,e[1])
end
end
return s

