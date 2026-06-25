local a={}
local i=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local a=e.CurrHeroCtrl.HeroBattleInfo:GetCurrFury()
if e.CurrHeroCtrl:IsFullFury()==false then
e.CurrHeroCtrl:AddFuryWithBuff(t[1])
else
local a=t[2]
local i=t[3]
local o={t[4],t[5]}
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(a,BuffRemoveType.Expire)
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,i,o)
local a=t[6]
local o=t[7]
local t={t[8],t[9]}
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(a,BuffRemoveType.Expire)
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,o,t)
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return i

