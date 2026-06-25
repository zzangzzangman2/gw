local t={}
local n=t
function t.GetCanAdd(e,e)
return true
end
function t.OnAdd(e,t)
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,HeroAttrId.injureRateAdd,t[1])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,HeroAttrId.injureResRateAdd,t[2])
end
function t.OnRemoveSelf(e,e)
end
function t.DoAction(e,t,a,i,o)
local o=o
if(o==1)then
local o=t[3]
local e=t[4]
local t={t[5]}
a:AddBuff(i,o,e,t)
else
local o=t[7]
e.currTimes=e.currTimes==nil and 1 or e.currTimes
if(e.currTimes>o)then
e.currTimes=1
return nil
end
a:ReduceFuryWithSkill(t[6],ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e.releaseHeroId),EBattleSrcType.Buff,false)
e.currTimes=e.currTimes+1
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
return n

