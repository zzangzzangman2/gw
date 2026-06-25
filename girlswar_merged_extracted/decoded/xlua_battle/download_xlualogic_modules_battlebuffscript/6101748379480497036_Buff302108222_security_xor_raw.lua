local t={}
local i=t
local a=require('Modules/BattleBuffScript/BuffResurgenceMgr')
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,i,o)
a.DoResurgence(e,t,i,o)
end
function t.DoResurgence(e,t,a,a)
local a=t[1]
local o=t[2]
local t={t[3],t[4]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,o,t)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
local t=302108211
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if a then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(t)
e.EnterEmptyState(a,true)
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

