local t={}
local a=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,o,i,i,i,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
local i=302102509
local i=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(i)
if i then
if t.buffTriggerTime==BuffTriggerTime.teamHeroFatalDmgBefore
or t.buffTriggerTime==BuffTriggerTime.enemyTeamHeroFatalDmgBefore then
a.RecordDeadCount(e,o)
end
if t.buffTriggerTime==BuffTriggerTime.enemyTeamHeroFatalDmgBefore then
a.HpHealthOnDead(e,o)
end
else
if t.buffTriggerTime==BuffTriggerTime.teamHeroDead
or t.buffTriggerTime==BuffTriggerTime.enemyTeamHeroDead then
a.RecordDeadCount(e,o)
end
if t.buffTriggerTime==BuffTriggerTime.enemyTeamHeroDead then
a.HpHealthOnDead(e,o)
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.teamHeroDead
or e==BuffTriggerTime.enemyTeamHeroDead
or e==BuffTriggerTime.teamHeroFatalDmgBefore
or e==BuffTriggerTime.enemyTeamHeroFatalDmgBefore)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.RecordDeadCount(t,e)
e[2]=e[2]+1
end
function t.HpHealthOnDead(e,t)
if t[1]>0 then
local t=e.CurrHeroCtrl.HeroBattleInfo.MaxHP*t[1]*MillionCoe
e.CurrHeroCtrl:HpHealthWithBuffImmediately(t,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
end
end
return a

