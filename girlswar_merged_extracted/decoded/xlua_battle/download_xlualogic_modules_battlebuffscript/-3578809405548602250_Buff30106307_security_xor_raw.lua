local o={}
local s=o
function o.GetCanAdd(e,e)
return true
end
function o.DoAction(t,e,o,o,o,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.eachRoundStart or a.buffTriggerTime==BuffTriggerTime.eachRoundEnd then
e[1]=e[1]+1
end
if a.buffTriggerTime==BuffTriggerTime.now or a.buffTriggerTime==BuffTriggerTime.eachRoundEnd then
if e[1]>=e[2]then
e[1]=e[1]-e[2]
local i=e[3]*MillionCoe
local o=t.CurrHeroCtrl.HeroBattleInfo:GetMaxHP()
local n=math.floor(o*i)
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.ourAll)
local o=e[4]
local e=e[5]
local n={n}
for a=1,#i do
local a=i[a]
a:AddBuff(t.CurrHeroCtrl,o,e,n)
end
if a.buffTriggerTime==BuffTriggerTime.eachRoundEnd then
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.ourAll)
for t=1,#e do
local e=e[t]
e.HeroBattleInfo:PlayBattleEffectWithBuffId(o)
end
end
end
end
return nil
end
function o.GetCanTrigger(e)
if(e==BuffTriggerTime.now or e==BuffTriggerTime.eachRoundStart or e==BuffTriggerTime.eachRoundEnd)then
return true
end
return false
end
function o.SetLogicData(e,e)
end
return s

