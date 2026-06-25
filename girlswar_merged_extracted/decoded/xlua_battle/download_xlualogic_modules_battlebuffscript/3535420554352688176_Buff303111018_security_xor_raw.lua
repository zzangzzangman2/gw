local i=require("Modules/Battle/BattleUtil")
local a={}
local o=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t[3]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
t[3]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
t[2]=0
end
local a=t[1]
if(t[2]>=a)then
return nil
end
t[2]=t[2]+1
local a=e.CurrHeroCtrl.HeroId
local t=e.CurrHeroCtrl.BigSkillId
local o={
costMp=false,
buffId=e.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.FightBack,
}
local e=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(t,a)
if e==nil then
i:AddTriggerAttackTask(a,t,o,{triggerSkillAtkType=ETriggerSkillAtkType.Normal,triggerSkillType=AttackType.BigSkill})
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.teamHeroDead
or e==BuffTriggerTime.enemyTeamHeroDead
or e==BuffTriggerTime.teamHeroFakeDead
or e==BuffTriggerTime.enemyTeamHeroFakeDead)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return o

