local t={}
local n=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if#t>=2 then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
end
e.isExec=true
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.DoActionSmallSkill(e,o)
local t=e:GetBuffData()
local a=o.HeroBattleInfo.CurrHP
local a=a*t[1]*MillionCoe
local i=e.CurrHeroCtrl:GetFinalAtk()
a=math.min(a,i*t[2]*MillionCoe)
local a=o:RealHurtWithBuff(a,e)
local a=a.hurtValue
e.CurrHeroCtrl:HpHealthWithBuffImmediately(a,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
local a=303110501
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if e then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(a)
a.AddSwordMaster(e,t[3])
end
end
return n

