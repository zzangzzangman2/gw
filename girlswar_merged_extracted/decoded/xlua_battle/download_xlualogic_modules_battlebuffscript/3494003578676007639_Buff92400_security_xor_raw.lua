local n=require("Modules/Battle/BattleUtil")
local o={}
local i=o
function o.GetCanAdd(e,e)
return true
end
function o.DoAction(e,t,o,o,o,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if a.buffTriggerTime==BuffTriggerTime.resurgence then
i.TriggerLimitSkill(e,t)
end
if e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
i.AddBuffIce(e,t)
elseif a.buffTriggerTime==BuffTriggerTime.eachRoundStart
or a.buffTriggerTime==BuffTriggerTime.enemyRoundStart then
if t[8]+t[3]<=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
i.AddBuffIce(e,t)
end
elseif a.buffTriggerTime==BuffTriggerTime.eachRoundEnd then
local a=e.CurrHeroCtrl.HeroBattleInfo.MaxHP
local t=math.floor(a*t[4]*MillionCoe)
n:ReduceSepsisHp(e.CurrHeroCtrl,e.CurrHeroCtrl,t,true,true)
elseif a.buffTriggerTime==BuffTriggerTime.afterSufferDmg
or a.buffTriggerTime==BuffTriggerTime.SepsisHpChangeDirect then
i.TriggerLimitSkill(e,t)
end
end
function o.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.eachRoundStart
or e==BuffTriggerTime.enemyRoundStart
or e==BuffTriggerTime.eachRoundEnd
or e==BuffTriggerTime.afterSufferDmg
or e==BuffTriggerTime.SepsisHpChangeDirect
or e==BuffTriggerTime.resurgence
)then
return true
end
return false
end
function o.SetLogicData(e,e)
end
function o.AddBuffIce(e,t)
local o=t[1]
local a=t[2]
local t={}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,a,t)
end
function o.TriggerLimitSkill(t,e)
local a=e[7]
e[9]=e[9]or 0
if(e[9]>=a)then
return nil
end
local a=t.CurrHeroCtrl:CurrSepsisHPPer()
if a<e[5]*MillionCoe then
return
end
e[9]=e[9]+1
local a=t.CurrHeroCtrl.HeroBattleInfo.MaxHP
local e=math.floor(a*e[6]*MillionCoe)
n:ReduceSepsisHp(t.CurrHeroCtrl,t.CurrHeroCtrl,e,true,true,t.buffId,true)
end
return i

