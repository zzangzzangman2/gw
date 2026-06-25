local t={}
local a=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
e.CurrHeroCtrl:SetHeroShowCtrl(true)
e.CurrHeroCtrl:ShowHero(true)
local t=t[1]*MillionCoe
local t=e.CurrHeroCtrl.HeroBattleInfo.MaxHP*t
t=math.floor(t)
e.CurrHeroCtrl:HpHealthWithBuffImmediately(t,EBattleSrcType.DeathImmune,e.releaseHeroId,e.buffId,true)
e.CurrHeroCtrl.NotUsualType=0
e.CurrHeroCtrl:SetHeroPoseType(HeroPoseType.none)
e.CurrHeroCtrl.CurrFsm.ParamDic["changeToIdleType"]=ChangeToIdleType.AppearIdle
e.CurrHeroCtrl:ChangeStateUnCheckState(HeroState.Idle)
e.isExec=true
return{
duration=3
}
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.resurgence)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return a

