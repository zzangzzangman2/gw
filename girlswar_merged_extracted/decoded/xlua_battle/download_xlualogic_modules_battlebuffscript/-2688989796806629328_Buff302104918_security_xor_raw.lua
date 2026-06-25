local o={}
local s=o
function o.GetCanAdd(e,e)
return true
end
function o.DoAction(t,e,a,a,a,o)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if o.buffTriggerTime==BuffTriggerTime.eachRoundStart then
local a=e[14]or 0
if a>0 then
t.CurrHeroCtrl:AddFuryWithBuff(a)
e[14]=0
end
elseif o.buffTriggerTime==BuffTriggerTime.eachRoundEnd then
local a=t.CurrHeroCtrl.HeroBattleInfo:GetCurrFury()
local o=math.min(a,e[11])
local a=e[15]or 0
local i=e[1]
if o>0 and a<i then
e[14]=o
t.CurrHeroCtrl:ReduceFuryWithBuffImmediately(o)
local n=math.max(e[12],1)
local o=math.floor(o/n*e[13])
local n=o/i
local s=t.CurrHeroCtrl.HeroBattleInfo.MaxHP
local n=math.floor(s*n)
t.CurrHeroCtrl:HpHealthWithBuffImmediately(n,EBattleSrcType.Buff,t.releaseHeroId,t.buffId)
a=math.min(i,a+o)
e[15]=a
local o=math.max(e[2],1)
local a=math.floor(a/o)
local n=e[3]
local o=e[4]
local i={e[5],e[6]}
t.CurrHeroCtrl:AddBuffWithFinalFloor(t.CurrHeroCtrl,n,o,i,a)
local i=e[7]
local o=e[8]
local e={e[9],e[10]}
t.CurrHeroCtrl:AddBuffWithFinalFloor(t.CurrHeroCtrl,i,o,e,a)
end
end
end
function o.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundStart or e==BuffTriggerTime.eachRoundEnd)then
return true
end
return false
end
function o.SetLogicData(e,e)
end
return s

