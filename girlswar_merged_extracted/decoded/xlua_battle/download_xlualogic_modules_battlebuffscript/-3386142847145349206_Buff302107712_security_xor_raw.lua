local a={}
local n=a
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
local a=t[2]
e.CurrHeroCtrl:ResetFuryWithBuff(a)
local o=302107709
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if a then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(o)
e.AddNightmareEnergy(a,t[3])
end
local i=t[4]
local o=t[5]
local a=0
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,i,o,a)
local o=t[6]
local a=t[7]
local i={t[8],t[9]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,a,i,1)
local o=t[10]
local a=t[11]
local t={t[12],t[13]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,a,t,1)
local a=302107711
local t=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if t then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(a)
e.CheckResetState(t)
end
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
function a.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]
end
function a.Dispose(e)
end
return n

