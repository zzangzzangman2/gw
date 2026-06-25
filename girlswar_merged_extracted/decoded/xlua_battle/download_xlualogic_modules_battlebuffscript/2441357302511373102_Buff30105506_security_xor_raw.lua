local a={}
local s=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,i,i,a,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if o.buffTriggerTime==BuffTriggerTime.addBuff then
if a.buffHeroId==e.CurrHeroCtrl.HeroId then
local a=a.addBuffId
local o=3010
local i=3011
if a~=o and a~=i then
return
end
local n=t[1]
local o=t[5]
local i=t[2]
local a={t[3],t[4]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,n,i,a)
local a=t[6]
local t={t[7],t[8]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,a,t)
end
elseif o.buffTriggerTime==BuffTriggerTime.removeBuff then
local o=a[1]
local a=3010
local i=3011
if o~=a and o~=i then
return
end
local n=t[1]
local o=t[5]
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
local t=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(i)
if a==nil and t==nil then
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(n,BuffRemoveType.Expire)
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(o,BuffRemoveType.Expire)
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.addBuff or e==BuffTriggerTime.removeBuff)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return s

