local e={}
local i=e
local t=require('Modules/BattleBuffScript/BuffResurgenceMgr')
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(a,i,e,o)
t.DoResurgence(a,i,e,o)
end
function e.DoResurgence(e,t,a,a)
local a=3005
local o=-1
local t={t[1],t[2]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,o,t)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.CurrHeroCtrl.WillNotUsual=true
e.CurrHeroCtrl.NotUsualType=HeroState.Freeze
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
return e.buffWeight[1]*t[1]+e.buffWeight[2]*t[2]
end
return i

