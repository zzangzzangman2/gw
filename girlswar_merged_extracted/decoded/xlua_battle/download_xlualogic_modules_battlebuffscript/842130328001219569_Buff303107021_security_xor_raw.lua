local i=require("Modules/Battle/BattleUtil")
local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,a,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local t=e.CurrHeroCtrl:RealHurtWithBuff(a[1],e)
if t then
if t.hurtValue>0 then
local a=a[2]
local t=math.floor(t.hurtValue*a*MillionCoe)
local a=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e.releaseHeroId)
i:AddSepsisHp(a,e.CurrHeroCtrl,t,true,true)
end
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
return o

