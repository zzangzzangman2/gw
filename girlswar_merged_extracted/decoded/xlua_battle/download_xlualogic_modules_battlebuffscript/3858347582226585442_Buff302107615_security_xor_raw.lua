local e={}
local s=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,e)
end
function e.OnRemoveSelf(e,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.enemyAll)
local e=a[1]
for a=1,#t do
local t=t[a]
local a=t.HeroBattleInfo:GetBuff(e)
if a then
t.HeroBattleInfo:RemoveBuffWithId(e,BuffRemoveType.Expire)
end
end
end
function e.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.enemyAll)
local o=t[1]
local n=t[2]
local i={t[3],t[4]}
for t=1,#a do
local t=a[t]
local a=t.HeroBattleInfo:GetBuff(o)
if a==nil then
t:AddBuff(e.CurrHeroCtrl,o,n,i)
end
end
end
function e.GetCanTrigger(e)
if e==BuffTriggerTime.now or e==BuffTriggerTime.eachRoundStart then
return true
end
return false
end
function e.SetLogicData(e,e)
end
return s

