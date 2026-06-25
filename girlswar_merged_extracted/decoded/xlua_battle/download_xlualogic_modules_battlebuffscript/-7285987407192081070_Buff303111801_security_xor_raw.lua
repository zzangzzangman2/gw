local n=require("Modules/Battle/BattleUtil")
local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,h,s,i)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if i.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[3],t[4])
elseif i.buffTriggerTime==BuffTriggerTime.attacked then
local i=303111802
local i=a.HeroBattleInfo:GetBuff(i)
if i==nil then
o.AddBuffFlaw(e,a,t[9])
end
if n:IsNormalSkillAtkType(s.triggerSkillAtkType)==false then
local a=HeroBuffValueInfo:New()
a.buffId=e.buffId
a.attrId=t[10]
a.value=t[11]
e.CurrHeroCtrl.HeroBattleInfo:AddTempBuffValue(a)
end
elseif i.buffTriggerTime==BuffTriggerTime.evade then
e.CurrHeroCtrl:AddFuryWithBuff(t[12])
local t=math.floor(t[13]*e.CurrHeroCtrl.HeroBattleInfo.MaxHP*MillionCoe)
e.CurrHeroCtrl:HpHealthWithDirect(t,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.attacked
or e==BuffTriggerTime.evade)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.AddBuffFlaw(t,o,s)
local e=t:GetBuffData()
local n=e[6]
local i=e[7]
local e={e[8]}
local a=303111812
local a=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if(a)then
local t=a:GetBuffData()
table.insert(e,t[10])
table.insert(e,t[11])
end
o:AddBuff(t.CurrHeroCtrl,n,i,e,s)
end
function t.CheckAndRecordMustBeCritOnce(e)
local e=e:GetBuffData()
if e[22]==1 then
e[22]=0
return true
end
return false
end
function t.SetNextMustBeCritOnce(e)
local e=e:GetBuffData()
e[22]=1
end
function t.AddBuffDeadLine(a,s)
local e=a:GetBuffData()
local o=e[14]
local i=e[15]
local t={}
local n=a.CurrHeroCtrl:GetFinalAtk()
local n=math.ceil(e[18]*MillionCoe*n)
for a=16,20 do
table.insert(t,e[a])
end
table.insert(t,n)
s:AddBuff(a.CurrHeroCtrl,o,i,t)
end
function t.AddAttackTask(e,i)
local t=e:GetBuffData()
if o.CheckCondition(e,t)==false then
return false
end
local t=e.CurrHeroCtrl.HeroId
local a=31118102
local o={
buffId=e.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.PursuitAttack,
triggerCount=0,
}
local e=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(a,t)
if e==nil then
n:AddTriggerAttackTask(t,a,o,i)
else
e.skillData.triggerCount=e.skillData.triggerCount+1
end
end
function t.CheckCondition(e,t)
if e.CurrHeroCtrl:GetBuffTeamStatCount(e.buffId,"Katana")>=t[21]then
return false
end
return true
end
function t.HandleOnDoAction(e,t)
if o.CheckCondition(e,t)==false then
return false
end
e.CurrHeroCtrl:AddBuffTeamStatCount(e.buffId,1,"Katana")
return true
end
return o

