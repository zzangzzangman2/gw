local t={}
local i=t
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
local t=a[2]
e.CurrHeroCtrl:ResetFuryWithBuff(t)
e.CurrHeroCtrl:ClearSepsisHpDirect(true)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.enemyAll)
if(t)then
local a=302107511
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if e then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(a)
local o=#t
for o=1,o do
local t=t[o]
a.AddSnowFrozenBuff(e,t)
end
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
function t.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]
end
function t.Dispose(e)
end
return i

