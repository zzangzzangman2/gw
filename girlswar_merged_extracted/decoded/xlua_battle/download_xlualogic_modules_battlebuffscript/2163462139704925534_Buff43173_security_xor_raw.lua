local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,o,a,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local a=t.HeroBattleInfo:DispelGranBuff(false,o[1])
if(a==nil or#a<=0)then
local a=o[2]*MillionCoe
local a=math.floor(t.HeroBattleInfo.MaxHP*a)
t:HpHealthWithBuffImmediately(a,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.attack)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return i

