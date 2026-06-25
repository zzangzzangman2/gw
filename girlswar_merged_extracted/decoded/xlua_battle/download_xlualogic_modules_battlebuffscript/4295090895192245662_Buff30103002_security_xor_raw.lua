local e={}
local a=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.CurrHeroCtrl:AddFuryWithSkillAndEffect(t[1])
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.DoReduceFury)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
return a

