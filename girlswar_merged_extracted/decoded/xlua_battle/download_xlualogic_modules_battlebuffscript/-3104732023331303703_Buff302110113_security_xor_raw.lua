local i=require("Modules/Battle/BattleUtil")
local a={}
local d=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,o,o,a,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local o=t[2]
local n=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if n==nil then
return
end
if a.buffHeroId==e.CurrHeroCtrl.HeroId then
local a=a.addBuffId
if i:IsCtlBuff(a)then
local a=e.CurrHeroCtrl.HeroBattleInfo.MaxHP
local a=math.floor(a*t[4]*MillionCoe)
e.CurrHeroCtrl:HpHealthWithBuffImmediately(a,EBattleSrcType.Buff,e.releaseHeroId,e.buffId,true)
e.CurrHeroCtrl:AddFuryWithBuff(t[5])
local r=t[6]
local h=t[7]
local n={t[8],t[9]}
local a=t[10]
local i=t[11]
local t={t[12],t[13]}
local s=e.CurrHeroCtrl.HeroBattleInfo:DispelAllGranBuff(false)
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(o,BuffRemoveType.Expire)
if#s>0 then
if e.CurrHeroCtrl and e.CurrHeroCtrl.HeroBattleInfo then
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,r,h,n)
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,i,t)
end
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.addBuff)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.DoActionSmallSkill(e,t)
local t=e:GetBuffData()
local o=t[1]
local a=t[2]
local t=t[3]
local i={}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,t,i)
return o
end
return d

