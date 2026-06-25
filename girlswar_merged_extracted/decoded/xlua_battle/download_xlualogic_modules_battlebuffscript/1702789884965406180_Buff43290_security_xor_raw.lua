local e={}
local a=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,o,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
a.AddBuffPreciousMemories(e,t[7])
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.AddBuffPreciousMemories(e,o)
local t=e:GetBuffData()
local a=t[5]
local t=t[6]
local i={}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,t,i,o)
end
return a

