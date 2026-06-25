local e={}
local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.OnRemoveSelf(e,e)
end
function t.DoAction(e,a,t,t,t)
local t=a[1]*MillionCoe
local t=e.CurrHeroCtrl.HeroBattleInfo.MaxHP*t
t=math.floor(t)
e.CurrHeroCtrl:HpHealthWithResurgence(t)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.CurrHeroCtrl:ResetFuryWithBuff(a[2])
local a=303111801
local t=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if t then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(a)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.eRandom,1)
local e=e[1]
if e then
a.AddBuffDeadLine(t,e)
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
function t.GetWeight(t,a,e)
return t.buffWeight[1]*e[1]
end
function t.Dispose(e)
end
return o 
