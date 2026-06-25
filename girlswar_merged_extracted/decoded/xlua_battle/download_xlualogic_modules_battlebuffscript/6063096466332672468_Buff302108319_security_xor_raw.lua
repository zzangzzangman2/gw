local a={}
local i=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,a,a)
local a=t[1]*MillionCoe
local a=e.CurrHeroCtrl.HeroBattleInfo.MaxHP*a
a=math.floor(a)
e.CurrHeroCtrl:HpHealthWithResurgence(a)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
local a=t[2]
e.CurrHeroCtrl:ResetFuryWithBuff(a)
local a=t[3]
local o=t[4]
local t={t[5],t[6]}
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
return i

