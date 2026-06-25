local a={}
local i=a
function a.GetCanAdd(e,e)
return true
end
function a.OnRemoveSelf(e,e)
end
function a.DoAction(e,t,a,a,a)
local a=t[1]*MillionCoe
local a=e.CurrHeroCtrl.HeroBattleInfo.MaxHP*a
a=math.floor(a)
e.CurrHeroCtrl:HpHealthWithResurgence(a)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.CurrHeroCtrl:ResetFuryWithBuff(t[2])
local a=t[3]
local o=t[4]
local t={t[5],t[6],t[7],t[8]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,o,t)
e.CurrHeroCtrl:SetHeroPoseType(HeroPoseType.none)
e.CurrHeroCtrl.CurrFsm.ParamDic["changeToIdleType"]=ChangeToIdleType.NormalIdle
e.CurrHeroCtrl:ChangeStateUnCheckState(HeroState.Idle)
e.isExec=true
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.resurgence)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.Dispose(e)
end
return i

