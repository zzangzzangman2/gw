local s=require("Modules/Battle/BattleUtil")
local a={}
local h=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,o,o,o,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if e.CurrHeroCtrl:CurrHPPer()<=t[1]*MillionCoe then
local n=30105617
local o=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(n)
if o then
local i=o:GetFloors()
if i>0 then
if a.buffTriggerTime==BuffTriggerTime.skillComplete
or a.buffTriggerTime==BuffTriggerTime.buffDamageComplete then
if e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
elseif a.buffTriggerTime==BuffTriggerTime.fatalDmgBefore then
if s:CheckCanTriggerFatalDmgBefore(e.CurrHeroCtrl)==false then
return
end
end
o:ReduceFloors(1)
if i<=1 then
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(n,BuffRemoveType.Expire)
end
e.CurrHeroCtrl.HeroBattleInfo:DispelAllGranBuff(false)
local o=t[2]
local i=t[3]
local n={t[4],t[5]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,i,n)
local o=e.CurrHeroCtrl.HeroBattleInfo:GetMaxHP()
local o=math.floor(o*t[6]*MillionCoe)
if a.buffTriggerTime==BuffTriggerTime.fatalDmgBefore then
e.CurrHeroCtrl:HpHealthWithBuffImmediately(o,EBattleSrcType.DeathImmune,e.releaseHeroId,e.buffId,true)
else
e.CurrHeroCtrl:HpHealthWithBuffImmediately(o,EBattleSrcType.Buff,e.releaseHeroId,e.buffId,true)
end
e.CurrHeroCtrl:AddFuryWithBuff(t[7])
end
end
end
return nil
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.skillComplete
or e==BuffTriggerTime.buffDamageComplete
or e==BuffTriggerTime.fatalDmgBefore)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return h

