local e={}
local i=e
local t=require('Modules/BattleBuffScript/BuffResurgenceMgr')
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(o,i,a,e)
t.DoResurgence(o,i,a,e)
end
function e.DoResurgence(e,t,a,a)
local a=t[1]
local o=t[2]
local t={t[3],t[4],t[5]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,o,t)
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
function e.GetWeight(t,a,e)
return t.buffWeight[1]*e[1]
end
return i 
