local a={}
local i=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,a,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local a=e.CurrHeroCtrl:CurrHPPer()
if a>t[1]*MillionCoe then
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t[2])
if a==nil then
local o=t[2]
local a=t[3]
local t={t[4],t[5]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,a,t)
end
else
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t[2])
if a then
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(t[2],BuffRemoveType.Expire)
end
end
return nil
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now or e==BuffTriggerTime.hpChange)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return i

