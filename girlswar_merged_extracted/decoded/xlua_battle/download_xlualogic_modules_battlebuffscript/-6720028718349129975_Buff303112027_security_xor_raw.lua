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
function e.CheckAddAttackTask(t)
local e=t:GetBuffData()
if e[5]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[5]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[4]=0
end
if e[4]>=e[3]then
return
end
local e=t.CurrHeroCtrl.HeroId
local a=t.CurrHeroCtrl.BigSkillId
local o={
buffId=t.buffId,
costMp=false,
triggerSkillAtkType=ETriggerSkillAtkType.FightBack,
}
local t=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(a,e)
if t==nil then
i:AddTriggerAttackTask(e,a,o,{triggerSkillAtkType=ETriggerSkillAtkType.Normal})
end
end
function e.HandleOnDoAction(t,e,a)
if e[4]>=e[3]then
return false
end
local a=303112028
if t.CurrHeroCtrl:GetBuffTeamStatCount(a)<e[1]then
return false
end
t.CurrHeroCtrl:ResetAllBuffTeamStatCount(a)
e[4]=e[4]+1
return true
end
return n

