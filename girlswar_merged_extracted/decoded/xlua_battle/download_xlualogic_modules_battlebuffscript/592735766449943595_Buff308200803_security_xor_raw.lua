local o=require("Modules/Battle/BattleUtil")
local e={}
local n=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
e.isExec=true
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.AddAttackTask(t)
local e=t:GetBuffData()
local i=t.CurrHeroCtrl.HeroId
local a=82008391
local e={
buffId=t.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.PursuitComboAttack,
cfgArgs={e[2],e[3],e[4],e[5]},
}
local t=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(a,i)
if t==nil then
o:AddTriggerAttackTask(i,a,e,{triggerSkillAtkType=ETriggerSkillAtkType.Normal})
end
end
function e.CheckCondition(t,e)
if o:CheckHasEnemyHpPerNotEnough(t.CurrHeroCtrl,e[1])then
return true
end
return false
end
function e.HandleOnDoAction(t,e,a)
if n.CheckCondition(t,e)==false then
return false
end
return true
end
return n

