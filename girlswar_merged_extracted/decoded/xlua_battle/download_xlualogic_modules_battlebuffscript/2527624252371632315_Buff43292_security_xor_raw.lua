local a=require("Modules/Battle/BattleUtil")
local h=require("Modules/BattleBuffScript/BuffPairTools")
local t={}
local n=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,o,i,a,i,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t.buffTriggerTime==BuffTriggerTime.now then
n.AddCaptiveMark(e,o[1])
elseif t.buffTriggerTime==BuffTriggerTime.enemyTeamHeroDead then
local t=e.CurrHeroCtrl
local e=43293
local e=a.HeroBattleInfo:GetBuff(e)
if e==nil or e.releaseHeroId~=t.HeroId then
return
end
t:CheckClearHpChainData()
end
end
function t.GetCanTrigger(e)
if e==BuffTriggerTime.now
or e==BuffTriggerTime.enemyTeamHeroDead then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.AddCaptiveMark(t,n)
local e=t:GetBuffData()
local i=t.CurrHeroCtrl
local o=e[2]
local s=e[3]
local r=e[4]
local e=a:GetHeroNoBuff(i,o,n)
local a=e[1]
if a==nil then
return
end
local e=a.HeroBattleInfo:GetBuff(o)
if e then
local e=e.releaseHeroId
local e=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e)
if e then
return
end
end
local e={}
local n=43296
local n=i.HeroBattleInfo:GetBuff(n)
if n then
local t=n:GetBuffData()
for a=4,6 do
table.insert(e,t[a])
end
else
for t=4,6 do
table.insert(e,0)
end
end
local e=a:AddBuff(i,o,s,e)
if e then
local e=a.HeroBattleInfo:GetBuff(o)
if e then
local t={
atkMgrHeroId=t.CurrHeroCtrl.HeroId,
atkBuffPairMgrId=t.buffId
}
e:SetDefBuffPairData(t)
end
end
local e=h.GetDefaultHpChainData()
e.assumedamagePercent=r
e.reduceDamagePercent=0
e.minHpPercent=0
e.defHeroId=a.HeroId
e.defBuffId=o
e.notTriggerHurtType=HeroHurtType.buff
e.guardHeroId=t.CurrHeroCtrl.HeroId
t.CurrHeroCtrl:SetHpChainData(e)
end
function t.IsCaptiveMarkFromWearer(t,e)
return t.releaseHeroId==e.HeroId
end
function t.FixChainAssumedamagePercent(t,e)
local a=t:GetBuffData()
if e==nil then
e=a[4]
end
local t=t.CurrHeroCtrl:GetAllHpChainData()
for a=1,#t do
local t=t[a]
t.assumedamagePercent=e
end
end
return n

