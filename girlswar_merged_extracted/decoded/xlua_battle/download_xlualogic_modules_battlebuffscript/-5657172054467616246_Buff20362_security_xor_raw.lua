local e={}
local t=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,t)
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
e.CurrHeroCtrl:ChangeState(HeroState.Attack)
e.CurrHeroCtrl:PlaySpineAnim("special",false,true)
local e={
TeamId=e.CurrHeroCtrl:GetTeamId(),
battleStationIndex=e.CurrHeroCtrl.battleStationIndex,
HeroId=e.releaseHeroId,
buffId=e.buffId,
prefabId=Constant.zhugeliang_rain_effect,
targetPosX=0,
targetPosY=0,
targetPosZ=50,
delay=1,
fadeIn=0.5,
bShowSpeed=true,
onComplete=function()
end,
}
ModulesInit.ProcedureNormalBattle.ShowBgEffect(e)
end
end
function e.OnRemoveSelf(e,t)
if GameInit.IsClient then
local e={
HeroId=e.releaseHeroId,
buffId=e.buffId,
prefabId=Constant.zhugeliang_rain_effect,
fadeOut=0.5,
bShowSpeed=true,
}
ModulesInit.ProcedureNormalBattle.HideBgEffect(e)
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
return t

