local s=require("Modules/Battle/BattleUtil")
local a={}
local i=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,o,s,n,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[3],t[4])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[5],t[6])
e.CurrHeroCtrl.HeroBattleInfo:SetMaxFury(t[7])
i.GainMirror(e,t[18])
elseif a.buffTriggerTime==BuffTriggerTime.eachRoundStart then
local a=302108407
local o=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if o then
local o=o:GetFloors()
e.CurrHeroCtrl:AddFuryWithBuffImmediately(t[10]*o)
local n=t[11]
local i=t[12]
local t={t[13],t[14]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,n,i,t,o)
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(a,BuffRemoveType.Expire)
end
elseif a.buffTriggerTime==BuffTriggerTime.anyHeroSkillBeAttack then
local a=n.attackType
if o.IsOurHero==e.CurrHeroCtrl.IsOurHero
and o:IsPet()==false
and a==AttackType.BigSkill
and n.criticalOrBlock==1 then
i.GainMirror(e,t[17])
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.eachRoundStart
or e==BuffTriggerTime.anyHeroSkillBeAttack)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.GainMirror(e,o)
local t=e:GetBuffData()
local n=t[15]
local r=t[16]
local s={}
local h=t[19]
local i=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(n)
local a=0
if i then
a=i:GetFloors()
end
local a=h-a
local i=o
if o>a then
i=a
local a=o-a
e.CurrHeroCtrl:AddFuryWithBuffImmediately(t[20]*a)
local o=e.CurrHeroCtrl.HeroBattleInfo.MaxHP
local t=a*o*t[21]*MillionCoe
e.CurrHeroCtrl:HpHealthWithBuffImmediately(t,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
end
if i>0 then
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,n,r,s,i)
end
end
function a.GetMirrorFloor(e)
local t=e:GetBuffData()
local t=t[15]
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
local t=0
if e then
t=e:GetFloors()
end
return t
end
function a.ReduceMirrorFloor(e,t)
local a=e:GetBuffData()
local a=a[15]
s:ReduceHeroBuffFloor(e.CurrHeroCtrl,a,t)
end
return i

