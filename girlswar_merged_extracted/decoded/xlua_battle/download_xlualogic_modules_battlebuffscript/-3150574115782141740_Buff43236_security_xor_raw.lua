local t={}
local n=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if#t>=2 then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
end
e.isExec=true
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.UsePotion(e)
local t=e:GetBuffData()
local o=t[1]
local i=t[2]
local a={}
for o=3,5 do
table.insert(a,t[o])
end
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,i,a)
end
return n

