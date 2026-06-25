local a=require("Modules/Battle/BattleUtil")
local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(t,e,i,h,s,n)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if n.buffTriggerTime==BuffTriggerTime.skillPlayEnd then
if i.HeroId~=t.CurrHeroCtrl.HeroId then
return
end
if a:IsNormalSkillAtkType(s.triggerSkillAtkType)==false then
return
end
if e[4]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[4]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[5]=0
end
e[3]=e[3]+1
if e[3]>=e[1]then
e[3]=0
o.CheckAddAttackTask(t)
end
end
end
function t.GetCanTrigger(e)
if e==BuffTriggerTime.skillPlayEnd then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.CheckAddAttackTask(t)
local e=t:GetBuffData()
if e[4]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[4]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[5]=0
end
if e[5]>=e[2]then
return
end
local e=t.CurrHeroCtrl.HeroId
local o=t.CurrHeroCtrl.BigSkillId
local t={
buffId=t.buffId,
costMp=false,
triggerSkillAtkType=ETriggerSkillAtkType.PursuitAttack,
}
local i=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(o,e)
if i==nil then
a:AddTriggerAttackTask(e,o,t,{triggerSkillAtkType=ETriggerSkillAtkType.Normal})
end
end
function t.HandleOnDoAction(t,e,t)
if e[5]>=e[2]then
return false
end
e[5]=e[5]+1
return true
end
return o

