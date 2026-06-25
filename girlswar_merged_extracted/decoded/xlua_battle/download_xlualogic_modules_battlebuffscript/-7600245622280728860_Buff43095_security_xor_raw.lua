local a={}
local o=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,o,o,o,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if e[3]==nil then
e[3]=0
end
if a.buffTriggerTime==BuffTriggerTime.beCritical then
if e[3]<e[2]then
e[3]=e[3]+1
local e=t.CurrHeroCtrl.HeroBattleInfo.MaxHP*e[1]*MillionCoe
t.CurrHeroCtrl:HpHealthWithBuff(e,EBattleSrcType.Buff,t.releaseHeroId,t.buffId)
end
elseif a.buffTriggerTime==BuffTriggerTime.eachRoundStart then
e[3]=0
end
return nil
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.beCritical or e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return o

