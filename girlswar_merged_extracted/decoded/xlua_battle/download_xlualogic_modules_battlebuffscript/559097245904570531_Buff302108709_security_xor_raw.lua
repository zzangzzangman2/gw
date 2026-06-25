local o={}
local i=o
function o.GetCanAdd(e,e)
return true
end
function o.DoAction(a,e,o,o,o,t)
if a==nil or a.CurrHeroCtrl==nil or a.CurrHeroCtrl.HeroBattleInfo==nil or a.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t.buffTriggerTime==BuffTriggerTime.enemyTeamHeroFatalDmgBefore then
if e[1]==2 then
e[1]=1
end
elseif t.buffTriggerTime==BuffTriggerTime.skillPlay
or t.buffTriggerTime==BuffTriggerTime.skill2Play
or t.buffTriggerTime==BuffTriggerTime.skill3Play then
e[1]=2
elseif t.buffTriggerTime==BuffTriggerTime.skillPlayEnd
or t.buffTriggerTime==BuffTriggerTime.skill2PlayEnd
or t.buffTriggerTime==BuffTriggerTime.skill3PlayEnd then
if e[1]==1 then
local i=e[4]
local o=e[5]
local t={e[6]}
a.CurrHeroCtrl:AddBuff(a.CurrHeroCtrl,i,o,t)
a.CurrHeroCtrl.HeroBattleInfo:AddHPAndMaxHPPer(e[6]*MillionCoe)
end
e[1]=0
end
end
function o.GetCanTrigger(e)
if(e==BuffTriggerTime.enemyTeamHeroFatalDmgBefore
or e==BuffTriggerTime.skillPlay
or e==BuffTriggerTime.skill2Play
or e==BuffTriggerTime.skill3Play
or e==BuffTriggerTime.skillPlayEnd
or e==BuffTriggerTime.skill2PlayEnd
or e==BuffTriggerTime.skill3PlayEnd)then
return true
end
return false
end
function o.SetLogicData(e,e)
end
return i

