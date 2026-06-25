local a={}
local i=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,o,i,o,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
elseif a.buffTriggerTime==BuffTriggerTime.attack then
local o=t[3]
local a=t[4]
local n=t[5]
local t=t[6]*MillionCoe
local t=math.floor(e.CurrHeroCtrl:GetFinalAtk()*t)
local t={t}
i:CheckAddBuff(o,e.CurrHeroCtrl,a,n,t)
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
return i

