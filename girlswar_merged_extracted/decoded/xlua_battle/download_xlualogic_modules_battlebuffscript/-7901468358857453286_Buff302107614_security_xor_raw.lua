local e={}
local s=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,e)
end
function e.OnRemoveSelf(e,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.ourAll)
local a=t[1]
local o=t[2]
local t={t[3]}
for t=1,#e do
local e=e[t]
local t=e.HeroBattleInfo:GetBuff(a)
if t then
e.HeroBattleInfo:RemoveBuffWithId(a,BuffRemoveType.Expire)
end
end
end
function e.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.ourAll)
local a=t[1]
local i=t[2]
local n={t[3]}
for t=1,#o do
local t=o[t]
local o=t.HeroBattleInfo:GetBuff(a)
if o==nil then
t:AddBuff(e.CurrHeroCtrl,a,i,n)
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

