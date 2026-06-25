local e=require("Modules/Battle/BattleUtil")
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
local i=t[1]
local a=t[2]
local o={t[3],t[4]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,i,a,o)
local o=t[5]
local a=t[6]
local t={t[7],t[8]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,a,t)
elseif a.buffTriggerTime==BuffTriggerTime.eachRoundStart then
local o=303112003
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if a then
local i=ModulesInit.BattleBuffMgr.GetBuffScript(o)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.selfRow)
for o=1,#e do
local e=e[o]
i.AddBuffAlert(a,e,nil,t[17])
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.AddBuffShield(a,o,i)
local t=a:GetBuffData()
local e=t[18]
local n=t[19]
local i=math.floor(a.CurrHeroCtrl.HeroBattleInfo.MaxHP*t[20]*i*MillionCoe)
local s={HeroAttrId.shield,i}
local t=o.HeroBattleInfo:GetBuff(e)
if t then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(e)
e.AddShield(t,i)
else
o:AddBuff(a.CurrHeroCtrl,e,n,s)
end
end
return h

