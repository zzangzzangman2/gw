local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,a,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
e.CurrHeroCtrl:SetHeroShowCtrl(true)
e.CurrHeroCtrl:ShowHero(true)
e.CurrHeroCtrl:EnsureUndead()
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.ourAllExcludeSelf)
table.insert(t,e.CurrHeroCtrl)
for o=1,#t do
local o=t[o]
local t=a[1]*MillionCoe
local t=o.HeroBattleInfo.MaxHP*t
t=math.floor(t)
o:HpHealthWithBuffImmediately(t,EBattleSrcType.DeathImmune,e.releaseHeroId,e.buffId,true)
o:AddFuryWithBuff(a[2])
end
local o=302108815
local t=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if t then
local o=ModulesInit.BattleBuffMgr.GetBuffScript(o)
o.GainEnergy(t,a[3])
local t=t:GetBuffData()
o.AddBuffLingyu(e.CurrHeroCtrl,t)
end
e.CurrHeroCtrl.NotUsualType=0
e.CurrHeroCtrl:SetHeroPoseType(HeroPoseType.none)
e.CurrHeroCtrl.CurrFsm.ParamDic["changeToIdleType"]=ChangeToIdleType.NormalIdle
e.CurrHeroCtrl:ChangeStateUnCheckState(HeroState.Idle)
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
local e=e.CurrHeroCtrl:GetMiddlePointPos()
ModulesInit.GlobalBattleEffectMgr.ShowEffectAutoRelease(SysPrefabId.BattleJejmsInEffect,e.x,e.y,50,3,0,false,function()
end)
end
e.isExec=true
return{
duration=2
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
return i

