local a={}
local i=a
local e=require('Modules/BattleBuffScript/BuffResurgenceMgr')
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(o,i,a,t)
e.DoResurgence(o,i,a,t)
end
function a.DoResurgence(t,e,a,a)
local a=e[1]
local o=e[2]
local e={e[3],e[4],e[5],e[6],e[7],e[8]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,o,e)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
t.CurrHeroCtrl.WillNotUsual=true
t.CurrHeroCtrl.NotUsualType=HeroState.DyingState
t.isExec=true
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.fatalDmg)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.GetWeight(t,a,e)
return t.buffWeight[1]*e[1]
end
return i

