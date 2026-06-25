local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,a,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
local t=ModulesInit.ProcedureNormalBattle.GetBattleHerosByHeroModelId(e.CurrHeroCtrl,BattleHeroType.ourAll,1044)
local o=false
for a=1,#t do
local t=t[a]
if t.HeroId~=e.CurrHeroCtrl.HeroId then
o=true
break
end
end
if o==false then
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.enemyAll)
if e~=nil then
for t=1,#e do
local e=e[t]
local t=e.HeroBattleInfo:GetBuff(a[1])
if t then
e.HeroBattleInfo:RemoveBuffWithId(a[1],BuffRemoveType.Expire)
end
end
end
end
e.isExec=true
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.HeroDead)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return i

