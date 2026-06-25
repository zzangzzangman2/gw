local t={}
local s=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(t,e)
local i=e[1]
local a=e[2]
local o=e[3]
local s=e[4]
local n={e[5],e[6],e[7]}
local e=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if(e)then
e.floors=math.min(e.floors+i,a)
if(e.floors==a)then
t.isExec=true
end
else
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,s,n)
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.skill3Play or e==BuffTriggerTime.skill2Play or e==BuffTriggerTime.skillPlay)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.GetWeight(t,a,e)
return t.buffWeight[1]*e[1]
end
return s

