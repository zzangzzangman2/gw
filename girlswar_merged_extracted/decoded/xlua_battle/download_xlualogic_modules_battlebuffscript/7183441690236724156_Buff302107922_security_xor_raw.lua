local i=require("Modules/Battle/BattleUtil")
local t={}
local n=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,i,i,o,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[3],t[4])
elseif a.buffTriggerTime==BuffTriggerTime.attack then
if o.triggerSkillAtkType==ETriggerSkillAtkType.Normal then
local a=302107914
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if a then
local a=0
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.ourAll)
for e=1,#o do
local e=o[e]
local e=e.HeroBattleInfo:DispelGranBuff(false,t[6])
a=a+#e
end
if a>0 then
local o=302107909
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if e then
local o=ModulesInit.BattleBuffMgr.GetBuffScript(o)
o.AddEnergyByPercent(e,t[7]*a)
end
end
end
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.attack)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.DoActionWithEnergyExplode(a,t)
local e=a:GetBuffData()
for o=1,#t do
local t=t[o]
local o=e[8]
local i=e[9]
local e={e[10],e[11]}
t:AddBuff(a.CurrHeroCtrl,o,i,e)
end
local t=i:GetMaxFuryHeroArrByHeroArr(t,e[12])
local t=t[1]
if t then
t:ReduceFuryWithBuffImmediately(e[13])
end
end
function t.GetImmuneDeathCount(e)
local e=e:GetBuffData()
return e[5]
end
return n

