local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,a,t,t)
local t=a[1]*MillionCoe
local t=e.CurrHeroCtrl.HeroBattleInfo.MaxHP*t
t=math.floor(t)
e.CurrHeroCtrl:HpHealthWithResurgence(t)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
local t=a[2]
e.CurrHeroCtrl:ResetFuryWithBuff(t)
local a=302108211
local t=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if t then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(a)
e.ClearKingValue(t,"kr_c_resurgence")
e.EnterBattleState(t,true)
end
local t=302108223
local t=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if t then
local t=302108221
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
t.ResetDamageRes(e)
end
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
return o

