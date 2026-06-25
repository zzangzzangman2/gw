local t=require("Modules/Battle/BattleUtil")
local e={}
local o=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(a,e)
t:ShowCampionEffect(a,e[2],nil,0,true,1.2,true)
end
function e.OnRemoveSelf(e,a)
t:HideCampionEffect(e)
end
function e.DoAction(e,a,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
t:HideCampionEffect(e)
e.isExec=true
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundStart or e==BuffTriggerTime.enemyRoundStart)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
return o

