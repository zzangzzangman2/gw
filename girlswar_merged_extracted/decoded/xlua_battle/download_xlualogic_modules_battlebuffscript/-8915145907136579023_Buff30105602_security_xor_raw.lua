local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,o,o,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local a=a
if(a==2)then
local o=e.CurrHeroCtrl.HeroBattleInfo:GetCurrHP()
local a=e.CurrHeroCtrl.HeroBattleInfo:GetMaxHP()
local a=a-o
local a=math.floor(a*t[1]*MillionCoe)
e.CurrHeroCtrl:HpHealthWithBuffImmediately(a,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
e.CurrHeroCtrl:AddFuryWithBuff(t[2])
end
return nil
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.beCriticalOrBlocked)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return i

