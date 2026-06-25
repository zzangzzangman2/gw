local t={}
local h=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local s=e:GetFloors()
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.enemyAll)
for i=1,#a do
local n=302105829
local o=2
local t={t[1],t[2],t[3],t[4]}
a[i]:AddBuffWithFinalFloor(e.CurrHeroCtrl,n,o,t,s,true)
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.eachRoundEnd
or e==BuffTriggerTime.addEnemy)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return h

