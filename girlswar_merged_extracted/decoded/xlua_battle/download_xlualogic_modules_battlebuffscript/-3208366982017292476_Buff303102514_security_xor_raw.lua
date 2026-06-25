local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,a,a,a,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local a=t[1]
local i=t[2]
if o.buffTriggerTime==BuffTriggerTime.now
or o.buffTriggerTime==BuffTriggerTime.enemyTeamHeroDead then
local t={t[3],t[4]}
e.CurrHeroCtrl:AddBuffAfterRemove(e.CurrHeroCtrl,a,i,t)
elseif o.buffTriggerTime==BuffTriggerTime.attacked then
local o=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if(o)then
local o=o:GetBuffData()
local o=o[2]-t[5]
if o<=0 then
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(a,BuffRemoveType.Expire)
else
local t={t[3],o}
e.CurrHeroCtrl:AddBuffAfterRemove(e.CurrHeroCtrl,a,i,t)
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.enemyTeamHeroDead
or e==BuffTriggerTime.attacked)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return n

