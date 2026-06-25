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
local t=math.floor(a*t[1]*MillionCoe)
e.CurrHeroCtrl:HpHealthWithBuffImmediately(t,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
return nil
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return o

