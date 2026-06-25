local a=require("Modules/Battle/BattleUtil")
local t={}
local s=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,h,r,o,i)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if i.buffTriggerTime==BuffTriggerTime.skill3Play
or i.buffTriggerTime==BuffTriggerTime.skill2Play
or i.buffTriggerTime==BuffTriggerTime.skillPlay then
local o=o.triggerSkillAtkType
if a:IsDependAtkType(o)==false then
local s=t[1]
local i=t[4]
local h=t[5]
local o={}
for e=6,9 do
table.insert(o,t[e])
end
local n=t[3]
local t=a:GetHeroListBuffFloor(e.CurrHeroCtrl,BattleHeroType.enemyAll,i,false,t[2])
for a=1,#t do
local t=t[a].enemy
t:CheckAddBuff(s,e.CurrHeroCtrl,i,h,o,n)
end
end
elseif i.buffTriggerTime==BuffTriggerTime.afterAttacked then
local i=e.CurrHeroCtrl.HeroId
if i==h.HeroId then
local i=o.criticalOrBlock
if i==1 then
local i=o.triggerSkillAtkType
if a:IsDependAtkType(i)==false then
local i=o.reduceHpValue
local s=e.CurrHeroCtrl.HeroId
local n=1926101
local o=r.HeroId
local i={
reduceHpValue=i,
srcEnemyHeroId=o,
firstEnemyHeroId=o,
refractionHeroIdMap={},
isTriggerRefraction=true,
}
local o=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(n,s)
if o then
table.insert(o.skillData.srcEnemyDataList,i)
else
local e={
triggerSkillAtkType=ETriggerSkillAtkType.AttachAttack,
buffId=e.buffId,
hurtDataList={},
insertLevel=ETriggerSkillInsertLevel.SysAttack,
srcEnemyDataList={},
maxRefractionCount=t[12],
refractionStage=0
}
table.insert(e.srcEnemyDataList,i)
a:AddTriggerAttackTask(s,n,e,{triggerSkillAtkType=ETriggerSkillAtkType.Normal})
end
end
end
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.skill3Play
or e==BuffTriggerTime.skill2Play
or e==BuffTriggerTime.skillPlay
or e==BuffTriggerTime.afterAttacked)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.HandleOnDoAction(a,t,e)
local e=e.skillData
local o=0
local h=e.srcEnemyDataList
local i=s.GetEnemyHurtData(a,h)
e.hurtDataList=i
local n=false
for e=1,#i do
local e=i[e]
local a=e.index
local t=e.refractionHeroId
local e=h[a]
if e then
e.refractionHeroIdMap[t]=true
n=true
o=o+1
end
end
if n==true then
e.refractionStage=e.refractionStage+1
local n=t[14]
local i=t[15]
local e={}
for a=16,19 do
table.insert(e,t[a])
end
local t=t[13]*o
a.CurrHeroCtrl:AddBuff(a.CurrHeroCtrl,n,i,e,t)
end
return n
end
function t.AddAttackTaskRefraction(i,t)
local e=i:GetBuffData()
local s=t.srcEnemyDataList
local e=t.hurtDataList
local n={}
for t=1,#e do
local t=e[t]
local e=t.srcEnemyHeroId
local e=t.index
local o=t.refractionHeroId
local e=s[e]
local i=e.firstEnemyHeroId
e.reduceHpValue=t.reduceHpValue
e.srcEnemyHeroId=o
local t=true
if o~=i then
local i=92481
local e=a:GetTargetHeroCtrl(o)
if e then
local e=e.HeroBattleInfo:GetBuff(i)
if e==nil then
t=false
end
end
end
e.isTriggerRefraction=t
table.insert(n,e)
end
local e=i.CurrHeroCtrl.HeroId
local o=1926101
local i=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(o,e)
if i==nil then
t.hurtDataList={}
t.srcEnemyDataList=n
a:AddTriggerAttackTask(e,o,t,{triggerSkillAtkType=ETriggerSkillAtkType.Normal})
end
end
function t.GetEnemyHurtData(t,e)
local r=t:GetBuffData()
local s={}
for h=1,#e do
local e=e[h]
local d=e.reduceHpValue
local l=e.srcEnemyHeroId
local o=e.firstEnemyHeroId
local i=e.refractionHeroIdMap
local n=e.isTriggerRefraction
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.enemyAll)
local e={}
for a,t in ipairs(t)do
if i[t.HeroId]~=true and o~=t.HeroId then
table.insert(e,t)
end
end
if#e<=0 then
if i[o]~=true then
local t=a:GetTargetHeroCtrl(o)
table.insert(e,t)
end
end
local e=RandomTableWithSeed(e,1)
local e=e[1]
if e then
if n then
local t=math.ceil(d*r[10]*r[11]*MillionCoe)
local e={
srcEnemyHeroId=l,
reduceHpValue=t,
refractionHeroId=e.HeroId,
index=h,
isTriggerRefraction=n
}
table.insert(s,e)
end
end
end
return s
end
return s

