local o=require("Modules/Battle/BattleUtil")
local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,a,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if o:CheckCanTriggerFatalDmgBefore(e.CurrHeroCtrl)==false then
return
end
local t=e.CurrHeroCtrl
if t.HeroBattleInfo.CurrHP<=0 then
t.HeroBattleInfo:SetHp(1,true)
end
t.HeroBattleInfo:ClearAllGranBuff(false)
local i=303112302
local o=o:GetHeroBuffFloor(t,i)
local o=math.floor(t.HeroBattleInfo.MaxHP*o*a[1]*MillionCoe)
t:HpHealthWithBuffImmediately(o,EBattleSrcType.DeathImmune,e.releaseHeroId,e.buffId)
t:AddFuryWithBuff(a[2])
e.isExec=true
end
function a.GetCanTrigger(e)
if e==BuffTriggerTime.fatalDmgBefore then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return n

