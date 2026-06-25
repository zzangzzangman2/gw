local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local a=e.CurrHeroCtrl.HeroBattleInfo:GetMaxHP()
local t=a*t[1]*MillionCoe
local t=e.CurrHeroCtrl:RealHurtWithBuff(t,e)
local a=t.hurtValue
local t=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e.releaseHeroId)
if t then
t:HpHealthWithBuffImmediately(a,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return o

