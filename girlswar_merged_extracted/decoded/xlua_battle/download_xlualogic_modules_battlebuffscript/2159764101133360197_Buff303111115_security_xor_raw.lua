local i=require("Modules/Battle/BattleUtil")
local e={}
local n=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
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
function e.DoBeansActionSmallSkill(t,a)
local e=t:GetBuffData()
local o=a.HeroBattleInfo:GetCurrHP()
local a=a.HeroBattleInfo.MaxHP
local o=a-o
local a=math.floor(o/a*OneMillion/e[1])
local e={
attrId=e[2],
value=math.min(e[3]*a,e[4]),
}
t.CurrHeroCtrl:AddAttrValueInCurAttack(e)
end
function e.DoBeansActionBigSkill(e,t)
local t=e:GetBuffData()
local t=e.CurrHeroCtrl
local e=e.CurrHeroCtrl.HeroId
local t=31111102
local a={
triggerSkillAtkType=ETriggerSkillAtkType.PursuitComboAttack,
isSmall=false
}
local o=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(t,e)
if o==nil then
i:AddTriggerAttackTask(e,t,a,{triggerSkillAtkType=ETriggerSkillAtkType.Normal})
end
end
return n

