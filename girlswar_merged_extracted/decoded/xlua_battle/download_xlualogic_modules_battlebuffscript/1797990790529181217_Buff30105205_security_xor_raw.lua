local a={}
local i=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if(t[1]>=RandomMgr:GetBattleRandom())then
local a=e.CurrHeroCtrl:CurrHPPer()
local o=t[3]+(t[4]-t[3])*(1-a)
local a=HeroBuffValueInfo:New()
a.buffId=e.buffId
a.attrId=t[2]
a.value=o
e.CurrHeroCtrl.HeroBattleInfo:AddTempBuffValue(a)
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.attacked)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return i

