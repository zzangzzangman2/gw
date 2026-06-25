local t={}
local n=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,a,t,i,o,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local t=e.CurrHeroCtrl.HeroId
if t==i.HeroId then
local t=o.criticalOrBlock
if t==2 then
if(a[3]<RandomMgr:GetBattleRandom())then
return
end
local t=e.CurrHeroCtrl.HeroBattleInfo:GetMaxHP()-e.CurrHeroCtrl.HeroBattleInfo:GetCurrHP()
local t=math.floor(t*a[1]*MillionCoe)
local a=math.floor(e.CurrHeroCtrl.HeroBattleInfo.MaxHP*a[2]*MillionCoe)
t=math.min(t,a)
if t>0 then
e.CurrHeroCtrl:HpHealthWithBuff(t,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
end
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.afterAttacked)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return n

