local a={}
local h=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,o,o,o,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
local a=t[1]
local o=t[2]
local i={t[3],t[4]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,o,i)
local o=t[5]
local a=t[6]
local t={t[7],t[8]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,a,t)
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.CheckExcuteResistFatalDamage(e,t,i)
local t=e:GetBuffData()
local a=t[11]
if t[19]>=a then
return false
end
local a=nil
local s=303111202
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.enemyAll)
local n=#o
for e=1,n do
local e=o[e]
local t=e.HeroBattleInfo:GetBuff(s)
if t then
a=e
break
end
end
if a then
e.CurrHeroCtrl:SetResistFatalDamage(true)
t[19]=t[19]+1
local o=math.floor(i*t[9]*MillionCoe)
a:RealHurtWithBuff(o,e)
local a=a.HeroBattleInfo.MaxHP
local t=math.floor(a*t[10]*MillionCoe)
e.CurrHeroCtrl:HpHealthWithBuffImmediately(t,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
return true
end
return false
end
return h

