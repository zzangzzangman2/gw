local o=require("Modules/Battle/BattleUtil")
local e={}
local i=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,a,t,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
local t=e.CurrHeroCtrl.HeroId
local a=a[1]
local i={
buffId=e.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.HelpMate,
defHeroIds={}
}
local e=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(a,t)
if e==nil then
o:AddTriggerAttackTask(t,a,i,{triggerSkillAtkType=ETriggerSkillAtkType.Normal})
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.anyHeroSkillBeAttack
or e==BuffTriggerTime.eachRoundStart
or e==BuffTriggerTime.eachRoundEnd)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.CheckCondition(e,a)
local o=a[3]-a[4]
if o<=0 then
return false
end
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.ourAll)
if(t==nil)then
return false
end
local e={}
for i=1,#t do
local t=t[i]
if t:CurrHPPer()<a[2]*MillionCoe and t.HeroBattleInfo.CurrHP>0 and#e<o then
table.insert(e,t.HeroId)
end
end
if#e<=0 then
return false
end
return true,e
end
function e.HandleOnDoAction(t,e,a)
local o,t=i.CheckCondition(t,e)
if o==false then
return false
end
e[4]=e[4]+#t
a.skillData.defHeroIds=t
return true
end
return i

