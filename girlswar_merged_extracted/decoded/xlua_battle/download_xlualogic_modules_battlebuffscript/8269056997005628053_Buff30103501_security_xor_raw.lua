local e={}
local s=e
function e.GetCanAdd(e,e)
return true
end
function e.OnRemoveSelf(e,e,e)
end
function e.DoAction(e,t,o,o,o,a)
if#t<5 or a==nil then
GameInit.LogError("Buff30103501 buffData 数量应该 大于 5")
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
if e.CurrHeroCtrl then
e.CurrHeroCtrl:CheckAddBuffValue(e.buffId,t[2],t[3])
end
end
if a.buffTriggerTime==BuffTriggerTime.eachRoundEnd then
local a=t[4]
local t=t[5]
if e.CurrHeroCtrl then
e.CurrHeroCtrl:RealHurtWithBuff(a,e,nil,t)
end
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now or e==BuffTriggerTime.eachRoundEnd)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.GetBuffValue(a,n,e)
local o=a.HeroBattleInfo:GetBuff(30103503)
local i=0
local t=1
if o then
local e=o:GetBuffData()
i=e[1]
t=e[2]
end
local o=a:GetFinalAtk()
local a=(e[4]+i)*MillionCoe
local a=math.floor(o*a)
local e={n,e[1],e[2],a,t}
return e
end
function e.DoAllHurt(e,t)
if#t<5 then
GameInit.LogError("Buff30103501 buffData 数量应该 大于 5")
return
end
local o=t[4]
local a=t[5]
if e.CurrHeroCtrl then
local i=e:GetRound()
local t=t[1]
e:SetRound(t)
e.CurrHeroCtrl:RealHurtWithBuff(o*i,e,nil,a)
end
end
return s

