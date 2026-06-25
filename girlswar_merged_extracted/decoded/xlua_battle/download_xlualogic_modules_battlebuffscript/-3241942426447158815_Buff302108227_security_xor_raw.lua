local a={}
local o=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,n,s,i,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
local a=302108211
local o=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(a)
e.ClearKingValue(o,"kr_c_info_state")
end
local a=e.CurrHeroCtrl.HeroBattleInfo.MaxHP
local a=math.floor(a*t[1]*MillionCoe)
e.CurrHeroCtrl:HpHealthWithBuffImmediately(a,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[2],t[3])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[4],t[5])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[6],t[7])
elseif a.buffTriggerTime==BuffTriggerTime.attacked then
local a=e.CurrHeroCtrl.HeroId
if a==n.HeroId then
elseif a==s.HeroId then
o.OnHurt(e,t)
end
elseif a.buffTriggerTime==BuffTriggerTime.buffDamageComplete then
local a=i.hurtType
local i=i.hurtValue
if a==HeroHurtType.buff then
o.OnHurt(e,t)
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.attacked
or e==BuffTriggerTime.buffDamageComplete)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.OnHurt(e,a)
local t=e.CurrHeroCtrl.HeroBattleInfo:GetCurrHP()
local t=e.CurrHeroCtrl.HeroBattleInfo.MaxHP-t
local t=math.floor(t*a[8]*MillionCoe)
e.CurrHeroCtrl:HpHealthWithBuffImmediately(t,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
end
return o

