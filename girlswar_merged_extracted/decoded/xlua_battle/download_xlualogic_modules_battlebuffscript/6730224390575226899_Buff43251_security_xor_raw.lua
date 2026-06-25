local r=require("Modules/Battle/BattleUtil")
local t={}
local d=t
function t.GetCanAdd(e,e)
return true
end
function t.OnAdd(e,t)
e.CurrHeroCtrl.isTriggerAllSkillAttackCompleteBuffForEver=true
end
function t.OnRemoveSelf(e,t)
e.CurrHeroCtrl.isTriggerAllSkillAttackCompleteBuffForEver=false
end
function t.DoAction(t,e,o,i,i,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.attacked then
local t=o.HeroId
e[14]=e[14]or{}
e[14][t]=t
elseif a.buffTriggerTime==BuffTriggerTime.allNormalSkilAttack
or a.buffTriggerTime==BuffTriggerTime.allSmallSkilAttack
or a.buffTriggerTime==BuffTriggerTime.allSkillAttack then
e[14]={}
elseif a.buffTriggerTime==BuffTriggerTime.allHeroSkillAttackComplete then
e[14]=e[14]or{}
local a=table.mapToList(e[14])
table.sort(a,function(t,e)
return t<e
end)
for o=1,#a do
local o=r:GetTargetHeroCtrl(a[o])
if o then
local a=e[1]
local e=e[2]
local i=43254
local i=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(i)
if i then
local t=i:GetBuffData()
a=t[9]
e=t[10]
end
d.AddBuffFrostMarks(t,o,e,a)
end
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.attacked
or e==BuffTriggerTime.allHeroSkillAttackComplete
or e==BuffTriggerTime.allNormalSkilAttack
or e==BuffTriggerTime.allSmallSkilAttack
or e==BuffTriggerTime.allSkillAttack)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.AddBuffFrostMarks(a,t,n,i)
local e=a:GetBuffData()
local o=43253
local o=t.HeroBattleInfo:GetBuff(o)
if o then
return
end
local o=e[3]
local s=e[4]
local h={e[5],e[6],e[7],e[8]}
if i then
t:CheckAddBuff(i,a.CurrHeroCtrl,o,s,h,n)
else
t:AddBuff(a.CurrHeroCtrl,o,s,h,n)
end
local i=t.HeroBattleInfo:GetBuff(o)
if i then
local i=i:GetFloors()
if i>=e[9]then
t.HeroBattleInfo:RemoveBuffWithId(o,BuffRemoveType.Expire)
local s=e[10]
local n=e[11]
local e={e[12],e[13]}
t:AddBuff(a.CurrHeroCtrl,s,n,e,i)
if t.HeroBattleInfo then
t.HeroBattleInfo:PlayBattleEffectWithBuffId(o)
end
local o=43258
local e=a.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if e then
local o=ModulesInit.BattleBuffMgr.GetBuffScript(o)
local e=e:GetBuffData()
local o=a.CurrHeroCtrl.HeroBattleInfo.MaxHP*e[2]*MillionCoe
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.fHollow)
local e=RandomTableWithSeed(t,e[1])
for t=1,#e do
local e=e[t]
local n=1925101
local i=a.teamId
local e=e.HeroId
local t=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndTeamId(n,i)
if t then
local t=t.skillData.hurtDataMap
if t[e]then
t[e]=t[e]+o
else
t[e]=o
end
else
local t={
triggerSkillAtkType=ETriggerSkillAtkType.TeamAttack,
teamId=a.teamId,
hurtDataMap={},
}
t.hurtDataMap[e]=o
r:AddTriggerTeamAttackTask(i,n,t,{triggerSkillAtkType=ETriggerSkillAtkType.Normal})
end
end
end
end
end
end
return d

