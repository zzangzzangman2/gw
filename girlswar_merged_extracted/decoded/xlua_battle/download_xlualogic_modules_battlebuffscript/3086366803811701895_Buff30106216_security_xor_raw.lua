local n=require("Modules/Battle/BattleUtil")
local a={}
local h=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(30106215)
if a then
local i=ModulesInit.BattleBuffMgr.GetBuffScript(30106214)
local s=i.GetFuryDamageValue(e.CurrHeroCtrl)
local a=e.CurrHeroCtrl.HeroBattleInfo.MaxHP
local o=a+math.floor((t[7]*t[3]*MillionCoe)*a)
if s>=o then
if n:CheckCanTriggerFatalDmgBefore(e.CurrHeroCtrl)==false then
return
end
i.ReduceFuryDamageValue(e.CurrHeroCtrl,o)
local a=math.floor(a*t[1]*MillionCoe)
e.CurrHeroCtrl:HpHealthWithBuffImmediately(a,EBattleSrcType.DeathImmune,e.releaseHeroId,e.buffId,true)
e.CurrHeroCtrl:AddFuryWithBuff(t[2])
t[7]=t[7]+1
elseif t[8]<t[6]then
if n:CheckCanTriggerFatalDmgBefore(e.CurrHeroCtrl)==false then
return
end
local a=math.floor(a*t[4]*MillionCoe)
e.CurrHeroCtrl:HpHealthWithBuffImmediately(a,EBattleSrcType.DeathImmune,e.releaseHeroId,e.buffId,true)
e.CurrHeroCtrl:AddFuryWithBuff(t[5])
t[8]=t[8]+1
end
else
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.fatalDmgBefore)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.CheckRageInFatalDmg(e)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return false
end
local t=e:GetBuffData()
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(30106215)
if a then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(30106214)
local a=a.GetFuryDamageValue(e.CurrHeroCtrl)
local e=e.CurrHeroCtrl.HeroBattleInfo.MaxHP
local e=e+math.floor((t[7]*t[3]*MillionCoe)*e)
if a>=e then
return true,"enoughFuryDamage"
elseif t[8]<t[6]then
return true,"zhinian"
end
end
return false
end
return h

