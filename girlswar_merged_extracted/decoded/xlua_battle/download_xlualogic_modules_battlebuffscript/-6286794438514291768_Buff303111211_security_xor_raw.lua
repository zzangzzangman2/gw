local n=require("Modules/Battle/BattleUtil")
local t={}
local s=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,a,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local a=t[11]
if t[12]>=a then
return
end
local a={}
for e=1,10 do
table.insert(a,t[e])
end
local o=303111216
local o=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if(o)then
local e=o:GetBuffData()
for t=12,18 do
table.insert(a,e[t])
end
else
for e=12,18 do
table.insert(a,0)
end
end
local e=e.CurrHeroCtrl.HeroId
local o=31112102
local a={
triggerSkillAtkType=ETriggerSkillAtkType.PursuitAttack,
skillParam=a,
insertLevel=ETriggerSkillInsertLevel.SysAttack,
}
local i=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(o,e)
if i==nil then
t[12]=t[12]+1
n:AddTriggerAttackTask(e,o,a,{triggerSkillAtkType=ETriggerSkillAtkType.Normal})
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.enemyTeamHeroDead
or e==BuffTriggerTime.enemyTeamHeroFakeDead
or e==BuffTriggerTime.enemyTeamHeroFatalDmgBefore
or e==BuffTriggerTime.enemyTeamHeroLockHp)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return s

