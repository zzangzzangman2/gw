local n=require("Modules/Battle/BattleUtil")
local t={}
local s=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local o=e.CurrHeroCtrl.HeroId
local a=t[1]
local i={}
local i=t[2]
local t={
defHeroIds={i},
buffId=e.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.PursuitAttack,
realhurt=t[3]
}
local e=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(a,o)
if e==nil then
n:AddTriggerAttackTask(o,a,t,{triggerSkillAtkType=ETriggerSkillAtkType.Normal,triggerSkillType=AttackType.SmallSkill})
end
return nil
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.HandleOnDoAction(t,t,e)
if e and e.skillData and e.skillData.defHeroIds then
local e=e.skillData.defHeroIds[1]
local e=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e)
if(e and e.HeroBattleInfo.CurrHP>0 and e:IsUsualState())then
return true
end
end
return false
end
return s

