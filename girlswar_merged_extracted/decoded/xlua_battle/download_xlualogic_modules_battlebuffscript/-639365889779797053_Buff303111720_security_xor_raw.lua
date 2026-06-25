local a=require("Modules/Battle/BattleUtil")
local e={}
local i=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,t)
if e==nil or e.CurrHeroCtrl==nil or t==nil then
return
end
i.CheckAddDamageRes(e)
end
function e.OnRemoveSelf(e,t)
if e==nil or e.CurrHeroCtrl==nil then
return
end
e.CurrHeroCtrl:ClearDamageResData(e.buffId)
end
function e.DoAction(e,t,t,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.CheckCondHpLock(e)
local e=e:GetBuffData()
if e[4]>=e[3]then
return
end
local e=e[1]
for t=1,#e do
local e=e[t]
local t=a:GetTargetHeroCtrl(e)
if t then
local e=303111704
local t=t.HeroBattleInfo:GetBuff(e)
if t then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(e)
local e=e.CheckCondHpLock(t)
if e then
return true
end
end
end
end
return false
end
function e.OnHpLockConsume(o)
local t=o:GetBuffData()
local e=t[1]
for i=1,#e do
local e=e[i]
local e=a:GetTargetHeroCtrl(e)
if e then
local a=303111704
local e=e.HeroBattleInfo:GetBuff(a)
if e then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(a)
local i=a.CheckCondHpLock(e)
if i then
t[4]=t[4]+1
a.OnHpLockConsume(e,o.CurrHeroCtrl)
break
end
end
end
end
end
function e.OnDamageRes(o,e)
local e=o:GetBuffData()
local t=e[1]
for i=1,#t do
local t=t[i]
local t=a:GetTargetHeroCtrl(t)
if t then
local a=303111704
local t=t.HeroBattleInfo:GetBuff(a)
if t then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(a)
local i=a.CheckCondHpLock(t)
if i then
e[4]=e[4]+1
a.OnDamageRes(t,o.CurrHeroCtrl)
break
end
end
end
end
end
function e.CheckAddDamageRes(e)
local t=e:GetBuffData()
e.CurrHeroCtrl:ClearDamageResData(e.buffId)
local t={
buffId=e.buffId,
reduceHpMinHpPercent=0,
reduceHpResRate=0,
minHpLockPercent=t[2],
damageResHeroId=e.CurrHeroCtrl.HeroId,
isNeedCheck=true,
}
e.CurrHeroCtrl:AddDamageResData(t)
end
return i

