local o=require("Modules/Battle/BattleUtil")
local e={}
local i=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,t,t)
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
function e.DoLimitAction(e,i,t,a)
local i=e:GetBuffData()
if a then
local t=o:GetSkillActData(t)
if t then
local t=a.triggerSkillAtkType or t.atkType
if o:IsPreventSkillAtkType(t)then
local t=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e.releaseHeroId)
if t then
local a=303102516
local t=t.HeroBattleInfo:GetBuff(a)
if(t)then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(a)
local e=a.DragonEyeDoLimitAction(t,e.CurrHeroCtrl.HeroId)
return true,e
end
end
end
end
end
return false
end
return i

