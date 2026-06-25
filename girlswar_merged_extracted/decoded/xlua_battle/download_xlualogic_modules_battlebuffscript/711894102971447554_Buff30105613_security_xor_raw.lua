local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local a=t[1]
local t=0
for o=#a,1,-1 do
local e=a[o]
t=t+e.damage
e.round=e.round-1
if e.round<=0 then
table.remove(a,o)
end
end
if t>0 then
e.CurrHeroCtrl:RealHurtWithBuff(t,e)
end
return nil
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundEnd)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return i

