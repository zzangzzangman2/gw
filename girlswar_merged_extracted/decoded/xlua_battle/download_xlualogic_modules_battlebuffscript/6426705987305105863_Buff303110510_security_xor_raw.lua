local a=require("Modules/Battle/BattleUtil")
local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,o,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if a:CheckCanTriggerFatalDmgBefore(e.CurrHeroCtrl)==false then
return
end
if e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
e.CurrHeroCtrl.HeroBattleInfo:SetHp(1,true)
end
local t=e.CurrHeroCtrl.HeroBattleInfo.MaxHP
local t=math.floor(t*o[1]*MillionCoe)
e.CurrHeroCtrl:HpHealthWithBuffImmediately(t,EBattleSrcType.DeathImmune,e.releaseHeroId,e.buffId)
e.isExec=true
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.fatalDmgBefore)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return i

