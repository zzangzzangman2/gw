local a={}
local s=a
local t=require('Modules/BattleBuffScript/BuffResurgenceMgr')
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,a,i,o)
t.DoResurgence(e,a,i,o)
end
function a.DoResurgence(e,t,a,a)
local i=t[1]
local o=303101211
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if(a)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(o)
e.ReduceFlower(a,i)
end
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.enemyAll)
for n=1,#a do
local o=t[2]
local i=t[3]
local t={t[4],t[5]}
a[n]:AddBuff(e.CurrHeroCtrl,o,i,t)
end
local o=t[6]
local a=t[7]
local t={t[8],t[9]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,a,t)
local t=303101223
local a=-1
local o=0
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,t,a,o)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if(e.CurrHeroCtrl.HeroBattleInfo~=nil)then
e.CurrHeroCtrl.HeroBattleInfo:ClearAllBuffWhenDying()
end
e.CurrHeroCtrl:SetHeroPetShowCtrl(false)
e.CurrHeroCtrl:SetHeroHeadBarShowCtrl(false)
e.CurrHeroCtrl.WillNotUsual=true
e.CurrHeroCtrl.NotUsualType=HeroState.DyingState
e.isExec=true
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.fatalDmg)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]
end
return s

