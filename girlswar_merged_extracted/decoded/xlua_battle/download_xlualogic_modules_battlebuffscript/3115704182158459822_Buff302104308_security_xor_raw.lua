local s=require("Modules/Battle/BattleUtil")
local t={}
local r=t
function t.GetCanAdd(e,e)
return true
end
function t.OnAdd(t,e)
t.CurrHeroCtrl.HeroBattleInfo:AddHPAndMaxHPPer(e[1]*MillionCoe)
end
function t.OnRemoveSelf(e,t)
e.CurrHeroCtrl.HeroBattleInfo:ReduceHPAndMaxHPPer(t[1]*MillionCoe)
end
function t.DoAction(e,a,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local t=a[3]
local o=a[6]
local n=302104310
local i=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(n)
if i then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
local a,e=e.GetAddHeroCountAndTimes(i)
t=t+a
o=o+e
end
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.ourAllExcludeSelf)
local t=s:GetMinHpPercentHeroArr(i,t)
local i={}
for e=1,#t do
table.insert(i,t[e].HeroId)
end
for s=1,#t do
local n=a[4]
local h=a[5]
local o={o,i,0}
local a=t[s].HeroBattleInfo:GetBuff(n)
if a==nil then
t[s]:AddBuff(e.CurrHeroCtrl,n,h,o)
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundEnd)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return r

