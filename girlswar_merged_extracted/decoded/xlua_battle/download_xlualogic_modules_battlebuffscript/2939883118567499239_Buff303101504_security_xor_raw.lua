local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.OnRemoveSelf(e,e)
end
function t.DoAction(e,a,t,t,t)
local t=a[2]*MillionCoe
local t=e.CurrHeroCtrl.HeroBattleInfo.MaxHP*t
t=math.floor(t)
e.CurrHeroCtrl:HpHealthWithResurgence(t)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.CurrHeroCtrl:ResetFuryWithBuff(a[1])
local t=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(303101509)
if t then
local a=t:GetBuffData()
local a=ModulesInit.BattleBuffMgr.GetBuffScript(303101509)
a.DoAction(t,t.buffData,e.CurrHeroCtrl,e.CurrHeroCtrl)
end
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
function t.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]
end
function t.Dispose(e)
end
return o

