local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,i,n,o,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
t.CurrHeroCtrl.HeroBattleInfo:CheckAddBuffValue(t.buffId,e[1],e[2])
t.CurrHeroCtrl.HeroBattleInfo:CheckAddBuffValue(t.buffId,e[3],e[4])
elseif a.buffTriggerTime==BuffTriggerTime.DoAddFury
or a.buffTriggerTime==BuffTriggerTime.DoAddFuryWithReset then
if e[5]>0 then
local a=o.addFuryValueIncludingOverflow
e[7]=e[7]+a
if e[7]>=e[5]then
e[7]=0
local a=308101207
local o=1
local e={e[6]}
t.CurrHeroCtrl:AddBuff(i,a,o,e,1)
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.DoAddFury
or e==BuffTriggerTime.DoAddFuryWithReset)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return n

