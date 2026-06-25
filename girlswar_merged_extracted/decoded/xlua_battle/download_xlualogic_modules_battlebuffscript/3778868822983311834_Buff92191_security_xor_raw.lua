local a=require('Modules/BattleBuffScript/BuffResurgenceMgr')
local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(t,i,o,e)
a.DoResurgence(t,i,o,e)
end
function t.DoResurgence(e,t,a,a)
local a=t[1]
local o=t[2]
local t={t[3]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,o,t)
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
return i

