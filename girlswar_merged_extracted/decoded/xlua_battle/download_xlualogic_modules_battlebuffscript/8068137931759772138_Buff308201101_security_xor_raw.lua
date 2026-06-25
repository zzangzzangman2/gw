local o=require("Modules/Battle/BattleUtil")
local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,n,h,s,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if a.buffTriggerTime==BuffTriggerTime.enemyRoundStart then
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.enemyAll)
local e=o:GetMaxFuryHeroArrByHeroArr(e,1)
local e=e[1]
if e then
t[3]=e.HeroId
else
t[3]=0
end
elseif a.buffTriggerTime==BuffTriggerTime.allNormalSkilAttack
or a.buffTriggerTime==BuffTriggerTime.allSmallSkilAttack
or a.buffTriggerTime==BuffTriggerTime.allSkillAttack then
if n.HeroId~=t[3]then
return
end
if i.CheckCondition(e,t)==false then
return false
end
local a=s.triggerSkillAtkType
if e.CurrHeroCtrl:IsOnAttack()==false
and n.IsOurHero~=e.CurrHeroCtrl.IsOurHero
and o:IsDependAtkType(a)==false then
local a=e.CurrHeroCtrl.HeroId
local i=t[1]
local t={
buffId=e.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.FightBack,
defHeroId=t[3]
}
local e=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(i,a)
if e==nil then
o:AddTriggerAttackTask(a,i,t,s)
end
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.enemyRoundStart
or e==BuffTriggerTime.allNormalSkilAttack
or e==BuffTriggerTime.allSmallSkilAttack
or e==BuffTriggerTime.allSkillAttack)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.CheckCondition(e,t)
local e=e:GetBuffData()
if e[4]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[5]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[4]=0
end
if e[4]>=e[2]then
return false
end
return true
end
function t.HandleOnDoAction(t,e,a)
if i.CheckCondition(t,e)==false then
return false
end
local t=a.skillData.defHeroId
local t=o:GetTargetHeroCtrl(t)
if t==nil then
return
end
e[4]=e[4]+1
return true
end
return i

