local e={}
local a=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t[2]>0 then
e.CurrHeroCtrl:AddFuryWithBuffImmediately(t[1]*t[2])
t[2]=0
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.AddCount(e,t)
local e=e:GetBuffData()
e[2]=e[2]+t
end
return a

