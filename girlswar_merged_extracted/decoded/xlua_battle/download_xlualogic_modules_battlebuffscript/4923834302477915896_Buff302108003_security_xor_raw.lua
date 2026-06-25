local o=require("Modules/Battle/BattleUtil")
local t={}
local n=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,a,i,i,i,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.HeroBattleInfo:AddHPAndMaxHPPer(a[1]*MillionCoe)
e.CurrHeroCtrl:AddImmuneResurgence(e.buffId)
elseif t.buffTriggerTime==BuffTriggerTime.eachRoundStart then
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.ourAll)
for e=1,#t do
local e=t[e]
e:AddFuryWithBuff(a[3])
e.HeroBattleInfo:PlayBattleEffectWithType(BattleEffectType.AddFury)
end
local t=o:GetMinHpPercentHeroArr(t,1)
local t=t[1]
if t then
local a=a[2]*MillionCoe
local a=math.floor(t.HeroBattleInfo.MaxHP*a)
t:HpHealthWithBuffImmediately(a,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
end
end
return nil
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now or e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.AddLightCount(t,e)
local e=t:GetBuffData()
e[16]=e[16]+1
local a=e[4]
if e[16]>=a then
local a=e[5]
local o=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if o==nil then
local i=e[6]
local o={}
for a=7,15 do
table.insert(o,e[a])
end
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,i,o)
end
end
end
return n

