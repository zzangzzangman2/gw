local o=require("Modules/Battle/BattleUtil")
local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,a,a,a,i)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if i.buffTriggerTime==BuffTriggerTime.eachRoundStart then
if#t>=8 then
if ModulesInit.ProcedureNormalBattle.IsPVE()==false or t[7]==1 then
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.ourAll)
local a=0
for t=1,#i do
local e=i[t].HeroBattleInfo:GetBuff(e.buffId)
if e then
a=a+1
end
end
if a>=t[8]*t[3]*MillionCoe then
local i=t[4]
local a=e.teamId
local e={
triggerSkillAtkType=ETriggerSkillAtkType.TeamAttack,
teamId=e.teamId,
skillParam={t[5],t[6]},
}
o:AddTriggerTeamAttackTask(a,i,e,{triggerSkillAtkType=ETriggerSkillAtkType.Normal})
end
end
end
return nil
elseif i.buffTriggerTime==BuffTriggerTime.eachRoundEnd then
local a=e.CurrHeroCtrl:RealHurtWithBuff(t[1],e)
if a then
if a.hurtValue>0 then
local t=math.floor(a.hurtValue*t[2]*MillionCoe)
local a=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e.releaseHeroId)
o:AddSepsisHp(a,e.CurrHeroCtrl,t,true,true)
end
end
return{ret=true}
end
return nil
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundStart
or e==BuffTriggerTime.eachRoundEnd)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return n

