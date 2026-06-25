local n=require("Modules/Battle/BattleUtil")
local e={}
local t=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,o,i,s,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a==nil or a.hurtValue==nil then
GameInit.LogError("Buff302104103 triggerData 不能为空")
return
end
local i=e.CurrHeroCtrl.HeroId
if i==s.HeroId and t.CheckCondition(e,o)then
local h=a.reduceHpValueBeforeReduceLimit
local r=a.triggerSkillAtkType
if(s:GetHPPerByHp(h)>o[1]*MillionCoe)then
local s=o[2]
local e=t.GetSkillData(e,o)
local t=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(s,i)
if t==nil then
n:AddTriggerAttackTask(i,s,e,a)
end
end
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.afterAttacked)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.CheckCondition(t,e)
local a=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(302104108)
if a then
return true
else
local t=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(302104105)
if t then
local t=t:GetBuffData()
return e[4]<t[2]
else
return e[4]<e[3]
end
end
end
function e.GetSkillData(e,t)
local e={
buffId=e.buffId,
}
return e
end
function e.HandleOnDoAction(a,e)
if t.CheckCondition(a,e)==false then
return false
end
local o=t.GetSkillData(a,e)
e[4]=e[4]+1
t.CheckAndClearFightBackCount(a)
return true,o
end
function e.HandleSkillChangeData(t)
local e=ModulesInit.ProcedureNormalBattle.GetEnemyCount(t)
local a=t.HeroBattleInfo:GetBuff(302104105)
local i=t.HeroBattleInfo:GetBuff(302104108)
if a or i then
local o=t.HeroBattleInfo:GetBuff(302104103)
local o=o:GetBuffData()
o[5]=0
local s=o[2]
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(SkillChangeType.Sequence,s,nil,n:Handler(e,function(n)
local e=0
if i then
local t=ModulesInit.ProcedureNormalBattle.GetEnemyCount(t)
if t>0 and t<n then
e=e+1
end
end
if a then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(302104105)
if t.CheckHasEnemyLessHp(a)then
e=e+1
end
end
if e>0 then
if e>1 then
o[5]=1
end
return true
end
return false
end))
end
return nil
end
function e.CheckAndClearFightBackCount(e)
local e=e:GetBuffData()
if e[5]>0 then
e[5]=0
return true
end
return false
end
return t

