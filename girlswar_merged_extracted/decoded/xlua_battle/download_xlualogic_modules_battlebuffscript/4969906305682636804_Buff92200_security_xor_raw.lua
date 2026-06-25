local a={}
local o=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,o,o,o,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
if#t>=2 then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
end
elseif a.buffTriggerTime==BuffTriggerTime.skill3Play or a.buffTriggerTime==BuffTriggerTime.skill2Play or a.buffTriggerTime==BuffTriggerTime.skillPlay then
if(t[3]>=RandomMgr:GetBattleRandom())then
local o=t[4]
local a=t[5]
local t={t[6],t[7]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,a,t)
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now or e==BuffTriggerTime.skill3Play or e==BuffTriggerTime.skill2Play or e==BuffTriggerTime.skillPlay)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return o

