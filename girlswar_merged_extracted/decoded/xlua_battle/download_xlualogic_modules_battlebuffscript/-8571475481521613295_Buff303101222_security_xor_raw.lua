local n=require("Modules/Battle/Formula")
local e={}
local s=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.GetRealHurtValue(e,t)
local a=e:GetBuffData()
local e=e.CurrHeroCtrl
local o=0
local i=t.HeroBattleInfo:GetBuff(303101202)
local t=t.HeroBattleInfo:GetBuff(303101203)
if i or t then
local i=a[1]
local t=n:CalculateHeroAttackCriticalRate(e,nil)
local t=t.attackCriticalRate
local e=e:GetFinalAtk()
o=math.floor((i*MillionCoe+t)*e/a[2])
end
return o
end
function e.DoBuffWithSmallSkill(e)
local t=e:GetBuffData()
local i=t[3]
local o=303101211
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if(a)then
if e.CurrHeroCtrl.HeroBattleInfo:HasGranOrUnGran(false)then
local o=ModulesInit.BattleBuffMgr.GetBuffScript(o)
local a=o.ReduceFlower(a,i)
if a then
e.CurrHeroCtrl.HeroBattleInfo:DispelAllGranBuff(false)
local a=t[4]
local o=t[5]
local t={t[6],t[7]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,o,t)
end
end
end
end
return s

