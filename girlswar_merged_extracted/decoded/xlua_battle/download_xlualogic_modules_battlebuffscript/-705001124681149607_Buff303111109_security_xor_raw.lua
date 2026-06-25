local n=require("Modules/Battle/BattleUtil")
local o={}
local h=o
function o.GetCanAdd(e,e)
return true
end
function o.DoAction(t,e,a,i,s,o)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if o.buffTriggerTime==BuffTriggerTime.now then
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[1],e[2])
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[3],e[4])
elseif o.buffTriggerTime==BuffTriggerTime.afterAttacked then
local a=t.CurrHeroCtrl.HeroId
if a==i.HeroId then
local a=s.reduceHpValue
e[9]=e[9]+a
local o=t.CurrHeroCtrl.HeroBattleInfo.MaxHP*e[5]*MillionCoe
local i=e[8]
if e[10]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[10]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[11]=0
end
if e[11]<i then
if e[9]>o then
local a=math.floor(e[9]/o)
a=math.min(a,i-e[11])
e[11]=e[11]+a
e[9]=e[9]-o*a
local o=e[6]
local i=e[7]
local e={}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,i,e,a)
end
end
end
elseif o.buffTriggerTime==BuffTriggerTime.immuneDamageConsume then
if t.CurrHeroCtrl.immuneDamageWithConsume==false then
local e=303111110
local a=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(e)
if a then
n:ReduceHeroBuffFloor(t.CurrHeroCtrl,e,1)
t.CurrHeroCtrl:SetImmuneDamageWithConsume(true)
end
end
end
end
function o.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.afterAttacked
or e==BuffTriggerTime.immuneDamageConsume)then
return true
end
return false
end
function o.SetLogicData(e,e)
end
return h

