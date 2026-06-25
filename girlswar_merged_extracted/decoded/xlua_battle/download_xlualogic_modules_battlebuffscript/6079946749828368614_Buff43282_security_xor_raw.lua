local i=require("Modules/Battle/BattleUtil")
local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,n,n,n,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.skillAttackComplete then
local a=t[1]
local o=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(43280)
if o then
a=t[2]
end
local t=e.CurrHeroCtrl.HeroBattleInfo.MaxHP
local t=math.floor(t*a*MillionCoe)
if e.CurrHeroCtrl.HeroBattleInfo.SepsisHp>0 then
i:ReduceSepsisHp(e.CurrHeroCtrl,e.CurrHeroCtrl,t,true,true)
else
e.CurrHeroCtrl:HpHealthWithBuffImmediately(t,EBattleSrcType.Buff,e.releaseHeroId,e.buffId,true)
end
elseif a.buffTriggerTime==BuffTriggerTime.now then
o.ResetData(e,t)
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.skillAttackComplete
or e==BuffTriggerTime.now)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.ResetData(e,t,o)
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(43280)
if a and o~=true then
e.CurrHeroCtrl:AddReduceSepsisRate(e.buffId,t[3])
else
e.CurrHeroCtrl:RemoveSepsisReduceRate(e.buffId)
end
end
return o

