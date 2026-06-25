local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.OnRemoveSelf(e,e)
end
function t.DoAction(e,a,t,t,t)
e.CurrHeroCtrl:SetHeroPetShowCtrl(true)
e.CurrHeroCtrl:SetHeroHeadBarShowCtrl(true)
local t=a[1]*MillionCoe
local t=e.CurrHeroCtrl.HeroBattleInfo.MaxHP*t
t=math.floor(t)
e.CurrHeroCtrl:HpHealthWithResurgence(t)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
local t=a[2]
e.CurrHeroCtrl:ResetFuryWithBuff(t)
local a=303101213
local t=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if(t)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(a)
e.ResetAttr(t)
end
local o=303101220
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.enemyAll)
for a=1,#t do
local a=t[a]
local t=a.HeroBattleInfo:GetBuff(o)
if t and t.releaseHeroId==e.CurrHeroCtrl.HeroId then
a.HeroBattleInfo:RemoveBuffWithId(o,BuffRemoveType.Expire)
end
end
local t=303101223
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(t,BuffRemoveType.Expire)
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

