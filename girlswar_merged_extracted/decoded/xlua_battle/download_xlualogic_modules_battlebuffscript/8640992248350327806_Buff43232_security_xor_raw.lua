local e={}
local i=e
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
function e.UsePotion(e)
local t=e:GetBuffData()
local a=t[1]
local t=t[2]
local o={}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,t,o)
end
return i

