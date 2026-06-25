local t={}
local n=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(t,e,i,i,o,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if a.buffTriggerTime==BuffTriggerTime.DoReduceFury
or a.buffTriggerTime==BuffTriggerTime.DoReduceFuryWithReset
or a.buffTriggerTime==BuffTriggerTime.DoReduceFuryWithFireSkill then
local t=o.reduceFuryValue
e[6]=e[6]+t
end
local o=e[6]
local a=math.floor(o/e[1])
if a>=1 then
e[6]=o-a*e[1]
local o=e[2]
local i=e[3]
local e={e[4],e[5]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,i,e,a)
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.DoReduceFury
or e==BuffTriggerTime.DoReduceFuryWithReset
or e==BuffTriggerTime.DoReduceFuryWithFireSkill
or e==BuffTriggerTime.eachRoundStart
or e==BuffTriggerTime.eachRoundEnd)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return n

