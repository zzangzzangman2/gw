local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,a,a,a,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if o.buffTriggerTime==BuffTriggerTime.eachRoundStart then
local i=t[1]
local o=t[2]
local a={}
for e=3,10 do
table.insert(a,t[e])
end
table.insert(a,0)
table.insert(a,0)
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,i,o,a)
elseif o.buffTriggerTime==BuffTriggerTime.eachRoundEnd then
local o=t[11]
local i=t[12]
local a={}
for e=13,19 do
table.insert(a,t[e])
end
table.insert(a,0)
table.insert(a,0)
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,i,a)
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundStart
or e==BuffTriggerTime.eachRoundEnd)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return n

