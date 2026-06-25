local a=require("Modules/Battle/BattleUtil")
local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,t,t,o,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local t=e.releaseHeroId
local a=a:GetTargetHeroCtrl(t)
if a then
local t=303104422
local a=a.HeroBattleInfo:GetBuff(t)
if(a)then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
t.AddAttackTask(a,o,e.CurrHeroCtrl.HeroId)
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(e.buffId,BuffRemoveType.Expire)
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.skill3Play
or e==BuffTriggerTime.skill2Play
or e==BuffTriggerTime.skillPlay)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return i

