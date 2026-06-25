local a=require("Modules/Battle/BattleUtil")
local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,o,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if a:CheckCanTriggerFatalDmgBefore(e.CurrHeroCtrl)==false then
return
end
local a=e.CurrHeroCtrl.HeroBattleInfo.MaxHP
local a=math.floor(a*t[1]*MillionCoe)
e.CurrHeroCtrl:HpHealthWithBuffImmediately(a,EBattleSrcType.DeathImmune,e.releaseHeroId,e.buffId,true)
e.CurrHeroCtrl:AddFuryWithBuff(t[2])
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
return o

