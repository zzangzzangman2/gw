local a={}
local o=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,i,o,i,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[3],t[4])
elseif a.buffTriggerTime==BuffTriggerTime.attack then
if o:CurrHPPer()>t[5]*MillionCoe then
local a=HeroBuffValueInfo:New()
a.buffId=e.buffId
a.attrId=t[6]
a.value=t[7]
e.CurrHeroCtrl.HeroBattleInfo:AddTempBuffValue(a)
end
end
return nil
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.attack)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return o

