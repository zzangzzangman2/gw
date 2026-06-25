local o={}
local i=o
function o.GetCanAdd(e,e)
return true
end
function o.DoAction(a,e,o,o,o,t)
if a==nil or a.CurrHeroCtrl==nil or a.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if t.buffTriggerTime==BuffTriggerTime.now then
a.CurrHeroCtrl.HeroBattleInfo:CheckAddBuffValue(a.buffId,e[1],e[2])
a.CurrHeroCtrl.HeroBattleInfo:CheckAddBuffValue(a.buffId,e[3],e[4])
elseif t.buffTriggerTime==BuffTriggerTime.skillPlay
or t.buffTriggerTime==BuffTriggerTime.skill2Play
or t.buffTriggerTime==BuffTriggerTime.skill3Play then
e[15]=1
elseif t.buffTriggerTime==BuffTriggerTime.skillPlayEnd
or t.buffTriggerTime==BuffTriggerTime.skill2PlayEnd
or t.buffTriggerTime==BuffTriggerTime.skill3PlayEnd then
e[15]=0
elseif t.buffTriggerTime==BuffTriggerTime.enemyTeamHeroDead
or t.buffTriggerTime==BuffTriggerTime.enemyTeamHeroFakeDead then
if e[15]==1 and e[5]>0 then
local n=e[5]
local i=e[6]
local t={}
for o=7,14 do
if e[o]then
table.insert(t,e[o])
else
table.insert(t,0)
end
end
a.CurrHeroCtrl:AddBuff(a.CurrHeroCtrl,n,i,t)
end
end
end
function o.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.skillPlay
or e==BuffTriggerTime.skill2Play
or e==BuffTriggerTime.skill3Play
or e==BuffTriggerTime.skillPlayEnd
or e==BuffTriggerTime.skill2PlayEnd
or e==BuffTriggerTime.skill3PlayEnd
or e==BuffTriggerTime.enemyTeamHeroDead
or e==BuffTriggerTime.enemyTeamHeroFakeDead)then
return true
end
return false
end
function o.SetLogicData(e,e)
end
return i

