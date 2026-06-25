local e={}
local s=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(a,e,o,o,t)
if(t==nil or#t<=0)then
return
end
local o=t[1]
local t=t[2]
if(t==BuffRemoveType.Expire or t==BuffRemoveType.Dispel)then
if(o==e[1])then
local n=e[2]
local i=e[3]
local o={e[4]}
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a.CurrHeroCtrl,BattleHeroType.fFront)
if(e~=nil)then
local t=#e
for t=1,t do
local e=e[t]
e:AddBuff(a.CurrHeroCtrl,n,i,o)
end
end
end
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.removeBuff)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]
end
return s

