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
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.ourAllExcludeSelf)
local o=a[1]
for a=1,#t do
local i=t[a].HeroBattleInfo:GetBuff(o)
if i and i.releaseHeroId==e.CurrHeroCtrl.HeroId then
t[a].HeroBattleInfo:RemoveBuffWithId(o,BuffRemoveType.Expire)
end
end
end
function e.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.ourAllExcludeSelf)
local o=t[1]
local n=t[2]
local i={t[3],t[4],t[5],t[6]}
for t=1,#a do
if a[t].HeroBattleInfo:GetBuff(o)==nil then
a[t]:AddBuff(e.CurrHeroCtrl,o,n,i)
end
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
return s

