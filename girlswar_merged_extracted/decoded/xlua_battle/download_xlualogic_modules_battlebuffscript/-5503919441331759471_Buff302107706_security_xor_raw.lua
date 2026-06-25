local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local i=t[1]
local n=t[2]
local o=t[3]
local a={}
for o=4,9 do
table.insert(a,t[o])
end
e.CurrHeroCtrl:CheckAddBuff(i,e.CurrHeroCtrl,n,o,a)
e.isExec=true
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return i

