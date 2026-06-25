local n=require("Modules/Battle/BattleUtil")
local t={}
local s=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,o,a,t,i,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
local t=i.triggerSkillType
if t==AttackType.BigSkill and a.IsOurHero==e.CurrHeroCtrl.IsOurHero then
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.fMaxFinalAtk)
if t and t.HeroId==a.HeroId then
local a=e.CurrHeroCtrl.HeroId
local o=o[1]
local t={
buffId=e.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.HelpMate,
defHeroIds={t.HeroId}
}
local e=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(o,a)
if e==nil then
n:AddTriggerAttackTask(a,o,t,i)
end
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.anyHeroSkillBeAttack)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.HandleOnDoAction(t,a,e)
if t.isExec==true then
return false
end
if e and e.skillData then
local e=e.skillData.defHeroIds[1]
local e=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e)
if e then
t.isExec=true
return true
end
end
return false
end
return s

