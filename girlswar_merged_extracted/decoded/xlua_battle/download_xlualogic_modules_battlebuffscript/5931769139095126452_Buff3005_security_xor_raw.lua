local e={}
local a=e
function e.GetCanAdd(e,e)
return true
end
function e.OnRemoveSelf(e,e)
end
function e.DoAction(e,t,a,a,a)
e.CurrHeroCtrl:AddFuryWithBuff(t[1])
local t=t[2]*MillionCoe
local t=e.CurrHeroCtrl.HeroBattleInfo.MaxHP*t
e.CurrHeroCtrl:HpHealthWithResurgence(t)
e.CurrHeroCtrl.CurrFsm.ParamDic["changeToIdleType"]=ChangeToIdleType.NormalIdle
e.CurrHeroCtrl:ChangeStateUnCheckState(HeroState.Idle)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.isExec=true
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.resurgence)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.GetWeight(t,a,e)
return t.buffWeight[1]*e[1]+t.buffWeight[2]*e[2]
end
function e.Dispose(e)
end
return a

