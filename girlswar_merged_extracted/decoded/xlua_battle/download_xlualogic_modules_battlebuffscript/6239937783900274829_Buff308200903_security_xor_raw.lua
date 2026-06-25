local i=require("Modules/Battle/BattleUtil")
local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,n,n,o,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[3],t[4])
elseif a.buffTriggerTime==BuffTriggerTime.addBuff then
if o.buffHeroId==e.CurrHeroCtrl.HeroId then
local e=o.addBuffId
if(i:IsCtlBuff(e))then
t[9]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
end
end
elseif a.buffTriggerTime==BuffTriggerTime.eachRoundEnd then
if t[9]==ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
local a=math.floor(t[10]*t[6]*MillionCoe)
local t=math.floor(e.CurrHeroCtrl.HeroBattleInfo.MaxHP*t[5]*MillionCoe)
t=math.min(t,a)
e.CurrHeroCtrl:RealHurtWithBuff(t,e)
end
elseif a.buffTriggerTime==BuffTriggerTime.attack then
if t[7]>0 then
local a=math.floor(t[10]*t[8]*MillionCoe)
local t=math.floor(e.CurrHeroCtrl.HeroBattleInfo.MaxHP*t[7]*MillionCoe)
t=math.min(t,a)
e.CurrHeroCtrl:RealHurtWithBuff(t,e)
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.addBuff
or e==BuffTriggerTime.eachRoundEnd
or e==BuffTriggerTime.attack)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return n

