local o={}
local i=o
function o.GetCanAdd(e,e)
return true
end
function o.DoAction(e,t,o,o,o,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.eachRoundStart then
e.CurrHeroCtrl:RemoveImmuneReduceFury(e.buffId)
local a=e.CurrHeroCtrl.HeroBattleInfo.CurrFury
if a<t[1]then
local t=t[1]-a
e.CurrHeroCtrl:AddFuryWithBuff(t)
else
if t[2]>0 then
e.CurrHeroCtrl:AddImmuneReduceFury(e.buffId)
end
end
elseif a.buffTriggerTime==BuffTriggerTime.skillPlayEnd
or a.buffTriggerTime==BuffTriggerTime.skill2PlayEnd
or a.buffTriggerTime==BuffTriggerTime.skill3PlayEnd then
if a.buffTriggerTime==BuffTriggerTime.skillPlayEnd then
if t[2]>0 then
local o=t[2]
local a=t[3]
local t={t[4],t[5]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,a,t)
end
end
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(308101202,BuffRemoveType.Expire)
end
end
function o.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundStart
or e==BuffTriggerTime.skillPlayEnd
or e==BuffTriggerTime.skill2PlayEnd
or e==BuffTriggerTime.skill3PlayEnd)then
return true
end
return false
end
function o.SetLogicData(e,e)
end
return i

