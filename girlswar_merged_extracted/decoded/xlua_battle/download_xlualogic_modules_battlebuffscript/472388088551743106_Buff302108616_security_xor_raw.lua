local a={}
local i=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,o,o,o,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.skillPlay then
local o=t[1]
local a=t[2]
local t={t[3],t[4],t[5],t[6]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,a,t)
elseif a.buffTriggerTime==BuffTriggerTime.skill3PlayEnd then
local t=t[1]
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(t,BuffRemoveType.Expire)
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.skillPlay
or e==BuffTriggerTime.skill3PlayEnd)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return i

