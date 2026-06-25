local i=require("Modules/Battle/Formula")
local t={}
local n=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.ourAll)
local a=0
for e=1,#o do
local e=i:GetHeroControlRate(o[e])
local e=e.attackFinalControlRate
a=a+e
end
local a=math.floor(a*t[4])
a=math.min(a,t[5])
if a>0 then
local i=t[1]
local o=t[2]
local t={t[3],a}
e.CurrHeroCtrl:AddBuffAfterRemove(e.CurrHeroCtrl,i,o,t)
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return n

