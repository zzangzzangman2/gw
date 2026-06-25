local l=require("Modules/Battle/BattleUtil")
local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,o,o,o,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.isTriggerAllSkillAttackCompleteBuffForEver=true
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[3],t[4])
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.eRandom,t[5])
if(t)then
for a,t in ipairs(t)do
n.AddBuffFragileAlliance(e,t)
end
end
elseif a.buffTriggerTime==BuffTriggerTime.eachRoundStart then
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.enemyAll)
if#a>t[15]then
local o=303112001
local i,o=l:GetHeroNoBuffByType(e.CurrHeroCtrl,BattleHeroType.enemyAll,o)
if#o<t[13]then
local t=RandomTableWithSeed(a,t[14])
for a=1,#t do
n.AddBuffFragileAlliance(e,t[a])
end
end
end
elseif a.buffTriggerTime==BuffTriggerTime.smallRoundStartTeamAttack then
if t[22]==1 then
t[22]=0
n.AddAttackTask(e)
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.eachRoundStart
or e==BuffTriggerTime.smallRoundStartTeamAttack)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.AddBuffFragileAlliance(a,n)
local e=a:GetBuffData()
local i=e[6]
local o=e[7]
local t={}
for a=8,12 do
table.insert(t,e[a])
end
n:AddBuff(a.CurrHeroCtrl,i,o,t)
end
function a.AddBuffAlert(t,s,d,a)
local o=t:GetBuffData()
if a<1 then
return
end
local r=o[16]
local h=o[17]
local e={}
local i=o[21]
local n=303112013
local n=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(n)
if n then
local t=n:GetBuffData()
for a=9,11 do
table.insert(e,t[a])
end
i=t[12]
else
for t=18,20 do
table.insert(e,o[t])
end
end
local l=303112022
local o=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(l)
if(o)then
local a=o:GetBuffData()
for t=21,28 do
table.insert(e,a[t])
end
else
for t=21,28 do
table.insert(e,0)
end
end
local n=303112027
local n=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(n)
if(n)then
local t=n:GetBuffData()
table.insert(e,t[1])
i=t[2]
else
table.insert(e,0)
end
local n=false
if d then
n=s:CheckAddBuff(d,t.CurrHeroCtrl,r,h,e,a,i)
else
n=s:AddBuffWithMaxFloor(t.CurrHeroCtrl,r,h,e,a,i)
end
if n then
if(o)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(l)
e.AddBuffShield(o,s,a)
end
end
end
function a.AddAttackTask(e)
local t=e:GetBuffData()
local t=e.CurrHeroCtrl.HeroId
local e=e.CurrHeroCtrl.BigSkillId
local a={
costMp=false,
triggerSkillAtkType=ETriggerSkillAtkType.FightBack,
}
local o=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(e,t)
if o==nil then
l:AddTriggerAttackTask(t,e,a,{triggerSkillAtkType=ETriggerSkillAtkType.Normal})
end
end
return n

