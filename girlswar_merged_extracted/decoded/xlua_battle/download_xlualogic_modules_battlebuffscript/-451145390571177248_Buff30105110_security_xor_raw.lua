local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,a,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local t=a[2]
local o=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if e.CurrHeroCtrl:CurrHPPer()<a[1]*MillionCoe then
if o==nil then
local o=a[3]
local a=0
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,t,o,a)
end
else
if o then
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(t,BuffRemoveType.Expire)
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now or e==BuffTriggerTime.hpChange)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return i

