local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,a,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local t=e.CurrHeroCtrl
local a=t.HeroBattleInfo:GetMaxHP()*a[1]*MillionCoe
t:HpHealthWithBuffImmediately(a,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
t.HeroBattleInfo:DispelAllGranBuff(false)
e.isExec=true
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

