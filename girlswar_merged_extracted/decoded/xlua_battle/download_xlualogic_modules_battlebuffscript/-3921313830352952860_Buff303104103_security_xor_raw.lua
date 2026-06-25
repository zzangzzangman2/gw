local s=require("Modules/Battle/BattleUtil")
local e={}
local t=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,o,i,n,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a==nil or a.hurtValue==nil then
GameInit.LogError("Buff303104103 triggerData 不能为空")
return
end
local i=e.CurrHeroCtrl.HeroId
if i==n.HeroId and t.CheckCondition(e,o)then
local h=a.reduceHpValueBeforeReduceLimit
local r=a.triggerSkillAtkType
if(n:GetHPPerByHp(h)>o[1]*MillionCoe)then
local n=o[2]
local e=t.GetSkillData(e,o)
local t=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(n,i)
if t==nil then
s:AddTriggerAttackTask(i,n,e,a)
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
local t=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(303104105)
if t then
local t=t:GetBuffData()
return e[4]<t[2]
else
return e[4]<e[3]
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
local t=t.GetSkillData(a,e)
e[4]=e[4]+1
e[5]={}
return true,t
end
function e.HandleSkillChangeData(e,h)
local r=ModulesInit.ProcedureNormalBattle.GetEnemyCount(e)
local o=e.HeroBattleInfo:GetBuff(303104105)
local n=e.HeroBattleInfo:GetBuff(303104108)
if o or n then
local i=e.HeroBattleInfo:GetBuff(303104103)
local a=i:GetBuffData()
a[5]={h}
local h=a[2]
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(SkillChangeType.Sequence,h,nil,s:Handler(r,function(s)
if n then
local e=ModulesInit.ProcedureNormalBattle.GetEnemyCount(e)
if e>0 and e<s then
table.insert(a[5],{triggerType="countByFire3"})
end
end
if t.CheckFightBackCountLimit(i)==false then
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(303104105)
if e.CheckHasEnemyLessHp(o)then
table.insert(a[5],{triggerType="countByFire1"})
end
end
end
if t.CheckAndClearFightBackCount(i)then
return true
end
return false
end))
end
return nil
end
function e.CheckAndClearFightBackCount(e)
local e=e:GetBuffData()
if#e[5]>0 then
local t=table.remove(e[5],1)
e[9]=t
if t.triggerType=="countByFire1"then
e[6]=e[6]+1
end
e[10]=e[10]+1
return true
end
return false
end
function e.GetAndClearFightBackParam(e)
local e=e:GetBuffData()
local t=e[9]
e[9]={}
return t
end
function e.CheckFightBackCountLimit(t)
local e=t:GetBuffData()
if e[7]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound or e[8]~=ModulesInit.ProcedureNormalBattle.CurrBattleSmallRound then
e[7]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[8]=ModulesInit.ProcedureNormalBattle.CurrBattleSmallRound
e[6]=0
end
local t=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(303104105)
if t then
local t=t:GetBuffData()
if e[6]<t[5]then
return false
end
end
return true
end
return t

