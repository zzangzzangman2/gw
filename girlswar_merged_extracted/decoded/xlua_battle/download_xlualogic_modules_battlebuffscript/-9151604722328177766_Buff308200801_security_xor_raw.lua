local n=require("Modules/Battle/BattleUtil")
local e={}
local a=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,n,n,i,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if o.buffTriggerTime==BuffTriggerTime.allHeroSkillAttackComplete then
if i.teamId~=e.CurrHeroCtrl:GetTeamId()and i.triggerSkillType==AttackType.BigSkill then
t[4]=t[4]+1
if t[4]>=t[2]then
t[4]=0
a.AddAttackTask(e,1)
end
end
elseif o.buffTriggerTime==BuffTriggerTime.teamHeroDead then
if t[3]>0 then
a.AddAttackTask(e,2)
end
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.allHeroSkillAttackComplete
or e==BuffTriggerTime.teamHeroDead)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.AddAttackTask(e,a)
local t=e:GetBuffData()
local o=e.CurrHeroCtrl.HeroId
local t=t[1]
local i={
buffId=e.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.FightBack,
triggerType=a
}
local e=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(t,o)
if e==nil or(e.skillData and e.skillData.triggerType~=a)then
n:AddTriggerAttackTask(o,t,i,{triggerSkillAtkType=ETriggerSkillAtkType.Normal})
end
end
function e.CheckDizzyCountEnough(e)
local e=e:GetBuffData()
if e[5]>=e[3]then
return false
end
return true
end
function e.AddDizzyCount(e)
local e=e:GetBuffData()
e[5]=e[5]+1
end
return a

