local i=require("Modules/Battle/BattleUtil")
local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,s,a,n,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if o.buffTriggerTime==BuffTriggerTime.now then
if#t>=2 then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
end
elseif o.buffTriggerTime==BuffTriggerTime.afterAttacked then
if e.CurrHeroCtrl.HeroBattleInfo.CurrHP>0 then
if e.CurrHeroCtrl.HeroId==a.HeroId then
local o=n.reduceHpValue
local a=a:GetHPPerByHp(o)
local o=math.floor(a*OneMillion/t[3]*t[4])
local a=i:GetTargetHeroCtrl(e.releaseHeroId)
if a then
local e=303111606
local a=a.HeroBattleInfo:GetBuff(e)
if a then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(e)
e.AddFuryByHorse(a,o,t[5])
end
end
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.afterAttacked)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return n

