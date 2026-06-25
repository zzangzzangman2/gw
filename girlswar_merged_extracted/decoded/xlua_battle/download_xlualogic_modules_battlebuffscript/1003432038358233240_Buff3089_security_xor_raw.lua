local e={}
local a=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t)
if(e.CurrHeroCtrl.normalOrSmallSkillAttackedTimes>0 and e.CurrHeroCtrl.normalOrSmallSkillAttackedTimes%t[1]==0)then
local t=t[2]*MillionCoe
local t=e.CurrHeroCtrl.HeroBattleInfo.MaxHP*t
e.CurrHeroCtrl:HpHealthWithBuff(t,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.normalOrSmallSkillAttacked)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]+e.buffWeight[2]*t[2]
end
return a

