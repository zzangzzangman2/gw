local e={}
local o=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.isExec=true
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.DoActionLightSkill(e)
local t=e:GetBuffData()
local a=e.CurrHeroCtrl.HeroBattleInfo.MaxHP*t[1]*MillionCoe
e.CurrHeroCtrl:HpHealthWithBuffImmediately(a,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
e.CurrHeroCtrl:AddFuryWithBuff(t[2])
end
return o

