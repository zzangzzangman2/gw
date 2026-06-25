local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,n,n,i,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if a.buffTriggerTime==BuffTriggerTime.eachRoundEnd then
if e.CurrHeroCtrl.HeroBattleInfo.CurrHP>0 then
if t[3]>0 then
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle~=true)then
e:PlayBuffPrefabEffect(EBuffEffectType.custom)
end
e.CurrHeroCtrl:RealHurtWithBuff(t[3],e)
if e.CurrHeroCtrl and e.CurrHeroCtrl:IsDeathOrWaitState()then
t[4]=1
end
end
end
elseif a.buffTriggerTime==BuffTriggerTime.afterSufferDmg then
local e=i.hurtValue
if e>0 then
t[3]=math.min(t[1],t[3]+e)
end
elseif a.buffTriggerTime==BuffTriggerTime.HeroDead then
if t[4]==1 then
local i=303110801
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.ourAllExcludeSelf)
local a={}
for e=1,#t do
local e=t[e]
local t=e.HeroBattleInfo:GetBuff(i)
if t==nil then
table.insert(a,e)
end
end
local t=RandomTableWithSeed(a,1)
local t=t[1]
if t then
o.AddBuffSeed(e,t,0)
end
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundEnd
or e==BuffTriggerTime.afterSufferDmg
or e==BuffTriggerTime.HeroDead)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.AddBuffSeed(e,o,a)
local t=e:GetBuffData()
local i=e.buffId
local n=-1
local t={t[1],t[2],a*t[1]*MillionCoe}
o:AddBuff(e.CurrHeroCtrl,i,n,t)
end
function t.GetAccumulateDamage(e)
local e=e:GetBuffData()
return e[3]
end
return o

