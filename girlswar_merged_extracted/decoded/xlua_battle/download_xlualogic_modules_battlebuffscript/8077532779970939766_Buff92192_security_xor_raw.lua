local t={}
local a=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,a)
local t=t[1]*MillionCoe
local t=e.CurrHeroCtrl.HeroBattleInfo.MaxHP*t
t=math.floor(t)
e.CurrHeroCtrl:HpHealthWithResurgence(t)
e.CurrHeroCtrl:SetHeroPoseType(HeroPoseType.none)
e.CurrHeroCtrl.CurrFsm.ParamDic["changeToIdleType"]=ChangeToIdleType.NormalIdle
e.CurrHeroCtrl:ChangeStateUnCheckState(HeroState.Idle)
e.isExec=true
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.resurgence)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return a

