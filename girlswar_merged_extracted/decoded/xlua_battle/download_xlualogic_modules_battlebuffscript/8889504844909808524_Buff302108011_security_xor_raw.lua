local o={}
local s=o
function o.GetCanAdd(e,e)
return true
end
function o.DoAction(t,e,a,a,a,o)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if o.buffTriggerTime==BuffTriggerTime.now then
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[1],e[2])
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[3],e[4])
local a={}
for o,t in pairs(ProfessionType)do
a[t]=e[22]
end
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.ourAllExcludeSelf)
for t=1,#o do
local t=o[t]
local t=t.profession
if a[t]and a[t]<e[23]then
a[t]=a[t]+1
end
end
local o=e[24]
local o=a[o]or 0
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[25],e[26]*o)
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[27],e[28]*o)
local o=e[29]
local o=a[o]or 0
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[30],e[31]*o)
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[32],e[33]*o)
local o=e[34]
local a=a[o]or 0
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[35],e[36]*a)
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[37],e[38]*a)
t.CurrHeroCtrl:AddFuryWithBuff(e[39]*a)
t.CurrHeroCtrl.HeroBattleInfo:PlayBattleEffectWithType(BattleEffectType.AddFury)
elseif o.buffTriggerTime==BuffTriggerTime.eachRoundEnd then
local a=e[21]
local i=e[5]
local o=e[6]
local n={e[7],e[8]}
t.CurrHeroCtrl:AddBuffWithMaxFloor(t.CurrHeroCtrl,i,o,n,1,a)
local i=e[9]
local o=e[10]
local n={e[11],e[12]}
t.CurrHeroCtrl:AddBuffWithMaxFloor(t.CurrHeroCtrl,i,o,n,1,a)
local n=e[13]
local i=e[14]
local o={e[15],e[16]}
t.CurrHeroCtrl:AddBuffWithMaxFloor(t.CurrHeroCtrl,n,i,o,1,a)
local o=e[17]
local i=e[18]
local e={e[19],e[20]}
t.CurrHeroCtrl:AddBuffWithMaxFloor(t.CurrHeroCtrl,o,i,e,1,a)
end
return nil
end
function o.GetCanTrigger(e)
if(e==BuffTriggerTime.now or e==BuffTriggerTime.eachRoundEnd)then
return true
end
return false
end
function o.SetLogicData(e,e)
end
return s

