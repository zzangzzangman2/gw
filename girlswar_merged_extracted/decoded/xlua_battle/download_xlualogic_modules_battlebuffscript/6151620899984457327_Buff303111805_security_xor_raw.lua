local e={}
local t={}
local n=t
local o=require('Modules/BattleBuffScript/BuffResurgenceMgr')
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(a,t,i,e)
o.DoResurgence(a,t,i,e)
end
function t.DoResurgence(e,t,a,a)
local o=t[1]
local a=t[2]
local t={t[3],t[4]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,a,t)
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
return n

