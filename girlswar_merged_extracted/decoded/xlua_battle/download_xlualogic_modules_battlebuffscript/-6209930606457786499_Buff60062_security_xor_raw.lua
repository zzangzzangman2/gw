local t={}
local i=t
local o=require('Modules/BattleBuffScript/BuffResurgenceMgr')
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(i,t,a,e)
o.DoResurgence(i,t,a,e)
end
function t.DoResurgence(e,o,t,t)
local a=60117
local t=-1
local o={o[1]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,t,o)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.CurrHeroCtrl.WillNotUsual=true
e.CurrHeroCtrl.NotUsualType=HeroState.DyingState
e.isExec=true
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.fatalDmg)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]
end
return i

