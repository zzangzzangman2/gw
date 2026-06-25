local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.OnAdd(e,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
e.CurrHeroCtrl:ChangeState(HeroState.Attack)
e.CurrHeroCtrl:PlaySpineAnim("special",false,true)
local t=4
if e.CurrHeroCtrl.CurrBattleTeam and e.CurrHeroCtrl.CurrBattleTeam.TeamId==1 then
t=-4
end
t=t*ModulesInit.ProcedureNormalBattle.mirrorScaleX
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.ourAll)
for t=1,#e do
local e=e[t]
e:DelayPlayBuffEffect(1.1,a[2])
end
ModulesInit.GlobalBattleEffectMgr.HideEffect(SysPrefabId.BattleFBBZCampainBuff,0,false)
ModulesInit.GlobalBattleEffectMgr.ShowEffect(SysPrefabId.BattleFBBZCampainBuff,t,0.4,50,0.4,0,false,function()
end)
end
end
function t.OnRemoveSelf(e,e)
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
ModulesInit.GlobalBattleEffectMgr.HideEffect(SysPrefabId.BattleFBBZCampainBuff,0,false)
end
end
function t.DoAction(e,e,e,e)
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return o

