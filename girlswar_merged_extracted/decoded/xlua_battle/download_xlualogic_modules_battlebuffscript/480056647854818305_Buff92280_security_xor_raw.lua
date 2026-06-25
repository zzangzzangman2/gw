local o={}
local i=o
function o.GetCanAdd(e,e)
return true
end
function o.DoAction(t,e,o,o,o,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.enemyTeamHeroDead then
if e[9]==2 then
e[9]=1
end
elseif a.buffTriggerTime==BuffTriggerTime.skillPlay
or a.buffTriggerTime==BuffTriggerTime.skill2Play
or a.buffTriggerTime==BuffTriggerTime.skill3Play then
e[9]=2
elseif a.buffTriggerTime==BuffTriggerTime.skillPlayEnd then
if e[9]==1 then
local o=e[1]
local a=e[2]
local e={e[3],e[4]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,a,e)
end
e[9]=0
elseif a.buffTriggerTime==BuffTriggerTime.skill2PlayEnd
or a.buffTriggerTime==BuffTriggerTime.skill3PlayEnd then
if e[9]==1 then
local a=e[5]
local o=e[6]
local e={e[7],e[8]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,o,e)
end
e[9]=0
end
end
function o.GetCanTrigger(e)
if(e==BuffTriggerTime.enemyTeamHeroDead
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

