local e={}
local n=e
local i=require('Modules/BattleBuffScript/BuffResurgenceMgr')
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(t,o,e,a)
i.DoResurgence(t,o,e,a)
end
function e.DoResurgence(e,t,a,a)
local o=t[1]
local i=t[2]
local a={}
for o=3,10 do
table.insert(a,t[o])
end
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,i,a)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.CurrHeroCtrl.WillNotUsual=true
e.CurrHeroCtrl.NotUsualType=HeroState.DyingState
e.isExec=true
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.fatalDmg)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]
end
return n

