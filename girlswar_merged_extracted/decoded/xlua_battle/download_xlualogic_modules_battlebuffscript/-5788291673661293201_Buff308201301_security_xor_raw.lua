local e={}
local a=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,a,a,a,a,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t and t.buffTriggerTime==BuffTriggerTime.now then
e.isExec=true
end
end
function e.GetCanTrigger(e)
if e==BuffTriggerTime.now then
return true
end
return false
end
function e.SetLogicData(e,e)
end
return a

