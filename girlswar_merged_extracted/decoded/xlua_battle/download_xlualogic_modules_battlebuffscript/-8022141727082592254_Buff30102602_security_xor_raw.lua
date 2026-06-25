local t={}
local a=t
function t.GetCanAdd(e,e)
return true
end
function t.OnAdd(e,e)
end
function t.OnRemoveSelf(t,e)
local e=e[1]
local e=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e)
if e and e.HeroBattleInfo then
local t={30102607,30102705}
for a=1,#t do
local t=t[a]
local e=e.HeroBattleInfo:GetBuff(t)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
if t then
t.DoAction(e,e:GetBuffData())
end
end
end
end
end
function t.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if#t>=5 then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[2],t[3])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[4],t[5])
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return a

