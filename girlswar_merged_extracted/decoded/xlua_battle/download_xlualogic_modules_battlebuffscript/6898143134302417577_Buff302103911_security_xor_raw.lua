local i=require("Modules/Battle/BattleUtil")
local e={}
local a=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,o,i,i,i,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if t.buffTriggerTime==BuffTriggerTime.fatalDmgBefore then
a.TriggerMeilinBless(e)
elseif t.buffTriggerTime==BuffTriggerTime.skillComplete
or t.buffTriggerTime==BuffTriggerTime.buffDamageComplete then
if e.CurrHeroCtrl.HeroBattleInfo.CurrHP>0 then
a.TriggerNewBorn(e,o)
end
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.skillComplete
or e==BuffTriggerTime.buffDamageComplete
or e==BuffTriggerTime.fatalDmgBefore)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.CheckCondition(e)
local e=e:GetBuffData()
local t=e[6]
local e=e[7]
if e<t then
return true
end
return false
end
function e.TriggerMeilinBless(e)
local a=302103916
local t=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if t then
local o=t:GetFloors()
if o>0 then
if i:CheckCanTriggerFatalDmgBefore(e.CurrHeroCtrl)==false then
return
end
t:ReduceFloors(1)
local i=t:GetBuffData()
local t=e.CurrHeroCtrl.HeroBattleInfo.MaxHP
local t=math.floor(t*i[1]*MillionCoe)
e.CurrHeroCtrl:HpHealthWithBuffImmediately(t,EBattleSrcType.DeathImmune,e.releaseHeroId,e.buffId,true)
if o<=1 then
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(a,BuffRemoveType.Expire)
end
return true
end
end
return false
end
function e.TriggerNewBorn(e,t)
local a=e.CurrHeroCtrl:CurrHPPer()
if a<=t[1]*MillionCoe then
local a=t[6]
local o=t[7]
if o<a then
t[7]=t[7]+1
e.CurrHeroCtrl.HeroBattleInfo:DispelAllGranBuff(false)
local a=e.CurrHeroCtrl.HeroBattleInfo.MaxHP
local o=math.floor(a*t[2]*MillionCoe)
i:ReduceSepsisHp(e.CurrHeroCtrl,e.CurrHeroCtrl,o,true,true)
local a=math.floor(a*t[3]*MillionCoe)
e.CurrHeroCtrl:HpHealthWithBuffImmediately(a,EBattleSrcType.Buff,e.releaseHeroId,e.buffId,true)
local a=t[4]
local t=t[5]
local o=0
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,t,o)
return true
end
end
return false
end
return a

