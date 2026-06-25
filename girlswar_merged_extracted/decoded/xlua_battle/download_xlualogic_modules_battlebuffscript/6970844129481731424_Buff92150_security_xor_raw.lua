local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if(t[1]>=RandomMgr:GetBattleRandom())then
local a=e.CurrHeroCtrl.CurrBattleTeam:GetRandomHeros(t[2])
for e=1,#a do
a[e].HeroBattleInfo:DispelAllGranBuff(false)
end
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.enemyAll)
for a=1,#e do
e[a].HeroBattleInfo:DispelGranBuff(true,t[3])
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.skill3Play or e==BuffTriggerTime.skill2Play or e==BuffTriggerTime.skillPlay)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return o

