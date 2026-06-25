local e={}
local a=require('Modules/BattleBuffScript/BuffResurgenceMgr')
local t={}
local s=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(i,t,o,e)
a.DoResurgence(i,t,o,e)
end
function t.DoResurgence(e,t,a,a)
local a=e.CurrHeroCtrl.CurrBattleTeam:GetAllHeros(true)
local o=303111102
local i=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if i then
for n=1,#a do
local e=ModulesInit.BattleBuffMgr.GetBuffScript(o)
e.AddBuffBrokenArmy(i,a[n],t[1])
end
end
local o=t[2]
local a=t[3]
local t={t[4],t[5]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,a,t)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.CurrHeroCtrl:AddBuffTeamStatCount(e.buffId,1)
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
return s

