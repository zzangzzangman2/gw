local t={}
local s=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,o,o,o,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now
or a.buffTriggerTime==BuffTriggerTime.addEnemy
or a.buffTriggerTime==BuffTriggerTime.removeMyMate then
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.enemyAll)
if a and#a>0 then
local i=t[1]
local o=t[2]
local t={t[3],t[4]}
for n=1,#a do
local a=a[n]
a:AddBuff(e.CurrHeroCtrl,i,o,t)
end
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.addEnemy
or e==BuffTriggerTime.removeMyMate)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return s

