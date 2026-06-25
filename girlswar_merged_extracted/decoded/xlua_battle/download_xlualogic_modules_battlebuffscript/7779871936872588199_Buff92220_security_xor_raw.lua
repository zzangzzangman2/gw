local a={}
local r=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,a,a,a,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if(e[1]>=RandomMgr:GetBattleRandom())then
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.ourAllExcludeSelf)
local a=RandomTableWithSeed(a,e[2])
table.insert(a,t.CurrHeroCtrl)
local n=e[3]
local o=e[4]
local r={e[5],e[6],e[7],e[8],e[9],e[10]}
local s=e[10]
local i=e[11]
for h=1,#a do
local a=a[h]
a:AddBuff(t.CurrHeroCtrl,n,o,r)
local e={e[12],0}
a:AddBuff(t.CurrHeroCtrl,s,i,e)
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return r

