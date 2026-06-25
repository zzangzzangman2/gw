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
function t.DoResurgence(t,e,a,a)
local o=e[1]
local a=e[2]
local e={e[3],e[4],e[5],e[6],e[7],e[8]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,a,e)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
t.CurrHeroCtrl.WillNotUsual=true
t.CurrHeroCtrl.NotUsualType=HeroState.DyingState
t.isExec=true
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

