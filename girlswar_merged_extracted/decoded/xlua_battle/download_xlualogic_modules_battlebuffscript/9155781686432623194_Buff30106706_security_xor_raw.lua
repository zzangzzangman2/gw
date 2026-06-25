local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,a,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.enemyAll)
for o=1,#a do
local i=a[o]
local o=e[1]
local a=e[2]
local e={e[3],e[4]}
i:AddBuff(t.CurrHeroCtrl,o,a,e)
end
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.ourAll)
for o=1,#a do
local a=a[o]
if a.profession==e[7]then
local o=e[5]
local i=e[6]
local e={e[8]}
a:AddBuff(t.CurrHeroCtrl,o,i,e)
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now or e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return n

