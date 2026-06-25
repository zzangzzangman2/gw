local o=require("Modules/Battle/BattleUtil")
local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,a,i,i,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t.buffHeroId==e.CurrHeroCtrl.HeroId then
local t=t.addBuffId
if o:IsCtlBuff(t)then
local t=302107511
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
t.GainSnowMan(e,a[1])
end
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.addBuff)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return i

