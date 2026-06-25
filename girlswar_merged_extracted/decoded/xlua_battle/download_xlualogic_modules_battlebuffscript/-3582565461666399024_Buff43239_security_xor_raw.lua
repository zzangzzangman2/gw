local e={}
local n=e
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
function e.UsePotion(t)
local a=t:GetBuffData()
local o=a[1]
local i=a[2]
local e={}
for t=3,10 do
table.insert(e,a[t])
end
table.insert(e,0)
table.insert(e,0)
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,i,e)
end
return n

