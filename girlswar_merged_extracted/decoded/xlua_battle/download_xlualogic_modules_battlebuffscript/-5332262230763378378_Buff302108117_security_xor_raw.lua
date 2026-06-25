local i=require("Modules/Battle/BattleUtil")
local t={}
local a=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,s,n,h,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if o.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
elseif o.buffTriggerTime==BuffTriggerTime.afterAttacked then
local o=e.CurrHeroCtrl.HeroId
if o==s.HeroId then
elseif o==n.HeroId then
if a.CheckBaseCondition(e,t)then
local o=e.CurrHeroCtrl.HeroId
local a=e.CurrHeroCtrl.BigSkillId
local t={
costMp=false,
buffId=e.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.FightBack,
skillHurtRateFinal=t[4],
}
local e=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(a,o)
if e==nil then
i:AddTriggerAttackTask(o,a,t,h)
end
end
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now or e==BuffTriggerTime.afterAttacked)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.CheckCondition(e,t)
if a.CheckBaseCondition(e,t)==false then
return false
end
local t=302108111
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
local e=t.IsSuperState(e)
if e then
return true
end
end
return false
end
function t.CheckBaseCondition(t,e)
if e[5]>0 then
return true
else
return false
end
end
function t.HandleOnDoAction(t,e)
if a.CheckCondition(t,e)==false then
return false
end
e[5]=e[5]-1
return true
end
function t.ResetFightBackCount(e)
local e=e:GetBuffData()
e[5]=e[3]
end
return a

