local o=require("Modules/Battle/BattleUtil")
local t={}
local n=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local a=43291
local o=o:GetHeroBuffFloor(e.CurrHeroCtrl,a)
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(a,BuffRemoveType.Expire)
if o>0 then
local a=t[1]
local i=t[2]
local t={t[3]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,i,t,o)
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return n

