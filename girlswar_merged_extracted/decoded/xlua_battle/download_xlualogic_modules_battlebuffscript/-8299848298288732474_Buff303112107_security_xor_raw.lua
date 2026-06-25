local a=require('Modules/BattleBuffScript/BuffResurgenceMgr')
local t={}
local n=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(t,i,o,e)
a.DoResurgence(t,i,o,e)
end
function t.DoResurgence(e,t,a,a)
local o=t[1]
local a=t[2]
local t={t[3],t[4],t[5]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,a,t)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.CurrHeroCtrl.WillNotUsual=true
e.CurrHeroCtrl.NotUsualType=HeroState.Freeze
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

