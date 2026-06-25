local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.OnRemoveSelf(e,e)
end
function t.DoAction(e,t,a,a,a)
local a=t[1]*MillionCoe
local a=e.CurrHeroCtrl.HeroBattleInfo.MaxHP*a
a=math.floor(a)
e.CurrHeroCtrl:HpHealthWithResurgence(a)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.CurrHeroCtrl:ResetFuryWithBuff(t[2])
local o=303111704
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if a then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(o)
e.AddBuffTheMind(a,t[3])
end
local t=303111712
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if a then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(t)
e.CheckAddBuffBeauty(a)
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
return i 
