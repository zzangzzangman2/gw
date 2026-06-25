local e={}
local i=e
local a=require("Modules/Battle/BattleUtil")
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,o,i,i,t)
if(t==nil or#t<=0)then
return
end
if t.buffHeroId==e.CurrHeroCtrl.HeroId then
local t=t.addBuffId
if(a:IsCtlBuff(t))then
local t=o[1]*MillionCoe
local t=e.CurrHeroCtrl.HeroBattleInfo.MaxHP*t
e.CurrHeroCtrl:HpHealthWithBuff(t,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
end
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.addBuff)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.GetWeight(t,a,e)
return t.buffWeight[1]*e[1]
end
return i

