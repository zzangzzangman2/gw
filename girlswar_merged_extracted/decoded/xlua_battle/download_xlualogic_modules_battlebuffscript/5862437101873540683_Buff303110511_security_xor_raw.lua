local o=require("Modules/Battle/BattleUtil")
local t={}
local a=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,i,n,n,n,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t.buffTriggerTime==BuffTriggerTime.eachRoundStart
or t.buffTriggerTime==BuffTriggerTime.enemyRoundStart then
if o.IsBigRoundStart(t.buffTriggerTime,e.CurrHeroCtrl)then
a.hurtEnemey(e,i)
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundStart
or e==BuffTriggerTime.enemyRoundStart)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.hurtEnemey(e,t)
if ModulesInit.ProcedureNormalBattle.IsPVE()==false or t[2]==1 then
local a=e.CurrHeroCtrl.HeroBattleInfo:GetMaxHP()
local t=math.floor(a*t[1]*MillionCoe)
e.CurrHeroCtrl:RealHurtWithBuff(t,e)
end
end
return a

