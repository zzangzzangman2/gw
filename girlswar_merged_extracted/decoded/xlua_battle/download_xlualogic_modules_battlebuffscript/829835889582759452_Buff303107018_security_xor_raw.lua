local i=require("Modules/Battle/BattleUtil")
local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,o,o,o,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
local o=e.CurrHeroCtrl:CurrHPPer()
if o<t[1]*MillionCoe and e.isExec==false then
if a.buffTriggerTime==BuffTriggerTime.skillComplete
or a.buffTriggerTime==BuffTriggerTime.buffDamageComplete then
if o<=0 then
return
end
elseif a.buffTriggerTime==BuffTriggerTime.fatalDmgBefore then
if i:CheckCanTriggerFatalDmgBefore(e.CurrHeroCtrl)==false then
return
end
end
e.isExec=true
local o=t[10]*MillionCoe
local o=e.CurrHeroCtrl.HeroBattleInfo.MaxHP*o
if a.buffTriggerTime==BuffTriggerTime.fatalDmgBefore then
e.CurrHeroCtrl:HpHealthWithBuffImmediately(o,EBattleSrcType.DeathImmune,e.releaseHeroId,e.buffId,true)
else
e.CurrHeroCtrl:HpHealthWithBuffImmediately(o,EBattleSrcType.Buff,e.releaseHeroId,e.buffId,true)
end
e.CurrHeroCtrl:AddFuryWithBuff(t[11])
local a=t[2]
local o=t[3]
local t={t[4],t[5],t[6],t[7],t[8],t[9]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,o,t,1)
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.fatalDmgBefore
or e==BuffTriggerTime.skillComplete
or e==BuffTriggerTime.buffDamageComplete)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return n

