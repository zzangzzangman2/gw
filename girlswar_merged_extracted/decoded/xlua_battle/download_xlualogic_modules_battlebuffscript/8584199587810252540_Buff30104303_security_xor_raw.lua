local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,o,a,o,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a==nil or a.HeroBattleInfo==nil then
return
end
if#t>=2 then
local a=a.HeroBattleInfo:GetBuff(t[3])
if a then
local a=t[1]*MillionCoe
local a=e.CurrHeroCtrl.HeroBattleInfo.MaxHP*a
e.CurrHeroCtrl:HpHealthWithBuffImmediately(a,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
e.CurrHeroCtrl:AddFuryWithBuff(t[2])
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.teamHeroDead)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return o

