local e={}
local s=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.isExec=true
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.AddBuffBrokenCherry(e,a)
local t=e:GetBuffData()
if a>0 then
local i=t[2]
local n=t[3]
local o={}
for a=4,7 do
table.insert(o,t[a])
end
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,i,n,o,a)
end
end
function e.AddFuryBConsumeFallingCherry(t,e)
local a=t:GetBuffData()
if e>0 then
t.CurrHeroCtrl:AddFuryWithBuff(a[1]*e)
end
end
return s

