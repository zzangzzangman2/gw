local o=require("Modules/Battle/BattleUtil")
local a={}
local i=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(303102508)
if a==nil then
return
end
if o:CheckCanTriggerFatalDmgBefore(e.CurrHeroCtrl)==false then
return
end
if e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
e.CurrHeroCtrl.HeroBattleInfo:SetHp(1,true)
end
local a=e.CurrHeroCtrl.HeroBattleInfo.MaxHP
local a=math.floor(a*t[1]*MillionCoe)
e.CurrHeroCtrl:HpHealthWithBuffImmediately(a,EBattleSrcType.DeathImmune,e.releaseHeroId,e.buffId)
e.CurrHeroCtrl:AddFuryWithBuff(t[2])
local o=t[3]
local a=t[4]
local t={t[5],t[6]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,a,t,1)
e.isExec=true
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.fatalDmgBefore)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return i

