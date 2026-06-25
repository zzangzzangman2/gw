local o=require("Modules/Battle/BattleUtil")
local a={}
local i=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,i,n,n,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if a.buffTriggerTime==BuffTriggerTime.beCritical then
if e.CurrHeroCtrl.HeroBattleInfo.CurrHP>0 then
local a=t[10]
local o=t[11]
local t={t[12],t[13]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,o,t)
end
elseif a.buffTriggerTime==BuffTriggerTime.attacked then
if e.CurrHeroCtrl.HeroBattleInfo.CurrHP>0 then
local a=t[14]
local t=t[15]
local o={}
i:AddBuff(e.CurrHeroCtrl,a,t,o)
end
elseif a.buffTriggerTime==BuffTriggerTime.HeroDead then
if t[16]==1 or ModulesInit.ProcedureNormalBattle.IsPVE()==false then
local a=o:GetEnemysWithBuff(e.CurrHeroCtrl,302108715)
local t={}
for e=1,#a do
table.insert(t,a[e].HeroId)
end
if#t>0 then
local i=21087102
local a=e.teamId
local e={
triggerSkillAtkType=ETriggerSkillAtkType.TeamAttack,
teamId=e.teamId,
defHeroIds=t,
insertLevel=ETriggerSkillInsertLevel.SysAttack,
}
o:AddTriggerTeamAttackTask(a,i,e,{triggerSkillAtkType=ETriggerSkillAtkType.Normal})
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.beCritical
or e==BuffTriggerTime.attacked
or e==BuffTriggerTime.HeroDead)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.DoActionBigSkill(t,a)
local e=t:GetBuffData()
local o=e[2]
local n=e[3]
local i={e[4],e[5]}
a:AddBuff(t.CurrHeroCtrl,o,n,i)
local o=e[6]
local i=e[7]
local e={e[8],e[9]}
a:AddBuff(t.CurrHeroCtrl,o,i,e)
end
return i

