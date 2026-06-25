local e={}
local a=e
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
function e.DoActionBigSkill(e)
local t=e:GetBuffData()
if e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=t[1]then
return true
end
return false
end
return a

