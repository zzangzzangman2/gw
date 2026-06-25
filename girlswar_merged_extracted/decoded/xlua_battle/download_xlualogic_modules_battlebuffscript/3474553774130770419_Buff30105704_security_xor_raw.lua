local t={}
local n=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,a,o,o,o,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t.buffTriggerTime==BuffTriggerTime.now
or t.buffTriggerTime==BuffTriggerTime.addMyMate
or t.buffTriggerTime==BuffTriggerTime.removeMyMate then
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.ourAll)
if t and#t>0 then
for o=1,#t do
local t=t[o]
local o=a[2]
local i=a[3]
local a={a[1]}
t:AddBuff(e.CurrHeroCtrl,o,i,a)
end
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.addMyMate
or e==BuffTriggerTime.removeMyMate)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return n

