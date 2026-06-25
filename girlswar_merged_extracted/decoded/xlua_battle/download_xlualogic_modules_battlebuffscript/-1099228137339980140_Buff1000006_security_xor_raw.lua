local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,o,t,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local t=a.HeroBattleInfo:GetCurrHP()
local t=math.floor(t*o[1]*MillionCoe)
if t>0 then
local t=a:RealHurtWithBuff(t,e)
local t=t.hurtValue
e.CurrHeroCtrl:HpHealthWithBuffImmediately(t,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
end
return nil
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.skillAttack)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return o

