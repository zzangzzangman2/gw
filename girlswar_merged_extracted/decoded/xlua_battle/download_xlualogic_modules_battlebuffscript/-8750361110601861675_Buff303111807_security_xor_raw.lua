local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local o=t[2]
local i=t[3]
local a={}
for e=4,7 do
table.insert(a,t[e])
end
local t=t[1]
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,i,a,t)
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.evade)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return o

