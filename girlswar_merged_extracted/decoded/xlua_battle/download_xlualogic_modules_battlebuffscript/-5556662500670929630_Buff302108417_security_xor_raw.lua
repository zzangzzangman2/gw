local a={}
local i=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,a,a)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.enemyAll)
for e=1,#a do
local e=a[e]
if e.HeroBattleInfo then
e.HeroBattleInfo:DispelAllGranBuff(true)
end
end
local a=t[1]*MillionCoe
local a=e.CurrHeroCtrl.HeroBattleInfo.MaxHP*a
a=math.floor(a)
e.CurrHeroCtrl:HpHealthWithResurgence(a)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.CurrHeroCtrl:ResetMaxFuryWithBuff()
local o=302108408
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if a then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(o)
e.GainMirror(a,t[2])
end
local a=t[3]
local o=t[4]
local t={t[5],t[6]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,o,t)
local t=302108409
local a=2
local o=0
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,t,a,o)
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

