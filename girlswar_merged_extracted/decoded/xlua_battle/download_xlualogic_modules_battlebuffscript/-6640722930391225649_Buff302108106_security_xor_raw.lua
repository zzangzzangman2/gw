local a={}
local o=a
function a.GetCanAdd(e,e)
return true
end
function a.OnAdd(t,e)
t.CurrHeroCtrl.HeroBattleInfo:AddHPAndMaxHPPer(e[5]*MillionCoe)
end
function a.OnRemoveSelf(t,e)
t.CurrHeroCtrl.HeroBattleInfo:ReduceHPAndMaxHPPer(e[5]*MillionCoe)
end
function a.DoAction(e,t,n,s,a,i)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if i.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[3],t[4])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[6],t[7])
local a=t[22]
local a=a*t[12]*MillionCoe
o.AddFightValue(e,a)
if e.CurrHeroCtrl:IsRealFirstRowHero()then
if t[14]>0 and t[15]>0 then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[14],t[15])
end
if t[16]>0 and t[17]>0 then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[16],t[17])
end
end
elseif i.buffTriggerTime==BuffTriggerTime.afterAttacked then
local t=e.CurrHeroCtrl.HeroId
if t==n.HeroId then
elseif t==s.HeroId then
local t=a.reduceHpValue
o.OnHandleDamage(e,t)
end
elseif i.buffTriggerTime==BuffTriggerTime.buffDamageComplete then
local t=a.hurtType
local a=a.hurtValue
if t==HeroHurtType.buff or t==HeroHurtType.hpChain then
o.OnHandleDamage(e,a)
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.afterAttacked
or e==BuffTriggerTime.buffDamageComplete)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.GetRealHurtValue(t,a)
if ModulesInit.ProcedureNormalBattle.IsPVE()then
return 0
end
local e=t:GetBuffData()
local o=0
if e[18]>0 then
if t.CurrHeroCtrl:IsRealFirstRowHero()then
local t=e[18]
local i=a.HeroBattleInfo:GetTotalBuffValue(HeroAttrId.shield)
if i>0 then
t=e[19]
end
local e=a.HeroBattleInfo.MaxHP
o=e*t*MillionCoe
end
end
return o
end
function a.OnHandleDamage(e,t)
local a=e:GetBuffData()
o.AddFightValue(e,t)
local t=e.CurrHeroCtrl.HeroBattleInfo.CurrHP
local t=e.CurrHeroCtrl.HeroBattleInfo.MaxHP-t
local t=math.floor(t*a[20]*MillionCoe)
e.CurrHeroCtrl:HpHealthWithBuffImmediately(t,EBattleSrcType.Buff,e.releaseHeroId,e.buffId,true)
end
function a.AddFightValue(t,a)
if ModulesInit.ProcedureNormalBattle.isTimeLine then
return
end
local e=t:GetBuffData()
local i=e[22]
e[21]=math.min(e[21]+a,i)
e[21]=math.floor(e[21])
o.RefreshRageBar(t)
end
function a.SetFightValue(t,i)
if ModulesInit.ProcedureNormalBattle.isTimeLine then
return
end
local e=t:GetBuffData()
local a=e[22]
e[21]=math.min(i,a)
e[21]=math.max(0,e[21])
o.RefreshRageBar(t)
end
function a.RefreshRageBar(t)
local a=t:GetBuffData()
local e=t.CurrHeroCtrl
local t=o.GetFightValue(t)
local a=a[22]
e:SetRageBar(t,a)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
function a.ReduceFightValue(a,t)
if ModulesInit.ProcedureNormalBattle.isTimeLine then
return
end
t=math.floor(t)
local e=a:GetBuffData()
e[21]=e[21]-t
e[21]=math.max(0,e[21])
o.RefreshRageBar(a)
end
function a.GetFightValue(e)
local e=e:GetBuffData()
return e[21]
end
function a.CheckFightValueMax(e)
local t=o.GetFightValue(e)
local e=e:GetBuffData()
local e=e[22]
if t>=e then
return true
else
return false
end
end
return o

