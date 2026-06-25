local n=require("Modules/Battle/BattleUtil")
local e={}
local a=e
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
function e.DoActionSmallSkill(t,o)
local e=t:GetBuffData()
local s=e[1]
local i=o.HeroBattleInfo.MaxHP*e[2]*MillionCoe
a.CheckResetSkillData(t,e)
if a.CheckCondition(t,e)then
local a=e[3]
if(a>=RandomMgr:GetBattleRandom())then
local o=t.CurrHeroCtrl.HeroId
local a=t.CurrHeroCtrl.BigSkillId
local t={
buffId=t.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.PursuitAttack,
alreadyReleaseSkillIndex=e[10],
costMp=false,
}
local e=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(a,o)
if e==nil then
n:AddTriggerAttackTask(o,a,t,{triggerSkillAtkType=ETriggerSkillAtkType.Normal})
end
end
end
local o=e[5]
local a=e[6]
local e={e[7]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,a,e)
return i,s
end
function e.SaveExSkillIndex(t,o)
local e=t:GetBuffData()
a.CheckResetSkillData(t,e)
if e[10]==0 then
e[10]=o
else
e[10]=0
end
end
function e.CheckResetSkillData(t,e)
if e[9]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[9]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[8]=0
e[10]=0
end
end
function e.CheckCondition(t,e)
local t=e[4]
if(e[8]<t)then
return true
end
return false
end
function e.HandleOnDoAction(t,e)
if a.CheckCondition(t,e)==false then
return false
end
e[8]=e[8]+1
return true
end
return a

