local e={}
local i=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,e)
end
function e.OnRemoveSelf(e,t)
e.CurrHeroCtrl:RemoveImmuneActiveAtkReduceFuryWithCount(e.buffId)
end
function e.DoAction(e,t,i,i,o,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.beCriticalOrBlocked then
local a=o
if(a==1)then
local a=t[1]
local o=t[2]
local t={t[3]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,o,t)
end
elseif a.buffTriggerTime==BuffTriggerTime.eachRoundStart or a.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl:ResetImmuneActiveAtkReduceFuryWithCount(e.buffId,t[4])
end
return nil
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.beCriticalOrBlocked or e==BuffTriggerTime.eachRoundStart or e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]
end
return i

