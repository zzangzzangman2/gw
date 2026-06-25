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
local s=t[8]
local a=t[3]
local i=303107922
local o=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(i)
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(i)
local e=e.GetImmuneDeathCount(o)
a=a+e
end
if s>=a then
return
end
if n:CheckCanTriggerFatalDmgBefore(e.CurrHeroCtrl)==false then
return
end
t[8]=t[8]+1
if t[8]>=a then
e.isExec=true
end
if e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
e.CurrHeroCtrl.HeroBattleInfo:SetHp(1,true)
end
e.CurrHeroCtrl.HeroBattleInfo:ClearAllGranBuff(false)
if e.CurrHeroCtrl and e.CurrHeroCtrl.HeroBattleInfo then
local o=303107909
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if a then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(o)
e.AddEnergyByPercent(a,t[2])
end
local o=t[4]
local a=t[5]
local i={t[6],t[7],a}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,a,i)
local a=e.CurrHeroCtrl.HeroBattleInfo.MaxHP
local t=math.floor(a*t[1]*MillionCoe)
e.CurrHeroCtrl:HpHealthWithBuffImmediately(t,EBattleSrcType.DeathImmune,e.releaseHeroId,e.buffId)
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
return h

