local e={}
local o=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,a)
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
e.CurrHeroCtrl:ChangeState(HeroState.Attack)
e.CurrHeroCtrl:PlaySpineAnim("special",false,true)
local t=4
if e.CurrHeroCtrl.CurrBattleTeam and e.CurrHeroCtrl.CurrBattleTeam.TeamId==1 then
t=-4
end
t=t*ModulesInit.ProcedureNormalBattle.mirrorScaleX
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.enemyAll)
for e=1,#t do
local e=t[e]
e:DelayPlayBuffEffect(2,a[2])
end
ModulesInit.GlobalBattleEffectMgr.HideEffect(SysPrefabId.BattleDiaochanCampainBuff,0,false)
local e=e.CurrHeroCtrl:GetFootPointPos()
ModulesInit.GlobalBattleEffectMgr.ShowEffect(SysPrefabId.BattleDiaochanCampainBuff,e.x,e.y,50,0.4,0,false,function()
end)
end
end
function e.OnRemoveSelf(e,e)
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
ModulesInit.GlobalBattleEffectMgr.HideEffect(SysPrefabId.BattleDiaochanCampainBuff,0,false)
end
end
function e.DoAction(e,e)
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.GetWeight(e,e,e)
return 1
end
return o

