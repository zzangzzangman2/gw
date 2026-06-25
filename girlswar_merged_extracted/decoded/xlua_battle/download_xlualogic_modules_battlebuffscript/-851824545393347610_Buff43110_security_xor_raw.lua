local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,n,a,i,o)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if o.buffTriggerTime==BuffTriggerTime.beCriticalOrBlocked then
local o=i
if(o==1)then
local i=e[1]
local o=e[2]
local n={e[3],e[4]}
t.CurrHeroCtrl:AddBuff(a,i,o,n)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.fHollow)
for o=1,#t do
local o=t[o]
local t=e[1]
local i=e[2]
local e={e[3],e[4]}
o:AddBuff(a,t,i,e)
end
end
elseif o.buffTriggerTime==BuffTriggerTime.attacked then
local o=e[5]
local i=e[6]
local e={e[7],e[8]}
t.CurrHeroCtrl:AddBuff(a,o,i,e)
end
return nil
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.beCriticalOrBlocked or e==BuffTriggerTime.attacked)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return n

