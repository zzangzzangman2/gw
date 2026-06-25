local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,a,a,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e[11]=e[11]or 0
if e[11]>=e[9]then
return nil
end
if t.CurrHeroCtrl.HeroBattleInfo.CurrFury<e[1]then
local a=92341
local a=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if(a==nil)then
e[11]=e[11]+1
t.CurrHeroCtrl:AddFuryWithBuffImmediately(e[2])
local i=e[3]
local o=e[4]
local a={}
for o=5,8 do
table.insert(a,e[o])
end
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,i,o,a)
end
end
return nil
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return n

