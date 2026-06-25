local s=require("Modules/Battle/BattleUtil")
local t={}
local h=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,o,t,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if o[2]==ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
return
end
local t={}
local i=false
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.ourAll)
for n=1,#a do
local a=a[n]
local e=a.HeroBattleInfo:GetBuff(e.buffId)
if e then
local e=e:GetBuffData()
if e[2]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[2]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
local n=a:GetFinalAtk()
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.fHollow)
for a=1,#e do
local e=e[a]
if t[e.HeroId]then
t[e.HeroId]=t[e.HeroId]+math.floor(n*o[1]*MillionCoe)
else
t[e.HeroId]=math.floor(n*o[1]*MillionCoe)
end
i=true
end
end
end
end
if i then
local o=1911102
local a=e.teamId
local e={
triggerSkillAtkType=ETriggerSkillAtkType.TeamAttack,
teamId=e.teamId,
damageMap=t,
insertLevel=ETriggerSkillInsertLevel.SysAttack,
}
s:AddTriggerTeamAttackTask(a,o,e,{triggerSkillAtkType=ETriggerSkillAtkType.Normal})
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundEnd)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return h

