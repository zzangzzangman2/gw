local t={}
local o=t
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
local a=t[2]+t[3]
e.CurrHeroCtrl:ResetFuryWithBuff(a)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.ourAllExcludeSelf)
for e=1,#a do
local e=a[e]
local t=t[3]
e:AddFuryWithBuffImmediately(t)
end
local t=303112109
local t=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if t then
local a=t:GetBuffData()
local t=303112104
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
t.AddBuffGrowth(e,a[1])
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
return o 
