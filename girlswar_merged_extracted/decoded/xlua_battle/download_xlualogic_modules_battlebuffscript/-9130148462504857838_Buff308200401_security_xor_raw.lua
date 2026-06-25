local s=require("Modules/Battle/BattleUtil")
local a={}
local o=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,i,h,n,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if a.buffTriggerTime==BuffTriggerTime.eachRoundStart then
local a=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
if e[3]>0 and a>=e[2]then
local a={}
if e[29]==1 then
a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.ourAll)
else
a=ModulesInit.ProcedureNormalBattle.GetBattleHerosWithTeamId(t.teamId,BattleHeroType.fFront)
end
for i=1,#a do
local n=e[3]
local o=e[4]
local e={e[5],e[6]}
a[i]:AddBuff(t.CurrHeroCtrl,n,o,e)
end
end
elseif a.buffTriggerTime==BuffTriggerTime.allSkillAttack then
if e[16]>0 and i.IsOurHero==t.CurrHeroCtrl.IsOurHero then
e[24]=e[24]+1
local a=math.floor(e[24]/e[16])
local i=e[23]
if a>i then
e[23]=e[23]+1
local s=e[7]
local r=e[8]
local d=e[15]
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.enemyAll)
local a={}
local h=#i
for e=1,h do
local e=i[e]
table.insert(a,e.HeroId)
end
o.AddAttackTask(t,e,n,a,r,d,s)
end
end
elseif a.buffTriggerTime==BuffTriggerTime.allSmallSkilAttack then
if e[17]>0 and i.IsOurHero==t.CurrHeroCtrl.IsOurHero then
e[26]=e[26]+1
local a=math.floor(e[26]/e[17])
local i=e[25]
if a>i then
e[25]=e[25]+1
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.eMinHpPercent)
if a then
local i=e[18]
local s=e[19]
local a={a.HeroId}
o.AddAttackTask(t,e,n,a,i,s,0)
end
end
end
elseif a.buffTriggerTime==BuffTriggerTime.allNormalSkilAttack then
if e[20]>0 and i.IsOurHero==t.CurrHeroCtrl.IsOurHero then
e[28]=e[28]+1
local i=math.floor(e[28]/e[20])
local a=e[27]
if i>a then
e[27]=e[27]+1
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.enemyAll)
local a=s:FindMostBigAtk(a)
if a then
local s=e[21]
local i=e[22]
local a={a.HeroId}
o.AddAttackTask(t,e,n,a,s,i,0)
end
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundStart
or e==BuffTriggerTime.allSkillAttack
or e==BuffTriggerTime.allSmallSkilAttack
or e==BuffTriggerTime.allNormalSkilAttack)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.AddAttackTask(e,a,i,r,o,h,n)
local t=e.CurrHeroCtrl.HeroId
local a=a[1]
local e={
buffId=e.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.Normal,
defHeroIds=r,
buffPro=o,
buffFloor=h,
skillHurtRate=n
}
local o=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(a,t)
if o==nil then
s:AddTriggerAttackTask(t,a,e,i)
end
end
function a.HandleOnDoAction(e,e)
return true
end
return o

