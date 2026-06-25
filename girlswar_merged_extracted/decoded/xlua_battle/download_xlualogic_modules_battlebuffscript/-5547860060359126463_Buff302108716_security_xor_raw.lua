local i=require("Modules/Battle/BattleUtil")
local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(t,e,n,n,i,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.enemyTeamHeroDead then
if e[2]==2 then
e[2]=1
end
elseif a.buffTriggerTime==BuffTriggerTime.enemyTeamHeroFatalDmgBefore then
if e[2]>0 then
local e=e[3]
o.AddPursuitAttack(t,e)
end
elseif a.buffTriggerTime==BuffTriggerTime.skillPlay then
e[2]=2
e[3]=i.triggerSkillAtkType
elseif a.buffTriggerTime==BuffTriggerTime.skillPlayEnd then
if e[2]==1 then
local a=302108705
local e=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(a)
t.AddBuffBloodFury(e)
end
end
e[2]=0
e[3]=0
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.enemyTeamHeroDead
or e==BuffTriggerTime.enemyTeamHeroFatalDmgBefore
or e==BuffTriggerTime.skillPlay
or e==BuffTriggerTime.skillPlayEnd)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.AddPursuitAttack(e,n)
local a=e:GetBuffData()
if t.CheckCondition(e,a)==false then
return
end
local t=e:GetBuffData()
local a=e.CurrHeroCtrl.HeroId
local t=e.CurrHeroCtrl.BigSkillId
if t>0 then
local e={
costMp=false,
buffId=e.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.PursuitComboAttack,
insertLevel=ETriggerSkillInsertLevel.ComboAttack,
}
local o=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(t,a)
if o==nil then
local o={
triggerSkillAtkType=n
}
i:AddTriggerAttackTask(a,t,e,o)
end
end
end
function t.CheckCondition(a,e)
if e[5]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[5]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[4]=0
end
local t=e[1]
local o=302108711
local a=a.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if a then
local e=a:GetBuffData()
t=e[1]
end
if(e[4]>=t)then
return false
end
return true
end
function t.HandleOnDoAction(t,e)
if o.CheckCondition(t,e)==false then
return false
end
e[4]=e[4]+1
return true
end
return o

