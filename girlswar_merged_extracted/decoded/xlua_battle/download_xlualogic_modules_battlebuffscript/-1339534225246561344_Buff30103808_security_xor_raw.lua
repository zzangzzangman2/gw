local n=require("Modules/Battle/BattleUtil")
local a={}
local i=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,i,i,o,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
if#t>=2 then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
end
if#t>=4 then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[3],t[4])
end
elseif a.buffTriggerTime==BuffTriggerTime.addBuff then
if#t>=5 then
if o.buffHeroId==e.CurrHeroCtrl.HeroId then
local a=o.addBuffId
if(n:IsCtlBuff(a))then
local t=e.CurrHeroCtrl.HeroBattleInfo.MaxHP*t[5]*MillionCoe
e.CurrHeroCtrl:HpHealthWithBuff(t,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
e.isExec=true
end
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now or e==BuffTriggerTime.addBuff)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return i

