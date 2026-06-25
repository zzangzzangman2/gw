local e={}
local s=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,o,o,o,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
if#t>=2 then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
end
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.DoLimitAction(e,t)
if#t>=5 then
local o=t[3]
local a=t[4]
local n=t[5]
local i=0
if o>0 and a>0 then
local a=e.CurrHeroCtrl:CheckAddBuff(o,e.CurrHeroCtrl,a,n,i)
if a then
e.CurrHeroCtrl.HeroBattleInfo:PlayBattleAllBuffEffect()
e.CurrHeroCtrl:RealHurtWithBuff(t[6],e)
return a
end
end
end
return false
end
function e.OnShareDamge(e,t)
local t=e:GetBuffData()
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
local e=e.CurrHeroCtrl:GetMiddlePointPos()
ModulesInit.GlobalBattleEffectMgr.ShowEffectAutoRelease(SysPrefabId.BattleLWDMChainDamageEffect,e.x,e.y,50,3,0,false,function()
end)
end
end
return s

