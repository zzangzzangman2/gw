local i=require("Modules/Battle/BattleUtil")
local e={}
local n=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,o,t,i)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local a=o[1]
local t=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if t then
local t=t:GetFloors()
if t>0 then
if(o[3]>=RandomMgr:GetBattleRandom())then
local t=303110332
local o=1
local a={a}
i:AddBuff(e.CurrHeroCtrl,t,o,a,1)
end
end
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.attack)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.AddBuffCurseKill(e)
local t=e:GetBuffData()
local o=t[1]
local a=t[2]
local t={t[3]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,a,t,1)
end
function e.DoActionBigSkill(e)
local a=e:GetBuffData()
local e=true
local t=false
if(a[4]>=RandomMgr:GetBattleRandom())then
e=false
t=true
end
return e,t
end
function e.DoActionBigSkillWithEnemyCount(e,t)
local a=e:GetBuffData()
if#t>=a[5]then
local a=e.CurrHeroCtrl.HeroId
local e=e.CurrHeroCtrl.SmallSkillId
local t={
triggerSkillAtkType=ETriggerSkillAtkType.PursuitAttack,
defHeroIds=t
}
local o=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(e,a)
if o==nil then
local o={
triggerSkillAtkType=ETriggerSkillAtkType.Normal
}
i:AddTriggerAttackTask(a,e,t,o)
end
end
end
return n

